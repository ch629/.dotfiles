---
name: postgres-bench-lab
description: Run local Postgres migration/seed/EXPLAIN benchmarks with the reusable postgres-bench-lab harness when requested or when performance evidence is required.
---

# Postgres Bench Lab

Use this skill to run reproducible local Postgres benchmarks using:

- harness project: `/Users/charliehowes/Projects/betika/postgres-bench-lab`
- workflow: reset → migrate → seed → explain
- artifacts: saved under `postgres-bench-lab/artifacts/`

## When to use

- User explicitly asks for benchmark/query-plan validation.
- A review requires `EXPLAIN (ANALYZE, BUFFERS)` evidence for hot-path queries.

## When NOT to use

- Do not run by default for every DB review.
- Do not run when user only needs static/schema-only reasoning.

## Preconditions

1. Ensure harness exists at `/Users/charliehowes/Projects/betika/postgres-bench-lab`.
2. Ensure `.env` exists in harness (`cp .env.example .env` if needed).
3. Ensure `MIGRATIONS_DIR` in `.env` points to the target project migration folder.

## Quick commands

```bash
cd /Users/charliehowes/Projects/betika/postgres-bench-lab
./scripts/reset.sh
./scripts/migrate.sh
./scripts/seed.sh
./scripts/explain.sh
```

## Required outputs

Return:

1. migration path used (`MIGRATIONS_DIR`) and migration files applied,
2. seed scenario summary (cardinality/distribution),
3. explain file path in `artifacts/`,
4. short performance interpretation:
   - total runtime,
   - dominant plan nodes,
   - estimate vs actual mismatch,
   - buffers hit/read,
   - concrete tuning recommendations.

## Scenario authoring rule

Seed data must reflect the tested use case (not placeholders). If inadequate seed data is found, update `SEED_SQL` scenario first, then run benchmark.

## What this skill covers

- **[Run benchmark workflow](usecases/run-benchmark.md)**
