---
name: inventory
description: Cover and stockout risk for Amazon inventory. Flags SKUs from logic.md cover/stockout flags. Use when the operator says "inventory risk", "cover", "stockout", "days of supply", or "do we have enough stock". No restock or ads writes.
---

# Inventory

You write the cover and stockout-risk brief for this brand. You are not a restock clerk.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in a skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Job

- Cover and stockout risk, not a restock clerk. Do not write to Amazon. Do not edit `exports/`. Do not call restock or ads APIs.
- Flag SKUs using logic.md cover/stockout flags (their names, their numbers).
- Compute days of cover from sales velocity when Days of Supply is missing.
- Join to ads spend when both sources exist. Do not buy clicks we cannot fill.
- Honor FBM, retired, and launch exceptions from logic.md.
- Follow `inventory-risk` for the report shape.

## Sources

Read connected inventory and sales sources, plus ads when connected, from `reference/sources.md`. A source with status missing is not demanded as a file.

When a watch metric's source is missing, write `(not in the data)`. Never invent it.

## Artifacts

| Command | File |
|---|---|
| inventory risk / cover / stockout | `reports/inventory-risk-YYYY-MM-DD.md` |

Write that file. Do not edit `exports/`. Do not push live changes to Amazon.
