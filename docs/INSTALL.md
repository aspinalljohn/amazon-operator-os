# Install Amazon Operator OS

One sitting in **Grok Bot**. No video required — everything is in text files inside the zip.

**Read `START-HERE.md` first** (30 seconds). It separates Grok connections from manual exports.

Grok Bot is the primary runtime. [Grok CLI](https://x.ai/cli/install.sh) is only needed for optional 5am overnight on Mac.

---

## 0. START HERE (before anything else)

Open **`START-HERE.md`** in the zip. Two buckets:

| Bucket A — Grok | Bucket B — Your exports |
|---|---|
| Grok Bot + attach zip + `/operator-setup` | Seller Central / Ads / Helium10 → CSV → `exports/` |
| **Not** a Seller Central plugin | **Not** a Grok connection |

Full detail: **`ONBOARDING.md`**. Short card: **`reference/what-you-need.md`**.

---

## 1. Install Grok Bot

Download: [x.ai/bot](https://x.ai/bot)

- **macOS** — disk image → Applications → launch → sign in
- **Windows** — installer → Start menu → sign in
- **Linux** — `.deb`, `.rpm`, or AppImage from x.ai/bot

Plan: SuperGrok Plus/Heavy or equivalent.

---

## 2. Create a blank agent

1. **New** in sidebar (or `Cmd/Ctrl+N`)
2. **Create new agent** — blank "New Agent"
3. This becomes **Ops**. Do not pick a suggested teammate.

---

## 3. Drop the kit zip

Attach `amazon-operator-os.zip`. Paste this first message:

```text
Read START-HERE.md and ONBOARDING.md first. Explain the two buckets to me in plain English before we continue.

Then: unzip to a folder named for my brand (e.g. northline-ops/), cd into it, run /operator-setup.

The zip IS the business folder (AGENTS.md, .grok/, exports/, reference/ at the root — no inner template/).

Setup should:
- Confirm I understand: Seller Central is NOT a Grok plugin — I export CSVs to exports/
- Fill AGENTS.md and reference/ from my answers
- Interview sources + logic inline (not /sources or /logic as homework)
- Create six Grok Bots from .grok/agents/

When done: business folder path + first file to export.
```

---

## 4. Drop your files

Read **`reference/how-to-refresh.md`** (setup writes your personal list).

**First file:** Seller Central → Business Reports → save CSV → **`exports/sales/`**

Newest file in each folder wins. Missing sources = `(not in the data)` — not a failure.

Column shapes: **`EXPORTS.md`**

---

## 5. Prove

In your Ops bot:

```text
/prove
```

Green = six files under `reports/`, even if some say `(not in the data)`.

---

## 6. Day to day

| Job | Bot |
|---|---|
| Weekly report, routing | **Ops** |
| Listing audit | **Listing** |
| Ads exceptions | **Ads** |
| Inventory risk | **Inventory** |
| Reviews | **Customer** |
| Creative briefs | **Creative** |

`/weekly` after first green `/prove`.

---

## 7. Overnight (optional, last)

After `/prove` is 6/6. Requires **Grok CLI** on Mac:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok login
```

Then: `/install-overnight` → `/overnight --now` (noon dry-run).

Mac must stay awake for 5am. Windows overnight is out of v1.

---

## Updates (optional)

Re-attach a fresh zip, or:

```bash
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```
