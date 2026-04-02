# Use Case: Extract Use Cases

Use this when an existing skill has too much scenario-specific content in `SKILL.md`.

## Workflow

1. Identify sections that are tied to specific workflows.
2. Create one file per workflow under `usecases/`.
3. Replace inlined workflow content with relative markdown links.
4. Add clear selection guidance in `SKILL.md` mapping user intent to each use-case file.
5. Ensure no critical guidance was lost during extraction.

## Safety checks

- Keep shared policies in `SKILL.md`; do not duplicate them across every use-case file.
- Ensure links are relative and valid.
- Ensure each use-case file can be understood independently.
