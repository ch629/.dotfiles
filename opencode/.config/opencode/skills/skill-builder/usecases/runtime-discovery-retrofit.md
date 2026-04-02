# Use Case: Runtime Discovery Retrofit

Use this when a skill contains brittle, hardcoded command usage.

## Workflow

1. Remove fixed command examples that may drift over time.
2. Add runtime discovery policy in `SKILL.md`.
3. Convert workflows to discovery-first steps (discover -> execute -> verify).
4. Keep syntax references generic unless the user asks for pinned examples.
5. Confirm the skill now instructs retries via help when argument mismatch occurs.

## Success criteria

- Skill remains accurate even if CLI flags evolve.
- Users still get clear execution flow without hardcoded commands.
