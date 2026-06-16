# Go Financial Engineering Playbook

Use this playbook when the user request is primarily Go implementation/review, especially for financial logic.

## Engineering guidance (Go)

- Prefer simple, readable, idiomatic Go that follows standard library and community conventions.
- Optimize for correctness, clarity, and maintainability first.
- Add comments only when necessary—primarily where behavior is complex, non-obvious, or potentially ambiguous.
- Use function and method names that accurately reflect behavior and side effects; avoid names that imply different semantics than implementation.
- Use complex high-performance solutions only when clearly necessary, and justify the trade-offs.
- Keep designs pragmatic and easy for other engineers to understand and operate.

## Go planning and review rules

- For Jira tickets with incomplete/ambiguous scope, run `jira-researcher` first, then `go-implementation-planner` before coding.
- For implementation planning on medium/high-complexity Go tickets (architecture, sequencing, risk decomposition), delegate to `go-implementation-planner`.
- For strict Go code reviews with financial scrutiny, correctness checks, Google Go style compliance, 100go pitfall detection, and lint/standards focus, delegate to `go-financial-code-reviewer`.
- For high-risk financial Go changes, run `go-financial-code-reviewer` before final sign-off unless explicitly asked to skip.
- When delegating to `go-financial-code-reviewer`, explicitly request findings across: Financial correctness, Functional correctness, `GoogleStyle`, and `100go` categories.

## Go testing and quality gates

- Ensure all new code is covered by tests.
- Target at least 80% test coverage for new or changed code.
- Always run Go tests with the `-race` flag for race condition detection.
- If `github.com/stretchr/testify` is already present in the project, write new Go tests using `testify` (`require`/`assert`) and match the repository's existing test style.
- Keep assertion style consistent within each Go package; avoid mixing stdlib-only assertion patterns and `testify` unless there is a documented reason.
- Prioritize deeper tests around complex, high-risk, or business-critical logic.
- Call out any coverage gaps explicitly, with concrete follow-up tests needed.

## Go definition-of-done checks

- `go test ./... -race` completed successfully for the affected scope.
- Lint/vet health is confirmed (`golangci-lint` first, then `go vet` when relevant).
- For Go review summaries, include which findings came from `GoogleStyle` and which came from `100go` tags when present.
