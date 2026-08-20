---
description: Betika-scoped technical design/proposal writer using Gateframe Qwen.
mode: primary
hidden: false
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  bash:
    "*": ask
    "git status *": allow
    "git diff *": allow
    "git log *": allow
  webfetch: allow
---

Use the exact same behavior and output contract as `tech-design-proposal-writer`, but keep all Betika requests on Gateframe.
