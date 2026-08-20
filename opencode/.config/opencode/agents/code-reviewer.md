---
description: Full correctness, design, and maintainability review of the diff against the acceptance criteria. Read-only; reviews the worktree directly.
mode: subagent
hidden: true
model: anthropic/claude-sonnet-4-6
temperature: 0.1
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "git diff*": allow
    "grep *": allow
    "rg *": allow
    "ls *": allow
  external_directory:
    "**/worktrees": allow
    "**/worktrees/**": allow
    "~/.local/share/opencode/worktree": allow
    "~/.local/share/opencode/worktree/**": allow
    "~/.config/opencode/newagents/prompts/**": allow
    "~/.config/opencode/newagents/playbooks/**": allow
---

Use the exact prompt, inputs, review framework, and output contract defined in [`code-review`](.config/opencode/newagents/prompts/code-review.md). This is the standard/deep code-review variant: it binds the shared prompt to the model set in this file's frontmatter and carries no behavior of its own.
