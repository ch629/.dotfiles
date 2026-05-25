---
description: Betika-scoped Jira ticket validator using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
temperature: 0.1
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "acli jira *": allow
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "go test *": allow
    "go vet *": allow
    "golangci-lint *": allow
---

Use the exact same behavior and output contract as `jira-ticket-validator`, but keep all Betika requests on Gateframe.
