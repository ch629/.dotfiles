---
description: Lighter, cheaper code reviewer for trivial low-risk diffs. Same prompt and contract as code-reviewer, on a smaller model. Routed by the orchestrator only for trivial-tier changes.
mode: subagent
hidden: true
model: openrouter/qwen/qwen-plus
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

Use the exact prompt, inputs, review framework, and output contract defined in [`code-review`](.config/opencode/newagents/prompts/code-review.md). This is the lightweight code-review variant for trivial diffs: it binds the shared prompt to the model set in this file's frontmatter and carries no behavior of its own.

You are dispatched only for `trivial`-tier diffs (small, no risky areas), so you will normally be briefed with `review_depth: light`. The risk guardrail from the shared prompt still binds: if the diff actually touches money / auth / db / migration / concurrency, do not treat it as trivial — review at full `standard` depth and flag that the tier was misjudged so the orchestrator can re-route to `code-reviewer`.
