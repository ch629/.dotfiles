---
name: context7-cli
description: Use the ctx7 CLI to look up current external library documentation and examples. Activate when the user asks for latest docs, current API usage, or mentions "ctx7" or "context7" for library/framework lookup.
---

# Context7 Docs Lookup

Use this skill only for retrieving up-to-date documentation from Context7.

## What this skill covers

- **[Documentation lookup](usecases/docs.md)** - Resolve a library ID and fetch current docs/snippets.

## Quick Reference

```bash
ctx7 library <name> <query>   # Step 1: resolve library ID
ctx7 docs <libraryId> <query> # Step 2: fetch docs
```

## Scope boundaries

- Do not use this skill for Context7 setup, login troubleshooting, or skill installation/generation workflows.
- If the user asks for those, route to a separate setup or skills-management skill.

## Notes

- Library IDs require a leading `/` (for example, `/facebook/react`).
- Run `ctx7 library` before `ctx7 docs` unless the user already supplied a valid Context7 library ID.
