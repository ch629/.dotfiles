---
description: Plan and launch personal Linear work in controlled parallel streams
agent: linear-parallel-work-orchestrator
subtask: true
---
Use `linear-parallel-work-orchestrator` for this personal-work run. For Betika work,
stop and ask the user to invoke `/parallel-linear-plan-betika` instead.

Parse command arguments as:

- `$1` = root Linear issue key (required)
- `$2` = subticket list (optional, comma-separated). Example: `PAY-124,PAY-125`
- `$3` = max parallel workers (optional, integer; default 2; hard cap 3 unless I explicitly approve more)
- `$4` = launch mode (optional: `plan-only`, `batch-approved`, or `single-step`; default `single-step`)

Execution requirements:

1. If `$1` is missing, stop and ask for the ticket key.
2. If `$2` is provided, only plan/launch that subset now and mark all other subtickets as deferred.
3. Build a reuse-first plan:
   - identify shared code/components to avoid duplicate work
   - create a shared-foundation section first when beneficial
4. Build a blocker matrix:
   - blocker, affected sections, owner, unblock condition/evidence
5. Enforce strict review gates per section:
    - required: `linear-ticket-validator`
    - required for financial Go changes: `go-financial-code-reviewer`
   - required checks evidence: tests/lint/race relevant to scope
6. Do not auto-launch implementation. Always pause for my explicit approval.
7. Do not exceed `max_parallel_workers` active sections.
8. Follow `policies/worktrees.md` for clean, pushed worktree cleanup. Branch deletion requires separate explicit approval.

When responding, always include:

- Decision
- Evidence
- Risks
- Next Actions
- Worker policy (max/active/queued)
- Selected vs deferred subtickets
- Reuse map
- Blocker matrix
