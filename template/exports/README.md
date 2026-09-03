# exports/ — your data drops

**This folder is not a Grok connection.** You export files from Seller Central, Amazon Ads, Helium10, etc. and drop them here. Grok reads these files. It does not log into Amazon for you.

Newest file in each subfolder wins.

| Folder | Export from | Typical file |
|---|---|---|
| `sales/` | Seller Central → Business Reports | `business-report.csv` |
| `ads/` | Amazon Ads → Sponsored Products | `sp-campaigns.csv`, `sp-search-terms.csv` |
| `inventory/` | Seller Central → Inventory Planning | `fba-inventory.csv` |
| `reviews/` | Helium10, Keepa, or paste | `reviews.csv` or `reviews.md` |
| `listings/` | All Listings Report or Amazon URL | `listings.md` |

After setup: your personal refresh list is `reference/how-to-refresh.md`.

Full guide: `ONBOARDING.md` at the zip root.
