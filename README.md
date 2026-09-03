# Amazon Operator OS

Private kit repo for **Operator Intelligence**: six named operators for Amazon brand owners, built for **[Grok Bot](https://docs.x.ai/grok-bot/overview)** (desktop app + cloud computer).

**Buyers start here:** [`template/README.md`](./template/README.md) (in the zip) and [`docs/INSTALL.md`](./docs/INSTALL.md) (Mac / Windows / Linux).

**Power users / kit development:** [`docs/GROK-BUILD-ADVANCED.md`](./docs/GROK-BUILD-ADVANCED.md) — local folder, Grok Build CLI, `.rhai` workflows, launchd.

---

## Grok Bot vs Grok Build (important)

| | **Grok Bot** (what we sell) | **Grok Build CLI** (advanced) |
|---|---|---|
| Product | Desktop app — [x.ai/bot](https://x.ai/bot) | Terminal `grok` command |
| Sign in | Cursor account in app | `grok login` / API key |
| Workspace | `/workspace/<brand>-ops/` on cloud VM | `~/Documents/<brand>-ops/` local |
| Six seats | Six named **Bots** in the app | Agent types + workflows |
| `/prove` fan-out | Ops `@` specialists or sequential skills | `weekly-ops.rhai` workflow |
| Overnight | **Routine** on Ops Bot (cloud, 24/7) | `bin/overnight.sh` + launchd (Mac) |
| Buyer installs CLI? | **No** | Only if they choose advanced path |

Skills (`SKILL.md`), agents (`.grok/agents/`), and `AGENTS.md` work in both environments. **Do not tell brand owners to install Grok CLI** unless they explicitly want the advanced doc.

---

## Repo layout

| Path | Purpose |
|---|---|
| `plugins/amazon-operator-os/` | Plugin source — agents, skills, workflows, commands |
| `template/` | Business folder copied to `/workspace/<brand>-ops/` |
| `fixtures/` | Northline Home anonymized CSVs for QA |
| `tests/kit_check.py` | Pack invariants |
| `docs/` | Install, exports, QA, delivery, advanced CLI |

---

## Docs index

| Doc | Audience |
|---|---|
| [`template/README.md`](./template/README.md) | **Brand owner** — in the zip |
| [`docs/INSTALL.md`](./docs/INSTALL.md) | **Brand owner** — Grok Bot install (Mac / Win / Linux) |
| [`docs/GTM.md`](./docs/GTM.md) | **Launch checklist**, sales bullets, bot roster decision |
| [`docs/DRIVE-WALKTHROUGH.md`](./docs/DRIVE-WALKTHROUGH.md) | **Record once** — video script + screenshot beats |
| [`docs/GROK-BUILD-ADVANCED.md`](./docs/GROK-BUILD-ADVANCED.md) | Local CLI optional path |
| [`docs/EXPORTS.md`](./docs/EXPORTS.md) | Export catalog |
| [`docs/WHAT-GOOD-LOOKS-LIKE.md`](./docs/WHAT-GOOD-LOOKS-LIKE.md) | Support bar (Northline Home) |
| [`docs/QA.md`](./docs/QA.md) | Ship gate + pre-ship checklist |
| [`docs/DELIVER.md`](./docs/DELIVER.md) | Fulfillment SOP |
| [`2026-09-01-amazon-operator-os-design.md`](./2026-09-01-amazon-operator-os-design.md) | Product spec |

---

## Step-by-step: develop in this repo

### 1. Clone and verify

```bash
git clone git@github.com:aspinalljohn/amazon-operator-os.git
cd amazon-operator-os
python3 tests/kit_check.py   # → ok
```

### 2. Edit plugin source

```
plugins/amazon-operator-os/
  agents/       ops, listing, ads, inventory, customer, creative
  skills/       SKILL.md procedures
  workflows/    weekly-ops.rhai, overnight-ops.rhai (Grok Build CLI)
  commands/     slash wrappers
```

Every agent file must include:

```text
READ_ORDER: AGENTS.md then sources.md then logic.md
```

Buyer-specific numbers belong only in `reference/sources.md` and `reference/logic.md` — never in skills.

### 3. Sync into the zip template

```bash
bash scripts/sync-template-grok.sh
```

Copies plugin → `template/.grok/`.

### 4. Test

```bash
python3 tests/kit_check.py
bash scripts/load-fixtures.sh /tmp/northline-ops
cp -R template/. /tmp/northline-ops/
```

**Grok Bot (buyer path):** deploy `/tmp/northline-ops` to a test cloud `/workspace/…`, create six Bots, run `/prove` in Ops.

**Grok Build CLI (dev path):** `cd /tmp/northline-ops && grok` → `/prove` with workflow.

See [`docs/QA.md`](./docs/QA.md) pre-ship checklist.

### 5. Ship zip

```bash
bash scripts/build-zip.sh   # → dist/amazon-operator-os.zip
```

Fulfillment: [`docs/DELIVER.md`](./docs/DELIVER.md).

---

## Step-by-step: buyer journey (Grok Bot)

1. Install **Grok Bot** from [x.ai/bot](https://x.ai/bot) — Mac, Windows, or Linux.
2. Sign in with Cursor; wait for Agent Computer ready.
3. Create six Bots: Ops, Listing, Ads, Inventory, Customer, Creative.
4. Unzip kit → `/workspace/<brand>-ops/` on cloud computer; enable skills per Bot.
5. **Ops** → `/operator-setup` (brand + sources + logic in one chat).
6. Drop exports per `reference/how-to-refresh.md`.
7. **Ops** → `/prove` → six artifacts in `reports/`.
8. Optional: `/install-overnight` → Routine (cloud scheduler).

---

## Architecture

```text
Grok Bot (buyer)
├── Desktop app (thin client)
├── Cloud computer (/workspace)
│   └── <brand>-ops/
│       ├── exports/     ← buyer CSVs
│       ├── reference/   ← sources.md + logic.md
│       ├── reports/     ← artifacts
│       └── .grok/       ← skills + agents from kit
└── Six named Bots (Ops routes; specialists run seats)
```

---

## Scripts

| Script | Use |
|---|---|
| `scripts/sync-template-grok.sh` | Plugin → `template/.grok/` |
| `scripts/load-fixtures.sh <dir>` | Northline fixtures for prove |
| `scripts/build-zip.sh` | `dist/amazon-operator-os.zip` |
| `tests/kit_check.py` | Invariants |

---

## Commit checklist

- [ ] `python3 tests/kit_check.py` → ok
- [ ] `bash scripts/sync-template-grok.sh` after plugin edits
- [ ] Buyer docs say **Grok Bot app**, not CLI install
- [ ] Pre-ship live `/prove` on Grok Bot (see QA.md)
