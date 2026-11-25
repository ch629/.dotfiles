# Use Case: CLI Skill Creation

Use this when building a skill that executes or guides command-line workflows.

## Policy

- Keep CLI-specific rules out of generic `SKILL.md` guidance for non-CLI skills.
- Run known, appropriately scoped commands directly; use the most specific relevant help when syntax is uncertain or arguments are rejected.
- Before retrying a mutation, ensure it did not already take effect. Preserve target resolution, authorization and verification safeguards.

## Workflow

1. Confirm the skill is CLI-oriented.
2. Add CLI discovery policy in a CLI-specific use-case file, not in generic core standards.
3. Keep stable, minimal command references and use conditional discovery for uncertain syntax.
4. Avoid redundant auth and help preflights; diagnose authentication failures without automatic login or token repair.
5. Add verification/report expectations for command outcomes.

## Optional companion guide

- For retrofitting brittle existing command examples, use:
  - [Runtime discovery retrofit](runtime-discovery-retrofit.md)
