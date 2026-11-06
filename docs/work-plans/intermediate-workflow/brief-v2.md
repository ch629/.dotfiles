### Delivery brief v2: Self-sufficient planned-dev

**Brief path:** `/Users/charliehowes/.dotfiles/docs/work-plans/intermediate-workflow/brief-v2.md`  
**Index path:** `/Users/charliehowes/.dotfiles/docs/work-plans/intermediate-workflow/README.md`  
**State:** Blocked pending a permitted primary handoff and exact-content delivery approval.  
**Revision:** v2; contract v1. No digest binding or implementation approval established.

**Outcome:** Complete larger, coherent developer tasks from one request, using compact internal planning, delegated implementation and risk-appropriate independent review—without routine Octto approvals or multiple user-facing plans.

**Acceptance criteria**
1. Add `planned-dev` as a primary. Ordinary task requests authorize normal in-scope implementation; ask only for consequential ambiguity, material scope/risk changes, missing authority or blockers.
2. Delegate implementation to `feature-developer`. Allow developer-authored tests; do not mandate a separate prior test-writer. Applicable tests and verification remain mandatory.
3. Require independent code review, additional reviewers according to risk, and at most two repair/re-review cycles. Missing evidence or unresolved required findings blocks completion.
4. Keep quick-dev’s direct-work fast path and default-agent setting. Route coherent delegated work to planned-dev; escalate full-governance or high-risk work to ticket-orchestrator. Do not bypass denied task targets.
5. Reconcile developer expectations, permissions and governance. Ordinary planned-dev work requires neither a saved delivery brief nor repeated approval ceremonies. Supplied delivery briefs retain their approval/resumption contract.
6. Separate implementation authority from commits, push, PR creation and deployment. Preserve ticket-orchestrator’s existing test-first requirements.

**Scope**
- Add `opencode/.config/opencode/agents/planned-dev.md`.
- Update `agents/quick-dev.md`, `agents/feature-developer.md`, and routing references in `agents/ticket-orchestrator.md`.
- Narrow `policies/delivery-brief.md` so ordinary planned-dev requests are not accidentally subjected to full delivery-brief ceremonies.
- Add focused static contract checks and update their documentation.
- No default-agent change, mandatory planner stage, model-eval cases or model-eval runs.

**Design**
- Planned-dev: inspect, plan internally, delegate development/tests, collect verification, commission reviews, delegate bounded fixes, report a concise local handoff.
- Permissions: orchestration edits denied; task deny-all followed by named worker/reviewer allowances.
- Developer: accept caller-selected supplied-test or developer-owned-test mode, explicit workspace/scope/checks, and explicit action authority. Commit only when authorized.
- Review: lite code review only for small low-risk changes; full code review otherwise. Security and DB/migration/infra review when applicable; escalate high-risk scope. Preserve infra target, validation and deployment-authority rules.

**Repository and protection**
- Repository: `/Users/charliehowes/.dotfiles`
- Starting commit: `c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44`
- Current branch: `workflow-pilot-phase-one`
- Profile: `default`; deploy context: `live`
- Preserve the staged removal of `zsh/.tokens` and its ignored local file. Never read token contents or alter that index entry. Stage only task-owned paths; no broad staging, reset or stash.

**Authority**
- User permits a new worktree and scoped local red-test/implementation commits.
- Model evals deferred.
- Push, PR creation and deployment unauthorized.
- Current orchestrator requires a refreshed remote base; user selected manual handoff rather than changing the exact local base. The next primary must have compatible instructions and permissions.
- This brief remains unapproved; worktree/commit permission is not exact-content delivery approval.

**Implementation slices**
1. Permitted primary confirms and binds approval to this revision’s exact content, then creates an isolated worktree at the selected commit using the worktree tool.
2. For **this configuration delivery**, retain the current pipeline’s separate test-writer-first stage. Write meaningful failing static checks.
3. Developer implements, persists approved brief/index/source history alongside the changes, runs applicable checks and creates scoped authorized commits.
4. Run security and deep code review, bounded fixes, completion review and a local handoff. No publication.

**Verification and AC mapping**
- AC1–2: static contracts for compact internal planning, delegated development and both test modes.
- AC3: reviewer selection, blocked-evidence handling and repair limits.
- AC4: routing/default-agent regression checks.
- AC5–6: policy boundaries, ordered task permissions and action-authority separation.

Run the existing delivery-workflow, quick-dev, shared-access and infrastructure static checkers, plus a focused new planned-dev checker. Record exact commands, versions, exit codes and tested revision. Model/runtime behavior remains **unverified**, not passed. Static assertions cannot prove autonomous execution or effective runtime denial.

**Evidence and risks**
- Clarifier, researcher and planner completed.
- HEAD/status were checked: only observed change was the protected staged deletion.
- No implementation, test results, reviewer verdicts or completion verdict exists.
- Main risks: weakening supplied-brief governance, accidentally retaining mandatory developer commits, permission bypasses, and overstating static verification.

**History**
- Unsaved v1’s heavy approach is superseded by v2 following the user’s request for autonomy.
- Preserve v1’s complete displayed body from the earlier plan review if persisting history; record bidirectional supersession links. Do not reconstruct an abbreviated predecessor.
- Inspect destination and Git status before saving; preserve newer or dirty decisions.
