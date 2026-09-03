---
name: operator-setup
description: First-run setup for Amazon Operator OS on Grok Bot. Writes the business folder on the cloud workspace, then interviews the operator for sources and logic in this same sitting. Use when the user runs /operator-setup or says they just installed the kit. Parent session only. Day-one command — do not send them to /sources and /logic as homework.
---

# Operator setup

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow. Do not spawn listing, ads, inventory, customer, or creative. The operator is answering questions. A child agent cannot do that.

Day one is this command only. After this sitting they have sources.md, logic.md, and a refresh card. Then they drop files and run /prove.

## 0. Preconditions (Grok Bot — default)

The operator uses the **Grok Bot desktop app** ([x.ai/bot](https://x.ai/bot)), signed in with Cursor. Their Agent Computer is running.

If they say they only installed **Grok CLI** (`grok` in terminal): tell them the kit's default path is **Grok Bot**, not Grok Build CLI. Point to `docs/GROK-BUILD-ADVANCED.md` for the optional local CLI path. Do not treat CLI install as day-one setup unless they explicitly chose advanced.

If they cannot run skills from the business folder yet, print steps from `docs/INSTALL.md` (install app → create six Bots → copy kit to `/workspace/<brand>-ops/` → enable skills under Settings → Plugins) and stop.

## 0b. Create the Bot roster (first-time only)

If they have not created the six Bots yet, tell them to create these in the Grok Bot sidebar before continuing:

Ops (this Bot), Listing, Ads, Inventory, Customer, Creative.

Enable kit skills per Bot under Settings → Plugins → Yours. Ops needs setup, prove, weekly, overnight; each specialist needs its seat skills.

## 1. Brand cluster (one at a time)

Ask: brand name, what they sell, 1–3 ASINs (optional), voice (offer the AGENTS.md default), delivery (none / Slack webhook / email-or-generic webhook). Do not ask ACOS or cover here. That is the logic interview.

Slug the brand name: lowercase, dashes, no spaces.

**Target folder (Grok Bot default):** `/workspace/<brand-slug>-ops/` on the shared Agent Computer.

**Advanced local Grok Build only:** `~/Documents/<brand-slug>-ops/`.

If the folder already exists, ask overwrite / use existing / pick another name.

## 2. Write the folder

Copy the kit `template/` into that folder on the Agent Computer. Fill:

- `AGENTS.md` — replace [BUSINESS NAME] and [WHAT YOU SELL] and the voice line
- `reference/brand.md`
- `reference/asins.md`
- `reference/delivery.md` (webhook URL if they pasted one; otherwise method: none)

Tell them: "Message Ops in Grok Bot with this folder as home. All six Bots share `/workspace/` on the same computer."

If the current cwd is already the filled business folder, skip the copy.

## 3. Sources interview (inline)

Follow `operator-sources` in this same conversation (`.grok/skills/operator-sources/SKILL.md`). Do not ask them to type /sources.

## 4. Logic interview (inline)

Follow `operator-logic` in this same conversation. They may skip; then write defaults-not-reviewed.

## 5. Close

Print `reference/how-to-refresh.md`. Say: "Drop or connect those files into `exports/`, then run `/prove` here in Ops."

Do not install overnight. Do not run /prove unless they already dropped files and asked.
