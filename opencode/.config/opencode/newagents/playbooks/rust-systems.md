# Rust Low-Level Systems Concern Playbook

Load when `touched_areas` includes `rust` for low-level systems (message queues, storage engines, database internals).
Implementers and `test-writer` read **Engineering** + **Testing**; `code-reviewer` reads **Review checklist**.

## Engineering rules (implement)

- Prefer safe Rust and clear ownership/borrowing over clever patterns. Introduce `unsafe` only when necessary; keep blocks minimal with explicit safety invariants documented, encapsulated behind safe APIs.
- Model fallible operations with `Result` and typed errors (`thiserror`/structured); avoid `unwrap`/`expect` in production paths unless a true invariant is documented.
- Concurrency: prefer deterministic designs, bounded queues/backpressure, explicit cancellation, and clear shutdown semantics. Use the simplest correct primitive (`Mutex`/`RwLock`/atomics/channels) for the contention/ordering need.
- Don't hold non-async locks/guards across `.await`; scope the unlock or use actor/message-passing for I/O-bound state machines.
- Profile before optimizing; optimize hotspots with measured evidence only.

## Testing (test-first + DoD)

- Cover boundary conditions, ordering guarantees, retries/idempotency, and corruption/failure scenarios for persistence/messaging.
- Prefer deterministic tests; avoid timing-sensitive flakes.
- Use `loom` for lock-free/tricky synchronization, `cargo fuzz` for parser/protocol/storage boundaries, and property tests for invariants (ordering, dedupe, serialization round-trip).
- For persistence changes, test restart/replay and partial-write/corruption recovery.

## Review checklist (review)

Order: safety → correctness/data-integrity → concurrency → style/maintainability → test/lint evidence.

- Safety: ownership/borrowing/lifetimes clear; every `unsafe` justified (contract, invariants, aliasing, lifetimes); UB-risk patterns (bad pointer/slice bounds, transmute misuse, FFI, unsafe interior-mutability races); correct pinning/self-referential use; `unsafe_op_in_unsafe_fn` discipline.
- Functional/data-integrity: ordering, dedupe/idempotency, replay; partial-failure/retry/crash-consistency; serde correctness and schema/version compatibility; boundary handling (empty/large/invalid/truncated payloads, timeouts).
- Concurrency: lock granularity and ordering (deadlock risk), atomics memory-ordering rationale for anything weaker than `SeqCst`, channel lifecycles/cancellation/graceful shutdown, no blocking the async executor, no guards held across `.await`.
- Standards: idiomatic errors, explicit types over over-generic abstractions, cohesive modules, semantically accurate names; flag needless complexity.
- Lint/security: `cargo clippy --all-targets --all-features -D warnings` as primary signal; `cargo audit`/`cargo deny` for dependency risk on production changes.
- Persistence/queue: explicit durability semantics (fsync/flush, WAL/checkpoint ordering, crash-recovery); at-least-once/exactly-once backed by idempotency/dedupe; restart/replay tests.
- Tag findings `Safety` / `Correctness` / `Concurrency` / `Reliability` / `Testing` / `Lint` (and `Security` / `Performance` when applicable).
