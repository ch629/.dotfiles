# Use Case: Triage Queue

Use this guide when the user wants to review queue items, assign ownership, or move tickets into active work.

## Runtime workflow

1. Discover the relevant search/list command with runtime help.
2. Preview candidate tickets and identify target keys.
3. Discover and run assign command for selected keys.
4. Discover and run transition command to move selected items forward.
5. Verify final status/assignee for changed tickets.

## Safety rules

- Preview before changing multiple tickets.
- If transition status names are unclear, inspect transition help before retrying.
- If some tickets fail (permissions/workflow), continue only when user intent is still clear and report skips.

## Report format

- Tickets reviewed (count).
- Tickets updated (count).
- Per-ticket minimum fields for changed items: key, summary, status, assignee, action result.
- Assignee/status before and after for changed items when relevant.
- Skipped tickets and reason.
