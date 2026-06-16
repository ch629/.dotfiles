# New Subagent Scaffold

Use this workflow when creating a specialized subagent.

## Steps

1. Define specialization narrowly (single domain/problem class).
2. Define expected input context from parent agent.
3. Define required output format and evidence requirements.
4. Set permissions to least privilege for task purpose.
5. Add explicit non-goals (what the subagent must not decide).

## Minimal template

```md
---
description: <narrow specialization + trigger>
mode: subagent
model: <provider/model>
temperature: 0.1
permission:
  edit: deny
  bash: ask
---

Role:
- ...

Inputs expected:
- ...

Review/analysis framework:
- ...

Output format:
- Findings
- Severity/Priority
- Evidence
- Recommended fixes
- Residual risks
```

## Validation checks

- Can this subagent be called repeatedly with consistent shape?
- Is output immediately actionable by the primary agent?
- Are non-goals explicit enough to prevent scope creep?
