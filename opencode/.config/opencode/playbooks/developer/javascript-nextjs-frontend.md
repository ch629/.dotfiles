# JavaScript Frontend (Next.js) Playbook

Use this playbook when the request is frontend implementation/review in JavaScript, with Next.js as the default framework.

## Scope and architecture defaults

- Prefer Next.js App Router conventions (`app/`, `layout`, `page`, `loading`, `error`, `route`) and keep routing concerns explicit.
- Default to Server Components; use Client Components only where interactivity/browser APIs are required.
- Keep `'use client'` boundaries as small as possible to minimize client bundle size.
- Organize by route/feature with consistent colocation, using route groups and private folders where helpful.

## Data fetching and rendering

- Prefer server-side data fetching in Server Components when possible.
- For parallel independent requests, start requests early and await with `Promise.all`.
- Use `loading` and `Suspense` to stream progressively and provide meaningful loading states (skeletons over generic spinners when practical).
- Keep sensitive server-only logic out of client bundles; avoid exposing secrets and use clear server/client module boundaries.

## Frontend code quality expectations

- Prioritize accessibility: semantic HTML, keyboard navigation, labels, and visible focus states.
- Prefer simple, readable components and predictable state management over clever abstractions.
- Keep components small and single-purpose; extract reusable UI patterns only when repetition is real.
- Validate error/empty/loading states explicitly in UI flows.

## Testing and verification (Next.js frontend)

- Cover changed UI logic with tests at the right level: unit/component for local behavior, E2E for critical user flows.
- For async Server Components, prefer E2E coverage for end-user correctness when unit tooling support is limited.
- Include at least one regression test for each bug fix in frontend behavior.

## Agent behavior patterns for frontend tasks

These patterns reflect common effective agent setups for coding work:

- Keep workflows simple and composable first (avoid unnecessary orchestration).
- Use routing behavior: classify the task first (UI bug, data flow, performance, accessibility, test gap), then apply specialized checks.
- Use evaluator passes for high-risk changes: implementation pass -> focused review pass (a11y/perf/correctness) -> targeted fix pass.
- Prefer transparent step plans and explicit assumptions before editing multiple files.

## Source-informed guidance

- Next.js docs emphasize App Router conventions, Server/Client component boundaries, streaming with `loading`/`Suspense`, and testing strategy selection.
- Agent design guidance from Anthropic's "Building effective agents" emphasizes simple composable workflows, routing, and evaluator-optimizer loops over unnecessary complexity.
