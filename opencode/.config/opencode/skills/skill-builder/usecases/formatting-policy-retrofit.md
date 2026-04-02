# Use Case: Formatting Policy Retrofit

Use this when a skill writes content to external systems with strict formatting requirements.

## Workflow

1. Identify target formatting constraints (rich text model, API format, editor schema).
2. Add a formatting policy section in `SKILL.md`.
3. State explicitly when Markdown is prohibited.
4. Define any additional system-specific constraints needed for valid content.
5. Update relevant use-case files to enforce this policy during create/edit flows.

## Verification

- Policy is clear, global, and unambiguous.
- Use-case docs reference and apply the policy consistently.
