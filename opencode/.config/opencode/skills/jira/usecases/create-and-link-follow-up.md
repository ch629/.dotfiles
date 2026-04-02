# Use Case: Create And Link Follow-Up

Use this guide when the user wants a new ticket created from existing work and connected back to the source.

## Runtime workflow

1. Discover and run create command with required fields from user intent.
   - If providing a description, format it as Jira ADF/ACL-compatible content (no Markdown).
   - If including code, use Jira code block content with language tag when known.
2. Capture the newly created key from command output.
3. Discover and run link command between source and new ticket.
4. Discover and run comment command to add cross-reference context.
5. Verify both tickets reflect relationship/comment state.

## Safety rules

- Confirm source ticket key before linking.
- If link type is required and unclear, inspect link help and choose the best semantic match.
- Keep comment text concise and include both ticket keys.
- Never write ticket descriptions in Markdown.

## Report format

- New ticket key and summary.
- Source ticket key.
- Per-ticket minimum fields for touched tickets: key, summary, status, assignee, action result.
- Link/comment failures or skipped actions with reason.
