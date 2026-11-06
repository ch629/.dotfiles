---
name: alloydb-dev-access
description: Betika-only access to the ZM dev AlloyDB wallet ledger database (oneplatform-prj-dev-1) through an IAP SOCKS tunnel and alloydb-auth-proxy. Use ONLY when Betika context is established and the user requests its database connection, outbox diagnostics, or an explicitly approved repair. Do not use for generic AlloyDB questions, other organizations, or unrelated projects. If the organization or target database is unclear, confirm before using these instructions.
---

# Betika AlloyDB dev access (wallet ledger, ZM dev)

> **Betika-specific.** Every value below (project, bastion, instance, service account, schema)
> belongs to Betika's internal ZM dev environment. This is not a generic AlloyDB guide.
> Do not reuse it for other organizations, projects or environments.

Use this skill to reach Betika's **dev** wallet ledger AlloyDB instance from a developer machine
and query it safely. Source guide: `~/Downloads/Database private access from development machine-161026-095816.pdf`.

## Fixed facts

| Thing | Value |
|---|---|
| GCP project | `oneplatform-prj-dev-1` |
| Bastion VM (IAP) | `hcp-agent-dev-2sfg`, zone `europe-west1-c` |
| AlloyDB instance URI | `projects/oneplatform-prj-dev-1/locations/europe-west1/clusters/db-wallet-ledger-zm-dev-alloydb-cluster-euwe1/instances/db-wallet-ledger-zm-dev-alloydb-instance-euwe1` |
| Local SOCKS port (IAP) | `127.0.0.1:9000` |
| Local proxy port | `127.0.0.1:15432` |
| Database | `postgres` (tables in `public`, e.g. `public.outbox`) |
| Impersonatable SA | `wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com` |
| DB IAM user | `wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam` |
| Tools | `gcloud`, `alloydb-auth-proxy` (`~/.local/bin`, v1.17.0), `psql` |

Only the posting-engine SA can be impersonated (outbox-worker, wallet-service,
posting-engine-zm and eod-snapshot SAs are denied). It has SELECT and UPDATE on `outbox`.

## Workflow

1. Check what is already running (`lsof -nP -iTCP:9000 -iTCP:15432 -sTCP:LISTEN`).
2. Start whatever is missing: [Connect](usecases/connect.md).
3. Query read-only by default: [Query and write safety](usecases/query-and-write-safety.md).
4. If anything fails: [Troubleshooting](usecases/troubleshooting.md).
5. Outbox-specific diagnostics: [Outbox diagnostics](usecases/outbox-diagnostics.md).

Selection guidance:
- Nothing listening / fresh machine -> connect.
- Need to run SQL -> query and write safety.
- Auth, timeout, permission or "connection refused" errors -> troubleshooting.
- Outbox backlog, quarantine, publishing questions -> outbox diagnostics.

## Safety rules

- **Dev only.** Never point this at stage/prod without the user explicitly asking and a new instance URI.
- Every query runs in `BEGIN READ ONLY` with a `statement_timeout` unless the user explicitly asked for a write.
- Writes need explicit user approval, a guarded `WHERE`, `lock_timeout`, and an exactly-N-rows assertion inside one transaction.
- Never print or log the access token. Pass it only via `PGPASSWORD`.
- Report: what was queried, row counts, and timestamps (UTC). Say when results are from dev, not prod.
