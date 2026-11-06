# Query and write safety

## Read-only query template

```bash
TOKEN="$(gcloud auth print-access-token --project=oneplatform-prj-dev-1 \
  --impersonate-service-account=wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com)" &&
PGPASSWORD="$TOKEN" psql -X -w -v ON_ERROR_STOP=1 -P pager=off -x \
  "host=127.0.0.1 port=15432 sslmode=disable connect_timeout=10 user=wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam dbname=postgres" \
  -c "BEGIN READ ONLY; SET LOCAL statement_timeout='15s'; <SQL>; COMMIT;"
```

- `PGOPTIONS=-c default_transaction_read_only=on` is **rejected** by AlloyDB here; use `BEGIN READ ONLY` in the SQL.
- `-x` gives expanded output (good for single rows); drop it for tables.
- Use `-f file.sql` for long queries; keep `BEGIN READ ONLY` / `COMMIT` inside the file.
- For plans: `EXPLAIN (ANALYZE, BUFFERS) ...` inside the read-only transaction. ANALYZE executes the
  query, so only use it on SELECTs.
- Prefer aggregates and `LIMIT`; outbox has ~millions of rows and is partitioned monthly.

## Writes (only with explicit user approval)

Rules: one transaction, short `lock_timeout`, guarded `WHERE` (full primary key + expected current
state), and an assertion that exactly the expected number of rows changed, else roll back.

Pattern (used to un-quarantine one outbox row; PK is `(created_at_utc, id)`):

```sql
BEGIN;
SET LOCAL lock_timeout = '3s';
SET LOCAL statement_timeout = '15s';
DO $$
DECLARE n int;
BEGIN
  UPDATE outbox
     SET quarantine_at_utc = NULL, next_attempt_at_utc = NULL, attempt_count = 0, last_error = NULL
   WHERE created_at_utc = '<ts>' AND id = <id>
     AND published_at_utc IS NULL AND quarantine_at_utc IS NOT NULL;
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 1 THEN RAISE EXCEPTION 'expected 1 row, got %', n; END IF;  -- aborts the transaction
END $$;
COMMIT;
```

Run with `psql -v ON_ERROR_STOP=1` so the exception stops the script before `COMMIT`.

Before writing: run the same `WHERE` as a read-only SELECT and show the user the rows.
After writing: re-read the rows and report the new state.

Never run DDL, bulk UPDATE/DELETE, or anything touching `journal_*`/`account*` balances here.
