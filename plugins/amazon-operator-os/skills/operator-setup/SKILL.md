---
name: operator-setup
description: First-run setup for Amazon Operator OS. Unpacks the kit, writes the business folder, interviews the operator for sources and logic, and creates the six Grok Bot agents. Use when the user runs /operator-setup, attached the kit zip, or says they just unzipped the kit. Parent session only. Day-one command — do not send them to /sources and /logic as homework.
---

# Operator setup

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow. Do not spawn listing, ads, inventory, customer, or creative as subagents during the interview. The operator is answering questions. A child agent cannot do that.

Day one is this command only. After this sitting they have a business folder, sources.md, logic.md, a refresh card, and six focused Grok Bots. Then they drop files and run /prove.

## 0. Preconditions

**Grok Bot (default path):** The operator created a blank agent and attached `amazon-operator-os.zip`. Unzip it in the workspace first (`unzip amazon-operator-os.zip -d ./` or equivalent). The kit root contains `template/`, `.grok/agents/`, and `.grok/skills/`.

**Grok CLI (optional path):** If the operator is in a terminal session with the kit unzipped, `cd` into the business folder. If `grok` is not runnable or the user is not authenticated and they ask for overnight, print the CLI install/auth steps from `docs/INSTALL.md` section 7 and continue setup — CLI is not required for day-one prove in Grok Bot.

## 1. Brand cluster (one at a time)

Ask: brand name, what they sell, 1–3 ASINs (optional), voice (offer the AGENTS.md default), delivery (none / Slack webhook / email-or-generic webhook). Do not ask ACOS or cover here. That is the logic interview.

Slug the brand name: lowercase, dashes, no spaces. Target folder: `~/Documents/<brand-slug>-ops/` on the local machine, or `<brand-slug>-ops/` under the Grok Bot workspace when running in the cloud computer. If it already exists, ask overwrite / use existing / pick another name.

## 2. Write the folder

Copy the kit `template/` into that folder. Fill:
- `AGENTS.md` — replace [BUSINESS NAME] and [WHAT YOU SELL] and the voice line
- `reference/brand.md`
- `reference/asins.md`
- `reference/delivery.md` (webhook URL if they pasted one; otherwise method: none)

Ensure `.grok/` from the kit (agents, skills, workflows, commands) is present in the business folder. If the zip was unpacked at workspace root, copy or merge `.grok/` into the business folder.

Tell them: "Your business folder is `<path>`. Work from this folder and your Ops bot from now on." If the current cwd is already the filled template, skip the copy.

## 3. Sources interview (inline)

Follow `operator-sources` in this same conversation (`.grok/skills/operator-sources/SKILL.md` in the business folder). Do not ask them to type /sources.

## 4. Logic interview (inline)

Follow `operator-logic` in this same conversation. They may skip; then write defaults-not-reviewed.

## 5. Create the six Grok Bots

Using the agent definitions in `.grok/agents/` (ops, listing, ads, inventory, customer, creative), create one focused Grok Bot per seat:

1. **Ops** — rename or confirm the current agent. Use `ops.md` for the description. This is the default routing bot.
2. **Listing, Ads, Inventory, Customer, Creative** — create new agents (New → Create new agent) with names and descriptions from each `.md` file's frontmatter.

Each bot's description should include: read `AGENTS.md`, `reference/sources.md`, and `reference/logic.md` first; write only to `reports/` and `drafts/`; never edit `exports/`.

Tell the operator which bots were created and what each owns. They can pin Ops in the sidebar.

If the runtime cannot create Grok Bots programmatically, print exact copy-paste instructions: for each seat, create a new agent and paste the body of the matching `.grok/agents/<seat>.md` into Edit Profile → description, plus the business folder path.

## 6. Close

Print `reference/how-to-refresh.md`. Say: "Drop or connect those files in exports/, then run /prove with your Ops bot." Do not install overnight. Do not run /prove unless they already dropped files and asked.
