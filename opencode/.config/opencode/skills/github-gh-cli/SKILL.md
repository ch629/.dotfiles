---
name: github-gh-cli
description: Manage GitHub repositories, pull requests, and Actions workflows with the gh CLI when users ask things like "open a PR", "check workflow runs", "view repo details", or "review PR status".
---

# GitHub GH CLI Skill

Use this skill when the user asks to work with GitHub via the `gh` CLI.

## What this skill does

- Uses `gh` to inspect and update repositories, pull requests, and workflow runs.
- Applies discovery-first command execution so syntax stays accurate across `gh` versions.
- Reports concise, decision-ready results after each action.

## When to use

Use this skill for requests like:

- "Create a PR from this branch"
- "Show open PRs assigned to me"
- "Check failed GitHub Actions workflows"
- "View this repo's default branch and settings"
- "Rerun the failed workflow for this commit"

## When not to use

- Do not use this skill for non-GitHub systems (GitLab, Bitbucket, Jira, Linear).
- Do not use this skill for requests that do not involve CLI execution.

## Runtime discovery policy

- Do not assume flags or command shape from memory when uncertain.
- Discover commands top-down before execution:
  - `gh --help`
  - `gh <group> --help`
  - `gh <group> <command> --help`
- If a command fails due to arguments, re-check `--help` and retry.
- Prefer structured output (`--json`, `--jq`, or `gh api`) for deterministic summaries.

## Data minimization policy

- Fetch only the fields needed to complete the current user request.
- Prefer narrow output selectors over full object dumps:
  - `--json <field1,field2>` for `gh` resource commands.
  - `--jq '<filter>'` to project only required values.
  - `gh api` with query params (`-f`/`-F`) for server-side filtering when supported.
- Limit scope early (repo, branch, state, author, workflow, run id, date range) before retrieving results.
- Use pagination/limits conservatively (`--limit`, page size, or endpoint parameters) and avoid requesting all pages unless required.
- If full payloads are needed for debugging, state why and summarize only relevant fields in user-facing output.

## Auth and context policy

- Validate auth and host context before mutating state:
  - `gh auth status`
- Confirm target repo context before write actions:
  - `gh repo view`
- Do not attempt login/logout/token repair automatically unless the user asks.

## Execution playbook

1. Validate auth and repo context.
2. Resolve the target entities (repo, PR, run, workflow) using read commands first.
3. Preview scope before broad or repeated mutations.
4. Execute requested action with non-interactive flags when intent is explicit.
5. Verify by re-reading relevant state and report outcomes.

## Dynamic use-case guides

Load these only when the request matches the scenario:

- Jira-linked branch/commit/PR traceability conventions:
  - [Jira traceability](usecases/jira-traceability.md)
- Repository discovery and settings inspection:
  - [Repository operations](usecases/repository-operations.md)
- Pull request creation, review checks, and status workflows:
  - [Pull request workflows](usecases/pull-request-workflows.md)
- Pull request review comment analysis with `gh-pr-review` extension:
  - [PR review comments](usecases/pr-review-comments.md)
- GitHub Actions workflow and run investigation:
  - [Workflow operations](usecases/workflow-operations.md)

Selection guidance:

- User asks for branch naming, commit conventions, or PR templates tied to Jira keys -> jira traceability.
- User asks about branches, visibility, metadata, remotes, or repo configuration -> repository operations.
- User asks to open, review, merge, or inspect PRs -> pull request workflows.
- User asks to summarize or inspect PR review comments at scale -> PR review comments.
- User asks about Actions status, logs, failures, reruns, or workflow health -> workflow operations.
- If a request spans multiple areas, load the guide that matches the primary intent first, then load others as needed.

## Safety and quality rules

- Prefer read-only commands before mutations to avoid acting on the wrong target.
- For potentially high-impact actions (merge, close, rerun across many runs), show what will change first.
- Require explicit user confirmation before bulk mutations affecting more than 10 items.
- Apply data minimization on every read/query; do not request full records when targeted fields are sufficient.
- For Jira-linked delivery, keep Jira key in branch names, commit subjects, and PR titles/bodies where team conventions allow.
- Never expose tokens, secrets, or sensitive config values.
- If repo ownership or host is ambiguous, resolve and state it before mutating.

## Output expectations for the user

After actions, report concise results with:

- Target repo and branch context used.
- Count of entities affected (PRs, runs, workflows, repos).
- Key per-entity fields (number/name, state/conclusion, URL).
- Any skipped/failed items and why.
