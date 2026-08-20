# Ticket pipeline (staging)

A self-contained, single-ticket delivery pipeline derived from [`agents.md`](agents.md).
Built in isolation in `newagents/` — **opencode does not auto-load this directory**.
Promote by moving the files into `.config/opencode/agents/` (see [Merging](#merging-into-the-live-stack)).

The `ticket-orchestrator` primary drives 13 single-shot subagents from a raw ticket to a PR ready
for your manual review. The design optimizes for **small, cacheable context**: a single
compact artifact (the Ticket Brief) is the only thing passed between stages, and each
subagent receives only the slice it needs.

A second primary, `quick-dev`, is a lightweight hands-on coder for small one-off tasks that don't
need the full pipeline — implement, build/lint/test, optional quick review. Use `ticket-orchestrator`
for ticket-driven / multi-stage work, `quick-dev` for a fast single change.

Domain depth lives in **concern files loaded on demand** (`playbooks/`, `policies/`), mirroring
the existing opencode stack — base prompts stay lean and a stage reads exactly one small file
when its stack matches.

```
newagents/
├── quick-dev.md                  primary — small one-off tasks (standalone)
├── ticket-pipeline/              the ticket workflow (1 primary + 13 subagents)
│   ├── ticket-orchestrator.md    primary — full pipeline
│   ├── ticket-clarifier.md
│   ├── ticket-researcher.md
│   ├── implementation-planner.md
│   ├── test-writer.md
│   ├── feature-developer.md
│   ├── db-reviewer.md  migration-reviewer.md  infra-reviewer.md
│   ├── security-scanner.md  code-reviewer.md  code-reviewer-lite.md
│   ├── completion-reviewer.md
│   └── pr-description-writer.md
├── prompts/                      shared agent-prompt bodies (no frontmatter)
│   └── code-review.md            ← code-reviewer + code-reviewer-lite both link here
├── playbooks/                    concern files (language/stack depth)
│   ├── go-financial.md
│   ├── rust-systems.md
│   └── frontend-web.md
└── policies/
    └── governance-profiles.md    delivery gates (default / betika)
```

> **The `ticket-pipeline/` grouping is source-side organization only — install the agent files FLAT.**
> opencode's glob does not descend into subfolders of this setup's **symlinked** `agents/` dir (verified
> with `opencode agent list`: a top-level agent loads, a subfolder one does not). Agent names are the
> **filename** regardless, so flattening doesn't change any names or the `task` allowlist. Keep
> `prompts/`, `playbooks/`, and `policies/` (non-agent markdown) **out** of `agents/` entirely — they
> live here and are referenced by absolute path. See [Installing](#installing-alongside-your-existing-agents).

## Flow

```
ticket-orchestrator (primary)
  → linear issue view <key>   fetch the spec ONCE (single source for the Brief)
  → ticket-clarifier        raw ticket text → ambiguity flags        ──┐ octto gates
  → (octto: ask user blocking questions)                              ─┘
  → ticket-researcher       ticket + answers → Ticket Brief (SoT)    ── DCP compress
  → implementation-planner  (high-complexity only) → plan folds into Brief
  → create worktree + branch from origin/main
  → linear issue start <key>  move ticket to In Progress
  → test-writer             AC slice + paths → failing tests
  → feature-developer       Brief + tests → implementation (green)   ── DCP compress
  → review fan-out (only the relevant ones for touched_areas):
      → db-reviewer            DB diff slice
      → migration-reviewer     migration files only (greenfield → pass-through)
      → infra-reviewer infra diff slice
      → security-scanner       diff range
      → code-reviewer          AC summary + diff range + dev's build/lint/test results
  → fix loop (≤2 iterations)                                         ── DCP compress
  → completion-reviewer     AC + evidence, verified vs the ORIGINAL Linear ticket
  → pr-description-writer   evidence map + verdicts → PR body
  → orchestrator opens PR → tear down worktree → STOP (user manual review;
                            user closes the ticket)
```

## The Ticket Brief (the only shared object)

The researcher produces it; the orchestrator owns it and forwards only slices. Keep it
under ~30 lines. It is the single source of truth — no subagent re-fetches the ticket.

| Field | Meaning |
|---|---|
| `key` | ticket id + direct link |
| `title` | one line |
| `scope` | 1–3 lines of what to build |
| `acceptance_criteria` | numbered checklist |
| `constraints` | hard rules / out-of-scope |
| `touched_areas` | subset of `[go, rust, db, migration, infra, frontend]` |
| `profile` | governance profile (default / betika), resolved at intake |
| `deploy_context` | `greenfield` or `live` — gates how strictly migrations are reviewed (default `live`) |
| `change_tier` | `trivial` / `standard` / `high-risk` — sizes review effort, computed from the real diff |
| `open_questions` | unresolved clarifier items (or "none") |
| `approach` | concrete implementation path (files/functions, in order) |
| `test_plan` | which tests to write first and where |
| `commands` | exact test + lint commands for the touched stack |
| `worktree` | path + branch (filled at launch) |
| `risks` | riskiest unknowns |

### What each stage receives (minimal slice)

| Subagent | Input slice |
|---|---|
| `ticket-clarifier` | raw ticket text only (no tools) |
| `ticket-researcher` | ticket text + resolved questions |
| `implementation-planner` | Ticket Brief + concern playbook path (high-complexity tickets only) |
| `test-writer` | `acceptance_criteria` + `test_plan` paths + worktree + test command |
| `feature-developer` | `scope`+`acceptance_criteria`+`approach` + test paths + worktree + commands (+ fix list in fix mode) |
| `db-reviewer` | manifest slice: worktree + `range` + DB file list + commits + evidence |
| `migration-reviewer` | manifest slice: migration file list + `range` + commits + `deploy_context` |
| `infra-reviewer` | manifest slice: infra file list + `range` + commits + evidence |
| `security-scanner` | manifest slice: full file list + `range` + commits |
| `code-reviewer` / `code-reviewer-lite` | manifest slice: full file list + `range` + commits + `acceptance_criteria` + language + `review_depth` + evidence (lite for trivial tier) |
| `completion-reviewer` | Linear `key` + `acceptance_criteria` + diff range + build/lint/test results |
| `pr-description-writer` | ticket key + AC-to-evidence map + reviewer verdicts + commit list |

## Linear integration

Linear is the ticket source, accessed via the `linear-cli` skill. Access is deliberately confined to
two agents so the single-fetch / minimal-context design holds:

| Agent | Linear access | Why |
|---|---|---|
| `ticket-orchestrator` | read (`issue view/list/query/url`) + **`issue start`** | looks up the spec once at intake; moves the ticket to In Progress at launch |
| `completion-reviewer` | **read-only** (`issue view/list/query/url`) | verifies the work against the *original* ticket, not just the derived Brief |

No other agent touches Linear — they work from the Brief. Two guardrails on mutation:

- The orchestrator can **only** move the ticket to In Progress (`issue start`). It is *not* granted
  `issue update`, so completing/closing, commenting, or reassigning falls through to the `*: ask`
  gate. The pipeline stops at "PR raised" and the **user closes the ticket** after manual review.
- `completion-reviewer` is read-only and explicitly forbidden from any mutating Linear command — it
  re-reads the ticket so a Brief that drifted from the real AC can't pass a hollow check.

## Clarifying questions (octto) — ask early, ask once

Ambiguity is resolved at the earliest possible point, before tokens are spent on research
or code. The orchestrator uses octto helpers (`ask_text`, `pick_many`, `confirm`,
`show_plan`, `review_section`) at two mandatory gates:

1. **Intake gate** — if ticket id, scope, target stack, or branch base is missing/ambiguous, ask before running the clarifier.
2. **Post-clarifier gate** — every blocking question from `ticket-clarifier` is surfaced to the user and answered before research begins.

Questions are batched into one prompt; no research, worktree, or code stage starts while a
blocking question is open. After the plan is confirmed, the orchestrator runs autonomously
to PR sign-off unless it hits an external blocker.

## Scale-based review tiering

Review effort is sized to the change, **risk-first**. Before the review fan-out the orchestrator
computes `change_tier` from the real diff:

| Tier | Trigger | Review policy |
|---|---|---|
| `trivial` | ≲30 LOC, ≤2 files **and** no risky areas (docs/config/comment/test-only) | skip planner; security only if executable code changed; db/migration/infra only if touched; **`code-reviewer-lite`** `review_depth: light` |
| `standard` | default | normal fan-out; `code-reviewer` `review_depth: standard` |
| `high-risk` | touches money/auth/db/migration/concurrency, **or** large diff (≳400 LOC / ≳10 files), **or** betika critical path | planner ensured; security mandatory; every touched-area reviewer; `code-reviewer` `review_depth: deep` |

The code-review model itself tiers via a **shared-prompt** pattern: the full review prompt lives in
[`prompts/code-review.md`](prompts/code-review.md) (no frontmatter), and both `code-reviewer.md` and
`code-reviewer-lite.md` are thin files that carry only their own frontmatter (model + permissions)
and defer their whole body to it. So both variants run one identical contract, each on whichever
model its own frontmatter sets — the model lives only in the frontmatter, never restated in prose,
so there's nothing to keep in sync. The orchestrator routes to `-lite` at the `trivial` tier,
`code-reviewer` otherwise. (Same idea as the `*-betika` variants, but sharing one prompt file rather
than referencing a sibling agent by name.)

**Guardrail:** any risky area forces *at least* `standard` regardless of diff size — a small change
to a critical path is never fast-pathed. Tiering varies breadth, model, and the depth hint only; it
never lowers the correctness/risk bar on the areas being reviewed. Both reviewers carry the same
risk guardrail, so `code-reviewer-lite` will escalate (and flag) a diff that turns out to touch a
risky area, and the orchestrator re-routes it to `code-reviewer`.

## Review handoff (change manifest)

Reviewers don't re-gather the change each — the orchestrator builds a **change manifest once** before the
fan-out (it already inspects the diff to compute `touched_areas`/`change_tier`) and hands each reviewer a
scoped slice:

- Built once with two commands: `git diff --name-status origin/main...HEAD` (files + change type) and
  `git log --oneline origin/main..HEAD` (commit subjects). Base is a freshly-refreshed `origin/main`, so
  the tree is clean and reviewers needn't verify history/base.
- Manifest = `range` + changed `files` (type + area, grouped) + `commits` + `evidence` (the developer's
  build/lint/test results).
- Each reviewer gets only its slice and runs **one** scoped `git diff origin/main...HEAD -- <its files>` —
  no `git log`, no `git status`, no whole-tree diff. Their `git status`/`git log` permissions were removed
  to enforce this; they keep scoped `git diff` + `grep`/`rg` for context. Refreshed after each fix loop.

This cuts each reviewer from ~4 repeated git calls over the whole diff to one scoped diff over its own
files — less duplicated context, smaller per-reviewer payload, and a stable manifest prefix that caches well.

## Context compression (DCP)

The orchestrator is the only long-lived agent (subagents are single-shot and discarded), so
it owns compression. It applies DCP at block boundaries once raw context is spent:

- after **clarify + research** — drop raw ticket text and research logs; keep the Brief.
- after **implementation** — drop raw build/test chatter once tests are green.
- after each **review fan-out** — drop raw reviewer transcripts once distilled into a fix list or evidence.

**Never compressed:** the Ticket Brief, AC-to-evidence map, open reviewer findings, and
commit/PR metadata — the durable thread carried to the end.

## Concern files (load on demand)

Domain depth is offloaded to concern files so base prompts stay small and cacheable. The
orchestrator owns the routing decision (it knows `touched_areas`) and **names the one file**
each stage should read — so a subagent reads a single small file, never the whole set.

| `touched_areas` | concern file | who reads it |
|---|---|---|
| `go` | [`go-financial.md`](playbooks/go-financial.md) | planner, test-writer, feature-developer, code-reviewer |
| `rust` | [`rust-systems.md`](playbooks/rust-systems.md) | planner, test-writer, feature-developer, code-reviewer |
| `frontend` | [`frontend-web.md`](playbooks/frontend-web.md) | planner, test-writer, feature-developer, code-reviewer |
| `db` / `migration` / `infra` | — | handled by the dedicated reviewers' built-in depth (db / migration / platform-infra) |

Each playbook has three sections so it serves the whole pipeline from one file: **Engineering**
(implementer), **Testing** (test-writer + DoD), **Review checklist** (code-reviewer, with finding tags).

### File-read access

`prompts/`, `playbooks/`, and `policies/` sit in the opencode **config** dir, which is outside the
worktree `cwd` the subagents run in. opencode's `read` permission defaults to `allow`, but reading
outside the working directory requires an **`external_directory`** grant (entries there inherit read
access). So every agent that opens a linked file lists the relevant config dir in its
`external_directory`:

| Agent | external_directory grant |
|---|---|
| `code-reviewer`, `code-reviewer-lite` | `~/.config/opencode/prompts/**`, `~/.config/opencode/playbooks/**` |
| `feature-developer`, `test-writer`, `implementation-planner` | `~/.config/opencode/playbooks/**` |
| `ticket-orchestrator`, `completion-reviewer` | `~/.config/opencode/policies/**` |

These globs point at the **promoted** install path (`~/.config/opencode/...`). The link paths in the
prompts and the `external_directory` globs must agree and must match where the files actually land —
see [Merging](#merging-into-the-live-stack).

[`governance-profiles.md`](policies/governance-profiles.md) defines delivery gates. The orchestrator resolves the active
`profile` at intake (by `cwd` path) and passes its gates to `completion-reviewer`, which enforces
them: `betika` requires ≥80% coverage on changed code, ticket key in branch + PR title, and
conventional commits (no `chore`); `default` treats these as recommendations.

`deploy_context` gates migration review. On `greenfield` (no production schema or live consumers),
`migration-reviewer` skips online-safety entirely — locking/downtime, backward/forward compat,
expand/contract sequencing, and reversibility — and does only a cheap apply-time correctness check
(or the orchestrator skips it outright for purely additive migrations). On `live` it runs the full
zero-downtime safety checklist. Default is `live`; the orchestrator confirms via octto when unsure,
since flipping to `greenfield` relaxes a safety gate.

## Model assignment

Claude tiers run on the `anthropic` provider; the rest on `openrouter`.

| Agent | Role from agents.md | Model |
|---|---|---|
| `ticket-orchestrator` | Orchestrator — **primary** (Sonnet) | `anthropic/claude-sonnet-4-6` |
| `quick-dev` | Small-task dev — **primary** (new) | `anthropic/claude-sonnet-4-6` |
| `ticket-clarifier` | Ticket clarifier (Haiku) | `anthropic/claude-haiku-4-5` |
| `ticket-researcher` | Research (Grok) | `openrouter/x-ai/grok-4.3` |
| `implementation-planner` | Planner (high-complexity only) | `anthropic/claude-sonnet-4-6` |
| `test-writer` | Test writer (Devstral) | `openrouter/mistralai/devstral-2512` |
| `feature-developer` | Developer (DeepSeek/Devstral) | `openrouter/deepseek/deepseek-v4-flash` |
| `db-reviewer` | DB reviewer (DeepSeek V4 Pro) | `openrouter/deepseek/deepseek-v4-pro` |
| `migration-reviewer` | Migration reviewer (Haiku) | `anthropic/claude-haiku-4-5` |
| `infra-reviewer` | Infra reviewer (new) | `anthropic/claude-sonnet-4-6` |
| `security-scanner` | Security scanner (Haiku) | `anthropic/claude-haiku-4-5` |
| `code-reviewer` | Code reviewer (Sonnet) | `anthropic/claude-sonnet-4-6` |
| `code-reviewer-lite` | Code reviewer, trivial tier | `anthropic/claude-haiku-4-5` |
| `completion-reviewer` | Completion reviewer (Haiku) | `anthropic/claude-haiku-4-5` |
| `pr-description-writer` | PR description writer (Haiku) | `anthropic/claude-haiku-4-5` |

> All openrouter slugs above were verified against the live OpenRouter `/models` catalog.
> Notes on choices: `deepseek-v4-flash` implements and `deepseek-v4-pro` reviews (same V4
> family, fast worker + strong reviewer); `grok-4.3` is the current standard Grok;
> `devstral-2512` is the current Devstral. Swap freely — e.g. `deepseek-v3.2` for the
> developer, or `grok-4.20` for research — if cost/quality trade-offs change.

## Installing alongside your existing agents

This set runs **next to** your current agents without touching them. Only the agent files go into the
scanned `agents/` dir; the assets (`prompts/`, `playbooks/`, `policies/`) stay in `newagents/`, and
every agent already points at `~/.config/opencode/newagents/...` for its links and `external_directory`
grants. So installing is just copying the agent files.

1. **Pre-reqs:** `openrouter` authed, the `anthropic` provider configured (`opencode.json`), and the
   `linear-cli` skill available with Linear auth set up.
2. **Copy the agent files FLAT into `agents/`.** opencode doesn't load agents from subfolders of this
   symlinked `agents/` dir, so they all go at the top level (names are unaffected — they're filenames):
   ```sh
   cd ~/.config/opencode/newagents
   cp ticket-pipeline/*.md ../agents/   # 1 primary + 13 subagents, flat
   cp quick-dev.md ../agents/           # standalone small-task primary
   ```
   Verify they registered: `opencode agent list | grep -E 'ticket-|reviewer|quick-dev'`.
3. **Leave the asset dirs where they are.** `newagents/{prompts,playbooks,policies}/` stay put — the
   copied agents reference them by absolute path. Put **nothing** but agent files under `agents/`
   (including its subfolders), or opencode will try to load stray markdown as agents.
4. **No collisions.** Every filename is distinct from your existing agents — the one clash,
   `platform-infra-reviewer`, was renamed to `infra-reviewer`. Your current stack is untouched, and
   `default_agent` stays `developer-personal`.
5. **Pick a primary with Tab.** In a session, cycle to a primary: `ticket-orchestrator` (full pipeline)
   or `quick-dev` (small one-off tasks). The 13 subagents are `hidden: true`, so they won't clutter the
   picker — they're reached by delegation / `@mention`.

### Smoke test (confirm linked-file reads resolve)

The one runtime unknown is whether your opencode resolves the agents' asset paths. Ask `quick-dev` to
make a tiny Go change and watch that it loads `…/newagents/playbooks/go-financial.md`. If that read
fails, your opencode resolves agent paths differently — switch the link + `external_directory` paths to
whatever convention your existing `developer-personal` playbook links use (that one already works in
your setup), e.g. `.config/opencode/...` vs `~/.config/opencode/...`.

### Uninstall / iterate

The installed files are flat in `agents/`, so remove them by name:
```sh
cd ~/.config/opencode/newagents
rm -f ../agents/quick-dev.md; for f in ticket-pipeline/*.md; do rm -f "../agents/$(basename "$f")"; done
```
Your original agents are unchanged. Edit in `newagents/` and re-copy to iterate.

### Promoting properly later

When you're happy and want this to be the canonical stack rather than a side-by-side test, move the
asset dirs out of `newagents/` (e.g. into `.config/opencode/{prompts,playbooks}/`), then update the
agents' link paths + `external_directory` globs to match. The orchestrator's `task` allowlist already
matches the 13 subagent files exactly — re-check it only if you rename anything.
