---
description: Betika-scoped full correctness, design, and maintainability review using Gateframe. Use for general/deep code reviews in Betika projects.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: deny
  task: deny
  bash:
    "*": ask
    "git diff*": allow
    "grep *": allow
    "rg *": allow
    "ls *": allow
---

Explicitly read `~/.config/opencode/agents/code-reviewer.md`,
`~/.config/opencode/prompts/code-review.md`, and
`~/.config/opencode/playbooks/code-review.md`. Use the base reviewer's behavioral
instructions and output contract, but keep the model configured here: all requests
must use Gateframe. Agent prompts are not automatically inherited.
