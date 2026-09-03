# Amazon Operator OS

Six named agents that run an Amazon brand from **your files** and **your rules**.

You drop the reports you already export. You tell the OS which numbers you actually watch. It writes a listing audit, ads exception brief, inventory risk, review intelligence, creative brief, and a weekly report that uses *your* north star (TACOS, cover, wasted spend, whatever you named), not a generic ACOS dashboard.

Grok opened in the business folder *is* the OS. You do not edit skills. You do not connect Seller Central APIs. Missing data is written as `(not in the data)`, never invented.

**New here?** One sitting: [install Grok](docs/INSTALL.md) → unzip (or clone) → `/operator-setup` → drop a file → `/prove`. Overnight is optional and last.

---

## Who this is for

An Amazon brand owner or operator who already looks at Seller Central, ads, inventory, and reviews, and wants those files to produce the same briefs every week without a custom build.

Not an agency pack. Not a generic coding-agent starter. Not a bid manager.

## What you get

| Seat | What it writes | What it is not |
|---|---|---|
| **Ops** | Weekly report + optional 5am morning brief | A chatbot |
| **Listing** | `reports/listing-audit-<asin>.md` | A catalog push |
| **Ads** | `reports/ppc-exception-brief-YYYY-MM-DD.md` | A bid manager |
| **Inventory** | `reports/inventory-risk-YYYY-MM-DD.md` | A restock clerk |
| **Customer** | Review intelligence + 3 reply drafts | A helpdesk |
| **Creative** | Image-stack + A+ brief (copy and art direction) | Pixels |

Personalization lives in two files you own:

- `reference/sources.md` → what data you have, where it lives, how you refresh it
- `reference/logic.md` → the number that matters, flags, exceptions, what the morning brief must include and must never mention

Those files beat every default inside a skill. If you watch TACOS, the ads brief watches TACOS. If you skip the logic interview, the file is stamped `defaults-not-reviewed` and the dashboard will look generic until you run `/logic`.

## Day one

You need: a Mac or Linux machine, [Grok CLI](https://x.ai/cli/install.sh), an [xAI account](https://console.x.ai). Windows can run the kit by hand; overnight on Windows is out of v1.

**Zip is the default path.** If you were emailed `amazon-operator-os.zip`, start there. This GitHub repo is the update channel, not a blocker.

```text
1. Install Grok and log in          →  docs/INSTALL.md
2. Unzip the kit (or clone this repo)
3. Open Grok in that folder
4. /operator-setup                  →  brand, sources, and logic in one sitting
5. Drop one of your files           →  follow the printed how-to-refresh.md
6. /prove                           →  six dated files under reports/
```

`/operator-setup` interviews you for sources and logic in that same conversation. Do not treat `/sources` and `/logic` as day-one homework. They exist for later edits.

`/prove` is green when six artifacts exist on disk. A file full of `(not in the data)` still counts. A watch metric with no source is named on the scoreboard; that does not fail `/prove`.

Step-by-step commands, including plugin updates: [`docs/INSTALL.md`](docs/INSTALL.md). What to export from Amazon: [`docs/EXPORTS.md`](docs/EXPORTS.md). Your live list is the refresh card setup writes, not the full catalog.

## Commands

| Command | When |
|---|---|
| `/operator-setup` | Day one. Writes the business folder, then interviews sources + logic. |
| `/prove` | Smoke test on *your* files. Six artifacts + a two-line scoreboard. |
| `/weekly` | Same fan-out, dated for this week. The operating command after the first prove. |
| `/listing-audit <asin>` | Named listing audit. |
| `/creative-brief <asin>` | Named image-stack + A+ brief. |
| `/sources` | Re-interview or add a source after day one. |
| `/logic` | Change a rule. `/logic add If hero cover < 21 days, throttle ads` appends. |
| `/install-overnight` | Optional. 5am local brief on Mac. Only after `/prove` is 6/6. |
| `/overnight --now` | Noon dry-run of the 5am job. Trust 5am only after this is clean. |

Talk to Ops in English (`should I keep spending on the hero SKU?`) or switch `/agent ads`. Ops may spawn one specialist for a question.

## Your business folder

Setup writes `~/Documents/<brand-slug>-ops/` (or fills the unzipped kit). Work from **that** folder, not from the kit source tree.

```
<brand>-ops/
├── AGENTS.md                 context every agent reads
├── exports/                  drop-only. Agents never edit this.
│   ├── sales/
│   ├── ads/
│   ├── inventory/
│   ├── reviews/
│   └── listings/
├── reference/
│   ├── sources.md            what you have
│   ├── logic.md              your rules
│   ├── how-to-refresh.md     only your connected sources
│   ├── brand.md, asins.md, delivery.md
├── reports/                  finished artifacts
├── drafts/                   rewrites and reply drafts
└── logs/                     overnight run log
```

Newest file in each `exports/` bucket wins. Dated names are fine. You do not need every bucket on day one.

Typical drops (not a forced list):

| Bucket | Typical file | From |
|---|---|---|
| `exports/sales/` | `business-report.csv` | Seller Central → Business Reports → Detail Page Sales and Traffic by Child Item |
| `exports/ads/` | `sp-campaigns.csv`, `sp-search-terms.csv` | Ads console → SP Campaign and Search term reports |
| `exports/inventory/` | `fba-inventory.csv` | Inventory Planning or FBA Manage Inventory |
| `exports/reviews/` | `reviews.csv` or `reviews.md` | Helium10 / Keepa / pasted last-90-day dump |
| `exports/listings/` | `catalog.csv`, `listings.md`, or an Amazon URL | All Listings Report, or ASIN + URL + title |

Sheets, Helium10, and pasted dumps map onto the same seats. A source not in `sources.md` is not checked overnight and is not demanded by `/prove`.

## Overnight (optional)

After `/prove` is 6/6, `/install-overnight` loads a 5am local Mac job. Ops always runs. Specialists run only on flags *you* set, max two, never listing or creative. Default priority is inventory → ads → customer unless `logic.md` reorders those three.

A Mac that sleeps will miss 5am. Use an always-on Mac mini, disable sleep for that window, or skip overnight and run `/weekly` by hand. Windows overnight is out of v1.

File is always written to `reports/morning-brief-YYYY-MM-DD.md`. Slack or email is opt-in during setup.

## Updates

Skills and agents ship inside the zip (under `.grok/`). Plugin install is optional, for later updates:

```text
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

Then open Grok in **your** business folder, not in this repo.

## What this is not

- Image generation
- Seller Central login work, or any live catalog / campaign writes
- Custom skill writing because you watch TACOS instead of ACOS (edit `logic.md`)
- A required Slack or email integration
- Advisory time

Support bar: a green `/prove` on your files, and a `logic.md` that looks like you. If `/prove` is not 6/6, reply with the path to `reports/`.

## Safety

- Agents read `exports/`. They never write there.
- Outputs go to `reports/`, `drafts/`, `logs/`, and (setup / `/sources` / `/logic` only) `reference/`.
- Nothing is pushed to Amazon.
- Webhooks and keys stay in local `reference/delivery.md` and your Grok config. Do not commit them.
- Keep the live business folder private. This repo is the kit, not your brand.

## FAQ

**Do I need every Amazon report on day one?** No. Connect what you have. Missing seats still write a file with `(not in the data)`.

**Do I need GitHub?** No. Zip is enough. This repo is for updates if you were invited.

**Can I change the rules later?** Yes. `/logic` or edit `reference/logic.md`. `/sources add …` when a new export appears. No reinstall.

**Why does the weekly report talk about ACOS when I watch TACOS?** `logic.md` is still `defaults-not-reviewed`, or the north star was never set. Run `/logic`. Do not ask for a new skill.

**Overnight did not run.** The Mac slept, Windows is out of v1, or `/prove` was not green before install. Run `/weekly` by hand, or `/overnight --now` on a machine that stays awake.
