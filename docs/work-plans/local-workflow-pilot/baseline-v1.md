# Workflow planning pilot: pre-contract baseline v1

## Identity and result

- Baseline configuration SHA: `4470628067697152ab4e0e0425e7bd4790741edf`
  (`origin/ai` starting point); branch `workflow-pilot-phase-one`.
- Worktree: `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one`.
- OpenCode binary: `/Users/charliehowes/.opencode/bin/opencode`; version `1.18.34`.
- Target: `product-planner-personal`; configured model `openai/gpt-4.1-mini`.
- **Blocked / behavioral cases not run. No demonstrated red model result.**
  A fresh-server readiness probe exited 1 without model output:
  `UnknownError: Unexpected server error. Check server logs for details.`,
  reference `err_d4eb727f`. This is a runtime blocker, not a failed contract assertion.
- `opencode models` succeeded but did not list the configured
  `openai/gpt-4.1-mini` (the distinct OpenRouter model was listed).
  Model listing does not verify credentials or inference. The server error's root
  cause was not established; do not label it a confirmed credential failure.
- No fallback model, existing server, credential inspection, ticket operations,
  or implementation changes were used. Initial Git status was clean.

## Preflight commands

All commands ran with the worktree above as the explicit shell working directory.
These are the subprocess commands used by the readiness probe (a Python wrapper
selected a free loopback port, waited three seconds, bounded the client to 45
seconds, and terminated/waited for its server in `finally`):

```sh
command -v opencode
opencode --version
opencode models
OPENCODE_CONFIG_DIR=/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode opencode serve --hostname 127.0.0.1 --port 50917
OPENCODE_CONFIG_DIR=/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode opencode run --attach http://127.0.0.1:50917 --agent product-planner-personal --dir /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one --format default 'Use no tools, files, tickets, or external services. Reply BASELINE_READY only.'
```

The explicit config directory requested the pre-contract worktree configuration;
the failed probe does not establish successful agent/config loading. No behavioral
baseline JSON was created or overwritten with synthetic failures.

## AC coverage

All names below have the `workflow-` prefix in `cases.json`.

| Acceptance criterion | Cases |
| --- | --- |
| Contract field coverage and unknown paths/commands (empty and no-match boundaries are not explicitly asserted) | `ticketless-contract-fields`, `ticketed-compatibility` |
| Discovery / Proposed delivery / Blocked / Approved delivery / Superseded, revision-bound approval and renewal | `discovery-empty-requirements`, `ticketless-contract-fields`, `blocked-missing-evidence`, `approved-current-revision`, `superseded-approval-renewal`, `ambiguous-approval-not-delivery` |
| Discoverable repo-local versioned artifact; ticketless path-plus-summary resumption | `ticketless-resume-path-summary`, `dirty-artifact-preservation` |
| Planning approval is not publication authority; manual handoff when permissions deny | `approved-current-revision`, `permission-denied-manual-handoff` |
| Representative scenarios and honest unavailable-model evidence | All ten cases; `blocked-missing-evidence`; this blocked baseline |
| Ticketed compatibility and dirty preservation | `ticketed-compatibility`, `dirty-artifact-preservation` |

The cases deliberately use the existing regex runner, not a new framework. They
are text-only scenario probes: they cannot prove actual artifact persistence,
cross-session loading, permission enforcement, absence of tool calls, or dirty-tree
preservation. They do not execute the hypothetical app's tests. Inspect transcripts
for negation, echoed expectations, invented evidence and semantic correctness:
regex matches alone are not behavioral sign-off. Artifact lifecycle and enforced
denials still need a separately authorized disposable-sandbox integration exercise.
The field probe checks semantic categories, not an invented exact serialization;
implementation must separately audit the final contract's complete field inventory.

## Static validation performed

Passed:

```sh
python3 -m json.tool /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/cases.json /dev/null
ruby /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/check_quick_dev.rb
ruby /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/check_shared_access.rb
git diff --check
```

An inline Python check imported the existing runner with bytecode writes disabled,
used `load_cases`, `filter_cases(..., 'offline')` and
`filter_cases_by_id(..., '^workflow-')`, and verified exactly ten selected cases,
unique IDs, supported runner keys, nonempty prompts/assertions, compilation of all
regexes with `re.IGNORECASE`, and rejection of empty output by `score_output`.
It also compared all non-workflow cases to `git show
4470628067697152ab4e0e0425e7bd4790741edf:opencode/.config/opencode/evals/cases.json`:
all preexisting cases remain identical. Empty-output rejection is a scorer sanity
check, **not** a red baseline against the old agent.

## Resume the blocked baseline

Resolve the fresh-server error and verify the configured model and authorized
credentials without printing secrets. Start a new server with this baseline
configuration and explicitly attach to its fresh loopback URL; do not use the
runner's default server discovery, which can reuse a stale server. Do not silently
substitute a model. Record any authorized model/config change as a separate baseline.

With a verified fresh server on port 50917 (otherwise replace that URL), run:

```sh
python3 /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/run_evals.py --cases /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/cases.json --suite offline --only '^workflow-' --workspace /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one --attach http://127.0.0.1:50917 --out-dir /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-phase-one/opencode/.config/opencode/evals/results/workflow-pre-contract-v1
```

That eval command is a **pending** step, not an executed result. Retain transcripts,
inspect semantic failures, and capture baseline only after genuine model output.
If implementation has already landed, the old configuration SHA must be restored
in an isolated approved environment rather than calling the new state pre-contract.
