# Delivery brief contract v1

For ticket-orchestrator, use one repository-local brief as the planning and resumption contract for ticketed
and ticketless work, including its full approval gates. A ticket is optional linkage, not a prerequisite or substitute
for the contract. This policy does not change agent routing, tool permissions or
publication authority. Phase 1 defines the contract; automatic agent loading and
behavioral enforcement are not claimed.

Ordinary planned-dev work does not require a saved delivery brief or its approval ceremonies. A supplied brief retains this contract's exact-content approval and resumption requirements; do not use the exemption to bypass its gates.

## Required fields

Keep every field visible; use `unknown`, `not run`, or `not applicable` with a reason
rather than inventing paths, evidence, commands, approval or ticket state.

| Field | Required content |
| --- | --- |
| Identity / origin | Stable slug, contract version, brief revision, state, author/source of request; optional supplied ticket key and whether remotely verified |
| Outcome | Problem, intended users and observable desired result |
| Acceptance criteria | Numbered, testable outcomes, including relevant empty/error/boundary cases |
| Scope / non-goals | Included work and explicit exclusions |
| Constraints | Safety, compatibility, time/tool restrictions and dependencies |
| Repository / base | Repository, base ref and resolved SHA, branch, worktree and known target paths (or unknowns) |
| Approach | Smallest proposed implementation and meaningful alternatives/tradeoffs |
| Evidence / unknowns | Sources, observed facts versus assumptions, unresolved decisions and blockers with next actions |
| Risk / authority | Risks, mitigations, permitted local actions, denied actions and required escalation; publication authority separately |
| Verification | AC-to-check mapping, exact commands/target/environment when known, required evidence and actual results; distinguish static checks, model behavior and integration |
| Delivery slices | Ordered bounded slices, dependencies, completion criteria and handoff owner/role |
| Approval | Exact revision, approver and source of explicit decision, scope of approval, outstanding approval and material changes since that decision |

## States and approval

- **Discovery**: problem, audience or outcomes are insufficiently defined. Ask the
  smallest useful question or propose a bounded experiment; do not invent readiness.
- **Proposed delivery**: a concrete brief exists, but explicit delivery approval for
  this revision is outstanding. List unknowns and remaining decisions.
- **Blocked**: a required decision, dependency, authority or verification gate cannot
  be met. Name the blocker, evidence, owner/next action and intended return state.
  A failed readiness probe with no model output is `Blocked / not run`, not a red
  behavioral assertion or a pass. Static validation cannot replace model evidence.
- **Approved delivery**: the authorized user explicitly approved this exact revision
  for the stated delivery scope and required gates are satisfied. Record the actual
  decision; `looks good, keep exploring` is not implementation approval. Clarify
  ambiguous approval instead of starting implementation.
- **Superseded**: a newer revision replaces this one. Retain its history and link
  both directions. Prior approval remains historical, not authority for the successor.

Discovery may become Proposed delivery when sufficiently defined. Any active state
may become Blocked; resolving the blocker restores only the justified state, never
automatic approval. Material changes to outcome, AC, scope, approach, constraints,
risk/authority, repository/base or verification require a new revision and renewed
explicit approval. A successor normally starts Proposed delivery (or Blocked if a
required gate is missing). Do not transfer approval from v3 to a materially changed
v4. Record nonmaterial corrections transparently without rewriting approved content.

Planning approval authorizes only its recorded scope. It is **not publication
authority** for push, PR creation, releases, deployment, ticket mutations or other
external writes. Record separate explicit authorization for each requested action;
permission availability alone is not authorization. Local saving/committing also
requires applicable user authority and tool permissions. Approval never overrides
denied edits, shell or task handoffs. If handoff is forbidden, provide a copyable
manual continuation for the user; do not delegate or switch tools to bypass denial.

## Persistence and ticketless resumption

Use `docs/work-plans/<slug>/README.md` as the discoverable index and
`docs/work-plans/<slug>/brief-v<N>.md` for revisioned briefs. The index identifies
the current revision, state, earlier revisions and evidence paths. Preserve prior
revision bodies; record supersession in the index or a linked lifecycle record,
with predecessor and successor links. Approval must identify the revision's exact
content (for example a committed blob or digest), not just a mutable filename.

Before saving, inspect the destination and Git status. Preserve dirty brief edits
and unrelated staged/unstaged work. If a dirty brief might contain a newer decision,
compare and clarify before choosing a successor; do not overwrite, discard, stage
or commit user work. Commit only the authorized slice. If persistence is forbidden
or unavailable, label the destination **proposed / not saved** and provide the full
copyable content. Never claim that proposing a path saved it.

End each session with this handoff, usable without a ticket or the conversation:

```text
Path: docs/work-plans/<slug>/brief-v<N>.md (saved, or proposed / not saved)
Summary: <outcome, scope and non-goals>
State / revision: <state>, v<N>; contract v1
Approval: <exact decision and bound content, or outstanding>; publication: <authority or none>
Evidence: <paths, actual checks/results, unknowns and blockers>
Remaining decision: <what and who>
Next action: <bounded action, required authority and verification>
Supersession: <predecessor/successor paths or none>
```

On resumption, read the index and brief, confirm revision/content and approval,
reconcile repository status and new evidence, then continue only within current
authority. Retain supplied ticket linkage without claiming remote validation.
