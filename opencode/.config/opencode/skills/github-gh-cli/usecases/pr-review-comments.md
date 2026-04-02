# Use Case: PR Review Comments

Use this when the user asks to inspect, summarize, triage, reply to, or resolve pull request review comments using the `gh-pr-review` extension.

## Typical triggers

- "Show me unresolved PR review comments"
- "Summarize review feedback on this PR"
- "List review comments I still need to address"
- "Check review discussion status before merge"
- "Reply to this review thread"
- "Resolve this thread after my fix"

## Workflow

1. Confirm repo/auth context (`gh auth status`, `gh repo view`).
2. Ensure extension availability and discover syntax:
   - `gh extension list`
   - `gh pr-review --help` (or extension-specific help path)
3. Resolve target repo and PR number:
   - Use `scripts/get-current-repo.sh` and `scripts/get-current-pr-number.sh` when context is current repo/branch.
   - If no PR is associated with current branch, ask for explicit PR number.
4. Run extension commands with filters/flags to limit results to required comments only.
5. For mutation actions, require explicit thread/review IDs and perform the exact requested action.
6. Summarize actionable feedback (open threads, requested changes, blocker themes) with links when available.

## Core command patterns

- Inspect review threads with filtering:
  - `gh pr-review review view -R <owner/repo> --pr <number> --unresolved --not_outdated`
  - Add narrow filters as needed: `--reviewer <login>`, `--states <state-list>`, `--tail <n>`.
- Reply to a specific thread:
  - `gh pr-review comments reply -R <owner/repo> <number> --thread-id <thread-id> --body "<message>"`
- List unresolved threads:
  - `gh pr-review threads list --unresolved -R <owner/repo> <number>`
- Resolve or unresolve a thread:
  - `gh pr-review threads resolve --thread-id <thread-id> -R <owner/repo> <number>`
  - `gh pr-review threads unresolve --thread-id <thread-id> -R <owner/repo> <number>`
- Pending review flow when requested:
  - Start review: `gh pr-review review --start -R <owner/repo> <number>`
  - Add inline comment: `gh pr-review review --add-comment --review-id <PRR_id> --path <file> --line <line> --body "<message>" -R <owner/repo> <number>`
  - Submit review: `gh pr-review review --submit --review-id <PRR_id> --event <APPROVE|REQUEST_CHANGES|COMMENT> --body "<message>" -R <owner/repo> <number>`

## Identifier handling

- Treat IDs as typed and do not interchange them:
  - Pending review IDs: `PRR_...` (used by `review --add-comment` and `review --submit`).
  - Review thread IDs: `PRRT_...` (used for thread replies in `comments reply`).
- Obtain IDs from extension output instead of guessing.
- If an ID format is rejected, re-read command help and refresh IDs from a read command.

## Safety checks

- Do not post, edit, or resolve review comments unless explicitly requested.
- If extension is missing, report the exact install command and wait for user confirmation before continuing.
- Keep output scoped to requested reviewers, states, or thread status to avoid noisy dumps.
- For destructive discussion-state changes (resolve/unresolve in bulk), preview targets and require confirmation when scope is large.

## Helpful install command

- `gh extension install agynio/gh-pr-review`
