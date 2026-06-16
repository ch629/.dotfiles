---
description: Betika-scoped Rust systems implementation planner using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: ask
  bash:
    "*": ask
    "cargo *": allow
    "rustc *": allow
    "rg *": allow
    "grep *": allow
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "ctx7 *": allow
---

Use the exact same behavior and output contract as `rust-systems-implementation-planner`, but keep all Betika requests on Gateframe.
