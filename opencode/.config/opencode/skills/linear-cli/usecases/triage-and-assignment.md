# Use Case: Triage and Assignment

Use this when the user wants to prioritize work, pick next tasks, or assign ownership.

## Goal

- Identify the right issue set quickly.
- Apply clear ownership and status updates.
- Confirm outcomes with minimal noise.

## Workflow

1. Query issues by assignee, team, status, priority, or cycle using the most direct known command.
2. Show a concise preview list before making updates.
3. Apply assignment/status changes.
4. Re-read updated issues and report before/after values.

## Safety checks

- If query scope is broad, limit and page results.
- Ask for explicit confirmation when mutating more than 10 issues.
- If issue identifiers are ambiguous, resolve and confirm targets first.
- If a command shape is unfamiliar, consult help only after attempting the direct query path.

## Report format

- Total issues reviewed.
- Total issues changed.
- Per issue: identifier, title, old status/assignee, new status/assignee.
