---
name: skill-builder
description: Builds, refactors, and standardizes skills with clear frontmatter, concise core guidance, progressive disclosure, and testable trigger behavior. Use when users ask to create a new skill, split a large SKILL.md, retrofit CLI guidance, or enforce formatting policies for external systems.
license: MIT
metadata:
  author: OpenCode
  version: 1.1.0
  category: developer-productivity
  tags:
    - skills
    - skill-authoring
    - refactoring
---

# Skill Builder

Use this skill when the user asks to create, refactor, or standardize other skills.

## What this skill does

- Creates reusable skill scaffolds that are domain-agnostic.
- Keeps core guidance in `SKILL.md` and moves scenario-specific flows into separate files.
- Adds explicit trigger-oriented descriptions and selection guidance.
- Enforces structure, formatting, and validation guardrails so skills stay resilient.

## Core standards

- Keep `SKILL.md` concise and stable; move heavy examples and workflows to use-case files.
- Use relative markdown links for internal references.
- Make selection guidance explicit so only relevant use-case docs are loaded.
- Prefer clear, actionable instructions and concrete trigger phrases over vague wording.

## Frontmatter and trigger rules

- Require YAML frontmatter in `SKILL.md` for every skill being created or retrofitted.
- Ensure required fields are present and valid:
  - `name`: kebab-case, ideally matches folder name.
  - `description`: includes both what the skill does and when to use it.
- Description quality rules:
  - Include likely user phrasing and task triggers.
  - Stay specific enough to avoid over-triggering.
  - Avoid generic descriptions such as "helps with projects".
- Keep frontmatter safe and parseable:
  - No XML-like angle bracket content in frontmatter.
  - Keep formatting valid YAML with opening and closing delimiters.

## Formatting policy

- Follow the target system's native formatting format for structured content.
- Do not use Markdown when the target system expects a different rich text format.

## Dynamic use-case guides

Load these only when the request matches:

- Create a new skill scaffold:
  - [Scaffold new skill](usecases/scaffold-new-skill.md)
- Split a large skill into dynamic references:
  - [Extract use cases](usecases/extract-usecases.md)
- Add or standardize formatting rules for external systems:
  - [Formatting policy retrofit](usecases/formatting-policy-retrofit.md)
- Create or retrofit CLI-execution skills:
  - [CLI skill creation](usecases/cli-skill-creation.md)

Selection guidance:

- New skill requested -> scaffold new skill.
- Existing skill too long or mixed concerns -> extract use cases.
- Skill writes to systems with strict rich text formats -> formatting policy retrofit.
- Skill runs CLI workflows or has brittle command examples -> CLI skill creation.

## Testing and iteration expectations

- Validate trigger behavior before finalizing:
  - Should trigger on direct requests.
  - Should trigger on paraphrased requests.
  - Should not trigger on unrelated requests.
- Validate functional behavior:
  - The resulting skill can be followed step-by-step without guessing.
  - Linked use-case files are reachable and independently understandable.
  - Quality and safety checks are explicit.
- Iterate based on failure mode:
  - Under-triggering -> add clearer user phrasing and scope hints.
  - Over-triggering -> tighten description and add boundaries.

## Troubleshooting retrofit checklist

- Missing or weak frontmatter -> add or rewrite `name` and `description`.
- Vague triggering -> replace abstract language with user-sayable phrases.
- Overlong core file -> extract workflows into `usecases/*.md`.
- Broken internal navigation -> fix relative links.
- Conflicting guidance across files -> consolidate shared policy in core file.

## Quality checklist

- `SKILL.md` is short, generic, and non-use-case-heavy.
- Frontmatter is present, valid, and trigger-oriented.
- Use-case docs are specific, scoped, and independently loadable.
- All cross-file references use relative links in markdown format.
- No contradictory guidance between core file and use-case files.
- Safety, verification, and reporting expectations are explicit.
