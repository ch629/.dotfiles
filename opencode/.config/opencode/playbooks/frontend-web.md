# Frontend Web (JavaScript / Next.js) Concern Playbook

Load when `touched_areas` includes `frontend`. Default framework: Next.js (App Router).
Implementers and `test-writer` read **Engineering** + **Testing**; `code-reviewer` reads **Review checklist**.

## Engineering rules (implement)

- Use App Router conventions (`app/`, `layout`, `page`, `loading`, `error`, `route`); keep routing explicit.
- Default to Server Components; use Client Components only where interactivity/browser APIs are required, and keep `'use client'` boundaries as small as possible to limit bundle size.
- Organize by route/feature with consistent colocation (route groups, private folders).
- Data: fetch server-side in Server Components when possible; start independent requests early and await with `Promise.all`; stream with `loading`/`Suspense` and meaningful skeleton states.
- Keep server-only logic and secrets out of client bundles; maintain clear server/client module boundaries.
- Components small and single-purpose; predictable state over clever abstractions; extract reuse only on real repetition.

## Testing (test-first + DoD)

- Cover changed UI logic at the right level: unit/component for local behavior, E2E for critical user flows.
- For async Server Components, prefer E2E coverage where unit tooling is limited.
- Include at least one regression test per bug fix.
- Explicitly verify error / empty / loading states.

## Review checklist (review)

- Correctness: error/empty/loading states handled; data-fetching boundaries correct; no secrets or server-only logic leaking to the client.
- Accessibility: semantic HTML, keyboard navigation, labels, visible focus states.
- Performance: minimal `'use client'` surface, no needless client bundle bloat, progressive streaming where it helps.
- Maintainability: small single-purpose components, predictable state, no premature abstraction.
- Tests: changed logic covered at the appropriate level; critical flows have E2E; regression test present for fixes.
