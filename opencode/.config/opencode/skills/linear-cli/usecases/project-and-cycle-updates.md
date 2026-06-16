# Use Case: Project and Cycle Updates

Use this when the user asks to update project health, cycle progress, or planning metadata in Linear.

## Goal

- Keep project/cycle status accurate.
- Ensure progress updates are reflected in related issues.
- Produce a concise execution summary.

## Workflow

1. Resolve target project/cycle by name or identifier.
2. Read current state first (status, lead, milestones, date windows, progress markers).
3. Apply requested updates.
4. Re-read the updated entity and dependent issue set when relevant.

## Safety checks

- Confirm exact target if names are similar.
- Preview downstream impact when updates imply issue transitions.
- Request explicit confirmation before wide status changes across many issues.
- If the update includes a description or planning note, draft it in a markdown file first so formatting can be validated.

## Report format

- Target project/cycle and scope.
- Before/after for key fields changed.
- Any dependent issues updated or intentionally unchanged.
