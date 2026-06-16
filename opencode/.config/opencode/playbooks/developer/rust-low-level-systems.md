# Rust Low-Level Systems Playbook

Use this playbook when the user request is primarily Rust implementation/review for low-level systems (for example: message queues, storage engines, and database internals).

## Engineering guidance (Rust)

- Prefer safe Rust and clear ownership/borrowing over clever patterns; introduce `unsafe` only when necessary and keep unsafe blocks minimal with explicit safety invariants.
- Model fallible operations with `Result` and typed errors; avoid `unwrap`/`expect` in production paths unless a true invariant is documented.
- For concurrency-heavy systems (queues, schedulers, storage), prefer deterministic designs, bounded queues/backpressure, explicit cancellation, and clear shutdown semantics.
- Use appropriate synchronization primitives (`Mutex`, `RwLock`, atomics, channels) based on contention and memory-ordering needs; default to the simplest correct primitive.
- Avoid premature micro-optimizations; profile first, then optimize hotspots with measured evidence.
- Write tests for boundary conditions, ordering guarantees, retries/idempotency, and corruption/failure scenarios for persistence or messaging flows.

## Rust planning and review rules

- For implementation planning on medium/high-complexity Rust low-level systems work (architecture, sequencing, risk decomposition), delegate to `rust-systems-implementation-planner`.
- For non-ticketed Rust low-level systems tasks, skip Jira research and delegate planning directly to `rust-systems-implementation-planner`.
- Default planning mode: for non-trivial Rust low-level systems requests (roughly 3+ implementation steps, concurrency/persistence impact, or unclear sequencing), run `rust-systems-implementation-planner` before coding unless the user explicitly asks to implement directly.
- For strict Rust low-level systems reviews (memory safety, concurrency, correctness, and performance-risk tradeoffs), delegate to `rust-systems-code-reviewer`.
- For high-risk Rust low-level systems changes (message queue internals, storage engines, custom persistence/concurrency paths), run `rust-systems-code-reviewer` before final sign-off unless explicitly asked to skip.
- When delegating to `rust-systems-code-reviewer`, explicitly request findings across: Memory safety/ownership, Concurrency correctness, Error handling/recovery, Performance-risk tradeoffs, and Testing depth.

## Rust definition-of-done emphasis

- Ensure risk-focused tests cover boundary conditions, ordering guarantees, retries/idempotency, and corruption/failure scenarios.
- If reviewer findings require changes, run a fix-and-recheck loop up to the configured review-pass limit.
