# Deliver Amazon Operator OS

John's fulfillment SOP. Same muscle as the Second Brain DIY Kit: Drive walkthrough, zip in email, optional GitHub invite, log the buyer.

SKU: Amazon Operator OS, self-serve kit, $997 (confirm at checkout).

You (John) do this. Buyers do not see this file as a homework list.

## After payment

1. **Email the zip** from john@goaspi.com (text onboarding is in the zip — no video required).
2. **Optional GitHub invite** if they sent a username.
3. **Log the buyer** in `amazon-operator-os-buyers-log.md`.

Do not start custom skill work. Do not log into Seller Central for them.

## Text onboarding (no video)

Buyers self-serve from files in the zip. Nothing to record.

| File | When they read it |
|---|---|
| **`START-HERE.md`** | First — two buckets in 30 seconds |
| **`ONBOARDING.md`** | Before first export — full guide + checklist |
| **`INSTALL.md`** | Step-by-step Grok Bot install |
| **`reference/what-you-need.md`** | During setup — short card in business folder |
| **`exports/README.md`** | When dropping first CSV — reminds them it is not a Grok plugin |

Setup (`/operator-setup`) reads `START-HERE.md` aloud and confirms understanding before the interview.

## Drive walkthrough (optional — skip if no time)

Only if you later record one. Camera on **Grok Bot**, not a terminal. Outline:

1. **Grok Bot install** — download from [x.ai/bot](https://x.ai/bot), sign in with xAI. macOS / Windows / Linux. Point at `docs/INSTALL.md`.
2. **Create a blank agent** — New → Create new agent. This becomes Ops. Do not pick a suggested teammate template.
3. **Drop the zip** — attach `amazon-operator-os.zip`. First message: unzip and run `/operator-setup`. Point them at **`ONBOARDING.md`** before they export anything — Grok-side vs manual exports.
4. **Drop one of their files** — follow the generated `reference/how-to-refresh.md`, not the full catalog in `docs/EXPORTS.md`. Newest file in the bucket wins. One real export is enough to see the path; they can add the rest after `/prove`.
5. **`/prove`** — six dated artifacts under `reports/` plus the two-line scoreboard. Missing data is `(not in the data)`. A watch metric with no source is named on line two; that does not fail `/prove`. Compare against `docs/WHAT-GOOD-LOOKS-LIKE.md` (Northline Home, TACOS north star).

Overnight is optional and last. Only after `/prove` is 6/6. Requires Grok CLI on Mac: `/install-overnight`, then noon dry-run `/overnight --now`. Windows overnight is out of v1. Mac that sleeps will miss 5am.

## Email the zip

From: **john@goaspi.com**

Attachment: `dist/amazon-operator-os.zip` built with `bash scripts/build-zip.sh` (syncs `template/.grok/` from the plugin, then zips `template/`).

Also attach or link: `docs/INSTALL.md` and `docs/EXPORTS.md` (copied into zip as `INSTALL.md`, `ONBOARDING.md`, `START-HERE.md`, `EXPORTS.md`).

Subject: `Amazon Operator OS — zip + START HERE`

Body (copy-paste):

```text
Your kit is attached.

Open START-HERE.md first (inside the zip). Two buckets:

  Grok-side:  Grok Bot + zip + /operator-setup  (no Seller Central plugin)
  Your-side:  Export CSVs from Seller Central/Ads → drop in exports/

Then INSTALL.md for step-by-step.

Day one: Grok Bot → blank agent → attach zip → setup → one CSV in exports/sales/ → /prove.

Reply with reports/ if /prove is not 6/6.
```

## GitHub invite (optional)

Private repo: **aspinalljohn/amazon-operator-os**

Invite only if they asked or sent a username. Zip-only is the default self-serve path. Plugin updates:

```text
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

Do not make the repo public in v1.

## Log the buyer

Append one row to `amazon-operator-os-buyers-log.md` in this repo:

| column | what |
|---|---|
| date | payment / send date |
| email | the address you mailed |
| github | username or blank |
| zip sent | yes / date |
| prove green | blank until they reply 6/6 or you confirm |
| notes | Drive sent, invite sent, defaults-not-reviewed, etc. |

Do not put webhook URLs, xAI keys, or Seller Central logins in the log.

## What's in the box

- Zip of the business folder (`template/` + vendored `.grok/`)
- `docs/INSTALL.md`, `docs/EXPORTS.md` (catalog)
- Plugin / repo access if invited
- Six agents: ops, listing, ads, inventory, customer, creative
- `/operator-setup`, `/sources`, `/logic`, `/prove`, `/weekly`
- Optional overnight (`/install-overnight`, `/overnight --now`)

## What's not

- Image generation
- Seller Central login work
- Custom skill writing
- Claude Code dual install
- Windows overnight
- Advisory time
- Live catalog or campaign writes
- Required Slack/email (optional only)

## Support boundary

"I will get you to a green `/prove` on your files and a `logic.md` that looks like you."

After that: Operator Intelligence cohort or advisory. They edit `sources.md` / `logic.md` themselves. You do not write them a new skill because they watch TACOS instead of ACOS.

If `/prove` is not 6/6: they reply with the path to `reports/`. You read the scoreboard and the logic file. You do not rebuild the pack for one brand.

## IP

Operator-generic skills only. Do not ship Wood Defender, ProductPinion client labs, Velocity-branded PDFs, Higgsfield keys, or private MCP configs.
