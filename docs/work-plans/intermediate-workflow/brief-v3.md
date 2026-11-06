# Delivery brief v3: reviewer-contract repair addendum

Contract v1; revision v3. Author: implementation primary. Source: user's explicit approval of the exact scope-extension question on 2026-11-06. This revision is the immutable [v2 contract](brief-v2.md), SHA-256 `b8c4a7052ed567a9ea58dcf247370e5dc746ae975c29c6876d1ad2182a05d627`, plus the exact additive scope below; all other fields remain unchanged. Do not reinterpret v2's historical pending-approval text as the current lifecycle state; see [README](README.md).

## Exact approved additive scope

> Approve this narrow v3 scope extension to the bound v2 brief (SHA-256 b8c4a7052ed567a9ea58dcf247370e5dc746ae975c29c6876d1ad2182a05d627): update security-scanner.md, db-reviewer.md and migration-reviewer.md so they accept either a supplied immutable commit range or an exact provenance-bound uncommitted snapshot, block missing provenance, and never substitute origin/main. Add focused regressions. Also tighten write-capable Git allowances in the new/changed agents and require the complete specialist task allowlist. All other v2 outcomes, constraints, exact base, local-only commit authority, deferred model evals and no push/PR remain unchanged.

Decision: user selected **Approve review fixes (Recommended)**. Scope includes the three reviewer contracts and focused tests, in addition to the original changed files; no unrelated reviewers or permission snapshots are to be normalized.

## Required fields / inherited contract

| Field | Current revision contract |
| --- | --- |
| Identity / origin | intermediate-workflow, contract v1, revision v3; user-approved additive scope above; ticketless |
| Outcome | v2 outcome unchanged: self-sufficient plan/delegate/verify/review middle tier |
| Acceptance criteria | v2 AC1–6 unchanged; additionally assert committed and snapshot specialist provenance, complete task map, no silently allowed write-capable Git commands |
| Scope / non-goals | v2 plus the exact additive scope above; no model cases/runs, default-agent change, publication or live infra operation |
| Constraints | All v2 constraints retained; never read/alter protected token contents/index/local file; explicit task-owned staging only; immutable predecessor body retained |
| Repository / base | /Users/charliehowes/.dotfiles; exact c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44; branch planned-dev in /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev; reviewed implementation d48ef40 |
| Approach | Reconcile specialist caller/callee inputs; block absent provenance; tighten Git defaults; strengthen positive/negative static regressions, then rerun affected review |
| Evidence / unknowns | Initial code/security reviews found specialist snapshot incompatibility, incomplete allowlist assertions and Git --output write surface; runtime behavior remains unverified |
| Risk / authority | Same local test/fix commit authority; no push/PR/deploy; no permission bypass; reviewer changes preserve read-only and infra/live gates |
| Verification | v2 suite plus regressions for each specialist and removed allowlist entry/write-capable Git command; record baseline delta and candidate snapshot; model evals deferred, not passed |
| Delivery slices | First repair/re-review cycle: feature-developer fixes listed findings, checks and commits; original reviewers recheck; completion reviewer verifies evidence; retain two-cycle outer limit |
| Approval | Explicit user choice approving the exact question quoted above, bound to immutable v2 digest plus this additive text; no other changes approved |

## History / handoff

Predecessor: [brief-v2.md](brief-v2.md), now superseded for active delivery by this additive revision; its approval remains historical. Successor: none. Record v2 → v3 in the index without changing v2's body. Delivery remains in progress pending repair verification, independent re-review and completion review. No runtime claim or publication authority is granted.
