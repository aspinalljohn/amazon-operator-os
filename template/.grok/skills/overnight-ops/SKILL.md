---
name: overnight-ops
description: Unattended overnight operator run. Pulls daily connected sources, checks them against logic.md, writes a morning brief, and optionally POSTs it. Failure-safe — a missing source never produces a silent empty no-op. Use when the operator says "run overnight", "morning brief", or a scheduled overnight wrapper fires.
when_to_use: Scheduled unattended run, or a noon dry-run of the overnight brief. Not for the weekly report.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Overnight Ops

A scheduled, unattended operator run. No human is watching. Produce a morning brief from daily connected sources and deliver it. Do not ask questions — if something is ambiguous, make the safe call and note it in the brief.

READ_ORDER: AGENTS.md then sources.md then logic.md

Do not spawn specialists. Overnight spawn list is later work. In this version Ops writes the brief alone.

Gather/check is cheap; judgment on flags is the same model in v1. Do not expose a model-router UI.

## 1. Sources to pull

Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the brief.

Pull only sources with freshness daily and status connected. Do not pull weekly/missing/stale rows. Do not invent a source.

Each source is a file path, a Sheet URL, a paste, or an MCP read from `path_or_url`. If a source is unreachable, do NOT skip silently — record it under Source failures and keep going with the rest.

Retry a failing source at most twice. One full pass. Do not loop. Do not burn budget overnight chasing a dead source.

## 2. Checks to run

Checks come from logic.md, not hardcoded ACOS 35 / cover 14.

Use ## Rules, ## Metrics I watch (flag column), ## Exceptions, and ## Overrides. Do not apply a skill-default ACOS or cover number. If logic.md has no flag for a metric, do not invent one.

Flag anything that trips a logic.md flag. Honor launch / FBM / retired / hero overrides. Anomalies: if logic names a trailing-average or multiplier rule, use that; otherwise do not invent a 2x/0.5x rule.

## 3. Brief to draft

Write `reports/morning-brief-YYYY-MM-DD.md` using logic's ## Brief section (must include / must never mention). Top line is logic.md north star, not a hardcoded revenue / ACOS / units block.

### Morning brief shape

```
# Morning brief → [DATE]
**Top line:** north star and the Brief "must include" metrics, today vs trailing window if the data has one.
**Flagged (do first):** every tripped check, most costly at the top, one line each, with the number that tripped it and the obvious next action.
**Quiet:** one line confirming the daily connected sources that came back clean (so silence is verified, not assumed).
**Source failures:** any daily connected source that was missing or unreadable, named explicitly.
**Delivery:** sent / skipped / failed
```

Prefix the title `INCOMPLETE BRIEF` when any daily source is missing or unreadable. Example: `# INCOMPLETE BRIEF Morning brief → [DATE]`. Never use emojis.

Honor "Morning must never mention" from logic.md. Do not add those topics.

## 4. Deliver

Always write the file first.

Read `reference/delivery.md`.

- method none (or empty): Delivery: skipped. Do not POST.
- method slack or webhook: POST the brief body to `url`. Retry at most twice. HTTP 2xx → Delivery: sent. After two failed attempts → Delivery: failed. Do not crash the run.
- Do not copy the URL or other secrets into the brief. The URL stays in delivery.md.

Slack incoming webhooks accept `{"text": "<brief markdown>"}`. A generic webhook can take the same JSON. Treat HTTP 2xx as success. Anything else is failure.

## 5. Failure-safe rule (non-negotiable)

- Never deliver a brief that LOOKS clean when a source failed. A missing source is a flagged event, not a no-op.
- If ZERO sources could be read, write (and deliver if configured) one line only: `Overnight run could not read any source`. Never a clean empty brief.
- Prefix title `INCOMPLETE BRIEF` when any daily source is missing or unreadable.
- Cap: one pass. Do not retry a failing source more than twice. Do not spawn specialists. Do not edit `exports/`.
