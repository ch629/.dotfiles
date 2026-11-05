# Worktree lifecycle

- When a task needs a new worktree, use the configured `worktree_create` tool, not raw `git worktree add`, custom directory layouts, or the retired terminal/fork plugin. Do not create a worktree for tasks that do not need one.
- Pass `repo_short`, a unique lowercase kebab-case `source_branch` (include the ticket key and stream slug when applicable), and explicit `target_branch` for the selected base. Refresh a remote-tracking base before creation; do not assume `origin/main`.
- Record those arguments and the returned absolute path. Keep the current conversation; do not open terminals or fork sessions. Pass the path to every worker; use absolute file paths and shell `workdir` inside it.
- Use `worktree_list` to rediscover existing trees. Reuse an existing task worktree only after verifying its repository, branch, and status; do not silently replace it.
- Pedantic automatic external-directory approval applies to active plugin-managed trees in interactive sessions. It does not grant shell/edit authority or isolate credentials. If tools or approval are unavailable, stop and request help or exact-path approval rather than silently falling back to raw Git or broad global allowances.
- After a PR is opened, verify the worktree is clean and HEAD is pushed before `worktree_remove` with the original `repo_short` and `source_branch`. Preserve dirty work and report blockers; never force-remove, snapshot-commit leftovers, or use the obsolete `worktree_delete` tool.
- Removal preserves the branch. Leave it intact unless the user explicitly requests branch deletion. `worktree_merge` remains denied for the PR-only workflow; do not substitute raw merges.

These are workflow instructions, not an OS sandbox or a guarantee against shell bypasses. See `worktree-plugin.md` for installation and approval-cache limitations.
