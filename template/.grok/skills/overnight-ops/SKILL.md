---
name: overnight-ops
description: Unattended overnight operator run. Pulls daily connected sources, checks them against logic.md, writes a morning brief, fans out at most 2 flagged specialists (never listing or creative), and optionally POSTs the brief. Failure-safe — a missing source never produces a silent empty no-op. Use when the operator says "run overnight", "morning brief", /overnight --now, or a scheduled overnight wrapper fires.
when_to_use: Scheduled unattended run, or a noon dry-run of the overnight brief. Not for the weekly report.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Overnight Ops

A scheduled, unattended operator run. No human is watching. Produce a morning brief from daily connected sources, spawn at most two flagged specialists, and deliver. Do not ask questions — if something is ambiguous, make the safe call and note it in the brief.

READ_ORDER: AGENTS.md then sources.md then logic.md

Overnight may spawn max 2 flagged specialists. Never listing or creative. Priority from logic.md ## Overnight, default inventory > ads > customer. Logic may reorder those three, not raise the cap.

Gather/check is cheap; judgment on flags is the same model in v1. Do not expose a model-router UI.

## 0. Parent / wrapper / `/overnight`

If the operator typed `/overnight --now` in an interactive session: run `bash bin/overnight.sh` and wait. That is the noon dry-run of 5am. Do not start the overnight-ops workflow in this session — that skips `--always-approve`, cwd, allow/deny, and `logs/overnight-YYYY-MM-DD.log`.

If this session is already the launchd wrapper (`bin/overnight.sh` / grok `--always-approve --max-turns 40`): do not call `spawn_subagent`. Start the `overnight-ops` workflow.

- Prefer `name: "overnight-ops"` or `script_path` `.grok/workflows/overnight-ops.rhai`
- If the host refuses the path for folder trust, pass `script` as the contents of `.grok/workflows/overnight-ops.rhai` (inline) with the same args
- `args.date`: YYYY-MM-DD. Run `date +%F` first. Workflows cannot call `timestamp()`.
- `agent_budget`: 8
- `validate_only`: false

`/overnight` without `--now` may start the workflow in this session (interactive, not a 5am proof).

Do not spawn listing, ads, inventory, customer, or creative yourself. The workflow Checks agent (ops) builds the spawn list; Specialists `parallel()` at most 2, then retries a failed spawn at most twice; Attach ops writes paths onto the brief and POSTs.

## 1. Sources to pull

Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the brief.

Pull only sources with freshness daily and status connected. Do not pull weekly/missing/stale rows. Do not invent a source.

Each source is a file path, a Sheet URL, a paste, or an MCP read from `path_or_url`. If a source is unreachable, do NOT skip silently — record it under Source failures and keep going with the rest.

Retry a failing source at most twice. One full pass. Do not loop. Do not burn budget overnight chasing a dead source.

## 2. Checks to run

Checks come from logic.md, not hardcoded ACOS 35 / cover 14.

Use ## Rules, ## Metrics I watch (flag column), ## Exceptions, and ## Overrides. Do not apply a skill-default ACOS or cover number. If logic.md has no flag for a metric, do not invent one.

Flag anything that trips a logic.md flag. Honor launch / FBM / retired / hero overrides. Anomalies: if logic names a trailing-average or multiplier rule, use that; otherwise do not invent a 2x/0.5x rule.

## 3. Fan-out (cap 2)

Build the spawn list from tripped flags only. Quiet morning (nothing tripped): spawn nobody. Still write and deliver the brief.

Map seat from the flag:

- inventory-seat flags (cover, stockout, days of supply / cover) → `inventory`
- ads-seat flags (TACOS, ACOS, wasted spend) → `ads`
- customer-seat flags (refund, review, rating, 1-star) → `customer`

Priority from logic.md ## Overnight. Default: inventory, ads, customer. Logic may reorder those three. Cap is **2**. If logic sets cap above 2, keep 2 and say so in the brief.

Never listing. Never creative. Drop those seats if they appear.

The overnight-ops workflow `parallel()`s at most 2 specialists, then retries a failed spawn at most twice, then records the slot as `(not in the data)` and moves on. Callers pass `agent_budget` 8 (ops checks + cap 2 specialists + 2 retries each + attach). Do not raise the specialist cap.

Specialist artifacts:

| Seat | File |
|---|---|
| inventory | `reports/inventory-risk-YYYY-MM-DD.md` |
| ads | `reports/ppc-exception-brief-YYYY-MM-DD.md` |
| customer | `reports/review-intelligence-YYYY-MM-DD.md` (and `drafts/review-replies-YYYY-MM-DD.md`) |

## 4. Brief to draft

Write `reports/morning-brief-YYYY-MM-DD.md` using logic's ## Brief section (must include / must never mention). Top line is logic.md north star, not a hardcoded revenue / ACOS / units block.

Checks agent writes the skeleton (no Delivery POST yet). Attach agent fills specialist paths and sets Delivery.

### Morning brief shape

```
# Morning brief → [DATE]
**Top line:** north star and the Brief "must include" metrics, today vs trailing window if the data has one.
**Flagged (do first):** every tripped check, most costly at the top, one line each, with the number that tripped it, the obvious next action, and the specialist artifact path if one ran.
**Quiet:** one line confirming the daily connected sources that came back clean (so silence is verified, not assumed).
**Source failures:** any daily connected source that was missing or unreadable, named explicitly.
**Delivery:** sent / skipped / failed
```

Prefix the title `INCOMPLETE BRIEF` when any daily source is missing or unreadable. Example: `# INCOMPLETE BRIEF Morning brief → [DATE]`. Never use emojis.

Honor "Morning must never mention" from logic.md. Do not add those topics.

## 5. Deliver

Always write the file first.

Read `reference/delivery.md`.

- method none (or empty): Delivery: skipped. Do not POST.
- method slack or webhook: POST the brief body to `url`. Retry at most twice. HTTP 2xx → Delivery: sent. After two failed attempts → Delivery: failed. Do not crash the run.
- Do not copy the URL or other secrets into the brief. The URL stays in delivery.md.

Slack incoming webhooks accept `{"text": "<brief markdown>"}`. A generic webhook can take the same JSON. Treat HTTP 2xx as success. Anything else is failure.

## 6. Failure-safe rule (non-negotiable)

- Never deliver a brief that LOOKS clean when a source failed. A missing source is a flagged event, not a no-op.
- If ZERO sources could be read, write (and deliver if configured) one line only: `Overnight run could not read any source`. Never a clean empty brief. Do not spawn specialists.
- Prefix title `INCOMPLETE BRIEF` when any daily source is missing or unreadable.
- Cap: one pass. Do not retry a failing source more than twice. Do not retry a failed specialist spawn more than twice. Overnight may spawn max 2 flagged specialists. Never listing or creative. Do not edit `exports/`.
