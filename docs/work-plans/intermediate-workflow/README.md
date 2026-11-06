# Intermediate workflow delivery

Current: [brief-v2.md](brief-v2.md), contract v1, approved delivery scope. The brief is an immutable copy of the proposed v2 displayed in the conversation; historical pending-state text inside it is resolved by this lifecycle record, not rewritten.

## Content and authority binding

- SHA-256 of `brief-v2.md` (UTF-8, LF, final newline): `b8c4a7052ed567a9ea58dcf247370e5dc746ae975c29c6876d1ad2182a05d627`.
- Approver: user, continuation message in this session, 2026-11-06. Exact decision captured in [source-request.md](source-request.md).
- Approved scope: v2's self-sufficient planned-dev, scoped static test-first implementation and local commits in an isolated worktree at `c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44`. No model cases/runs; runtime enforcement remains unverified. No push, PR, deployment or other publication authority.
- Worktree: `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev`; branch `planned-dev`; verified initial HEAD equals the exact base above. The absolute paths in the immutable proposal identify the original repository destination; actual saved artifacts are in this isolated worktree at the same repository-relative paths.
- Original repository status before launch: staged deletion `zsh/.tokens` only. Never read its contents or alter that staged deletion/ignored local file. All staging must be explicit task-owned paths in this worktree.
- Manual primary handoff requested and continuation authorized by user. Current implementation context supports editing and the worktree tool; no remote-base substitution or policy bypass is used.

## History

- v1: proposed in conversation, never saved or delivery-approved; approach-only approval is historical. Superseded by v2 following the user's request to remove routine planning ceremonies. The original complete v1 body remains in conversation plan review `q_zemufz94`; it is not reconstructed or abbreviated here. No previously saved predecessor file existed to overwrite. Predecessor/successor: conversation v1 → this `brief-v2.md`; v2 → none.
- v2: exact proposal saved and bound above; user explicitly instructed continuation. Future material changes require a successor and renewed approval; lifecycle/evidence updates do not rewrite this body.

## Evidence / next action

Intake clarification, research, implementation planning, static tests and implementation completed. See `evidence.md` for results and the pre-existing baseline failures. Independent reviews are pending. Model evals are deferred by user and cannot be reported as passed; delivery is in progress, not complete.

Next: independent code/security reviews, bounded fixes and completion review. Final user manual review remains required. Restart OpenCode after agent/config changes.
