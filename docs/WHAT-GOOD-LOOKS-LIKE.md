# What good looks like

Support bar for a green `/prove` and a morning brief. Anonymized **Northline Home** fixtures. The number that matters is **TACOS**, not ACOS.

If a buyer's artifacts look like a generic ACOS/CVR dashboard, their `logic.md` is wrong or still `defaults-not-reviewed`. Do not write them a new skill.

## Fixture facts

Brand: Northline Home. Hero: B0FIXTURE1 (expandable bamboo drawer organizer). Launch: B0FIXTURE6. Window: one 14-day drop. Week-over-week is `(not in the data)`.

| | |
|---|---|
| Ordered product sales | $29,790.00 |
| Ads spend | $1,300.00 |
| TACOS | 4.36% (target <18%, flag >22%) |
| Hero cover | 12 days, inbound 0, still spending $890 |
| Wasted spend | $40.00 `cheap plastic organizer` BROAD, sales $0 |
| CVR flag | B0FIXTURE3 4.0% (<5%) |
| Campaign trap | B0FIXTURE2 Exact ACOS 41% — **not** the flag. ASIN TACOS 14.39% |

Logic (`fixtures/logic.md`): north star TACOS; cover 21 days; wasted spend >$20 with $0 sales; hero always first; B0FIXTURE6 ignore TACOS 14 days; morning must include TACOS, cover on hero, wasted spend; must never mention impression share; overnight priority inventory, ads, customer; cap 2.

## Scoreboard

After `/prove --fixtures` (ASIN B0FIXTURE1):

```
Artifacts: 6/6
Logic: 4 of 4 watch metrics had data.
```

Six files:

- `reports/listing-audit-B0FIXTURE1.md`
- `reports/ppc-exception-brief-2026-09-01.md`
- `reports/inventory-risk-2026-09-01.md`
- `reports/review-intelligence-2026-09-01.md`
- `reports/creative-brief-B0FIXTURE1.md`
- `reports/weekly-report-2026-09-01.md`

A file full of `(not in the data)` still counts. Missing ads would still be 6/6 with `TACOS = no source.` on line two.

The ads brief on this run said: "Skill-default 35% ACOS not used. Logic names TACOS." If you see 35% ACOS as the flag, that is a QA fail.

## Weekly report → 2026-09-01

Filled from the fixture prove. This is the ops page. Specialist attachments are paths, not pasted briefs.

```
# Weekly report → 2026-09-01

## The number that matters

TACOS **4.36%** ($1,300.00 ads spend / $29,790.00 ordered product sales). Target <18%. Flag >22%. Under target. Does not trip the flag.

Hero B0FIXTURE1 TACOS 5.70% ($890.00 / $15,600.00). B0FIXTURE2 14.39% ($410.00 / $2,850.00). B0FIXTURE6 tag:launch — TACOS not flagged (launch date not in the data; no mapped spend).

One 14-day drop. No prior week in the data. Week-over-week is (not in the data).

## What moved

| metric | value | vs last week | note |
|---|---|---|---|
| TACOS (north star) | 4.36% | (not in the data) — one 14-day drop | Spend $1,300.00 against $29,790.00 sales. Campaign ACOS is not the flag. |
| Cover hero B0FIXTURE1 | 12 days | (not in the data) | Flag <21. Available 180, inbound 0. Still spending $890.00. Implied velocity 15.0 units/day. 135 units short of 21-day cover. |
| Cover rest of catalog | 28–80 days | (not in the data) | B0FIXTURE2 45d, B0FIXTURE3 80d, B0FIXTURE4 35d, B0FIXTURE5 28d, B0FIXTURE6 40d (launch). All >=21. |
| Wasted spend | $40.00 | (not in the data) | `cheap plastic organizer` BROAD: spend $40.00, sales $0.00, 12 orders. Flag: spend >$20 and sales $0. |
| CVR B0FIXTURE1 (hero) | 12.4% | (not in the data) | Good (>=10%). 4,200 sessions / 520 units / $15,600. Conversion is not the constraint. |
| CVR B0FIXTURE3 | 4.0% | (not in the data) | Flag <5%. 950 sessions / 38 units / $1,140. |
| CVR other children | 5.3–10.0% | (not in the data) | B0FIXTURE2 5.3%, B0FIXTURE4 10.0% (on the good line), B0FIXTURE5 8.0%, B0FIXTURE6 7.0% (launch). Between flag and good except B0FIXTURE4. |

## What needs attention

1. Hero cover 12 days while `NLH - B0FIXTURE1 - Exact` is still spending $890.00. Logic: cover <21 days on an ASIN that is still spending → throttle ads. Do not buy clicks we cannot fill. Inbound 0 does not close the 135-unit gap.
2. B0FIXTURE3 CVR 4.0% trips the listing-health flag (<5%).
3. Wasted $40.00 on `cheap plastic organizer`. B0FIXTURE2 has an 8-review leak cluster (8 of 9 dump reviews are 1-star); CVR 5.3% sits just above the <5% flag.

## One decision for next week

Throttle `NLH - B0FIXTURE1 - Exact` until hero cover is back to >=21 days. Replenish 135 units (or more) — inbound 0 does not close the gap. TACOS is not the constraint this week. Do not add listing traffic tests on the hero while cover is 12 days.

## Specialist attachments

- reports/listing-audit-B0FIXTURE1.md
- reports/ppc-exception-brief-2026-09-01.md
- reports/inventory-risk-2026-09-01.md
- reports/review-intelligence-2026-09-01.md
- reports/creative-brief-B0FIXTURE1.md

## Sources

Connected files used (`reference/sources.md` path_or_url):

| id | path |
|---|---|
| sales | exports/sales/business-report.csv |
| ads-campaigns | exports/ads/sp-campaigns.csv |
| ads-search-terms | exports/ads/sp-search-terms.csv |
| inventory | exports/inventory/fba-inventory.csv |
| reviews | exports/reviews/reviews.csv |
| listings | exports/listings/listings.md |
```

## Morning brief → 2026-09-01

Overnight on the same fixtures. Daily connected sources only (sales, ads-campaigns, ads-search-terms, inventory). Reviews and listings are weekly — overnight does not pull them.

Flags that trip: hero cover 12 days (inventory) and wasted $40 (ads). TACOS 4.36% does not trip. Cap 2 → inventory + ads. Customer stays quiet. Delivery method none.

```
# Morning brief → 2026-09-01
**Top line:** TACOS 4.36% ($1,300.00 ads spend / $29,790.00 ordered product sales). Target <18%. Flag >22%. Under flag. Cover on hero B0FIXTURE1: 12 days (flag <21). Wasted spend: $40.00.
**Flagged (do first):**
- B0FIXTURE1 cover 12 days (Available 180, inbound 0) while `NLH - B0FIXTURE1 - Exact` is still spending $890.00. Throttle ads. Replenish 135 units to 21-day cover. reports/inventory-risk-2026-09-01.md
- Wasted spend $40.00 on `cheap plastic organizer` (BROAD, sales $0, flag spend >$20 and sales $0). reports/ppc-exception-brief-2026-09-01.md
**Quiet:** sales, ads-campaigns, ads-search-terms, inventory came back. TACOS under 22%. Non-hero cover 28–80 days. No customer-seat flag on the daily pull.
**Source failures:** none
**Delivery:** skipped
```

Hero leads. Impression share is not mentioned. No emojis. If any daily source had been missing, the title would be `INCOMPLETE BRIEF Morning brief → 2026-09-01`. If zero sources were readable, the file would be one line: `Overnight run could not read any source`.

## Not good

- Top line is revenue, units, or 35% ACOS while `logic.md` names TACOS 22%.
- Invented week-over-week, invented cover, invented reviews.
- A clean-looking brief when a daily source failed.
- Overnight spawning listing or creative.
- Overnight spawning three specialists.
- Writing into `exports/`.
- Copying a Slack/webhook URL into the brief.
- Image files, mockups, or "I generated the image" from Creative. Briefs only.
