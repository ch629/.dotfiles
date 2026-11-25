# Governance Profiles

Use this profile system to apply different delivery quality gates by project context.

## Profile selection (path-based)

Select the first matching profile by current workspace path (`cwd`):

1. If path contains `/betika/` -> `betika` profile.
2. Otherwise -> `default` profile.

If path matching is ambiguous, ask the user to confirm active profile before enforcing strict gates.

## Profiles

### `default`

- Coverage target: recommended, not a merge blocker.
- Linear issue key in branch/PR title: recommended, not required.
- Linear validator before sign-off: recommended for ticketed work.
- Completion review before PR: recommended for ticketed work.
- Conventional commits: preferred when creating commits.

### `betika`

- Coverage target: **required** at >=80% for changed/new code areas (or explicit documented gap + follow-up if impossible within ticket scope).
- Linear traceability: **required** in branch names and PR titles.
- Linear validator before sign-off: **required** for Linear-ticketed work unless user explicitly asks to skip.
- Completion review before PR: **required** for ticketed work unless user explicitly asks to skip.
- Conventional commits: **required** for assistant-authored commits.
- Commit type `chore` is **not allowed** for assistant-authored commits.
- PR title must follow:
  - Conventional commit prefix, then ticket suffix in brackets.
  - Format: `<type>(<optional-scope>): <subject> [ABC-123]`
  - Example: `fix(settlement): prevent duplicate ledger postings [PAY-741]`

## Extending for new companies

Resolve the active profile at intake and record its gates in the delivery brief. Completion review enforces these gates; it does not replace the Linear validator when that validator is required.

To add a new company profile:

1. Add a new path match rule under profile selection.
2. Add a new profile section with required gates.
3. Keep the same gate categories so behavior stays predictable:
   - Coverage
   - Commit format
   - Branch/PR Linear traceability
   - Validator/reviewer requirements

To remove a company profile, delete its selector rule and profile section.
