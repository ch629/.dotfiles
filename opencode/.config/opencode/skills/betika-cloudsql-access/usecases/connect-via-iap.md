# Connect via IAP SOCKS and cloud-sql-proxy

Use this guide once the target (instance connection name, database, service
account) is confirmed with [discover-target.md](discover-target.md).

## How the path works

```
psql -> 127.0.0.1:LOCAL_PORT (cloud-sql-proxy --psc)
     -> socks5 127.0.0.1:SOCKS_PORT (gcloud compute ssh -D, IAP)
     -> hcp-agent-<env>-mig VM inside the VPC
     -> Cloud SQL PSC endpoint
```

- The wallet Cloud SQL instances are PSC-only (no public IP), so a laptop
  cannot reach them directly. The hcp-agent VM gives a network path; IAP gives
  access to the VM without VPN.
- Authentication is IAM: the Postgres user is the service account email
  without `.gserviceaccount.com`, and the password is a short-lived access
  token minted by impersonating that service account.
- Nothing is created in the cluster. This is why it is preferred over
  `platform-argocd-apps/bin/connect_to_db.sh`, which applies a debug pod and
  also fails in dev because dev apps have no proxy sidecar.

## Prerequisites

- IAM (granted by the platform team, never self-granted):
  `roles/iap.tunnelResourceAccessor` on the environment project and
  Service Account Token Creator on the database service account.
- `gcloud` authenticated (`gcloud auth list`), `psql`, `nc`, and
  `cloud-sql-proxy` v2 on `PATH`. Install the proxy from
  [troubleshooting.md](troubleshooting.md#install-cloud-sql-proxy) if missing.

## Steps

The examples below use the preferred runtime account; impersonation of that
account was denied for the recorded dev caller. See the
[verified dev ledger account](discover-target.md#verified-dev-ledger-impersonation)
for the migration account whose token preflight succeeded. Use it only after
explicit approval for its higher privileges and the intended read-only session;
substitute its full email in `--service-account`. Do not treat token success as
proof that the database connection works.

1. State the target and get user approval before starting anything:
   environment, project, instance, database, service account, purpose.
   Prod needs its own explicit approval and the read replica where one exists.
2. Dry run the helper to confirm parsing and derived values:

   ```bash
   ~/.config/opencode/skills/betika-cloudsql-access/scripts/cloudsql-psql.sh \
     --instance oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1 \
     --service-account wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com \
     --dry-run
   ```

3. Run a single query non-interactively (preferred for agents, because the
   script tears everything down when psql exits):

   ```bash
   ~/.config/opencode/skills/betika-cloudsql-access/scripts/cloudsql-psql.sh \
     --instance oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1 \
     --service-account wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com \
     -- -c 'SHOW default_transaction_read_only' -c 'SELECT current_user, now()'
   ```

   Use `-- -f /path/query.sql` for longer queries. Without psql args the user
   gets an interactive session (only useful when the user runs it themselves).
4. Prod example (only after explicit approval; prefer the replica):

   ```bash
   .../cloudsql-psql.sh --allow-prod \
     --instance oneplatform-prj-prod-1:europe-west1:db-wallet-ledger-zm-prod-postgresql-euwe1-replica-rr-01 \
     --service-account <runtime-sa>@oneplatform-prj-prod-1.iam.gserviceaccount.com \
     -- -f query.sql
   ```

5. Verify cleanup after each run:

   ```bash
   pgrep -fl 'cloud-sql-proxy|tunnel-through-iap' || echo "clean"
   ```

## What the helper adds over the Confluence script

- Looks up the VM zone and passes `--project`/`--zone` explicitly.
- Refuses prod without `--allow-prod`; refuses AlloyDB URIs.
- Checks ports are free and waits for each hop to listen instead of `sleep 4`.
- Binds everything to `127.0.0.1` and uses non-default ports (15432, 19000)
  to avoid clashing with a local Postgres.
- Sets `PGOPTIONS` with `default_transaction_read_only=on`,
  `statement_timeout` and `idle_in_transaction_session_timeout`.
- Never echoes the token and unsets it on exit; a trap kills the proxy and
  the IAP tunnel on exit, error or interrupt.

## Manual fallback

If the helper cannot be used, follow the same order by hand: look up the VM
and zone, start `gcloud compute ssh VM --project P --zone Z --tunnel-through-iap -- -D 127.0.0.1:19000 -N -q &`,
start `ALL_PROXY=socks5://127.0.0.1:19000 cloud-sql-proxy INSTANCE --psc --address 127.0.0.1 --port 15432 &`,
then connect with `PGPASSWORD` from
`gcloud auth print-access-token --impersonate-service-account=SA` and the
`PGOPTIONS` above. Kill both background processes when done.

## Alternative: proxy-side IAM login

`cloud-sql-proxy --impersonate-service-account SA --auto-iam-authn` logs in
for you (no `PGPASSWORD`). The impersonated SA then also needs Cloud SQL Client
and Service Usage Consumer. Use it only if the token-as-password path fails
and the IAM is already in place.
