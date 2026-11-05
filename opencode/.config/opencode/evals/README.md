# Agent Regression Evals

This repository includes a lightweight regression harness so you can track whether agent prompt/config changes made behavior better, worse, or unchanged.

## Files

- `opencode/.config/opencode/evals/cases.json` - eval scenarios and scoring rules.
- `opencode/.config/opencode/evals/run_evals.py` - runs scenarios, scores outputs, and compares to baseline.

## Why this works

- Uses deterministic checks (`must_include`, `must_not_include`, optional `should_include`) instead of subjective memory.
- Produces machine-readable output for CI (`summary.json`) and a human-readable report (`summary.md`).
- Supports baseline comparison so you can answer: "did this change improve behavior?"

## Quick start

Run `ruby opencode/.config/opencode/evals/check_quick_dev.rb` for static quick-dev
permission, scope and review-contract regressions. These assertions check policy wiring,
not model behavior, live approval enforcement or OS sandboxing.

For the pinned worktree plugin's Git lifecycle and mocked permission-event check, see
[`../worktree-plugin.md`](../worktree-plugin.md#check-the-pinned-release). It is not a live TUI test.

Static infrastructure policy checks (Ruby stdlib only; no model/network calls):

```bash
ruby opencode/.config/opencode/evals/check_infra_policy.rb
```

These check YAML frontmatter, configured permission patterns and shared-policy wiring;
they do **not** prove OpenCode runtime enforcement or OS sandboxing. Behavioral infra
cases use the existing model-backed harness:

```bash
python3 opencode/.config/opencode/evals/run_evals.py --suite offline --only '^infra-'
```

Model-backed cases cost tokens and may load the currently installed agent configuration.
Restart OpenCode after config changes before comparing results. No infrastructure commands
are requested by these scenarios. Permission-denial integration tests must use a disposable
sandbox without cloud credentials; never use production to test denial behavior.

From your dotfiles root:

```bash
python3 opencode/.config/opencode/evals/run_evals.py --set-baseline
python3 opencode/.config/opencode/evals/run_evals.py --compare-baseline
```

## Useful flags

- `--suite offline` - run deterministic, no external Jira dependency prompts.
- `--suite live` - run prompts that expect real Jira access.
- `--only <pattern1,pattern2>` - run only matching case IDs (regex, comma-separated).
- `--jobs <n>` - run up to `n` cases in parallel.
- `--agent developer-personal` - override target primary agent.
- `--workspace <path>` - directory to run OpenCode in.
- `--out-dir <path>` - where reports are written.
- `--attach <url>` - use an existing OpenCode server instead of auto-start.
- `--timeout <seconds>` - default per-case timeout (cases may override this).

## Baseline workflow (recommended)

1. Set baseline on your current known-good config.
2. Make prompt/model/permission changes.
3. Run with `--compare-baseline`.
4. Keep changes only if score and pass counts improve (or are intentionally unchanged).

Profile-aware behavior checks:

- Offline cases include path-sensitive governance checks (for example `/betika/` requirements such as strict coverage/traceability formatting).
- Add new profile-specific cases whenever you introduce a new company profile.

## Notes

- OpenCode `run` only accepts primary agents directly. For subagent-specific checks, cases can set `invoke_subagent` and the harness prepends `@subagent` to the prompt.
- If no `--attach` is provided, the harness first tries to reuse an existing server (env URL, then `127.0.0.1:4096`) before starting a temporary one.
- Progress updates are printed every 5 seconds per case, and timed-out cases are marked as failed with `error=timeout`.

## Shared reference access

Run `ruby opencode/.config/opencode/evals/check_shared_access.rb` from the repository root. This checks the narrow global allowlist, symlink backing-path rules, unrelated-directory approval and agent edit overrides statically; it does not test runtime permissions or shell isolation. See [v2 readiness](../opencode-v2-readiness.md) before upgrading.
