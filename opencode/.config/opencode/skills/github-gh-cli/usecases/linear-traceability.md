# Use Case: Linear Traceability

Use this guide when the user wants branch, commit, and PR conventions that preserve Linear traceability.

## Recommended conventions

- Branch naming: `<lowercase-issue-key>-<short-kebab-summary>`
  - Example: `pay-123-fix-settlement-rounding`
- Conventional commit subject: `<type>(<optional-scope>): <concise why-focused subject>`
  - Example: `fix(settlement): enforce deterministic fee rounding`
  - Include the issue key in the commit body when useful or required by the repository.
- PR title: `<type>(<optional-scope>): <feature/fix summary> [LINEAR-KEY]`

Profile-specific convention:

- For Betika projects (`/betika/` path), the issue key in branch names and PR titles is required. PR titles must use conventional commit format with the Linear issue key suffix:
  - `<type>(<optional-scope>): <subject> [ABC-123]`
  - Example: `fix(settlement): enforce idempotent webhook replay [PAY-741]`

## PR body scaffold

Use the repository PR template when present; otherwise use this structure for Linear-linked work:

- `## Summary`
- `## Linear`
  - Ticket key + URL
- `## Acceptance Criteria Coverage`
  - AC item -> evidence (file/test/output)
- `## Validation`
  - test/lint/race commands + key output notes
- `## Risks`
  - residual risk + rollback/mitigation notes

## Safety rules

- Do not invent Linear issue keys; ask if ticket linkage is requested but missing. Omit linkage for ticketless work where the profile permits it.
- Keep traceability details concise and machine-searchable.
- If repository conventions conflict, follow repository conventions and note the exception.
- If a strict profile requires a Linear issue key and it is missing, block PR creation and request the key.
