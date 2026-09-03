# Install Amazon Operator OS (Grok Bot)

This kit runs on **[Grok Bot](https://docs.x.ai/grok-bot/overview)** — xAI’s desktop app with a persistent **cloud computer**. You message named Bots like teammates; they read your exports and write reports. You do **not** install Grok CLI for the default path.

**Advanced:** local folder + Grok Build CLI + launchd → [`docs/GROK-BUILD-ADVANCED.md`](./GROK-BUILD-ADVANCED.md).

One sitting: install Grok Bot → create your six Bots → put the kit on the cloud workspace → `/operator-setup` → drop exports → `/prove`. Overnight is optional and uses a **Routine**, not a cron job on your laptop.

---

## What you need

- An eligible plan (e.g. SuperGrok Plus, Cursor Pro+, Cursor Ultra — see [Get started](https://docs.x.ai/grok-bot/get-started))
- **Grok Bot desktop app** — [x.ai/bot](https://x.ai/bot) (macOS, Windows, or Linux)
- Seller Central (or tool) exports you already pull — the kit does not log into Amazon for you

---

## Step 1 — Install Grok Bot (pick your OS)

Downloads: **[x.ai/bot](https://x.ai/bot)** → choose your platform.

### macOS

1. Download **Apple silicon** or **Intel** (Apple menu → About This Mac: **Chip** = Apple silicon, **Processor** = Intel).
2. Open the disk image, drag **Grok Bot** to Applications.
3. Open Grok Bot. Allow macOS to open the app if prompted.

### Windows

1. Download **x64** or **Arm64** (Settings → System → About → System type).
2. Run the installer.
3. Open Grok Bot from the Start menu.

### Linux

1. Download **x64** or **Arm64** (terminal: `uname -m` → `x86_64` = x64, `aarch64` = Arm64).
2. Install the `.deb`, `.rpm`, or run the AppImage.
3. Open Grok Bot from your launcher.

---

## Step 2 — Sign in

1. Choose **Get started** (or **Sign in with Cursor** in Settings).
2. Complete sign-in in the browser.
3. Wait until your **Agent Computer** finishes starting (first launch can take a few minutes).

You are signed in when you can open a Bot chat and see the computer status ready.

---

## Step 3 — Create your six Bots

In Grok Bot, create **six named Bots** (sidebar → create Bot). **Use exact names** — see `reference/bot-roster.md` in your ops folder (or the template copy before deploy):

| Bot name | Role |
|---|---|
| **Ops** | Default operator — setup, weekly, morning brief, routing |
| **Listing** | Listing audits |
| **Ads** | PPC exception briefs |
| **Inventory** | Cover / stockout risk |
| **Customer** | Review intelligence |
| **Creative** | Image-stack and A+ briefs (text only) |

After deploy, enable skills per Bot (Settings → Plugins → Yours) as listed in `reference/bot-roster.md`.

**Do not add a seventh Bot** (Finance, Competitor, etc.) for v1 — not in the kit.

You will mostly talk to **Ops**. The others run when `/prove`, `/weekly`, or overnight needs their seat.

Optional: one **group chat** with all six for visibility; Ops still owns setup and compile steps.

---

## Step 4 — Put the kit on your cloud workspace

Your Bots share one cloud computer. Keep the business folder here:

```text
/workspace/<your-brand>-ops/
```

**From the zip (typical):**

1. Unzip `amazon-operator-os.zip` on your computer.
2. In the **Ops** Bot chat, ask it to copy the unzipped `template/` contents into `/workspace/<your-brand>-ops/` on the Agent Computer (or upload the zip and ask Ops to unzip there).
3. Confirm the folder has `AGENTS.md`, `exports/`, `reference/`, `.grok/skills/`, `.grok/agents/`.

**From GitHub (if invited):** clone or copy into `/workspace/<your-brand>-ops/` on the cloud computer.

**Enable skills:** Settings → Plugins → **Yours** → enable the operator skills for each Bot (at minimum Ops needs setup/prove/weekly/overnight; specialists need their seat skills).

---

## Step 5 — Run setup (one conversation with Ops)

Open the **Ops** Bot. Type `/` and choose **operator-setup**, or say you just installed the kit.

```text
/operator-setup
```

Answer in one sitting:

1. Brand name, what you sell, optional ASINs, delivery (Slack webhook optional)
2. What reports you already use and where they live
3. What metrics matter, when you want flags, what a generic dashboard would get wrong

Ops writes `reference/sources.md`, `reference/logic.md`, and `reference/how-to-refresh.md` under `/workspace/<your-brand>-ops/`.

Do **not** run `/sources` and `/logic` separately on day one — setup runs both inline.

---

## Step 6 — Drop your exports

On the **cloud computer**, put files in the ops folder (Ops can help):

```text
/workspace/<your-brand>-ops/exports/sales/
/workspace/<your-brand>-ops/exports/ads/
…
```

Follow **`reference/how-to-refresh.md`** — only sources you connected. Newest file in each bucket wins.

You can export on your laptop and upload, or sign into Seller Central in the Bot’s browser once and save CSVs into `/workspace/.../exports/`.

Catalog of known report types: [`docs/EXPORTS.md`](./EXPORTS.md).

---

## Step 7 — Prove

In **Ops**:

```text
/prove
```

Expect **six files** under `reports/` and a two-line scoreboard. Missing data shows as `(not in the data)` — that still counts as shipped.

Ops may `@` the other Bots to run their seats, or run specialist skills in sequence on the shared workspace.

---

## Step 8 — Weekly rhythm

Refresh exports, then in **Ops**:

```text
/weekly
```

**Cost:** each `/prove` or `/weekly` runs multiple agent jobs. Plan for weekly use, not constant re-runs.

---

## Step 9 — Morning brief (optional)

Only after `/prove` is green. In **Ops**:

```text
/install-overnight
```

This creates a Grok Bot **Routine** (scheduled job on the cloud computer), e.g. weekday 5:00 AM in your time zone. It runs the overnight-ops skill: daily checks, at most two flagged specialists (inventory / ads / customer), morning brief in `reports/`.

Test first:

```text
/overnight --now
```

Review the morning brief in the conversation and on disk. Routines keep running when your laptop is closed.

Manage routines: Ops → conversation details → **Routines**.

---

## Commands reference

| Command | Bot | Purpose |
|---|---|---|
| `/operator-setup` | Ops | First-run interview |
| `/prove` | Ops | Six artifacts smoke test |
| `/weekly` | Ops | Weekly operating run |
| `/sources` | Ops | Change data wiring later |
| `/logic` | Ops | Change metrics and flags |
| `/install-overnight` | Ops | Create scheduled morning Routine |
| `/overnight --now` | Ops | Test overnight once |

Type `/` in chat to pick a skill. Use `@Listing`, `@Ads`, etc. to message a specialist directly.

---

## Platform notes

| Platform | Grok Bot app | Overnight Routine |
|---|---|---|
| macOS | Yes | Yes (cloud — laptop can sleep) |
| Windows | Yes | Yes (cloud) |
| Linux | Yes | Yes (cloud) |
| iPhone / Android | Companion app | Start/review; setup on desktop |

---

## Troubleshooting

| Issue | What to do |
|---|---|
| Told to install `grok` CLI | Wrong path — use this doc, not Grok Build CLI, unless you chose the [advanced local path](./GROK-BUILD-ADVANCED.md) |
| Skill not in `/` menu | Settings → Plugins → Yours → enable for this Bot |
| Generic ACOS dashboard | Run `/logic` — file may be `defaults-not-reviewed` |
| `TACOS = no source` on scoreboard | Connect both sales and ads exports (composite metric) |
| Routine did not run | Ops → Routines → check paused / failed run; confirm daily exports landed |

Support bar: [`docs/WHAT-GOOD-LOOKS-LIKE.md`](./WHAT-GOOD-LOOKS-LIKE.md).
