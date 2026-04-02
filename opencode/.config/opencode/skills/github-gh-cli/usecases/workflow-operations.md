# Use Case: Workflow Operations

Use this when the user asks to inspect, debug, or rerun GitHub Actions workflows and runs.

## Typical triggers

- "Show recent failed workflow runs"
- "Why did this run fail?"
- "Rerun this workflow"
- "List workflows for this repo"

## Workflow

1. Confirm target repo context (`gh repo view`).
2. Discover Actions command syntax (`gh run --help`, `gh workflow --help`).
3. Enumerate workflows/runs with filtered queries and narrow to the target by workflow name, branch, commit, or run id.
4. Inspect run metadata and logs before rerunning when diagnosing failures.
5. Execute requested action (rerun/cancel/watch/download logs) with explicit target ids.
6. Re-check run status and summarize conclusion, failing job(s), and links.

## Safety checks

- Do not rerun/cancel many runs without preview and user confirmation.
- Be explicit about which run/workflow id is being acted on.
- If logs are unavailable due to permissions/retention, report that clearly.
