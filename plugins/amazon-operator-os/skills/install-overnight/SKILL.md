---
name: install-overnight
description: Install the 5am local overnight brief via launchd on macOS. Writes the plist, loads it, and tells the operator to noon dry-run before trusting 5am. Use when the operator says "install overnight", runs /install-overnight, or wants a scheduled morning brief.
---

# Install overnight

Install launchd so this business folder gets a 5am local morning brief. Parent session. Do not spawn specialists. Do not start the overnight-ops workflow in this sitting unless they asked to dry-run now.

## Windows

If this machine is Windows, print exactly:

```
out of v1, run /weekly manually.
```

Stop. Do not write a Task Scheduler job.

## Mac sleep warning

Say this before installing:

A Mac that sleeps will miss the 5am run. Use an always-on Mac mini, disable sleep for that window, or skip overnight and run `/weekly` by hand.

## Install (macOS)

1. Confirm cwd is the business folder (has `AGENTS.md`, `bin/overnight.sh`, `bin/overnight.plist.example`, `reference/logic.md`). If `bin/overnight.sh` is missing, the folder was not fully unzipped — re-unzip the kit zip.
2. `chmod +x bin/overnight.sh`
3. Resolve `OPS_DIR` as this folder's absolute path (`pwd -P`).
4. Read `bin/overnight.plist.example`. Replace every `__OPS_DIR__` with that absolute path. Do not leave the placeholder.
5. `mkdir -p ~/Library/LaunchAgents logs reports`
6. Write `~/Library/LaunchAgents/com.operatoros.overnight.plist`
7. If that label is already loaded, `launchctl unload ~/Library/LaunchAgents/com.operatoros.overnight.plist` first (ignore a not-loaded error).
8. `launchctl load ~/Library/LaunchAgents/com.operatoros.overnight.plist`

Plist must keep:

- Label `com.operatoros.overnight`
- `StartCalendarInterval` Hour `5` Minute `0`
- `ProgramArguments` `/bin/bash` `-lc` `<OPS_DIR>/bin/overnight.sh`
- `WorkingDirectory` `<OPS_DIR>`

## Noon dry-run

Do not trust 5am yet. Tell them to run `/overnight --now`. That command runs the wrapper `bin/overnight.sh` — the same script launchd runs at 5am (`grok --always-approve --cwd --max-turns 40` with allow/deny globs). It is not an in-session overnight-ops workflow.

They should see `reports/morning-brief-YYYY-MM-DD.md` and `logs/overnight-YYYY-MM-DD.log`. If the log is missing, the dry-run did not prove 5am.

Do not run the wrapper yourself unless they asked to dry-run now.
