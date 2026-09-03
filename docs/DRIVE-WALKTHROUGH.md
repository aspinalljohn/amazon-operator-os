# Drive walkthrough — recording script

Record once. ~25–35 minutes. Screen recording of **Grok Bot** (not terminal). Voice: calm, direct, no hype.

**Goal:** buyer finishes thinking “I can do this in one sitting.”

Attach to buyer email alongside `docs/INSTALL.md` and the zip.

---

## Before you record

- [ ] Fresh Grok Bot account or reset demo Bots
- [ ] `bash scripts/build-zip.sh` → attach `dist/amazon-operator-os.zip`
- [ ] Northline fixtures ready if you demo without live SC data
- [ ] Close unrelated tabs; hide notifications
- [ ] 1920×1080 or 1280×720 recording

---

## Scene 1 — What this is (2 min)

**Show:** Sales page or this repo README — Grok Bot vs chatbot slide (verbal).

**Say:**

> Amazon Operator OS is six named AI operators for your Amazon brand. They run on Grok Bot — a desktop app with a cloud computer that stays on when your laptop is closed. You drop the same CSVs you already export from Seller Central. They write dated reports into a folder you own. They do not change live listings or bids.

**Do not say:** install Grok CLI, terminal, or `grok login`.

---

## Scene 2 — Install Grok Bot (4 min)

**Show:** Browser → [x.ai/bot](https://x.ai/bot) → download for your OS.

| OS | Show on screen |
|---|---|
| Mac | Apple silicon vs Intel picker → drag to Applications → open app |
| Windows | x64 installer → Start menu → Grok Bot |
| Linux | .deb / AppImage → launcher |

**Show:** Welcome → **Sign in with Cursor** → browser auth completes → app shows Agent Computer starting.

**Say:**

> You need an eligible plan — SuperGrok Plus, Cursor Pro+, or similar. Check Get started on docs.x.ai if sign-in fails. First launch can take a few minutes while your cloud computer starts. That computer is where your brand folder lives.

**Screenshot moment 1:** Grok Bot home with Agent Computer **ready** (not “starting”).

---

## Scene 3 — Create six Bots (6 min)

**Show:** Sidebar → **Create Bot** (repeat six times).

Create with these **exact names**:

| # | Name | Suggested description (paste into Bot profile) |
|---|---|---|
| 1 | **Ops** | Amazon brand operator — setup, weekly report, morning brief, routes to specialists |
| 2 | **Listing** | Listing audits — title, bullets, attributes, AI-shopping gaps |
| 3 | **Ads** | PPC exception brief — flags only, no bid changes |
| 4 | **Inventory** | Cover and stockout risk |
| 5 | **Customer** | Review themes and reply drafts |
| 6 | **Creative** | Image-stack and A+ briefs — text only |

**Say:**

> Six Bots, not one chat with six personalities. Each Bot matches a seat in the kit. You will mostly talk to Ops. The others run when you prove, weekly, or overnight needs them.

**Show:** Settings → **Plugins** → **Yours** (or packaged skills after kit deploy).

**Say:**

> After we copy the kit onto your cloud workspace, enable the operator skills for each Bot. Ops gets setup, prove, weekly, and overnight. Each specialist gets one skill family. If a skill is missing from `/`, enable it here for that Bot.

**Screenshot moment 2:** Sidebar with all six Bots visible.

**Screenshot moment 3:** Settings → Plugins → skills enabled for Ops.

**Optional:** Create a **group chat** with all six → say it is optional for visibility; Ops still owns setup.

---

## Scene 4 — Deploy the kit (5 min)

**Show:** Unzip `amazon-operator-os.zip` locally (Finder / Explorer).

**Show:** Open **Ops** Bot chat.

**Type:**

```text
Copy the unzipped template folder to /workspace/my-brand-ops/ on the Agent Computer.
Include the .grok folder with skills and agents.
```

**Show:** Agent Computer file view → `/workspace/my-brand-ops/` with:

- `AGENTS.md`
- `exports/`
- `reference/`
- `.grok/skills/`
- `.grok/agents/`

**Say:**

> Your folder lives on the cloud computer at `/workspace/your-brand-ops/`, not on your laptop. All six Bots share this computer. Exports go in `exports/`. Reports land in `reports/`.

**Screenshot moment 4:** `/workspace/.../ops/` tree in Agent Computer or file browser.

---

## Scene 5 — `/operator-setup` (6 min)

**Show:** Ops chat → type `/` → select **operator-setup**.

**Say:**

> One command, one conversation. Do not run sources and logic separately on day one. Ops interviews you for brand, what reports you already use, and what numbers matter — TACOS vs ACOS, cover days, launch ASIN exceptions.

**Show:** Answer briefly on camera (demo brand: “Northline Home”, home goods, hero ASIN).

**Show:** Files written:

- `reference/sources.md`
- `reference/logic.md`
- `reference/how-to-refresh.md`
- `reference/bot-roster.md`

**Screenshot moment 5:** `reference/how-to-refresh.md` — personal export checklist.

---

## Scene 6 — Drop one export (3 min)

**Show:** Export one CSV from Seller Central (or copy fixture `business-report.csv` into `exports/sales/`).

**Say:**

> You do not need every file on day one. One real export proves the path. Missing data shows as “not in the data” — it does not fail prove.

**Screenshot moment 6:** `exports/sales/business-report.csv` on cloud workspace.

---

## Scene 7 — `/prove` (5 min)

**Show:** Ops → `/prove`.

**Say:**

> Prove runs six seats. Ops may message the other Bots or run their skills. You want six files in `reports/` and a two-line scoreboard.

**Show:** `reports/` with six files. Open weekly report — **TACOS** as north star, not generic ACOS.

**Show scoreboard:**

```text
Artifacts: 6/6
Logic: K of M watch metrics had data.
```

**Screenshot moment 7:** Six artifacts + scoreboard in Ops chat.

**Say:**

> Reply to support with this scoreboard if you are stuck. Green prove is six files exist — not that every metric has data.

---

## Scene 8 — Weekly + overnight (optional, 3 min)

**Show:** Ops → `/weekly` (mention refresh exports first).

**Show:** Ops → `/install-overnight` → Routine created → `/overnight --now` test.

**Say:**

> Overnight is a Routine on the cloud computer. Your laptop can sleep. Max two specialists overnight — inventory, ads, or customer — never listing or creative on the schedule.

**Screenshot moment 8:** Routines panel with next run time.

---

## Scene 9 — Close (1 min)

**Say:**

> Read `README.md` in your ops folder and `docs/INSTALL.md` for your platform. Edit `sources.md` and `logic.md` yourself when your stack changes. Support gets you to green prove — not custom skill rewrites. Optional GitHub invite if you want plugin updates.

**Show:** `template/README.md` or buyer folder README.

---

## Screenshot checklist (for PDF companion)

Export these frames as a PDF “quick start” if you do not publish video chapters:

1. Agent Computer ready
2. Six Bots in sidebar
3. Plugins enabled for Ops
4. `/workspace/.../ops/` folder tree
5. `how-to-refresh.md`
6. One export in `exports/`
7. Six reports + scoreboard
8. Routine scheduled (optional)

---

## Common mistakes (call out in video or FAQ)

| Mistake | Fix |
|---|---|
| Installed Grok CLI instead of Grok Bot app | Use [x.ai/bot](https://x.ai/bot); CLI is advanced only |
| Only created one Bot | Create all six named Bots |
| Folder on laptop, not `/workspace/` | Deploy to cloud Agent Computer |
| Skipped `/operator-setup` | Run it once — sources + logic inline |
| Expected live SC API | Drop CSV exports manually |
| Added Finance / Competitor Bot | Not in v1 kit — use Ops ad hoc |

---

## Post-upload

- [ ] Link in delivery email
- [ ] Log buyer in `amazon-operator-os-buyers-log.md`
- [ ] Pin link in support doc / Notion if used
