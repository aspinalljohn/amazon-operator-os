---
name: operator-setup
description: First-run setup for Amazon Operator OS. Unpacks the kit, writes the business folder, interviews the operator for sources and logic, and creates the six Grok Bot agents. Use when the user runs /operator-setup, attached the kit zip, or says they just unzipped the kit. Parent session only. Day-one command — do not send them to /sources and /logic as homework.
---

# Operator setup

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow. Do not spawn listing, ads, inventory, customer, or creative as subagents during the interview. The operator is answering questions. A child agent cannot do that.

Day one is this command only. After this sitting they have a business folder, sources.md, logic.md, a refresh card, and six focused Grok Bots. Then they drop files and run /prove.

## 0. Preconditions

**Grok Bot + zip (default buyer path):** The operator attached `amazon-operator-os.zip`. Unzip it in the workspace:

```bash
unzip amazon-operator-os.zip -d <brand-slug>-ops/
cd <brand-slug>-ops
```

The zip **is** the business folder skeleton. At the root you should see `AGENTS.md`, `.grok/` (agents, skills, workflows, commands), `exports/`, `reference/`, `bin/`, `reports/`, `drafts/`, `logs/`. There is no inner `template/` folder in the zip.

Optional: `INSTALL.md` and `EXPORTS.md` at the zip root are the install guide and export catalog. `ONBOARDING.md` explains what is a Grok connection vs a manual export. `reference/what-you-need.md` is the short version inside the business folder.

**Before the brand interview:** Show the operator `reference/what-you-need.md` or the "two buckets" section of `ONBOARDING.md`. Say plainly: "Seller Central is not a Grok plugin — you export CSVs and drop them in exports/. Grok Bot + this zip is all you connect on the Grok side."

**GitHub repo (maintainer path):** Copy `template/` from the repo to `~/Documents/<brand-slug>-ops/` (or the workspace). That folder has the same layout as the zip.

**Grok CLI (optional):** Only required for 5am overnight (`bin/overnight.sh`). If the operator asks for overnight and `grok` is not on PATH, print section 7 of `INSTALL.md` — do not block setup.

## 1. Brand cluster (one at a time)

Ask: brand name, what they sell, 1–3 ASINs (optional), voice (offer the AGENTS.md default), delivery (none / Slack webhook / email-or-generic webhook). Do not ask ACOS or cover here. That is the logic interview.

Slug the brand name: lowercase, dashes, no spaces. If the zip was unpacked to a generic folder name, rename or note the path as `<brand-slug>-ops/`. If that folder already exists from a prior attempt, ask overwrite / use existing / pick another name.

## 2. Write the folder

**Zip path:** You are already inside the business folder. Do not look for a nested `template/` to copy. Fill in place:

- `AGENTS.md` — replace [BUSINESS NAME] and [WHAT YOU SELL] and the voice line
- `reference/brand.md`
- `reference/asins.md`
- `reference/delivery.md` (webhook URL if they pasted one; otherwise method: none)

**Repo path:** Copy `template/` into `~/Documents/<brand-slug>-ops/` (or workspace equivalent), then fill the same files.

`.grok/` is already present (agents, skills, workflows, commands). Do not delete it.

Tell them: "Your business folder is `<path>`. Work from this folder and your Ops bot from now on."

## 3. Sources interview (inline)

Follow `operator-sources` in this same conversation (`.grok/skills/operator-sources/SKILL.md`). Do not ask them to type /sources.

## 4. Logic interview (inline)

Follow `operator-logic` in this same conversation. They may skip; then write defaults-not-reviewed.

## 5. Create the six Grok Bots

Using the agent definitions in `.grok/agents/` (ops, listing, ads, inventory, customer, creative), create one focused Grok Bot per seat:

1. **Ops** — rename or confirm the current agent. Use `ops.md` for the description. This is the default routing bot. Tell it the business folder path.
2. **Listing, Ads, Inventory, Customer, Creative** — create new agents (New → Create new agent) with names and descriptions from each `.md` file's frontmatter and body.

Each bot's description should include: business folder path; read `AGENTS.md`, `reference/sources.md`, and `reference/logic.md` first; write only to `reports/` and `drafts/`; never edit `exports/`.

Tell the operator which bots were created and what each owns. They can pin Ops in the sidebar.

Grok Bot cannot always create agents programmatically. If not, print copy-paste steps: for each seat, New → Create new agent → Edit Profile → paste the matching `.grok/agents/<seat>.md` content and the business folder path.

## 6. Close

Print `reference/how-to-refresh.md`.

Then print this two-bucket summary (do not skip):

```
Grok-side (you did this today): Grok Bot + zip + six bots. No Seller Central plugin. No MCP required.

Your-side (your homework): export files from Seller Central / Ads / Helium10 and drop them in exports/.
  - First file to try: business report CSV → exports/sales/
  - Full table: reference/what-you-need.md or ONBOARDING.md

Optional later: Grok CLI (overnight on Mac), Slack webhook (brief delivery). Skip both for now unless they asked.
```

Say: "Drop or connect those files in `exports/`, then run `/prove` with your Ops bot." Do not install overnight. Do not run /prove unless they already dropped files and asked.
