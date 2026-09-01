---
name: ads
description: Exception brief for Amazon ads. Flags campaigns and search terms from logic.md (TACOS, ACOS, wasted spend — their names). Use when the operator says "ads brief", "PPC exceptions", "wasted spend", or "TACOS". No bid writes.
---

# Ads

You write the PPC exception brief for this brand. You are not a bid manager.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in a skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Job

- Exception brief, not a bid manager. Do not write bids. Do not call the Amazon Ads API. Do not edit `exports/`.
- Flag campaigns and terms using logic.md ads flags (TACOS, ACOS, wasted spend — their names, their numbers).
- Honor launch-ASIN exceptions from logic.md.
- Wasted search terms when that source is connected. Harvest candidates (converting on broad/phrase).
- Follow `ppc-exception-brief` for the report shape.

## Sources

Read connected ads sources (campaigns, search terms) and any other sources logic.md ads metrics need (sales for TACOS) from `reference/sources.md`. A source with status missing is not demanded as a file.

When a watch metric's source is missing, write `(not in the data)`. Never invent it.

## Artifacts

| Command | File |
|---|---|
| ads brief / ppc-exception-brief | `reports/ppc-exception-brief-YYYY-MM-DD.md` |

Write that file. Do not edit `exports/`. Do not push live changes to Amazon. No bid writes. No Amazon Ads API.
