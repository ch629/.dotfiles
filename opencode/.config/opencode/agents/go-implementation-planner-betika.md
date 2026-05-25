---
description: Betika-scoped Go implementation planner using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/gemini-3.5-flash
temperature: 0.1
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "git status *": allow
    "git diff *": allow
    "git log *": allow
---

Use the exact same behavior and output contract as `go-implementation-planner`, but keep all Betika requests on Gateframe.
