# Routing extension evidence v2

## Source and target

Date: 2026-11-05. Every shell command used exactly this working directory:
`/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-routing-extension`.
Initial status: clean. HEAD: `2c5525bb70f63f893a82093dc77797498d8b826b`;
tree: `f38a551c04999ce51e0f8a272527cb715f156a50`. Target: local OpenCode
agent prompt bodies, not remote infrastructure. No concern playbook applies.

Before any edits, these commands exited 0:

```sh
git status --short
git rev-parse HEAD
git diff 0bbac5bebffb5b475f4ed4ade9f8ae089ef95586 HEAD -- opencode/.config/opencode/agents opencode/.config/opencode/evals
git diff --exit-code 0bbac5bebffb5b475f4ed4ade9f8ae089ef95586 HEAD -- opencode/.config/opencode/agents opencode/.config/opencode/opencode.json opencode/.config/opencode/evals/cases.json opencode/.config/opencode/evals/run_evals.py
git rev-parse HEAD^{tree}
opencode --version
```

The exit-code diff was empty: agent configuration, main configuration, cases and
runner are identical to test commit `0bbac5bebffb5b475f4ed4ade9f8ae089ef95586`.
Later provenance checks (exit 0):

```sh
git diff --name-only 0bbac5bebffb5b475f4ed4ade9f8ae089ef95586 2c5525bb70f63f893a82093dc77797498d8b826b -- opencode/.config/opencode
git ls-tree 2c5525bb70f63f893a82093dc77797498d8b826b opencode/.config/opencode/agents opencode/.config/opencode/opencode.json opencode/.config/opencode/evals/cases.json opencode/.config/opencode/evals/run_evals.py
```

Only eval README, static delivery check and delivery policy differ between those
commits. Immutable source objects:

| Input | Git object |
| --- | --- |
| agents tree | `45bab2d500ebedba3654869979ccc5181781df85` |
| cases.json | `0543bc8e242214ef179c0b9ffffdbb7a32ed38d8b` |
| run_evals.py | `c30b6ba3b0bd97d0cb92cfc24ea5cd6a94b34404` |
| opencode.json | `034c6afddec6e041b65cc640077b00c2a19beb0b` |

## One bounded pre-edit readiness diagnosis

OpenCode version `1.18.34`. A Python subprocess wrapper copied the process
environment, set only `OPENCODE_CONFIG_DIR` to this worktree's
`opencode/.config/opencode`, selected a free loopback port with a socket bind,
started its own server, waited three seconds and ran one client with a 45-second
timeout. In `finally` it terminated and waited for that server (10-second cleanup
timeout). Wrapper exit 0 means cleanup completed, not readiness success.
Exact subprocess commands:

```sh
OPENCODE_CONFIG_DIR=/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-routing-extension/opencode/.config/opencode opencode serve --hostname 127.0.0.1 --port 51353
OPENCODE_CONFIG_DIR=/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-routing-extension/opencode/.config/opencode opencode run --attach http://127.0.0.1:51353 --agent product-planner-personal --dir /Users/charliehowes/.local/state/opencode/worktrees/dotfiles-workflow-pilot-routing-extension --format default 'Use no tools, files, tickets, or external services. Reply BASELINE_READY only.'
```

Configured readiness agent/model: `product-planner-personal`, `openai/gpt-4.1-mini`.
No model override or substitution. Successful effective configuration/provider/model
loading is **not established**. Global configuration/environment isolation beyond the
explicit worktree config directory is not proven; no credential or secret inspection
was performed. No stale server was used, permissions changed or runtime repair tried.

Sanitized captured server output (exit -15 after deliberate SIGTERM):

```text
Warning: OPENCODE_SERVER_PASSWORD is not set; server is unsecured.
opencode server listening on http://127.0.0.1:51353
```

Client stdout empty; stderr (ANSI styling removed), exit 1:

```text
Error: {
  "name": "UnknownError",
  "data": {
    "message": "Unexpected server error. Check server logs for details.",
    "ref": "err_82a24134"
  }
}
```

Diagnosis stops here. Startup/listening succeeded; no model output or root cause
was obtained. No broad log/credential reads or additional probes. Genuine ten-case
baseline: **Blocked / not run**. Fresh post-change comparison: **Blocked / not run**
because no genuine baseline exists. No baseline file was created or overwritten;
no synthetic failures, invented transcripts, improvement claim or full behavioral
sign-off. Prior baseline-v1.md and verification-v1.md are unchanged.

Semantic assessment: no model response exists to assess. Regex/static success cannot
demonstrate artifact persistence, dirty preservation, cross-session resumption or
enforced permission denial. Those remain unverified and need separately authorized
disposable integration evaluation. A future model run must retain immutable source
identity, actual transcripts, semantic assessment and fresh-server provenance for
both baseline and candidate; never compare against a blocked placeholder.

## Static validation

Versions (each version command exited 0): `python3 --version`: Python 3.15.2;
`ruby --version`: ruby 2.6.10p210 (universal.arm64e-darwin26);
`git --version`: git 2.56.0. The following exact commands were run with individual
exit codes captured by a Python subprocess wrapper; all exited 0:

```sh
ruby opencode/.config/opencode/evals/check_delivery_workflow.rb
ruby opencode/.config/opencode/evals/check_quick_dev.rb
ruby opencode/.config/opencode/evals/check_shared_access.rb
ruby opencode/.config/opencode/evals/check_infra_policy.rb
python3 -m json.tool opencode/.config/opencode/evals/cases.json /dev/null
python3 -m json.tool opencode/.config/opencode/opencode.json /dev/null
git diff --check
```

```text
Delivery workflow static checks: 92/92 passed; 0 failed.
Static prompt contracts only; model behavior and integration are not evaluated.
Quick-dev policy checks passed (permissions, scope, verification, snapshot review).
Shared access checks passed (aliases, backing paths, unrelated paths, agent overrides).
Infrastructure policy checks passed (frontmatter, configured shell rules, shared policy, eval cases).
```

JSON and whitespace checks were silent. Initial red result supplied by test-writer:
70/92 failed; first post-edit run passed 92/92. No test assertions were changed.
Runner unchanged; conditional Python unit tests not applicable. Build not applicable
to Markdown prompt/documentation changes; no compiled/build inputs changed.

AC mapping: the four primaries now carry revision-bound resumption/authority and
manual handoff rules; planner/orchestrator enforce state and persistence behavior;
five downstream stages accept ticketless briefs and preserve path/revision identity.
Ticketed completion reconciles the once-fetched original source rather than repeating
Linear lookup. Quick-dev keeps the ordinary direct bounded path. All nine ordered
permission-map snapshots pass; frontmatter has not been edited.

## Commit binding and limits

Before commit, inspect status, full diff and recent subjects, stage only the nine
agent files and three pilot files, rerun the checks, and record `git write-tree` in
the implementation report. After commit confirm `HEAD^{tree}` equals that staged
tree and `git diff --exit-code HEAD`/status are clean before binding checks to HEAD.
The immutable implementation commit contains this evidence; do not rewrite earlier
pilot records to imply a successful baseline. Publication remains the orchestrator's
responsibility and was not performed. Independent review remains pending.
