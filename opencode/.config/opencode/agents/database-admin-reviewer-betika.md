---
description: Betika-scoped database reviewer using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: deny
  task: deny
  bash:
    "*": ask
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "grep *": allow
    "rg *": allow
---

Use the exact same behavior and output contract as `database-admin-reviewer`, but keep all Betika requests on Gateframe.

Explicitly read `~/.config/opencode/agents/database-admin-reviewer.md` and
`~/.config/opencode/playbooks/code-review.md`; follow their behavioral instructions,
not the base agent's model configuration. Agent prompts are not automatically inherited.
