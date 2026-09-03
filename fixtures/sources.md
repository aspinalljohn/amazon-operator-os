# Sources

status: connected

| id | seat | type | path_or_url | freshness | status | how_i_get_it |
|---|---|---|---|---|---|---|
| sales | ops, ads, inventory | csv | exports/sales/business-report.csv | daily | connected | SC → Business Report → Detail Page by Child → 14 days |
| ads-campaigns | ads, ops | csv | exports/ads/sp-campaigns.csv | daily | connected | Ads → SP → Campaign report → 14 days |
| ads-search-terms | ads, ops | csv | exports/ads/sp-search-terms.csv | daily | connected | Ads → SP → Search term report → 14 days |
| inventory | inventory, ops | csv | exports/inventory/fba-inventory.csv | daily | connected | SC → Inventory Planning → FBA inventory |
| reviews | customer | csv | exports/reviews/reviews.csv | weekly | connected | Helium10 / pasted last-90-day reviews dump |
| listings | listing, creative | paste | exports/listings/listings.md | weekly | connected | Listing pack markdown with titles and dp URLs |
