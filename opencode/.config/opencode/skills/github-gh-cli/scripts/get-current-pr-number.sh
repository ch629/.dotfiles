#!/usr/bin/env bash
set -euo pipefail

gh pr view --json number | jq -r '.number'
