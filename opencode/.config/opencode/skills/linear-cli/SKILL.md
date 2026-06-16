---
name: linear-cli
description: Manage Linear projects and issues with the Linear CLI when users ask things like "find my Linear issues", "show ticket contents for LIN-123", "create a Linear task", "move LIN-123 to In Progress", "assign issues", or "update project status".
---

# Linear CLI Skill

Use this skill when the user asks to manage Linear work using the CLI.

## What this skill does

- Uses the Linear CLI for issue and project-management operations.
- Prioritizes one-command ticket lookup for inspection/search before any discovery flow.
- Applies runtime command discovery so guidance remains version-safe.
- Provides concise verification and result summaries after actions.
- When authoring Linear descriptions or long-form issue bodies, draft them in a markdown file first so formatting can be checked before submission.

## When to use

Use this skill for requests like:

- "Show my open Linear issues"
- "Create a bug in Linear"
- "Move LIN-123 to In Progress"
- "Assign these Linear tickets to me"
- "Update this Linear project status"

## When not to use

- Do not use this skill for non-Linear systems (for example Jira, GitHub Issues, Asana, Trello).
- Do not use this skill for planning-only requests that do not require CLI execution.

## Runtime discovery policy

- For ticket lookup and inspection, use the direct command immediately; do not run help first.
- Do not rely on hardcoded flags or command shapes when uncertain about mutations.
- Discover syntax top-down only when you need an unfamiliar command or a command fails:
  - `linear --help`
  - `linear <group> --help`
  - `linear <group> <command> --help`
- If a command fails due to argument mismatch, re-check help and retry with corrected flags.
- Prefer machine-readable output modes when available.

## Description drafting policy

- For issue descriptions, comments, and other rich-text content, draft the content in a markdown file before sending it to Linear.
- Use the markdown file to sanity-check headings, lists, links, and code blocks before submission.
- Keep plain scalar updates inline; reserve markdown drafting for body content where formatting matters.
- For dependency relationships, use Linear's dependency fields/links rather than adding a `Dependencies` heading in the description body.

## Ticket lookup fast path

- If the user gives a ticket key, inspect it with one command and no preflight help.
- If the user gives a search term, issue one search command before asking for clarification.
- Only fall back to broader discovery when the ticket reference is missing or ambiguous.

## Auth and execution policy

- Assume auth is already configured and proceed with requested work.
- Do not auto-run login/logout/token repair unless the user explicitly asks.
- If auth fails, stop mutations, report the auth failure, and ask the user to re-authenticate.

## Execution playbook

1. Validate CLI context and workspace/team scope when needed.
2. Resolve target entities (issues, projects, cycles, users) using read commands first.
3. Preview scope before broad or bulk mutations.
4. Execute requested mutation with explicit, non-interactive flags when intent is clear.
5. Verify by re-reading state and report outcomes.

## Common command patterns

Use these first when the user already knows the general task.

### Find or inspect a ticket

- View a known ticket directly:
  - `linear issue view <issueId> --workspace <workspace-slug>`
- List your own issues:
  - `linear issue list --workspace <workspace-slug>`
- Search issues by keyword:
  - `linear issue query --workspace <workspace-slug> --search "<term>" --json`
- Filter by team, state, or assignee:
  - `linear issue query --workspace <workspace-slug> --team <team-key> --state unstarted --assignee <username> --json`
- View a specific issue:
  - `linear issue view <issueId>`
- Print a ticket URL:
  - `linear issue url <issueId>`

### Move a ticket to In Progress

- Fast path when you know the issue id:
  - `linear issue start <issueId>`
- Explicit update path:
  - `linear issue update <issueId> --state started`

### Complete a ticket

- Mark done with the update command:
  - `linear issue update <issueId> --state completed`

### Workspace scope

- Target a specific workspace with:
  - `--workspace <workspace-slug>`

Examples:

- `linear issue query --workspace messageq --search "login" --json`
- `linear issue view MQ-123 --workspace messageq`
- `linear issue start MQ-123`
- `linear issue update MQ-123 --state completed`

## Dynamic use-case guides

Load these only when the request matches:

- Workspace defaults and ticket lookup for the active workspace/team:
  - [Workspace and ticket lookup](usecases/workspace-and-ticket-lookup.md)
- Personal queue and assignment workflows:
  - [Triage and assignment](usecases/triage-and-assignment.md)
- Creating issues and linking to existing work:
  - [Create and link issues](usecases/create-and-link-issues.md)
- Project/cycle status updates and planning hygiene:
  - [Project and cycle updates](usecases/project-and-cycle-updates.md)
- Bulk operations across filtered issue sets:
  - [Bulk issue updates](usecases/bulk-issue-updates.md)

Selection guidance:

- User asks to pick up, inspect, or find a specific ticket -> workspace and ticket lookup.
- User asks "what should I work on", "assign these", or "start these" -> triage and assignment.
- User asks to create a follow-up task and connect it to existing work -> create and link issues.
- User asks to update project/cycle progress, status, or milestones -> project and cycle updates.
- User asks to apply one change to many issues -> bulk issue updates.

## Safety and quality rules

- Always preview affected items before bulk mutation.
- Require explicit user confirmation before bulk mutations affecting more than 10 issues.
- Prefer focused fields over full object dumps for deterministic summaries.
- Never delete/archive entities unless explicitly requested.
- Never expose tokens, secrets, or sensitive configuration values.

## Output expectations for the user

After actions, report concise results with:

- Workspace/team/project context used.
- Count of affected entities.
- Per-entity key fields (identifier, title, status, assignee, URL).
- Any skipped/failed items and why.
