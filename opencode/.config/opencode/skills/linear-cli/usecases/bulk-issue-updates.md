# Use Case: Bulk Issue Updates

Use this when one action must be applied to many Linear issues.

## Goal

- Execute large-scope updates safely and predictably.
- Prevent accidental changes from broad filters.

## Workflow

1. Build a narrow issue query (team, project, label, assignee, cycle, status).
2. Run a read-only preview and present the proposed impact.
3. Ask for explicit confirmation if more than 10 issues are affected.
4. Execute the bulk update.
5. Re-query to verify completion and identify failures/skips.

## Safety checks

- Never run broad, unbounded bulk updates without preview.
- If command lacks true bulk mode, iterate deterministically and track per-issue outcomes.
- Stop and surface partial-failure details instead of silently continuing.
- If a bulk update includes descriptions or other formatted text, draft the content in a markdown file first.

## Report format

- Query/filter used.
- Total matched, total changed, total skipped/failed.
- Per skipped/failed issue: identifier and reason.
