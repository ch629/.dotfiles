---
name: agent-builder
description: Builds and refactors opencode primary agents and subagents with clear scope, strong trigger rules, explicit permissions, and testable response contracts. Use when users ask to create, split, harden, or standardize agent/subagent definitions.
license: MIT
metadata:
  author: OpenCode
  version: 1.0.0
  category: developer-productivity
  tags:
    - agents
    - subagents
    - prompt-engineering
    - governance
---

# Agent Builder

Use this skill when the user asks to create or modify opencode agents/subagents.

## What this skill does

- Creates clean agent files with valid frontmatter and focused prompts.
- Splits overloaded prompts into reusable playbooks and keeps base prompts lean.
- Defines delegation boundaries, permissions, and response contracts explicitly.
- Adds practical quality gates (verification, review loops, and stop conditions).

## Core best practices

- Keep agent responsibilities narrow; avoid "do everything" prompts.
- Prefer simple, composable workflows before adding complex orchestration.
- Route by task type (research, planning, implementation, validation) and by risk.
- Make success criteria explicit: expected output format, evidence, and next actions.
- Prefer transparent behavior over hidden heuristics; surface assumptions and unknowns.
- Add guardrails for autonomy: bounded loops, clear escalation points, and failure exits.

## Authoring standards for agent files

- Use valid frontmatter with `description` and `mode` always present.
- Set `mode` intentionally:
  - `primary` for top-level orchestration agents.
  - `subagent` for specialized delegated workers.
  - `all` only when intentional.
- Keep prompts structured with stable sections:
  - Mission
  - Scope boundaries
  - Delegation rules
  - Execution policy
  - Response contract
  - Definition of done
- Keep policy-like rules centralized; avoid contradictory statements across agents.

## Permission and safety policy

- Deny all `task` targets by default, then allow only explicit subagents.
- Align permissions with mission (reviewers should not need broad edit rights unless required).
- Require explicit "ask user" behavior for ambiguous scope, mixed language targets, or missing governance inputs.
- For high-risk domains, define mandatory review/validator passes and maximum recheck loops.

## Dynamic use-case guides

Load only what matches the request:

- Create a new primary agent:
  - [New primary agent scaffold](usecases/new-primary-agent.md)
- Create a specialized subagent:
  - [New subagent scaffold](usecases/new-subagent.md)
- Split an overloaded agent into playbooks/subagents:
  - [Split and modularize agent prompts](usecases/split-agent-prompt.md)
- Harden governance and safety gates:
  - [Governance and safety hardening](usecases/governance-hardening.md)

## Quality checklist

- Trigger behavior is specific (what + when), not generic.
- Delegation map is explicit and non-overlapping.
- Permission surface is least-privilege.
- Response contract is testable and consistent.
- Review/validation loops have bounded retries and clear stop behavior.
- Agent instructions do not conflict with repository governance rules.

## Source-informed notes

- Agent architecture guidance follows widely used patterns: start simple, route tasks deliberately, and introduce evaluator/review loops only where they improve outcomes.
- Tool and interface clarity is prioritized: explicit, unambiguous instructions outperform clever but implicit phrasing.
