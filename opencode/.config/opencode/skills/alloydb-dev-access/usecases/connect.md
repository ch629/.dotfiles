# Connect to dev AlloyDB

Two background processes are needed: an IAP SOCKS tunnel, then the AlloyDB auth proxy routed through it.
Both are long-running; start them in the background and log to files.

## 0. Preconditions

```bash
gcloud auth list                       # an active @betika user account
gcloud config get-value project        # any; commands pass --project explicitly
command -v alloydb-auth-proxy psql
```

If `gcloud` auth is stale: ask the user to run `gcloud auth login` (interactive; don't do it for them).

## 1. IAP SOCKS tunnel (port 9000)

```bash
LOG=/tmp/alloydb-wallet-dev-iap.log
nohup gcloud compute ssh hcp-agent-dev-2sfg \
  --project=oneplatform-prj-dev-1 --zone=europe-west1-c \
  --tunnel-through-iap --quiet \
  -- -D 127.0.0.1:9000 -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 \
  >"$LOG" 2>&1 &
sleep 5; lsof -nP -iTCP:9000 -sTCP:LISTEN
```

This tunnel **dies silently** after idle periods or network changes. If queries suddenly hang or
the proxy logs dial errors, restart this step first. The proxy usually survives.

## 2. AlloyDB auth proxy (port 15432)

```bash
LOG=/tmp/alloydb-wallet-dev-proxy.log
ALL_PROXY=socks5://127.0.0.1:9000 nohup alloydb-auth-proxy \
  --address=127.0.0.1 --port=15432 --psc --run-connection-test \
  projects/oneplatform-prj-dev-1/locations/europe-west1/clusters/db-wallet-ledger-zm-dev-alloydb-cluster-euwe1/instances/db-wallet-ledger-zm-dev-alloydb-instance-euwe1 \
  >"$LOG" 2>&1 &
sleep 5; tail -n 5 "$LOG"   # expect "ready for new connections" and a passing connection test
```

`--psc` is required (private service connect). `ALL_PROXY` sends it through the SOCKS tunnel.

## 3. Smoke test

```bash
TOKEN="$(gcloud auth print-access-token --project=oneplatform-prj-dev-1 \
  --impersonate-service-account=wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com)" &&
PGPASSWORD="$TOKEN" psql -X -w -v ON_ERROR_STOP=1 -P pager=off \
  "host=127.0.0.1 port=15432 sslmode=disable connect_timeout=10 user=wallet-posting-engine-db-zm@oneplatform-prj-dev-1.iam dbname=postgres" \
  -c "BEGIN READ ONLY; SELECT current_user, now(); COMMIT;"
```

`sslmode=disable` is correct: the proxy terminates TLS. The token is the password (IAM auth) and
expires after ~1 hour; fetch a fresh one per command.

## Optional: kubectl to the dev GKE cluster

Context `gke_oneplatform-prj-dev-1_europe-west1_oneplatform-zm-dev-gke-shared-euw1-1` needs
`proxy-url: http://127.0.0.1:8888` and a tunnel:

```bash
gcloud compute ssh hcp-agent-dev-2sfg --project=oneplatform-prj-dev-1 --zone=europe-west1-c \
  --tunnel-through-iap -- -L 8888:localhost:8888 -N -q
```

(Untested end-to-end; follow the PDF guide if it differs.)

## Stopping

```bash
pkill -f 'alloydb-auth-proxy.*15432'; pkill -f 'hcp-agent-dev-2sfg.*-D 127.0.0.1:9000'
```
