# Use Case: Bulk Update

Use this guide when the user wants to update many tickets at once via query/filter/key set.

## Runtime workflow

1. Discover and run search command to preview the exact scope.
2. Share scope summary and proceed when intent is explicit.
3. Discover and run edit/assign/transition command over that same scope.
4. Re-run search/read command to verify post-update state.
5. Report totals, keys changed, and failures.

## Safety rules

- Never mutate broad scope without previewing matching tickets first.
- Keep scope expression identical between preview and mutation unless user requests changes.
- Use non-interactive confirmation options only when intent is explicit.
- Do not delete/archive in bulk unless user explicitly requests it.
- If bulk-editing descriptions, use Jira ADF/ACL-compatible content and never Markdown.

## Report format

- Previewed count.
- Updated count.
- Per-ticket minimum fields: key, summary, status, assignee, action result.
- Partial failures/skipped tickets with reason.
