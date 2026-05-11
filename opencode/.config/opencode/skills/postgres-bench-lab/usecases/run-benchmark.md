# Use case: run benchmark workflow

Use this procedure to gather query-plan evidence with the local harness.

## 1) Validate configuration

- Open `/Users/charliehowes/Projects/betika/postgres-bench-lab/.env`.
- Confirm:
  - `MIGRATIONS_DIR` is set to the target project migration path (absolute path).
  - `SEED_SQL` points to a scenario script with realistic data.
  - `EXPLAIN_SQL` points to the target query script.

If any of these are missing, stop and ask for/prepare the correct values.

## 2) Prepare database

```bash
cd /Users/charliehowes/Projects/betika/postgres-bench-lab
./scripts/reset.sh
./scripts/migrate.sh
```

## 3) Seed scenario data

```bash
./scripts/seed.sh
```

Seed should model relevant workload shape:

- table cardinality,
- key distribution/skew,
- status/state mix,
- timestamp spread,
- blocked vs ready edge cases for ordering queries.

## 4) Run explain and capture output

```bash
./scripts/explain.sh
```

Repeat as needed for warmup + measured runs.

## 5) Report

Provide:

- artifact file path,
- execution timing highlights,
- dominant cost nodes,
- row estimate vs actual gaps,
- buffer IO highlights,
- prioritized recommendations.
