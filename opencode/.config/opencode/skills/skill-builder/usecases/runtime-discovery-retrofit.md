# Use Case: Runtime Discovery Retrofit

Use this when a skill contains brittle, hardcoded command usage.

## Workflow

1. Retain useful stable command examples; flag version-sensitive syntax for conditional discovery.
2. Add runtime discovery policy in `SKILL.md`.
3. Run known commands directly; use the most specific help when syntax is uncertain or arguments are rejected.
4. Preserve target resolution, authorization and result verification.
5. Before retrying a mutation, ensure it did not already take effect.

## Success criteria

- Skill handles evolving CLI flags without routine help preflights.
- Users get a clear execution flow with appropriate safety checks.
