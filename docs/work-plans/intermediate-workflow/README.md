# Intermediate workflow delivery

Current: [brief-v3.md](brief-v3.md), contract v1, approved delivery scope: the immutable v2 body plus the exact user-approved review-fix scope extension. V2 is superseded for active delivery; historical pending-state text inside it is resolved by this lifecycle record, not rewritten.

## Content and authority binding

- SHA-256 of `brief-v3.md`: `d4efd8331ef8945b620e7b739a37867121c1339dc53870afdd2d77b8407a398d`. Approved content is immutable v2 plus the exact scope question quoted in v3 and accepted by the user; the file records all inherited fields and adds no further implementation authority.
- SHA-256 of `brief-v2.md` (UTF-8, LF, final newline): `b8c4a7052ed567a9ea58dcf247370e5dc746ae975c29c6876d1ad2182a05d627`.
- Approver: user, continuation message in this session, 2026-11-06. Exact decision captured in [source-request.md](source-request.md).
- Approved scope: v2's self-sufficient planned-dev, scoped static test-first implementation and local commits in an isolated worktree at `c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44`. No model cases/runs; runtime enforcement remains unverified. No push, PR, deployment or other publication authority.
- Worktree: `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev`; branch `planned-dev`; verified initial HEAD equals the exact base above. The absolute paths in the immutable proposal identify the original repository destination; actual saved artifacts are in this isolated worktree at the same repository-relative paths.
- Original repository status before launch: staged deletion `zsh/.tokens` only. Never read its contents or alter that staged deletion/ignored local file. All staging must be explicit task-owned paths in this worktree.
- Manual primary handoff requested and continuation authorized by user. Current implementation context supports editing and the worktree tool; no remote-base substitution or policy bypass is used.

## History

- v1: proposed in conversation, never saved or delivery-approved; approach-only approval is historical. Superseded by v2 following the user's request to remove routine planning ceremonies. The original complete v1 body remains in conversation plan review `q_zemufz94`; it is not reconstructed or abbreviated here. No previously saved predecessor file existed to overwrite. Predecessor/successor: conversation v1 → `brief-v2.md` → `brief-v3.md`.
- v2: exact proposal saved and bound above; user explicitly instructed continuation. Superseded by [v3](brief-v3.md); its body and historical approval are preserved.
- v3: user explicitly selected **Approve review fixes (Recommended)** for the exact additive scope quoted in brief-v3.md. Predecessor v2; successor none. This authorizes the three specialist contract updates and focused review fixes, with all original local-only constraints retained. Future material changes require a successor and renewed approval; lifecycle/evidence updates do not rewrite approved bodies.

## Evidence / next action

Implementation and the two permitted repair/re-review cycles are complete. Final reviewed source commit: `b895a3eca8c8b8a5eba1bfae190f92e44a04716f`. Independent code review **Approve**, security review **Pass (static prompt/config review only)**, completion review **Complete with Residuals — ready for local user review**. See [evidence.md](evidence.md) for commands, source hashes, final verdicts and pre-existing baseline failures. Model/runtime behavior and effective permission enforcement remain deferred/unverified, not passed. Contract state remains Approved delivery; implementation/reviews are complete, with user acceptance outstanding.

Next: user manually reviews the local `planned-dev` branch/worktree. It has not been merged or installed into the active dotfiles checkout; no push, PR or deployment occurred. After accepting and installing the changes, quit and restart OpenCode to load the agents/permissions. No further repair cycles or publication are authorized by this handoff.
