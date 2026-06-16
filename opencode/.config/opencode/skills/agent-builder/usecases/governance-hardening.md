# Governance and Safety Hardening

Use this when an agent must meet stricter quality or compliance controls.

## Hardening checklist

- Add path-based governance profile resolution rule.
- Add required reviewer/validator gates by risk category.
- Add explicit fix-and-recheck loop limits.
- Add traceability rules for ticketed work (branch/PR/title requirements).
- Add coverage/testing/lint expectations with profile strictness differences.

## Failure-handling policy

- If required key data is missing (e.g., Jira key in strict profile), ask user before continuing.
- If validation loops fail repeatedly, stop and return unresolved findings plus prioritized recommendations.

## Acceptance criteria

- Governance rules are testable and unambiguous.
- Required vs recommended gates are clearly separated.
- Reviewer category requirements are explicitly listed.
