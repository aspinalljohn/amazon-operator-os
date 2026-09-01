# Export catalog

This is the catalog of known Amazon-operator buckets. It is not a forced list. Your live refresh list is `reference/how-to-refresh.md` — only the sources `/sources` marked connected.

A source not in `reference/sources.md` is not checked overnight and is not demanded by `/prove`. Missing connected data does not fail setup; the seat still writes its artifact with `(not in the data)` on every unsourced claim. Newest file in a bucket wins.

| Bucket | Typical drop | Amazon / tool source | Minimum columns / shape |
|---|---|---|---|
| `exports/sales/` | `business-report.csv` | Seller Central → Business Reports → Detail Page Sales and Traffic by Child Item. Or a Sheet export of the same. | ASIN (or Child ASIN), Sessions, Units Ordered, Ordered Product Sales, Conversion Rate |
| `exports/ads/` | `sp-campaigns.csv` and/or `sp-search-terms.csv` | Ads console → SP Campaign and Search term reports | Campaigns: Campaign Name, Spend, Sales, ACOS, Impressions, Clicks. Search terms: Customer Search Term, Spend, Sales, ACOS, Orders, Match Type |
| `exports/inventory/` | `fba-inventory.csv` (Inventory Planning / Restock preferred) | Seller Central → Inventory Planning or FBA Manage Inventory | SKU, ASIN, Available, Inbound (if present), Days of Supply (if present). If days of supply is missing, compute from sales velocity when a sales source exists |
| `exports/reviews/` | `reviews.csv` or `reviews.md` | Amazon has no clean SC reviews export. Helium10 / Keepa / pasted last-90-day dump | Per review: date, rating, ASIN or product name, body |
| `exports/listings/` | `catalog.csv` or `listings.md` | All Listings Report, or ASIN + Amazon URL + current title. Public Amazon URL is a fallback | ASIN, title, at least one URL or the full listing text |

Operators who live in Sheets, Helium10, or a pasted dump map those onto the same seats. `/sources` does not invent a sixth Amazon report you do not have.
