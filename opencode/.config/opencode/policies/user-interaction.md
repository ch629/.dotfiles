# User interaction

Use OpenCode's native `question` tool for user-facing clarification, choices and explicit approval. Keep interaction in the OpenCode window; do not start a browser questionnaire or session.

- Batch related questions. Use multiple selection only when more than one answer may apply; allow custom input for details not captured by the choices.
- Present plans, diffs and other long material in the conversation, then use `question` for the decision. For content-bound approval, identify the exact revision and digest or immutable artifact being approved; do not treat a general positive response as approval of undisclosed content.
- Preserve each workflow's required gates and authority boundaries. Changing the interaction tool does not authorize edits, commits, publication or deployment, waive approval requirements, or add routine approval gates to autonomous workflows.
- Send informational updates and failure notifications as ordinary messages; use `question` only when an answer or decision is needed. Record material answers in the workflow's existing decision record.
- If the native tool is unavailable, ask directly in the conversation and wait for a clear answer where required. Never infer approval from tool unavailability or silently switch to a browser session.
