# Use Case: Scaffold New Skill

Use this when creating a brand-new skill from scratch.

## Workflow

1. Define skill scope in one sentence.
2. Create a concise `SKILL.md` with: purpose, when-to-use, core standards, and quality checklist.
3. Move scenario-specific procedures into `usecases/*.md` files.
4. Add relative markdown links from `SKILL.md` to each use-case file.
5. Add selection guidance so the right use-case file is loaded per request.

## Output requirements

- Keep the core file short and policy-focused.
- Keep use-case files action-focused and narrow in scope.
- Avoid embedding tool-specific syntax unless user explicitly requests it.
