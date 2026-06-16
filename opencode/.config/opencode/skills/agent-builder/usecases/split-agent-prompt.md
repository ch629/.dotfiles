# Split and Modularize Agent Prompts

Use this when an agent prompt is too large, mixed, or hard to maintain.

## Signals to split

- Prompt contains multiple unrelated domains (e.g., infra + data + app logic) in one block.
- Repeated language-specific details dilute base orchestration behavior.
- Frequent edits create drift or contradictions.

## Refactor pattern

1. Keep base agent focused on orchestration and policy.
2. Move domain-specific guidance into playbooks (`playbooks/<agent>/...`).
3. Add a router section that loads playbooks on demand.
4. Keep high-level constraints in base file; move implementation specifics out.

## Acceptance criteria

- Base agent is shorter and easier to read.
- Language/domain rules exist in modular playbooks.
- Router conditions are explicit and mutually understandable.
- No duplicated or conflicting rules remain.
