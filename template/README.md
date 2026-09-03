# Amazon Operator OS — your brand operating folder

You run this kit on **[Grok Bot](https://x.ai/bot)** — the desktop app where AI teammates work on a **cloud computer** that stays on when your laptop is closed. You do **not** need to install Grok CLI.

This folder lives on that cloud computer at:

```text
/workspace/<your-brand>-ops/
```

Six Bots read your Amazon exports, apply **your** rules, and write reports here. They do not log into Seller Central for you or change live listings or ads.

Full install steps (Mac, Windows, Linux): see **`docs/INSTALL.md`** in the kit repo or your purchase email.

---

## Before you start

1. Install **Grok Bot** from [x.ai/bot](https://x.ai/bot) (Mac, Windows, or Linux).
2. Sign in with your **Cursor** account.
3. Create **six Bots** in the app: **Ops**, **Listing**, **Ads**, **Inventory**, **Customer**, **Creative**.
4. Copy this folder to `/workspace/<your-brand>-ops/` on the Agent Computer (Ops can help from chat).
5. **Settings → Plugins → Yours** — enable the kit skills for each Bot.

---

## What you get

| Bot | What it writes |
|---|---|
| **Ops** | Weekly report + morning brief |
| **Listing** | Listing audit for one ASIN |
| **Ads** | PPC exception brief (flags only — no bid changes) |
| **Inventory** | Cover / stockout risk |
| **Customer** | Review themes + reply drafts |
| **Creative** | Image-stack and A+ briefs (text only, no image gen) |

Your rules live in two files:

- `reference/sources.md` — what data you have and where it lives
- `reference/logic.md` — metrics, flags, exceptions, brief contents

Agents read those first. Missing numbers are written as `(not in the data)` — never invented.

---

## Step-by-step (first day)

### 1. Open Ops and run setup

In the **Ops** Bot chat, type `/` and choose **operator-setup**:

```text
/operator-setup
```

Answer in **one conversation**:

- Brand name, what you sell, optional hero ASINs
- Which reports you already pull (Business Report, ads, inventory, etc.)
- What you watch (TACOS? cover days?), what should wake you up, launch ASIN exceptions

Ops writes `reference/sources.md`, `reference/logic.md`, and `reference/how-to-refresh.md`.

### 2. Drop your exports

Put CSVs (or pasted reviews) in `exports/` — see **`reference/how-to-refresh.md`** for your list only:

```text
exports/sales/       ← Business Report
exports/ads/         ← Campaign + search term reports
exports/inventory/   ← FBA inventory
exports/reviews/     ← Helium10 or paste (no clean SC export)
exports/listings/    ← Listing pack or catalog
```

Upload from your computer or save from Seller Central using the Bot’s browser. **Agents never edit `exports/`** — re-export and drop a new file.

### 3. Prove it works

In **Ops**:

```text
/prove
```

You want **six files** in `reports/` and a scoreboard like:

```text
Artifacts: 6/6
Logic: 4 of 4 watch metrics had data.
```

Empty sections with `(not in the data)` still count. Fix missing exports or edit `logic.md`.

### 4. Run weekly

After a green prove, refresh exports and run:

```text
/weekly
```

Plan for **weekly** runs — each prove/weekly uses meaningful AI usage.

### 5. Morning brief (optional)

After `/prove` is 6/6, in **Ops**:

```text
/install-overnight
/overnight --now
```

This creates a **Routine** on the cloud computer (e.g. 5am weekdays). Your laptop can be off. Manage under Ops → **Routines**.

---

## Folder map

```text
/workspace/<your-brand>-ops/
├── README.md              ← this file
├── AGENTS.md              ← every Bot reads this first
├── exports/               ← YOU drop CSVs (read-only for Bots)
├── reference/
│   ├── sources.md         ← your data wiring
│   ├── logic.md           ← your metrics and flags
│   ├── how-to-refresh.md  ← your export checklist
│   ├── brand.md, asins.md, delivery.md
├── reports/               ← finished artifacts (dated)
├── drafts/                ← review reply drafts
└── logs/                  ← overnight logs (if used)
```

---

## Commands

| Type `/…` | Bot | Purpose |
|---|---|---|
| `operator-setup` | Ops | First-run interview |
| `prove` | Ops | Test all six seats |
| `weekly` | Ops | Weekly operating run |
| `sources` | Ops | Add or change exports later |
| `logic` | Ops | Change TACOS, cover, brief rules |
| `install-overnight` | Ops | Schedule morning Routine |
| `overnight --now` | Ops | Test overnight once |

Message **@Listing**, **@Ads**, etc. for one seat on demand.

---

## When something looks wrong

| Symptom | Fix |
|---|---|
| Instructions say install Grok CLI | Ignore for Grok Bot — use [x.ai/bot](https://x.ai/bot). CLI is optional advanced only. |
| Skill missing from `/` menu | Settings → Plugins → Yours → enable for this Bot |
| Generic ACOS dashboard | Run `/logic` — may still be `defaults-not-reviewed` |
| `(not in the data)` everywhere | Drop CSVs or set sources to `connected` in `reference/sources.md` |
| `TACOS = no source` | Need **both** sales and ads files (TACOS = spend ÷ sales) |
| Routine missed | Ops → Routines → check paused/failed; refresh daily exports first |

---

## What this kit does not do

- Auto-pull Seller Central without you exporting or using the Bot browser
- Change bids, prices, or catalog live
- Generate product images
- Replace your judgment on spend or replenishment

It surfaces exceptions using **your** rules so you decide faster.

---

## Advanced: local Mac + Grok CLI

Power users who want a folder on `~/Documents/` and macOS launchd instead of Grok Bot Routines: see **`docs/GROK-BUILD-ADVANCED.md`**. Not the default buyer path.

---

## Help

Reply to your purchase email with your scoreboard lines and the path to `reports/`. Support gets you to a green `/prove` and a `logic.md` that sounds like you.
