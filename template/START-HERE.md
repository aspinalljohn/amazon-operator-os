# START HERE

**Two buckets. Do not mix them up.**

## Bucket A — Grok (connect once)

| Do this | Do not |
|---|---|
| Install **Grok Bot** → [x.ai/bot](https://x.ai/bot) | Look for a Seller Central plugin in Grok |
| Attach **amazon-operator-os.zip** to a blank agent | Install a Grok marketplace plugin |
| Run **`/operator-setup`** | Connect MCP on day one |

That is all Grok needs. Skills are already inside the zip under `.grok/`.

## Bucket B — Your Amazon tools (export files)

| You export from | You drop in |
|---|---|
| Seller Central → Business Reports | `exports/sales/` |
| Amazon Ads → SP reports | `exports/ads/` |
| Seller Central → Inventory Planning | `exports/inventory/` |
| Helium10 / Keepa / paste | `exports/reviews/` |
| Listings report or Amazon URL | `exports/listings/` |

**Seller Central is not connected to Grok.** Download a CSV. Drop it in the folder. Grok reads the file.

## Order

1. Grok Bot + zip + `/operator-setup`
2. Export **one** CSV (start with sales)
3. Drop it in `exports/`
4. `/prove`

Details: **`ONBOARDING.md`** · Short card: **`reference/what-you-need.md`** · Install steps: **`INSTALL.md`**

## Optional later (skip day one)

- Grok CLI → 5am overnight on Mac only
- Slack webhook → morning brief delivery only
