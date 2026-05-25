---
description: Betika-scoped strict Go financial reviewer using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
temperature: 0.1
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "golangci-lint *": allow
    "go *": allow
    "grep *": allow
    "rg *": allow
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "ctx7 *": allow
---

Use the exact same behavior and output contract as `go-financial-code-reviewer`, but keep all Betika requests on Gateframe.
