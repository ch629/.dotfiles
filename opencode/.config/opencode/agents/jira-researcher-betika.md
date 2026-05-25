---
description: Betika-scoped Jira researcher using Gateframe.
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
    "jq *": allow
---

Use the exact same behavior and output contract as `jira-researcher`, but keep all Betika requests on Gateframe.
