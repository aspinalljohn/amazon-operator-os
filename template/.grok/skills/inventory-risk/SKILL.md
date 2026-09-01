---
name: inventory-risk
description: Flag Amazon SKUs that trip logic.md cover/stockout flags. Computes days of cover from sales velocity when Days of Supply is missing, joins ads spend when both sources exist, honors FBM/retired/launch exceptions. Writes reports/inventory-risk-YYYY-MM-DD.md.
when_to_use: When the inventory agent runs, or the operator asks for cover, stockout risk, days of supply, or whether ads should keep spending into thin inventory.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
---

# Inventory risk

Cover and stockout-risk brief. Not a restock clerk. Do not write to Amazon. Do not edit `exports/`. Do not call restock or ads APIs.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## 1. Read wiring first

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.
2. From sources.md, take rows with status connected whose seat includes inventory, plus sales (velocity) and ads-campaigns when those seats/source_ids exist. Newest file in a bucket wins. Do not invent a source that is missing.
3. A source with status missing is not demanded as a file. If a watch metric's source is missing or unreadable, write `(not in the data)` for that metric. Still write the artifact.
4. Read `reference/asins.md` for tags (`hero`, `launch`, `fbm`, `retired`) when that file has rows.

## 2. Flags come from logic.md

Use logic.md cover/stockout flags. Their names, their numbers.

Cover flags are:
- Any row in ## Metrics I watch whose seat includes `inventory`
- Any watch metric named cover, stockout, days of supply, or days of cover (operator wording; match case-insensitively)
- North star when it is a cover or stockout metric
- ## Rules that name cover, stockout, days of supply, or ads throttle on thin inventory
- ## Overrides that set a per-ASIN cover flag

Flag SKUs against those flags. Per-ASIN override wins over the watch-list number for that ASIN.

Honor ## Exceptions and ## Overrides before you flag:
- FBM SKUs (`tag:fbm`, named ASIN, or fulfillment channel FBM): ignore FBA inbound. Watch vendor lead time instead. If lead time is not in the data, write `(not in the data)`.
- Retired / do-not-report ASINs (`tag:retired` or named): omit them.
- Launch ASINs (`tag:launch` or named ASIN): honor the ignored metric and window logic names. If logic does not ignore cover for launch, still apply cover flags and note the tag. If launch date is not in the data, still honor the tag and note launch date `(not in the data)`.
- Hero ASIN first when logic says so.

Skill-default cover applies only when logic has no cover flag: 14 days.

## 3. Pull connected inventory and sales

**Inventory** (typical `exports/inventory/fba-inventory.csv`): SKU, ASIN, Available, Inbound (if present), Days of Supply (if present).

**Sales** (typical `exports/sales/business-report.csv`): (Child) ASIN, Units Ordered, Ordered Product Sales.

If a connected file is unreadable or the wrong report, name the file and the expected columns. Do not guess numbers.

### Days of cover

Prefer Days of Supply when that column is present and numeric.

When Days of Supply is missing, compute days of cover from sales velocity:
1. Take Units Ordered for the child ASIN from the connected sales source.
2. Take the window from sources.md `how_i_get_it` or from dated rows in the sales file. If neither names a window, computed cover is `(not in the data)`.
3. Daily velocity = Units Ordered / window days. Days of cover = Available / daily velocity.
4. If Units Ordered is 0, cover is no-velocity — do not treat that as a stockout unless Available is 0.

When Days of Supply and Available are both numeric, implied velocity = Available / Days of Supply. Use that to turn inbound units into days if sales is missing.

If the inventory source is missing, cover is `(not in the data)`.

### Inbound vs gap

For each live SKU that is not omitted:
- Flag days = the cover flag that applies to that ASIN.
- Gap days = max(flag days − current cover, 0).
- Inbound days = Inbound / daily velocity when velocity is known; otherwise inbound stays in units and inbound days is `(not in the data)`.
- Inbound covers the gap when (Available + Inbound) reaches flag days of cover, or when inbound days ≥ gap days.

FBM: do not use the FBA Inbound column. Vendor lead time replaces it.

## 4. Join ads spend when both sources exist

When inventory and ads-campaigns are both connected, join spend onto ASINs. Do not buy clicks we cannot fill.

Map campaign name → ASIN when the name contains an ASIN token (`B0` plus alphanumerics). Sum Spend per mapped ASIN. Unmapped campaigns stay at account level.

An ASIN with cover below its flag and Spend > 0 is still buying clicks it cannot fill. Recommend throttle ads.

If the ads source is missing, ads spend is `(not in the data)`. Still flag cover. Do not invent spend. Do not skip the artifact.

## 5. Recommended action

One action per flagged SKU, using only these labels (combine with `+` when both apply):

- **replenish** — cover < flag and inbound does not close the gap (or inbound is 0 / missing / ignored for FBM).
- **throttle ads** — cover < flag and that ASIN still has ads spend. Do not buy clicks we cannot fill.
- **do nothing** — cover ≥ flag, or an exception omits/skips the SKU, or inbound already closes the gap and there is no ads spend to throttle.

Hero first when logic says so. Then other flagged SKUs, most-short-cover first.

## 6. Save output

Write `reports/inventory-risk-YYYY-MM-DD.md` using today's date. Always write the file. Do not edit `exports/`. Do not push live changes to Amazon. No restock API. No ads writes.

### Artifact shape

```
# Inventory risk → [DATE]

[defaults-not-reviewed line if logic.md is stamped that way]

## Flags used
[logic.md cover/stockout flags — names and numbers. Or the fallback, only when logic has no cover flag.]

## Exceptions honored
[FBM / launch / hero / retired — what was skipped, inbound-ignored, or ordered first]

## Flagged
[SKU, ASIN, cover, inbound vs gap, ads spend, action. Missing source → (not in the data).]

## Quiet
[live SKUs that did not trip the cover flag, one line, or none]

## Watch metrics missing a source
[metric and source_id, or none]

## Sources
[connected files actually used, from sources.md path_or_url]
```

Sources footer lists connected files actually used. Prefer a short table over a wall of prose. Operator metrics over adjectives. No hype, no emojis.
