# Task Decomposition and Sequencing Playbook

Use this playbook to convert scope into executable work.

## Output contract

1. Epics
2. Tasks per epic
3. Subtasks for complex items
4. Dependency graph
5. Parallel tracks
6. Critical path and blockers

## Task definition standard

Each task should include:

- Objective
- Definition of done
- Owner role
- Dependencies
- Risk level (low/medium/high)
- Validation method

## Sizing guardrail

- Prefer 0.5-2 day tasks.
- If larger, split or mark as epic with internal milestones.

## Sequencing rules

1. Resolve unknowns and interfaces first.
2. Build thinnest end-to-end path early.
3. Add hardening and edge handling before launch.
4. Keep a dedicated instrumentation/analytics stream.

## Delivery risk prompts

- What can block this task?
- What assumptions remain untested?
- What fallback exists if this slips?
