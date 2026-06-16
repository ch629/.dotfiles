---
description: Betika-scoped parallel Jira orchestrator using Gateframe.
mode: subagent
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: deny
  task:
    "*": deny
    jira-researcher-betika: allow
    go-implementation-planner-betika: allow
    developer-betika: allow
    jira-ticket-validator-betika: allow
    go-financial-code-reviewer-betika: allow
    general: allow
    explore: allow
  bash:
    "*": ask
    "git worktree add *": allow
    "git worktree list*": allow
    "git branch --show-current": allow
    "git branch --list *": allow
    "git status *": allow
    "git diff *": allow
    "git log *": allow
---

Use the exact same behavior and output contract as `jira-parallel-work-orchestrator`, but delegate only to `*-betika` agents for specialized work.
