---
name: ppc-exception-brief
description: Flag Amazon ads campaigns and search terms using logic.md ads flags (TACOS, ACOS, wasted spend — their names). Writes reports/ppc-exception-brief-YYYY-MM-DD.md. Use when the operator asks for an ads brief, PPC exceptions, wasted spend, or TACOS. No bid writes.
when_to_use: When the ads agent runs, or the operator asks for a PPC exception brief, wasted spend, harvest candidates, or TACOS/ACOS flags.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
---

# PPC exception brief

Exception brief for Amazon ads. Not a bid manager. Do not write bids. Do not call the Amazon Ads API. Do not edit `exports/`.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## 1. Read wiring first

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.
2. From sources.md, take rows with status connected whose seat includes ads, plus any source_id a watch metric with seat ads needs (sales for TACOS). Newest file in a bucket wins. Do not invent a source that is missing.
3. A source with status missing is not demanded as a file. If a watch metric's source is missing or unreadable, write `(not in the data)` for that metric. Still write the artifact.

## 2. Flags come from logic.md

Use logic.md ads flags. Their names, their numbers.

Ads flags are:
- Any row in ## Metrics I watch whose seat includes `ads`
- Any watch metric named TACOS, ACOS, or wasted spend (operator wording; match case-insensitively)
- North star when it is an ads efficiency metric (TACOS or ACOS)
- ## Rules that name TACOS, ACOS, wasted spend, or ads throttle

Flag campaigns and terms against those flags. Do not treat a campaign ACOS column as TACOS. TACOS is ads spend / product sales and needs the sales source.

Honor ## Exceptions and ## Overrides before you flag:
- Launch ASINs (`tag:launch` or named ASIN): do not flag the ignored ads metric (usually TACOS) for the window logic names. If launch date is not in the data, still honor the tag and note launch date `(not in the data)`.
- Hero ASIN first when logic says so.
- Retired / do-not-report ASINs: omit them.

Map campaign name → ASIN when the name contains an ASIN token (`B0` plus alphanumerics). Unmapped campaigns stay at account level.

Skill-default ACOS applies only when logic has no ads flags: 35%.

## 3. Pull connected ads data

**Campaigns** (typical `exports/ads/sp-campaigns.csv`): Campaign Name, Spend, Sales, ACOS, Impressions, Clicks.

**Search terms** (typical `exports/ads/sp-search-terms.csv`): Customer Search Term, Spend, Sales, ACOS, Orders, Match Type.

If a connected file is unreadable or the wrong report, name the file and the expected columns. Do not guess numbers.

Compute TACOS when logic watches it and both ads-campaigns and sales are connected: total ads spend / ordered product sales (account), and per-ASIN when you can join campaign→ASIN to the sales child ASIN. If either source is missing, TACOS is `(not in the data)`.

## 4. Wasted search terms

When the search-terms source is connected, flag wasted terms using the wasted-spend flag in logic.md (operator name and threshold). If logic names wasted spend with no numeric threshold, use the rule as written.

If the search-terms source is missing, wasted spend is `(not in the data)`. Do not scan a file that sources.md did not connect.

## 5. Harvest candidates

When the search-terms source is connected, list converting terms on broad or phrase that deserve exact: Match Type broad or phrase (any case), and orders > 0 with sales > 0.

If that source is missing, harvest candidates are `(not in the data)`.

## 6. Save output

Write `reports/ppc-exception-brief-YYYY-MM-DD.md` using today's date. Always write the file. No bid writes. No Amazon Ads API. Do not edit `exports/`. Do not push live changes to Amazon.

### Artifact shape

```
# PPC exception brief → [DATE]

[defaults-not-reviewed line if logic.md is stamped that way]

## Flags used
[logic.md ads flags — names and numbers. Or the fallback, only when logic has no ads flags.]

## Exceptions honored
[launch / hero / retired — what was skipped or ordered first]

## Flagged
[campaigns and ASIN/account TACOS or ACOS that trip the flags. Missing source → (not in the data).]

## Wasted search terms
[term, spend, sales, match type — or (not in the data)]

## Harvest candidates
[converting broad/phrase terms recommended for exact — or (not in the data)]

## Watch metrics missing a source
[metric and source_id, or none]

## Sources
[connected files actually used, from sources.md path_or_url]
```

Sources footer lists connected files actually used. Prefer a short table over a wall of prose. Operator metrics over adjectives. No hype, no emojis.
