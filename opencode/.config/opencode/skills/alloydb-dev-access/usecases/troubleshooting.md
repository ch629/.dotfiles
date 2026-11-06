# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| psql hangs / `connect_timeout` expires | IAP tunnel on 9000 died | `lsof -nP -iTCP:9000 -sTCP:LISTEN`; restart tunnel ([connect](connect.md) step 1) |
| proxy log: dial / socks errors | same as above | restart tunnel; restart proxy if it exited |
| `connection refused` on 15432 | proxy not running | start proxy (connect step 2), check its log |
| `password authentication failed` | token expired or wrong user string | refetch token; user must be `...@oneplatform-prj-dev-1.iam` (no `.gserviceaccount.com`) |
| `gcloud ... impersonate` permission denied | SA not impersonatable by you | only `wallet-posting-engine-db-zm` works; other wallet SAs are denied |
| `unrecognized configuration parameter` / PGOPTIONS rejected | AlloyDB disallows `default_transaction_read_only` via options | use `BEGIN READ ONLY` in SQL |
| `permission denied for table X` | SA lacks grant | report it; don't hunt for other credentials |
| `pg_stat_activity.query` shows `<insufficient privilege>` | other roles' sessions are hidden | expected; use counts by `usename`/`state` only |
| gcloud ssh asks for passphrase / key | first-time IAP ssh key setup | let the user run it interactively once |
| `gcloud auth` errors | user login expired | ask user to run `gcloud auth login` |

Logs: `/tmp/alloydb-wallet-dev-iap.log`, `/tmp/alloydb-wallet-dev-proxy.log` (or wherever they were started).
