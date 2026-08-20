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
- Honor `context` cancellation/deadline; never leak goroutines or resources (`Body`, `Rows`, files, timers).

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

- Cover all new/changed code; target ≥80% for changed areas; go deeper on high-risk/money paths.
- Required cases: zero, negative, large values, overflow/underflow, rounding boundaries, fee/rate edges, and idempotency/replay where applicable.
- Run Go tests with `-race`. Prefer table-driven tests for branch-heavy rules.
- If `github.com/stretchr/testify` is already in the repo, use `require`/`assert` consistently with existing style; don't mix stdlib-only and testify in one package without reason.
- Deterministic tests only — no timing/scheduler assumptions; inject a clock where time matters.

## Review checklist (review)

Order: financial risk → correctness → Google Go style → lint/test evidence. When money is touched, also emit a **financial-invariants summary** (Pass/Fail/Unknown) for: balance conservation, rounding/precision/scale, idempotency/replay, overflow/underflow, and time/cutoff boundary correctness.

- Financial: balance conservation and debit/credit invariants, rounding/precision/scale, overflow/underflow, reconciliation, settlement/period time & timezone cutoffs, and ordering/race-driven inconsistency.
- Correctness: error/partial-failure paths, retries/compensating actions, at-most-once side effects (idempotency keys, replay safety, dedupe), nil/zero/typed-nil pitfalls, deterministic behavior where ordering matters (map iteration, goroutine scheduling).
- Naming: function/method names must accurately describe behavior and side effects — flag names that imply different semantics than the implementation.
- `100go` sweep: `err` shadowing, unnecessary nesting, `init` misuse, interface pollution / producer-side interface forcing / returning interfaces where a concrete type is cleaner, overuse of `any`, slice/map aliasing & shared backing-array mutation, range-copy pitfalls, map-iteration nondeterminism, `defer`-in-loop resource pressure, dropped/double-handled errors, missing `errors.Is`/`errors.As`, context propagation/cancellation leaks, resource leaks (`Body`/`Rows`/files/timers/tickers).
- Go 1.22+ loop-variable capture: do not flag missing defensive shadowing in 1.22+ code by default; still verify closure capture in mixed-version repos and when taking the address of the loop variable.
- Modernization: for the module's declared Go version, flag hand-rolled helpers that a current stdlib feature replaces (`slices`/`maps`/`cmp`, `min`/`max`/`clear`, range-over-int/func, `errors.Join`, `log/slog`) — but do not demand features newer than `go.mod` declares.
- `GoogleStyle`: clear naming with preserved initialisms (`ID`/`URL`/`HTTP`/`JSON`), exported doc comments starting with the identifier, lowercase error strings without trailing punctuation, short package names (no `util`/`common`/`shared`).
- Tests: monetary edge/rounding boundaries and idempotency/replay/duplicate-message cases covered; table-driven for branch-heavy rules; `testify` used consistently if already present (flag mixed stdlib/testify styles); race-detector evidence when concurrency changed.
- Lint: `golangci-lint` primary, then `go vet`; fix valid findings, de-prioritize likely false positives with justification, prefer scoped config exclusions over broad suppression, allow `//nolint:<linter>` only narrowly with inline justification. If lint/test results weren't provided, state what to run (golangci-lint first).
- DoD evidence: `go test ./... -race` green, lint clean for the touched scope; tag findings `Financial` / `GoogleStyle` / `100go` / `Concurrency` / `Testing` / `Lint`.
