# Install Amazon Operator OS

One sitting in **Grok Bot**. Create a blank agent, drop the kit zip, run setup. The agent unpacks the kit, interviews you, and stands up your six-operator team. Drop your files, then `/prove`. Overnight is optional and last.

Grok Bot is the primary runtime. [Grok CLI](https://x.ai/cli/install.sh) is only needed if you want the optional 5am overnight job on Mac.

---

## 1. Install Grok Bot

Download the desktop app for your platform: [x.ai/bot](https://x.ai/bot)

- **macOS** — open the disk image, drag Grok Bot to Applications, launch and sign in with your xAI account.
- **Windows** — run the installer, open from Start, sign in.
- **Linux** — install the `.deb`, `.rpm`, or AppImage from More downloads on x.ai/bot.

Full steps: [Grok Bot get started](https://docs.x.ai/grok-bot/get-started)

You need an eligible plan (SuperGrok Plus/Heavy or equivalent Cursor plan).

---

## 2. Create a blank agent

This agent becomes your **Ops** lead. It will unpack the kit and create the specialist bots.

1. In Grok Bot, choose **New** in the sidebar (or `Cmd/Ctrl+N`).
2. Select **Create new agent**.
3. Grok Bot opens a blank agent named **New Agent**.
4. Optional: **Bot actions → Edit Profile** — rename to your brand (e.g. "Northline Ops") or leave the default for now. Setup will refine this.

Do not pick a suggested teammate template. Start blank.

---

## 3. Drop the kit zip

Attach `amazon-operator-os.zip` (from your email) to this agent:

- Drag the zip into the composer, or use the attachment control.

Then send your first task. Copy-paste is fine:

```text
This zip is Amazon Operator OS. Unzip it to a folder named for my brand (e.g. northline-ops/), cd into that folder, then run /operator-setup.

The zip is the business folder — at the root you should see AGENTS.md, .grok/, exports/, and reference/. There is no inner template/ folder.

From there:
- Fill AGENTS.md and reference/ from my answers (do not copy from elsewhere)
- Interview me for sources and logic in this same conversation
- Create focused Grok Bot agents for the six seats using .grok/agents/ (Ops, Listing, Ads, Inventory, Customer, Creative)
- Do not send me to /sources or /logic as homework

When setup finishes, tell me the business folder path and what to drop first in exports/.
```

The agent unpacks the zip into a business folder (`AGENTS.md`, `.grok/`, `exports/`, `reference/` at the root), runs the interviews, and creates the specialist bots from `.grok/agents/`.

---

## 4. Drop your files

Follow the generated `reference/how-to-refresh.md` — only the sources you connected, not the full catalog in `docs/EXPORTS.md`. Newest file in each `exports/` bucket wins.

Typical first file: one Seller Central export (e.g. business report CSV) into `exports/sales/`.

---

## 5. Prove

Back in your Ops agent (or the business folder conversation):

```text
/prove
```

Expect six dated artifacts under `reports/`. Missing data shows as `(not in the data)`. A watch metric with no source is named on the scoreboard; that does not fail `/prove`.

Green = six files exist on disk, even if some are mostly `(not in the data)`.

---

## 6. Run the OS day to day

| What | Where |
|---|---|
| Weekly report, routing, morning brief | Your **Ops** bot |
| Listing audit | **Listing** bot (or ask Ops) |
| Ads exceptions | **Ads** bot |
| Inventory risk | **Inventory** bot |
| Reviews + reply drafts | **Customer** bot |
| Creative briefs (no pixels) | **Creative** bot |

Use `/weekly` after the first green `/prove`. Talk to Ops in plain English or message a specialist bot directly.

Commands reference: see the kit README or ask Ops to list them.

---

## 7. Overnight (optional, last)

Only after `/prove` is 6/6.

Overnight uses **Grok CLI** on Mac — a 5am local job that runs `bin/overnight.sh` in your business folder. Grok Bot is not required for the scheduled run once CLI is installed.

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok login
```

Then in your business folder conversation:

```text
/install-overnight
```

Noon dry-run before you trust 5am:

```text
/overnight --now
```

**Mac sleep warning:** a Mac that sleeps will miss 5am. Use an always-on Mac mini, disable sleep for that window, or skip overnight and run `/weekly` by hand. Windows overnight is out of v1.

---

## Updates (optional)

The zip already ships skills and agent definitions under `.grok/`. For plugin-style updates from GitHub:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash   # if not installed
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

Most buyers never need this. Re-attach a fresh zip to your Ops bot if you prefer.

---

## What to export from Amazon

Catalog of known report shapes: `EXPORTS.md` in the zip (or [`docs/EXPORTS.md`](EXPORTS.md) in this repo). Your live list is the refresh card setup writes, not the full catalog.
