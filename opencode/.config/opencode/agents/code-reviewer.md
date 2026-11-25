---
description: Full correctness, design, and maintainability review of the diff against the acceptance criteria. Read-only; reviews the worktree directly.
mode: subagent
hidden: true
model: openai/gpt-6.2-sol
temperature: 0.1
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
  external_directory:
    "~/.config/opencode/prompts/**": allow
    "~/.config/opencode/playbooks/**": allow
---

Explicitly read `~/.config/opencode/prompts/code-review.md` and use its exact prompt, inputs, review framework, and output contract. This is the standard/deep code-review variant: it binds the shared prompt to the model set in this file's frontmatter and carries no behavior of its own.
