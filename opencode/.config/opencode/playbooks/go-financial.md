# Go Financial Concern Playbook

Load when `touched_areas` includes `go` (especially money-moving / business-critical logic).
Implementers and `test-writer` read **Engineering** + **Testing**; `code-reviewer` reads **Review checklist**.

## Engineering rules (implement)

- Prefer simple, readable, idiomatic Go that follows the standard library and community conventions. Correctness, clarity, and maintainability first.
- Comment only where behavior is complex, non-obvious, or ambiguous. Name functions/methods for their real behavior and side effects.
- Use complex high-performance solutions only when clearly necessary, and justify the trade-off.
- Money: use safe representations (integer minor units or a decimal type) — never float math for currency unless strongly justified. Keep precision/scale explicit and deterministic.
- Make side effects at-most-once where required: idempotency keys, replay safety, dedupe.
- Wrap errors with `%w` when callers may need to inspect causes; never drop errors.
- Honor `context` cancellation/deadline; never leak goroutines or resources (`Body`, `Rows`, files, active background work). Timer GC/reset rules depend on Go version and overrides.

### Modern Go (use what the module's `go.mod` version supports — never exceed it)

- Read the Go version in `go.mod` and prefer current idioms available in it; do not use features newer than the declared version (bump the directive deliberately if you genuinely need a newer one, and call that out).
- Builtins & stdlib generics: use `min`/`max`/`clear` and the `slices`, `maps`, `cmp` packages instead of hand-rolled loops/helpers or third-party slice/map libs (1.21+).
- Loops: rely on per-iteration loop-variable scoping — no manual `x := x` shadowing — and range-over-int `for i := range n` (1.22+).
- Iterators: prefer range-over-func and the `iter` package, plus the iterator forms `slices.Collect` / `maps.Keys` / `maps.Values` (1.23+).
- Pointers to values: use the `new(expr)` form to get a pointer to an initialized value where the toolchain supports it, instead of temporaries or helper funcs that exist only to take an address.
- Errors & logging: `errors.Join` to aggregate errors (alongside `%w`); `log/slog` for structured logging rather than ad-hoc formatting.
- Randomness: `math/rand/v2` for non-crypto randomness; `crypto/rand` for anything security-sensitive.
- Other recent niceties as available: `cmp.Or`, generic type aliases (1.24), `testing.B.Loop` for benchmarks, and `testing/synctest` for deterministic concurrency tests.
- These never override the money rules above: no float for currency, and precision/determinism still bind.

## Testing (test-first + DoD)

- Cover changed behavior and important failure paths; ≥80% for changed areas follows the active governance profile (required for Betika, recommended for default). Go deeper on high-risk/money paths.
- Required cases: zero, negative, large values, overflow/underflow, rounding boundaries, fee/rate edges, and idempotency/replay where applicable.
- Run Go tests with `-race`. Prefer table-driven tests for branch-heavy rules.
- Follow the package's existing assertion style; do not add or mandate an assertion library solely for consistency.
- Deterministic tests only — no timing/scheduler assumptions; inject a clock where time matters.

## Review checklist (review)

Explicitly read `~/.config/opencode/playbooks/code-review.md`, **Review method** and
**Go and financial systems** (plus **Database and migrations** when relevant).
Order: financial risk → correctness → maintainability → lint/test evidence.

- When money is touched, emit a **financial-invariants summary**: Pass/Fail/Unknown,
  or N/A with reason, for balance conservation, rounding/precision/scale,
  idempotency/replay, overflow/underflow, and time/cutoff boundary correctness.
- Apply repository style and supported Go semantics. Modernization or assertion-library
  choice alone is not a defect. Flag misleading names when they cause a concrete misunderstanding.
- Consume revision-bound race/test/lint evidence; request missing required checks from
  the developer. Do not execute repository code during review.
- Tag findings `Financial` / `GoogleStyle` / `100go` / `Concurrency` / `Testing` / `Lint`
  as relevant; tags identify the concern, not proof of a bug.
