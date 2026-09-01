# Operating logic

status: reviewed

Brand: Northline Home

## North star
The number that matters: TACOS. Target: <18%. Source: sales + ads-campaigns.

## Metrics I watch
| metric | why | source_id | good | flag | seat |
|---|---|---|---|---|---|
| TACOS | total ads efficiency | sales + ads-campaigns | <18% | >22% | ads, ops |
| cover | stockout risk on live SKUs | inventory | >=21 days | <21 days | inventory, ops |
| wasted spend | search terms with spend and no sales | ads-search-terms | $0 wasted | spend >$20 and sales $0 | ads |
| CVR | listing health by child ASIN | sales | >=10% | <5% | listing, ops |

## Rules
- If cover < 21 days on an ASIN that is still spending, throttle ads. Do not buy clicks we cannot fill.
- Flag TACOS above 22%. Target under 18%.
- Flag wasted search terms with spend and zero sales.
- Hero ASIN B0FIXTURE1 always leads every brief.

## Exceptions
- Launch ASINs (tag:launch): ignore TACOS for 14 days after launch.
- B0FIXTURE6 is launch — do not flag its TACOS in the first 14 days.

## Brief
Morning must include: TACOS, cover on hero, wasted spend.
Morning must never mention: impression share.
Weekly must include: north star, what moved, one decision.

## Overnight
priority: inventory, ads, customer
cap: 2

## Overrides
- B0FIXTURE1: always first in every brief, cover flag 21 days
- B0FIXTURE6 / tag:launch: ignore TACOS for 14 days
