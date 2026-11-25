# Troubleshooting

Use this guide when the helper script or a manual connection fails. Check each
hop in order: tools, IAP tunnel, proxy, authentication, session.

## CLI discovery

Flags drift between versions. When a command fails on arguments, check help
top-down before retrying: `gcloud compute ssh --help`,
`cloud-sql-proxy --help`, `psql --help`, then retry with corrected flags.

## Install cloud-sql-proxy

macOS Apple Silicon (check the latest version on the GitHub releases page of
`GoogleCloudPlatform/cloud-sql-proxy` and verify its SHA-256 there):

```bash
VERSION=v2.28.0
curl -fsSL -o cloud-sql-proxy \
  "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/${VERSION}/cloud-sql-proxy.darwin.arm64"
shasum -a 256 cloud-sql-proxy   # compare with the published checksum
chmod +x cloud-sql-proxy && mv cloud-sql-proxy /opt/homebrew/bin/
cloud-sql-proxy --version
```

Alternatives: `brew install cloud-sql-proxy` or
`go install github.com/GoogleCloudPlatform/cloud-sql-proxy/v2@latest`.
Installing local tools needs the user's agreement.

## Symptoms

| Symptom | Likely cause | Check / fix |
|---|---|---|
| `no instances found in hcp-agent-<env>-mig` | Wrong project or MIG name | `gcloud compute instance-groups managed list --project P --filter='name~hcp-agent'`; pass `--mig` |
| `gcloud compute ssh` permission denied / 4033 | Missing `roles/iap.tunnelResourceAccessor` or OS Login access | Ask the platform team; do not self-grant |
| ssh prompts for a key passphrase or host key | First run on this VM | Run once interactively, or let the user run it |
| `IAP SOCKS tunnel exited before listening` | ssh failed or port taken | Re-run the ssh command by hand without `-q` to see the error; try another `--socks-port` |
| proxy `dial tcp ... i/o timeout` | SOCKS not used or PSC endpoint unreachable | Confirm `ALL_PROXY` and `--psc`; confirm the instance has PSC (`gcloud sql instances describe NAME --project P --format='value(settings.ipConfiguration.pscConfig.pscEnabled)'`) |
| proxy `403` / `cloudsql.instances.get` denied | Your ADC lacks Cloud SQL Client | `gcloud auth application-default login`; ask for the role |
| `token request failed` / `iam.serviceAccounts.getAccessToken` denied | Caller cannot impersonate that specific SA | Check the [verified dev ledger finding](discover-target.md#verified-dev-ledger-impersonation); runtime-account denial does not prove all dev access is unavailable. Do not try arbitrary accounts or self-grant roles. The known migration account requires explicit approval because it is more privileged. Otherwise ask the platform team. |
| `password authentication failed for user` | Wrong DB user, expired token, or SA not a DB user | User must be SA email minus `.gserviceaccount.com`; `gcloud sql users list --instance NAME --project P`; tokens last about 1 hour, re-run |
| `cannot execute ... in a read-only transaction` | The guard is working | Writes are out of scope; offer the `infrastructure-operator` switch |
| `canceling statement due to statement timeout` | Query too heavy | Narrow the filter or add a time range; raise `--statement-timeout` only with reason |
| port already in use | Local Postgres or a leftover run | `lsof -nP -iTCP:15432 -sTCP:LISTEN`; pass another `--local-port` |
| proxy warns about `monitoring.metricWriter` | Built-in metrics export | Harmless; newer proxies accept `--enable-builtin-metrics=false` |

## Leftover processes

```bash
pgrep -fl 'cloud-sql-proxy|tunnel-through-iap'
```

Only kill processes this workflow started, and say so in the report.

## connect_to_db.sh

`platform-argocd-apps/bin/connect_to_db.sh` copies the app's proxy sidecar
into a new debug pod in the app namespace, then port-forwards to it. It:

- Creates a pod in a shared cluster, which is a live change; do not run it
  from this workflow.
- Needs a reachable GKE API (VPN or the IAP proxy on port 8888 from the
  Confluence page).
- Fails in dev for the wallet apps, which use the in-process Go connector and
  have no `cloud-sql-proxy` sidecar.

It is fine for the user to run it themselves in stage or prod.

## AlloyDB

Older docs and some app manifests mention AlloyDB. The wallet apps now use
Cloud SQL for PostgreSQL. For a genuine AlloyDB target, the Confluence page
shows the same IAP SOCKS pattern with `alloydb-auth-proxy`; this skill's
script does not support it.
