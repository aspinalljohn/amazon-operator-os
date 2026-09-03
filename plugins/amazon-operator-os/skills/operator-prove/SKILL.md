---
name: operator-prove
description: Smoke-test Amazon Operator OS on this folder's files. Fans out listing, ads, inventory, customer, and creative via weekly-ops, then prints a two-line scoreboard. Use when the user runs /prove or /prove --fixtures.
argument-hint: [--fixtures]
---

# Operator prove

Smoke test that the OS works on *their* files. Do not call `spawn_subagent`. Start the `weekly-ops` workflow (`mode: prove`). Specialists write the artifacts; you print the scoreboard after the run completes.

Do not poll or sleep-wait. Launch the workflow and use the completion report.

## 0. Optional `--fixtures`

If the user passed `--fixtures` (not buyer-default):

1. Find `scripts/load-fixtures.sh` (cwd, or the kit root that contains `fixtures/` and `scripts/`).
2. Run `bash scripts/load-fixtures.sh "$(pwd)"` so DEST is this business folder.
3. Continue the same prove path.

`load-fixtures.sh` copies fixture CSVs into `exports/` without overwriting files that already exist, and always copies fixture `reference/sources.md` and `reference/logic.md`.

## 1. Read wiring

Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.

List connected vs missing sources (from the sources table). A source with status missing is not demanded as a file.

If logic.md is stamped `defaults-not-reviewed`, warn: "logic is still defaults — run `/logic` or your briefs will look like every other Amazon dashboard." Do not stop.

## 2. Date and ASIN

Pass the date in. Workflows cannot call `timestamp()`. Run `date +%F` and use that YYYY-MM-DD.

Listing and Creative share the prove ASIN:

1. Named ASIN if the operator gave one.
2. Else the first ASIN in `reference/asins.md`.
3. Else the first ASIN in the connected listings source.

Pass that ASIN to the workflow when you have one.

## 3. Fan-out

Start workflow `weekly-ops`:

- Prefer `name: "weekly-ops"` or `script_path` `.grok/workflows/weekly-ops.rhai`
- If the host refuses the path for folder trust, pass `script` as the contents of `.grok/workflows/weekly-ops.rhai` (inline) with the same args
- `args.mode`: `prove`
- `args.date`: the YYYY-MM-DD from step 2
- `args.asin`: the prove ASIN when known
- `agent_budget`: 8
- `validate_only`: false

Do not spawn listing/ads/inventory/customer/creative yourself. The workflow Phase 1 runs those five in `parallel()` with `capability_mode: "read-write"`. Phase 2 ops writes `reports/weekly-report-YYYY-MM-DD.md`.

## 4. Scoreboard

After the workflow completes, check disk. A file full of `(not in the data)` still counts as shipped.

The six artifacts:

| Seat | File |
|---|---|
| listing | `reports/listing-audit-<asin>.md` |
| ads | `reports/ppc-exception-brief-YYYY-MM-DD.md` |
| inventory | `reports/inventory-risk-YYYY-MM-DD.md` |
| customer | `reports/review-intelligence-YYYY-MM-DD.md` |
| creative | `reports/creative-brief-<asin>.md` |
| ops | `reports/weekly-report-YYYY-MM-DD.md` |

If ASIN was resolved inside a specialist, glob `reports/listing-audit-*.md` and `reports/creative-brief-*.md` for this run.

Print exactly two scoreboard lines, then stop:

```
Artifacts: N/6
Logic: K of M watch metrics had data. <metric> = no source.
```

`M` is the row count of logic.md `## Metrics I watch`.

For each watch metric, resolve `source_id`:

- Single id → that row in sources.md must be `status: connected` and readable on disk (or via MCP).
- Composite id → split on `+`, trim each part. **All** parts must be connected and readable. Example: `sales + ads-campaigns` needs both `sales` and `ads-campaigns`.

`K` is how many watch metrics pass that test. Name each failing metric as `<metric> = no source.` If every watch metric had data, omit the metric list.

`/prove` **passes** if all six files exist on disk. It does **not** fail because a watch metric lacks a source — that is the second line, so they can add a source or drop the metric.

Do not fail the run because a watch metric lacks a source. Do not invent numbers. Do not edit `exports/`.
