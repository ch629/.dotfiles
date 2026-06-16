# Use Case: Create and Link Issues

Use this when the user asks to create new Linear issues and connect them to existing work.

## Goal

- Create complete, actionable issues.
- Preserve relationships and traceability.
- Avoid duplicate or incorrectly linked work.

## Workflow

1. Resolve target team/project and parent/related issue identifiers.
2. Draft issue payload with clear title, description, priority, and assignee where provided.
3. If the description or body needs formatting, compose it in a markdown file first so headings, lists, links, and code blocks can be checked.
4. Create the new issue.
5. Add parent/sub-issue/related links as requested.
6. Verify by reading both the new issue and linked issue summaries.

## Quality checks

- Ensure links reflect user intent (blocks, related, duplicate, parent/child).
- Prevent linking to wrong targets by confirming ambiguous IDs first.
- If rich-text formatting constraints exist in the target, follow Linear-native formatting expectations.
- Prefer drafting Linear descriptions in a markdown file before submission whenever formatting matters.
- When adding dependencies, use Linear's dependency fields/links and do not model them as a `Dependencies` heading in the description.

## Report format

- New issue identifier and URL.
- Linked issue identifiers and relationship types.
- Any fields skipped because input was missing.
