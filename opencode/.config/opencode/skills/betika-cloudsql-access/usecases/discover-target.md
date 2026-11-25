# Discover the target

Goal: know the project, instance connection name, database name and service account
before connecting. All commands here are read-only.

## What you need

| Item | Format | Example |
|---|---|---|
| Instance connection name | `<project>:<region>:<instance>` | `oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1` |
| Service account | `<name>@<project>.iam.gserviceaccount.com` | `wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com` |
| Database user | service account email without `.gserviceaccount.com` | `wallet-posting-engine-zm@oneplatform-prj-dev-1.iam` |
| Database name | from the service DSN | `default` |

## Known wallet targets

Recorded 2026-11-19 from `platform-argocd-apps` `origin/main` (`455249e4`). These
drift. Re-check before relying on them.

| Service | Env | Project | Instance |
|---|---|---|---|
| Ledger (`wallet-posting-engine`) | dev | `oneplatform-prj-dev-1` | `db-wallet-ledger-zm-dev-postgresql-euwe1` |
| Ledger | stage | `oneplatform-prj-stage-1` | `db-wallet-ledger-zm-stage-postgresql-euwe1` |
| Ledger | prod | `oneplatform-prj-prod-1` | `db-wallet-ledger-zm-prod-postgresql-euwe1` |
| Payments (`wallet-payment-api`) | dev | `oneplatform-prj-dev-1` | `db-wallet-payment-api-zm-dev-postgresql-euwe1` |
| Payments | stage | `oneplatform-prj-stage-1` | `db-wallet-payment-api-zm-stage-postgresql-euwe1` |
| Payments | prod | `oneplatform-prj-prod-1` | `db-wallet-payment-api-zm-prod-postgresql-euwe1` |

- Region is `europe-west1`. Database name is `default`.
- Stage and prod have a read replica: append `-replica-rr-01` to the instance name.
  Dev has no replica.
- The dev ledger instance is PostgreSQL 18, private (no public IP), reachable by
  Private Service Connect, with IAM database authentication on.

Service accounts on the dev ledger instance (`gcloud sql users list`, 2026-11-19):
`wallet-posting-engine-zm`, `wallet-posting-engine-db-zm` (migrations),
`wallet-service-zm`, `wallet-outbox-worker-zm`, `wallet-posting-consumer-zm`,
`wallet-eod-snapshot-zm`, all `@oneplatform-prj-dev-1.iam`. There is no human IAM
database user, so access is by impersonating one of these.

The payments instances' user lists were not checked. List them before connecting.

## Choosing the service account

- Prefer a dedicated read-only account; none is currently known.
- Otherwise prefer the service's runtime account, if the caller is authorised to
impersonate it. A runtime account is not necessarily read-only.
- A migration account (`-db-`) is more privileged and can run migrations/DDL.
Do not select it automatically after another account is denied. Explain the
privilege difference and obtain explicit approval for that exact account and
read-only purpose. Never disable the session guards or change IAM.

## Verified dev ledger impersonation

Recorded 2026-11-19 for caller `charlie.howes@betika.com`:

| Item | Verified value / result |
|---|---|
| Project | `oneplatform-prj-dev-1` |
| Instance | `oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1` |
| Database | `default` |
| Migration service account | `wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com` |
| Postgres IAM username | `wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam` |
| Token impersonation | Succeeded for this exact migration account with user approval; token discarded |
| Runtime accounts | `wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com` and `wallet-payment-api-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com` both denied `iam.serviceAccounts.getAccessToken` |

**This verifies token minting only, not a successful database connection.** No
Postgres session was opened with the migration account. These findings are
caller-, account- and environment-specific; do not assume access to stage/prod,
the payments migration account, or other service accounts.

After approval for this exact account, a token-only preflight can fail early
before opening the IAP tunnel. Discard stdout; never print or persist the token:

```bash
gcloud auth print-access-token \
--project=oneplatform-prj-dev-1 \
--impersonate-service-account=wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com \
> /dev/null
```

For a later approved read-only session, pass that migration account explicitly
as `--service-account` to the helper; it derives the IAM username above. Token-only
approval does not authorise opening a database session. Re-check the target and
obtain connection approval first.

## Look it up from the manifests

Use a current checkout of `platform-argocd-apps`. Inspect `origin/main`, not a stale
local branch.

```sh
git -C ~/Projects/betika/platform-argocd-apps fetch origin main
git -C ~/Projects/betika/platform-argocd-apps show \
  origin/main:apps/<namespace>/<app>/manifests/<country>/<env>.yaml
```

In the rendered manifest look for:

- `DB_DSN` and `DB_READ_DSNS` in the ConfigMap: `host`, `user`, `dbname`, `port`.
- A `cloud-sql-proxy` sidecar's arguments, which carry the instance connection name
  and `?port=` per instance (stage and prod).
- The ServiceAccount annotation `iam.gke.io/gcp-service-account`.

Dev wallet services have no proxy sidecar. Their `DB_DSN` uses the instance
connection name directly as `host`. Read the instance from there.

Do not paste whole manifests into the conversation. Project the fields you need.

## Confirm with gcloud

```sh
gcloud sql instances describe <instance> --project <project> \
  --format='yaml(connectionName,databaseVersion,state,settings.ipConfiguration.ipv4Enabled,settings.ipConfiguration.pscConfig.pscEnabled)'

gcloud sql users list --instance <instance> --project <project> \
  --format='table(name,type)'
```

Check `gcloud sql instances describe --help` if a field path is rejected.

Confirm that:

- the instance exists and is `RUNNABLE`;
- the service account appears as `CLOUD_IAM_SERVICE_ACCOUNT`;
- the project matches the environment the user asked for.

If the user's words and the target disagree (they said "dev" but the instance is in
the stage project), stop and ask.

## AlloyDB targets

Wallet services no longer use AlloyDB. If a manifest still shows an
`alloydb-auth-proxy` sidecar or an instance URI starting with `projects/`, this
skill's script does not apply. Follow the AlloyDB section of the Confluence page and
tell the user the target is not Cloud SQL.
