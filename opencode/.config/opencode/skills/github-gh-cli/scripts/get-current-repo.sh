#!/usr/bin/env bash
set -euo pipefail

gh repo view --json nameWithOwner | jq -r '.nameWithOwner'
