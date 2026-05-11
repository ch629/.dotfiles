---
name: jira
description: Manage Jira work items from the CLI when users ask things like "find my open tickets", "create a bug", "move ABC-123 to In Progress", "assign these issues", or "link related tickets".
---

# Jira Skill

Use this skill when the user asks to manage Jira tickets from the CLI with `acli jira`.

## What this skill does

- Assumes Jira CLI auth is valid and proceeds directly with requested work.
- Finds, views, creates, updates, transitions, assigns, comments, and links work items.
- Uses runtime CLI help to discover exact command syntax and flags.

## When to use

Use this skill for requests like:

- "Find my open tickets"
- "Create a bug in PROJ"
- "Move ABC-123 to In Progress"
- "Assign these issues to me"
- "Add a comment and link related tickets"

## When not to use

- Do not use this skill for non-Jira systems (for example GitHub Issues, Linear, ServiceNow, Asana).
- Do not use this skill for pure planning/advice requests that do not involve Jira CLI execution.

## Runtime discovery policy

- Do not rely on hardcoded command flags or usage examples in this skill.
- Discover command syntax at runtime with help commands before executing actions.
- Prefer top-down discovery:
  - `acli jira --help`
  - `acli jira <group> --help`
  - `acli jira <group> <command> --help`
- Re-check help when switching to a new subcommand during the session.
- If a command fails due to arguments, inspect help again and retry with corrected flags.

## Description formatting policy

- When creating or editing ticket descriptions, use Jira ADF-compatible structured content only.
- Never use Markdown in ticket descriptions.
- If the description includes code, include it as a code block in the Jira-compatible format.
- Use syntax highlighting language tags when known; if unknown, use an untyped code block.

## Execution playbook

1. Validate auth context.
   - Assume auth is already valid and start with the requested Jira command flow.
   - Do not attempt to log in, log out, rotate tokens, or otherwise fix auth automatically.
   - If any command returns an auth error, stop further Jira actions and tell the user to authorize the CLI in their environment.
   - After an auth error, ask the user to confirm once authorization is fixed, then continue.

2. Resolve target work items.
   - Prefer explicit keys when provided.
   - If user gives natural language, convert it into a query and search first.
   - For broad changes, show a preview list before mutating.

3. Perform requested action.
   - Use help output to determine the correct read or mutation command.
   - Use non-interactive confirmation flags when available and intent is explicit.
   - Prefer machine-readable output modes when available.

4. Verify and report.
   - Re-run read commands with focused output fields when available.
   - Return key details: key, summary, status, assignee, and links/comments added.

## Dynamic use-case guides

Load these only when the user request matches the scenario:

- End-to-end ticket delivery from intake to implementation handoff:
  - [Ticket to PR Go delivery](usecases/ticket-to-pr-go-delivery.md)
- Triage queue and assignment flows:
  - [Triage queue](usecases/triage-queue.md)
- Create follow-up tickets and cross-link/comment flows:
  - [Create and link follow-up](usecases/create-and-link-follow-up.md)
- Bulk updates driven by JQL/filter scope:
  - [Bulk update](usecases/bulk-update.md)

Selection guidance:

- If the user asks to take a ticket from pickup through implementation readiness/PR readiness, load ticket-to-pr-go-delivery.
- If the user asks "what should I work on", "assign these", or "start these tickets", load triage.
- If the user asks to spawn a new ticket from existing work and connect them, load create-and-link.
- If the user asks to modify many tickets at once, load bulk-update.
- If a request matches multiple guides, prefer by primary intent:
  - end-to-end delivery workflow -> ticket-to-pr-go-delivery
  - queue review/ownership decisions -> triage
  - creating a new derived ticket + relationship -> create-and-link
  - one action applied to many tickets -> bulk-update

## Safety and quality rules

- Always preview before bulk mutation (`--jql`, `--filter`, or many keys).
- Require explicit user confirmation before bulk mutation when scope is more than 10 tickets.
- Prefer machine-readable output for deterministic parsing and summarization when supported.
- Use focused field selection for cleaner output when supported.
- If command syntax is uncertain, run `--help` first instead of guessing.
- Do not delete/archive tickets unless the user explicitly asks.
- Ensure all description updates follow the description formatting policy (no Markdown).
- For implementation-ready tickets, preserve traceability by keeping Jira key references in branch/commit/PR recommendations.
- Never print, store, or echo auth tokens/secrets; redact sensitive values in user-facing output.

## Output expectations for the user

After actions, report concise results:

- Count of affected tickets.
- Per-ticket minimum fields: key, summary, status, assignee, action result.
- Before/after status or assignee when relevant.
- Any skipped items and why (permissions, invalid transition, missing key).
