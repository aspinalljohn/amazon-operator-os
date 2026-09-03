# Operator onboarding — what you need vs what you export

Read this once during `/operator-setup` or right after. It separates two things operators often mix up.

---

## The two buckets (read this first)

| | **Grok-side** (the app) | **Your-side** (your Amazon tools) |
|---|---|---|
| **What it is** | Grok Bot + the kit zip | CSV/Sheet exports you already download |
| **Who connects it** | You install Grok Bot, attach zip, run setup | You export from Seller Central, Ads, Helium10, etc. |
| **Required?** | Yes — Grok Bot + zip | At least **one** export to see real numbers; none required to finish setup |
| **Grok plugin?** | No marketplace plugin. Skills ship **inside the zip** under `.grok/` | **Not a Grok connection.** Drop files into `exports/` |

**You do not connect Seller Central to Grok.** You export a file, drop it in a folder, Grok reads it.

---

## Part 1 — Grok-side (what runs the OS)

### Required

| Tool | What to do |
|---|---|
| **Grok Bot** | Install from [x.ai/bot](https://x.ai/bot). Sign in with your xAI account. |
| **Kit zip** | Attach `amazon-operator-os.zip` to a **blank** new agent. Say: unzip and run `/operator-setup`. |
| **Six bots** | Setup creates Ops + Listing + Ads + Inventory + Customer + Creative from `.grok/agents/`. |

No GitHub. No Grok marketplace plugin. No MCP. No Seller Central API.

### Optional (skip on day one)

| Tool | Only if you want… | Skip if… |
|---|---|---|
| **Grok CLI** | 5am overnight brief on Mac (`/install-overnight`) | You run `/weekly` by hand or use Grok Bot only |
| **CLI plugin** (`amazon-operator-os`) | GitHub-based skill updates | Zip is enough; re-attach a fresh zip instead |
| **Slack webhook** | Morning brief pushed to Slack | File in `reports/` is enough (`delivery.md` → `none`) |
| **Generic webhook** | Brief POSTed to your automation | Same — optional |
| **Grok Bot Settings → Plugins** | Live Google Sheet / Gmail / Slack as a *source* | You drop CSV exports instead (v1 default) |

**Day-one rule:** Grok Bot + zip + setup. Everything else is later.

---

## Part 2 — Your exports (where the numbers come from)

These are **manual downloads** from tools you already use. Save them into the matching `exports/` folder. Newest file in each folder wins.

| Seat | Where you get the file | Drop here |
|---|---|---|
| Ops · Ads · Inventory | **Seller Central** → Business Reports → Detail Page Sales and Traffic by Child Item | `exports/sales/` |
| Ads | **Amazon Ads** → Sponsored Products → Campaign report + Search term report | `exports/ads/` |
| Inventory | **Seller Central** → Inventory Planning (or FBA Manage Inventory) | `exports/inventory/` |
| Customer | **Helium10**, **Keepa**, or paste reviews (Amazon has no clean SC export) | `exports/reviews/` |
| Listing · Creative | All Listings Report, listing markdown, or a public Amazon URL | `exports/listings/` |

**Not Grok connections.** Grok never logs into Seller Central for you in v1. You export → drop → `/prove`.

### Minimum to see it work

1. **One file** — e.g. business report CSV → `exports/sales/`
2. **`/prove`** — six artifacts appear; missing seats say `(not in the data)`

### Healthy weekly stack (typical brand)

| Source | How often | Overnight uses it? |
|---|---|---|
| Sales CSV | Daily / weekly | Yes (if connected) |
| Ads campaigns + search terms CSV | Daily / weekly | Yes |
| Inventory CSV | Daily / weekly | Yes |
| Reviews dump | Weekly | No (weekly seat only) |
| Listings markdown | Weekly | No |

Your live list after setup: `reference/how-to-refresh.md` (only sources you said you have).

Full column shapes: `EXPORTS.md`.

---

## Part 3 — Day-one checklist

Use this in order. Do not skip to overnight.

```
[ ] 1. Install Grok Bot and sign in
[ ] 2. New → Create new agent (blank)
[ ] 3. Attach amazon-operator-os.zip
[ ] 4. Run /operator-setup (interview + six bots)
[ ] 5. Export ONE file from Seller Central or Ads
[ ] 6. Drop it in the matching exports/ folder
[ ] 7. /prove → six files under reports/
[ ] 8. Read the scoreboard — add sources or drop metrics you do not have
```

**Optional later:**

```
[ ] Grok CLI + /install-overnight (Mac, always-on)
[ ] Slack/webhook in reference/delivery.md
[ ] More exports from the table above
```

---

## Part 4 — What setup will ask you

During `/operator-setup`, Ops asks two things in plain English:

1. **Sources** — "What numbers do you already look at, and where do they live?" → writes `reference/sources.md`
2. **Logic** — "What number matters, what bad looks like?" → writes `reference/logic.md`

You can skip sources you do not have. Skipped = `status: missing` = that seat writes `(not in the data)`, not a failure.

---

## Quick FAQ

**Do I need Helium10?** Only if you want review intelligence. Skip it on day one.

**Do I need every CSV?** No. Connect what you have. Add more after the first green `/prove`.

**Is Seller Central a Grok plugin?** No. Export a CSV manually.

**Is the kit a Grok Bot plugin?** No. It is a zip of skills + folder layout. Attach it to your agent.

**Something broke — where do I look?** `reports/` for artifacts. `reference/sources.md` for wiring. `reference/logic.md` for your rules.
