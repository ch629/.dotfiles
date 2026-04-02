# Use Case: Repository Operations

Use this when the user asks to inspect or manage repository-level information with `gh`.

## Typical triggers

- "Show repo details"
- "What is the default branch?"
- "List repos in this org"
- "View branch protection or visibility"

## Workflow

1. Confirm host and auth state with `gh auth status`.
2. Resolve repo target explicitly:
   - Current repo: `gh repo view`
   - Explicit repo: `gh repo view <owner>/<repo>`
3. Discover fields/options via help before selecting output.
4. Use machine-readable output when available (`--json`/`--jq`) and request only needed fields.
5. Report only relevant fields for the request (for example default branch, visibility, topics, description, URL).

## Safety checks

- Do not modify settings unless explicitly requested.
- If multiple repos match a natural-language request, present choices before mutating.
- Redact sensitive output if command response includes secrets.
