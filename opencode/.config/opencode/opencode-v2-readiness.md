# OpenCode v2 readiness

Research snapshot: 2026-11-05. Installed version: **1.18.34**. Evaluated v2 release: **2.2.5** (2026-10-30). This PR does **not** upgrade the binary or port plugins.

## Recommendation

Stay on v1 until the plugin and evaluation harness migration is tested. Keeping the existing supported config/agent/skill syntax initially is fine: v2 normalizes legacy configuration in memory without rewriting the files. A wholesale config rewrite is not a prerequisite.

| Area | Impact on this setup / required action |
| --- | --- |
| Plugins — blocker | V1 implementations do not run on v2. Confirm v2-compatible releases of notifier and DCP. Port local strip-top-p, ponytail, permission-audit and worktree integrations. V2 uses `@opencode/plugin` with `Plugin.define`/`setup`; configured local plugins resolve directories/entrypoints rather than the old `.ts` file entries. Renaming files is not a port. |
| Server API — blocker | The evaluation harness uses the v1 server API. Port/verify against the v2 client/API before treating its results as evidence. |
| External access | V2 defaults `external_directory` to **allow**. Keep the explicit global `* : ask` followed by narrow reference allowlists. Agent/project rules can override these; this is not an administrative sandbox. |
| TUI | Global supported `tui.json` settings migrate to a single global `cli.json`; project-local TUI settings do not migrate. Review the result. |
| Model settings | Agent `temperature`, `top_p` and `options` no longer configure generation; use model variants. Audit the local wrapper/provider capability fields and warnings. |
| Verification | V2 does not run LSP servers/tools/diagnostics even if legacy `lsp` config is retained. Use explicit compiler, lint and typecheck commands. |
| Workflow assumptions | Todos require `experimental.todo`; old compaction `tail_turns`/`prune` settings are ignored. Audit plugins against the new compaction and tool hooks. `CLAUDE.md` fallback discovery is not currently supported; use `AGENTS.md`. |

## Safe migration sequence

1. Back up v1 binary/version, config, TUI settings and plugin pins; record how to restore them. Both versions normally install as `opencode`, so do not overwrite the working install for an experiment.
2. Test a pinned v2 binary in an isolated environment with copied configuration and no production credentials. Port/disable incompatible plugins explicitly; verify both providers and a basic edit/test session.
3. Exercise shared-reference reads, write approval, unrelated-directory approval, reviewer shell denial, delegation, permission audit, worktree lifecycle and evaluation API behavior. Static policy checks alone do not prove runtime enforcement.
4. Run representative small code and infrastructure tickets, including missing evidence and stale-review cases. Check cost, latency, blocked states and recovery, not just successful output.
5. Upgrade the normal installation only after those checks pass; retain a tested rollback. Review auto-migrated CLI settings, then restart OpenCode.

## Shared access added by this PR

Global external-directory allowances cover only agent definitions, shared playbooks/policies/prompts and skills, including `~/.claude/skills` and this dotfiles checkout's backing paths. Other external paths default to asking, subject to existing agent-specific exceptions such as worktrees and scripts. The default agent's blanket OpenCode-directory allowance is removed. Native edits to the shared references ask (read-only agents still deny); redundant agent-wide edit allowances are removed so they cannot override that policy. Ordinary repository editing retains its default behavior.

This reduces repeated reference-access prompts; it does **not** make those directories read-only to shell commands, plugins or arbitrary code. Existing saved approvals and project/agent overrides also affect effective permissions. No shell allowlist is expanded. Restart OpenCode to load the configuration; use `/audit-permissions` to identify remaining repeated requests rather than broadly allowing all of `.claude` or the OpenCode config directory.

## Sources

- [v2.2.5 release](https://github.com/anomalyco/opencode/releases/tag/v2.2.5)
- [Version-pinned v1 migration guide](https://github.com/anomalyco/opencode/blob/v2.2.5/services/www/src/docs/content/migrate-v1.mdx)
- [Version-pinned plugin migration](https://github.com/anomalyco/opencode/blob/v2.2.5/services/www/src/docs/content/build/plugins/migrate-v1.mdx)
- [Version-pinned v2 permission semantics](https://github.com/anomalyco/opencode/blob/v2.2.5/services/www/src/docs/content/permissions.mdx)
- [Installed v1 permission implementation](https://github.com/anomalyco/opencode/blob/v1.18.34/packages/opencode/src/permission/index.ts)
