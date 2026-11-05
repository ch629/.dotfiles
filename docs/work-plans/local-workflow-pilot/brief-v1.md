# Local workflow pilot — delivery brief v1

## Identity / origin / outcome

Contract v1; brief v1; state: **Proposed delivery**. Origin: user's approved Phase 1
implementation request, transcribed into this sanitized artifact by the implementation
agent. No ticket. No predecessor or successor; see [lifecycle index](README.md).

Outcome: users and agents can resume bounded delivery planning from a repository
path and summary without depending on ticket access or a prior conversation.

## Acceptance criteria

1. Define identity/origin, outcome, AC, scope/non-goals, constraints, repository/base,
   approach, evidence/unknowns, risk/authority, verification, slices and approval.
2. Define Discovery, Proposed delivery, Blocked, Approved delivery and Superseded;
   bind approval to a revision and renew it on material changes.
3. Provide discoverable versioned repository-local artifacts, supersession links
   and ticketless path-plus-summary resumption; tickets remain optional.
4. Separate planning approval from publication authority; provide manual
   continuation when task or other permissions forbid handoff/persistence.
5. Preserve committed cases and honest pre-routing baseline evidence. Obtain genuine
   model output against unchanged routing if available; otherwise retain Blocked /
   not run, including the original readiness failure.
6. Make no routing or permission changes; independent review follows implementation.

## Scope / non-goals / constraints

In scope: shared policy, this sanitized versioned artifact and eval README guidance.
Out of scope: agent wiring, permissions, runner changes, ticket operations, publishing,
deployment and repair of the runtime/provider configuration. Never read secret token
files; preserve the source dirty tree and unrelated work. All shell operations use
the assigned worktree; edits use absolute paths. No concern playbook applies.

## Repository / base / target paths

- Repository: dotfiles; base `origin/ai` at
  `4470628067697152ab4e0e0425e7bd4790741edf` (supplied refreshed base).
- Branch: `workflow-pilot-phase-one`; pre-written test commit:
  `0bbac5bebffb5b475f4ed4ade9f8ae089ef95586`.
- Worktree: plugin-managed `dotfiles-workflow-pilot-phase-one`; resolve its absolute
  path in the local session, not from another user's home directory.
- Targets: `opencode/.config/opencode/policies/delivery-brief.md`,
  `docs/work-plans/local-workflow-pilot/`, `opencode/.config/opencode/evals/README.md`.

## Approach / evidence / unknowns

Add a documentation-only contract and use the existing ten `workflow-` scenarios
without weakening them. Prefer manual explicit policy loading over unapproved agent
wiring in this phase. This limits rollout: defining the policy does not establish
that current agents consume it or satisfy the scenarios.

Dependencies: existing Ruby/Python static checks and an available configured OpenCode
model for behavioral evidence. The test-writer baseline is **Blocked / not run**:
OpenCode 1.18.34 returned UnknownError `err_d4eb727f` before model output. A fresh
pre-edit retry also failed; see verification-v1.md. Cause remains unknown; neither
credentials nor successful agent/config loading have been established. No required
behavioral evidence is being replaced with static checks.

## Risk / authority / approval

Risks: stale approval, invented evidence and accidental publication. Mitigate with
revision-bound decisions, explicit unknowns and separate authority records.

The user explicitly authorized implementing and locally committing this Phase 1
scope against the named tests, with the blocked-baseline fallback. That is the
source of local implementation authority, not evidence of approval of this new
artifact. **Approval of brief v1's exact content: outstanding.** No approver/content
binding is invented. Independent review remains pending. No push, PR, ticket mutation
or other publication is authorized. A future approval must name this revision and
its committed blob/digest; material changes require a successor and fresh approval.

## Verification / delivery slices

| Slice | AC | Completion / handoff |
| --- | --- | --- |
| Test-writer (committed) | 1–6 | Ten workflow cases and honest baseline-v1.md at the test commit |
| Implementation | 1–4, 6 | Audit policy field/state inventory and artifact links; JSON validation, all three Ruby checks and whitespace check |
| Baseline readiness | 5 | Fresh-server probe before edits; genuine model run only if ready, otherwise documented Blocked / not run |
| Independent review (pending) | 1–6 | Review scoped diff, semantic contract and evidence; request revision-bound artifact approval |

Exact executed commands/results are in [verification-v1.md](verification-v1.md).
No compiled build applies to this Markdown-only slice. Behavioral evals and actual
persistence/permission-denial integration are distinct from static validation and
remain unverified. Next action: independent review, not routing rollout.
