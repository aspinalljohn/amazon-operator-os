# Amazon Operator OS — your brand operating folder

You bought a **six-agent operator kit** for your Amazon brand. Grok reads your Seller Central exports, applies **your** metrics and rules, and writes dated reports into this folder. It does not log into Amazon or change live listings or ads.

Read this file top to bottom once. After setup, your daily list is in `reference/how-to-refresh.md`.

---

## What you get

Six specialists, one folder:

| Agent | What it writes |
|---|---|
| **Ops** | Weekly report + morning brief |
| **Listing** | Listing audit for one ASIN |
| **Ads** | PPC exception brief (flags, not bid changes) |
| **Inventory** | Cover / stockout risk |
| **Customer** | Review themes + reply drafts |
| **Creative** | Image-stack and A+ briefs (no image generation) |

Your rules live in two files you own:

- `reference/sources.md` — what data you have and where it lives
- `reference/logic.md` — metrics you watch, flags, exceptions, what the brief must include

Agents read those files first. They never invent numbers — missing data is written as `(not in the data)`.

---

## Step-by-step setup

### Step 1 — Install Grok (pick your computer)

**Mac** — Terminal:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok login
```

**Linux** — same as Mac.

**Windows** — PowerShell:

```powershell
irm https://x.ai/cli/install.ps1 | iex
grok login
```

Close and reopen the terminal if `grok` is not found. You need an [xAI account](https://console.x.ai).

Full platform notes: see `docs/INSTALL.md` in the kit repo, or the install PDF/video from your purchase email.

---

### Step 2 — Open this folder in Grok

```bash
cd path/to/your-brand-ops
grok
```

If setup has not run yet, unzip the kit and `cd` into it first. After setup, work from `~/Documents/<your-brand>-ops/` (Mac/Linux) or `Documents\<your-brand>-ops\` (Windows).

---

### Step 3 — Run setup (one conversation)

Type:

```text
/operator-setup
```

Answer in plain language:

1. Brand name, what you sell, optional hero ASINs
2. What reports you already look at and where they live
3. What numbers matter, when you want to be woken up, and what a generic dashboard would get wrong

Setup writes `reference/sources.md`, `reference/logic.md`, and `reference/how-to-refresh.md`. **Do not skip this** — it is how the kit learns your TACOS vs ACOS, launch ASINs, cover days, etc.

---

### Step 4 — Drop your exports

Open `reference/how-to-refresh.md`. Export only what you connected — not every Amazon report in the catalog.

Put files here (newest wins in each folder):

```
exports/sales/       ← Business Report CSV
exports/ads/         ← Campaign + search term CSVs
exports/inventory/   ← FBA inventory CSV
exports/reviews/     ← Reviews CSV or pasted markdown
exports/listings/    ← Listing pack or catalog
```

**Never edit files in `exports/` from the agents** — they are read-only. Re-export from Seller Central (or Helium10) and drop the new file.

---

### Step 5 — Prove it works

```text
/prove
```

You should see **six files** in `reports/` and a two-line scoreboard:

```
Artifacts: 6/6
Logic: K of M watch metrics had data. ...
```

`/prove` passes when all six files exist. Empty sections with `(not in the data)` still count — add the missing export or remove that metric from `logic.md`.

Compare your weekly report to the Northline Home example in support docs if you are unsure.

---

### Step 6 — Run weekly (your operating rhythm)

After a green prove:

```text
/weekly
```

Refresh exports first. Same six artifacts, dated for this week.

**Cost note:** each `/prove` or `/weekly` runs multiple AI jobs. Plan for weekly runs, not dozens per day.

---

### Step 7 — Morning brief (optional, Mac only)

Only after `/prove` is 6/6:

```text
/install-overnight
/overnight --now
```

If the dry-run looks good, you get a 5am brief on days your Mac is awake. **Windows and Linux:** run `/weekly` manually instead (overnight scheduler is Mac-only in v1).

---

## Folder map

```
your-brand-ops/
├── README.md              ← this file
├── AGENTS.md              ← voice and rules every agent reads
├── exports/               ← YOU drop CSVs here (read-only for agents)
├── reference/
│   ├── sources.md         ← your data wiring
│   ├── logic.md           ← your metrics and flags
│   ├── how-to-refresh.md  ← your personal export checklist
│   ├── brand.md, asins.md, delivery.md
├── reports/               ← finished artifacts (dated)
├── drafts/                ← review reply drafts
├── logs/                  ← overnight run logs
└── bin/overnight.sh       ← Mac overnight wrapper (optional)
```

---

## Commands you will use

| Command | Purpose |
|---|---|
| `/operator-setup` | First-time setup |
| `/prove` | Test all six agents on your files |
| `/weekly` | Weekly operating run |
| `/sources` | Add Helium10, a new report, or change paths |
| `/logic` | Change TACOS target, cover days, brief rules |
| `/install-overnight` | Mac: schedule 5am brief |
| `/overnight --now` | Test overnight before trusting 5am |

Talk to Ops in normal English too: "Should I keep spending on the hero SKU?" Ops can route to Ads or Inventory.

---

## When something looks wrong

| Symptom | Fix |
|---|---|
| Generic ACOS dashboard | Run `/logic` — you may still have `defaults-not-reviewed` |
| `(not in the data)` everywhere | Drop the CSV or fix `reference/sources.md` status to connected |
| Scoreboard says `TACOS = no source` | Connect both sales and ads exports (TACOS needs both) |
| Wrong columns error | Re-export the report named in the error; see export catalog |
| Overnight missed | Mac was asleep — disable sleep or run `/weekly` by hand |
| Windows overnight | Not in v1 — use `/weekly` on a schedule you choose |

---

## What this kit does not do

- Log into Seller Central or Amazon Ads
- Change bids, prices, or catalog live
- Generate product images
- Replace your judgment on replenishment or ad spend

It **surfaces** exceptions using your rules so you decide faster.

---

## Need help?

Reply to your purchase email with the path to `reports/` and your scoreboard lines. Support gets you to a green `/prove` and a `logic.md` that sounds like you — not custom skill rewrites.
