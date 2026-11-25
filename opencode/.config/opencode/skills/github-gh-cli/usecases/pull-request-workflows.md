# Use Case: Pull Request Workflows

Use this when the user asks to create, inspect, review, or merge pull requests with `gh`.

## Typical triggers

- "Create a PR for my current branch"
- "Show open PRs assigned to me"
- "Check PR review status"
- "Merge this PR when checks pass"

## Workflow

1. Resolve repo and branch context from available evidence; use a focused read if needed.
2. Use known PR commands directly; inspect specific help only when syntax is uncertain or rejected.
3. For PR creation, verify base/head intent and title/body source.
4. For existing PRs, fetch current status first (`gh pr view`, `gh pr list`, structured output preferred) with only required fields.
5. Run requested mutation (create/edit/review/merge) with explicit flags.
6. Verify resulting PR state and return URL plus key status fields.

## Safety checks

- Do not merge or close PRs without explicit user intent.
- For bulk PR actions, preview targets and require confirmation if scope is large.
- Call out blocked merges (failing checks, missing approvals, branch protection).
