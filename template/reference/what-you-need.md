# What you need vs what you export

Static reference — read during setup. Full walkthrough: `ONBOARDING.md`.

## Grok-side (required)

- **Grok Bot** — [x.ai/bot](https://x.ai/bot)
- **Kit zip** attached to a blank agent → `/operator-setup`
- **Six bots** created from `.grok/agents/` during setup

No Seller Central API. No Grok marketplace plugin. No MCP required.

## Grok-side (optional — skip day one)

| Tool | When |
|---|---|
| Grok CLI | 5am overnight on Mac only |
| Slack / webhook | Morning brief delivery only |
| Grok Bot plugins | Live Sheet/Gmail source — not v1 default |

## Your exports (manual — not Grok connections)

| Seat | Export from | Drop in |
|---|---|---|
| Ops · Ads · Inventory | Seller Central → Business Reports | `exports/sales/` |
| Ads | Amazon Ads → SP reports | `exports/ads/` |
| Inventory | Seller Central → Inventory Planning | `exports/inventory/` |
| Customer | Helium10 / Keepa / paste | `exports/reviews/` |
| Listing · Creative | Listings report or Amazon URL | `exports/listings/` |

After setup, your personal list is `reference/how-to-refresh.md`.
