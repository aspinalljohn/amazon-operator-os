# Install Amazon Operator OS

One sitting on any platform: install Grok, open your business folder, run `/operator-setup`, drop your exports, run `/prove`. Overnight is optional and **Mac-only** in v1.

Pick your platform below, then follow the shared steps (4–8).

---

## Platform setup

### macOS

**1. Install Grok CLI**

Open Terminal and run:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok --version
```

**2. Sign in to xAI**

```bash
grok login
```

Or launch `grok` once and complete browser login. For headless use, set `XAI_API_KEY` from [console.x.ai](https://console.x.ai).

**3. Open your business folder**

Unzip the kit to `~/Documents/` (or clone the repo). Example:

```bash
cd ~/Documents/my-brand-ops
grok
```

**Overnight (optional):** supported via `/install-overnight` (5am launchd). A Mac that sleeps will miss the run — use an always-on Mac mini or disable sleep for that window.

---

### Linux

**1. Install Grok CLI**

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
grok --version
```

**2. Sign in to xAI**

```bash
grok login
```

Or set `XAI_API_KEY` from [console.x.ai](https://console.x.ai).

**3. Open your business folder**

```bash
cd ~/Documents/my-brand-ops   # or wherever you unzipped
grok
```

**Overnight:** not installed by the kit in v1. Run `/weekly` manually, or add your own cron that calls `bin/overnight.sh` if you accept unsupported setup.

---

### Windows

**1. Install Grok CLI**

Open **PowerShell** (not CMD) and run:

```powershell
irm https://x.ai/cli/install.ps1 | iex
grok --version
```

If `grok` is not found, close and reopen the terminal. The installer adds `%USERPROFILE%\.grok\bin` to your user PATH.

**Alternative:** Git Bash or WSL2 with the Linux installer:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
```

Pick one environment (native Windows or WSL) and stay in it for this project — do not mix paths for the same folder.

**2. Sign in to xAI**

```powershell
grok login
```

Or set `XAI_API_KEY` from [console.x.ai](https://console.x.ai).

**3. Open your business folder**

```powershell
cd C:\Users\You\Documents\my-brand-ops
grok
```

**Overnight:** out of v1 on Windows. Run `/weekly` manually each week.

---

## Shared steps (all platforms)

### 4. Run setup

From the business folder in Grok:

```text
/operator-setup
```

Answer the brand, sources, and logic interview in **that same session**. Setup writes `~/Documents/<brand-slug>-ops/` (or fills the folder you are in) and prints your refresh card.

Do not run `/sources` and `/logic` separately on day one — setup runs both inline.

### 5. Drop your files

Follow `reference/how-to-refresh.md` — only the sources you connected, not the full catalog in `docs/EXPORTS.md`. Newest file in each `exports/` bucket wins.

Typical drops:

| Folder | What to export |
|---|---|
| `exports/sales/` | Seller Central Business Report (Detail Page by Child) |
| `exports/ads/` | SP campaign + search term reports |
| `exports/inventory/` | FBA inventory / inventory planning |
| `exports/reviews/` | Helium10 dump or pasted reviews (Amazon has no clean SC export) |
| `exports/listings/` | Listing markdown or catalog CSV |

### 6. Prove

```text
/prove
```

Expect six dated artifacts under `reports/`. Missing data shows as `(not in the data)`. A watch metric with no source is named on the scoreboard; that does **not** fail `/prove`.

### 7. Cost and refresh

- **`/prove` and `/weekly` run six agent jobs** (five specialists + ops compile). Expect meaningful xAI usage each run. Use weekly for operating rhythm; do not run `/prove` on a loop.
- **Exports must be refreshed** before `/weekly` or overnight. The kit does not pull Seller Central for you. Follow `reference/how-to-refresh.md`.
- **Stale files:** if a daily source is older than your stated freshness, agents may still read it. Re-export before you trust the brief.

### 8. Overnight (optional, Mac only, last)

Only after `/prove` is green:

```text
/install-overnight
```

Then noon dry-run:

```text
/overnight --now
```

Trust 5am only after you see `reports/morning-brief-YYYY-MM-DD.md` and `logs/overnight-YYYY-MM-DD.log`.

---

## Plugin updates (optional)

If you have GitHub access to the kit repo:

```bash
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

The zip path works without a plugin install — agents and skills live under `.grok/` in your business folder.

---

## Commands reference

| Command | When |
|---|---|
| `/operator-setup` | First run — brand + sources + logic interview |
| `/prove` | Smoke test — six artifacts from your files |
| `/weekly` | Operating rhythm after first green prove |
| `/sources` | Add or change data wiring later |
| `/logic` | Change metrics, flags, brief rules |
| `/install-overnight` | Mac only — schedule 5am brief |
| `/overnight --now` | Test the overnight wrapper before 5am |

---

## Help

- What good looks like: `docs/WHAT-GOOD-LOOKS-LIKE.md` (in the repo) or ask support for the Northline Home example.
- Export catalog: `docs/EXPORTS.md`
- Brand-owner guide: `README.md` in your business folder (from the zip)

Support boundary: get you to a green `/prove` on your files and a `logic.md` that looks like you. You edit `sources.md` and `logic.md` yourself after that.
