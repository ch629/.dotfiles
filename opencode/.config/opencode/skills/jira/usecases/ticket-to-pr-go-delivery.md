# Use Case: Ticket To PR Go Delivery

Use this guide when the user wants an end-to-end flow from Jira ticket pickup to implementation/PR-ready execution.

## Runtime workflow

1. Discover and read ticket details (including parent/epic context when relevant).
2. Extract and verify acceptance criteria, constraints, and unresolved unknowns.
3. Produce a concrete implementation breakdown for Go code changes.
4. Define test strategy and required validation evidence before coding starts.
5. Define PR traceability artifacts (branch name, commit prefix, AC-to-evidence mapping).

## Required artifacts

- Ticket summary and status.
- Verified acceptance-criteria checklist.
- Unknowns and exact clarifications needed.
- Ordered implementation steps with risk notes.
- Test plan (`go test ./... -race` plus scenario coverage expectations).
- Branch naming recommendation that includes Jira key.
- Commit subject prefix recommendation using Jira key.
- PR summary scaffold with AC -> evidence mapping.
- For strict company profiles (for example Betika), include required PR title format and commit constraints.

## Safety rules

- Do not assume acceptance criteria that are not present; label assumptions explicitly.
- If confidence is not high, state "I do not know" and request missing details.
- Keep recommendations deterministic, concise, and auditable.
- Prefer incremental rollout/rollback notes for higher-risk payment or data changes.

## Report format

- Ticket: key and link.
- Known facts.
- Unknowns.
- What needs doing.
- Acceptance criteria checklist.
- Implementation order.
- Test and validation evidence plan.
- Traceability plan (branch/commit/PR).
- Suggested first implementation step.
