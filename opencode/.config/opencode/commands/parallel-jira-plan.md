---
description: Plan and launch Jira work in controlled parallel streams
agent: jira-parallel-work-orchestrator
subtask: true
---
Use `jira-parallel-work-orchestrator` for this run.

Parse command arguments as:

- `$1` = root Jira ticket key (required)
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
   - required: `jira-ticket-validator`
   - required: `go-financial-code-reviewer`
   - required checks evidence: tests/lint/race relevant to scope
6. Do not auto-launch implementation. Always pause for my explicit approval.
7. Do not exceed `max_parallel_workers` active sections.
8. Treat destructive git actions (branch/worktree deletion) as disallowed unless I explicitly approve in this session.

When responding, always include:

- Decision
- Evidence
- Risks
- Next Actions
- Worker policy (max/active/queued)
- Selected vs deferred subtickets
- Reuse map
- Blocker matrix
