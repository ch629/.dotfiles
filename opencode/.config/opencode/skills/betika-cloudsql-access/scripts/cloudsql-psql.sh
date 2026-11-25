#!/usr/bin/env bash
# Open a read-only psql session to a private (PSC) Cloud SQL for PostgreSQL
# instance through an IAP SOCKS tunnel on the environment's hcp-agent VM.
#
# Based on Confluence OP page 3800793092 ("How to: Cluster/Database private
# access from development machine"), with target checks, a read-only session
# guard, token hygiene and guaranteed cleanup added.
#
# The read-only guard (default_transaction_read_only=on) is a safety net, not a
# security boundary: a session can turn it off. Use it for diagnostics only.

set -euo pipefail

readonly DEFAULT_REGION_MIG="europe-west1"

instance=""
service_account=""
database="default"
local_port="15432"
socks_port="19000"
mig=""
statement_timeout="60s"
allow_prod="false"
dry_run="false"
psql_args=()

usage() {
  cat <<'EOF'
Usage: cloudsql-psql.sh --instance PROJECT:REGION:INSTANCE --service-account SA_EMAIL [options] [-- psql args]

Opens a read-only psql session to a PSC-only Cloud SQL PostgreSQL instance via
an IAP SOCKS tunnel (hcp-agent-<env>-mig) and cloud-sql-proxy --psc, logging in
with an IAM access token for the impersonated database service account.

Required:
  --instance NAME          Cloud SQL connection name, e.g.
                           oneplatform-prj-dev-1:europe-west1:db-wallet-ledger-zm-dev-postgresql-euwe1
  --service-account EMAIL  Database IAM service account to impersonate, e.g.
                           wallet-posting-engine-zm@oneplatform-prj-dev-1.iam.gserviceaccount.com

Options:
  --database NAME          Database name (default: default)
  --local-port PORT        Local cloud-sql-proxy port (default: 15432)
  --socks-port PORT        Local IAP SOCKS port (default: 19000)
  --mig NAME               hcp-agent managed instance group (default: derived from project)
  --statement-timeout DUR  Postgres statement_timeout (default: 60s)
  --allow-prod             Required to target a prod project
  --dry-run                Print the resolved plan and exit; starts nothing
  -h, --help               Show this help

Anything after "--" is passed to psql, e.g. -- -c 'SELECT 1' or -- -f query.sql.
Without psql args an interactive session is opened.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

log() {
  printf '==> %s\n' "$*" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --instance) instance="${2:-}"; shift 2 ;;
    --service-account) service_account="${2:-}"; shift 2 ;;
    --database) database="${2:-}"; shift 2 ;;
    --local-port) local_port="${2:-}"; shift 2 ;;
    --socks-port) socks_port="${2:-}"; shift 2 ;;
    --mig) mig="${2:-}"; shift 2 ;;
    --statement-timeout) statement_timeout="${2:-}"; shift 2 ;;
    --allow-prod) allow_prod="true"; shift ;;
    --dry-run) dry_run="true"; shift ;;
    -h | --help) usage; exit 0 ;;
    --) shift; psql_args=("$@"); break ;;
    *) die "unknown argument: $1 (see --help)" ;;
  esac
done

[[ -n "$instance" ]] || die "--instance is required"
[[ -n "$service_account" ]] || die "--service-account is required"

IFS=':' read -r project region instance_name <<<"$instance"
[[ -n "$project" && -n "$region" && -n "$instance_name" ]] ||
  die "--instance must be PROJECT:REGION:INSTANCE, got: $instance"
[[ "$instance" != projects/* ]] ||
  die "AlloyDB URIs are not supported; this script targets Cloud SQL only"
[[ "$service_account" == *.gserviceaccount.com ]] ||
  die "--service-account must be a full service account email"
[[ "$local_port" =~ ^[0-9]+$ && "$socks_port" =~ ^[0-9]+$ ]] ||
  die "ports must be numeric"

if [[ "$project" =~ ^oneplatform-prj-(dev|stage|prod)-1$ ]]; then
  env_name="${BASH_REMATCH[1]}"
else
  [[ -n "$mig" ]] || die "cannot derive environment from project $project; pass --mig"
  env_name="unknown"
fi

if [[ "$env_name" == "prod" && "$allow_prod" != "true" ]]; then
  die "target is prod ($project); re-run with --allow-prod only after explicit approval"
fi

mig="${mig:-hcp-agent-${env_name}-mig}"
db_user="${service_account%.gserviceaccount.com}"

for tool in gcloud cloud-sql-proxy psql nc; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    if [[ "$dry_run" == "true" ]]; then
      log "warning: $tool not found on PATH"
    else
      die "$tool not found on PATH (see usecases/troubleshooting.md)"
    fi
  fi
done

port_in_use() {
  nc -z 127.0.0.1 "$1" >/dev/null 2>&1
}

wait_for_port() {
  local port="$1" pid="$2" label="$3" attempt
  for attempt in $(seq 1 30); do
    if port_in_use "$port"; then
      return 0
    fi
    if ! kill -0 "$pid" >/dev/null 2>&1; then
      die "$label exited before listening on port $port"
    fi
    sleep 1
    : "$attempt"
  done
  die "$label did not listen on port $port within 30s"
}

cat >&2 <<EOF
Target
  environment:      $env_name
  project:          $project
  instance:         $instance
  database:         $database
  db user:          $db_user
  impersonating:    $service_account
  hcp-agent MIG:    $mig ($DEFAULT_REGION_MIG)
  local SOCKS port: $socks_port
  local DB port:    $local_port
  session guard:    default_transaction_read_only=on, statement_timeout=$statement_timeout
EOF

if [[ "$dry_run" == "true" ]]; then
  log "dry run: nothing started"
  exit 0
fi

port_in_use "$socks_port" && die "SOCKS port $socks_port already in use; pass --socks-port"
port_in_use "$local_port" && die "local port $local_port already in use; pass --local-port"

ssh_pid=""
proxy_pid=""
# shellcheck disable=SC2329 # invoked via trap
cleanup() {
  local status=$?
  unset PGPASSWORD
  for pid in "$proxy_pid" "$ssh_pid"; do
    if [[ -n "$pid" ]] && kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" >/dev/null 2>&1 || true
      wait "$pid" 2>/dev/null || true
    fi
  done
  log "tunnel and proxy stopped"
  exit "$status"
}
trap cleanup EXIT INT TERM

log "looking up an hcp-agent VM"
vm_name="$(gcloud compute instance-groups managed list-instances "$mig" \
  --project "$project" --region "$DEFAULT_REGION_MIG" --limit 1 \
  --format 'value(instance.basename())')"
[[ -n "$vm_name" ]] || die "no instances found in $mig ($project)"
vm_zone="$(gcloud compute instances list --project "$project" \
  --filter "name=($vm_name)" --format 'value(zone.basename())')"
[[ -n "$vm_zone" ]] || die "could not resolve zone for $vm_name"
log "using $vm_name in $vm_zone"

log "starting IAP SOCKS tunnel on 127.0.0.1:$socks_port"
gcloud compute ssh "$vm_name" --project "$project" --zone "$vm_zone" \
  --tunnel-through-iap -- \
  -D "127.0.0.1:$socks_port" -N -q -o ExitOnForwardFailure=yes &
ssh_pid=$!
wait_for_port "$socks_port" "$ssh_pid" "IAP SOCKS tunnel"

log "starting cloud-sql-proxy (PSC) on 127.0.0.1:$local_port"
ALL_PROXY="socks5://127.0.0.1:$socks_port" cloud-sql-proxy "$instance" \
  --psc --address 127.0.0.1 --port "$local_port" --quiet &
proxy_pid=$!
wait_for_port "$local_port" "$proxy_pid" "cloud-sql-proxy"

log "requesting short-lived IAM token for $service_account"
PGPASSWORD="$(gcloud auth print-access-token --impersonate-service-account="$service_account" 2>/dev/null)" ||
  die "token request failed; check roles/iam.serviceAccountTokenCreator on $service_account"
export PGPASSWORD

export PGOPTIONS="-c default_transaction_read_only=on -c statement_timeout=$statement_timeout -c idle_in_transaction_session_timeout=300s"
export PGAPPNAME="cloudsql-psql-readonly"

log "connecting (read-only session guard enabled)"
set +e
psql "host=127.0.0.1 port=$local_port sslmode=disable user=$db_user dbname=$database" \
  -v ON_ERROR_STOP=1 ${psql_args[@]+"${psql_args[@]}"}
psql_status=$?
set -e
exit "$psql_status"
