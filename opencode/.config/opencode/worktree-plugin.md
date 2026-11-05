# Single-session worktrees

The server plugin is pinned to [afwlehmann/opencode-worktree-plugin v0.7.0](https://github.com/afwlehmann/opencode-worktree-plugin/releases/tag/v0.7.0) in `opencode.json`, with `permissionMode: pedantic`. No TUI plugin or extra terminal is required. This is for OpenCode 1.18.x; v2 compatibility is not established.

- Use `worktree_create`, `worktree_list`, and `worktree_remove`. Names must be lowercase kebab-case, without slashes. Supply the selected refreshed remote-tracking base explicitly as `target_branch`.
- Stay in the current session. Workers must use the returned absolute worktree path for file tools and shell `workdir`; their workspace does not automatically change.
- After opening the PR, verify clean status and that HEAD is pushed, then remove the worktree. `worktree_remove` preserves its branch and refuses uncommitted files. `worktree_merge` is denied globally for our PR-only workflow; do not replace it with raw merge/delete commands.
- Pedantic mode responds to interactive external-directory requests for active Git worktrees **under the plugin's storage root**, including worker requests. It is repository-scoped, not ownership-scoped to the creating session. It does not grant shell/edit permissions or override explicit denials. Headless `opencode run` requires separate explicit approvals.
- Permissions are not a filesystem sandbox: symlink targets outside the worktree still require scrutiny. The plugin may reply `always` when suggested approval patterns are inside a worktree; existing cached session approvals are not revoked on removal. Removal prevents new active-worktree grants, not guaranteed revocation of prior approvals.
- Worktrees live under `${XDG_STATE_HOME:-~/.local/state}/opencode/worktrees/`. No broad allow for this root is added. The plugin can ask to copy an ignored/untracked `.opencode` directory; review that request, since it can include local configuration or secrets. Old file-sync and setup hooks are not migrated automatically.

## Existing installation

The old auto-discovered `~/.config/opencode/plugins/worktree.ts` must not remain active alongside the replacement: both define `worktree_create`. On this machine it is preserved as `worktree.ts.disabled`; its helper files are left untouched. On another existing installation, disable that entry point before restarting. A fresh dotfiles installation has no copy of that untracked plugin.

Restart OpenCode to load the replacement and its tool schemas. The current conversation retains the old loaded tools until restart. Restore the old filename and remove the pinned config entry to roll back; do not run both.

## Check the pinned release

Extract the release tarball into a disposable directory, then run:

```sh
bun opencode/.config/opencode/evals/check_worktree_plugin.mjs /absolute/path/to/package/dist/index.js
```

The check runs real Git create/remove operations in a temporary repository and feeds parent/worker permission events through the release's real handler with a mocked reply client. It checks dirty refusal, branch retention, and unrelated/mixed paths. It does **not** prove live TUI event delivery, explicit-deny enforcement, cached-approval revocation, or symlink isolation; smoke-test worker access after restart before relying on unattended operation.
