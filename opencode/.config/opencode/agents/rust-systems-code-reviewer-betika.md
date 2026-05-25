---
description: Betika-scoped Rust systems reviewer using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
temperature: 0.1
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "cargo *": allow
    "rustc *": allow
    "clippy *": allow
    "grep *": allow
    "rg *": allow
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "ctx7 *": allow
---

Use the exact same behavior and output contract as `rust-systems-code-reviewer`, but keep all Betika requests on Gateframe.
