---
name: operator-setup
description: First-run setup for Amazon Operator OS. Writes the business folder, then interviews the operator for sources and logic in this same sitting. Use when the user runs /operator-setup or says they just unzipped the kit. Parent session only. Day-one command — do not send them to /sources and /logic as homework.
---

# Operator setup

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow. Do not spawn listing, ads, inventory, customer, or creative. The operator is answering questions. A child agent cannot do that.

Day one is this command only. After this sitting they have sources.md, logic.md, and a refresh card. Then they drop files and run /prove.

## 0. Preconditions

If `grok` is not runnable or the user is not authenticated, print the install/auth steps from `docs/INSTALL.md` and stop. Do not interview a half-installed machine.

## 1. Brand cluster (one at a time)

Ask: brand name, what they sell, 1–3 ASINs (optional), voice (offer the AGENTS.md default), delivery (none / Slack webhook / email-or-generic webhook). Do not ask ACOS or cover here. That is the logic interview.

Slug the brand name: lowercase, dashes, no spaces. Target folder: `~/Documents/<brand-slug>-ops/`. If it already exists, ask overwrite / use existing / pick another name.

## 2. Write the folder

Copy the kit `template/` into that folder. Fill:
- `AGENTS.md` — replace [BUSINESS NAME] and [WHAT YOU SELL] and the voice line
- `reference/brand.md`
- `reference/asins.md`
- `reference/delivery.md` (webhook URL if they pasted one; otherwise method: none)

Tell them: "Open Grok in that folder from now on." If the current cwd is already the template, fill in place and skip the copy.

## 3. Sources interview (inline)

Follow `plugins/amazon-operator-os/skills/operator-sources/SKILL.md` (or `.grok/skills/operator-sources/SKILL.md` in the business folder) in this same conversation. Do not ask them to type /sources.

## 4. Logic interview (inline)

Follow `operator-logic` in this same conversation. They may skip; then write defaults-not-reviewed.

## 5. Close

Print `reference/how-to-refresh.md`. Say: "Drop or connect those files, then run /prove in this folder." Do not install overnight. Do not run /prove unless they already dropped files and asked.
