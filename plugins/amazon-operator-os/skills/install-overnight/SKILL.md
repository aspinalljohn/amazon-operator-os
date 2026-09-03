---
name: install-overnight
description: Install a scheduled morning brief on Grok Bot (Routine on the Ops Bot, cloud scheduler). For Grok Build CLI advanced path only, may use macOS launchd via bin/overnight.sh. Use when the operator says install overnight, runs /install-overnight, or wants a scheduled morning brief.
---

# Install overnight

Parent session. Do not spawn specialists in this sitting unless they asked to dry-run now.

## Grok Bot (default)

The operator uses **Grok Bot**, not Grok CLI. Do **not** install launchd or tell them to run `grok` in terminal for scheduling.

Create a **Routine** on this Ops Bot. Ask them to confirm:

- Schedule (default: weekdays 5:00 AM in their time zone — adjust if they say so)
- Time zone
- Input: daily connected sources in `reference/sources.md` under `/workspace/<brand>-ops/`
- Output: `reports/morning-brief-YYYY-MM-DD.md` plus conversation summary
- Cap: at most 2 flagged specialists (inventory, ads, customer) — never listing or creative
- Missing data: one-line incomplete alert, never a fake-clean brief
- Delivery: read `reference/delivery.md`; POST only if method is slack/webhook

Draft the routine instruction in plain language, e.g.:

> Every weekday at 5:00 AM [timezone], run the overnight-ops skill for `/workspace/<brand>-ops/`. Read reference/sources.md and reference/logic.md. Pull daily connected exports. Write the morning brief. Fan out at most two flagged specialists per logic.md. If zero sources readable, report failure instead of an empty brief.

Use Grok Bot's routine creation flow (the app creates the Routine from this instruction). Point them to **View conversation details → Routines** to manage it.

## Test run (required)

Before trusting the schedule, tell them:

```text
/overnight --now
```

Run the overnight-ops skill once interactively. They should see a morning brief in `reports/` and a clear summary in chat. Use **Test run** on the Routine if the app offers it.

Routines run on the **cloud computer** — their laptop can be closed.

## Grok Build CLI (advanced only)

Only if they explicitly use the local CLI path (`docs/GROK-BUILD-ADVANCED.md`) **and** the business folder is on their Mac with `bin/overnight.sh`:

### Windows / Linux CLI

Print: `Overnight via launchd is Grok Build advanced on Mac only. Use a Grok Bot Routine, or run /weekly manually.`

Stop unless they switch to Grok Bot Routines.

### macOS CLI + launchd

1. Confirm cwd is the local business folder (has `bin/overnight.sh`, `bin/overnight.plist.example`).
2. `chmod +x bin/overnight.sh`
3. Write `~/Library/LaunchAgents/com.operatoros.overnight.plist` from the example with absolute `__OPS_DIR__`.
4. `launchctl load` the plist.
5. Mac sleep warning: a sleeping Mac misses 5am — prefer Grok Bot Routine instead.

Dry-run: `bash bin/overnight.sh` or `/overnight --now`.

Do not run the wrapper yourself unless they asked to dry-run now.
