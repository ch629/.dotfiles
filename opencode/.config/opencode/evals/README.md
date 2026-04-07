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
- `--agent developer-primary` - override target primary agent.
- `--workspace <path>` - directory to run OpenCode in.
- `--out-dir <path>` - where reports are written.
- `--attach <url>` - use an existing OpenCode server instead of auto-start.
- `--timeout <seconds>` - default per-case timeout (cases may override this).

## Baseline workflow (recommended)

1. Set baseline on your current known-good config.
2. Make prompt/model/permission changes.
3. Run with `--compare-baseline`.
4. Keep changes only if score and pass counts improve (or are intentionally unchanged).

## Notes

- OpenCode `run` only accepts primary agents directly. For subagent-specific checks, cases can set `invoke_subagent` and the harness prepends `@subagent` to the prompt.
- If no `--attach` is provided, the harness first tries to reuse an existing server (env URL, then `127.0.0.1:4096`) before starting a temporary one.
- Progress updates are printed every 5 seconds per case, and timed-out cases are marked as failed with `error=timeout`.
