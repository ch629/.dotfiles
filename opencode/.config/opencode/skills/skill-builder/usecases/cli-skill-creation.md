# Use Case: CLI Skill Creation

Use this when building a skill that executes or guides command-line workflows.

## Policy

- Keep CLI-specific rules out of generic `SKILL.md` guidance for non-CLI skills.
- Prefer runtime discovery over hardcoded command syntax.
- Use top-down help discovery:
  - `<tool> --help`
  - `<tool> <group> --help`
  - `<tool> <group> <command> --help`
- If a command fails due to argument mismatch, inspect help and retry.

## Workflow

1. Confirm the skill is CLI-oriented.
2. Add CLI discovery policy in a CLI-specific use-case file, not in generic core standards.
3. Convert fixed command examples to discovery-first guidance where possible.
4. Keep only stable, minimal command references that are unlikely to drift.
5. Add verification/report expectations for command outcomes.

## Optional companion guide

- For retrofitting brittle existing command examples, use:
  - [Runtime discovery retrofit](runtime-discovery-retrofit.md)
