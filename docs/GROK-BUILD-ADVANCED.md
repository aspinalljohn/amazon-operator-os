# Grok Build (CLI) — advanced local path

**Default buyer path is [Grok Bot](https://docs.x.ai/grok-bot/overview)** — the desktop app with a cloud computer. This doc is for power users who want a **local** business folder, **Grok Build CLI** (`grok` in terminal), **`.rhai` workflows**, and **macOS launchd** overnight.

Grok Bot and Grok Build share skills (`SKILL.md`), agents (`.grok/agents/`), and `AGENTS.md`. They do **not** share the same install or scheduler.

| | Grok Bot (default) | Grok Build CLI (this doc) |
|---|---|---|
| Install | [x.ai/bot](https://x.ai/bot) desktop app | `curl … install.sh` or PowerShell installer |
| Sign in | Cursor account in app | `grok login` or `XAI_API_KEY` |
| Business folder | `/workspace/<brand>-ops/` on cloud VM | `~/Documents/<brand>-ops/` on your machine |
| `/prove` fan-out | Ops coordinates Bots or runs seats in sequence | `weekly-ops.rhai` workflow |
| Overnight | Grok Bot **Routine** on Ops Bot | `bin/overnight.sh` + launchd (Mac only) |
| Laptop can sleep | Yes — cloud keeps running | Mac must stay awake for 5am launchd |

---

## 1. Install Grok Build CLI

**macOS / Linux:**

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok --version
grok login
```

**Windows (PowerShell):**

```powershell
irm https://x.ai/cli/install.ps1 | iex
grok login
```

Or Git Bash / WSL with the bash installer.

---

## 2. Local business folder

```bash
cd ~/Documents/my-brand-ops
grok
```

Unzip the kit here. Skills and agents live under `.grok/`.

Optional plugin updates:

```bash
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

---

## 3. Setup, prove, weekly

Same slash commands as Grok Bot: `/operator-setup`, drop exports, `/prove`, `/weekly`.

`/prove` and `/weekly` start the `weekly-ops.rhai` workflow when the CLI supports it (`agent_budget: 8`).

---

## 4. Overnight (macOS + CLI only)

After green `/prove`:

```text
/install-overnight
/overnight --now
```

This writes `~/Library/LaunchAgents/com.operatoros.overnight.plist` and runs `bin/overnight.sh`, which invokes:

```bash
grok --always-approve --cwd "$OPS_DIR" --max-turns 40 …
```

**Windows / Linux CLI:** no launchd in v1 — run `/weekly` manually or add your own cron.

**Mac sleep:** a sleeping Mac misses 5am launchd. Use an always-on Mac mini or skip overnight.

---

## 5. When to use this path

- You want files on your laptop, not only on the cloud VM
- You need `.rhai` workflow fan-out and headless `--always-approve`
- You are developing the kit repo itself

Brand owners who just want six operators and a morning brief should use **Grok Bot** and [`docs/INSTALL.md`](./INSTALL.md).
