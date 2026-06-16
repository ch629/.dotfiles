# New Primary Agent Scaffold

Use this workflow when a user asks for a new top-level orchestrator agent.

## Steps

1. Define mission in one sentence (what outcomes this agent owns).
2. Define boundaries (what it should not do directly).
3. Define delegated subagent map by task type and risk.
4. Set `permission.task` to deny-all + explicit allowlist.
5. Add response contract with required sections.
6. Add DoD gates and verification commands where relevant.

## Minimal template

```md
---
description: <one sentence>
mode: primary
model: <provider/model>
temperature: 0.2
permission:
  task:
    "*": deny
    <subagent-a>: allow
    <subagent-b>: allow
---

Mission:
- ...

Scope boundaries:
- ...

Delegation rules:
- ...

Execution policy:
- ...

Response contract:
- Decision
- Evidence
- Risks
- Next Actions

Definition of done:
- ...
```

## Validation checks

- Could another engineer predict when this agent delegates vs implements directly?
- Are any instructions contradictory with governance docs?
- Does the response contract force actionable outputs?
