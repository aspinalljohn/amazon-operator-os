# Amazon Operator OS

Private kit repo for **Operator Intelligence**: a Grok plugin plus business-folder template that puts six named agents into an Amazon brand owner's workflow.

**Buyers:** use the zip or your `~/Documents/<brand>-ops/` folder. Start with [`template/README.md`](./template/README.md) (included in the zip) or [`docs/INSTALL.md`](./docs/INSTALL.md).

**Maintainers:** this README is the repo walkthrough. Build, test, and ship from here.

---

## What this repo is

| Piece | Path | Purpose |
|---|---|---|
| Grok plugin | `plugins/amazon-operator-os/` | Agents, skills, workflows, slash commands |
| Business template | `template/` | What `/operator-setup` copies to the buyer's ops folder |
| Fixtures | `fixtures/` | Anonymized Northline Home CSVs for QA |
| Pack tests | `tests/kit_check.py` | Invariants — run before every commit |
| Buyer docs | `docs/` | Install, exports catalog, QA, delivery SOP |

One repo, two install paths:

1. **Zip (default)** — `bash scripts/build-zip.sh` → `dist/amazon-operator-os.zip`. Buyer unzips; `.grok/` is already vendored under `template/.grok/`.
2. **Plugin (updates)** — `grok plugin marketplace add …` then `grok plugin install amazon-operator-os --trust`. Setup still writes the business folder.

---

## Docs index

| Doc | Audience |
|---|---|
| [`template/README.md`](./template/README.md) | **Brand owner** — plain-language setup in the zip |
| [`docs/INSTALL.md`](./docs/INSTALL.md) | **Brand owner** — Mac / Linux / Windows install |
| [`docs/EXPORTS.md`](./docs/EXPORTS.md) | Export catalog (not the buyer's live refresh list) |
| [`docs/WHAT-GOOD-LOOKS-LIKE.md`](./docs/WHAT-GOOD-LOOKS-LIKE.md) | Support bar — filled Northline Home example |
| [`docs/QA.md`](./docs/QA.md) | Ship gate matrix + pre-ship live checklist |
| [`docs/DELIVER.md`](./docs/DELIVER.md) | John's fulfillment SOP |
| [`2026-09-01-amazon-operator-os-design.md`](./2026-09-01-amazon-operator-os-design.md) | Product spec |
| [`2026-09-01-amazon-operator-os-implementation-plan.md`](./2026-09-01-amazon-operator-os-implementation-plan.md) | Build plan |

---

## Step-by-step: develop in this repo

### 1. Clone and verify

```bash
git clone git@github.com:aspinalljohn/amazon-operator-os.git
cd amazon-operator-os
python3 tests/kit_check.py    # must print: ok
```

### 2. Edit plugin source

Change agents, skills, or workflows under `plugins/amazon-operator-os/`:

```
plugins/amazon-operator-os/
  agents/          ops, listing, ads, inventory, customer, creative
  skills/          generic procedures (SKILL.md per skill)
  workflows/       weekly-ops.rhai, overnight-ops.rhai
  commands/        slash command wrappers
  personas/        operator.toml
```

Every agent file must contain:

```text
READ_ORDER: AGENTS.md then sources.md then logic.md
```

Buyer-specific numbers live only in `template/reference/` stubs — never in skills.

### 3. Sync template

After plugin changes, vendoring into the zip template:

```bash
bash scripts/sync-template-grok.sh
```

This copies `agents/`, `skills/`, `personas/`, `workflows/` → `template/.grok/`.

### 4. Run pack checks

```bash
python3 tests/kit_check.py
```

Optional:

```bash
grok plugin validate plugins/amazon-operator-os
bash -n template/bin/overnight.sh
```

### 5. Integration test with fixtures

```bash
rm -rf /tmp/northline-ops
mkdir -p /tmp/northline-ops
cp -R template/. /tmp/northline-ops/
bash scripts/load-fixtures.sh /tmp/northline-ops
cd /tmp/northline-ops
grok    # interactive: /prove
```

Expect six files under `reports/`. Weekly north star must be **TACOS**, not generic ACOS 35%.

See [`docs/QA.md`](./docs/QA.md) for the full matrix and **pre-ship live checklist** (required once per release on a Mac with grok).

### 6. Build the buyer zip

```bash
bash scripts/build-zip.sh
# → dist/amazon-operator-os.zip
```

Email that zip per [`docs/DELIVER.md`](./docs/DELIVER.md). Log buyers in `amazon-operator-os-buyers-log.md`.

---

## Step-by-step: buyer journey (what you ship)

1. Buyer installs Grok — platform steps in [`docs/INSTALL.md`](./docs/INSTALL.md) (Mac / Linux / Windows).
2. Buyer unzips to `Documents/` and opens Grok in the folder.
3. Buyer runs **`/operator-setup`** — one interview for brand, sources, and logic.
4. Buyer drops exports per **`reference/how-to-refresh.md`**.
5. Buyer runs **`/prove`** — six artifacts + scoreboard.
6. Optional (Mac): **`/install-overnight`** then **`/overnight --now`**.

Slash commands shipped:

| Command | File |
|---|---|
| `/operator-setup` | `commands/operator-setup.md` |
| `/prove` | `commands/prove.md` |
| `/weekly` | `commands/weekly.md` |
| `/sources` | `commands/sources.md` |
| `/logic` | `commands/logic.md` |
| `/install-overnight` | `commands/install-overnight.md` |
| `/overnight` | `commands/overnight.md` |

---

## Architecture (short)

```
Buyer machine
├── Grok CLI + xAI account
├── Plugin or vendored .grok/ in business folder
└── ~/Documents/<brand>-ops/
    ├── exports/      ← buyer drops CSVs (read-only for agents)
    ├── reference/    ← sources.md + logic.md (buyer rules)
    └── reports/      ← agent outputs
```

Personalization = **`reference/sources.md`** + **`reference/logic.md`**. Skills stay generic. Parent session only for setup/sources/logic — no subagent interviews.

Overnight: Ops checks daily sources, fans out **max 2** flagged specialists (inventory / ads / customer). Never listing or creative. Mac launchd via `bin/overnight.sh`.

---

## Key scripts

| Script | Use |
|---|---|
| `scripts/sync-template-grok.sh` | Plugin → `template/.grok/` |
| `scripts/load-fixtures.sh <ops-folder>` | Copy Northline Home fixtures for `/prove --fixtures` |
| `scripts/build-zip.sh` | Produce `dist/amazon-operator-os.zip` |
| `tests/kit_check.py` | Pack invariants |

---

## Commit checklist

- [ ] `python3 tests/kit_check.py` → ok
- [ ] `bash scripts/sync-template-grok.sh` if plugin changed
- [ ] No client IP (Wood Defender, Velocity paths) in skills
- [ ] Live `/prove` on fixtures if changing workflows (see QA pre-ship checklist)

---

## License / IP

Operator-generic skills only. Private repo. Do not ship buyer webhook URLs, xAI keys, or Seller Central credentials in commits.
