# Outbox diagnostics (wallet-core / wallet-posting-engine)

Schema (`internal/storage/database/outbox.go` in betikake/wallet-core): `id, journal_header_id,
journal_header_created_at_utc, user_id, topic, key, payload, created_at_utc, published_at_utc,
attempt_count, next_attempt_at_utc, last_attempt_at_utc, quarantine_at_utc, last_error`.
PK `(created_at_utc, id)`. Range-partitioned monthly by `created_at_utc` (`outbox_YYYY_MM`).
Key index: `ix_outbox_unpublished_user_head_covering (user_id, created_at_utc, id) INCLUDE
(next_attempt_at_utc, quarantine_at_utc) WHERE published_at_utc IS NULL`.

Worker semantics: per user, rows publish strictly in `(created_at_utc, id)` order. A user's
**head** row that is quarantined or not yet due blocks all of that user's later rows.

Run each inside the read-only template from [query and write safety](query-and-write-safety.md).

## Backlog health

```sql
SELECT count(*) FILTER (WHERE published_at_utc IS NULL)                              AS unpublished,
       count(*) FILTER (WHERE published_at_utc IS NULL AND quarantine_at_utc IS NOT NULL) AS quarantined,
       count(*) FILTER (WHERE published_at_utc > now() - interval '1 hour')          AS published_1h,
       min(created_at_utc) FILTER (WHERE published_at_utc IS NULL)                   AS oldest_unpublished,
       max(published_at_utc)                                                         AS last_publish
  FROM outbox;
```

## Quarantined rows and why

```sql
SELECT id, user_id, created_at_utc, quarantine_at_utc, attempt_count, last_error
  FROM outbox
 WHERE published_at_utc IS NULL AND quarantine_at_utc IS NOT NULL
 ORDER BY created_at_utc LIMIT 20;
```

## Is a user blocked?

```sql
SELECT count(*) FILTER (WHERE created_at_utc > '<head ts>')  AS later_unpublished,
       min(created_at_utc), max(created_at_utc)
  FROM outbox WHERE user_id = '<user>' AND published_at_utc IS NULL;
```

## Users with most pending rows

```sql
SELECT user_id, count(*) FROM outbox WHERE published_at_utc IS NULL
 GROUP BY user_id ORDER BY count(*) DESC LIMIT 10;
```

## Partitions (watch the upper bound; inserts fail past the last partition)

```sql
SELECT c.relname, pg_get_expr(c.relpartbound, c.oid)
  FROM pg_inherits i JOIN pg_class c ON c.oid = i.inhrelid
 WHERE i.inhparent = 'outbox'::regclass ORDER BY 1;
```

## Who is connected

```sql
SELECT usename, state, count(*) FROM pg_stat_activity GROUP BY 1, 2 ORDER BY 3 DESC;
```

History: Oct 2026 incident — one user's quarantined head (unknown `business_event_type`) filled
the old 2048-row candidate window and stalled all publishing for ~2 weeks. Fixed by PR #274
(bounded per-user head walk). Un-quarantine a row only after the deployed worker can handle it.
