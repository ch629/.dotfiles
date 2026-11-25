---
name: betika-cloudsql-access
description: Connects to Betika Cloud SQL for PostgreSQL databases (wallet ledger, wallet payments and other platform services in dev, stage or prod) from a development machine through the IAP tunnel and Cloud SQL Auth Proxy, for read-only diagnostics with psql. Use when users ask things like "connect to the dev database", "query journal_header in dev", "check the payment row in Cloud SQL", "open a psql session to the ledger DB", "use the alloydb skill", or mention connect_to_db.sh, cloud-sql-proxy, the IAP tunnel or private database access. Not for local testcontainer or docker Postgres work.
---

# Betika Cloud SQL Access

Use this skill to reach a private Betika Cloud SQL for PostgreSQL instance from a
development machine and run read-only diagnostic queries.

It replaces the older AlloyDB access workflow. Wallet services moved from AlloyDB
to Cloud SQL for PostgreSQL; the connection method is the same idea with a
different proxy binary and instance name format.

## What this skill does

- Finds the instance, database and IAM database user for a service.
- Opens an IAP SOCKS tunnel through an `hcp-agent` VM and runs `cloud-sql-proxy --psc` over it.
- Authenticates as a service account by impersonation (IAM database authentication, no stored password).
- Runs `psql` with read-only session guards, then tears everything down.

## When not to use

- Local Postgres, testcontainers or benchmarks: use `postgres-bench-lab` or the repo's own test harness.
- Schema or migration authoring: use the repo's migration skill.
- Any write, DDL, backfill or data repair on a shared database: out of scope. Stop and
  offer the user a manual switch to `infrastructure-operator`.

## Source of truth

- Confluence: "How to: Cluster/Database private access from development machine",
  space `OP`, page ID `3800793092`. Read it with
  `acli confluence page view --id 3800793092 --body-format storage --json`.
  The page has a Cloud SQL section and a legacy AlloyDB section.
- Deployed targets: rendered manifests in `betikake/platform-argocd-apps`
  (`apps/<namespace>/<app>/manifests/<country>/<env>.yaml`).

If this skill and the Confluence page disagree, say so and prefer the page.

## Safety rules

These apply on every use. They are stricter than the Confluence page on purpose.

1. **Ask before connecting.** Starting the tunnel, impersonating a service account and
   querying a shared database each touch live systems. State the target (project,
   instance, service account, database) and get the user's go-ahead first. A request
   to "check" or "look at" something is not approval to connect to prod.
2. **Prod needs its own explicit approval**, naming prod. Prefer the read replica.
3. **Read-only only.** Use the helper script, which sets `default_transaction_read_only=on`
   and timeouts. Never turn those guards off. Never run `INSERT`, `UPDATE`, `DELETE`,
   DDL, `COPY ... FROM`, `VACUUM`, or functions with side effects.
4. **The guard is not a security boundary.** Runtime service accounts can write. The
   session setting stops accidents, not intent. Treat every statement as if it could
   write, and read it before running it.
5. **Never grant yourself access.** Missing IAM roles are a blocker to report, not
   something to fix with `gcloud ... add-iam-policy-binding`.
6. **Never print tokens.** Do not echo `PGPASSWORD`, access tokens or `gcloud auth
   print-access-token` output. Do not run the script with `bash -x`.
7. **Minimise data.** Select named columns, filter on indexed keys, add `LIMIT`. Do not
   dump whole JSONB documents or customer identifiers into the conversation when a
   narrower projection answers the question.
8. **Clean up.** No tunnel or proxy process may be left running. Verify after the session.
9. **Do not use `bin/connect_to_db.sh` yourself.** It creates a debug pod in the cluster,
   which is a live change. See [troubleshooting](usecases/troubleshooting.md).

## Workflow

1. Identify the target: [discover the target](usecases/discover-target.md).
For the remembered dev posting-engine account, read the
[verified impersonation finding](usecases/discover-target.md#verified-dev-ledger-impersonation):
`wallet-posting-engine-db-zm` can mint a token for the recorded caller, but a
successful database session is not yet verified. It is a privileged migration
account and requires explicit approval, not an automatic fallback.
2. Check prerequisites and connect: [connect through IAP](usecases/connect-via-iap.md).
3. Query: [read-only queries](usecases/read-only-queries.md).
4. If anything fails: [troubleshooting](usecases/troubleshooting.md).

Selection guidance:

- User names a service or table but not an instance -> discover the target first.
- Target is known and approved -> connect through IAP.
- Connected and need query patterns or wallet diagnostics -> read-only queries.
- Permission errors, timeouts, port conflicts, or questions about `connect_to_db.sh`
  or AlloyDB -> troubleshooting.

## Helper script

[`scripts/cloudsql-psql.sh`](scripts/cloudsql-psql.sh) runs the whole flow and cleans
up on exit. Always start with `--dry-run`, which makes no network calls:

```sh
~/.config/opencode/skills/betika-cloudsql-access/scripts/cloudsql-psql.sh \
  --instance oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1 \
  --service-account wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com \
  --dry-run
```

Run `cloudsql-psql.sh --help` for options. Do not rely on flags from memory.

## Output expectations

After a session, report:

- Target: project, instance, database, service account used, primary or replica.
- Each statement run (or a faithful summary) and the result, with row counts.
- Confirmation that the session was read-only and that the tunnel and proxy are stopped.
- Anything that failed or was skipped, and what is still unknown.

Separate what the query showed from what you infer from it.

## Quality checklist

- Target confirmed with the user before any connection.
- Prod approval is explicit and names prod.
- `SHOW default_transaction_read_only` returned `on` at the start of the session.
- No token or password appeared in output.
- No background `cloud-sql-proxy` or IAP `ssh` process remains.
