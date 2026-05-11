# Use Case: Jira Traceability

Use this guide when the user wants branch, commit, and PR conventions that preserve Jira traceability.

## Recommended conventions

- Branch naming: `<JIRA-KEY>-<short-kebab-summary>`
  - Example: `PAY-123-fix-settlement-rounding`
- Commit subject prefix: `<JIRA-KEY>: <concise why-focused subject>`
  - Example: `PAY-123: enforce deterministic fee rounding to preserve reconciliation parity`
- PR title prefix: `<JIRA-KEY>: <feature/fix summary>`

Profile-specific convention:

- For Betika projects (`/betika/` path), PR title must use conventional commit format with Jira key suffix:
  - `<type>(<optional-scope>): <subject> [ABC-123]`
  - Example: `fix(settlement): enforce idempotent webhook replay [PAY-741]`

## PR body scaffold

Use this structure for Jira-linked work:

- `## Summary`
- `## Jira`
  - Ticket key + URL
- `## Acceptance Criteria Coverage`
  - AC item -> evidence (file/test/output)
- `## Validation`
  - test/lint/race commands + key output notes
- `## Risks`
  - residual risk + rollback/mitigation notes

## Safety rules

- Do not invent Jira keys; ask if missing.
- Keep traceability details concise and machine-searchable.
- If repository conventions conflict, follow repository conventions and note the exception.
- If a strict profile requires Jira-formatted titles and key is missing, block PR creation and request the key.
