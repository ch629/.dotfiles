# Governance Profiles

Delivery quality gates by project context. The orchestrator resolves the active profile once
at intake (records it as `profile` in the Ticket Brief); `completion-reviewer` enforces it.

## Profile selection (path-based)

Select the first matching profile by current workspace path (`cwd`):

1. If path contains `/betika/` -> `betika` profile.
2. Otherwise -> `default` profile.

If path matching is ambiguous, ask the user (via octto) to confirm the active profile before enforcing strict gates.

## Profiles

### `default`

- Coverage target: recommended, not a merge blocker.
- Ticket key in branch/PR title: recommended, not required.
- Completion review before sign-off: recommended for ticketed work.
- Conventional commits: preferred.

### `betika`

- Coverage target: **required** ≥80% for changed/new code (or a documented gap + follow-up if impossible within scope).
- Ticket traceability: **required** in branch names and PR titles.
- Completion review before sign-off: **required** for ticketed work unless the user explicitly asks to skip.
- Conventional commits: **required** for assistant-authored commits; commit type `chore` is **not allowed**.
- PR title format: `<type>(<optional-scope>): <subject> [ABC-123]`
  - Example: `fix(settlement): prevent duplicate ledger postings [PAY-741]`

## Extending for new companies

1. Add a path-match rule under profile selection.
2. Add a profile section, keeping the same gate categories so behavior stays predictable:
   Coverage · Commit format · Branch/PR traceability · Validator/reviewer requirements.
