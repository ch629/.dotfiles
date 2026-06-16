# Use Case: Workspace and Ticket Lookup

Use this when the user asks to pick up, inspect, or locate a specific Linear ticket.

## Known defaults

- `messageq` workspace -> team `MQ`
- `airecipes` workspace -> team `REC`

Prefer these defaults unless the user names a different workspace or team.

## Workspace routing

- `MQ-123` -> workspace `messageq`
- `REC-123` -> workspace `airecipes`

If the prefix matches a known workspace/team pair, skip broad discovery and query directly in that workspace.

## Goal

- Resolve the ticket quickly with the least amount of searching.
- Use a single command for known ticket keys and a single query command for keyword searches.
- Fall back to broader discovery only when the ticket ref is unclear.

## Workflow

1. If the user gives a ticket key like `MQ-123`, view it directly with one command:
   - `linear issue view MQ-123 --workspace messageq`
2. If the user gives a ticket key like `REC-123`, view it directly:
   - `linear issue view REC-123 --workspace airecipes`
3. If the user gives a keyword or partial title, search the workspace:
   - `linear issue query --workspace messageq --search "<term>" --json`
4. If the request is likely in the main team, scope to team `MQ` for tighter results:
   - `linear issue query --workspace messageq --team MQ --search "<term>" --json`
5. If the request is likely in the `REC` team, scope to team `REC` for tighter results:
   - `linear issue query --workspace airecipes --team REC --search "<term>" --json`
6. If the ticket is found and the user wants to start work, mark it started:
   - `linear issue start <issueId>`
   - or `linear issue update <issueId> --state started`
7. If the user wants it completed, mark it completed:
   - `linear issue update <issueId> --state completed`

## Lookup examples

- Inspect a known ticket:
  - `linear issue view MQ-123 --workspace messageq`
- Inspect a known ticket in the other workspace:
  - `linear issue view REC-123 --workspace airecipes`
- Search the workspace for a subject:
  - `linear issue query --workspace messageq --search "login" --json`
- Search the main team only:
  - `linear issue query --workspace messageq --team MQ --search "login" --json`
- Search the REC team only:
  - `linear issue query --workspace airecipes --team REC --search "recipe" --json`
- Get issues assigned to you in the default workspace:
  - `linear issue list --workspace messageq`

## Action examples

- Start `MQ-123`:
  - `linear issue start MQ-123`
- Start `REC-123`:
  - `linear issue start REC-123`
- Complete `MQ-123`:
  - `linear issue update MQ-123 --state completed`
- Complete `REC-123`:
  - `linear issue update REC-123 --state completed`

## Safety checks

- If the identifier is ambiguous, search first and confirm before mutating.
- If the user gives a known ticket key prefix, use the matching workspace directly; if the prefix is unknown, search before mutating.
- If search results are too broad, narrow by `--team MQ`, `--state`, or `--assignee`.
- Do not run `linear --help` or nested help commands before a direct ticket view/search unless the command fails.

## Report format

- Workspace and team used.
- Ticket key, title, status, assignee, URL.
- What action was taken or whether no match was found.
