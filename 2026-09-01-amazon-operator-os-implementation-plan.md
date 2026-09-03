# Amazon Operator OS Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a self-serve Grok kit that puts six named agents in an Amazon brand owner's business folder, interviews them (parent session only) for sources and logic, and proves all six artifacts from fixtures.

**Architecture:** One private repo is both a Grok plugin and a zip-able business-folder template. Skills are generic procedures. Buyer-specific wiring lives in `reference/sources.md` and `reference/logic.md`, captured by the main agent during `/operator-setup`. Specialists are custom Grok agent types spawned only after setup, never during the interview.

**Tech Stack:** Grok CLI, SKILL.md, Grok agent markdown, Grok workflows (`.rhai`), launchd, Python 3 for `tests/kit_check.py`, macOS.

**Spec:** `Documents/operator-intelligence/amazon-operator-os/2026-09-01-amazon-operator-os-design.md`

## Global Constraints

- Repo root: `/Users/johnaspinall/Documents/operator-intelligence/amazon-operator-os/`
- Runtime: Grok CLI + xAI account. Skill bodies stay portable SKILL.md.
- Buyer never edits a skill. Their files win over skill defaults.
- Interview is parent/Ops only. Never `spawn_subagent` during setup, sources, or logic. Never a workflow for the interview. Day one is `/operator-setup` only.
- `/sources` and `/logic` exist as later-edit commands, not day-one homework.
- Creative v1 is briefs only. No image APIs, no Higgsfield, no gpt-image.
- No Amazon APIs. No live catalog or campaign writes.
- Overnight specialist cap is 2. Priority default inventory > ads > customer. Listing and creative never run overnight. Logic may reorder those three, not raise the cap.
- Honesty: missing numbers are `(not in the data)`. Never invent.
- Every agent file must contain the exact marker: `READ_ORDER: AGENTS.md then sources.md then logic.md`
- Outputs only under `reports/`, `drafts/`, `logs/`, `reference/`. `exports/` is read-only.
- Operator-generic IP only. Do not copy Wood Defender, Velocity client paths, ProductPinion labs, or John's MCP secrets.
- `kit_check.py` must pass at the end of every task. `/prove --fixtures` is the integration gate from Task 10 onward.
- Voice in buyer-facing copy: direct, no hype, no emojis.

---

## File map

| Path | Responsibility |
|---|---|
| `tests/kit_check.py` | Invariant tests for the pack. Grows each task. |
| `.grok-plugin/marketplace.json` | Marketplace index. |
| `plugins/amazon-operator-os/plugin.json` | Plugin manifest. |
| `plugins/amazon-operator-os/agents/*.md` | Six agent types. |
| `plugins/amazon-operator-os/personas/operator.toml` | Operator persona. |
| `plugins/amazon-operator-os/skills/*/SKILL.md` | Generic procedures. |
| `plugins/amazon-operator-os/workflows/*.rhai` | `/prove` `/weekly` overnight fan-out. |
| `template/` | What setup copies to `~/Documents/<brand>-ops/`. |
| `fixtures/` | Anonymized CSVs + fixture `logic.md` / `sources.md`. |
| `docs/INSTALL.md` `EXPORTS.md` `WHAT-GOOD-LOOKS-LIKE.md` `DELIVER.md` | Buyer + John docs. |
| `template/bin/overnight.sh` | Headless overnight wrapper. |

Vendor a copy of `plugins/amazon-operator-os/{agents,skills,personas,workflows}` into `template/.grok/` at the end of Task 1 and refresh it whenever those files change (a `sync_template_grok` function in `kit_check.py` is not required; a `scripts/sync-template-grok.sh` is).

---

### Task 1: Repo scaffold + kit_check

**Files:**
- Create: `tests/kit_check.py`
- Create: `.grok-plugin/marketplace.json`
- Create: `plugins/amazon-operator-os/plugin.json`
- Create: `scripts/sync-template-grok.sh`
- Create: `README.md`
- Create: `.gitignore`

**Interfaces:**
- Consumes: nothing
- Produces: `kit_check.py` with `fail(msg)` / `ok(name)` helpers; marketplace plugin name `amazon-operator-os`; `scripts/sync-template-grok.sh` copies plugin agents/skills/personas/workflows into `template/.grok/`

- [ ] **Step 1: Write the failing kit check**

```python
#!/usr/bin/env python3
"""Pack invariants for Amazon Operator OS. Run from repo root: python3 tests/kit_check.py"""
from __future__ import annotations
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins" / "amazon-operator-os"
TEMPLATE = ROOT / "template"
FIXTURES = ROOT / "fixtures"
PREAMBLE = "READ_ORDER: AGENTS.md then sources.md then logic.md"
failures: list[str] = []


def fail(msg: str) -> None:
    failures.append(msg)


def require(path: Path, msg: str | None = None) -> None:
    if not path.exists():
        fail(msg or f"missing {path.relative_to(ROOT)}")


def main() -> int:
    require(ROOT / ".grok-plugin" / "marketplace.json")
    require(PLUGIN / "plugin.json")
    mp = ROOT / ".grok-plugin" / "marketplace.json"
    if mp.exists():
        data = json.loads(mp.read_text())
        names = [p.get("name") for p in data.get("plugins", [])]
        if "amazon-operator-os" not in names:
            fail("marketplace.json must list plugin amazon-operator-os")
    if failures:
        print("FAIL")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

- [ ] **Step 2: Run it and confirm it fails**

Run: `python3 tests/kit_check.py`
Expected: FAIL with `missing .grok-plugin/marketplace.json`

- [ ] **Step 3: Write marketplace, plugin.json, gitignore, README, sync script**

`.grok-plugin/marketplace.json`:

```json
{
  "name": "Operator Intelligence",
  "description": "Grok packs for Amazon brand operators",
  "owner": { "name": "John Aspinall", "email": "john@goaspi.com" },
  "plugins": [
    {
      "name": "amazon-operator-os",
      "description": "Six-agent Amazon operator OS: Ops, Listing, Ads, Inventory, Customer, Creative",
      "source": { "type": "local", "path": "./plugins/amazon-operator-os" }
    }
  ]
}
```

`plugins/amazon-operator-os/plugin.json`:

```json
{
  "name": "amazon-operator-os",
  "description": "Amazon Operator OS — six agents, sources + logic interviews, overnight brief",
  "version": "0.1.0"
}
```

`.gitignore`:

```
.DS_Store
__pycache__/
*.pyc
logs/
template/exports/**/*.csv
!fixtures/**
```

`scripts/sync-template-grok.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/template/.grok"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$ROOT/plugins/amazon-operator-os/agents" "$DEST/agents"
cp -R "$ROOT/plugins/amazon-operator-os/skills" "$DEST/skills"
# Do not mkdir personas/workflows/commands before cp — that nests source/ one level too deep.
if [ -d "$ROOT/plugins/amazon-operator-os/personas" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/personas" "$DEST/personas"
fi
if [ -d "$ROOT/plugins/amazon-operator-os/workflows" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/workflows" "$DEST/workflows"
fi
if [ -d "$ROOT/plugins/amazon-operator-os/commands" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/commands" "$DEST/commands"
fi
echo "synced template/.grok"
```

`README.md` (short): private kit repo, point to the spec and INSTALL.md, do not document unbuilt commands as if they work.

- [ ] **Step 4: Re-run kit_check**

Run: `python3 tests/kit_check.py`
Expected: `ok`

- [ ] **Step 5: Commit**

```bash
chmod +x scripts/sync-template-grok.sh tests/kit_check.py
git add tests .grok-plugin plugins scripts README.md .gitignore
git commit -m "chore: scaffold amazon-operator-os plugin and kit_check"
```

---

### Task 2: Template folder + AGENTS.md + catalog docs

**Files:**
- Create: `template/AGENTS.md`
- Create: `template/exports/{sales,ads,inventory,reviews,listings}/README.md`
- Create: `template/reports/.gitkeep` `template/drafts/.gitkeep` `template/logs/.gitkeep`
- Create: `template/reference/{brand.md,asins.md,sources.md,logic.md,how-to-refresh.md,delivery.md}`
- Create: `docs/INSTALL.md` `docs/EXPORTS.md`
- Modify: `tests/kit_check.py` — require those paths

**Interfaces:**
- Consumes: Task 1 ROOT / TEMPLATE
- Produces: empty-but-valid `reference/sources.md` and `reference/logic.md` stubs with headings the interview skills will fill; `docs/EXPORTS.md` is the *catalog*, not the buyer refresh card

- [ ] **Step 1: Extend kit_check with template paths (will fail)**

Add to `main()`:

```python
    for rel in [
        "template/AGENTS.md",
        "template/exports/sales/README.md",
        "template/exports/ads/README.md",
        "template/exports/inventory/README.md",
        "template/exports/reviews/README.md",
        "template/exports/listings/README.md",
        "template/reference/brand.md",
        "template/reference/asins.md",
        "template/reference/sources.md",
        "template/reference/logic.md",
        "template/reference/how-to-refresh.md",
        "template/reference/delivery.md",
        "docs/INSTALL.md",
        "docs/EXPORTS.md",
    ]:
        require(ROOT / rel)
    sources = (TEMPLATE / "reference" / "sources.md").read_text() if (TEMPLATE / "reference" / "sources.md").exists() else ""
    if "# Sources" not in sources:
        fail("template/reference/sources.md must start with a # Sources heading")
    logic = (TEMPLATE / "reference" / "logic.md").read_text() if (TEMPLATE / "reference" / "logic.md").exists() else ""
    if "# Operating logic" not in logic:
        fail("template/reference/logic.md must start with # Operating logic")
```

Run: `python3 tests/kit_check.py`
Expected: FAIL missing `template/AGENTS.md`

- [ ] **Step 2: Write `template/AGENTS.md`**

```markdown
# AGENTS.md → [BUSINESS NAME] operator context

You are the operating assistant for [BUSINESS NAME], a [WHAT YOU SELL].
You help run the business leaner. You are not a chatbot. You read files, do the work, and write results back as markdown.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `reference/sources.md` and `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in a skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Folder conventions

- `exports/`   raw data drops. Read-only. Never edit.
- `reports/`   finished artifacts. Date time-bound files.
- `reference/` standing context: brand, ASINs, sources, logic, delivery.
- `drafts/`    rewrites and reply drafts.
- `logs/`      overnight run logs.

Filenames lowercase, dashes, `.md` or `.csv`.

## Voice

Direct and plain. Operator metrics over adjectives. No hype, no exclamation marks, no emojis. Brief a busy partner who already knows the business.

## Metrics that matter here

Use the watch list in `reference/logic.md`. Do not invent a generic ACOS/CVR dashboard if logic names something else.

## Do

- Read `reference/sources.md` and `reference/logic.md` first.
- Show your inputs. Name the files you used.
- Prefer a short table over a wall of prose.
- When a number is missing, write `(not in the data)`. Never invent it.
- Write outputs to `reports/` or `drafts/`.

## Don't

- Don't edit `exports/`.
- Don't fabricate numbers, dates, or quotes.
- Don't spawn a subagent to interview the operator.
- Don't write files outside this folder.
- Don't push live changes to Amazon.
```

- [ ] **Step 3: Write stub reference files and export READMEs**

`template/reference/sources.md`:

```markdown
# Sources

status: empty

| id | seat | type | path_or_url | freshness | status | how_i_get_it |
|---|---|---|---|---|---|---|
```

`template/reference/logic.md`:

```markdown
# Operating logic

status: empty

## North star

## Metrics I watch

## Rules

## Exceptions

## Brief

## Overnight
priority: inventory, ads, customer
cap: 2
```

`template/reference/delivery.md`:

```markdown
method: none
url:
email:
```

`template/reference/brand.md`, `asins.md`, `how-to-refresh.md`: one heading each (`# Brand`, `# ASINs`, `# How to refresh`).

Each `template/exports/<bucket>/README.md`: one paragraph naming the typical Amazon report from spec section 5.2 and "Drop the newest file here. `/sources` maps it."

- [ ] **Step 4: Write INSTALL.md and EXPORTS.md**

`docs/INSTALL.md` must include: install Grok CLI, authenticate xAI, unzip or clone, `cd` into the folder, `/operator-setup`, then drop files from the generated `how-to-refresh.md`, then `/prove`. Overnight is optional and last. Mac sleep warning.

`docs/EXPORTS.md` is the catalog table from spec 5.2 (sales / ads / inventory / reviews / listings) plus "this is the catalog; your live list is `reference/how-to-refresh.md`."

- [ ] **Step 5: Run kit_check and commit**

Run: `python3 tests/kit_check.py`
Expected: `ok`

```bash
git add template docs tests/kit_check.py
git commit -m "feat: add business-folder template and export catalog"
```

---

### Task 3: Parent-only setup interview (sources + logic)

This is the product surface for personalization. The main agent does it.

**Files:**
- Create: `plugins/amazon-operator-os/skills/operator-setup/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/operator-sources/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/operator-logic/SKILL.md`
- Create: `plugins/amazon-operator-os/commands/sources.md`
- Create: `plugins/amazon-operator-os/commands/logic.md`
- Modify: `tests/kit_check.py` — require those skills; assert setup SKILL forbids spawn_subagent

**Interfaces:**
- Consumes: template files from Task 2
- Produces: skills that write `reference/sources.md`, `reference/logic.md`, `reference/how-to-refresh.md` in the business folder; setup copies `template/` to `~/Documents/<brand-slug>-ops/`

- [ ] **Step 1: Extend kit_check (will fail)**

```python
    for name in ["operator-setup", "operator-sources", "operator-logic"]:
        p = PLUGIN / "skills" / name / "SKILL.md"
        require(p)
        if p.exists():
            text = p.read_text()
            if name == "operator-setup" and "spawn_subagent" not in text:
                fail("operator-setup must explicitly forbid spawn_subagent")
            if "parent session" not in text.lower() and "parent/ops" not in text.lower() and "PARENT" not in text:
                fail(f"{name} must say it runs in the parent session")
```

Run: `python3 tests/kit_check.py`
Expected: FAIL missing operator-setup

- [ ] **Step 2: Write `operator-sources/SKILL.md`**

```markdown
---
name: operator-sources
description: Interview the operator about what data they actually have and write reference/sources.md plus a one-page how-to-refresh.md. Use when the user runs /sources, says "add a source", "I have a new export", or during /operator-setup. Parent session only.
---

# Operator sources interview

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow.

You are mapping what this operator already looks at onto a source registry. You are not forcing five Amazon CSVs.

## Catalog you may map onto

- sales → typically SC Business Report (Detail Page Sales and Traffic by Child Item) → exports/sales/
- ads-campaigns / ads-search-terms → SP campaign and search term reports → exports/ads/
- inventory → Inventory Planning or FBA Manage Inventory → exports/inventory/
- reviews → Helium10 / Keepa / paste (Amazon has no clean SC reviews export) → exports/reviews/
- listings → All Listings Report, markdown pack, or public Amazon URL → exports/listings/

They may also name a Google Sheet URL, an MCP server already connected, or a pasted dump. type is one of: csv | sheet | url | paste | mcp.

## Steps

1. If `reference/sources.md` already has rows with status connected, show the table and ask what to add/change. Do not wipe it.
2. Ask: "What numbers do you already look at, and where does each one live?" One cluster. Do not dump a 20-field form.
3. For each named source: have it now / skip / later. Skip writes status: missing.
4. For have-it-now: path relative to this folder, Sheet URL, paste target, or MCP server_id. If they want MCP and it is not connected, print a config.toml snippet and wait for "done", then ping once. Do not pretend it connected.
5. Write `reference/sources.md` with heading `# Sources` and the table columns: id, seat, type, path_or_url, freshness, status, how_i_get_it.
6. Write `reference/how-to-refresh.md` listing ONLY connected sources, one bullet each, with the how_i_get_it steps. Not the full catalog.
7. Show the table. Ask "Is this your stack?" Edit until they say yes.

Overnight and /prove read this file. Sources with status missing are not demanded as files.
```

- [ ] **Step 3: Write `operator-logic/SKILL.md`**

```markdown
---
name: operator-logic
description: Interview the operator about the metrics they watch, what bad looks like, exceptions, and what the morning brief should include. Writes reference/logic.md. Use when the user runs /logic, says "add a rule", "we watch TACOS not ACOS", or during /operator-setup. Parent session only.
---

# Operator logic interview

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow.

You compile their operating rules into `reference/logic.md`. Skills stay generic. This file beats every default in a skill.

If they refuse or skip, write starter defaults and stamp `status: defaults-not-reviewed` at the top:
- ACOS flag 35%
- sales drop vs 7d 20%
- cover 14 days
- refund keywords: refund, broken, defective, chargeback, mold, leak
- overnight priority inventory, ads, customer; cap 2
Then say: "Briefs will look like a generic Amazon dashboard until you run /logic."

## Four clusters (one at a time)

1. "What do you check before you do anything else?" Capture 3–7 metrics in their words. Map each to a source_id from `reference/sources.md`. If they name a metric with no source: "We do not have that file yet. Skip it, or tell me where it lives." Do not invent a source.
2. "When do you want to be woken up?" One flag per metric. Sentence in, rule out.
3. "What would a generic Amazon dashboard get wrong?" Launch ASINs, kits vs units, FBM, Subscribe & Save, 3P, parent/child, seasonal, retired. Write as Exceptions. Then: "Any ASINs or groups that do not follow the defaults?" Optional overrides. Do not require a per-ASIN spreadsheet.
4. "What should the morning brief include? What should it never mention?"

## Write `reference/logic.md`

Required sections, exact headings:

# Operating logic
## North star
## Metrics I watch
## Rules
## Exceptions
## Brief
## Overnight
## Overrides

Metrics table columns: metric, why, source_id, good, flag, seat.

Overnight: default priority inventory, ads, customer. cap: 2. They may reorder those three. They may not set cap above 2. If they ask for 3, keep 2 and say so.

Show the file. Ask "Is this you?" Edit until they say yes.

`/logic add <sentence>` appends under Rules (or Overrides if it names an ASIN) and re-shows the file. Do not re-run the full interview for an add.
```

- [ ] **Step 4: Write `operator-setup/SKILL.md`**

```markdown
---
name: operator-setup
description: First-run setup for Amazon Operator OS. Writes the business folder, then interviews the operator for sources and logic in this same sitting. Use when the user runs /operator-setup or says they just unzipped the kit. Parent session only. Day-one command — do not send them to /sources and /logic as homework.
---

# Operator setup

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow. Do not spawn listing, ads, inventory, customer, or creative. The operator is answering questions. A child agent cannot do that.

Day one is this command only. After this sitting they have sources.md, logic.md, and a refresh card. Then they drop files and run /prove.

## 0. Preconditions

If `grok` is not runnable or the user is not authenticated, print the install/auth steps from `docs/INSTALL.md` and stop. Do not interview a half-installed machine.

## 1. Brand cluster (one at a time)

Ask: brand name, what they sell, 1–3 ASINs (optional), voice (offer the AGENTS.md default), delivery (none / Slack webhook / email-or-generic webhook). Do not ask ACOS or cover here. That is the logic interview.

Slug the brand name: lowercase, dashes, no spaces. Target folder: `~/Documents/<brand-slug>-ops/`. If it already exists, ask overwrite / use existing / pick another name.

## 2. Write the folder

Copy the kit `template/` into that folder. Fill:
- `AGENTS.md` — replace [BUSINESS NAME] and [WHAT YOU SELL] and the voice line
- `reference/brand.md`
- `reference/asins.md`
- `reference/delivery.md` (webhook URL if they pasted one; otherwise method: none)

Tell them: "Open Grok in that folder from now on." If the current cwd is already the template, fill in place and skip the copy.

## 3. Sources interview (inline)

Follow `plugins/amazon-operator-os/skills/operator-sources/SKILL.md` (or `.grok/skills/operator-sources/SKILL.md` in the business folder) in this same conversation. Do not ask them to type /sources.

## 4. Logic interview (inline)

Follow `operator-logic` in this same conversation. They may skip; then write defaults-not-reviewed.

## 5. Close

Print `reference/how-to-refresh.md`. Say: "Drop or connect those files, then run /prove in this folder." Do not install overnight. Do not run /prove unless they already dropped files and asked.
```

- [ ] **Step 5: Write thin command wrappers**

`plugins/amazon-operator-os/commands/sources.md`:

```markdown
Follow the operator-sources skill. Parent session only.
```

`plugins/amazon-operator-os/commands/logic.md`:

```markdown
Follow the operator-logic skill. Parent session only. If the user said /logic add …, take the add path.
```

- [ ] **Step 6: Sync template and run kit_check**

```bash
bash scripts/sync-template-grok.sh
python3 tests/kit_check.py
```

Expected: `ok`

```bash
git add plugins tests template
git commit -m "feat: parent-only setup interview for sources and logic"
```

---

### Task 4: Fixtures + fixture logic (TACOS, not ACOS-only)

**Files:**
- Create: `fixtures/sources.md` `fixtures/logic.md`
- Create: `fixtures/sales/business-report.csv`
- Create: `fixtures/ads/sp-campaigns.csv` `fixtures/ads/sp-search-terms.csv`
- Create: `fixtures/inventory/fba-inventory.csv`
- Create: `fixtures/reviews/reviews.csv`
- Create: `fixtures/listings/listings.md`
- Modify: `tests/kit_check.py` — parse CSVs, assert fixture logic north star is TACOS

**Interfaces:**
- Consumes: catalog columns from spec 5.2
- Produces: anonymized brand "Northline Home" with 6 child ASINs; hero `B0FIXTURE1`; launch `B0FIXTURE6`

- [ ] **Step 1: Extend kit_check for fixtures (will fail)**

```python
    import csv
    require(FIXTURES / "logic.md")
    if (FIXTURES / "logic.md").exists():
        lt = (FIXTURES / "logic.md").read_text()
        if "TACOS" not in lt:
            fail("fixture logic.md must use TACOS as a watch metric so we catch ACOS-default bugs")
        if "defaults-not-reviewed" in lt:
            fail("fixture logic.md must be a reviewed example, not defaults")
    sales = FIXTURES / "sales" / "business-report.csv"
    require(sales)
    if sales.exists():
        rows = list(csv.DictReader(sales.open()))
        if len(rows) < 6:
            fail("sales fixture needs at least 6 child ASIN rows")
        for col in ["(Child) ASIN", "Sessions", "Units Ordered", "Ordered Product Sales", "Conversion Rate"]:
            if col not in (rows[0] if rows else {}):
                fail(f"sales fixture missing column {col}")
```

Run: `python3 tests/kit_check.py`
Expected: FAIL missing fixtures/logic.md

- [ ] **Step 2: Write fixture logic and sources**

`fixtures/logic.md` north star: TACOS, target <18%, flag >22%. Cover flag 21 days. Hero B0FIXTURE1 always first. B0FIXTURE6 tag launch, ignore TACOS for 14 days. Morning brief must include TACOS, cover on hero, wasted spend. Must never mention impression share. Overnight priority inventory, ads, customer; cap 2.

`fixtures/sources.md`: all five buckets connected, type csv, paths under `exports/...` (prove copies fixtures into exports).

- [ ] **Step 3: Write CSVs**

Sales columns exactly: `(Child) ASIN,Sessions,Units Ordered,Ordered Product Sales,Conversion Rate`
Six rows: B0FIXTURE1..6. Hero has high sales. One ASIN with CVR 0.04 (weak). 14-day window implied.

Ads campaigns: `Campaign Name,Spend,Sales,ACOS,Impressions,Clicks` — one campaign ACOS 41% on a non-launch ASIN, one clean.

Search terms: `Customer Search Term,Spend,Sales,ACOS,Orders,Match Type` — one wasted term (spend 40, sales 0), one harvest candidate (phrase, converting).

Inventory: `SKU,ASIN,Available,Inbound,Days of Supply` — hero at 12 days (under 21), one SKU at 80 days, launch ASIN at 40.

Reviews: `date,rating,asin,body` — 40 rows mixed 5-star and a 1-star cluster on B0FIXTURE2 about leaking.

Listings: markdown with six ASINs, titles, `https://www.amazon.com/dp/B0FIXTURE1` etc. (fake dp is fine; listing agent must tolerate fetch failure and use the markdown).

- [ ] **Step 4: kit_check + commit**

Run: `python3 tests/kit_check.py`
Expected: `ok`

```bash
git add fixtures tests/kit_check.py
git commit -m "test: add Northline Home fixtures with TACOS logic"
```

---

### Task 5: Ops agent + weekly report + overnight skill (no fan-out)

**Files:**
- Create: `plugins/amazon-operator-os/agents/ops.md`
- Create: `plugins/amazon-operator-os/personas/operator.toml`
- Create: `plugins/amazon-operator-os/skills/weekly-operator-report/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/overnight-ops/SKILL.md`
- Modify: `tests/kit_check.py` — require PREAMBLE in ops.md

**Interfaces:**
- Consumes: sources.md, logic.md, connected exports
- Produces: `reports/weekly-report-YYYY-MM-DD.md` and `reports/morning-brief-YYYY-MM-DD.md` (Ops only, no specialist spawn yet)

- [ ] **Step 1: kit_check preamble on ops.md (will fail)**

```python
    ops = PLUGIN / "agents" / "ops.md"
    require(ops)
    if ops.exists() and PREAMBLE not in ops.read_text():
        fail("ops.md missing READ_ORDER preamble")
```

- [ ] **Step 2: Write `personas/operator.toml`**

```toml
[subagents.personas.operator]
description = "Direct operator. Metrics over adjectives."
instructions = "Direct and plain. Operator metrics over adjectives. No hype, no emojis. Name source files. If a number is not in a connected source, write (not in the data). Read reference/sources.md and reference/logic.md before you analyze."
```

- [ ] **Step 3: Write `agents/ops.md`**

YAML frontmatter: `name: ops`, description for routing, tools unrestricted. Body must include PREAMBLE, "never spawn during setup/sources/logic", weekly and overnight artifact paths from the spec, "top line comes from logic.md north star", "overnight spawn list is Task 11 — in this version do not spawn specialists."

- [ ] **Step 4: Write weekly-operator-report skill**

Port the report shape from `~/.agents/skills/opencode-operator-starter/SKILL.md` (the weekly report block). Changes required:
- Read sources.md + logic.md first
- "The number that matters" is logic's north star, not a generic revenue line
- Sources footer lists connected files actually used
- Write `reports/weekly-report-YYYY-MM-DD.md`

- [ ] **Step 5: Write overnight-ops skill (no fan-out yet)**

Port failure-safe rules from `~/.agents/skills/overnight-ops/SKILL.md`. Changes required:
- Pull only sources with freshness daily and status connected
- Checks come from logic.md, not hardcoded ACOS 35 / cover 14
- Write `reports/morning-brief-YYYY-MM-DD.md` using logic's Brief section
- Empty sources: one-line `Overnight run could not read any source`. Never a clean empty brief
- Delivery: if `reference/delivery.md` method is slack or webhook, POST the brief; on HTTP failure set Delivery: failed; retry at most twice
- Do not spawn specialists in this task
- Prefix title `INCOMPLETE BRIEF` when any daily source is missing or unreadable

- [ ] **Step 6: Sync, kit_check, commit**

```bash
bash scripts/sync-template-grok.sh
python3 tests/kit_check.py
git add plugins tests template
git commit -m "feat: ops agent, weekly report, overnight brief without fan-out"
```

---

### Task 6: Listing agent

**Files:**
- Create: `plugins/amazon-operator-os/agents/listing.md`
- Create: `plugins/amazon-operator-os/skills/listing-audit/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/amazon-title-compress/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/amazon-qa-generator/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/amazon-attribute-fill-rate/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/amazon-ai-shopping-visibility-audit/SKILL.md`
- Modify: `tests/kit_check.py`

**Interfaces:**
- Consumes: listings source, asins.md, logic.md (which ASIN is hero)
- Produces: `reports/listing-audit-<asin>.md`
- Prove ASIN: first in `reference/asins.md`, else first ASIN in the listing source

- [ ] **Step 1: kit_check listing.md preamble + artifact path string `reports/listing-audit-`**

- [ ] **Step 2: Copy and strip skills**

Copy from:
- `~/.agents/skills/listing-audit/SKILL.md`
- `~/.agents/skills/amazon-title-compress/SKILL.md`
- `~/.agents/skills/amazon-qa-generator/SKILL.md`
- `~/.agents/skills/amazon-attribute-fill-rate/SKILL.md`
- `~/.agents/skills/amazon-ai-shopping-visibility-audit/SKILL.md`

Strip from every copy:
- Aspi / Velocity / Wood Defender / client folder paths
- "Save based on context" blocks that write into `02 aspi/` or `05 fractional/`
- References to `Hero Image Audit Process.md` that are not in this kit (inline a 5-point mobile check in listing-audit instead)
- Any API keys

Write output path: `reports/listing-audit-<asin>.md`

Add PREAMBLE to listing-audit. If Amazon URL fetch fails, use the markdown pack. Do not fail the artifact.

- [ ] **Step 3: Write `agents/listing.md`**

Frontmatter name `listing`. Body: PREAMBLE, job is audit not catalog push, no rewrites required in v1, run listing-audit + title-compress + Q&A + attributes + AI-shopping gaps into the one artifact.

- [ ] **Step 4: kit_check grep that listing-audit does not contain `02 aspi` or `velocity-sellers/clients`**

```python
    la = (PLUGIN / "skills" / "listing-audit" / "SKILL.md").read_text()
    for needle in ["02 aspi/", "05 fractional/", "Wood Defender"]:
        if needle in la:
            fail(f"listing-audit still contains client IP path {needle}")
```

- [ ] **Step 5: sync, kit_check, commit**

```bash
bash scripts/sync-template-grok.sh
python3 tests/kit_check.py
git commit -am "feat: listing agent and operator-generic listing-audit set"
```

---

### Task 7: Ads agent

**Files:**
- Create: `plugins/amazon-operator-os/agents/ads.md`
- Create: `plugins/amazon-operator-os/skills/ppc-exception-brief/SKILL.md`
- Modify: `tests/kit_check.py`

**Interfaces:**
- Consumes: ads sources + logic ads flags (TACOS/ACOS/wasted spend — their names)
- Produces: `reports/ppc-exception-brief-YYYY-MM-DD.md`

- [ ] **Step 1: kit_check ads.md PREAMBLE and skill mentions `logic.md`**

- [ ] **Step 2: Write ppc-exception-brief**

Must:
- Read sources + logic first
- Flag campaigns/terms using logic, not hardcoded 35% ACOS (35% only if logic has no ads flag)
- Honor launch-ASIN exceptions
- Wasted search terms when that source is connected
- Harvest candidates (converting on broad/phrase)
- `(not in the data)` if a watch metric's source is missing
- No bid writes, no Amazon Ads API
- Write `reports/ppc-exception-brief-YYYY-MM-DD.md`

- [ ] **Step 3: Write `agents/ads.md` with PREAMBLE**

- [ ] **Step 4: kit_check — `35` must not appear as the primary flag instruction unless preceded by "only when logic has no ads flags"**

- [ ] **Step 5: sync, kit_check, commit**

```bash
git commit -am "feat: ads agent and ppc-exception-brief driven by logic.md"
```

---

### Task 8: Inventory agent

**Files:**
- Create: `plugins/amazon-operator-os/agents/inventory.md`
- Create: `plugins/amazon-operator-os/skills/inventory-risk/SKILL.md`

**Interfaces:**
- Consumes: inventory + sales sources, logic cover flags, exceptions (FBM, retired)
- Produces: `reports/inventory-risk-YYYY-MM-DD.md`

- [ ] **Step 1: kit_check inventory.md PREAMBLE**

- [ ] **Step 2: Write inventory-risk skill**

Must: cover/stockout from logic (default 14 only if logic has no cover flag), compute days of cover from sales velocity when Days of Supply missing, join to ads spend when both sources exist ("do not buy clicks we cannot fill"), honor FBM/retired/launch exceptions, write `reports/inventory-risk-YYYY-MM-DD.md`.

- [ ] **Step 3: Write `agents/inventory.md`**

- [ ] **Step 4: sync, kit_check, commit**

```bash
git commit -am "feat: inventory agent and cover/stockout brief"
```

---

### Task 9: Customer agent

**Files:**
- Create: `plugins/amazon-operator-os/agents/customer.md`
- Create: `plugins/amazon-operator-os/skills/review-intelligence/SKILL.md`

**Interfaces:**
- Consumes: reviews source (csv or md)
- Produces: `reports/review-intelligence-YYYY-MM-DD.md` and `drafts/review-replies-YYYY-MM-DD.md` (3 drafts)

- [ ] **Step 1: kit_check customer.md PREAMBLE**

- [ ] **Step 2: Write review-intelligence**

Must: rating mix, top 5 themes, 1-star/2-star clusters, listing implications one line each, 3 reply drafts, say so if dump has no dates, `(not in the data)` if reviews source missing, still write the artifact.

- [ ] **Step 3: Write `agents/customer.md`**

- [ ] **Step 4: sync, kit_check, commit**

```bash
git commit -am "feat: customer agent and review intelligence"
```

---

### Task 10: Creative agent (briefs only)

**Files:**
- Create: `plugins/amazon-operator-os/agents/creative.md`
- Create: `plugins/amazon-operator-os/skills/aplus-brief/SKILL.md`
- Create: `plugins/amazon-operator-os/skills/image-stack-brief/SKILL.md`

**Interfaces:**
- Consumes: listing source, same prove ASIN as Listing
- Produces: `reports/creative-brief-<asin>.md`

- [ ] **Step 1: kit_check creative.md PREAMBLE; fail if skill mentions higgsfield, gpt-image, image_gen, or "generate the image"**

- [ ] **Step 2: Port aplus-brief from `~/.agents/skills/aplus-brief/SKILL.md`**

Strip client paths. Output into the combined creative brief, not a Velocity folder. No mockup image generation.

- [ ] **Step 3: Write image-stack-brief**

Do not copy the full `amazon-image-stack` generator. Write a brief-only skill: 5–7 secondary slots, each with role, copy, art direction. Stop. No image API.

- [ ] **Step 4: Write `agents/creative.md`** — one artifact combining both briefs. Same ASIN rule as Listing.

- [ ] **Step 5: sync, kit_check, commit**

```bash
git commit -am "feat: creative agent with image-stack and A+ briefs only"
```

---

### Task 11: `/prove` + weekly workflow

**Files:**
- Create: `plugins/amazon-operator-os/skills/operator-prove/SKILL.md`
- Create: `plugins/amazon-operator-os/workflows/weekly-ops.rhai`
- Create: `plugins/amazon-operator-os/commands/prove.md`
- Create: `plugins/amazon-operator-os/commands/weekly.md`
- Create: `scripts/load-fixtures.sh`

**Interfaces:**
- Consumes: six agent types from Tasks 5–10; fixtures from Task 4
- Produces: six artifacts + two-line scoreboard; workflow `weekly-ops` with args.mode `prove` | `weekly`

- [ ] **Step 1: kit_check workflow file exists and contains `agent_type` for listing, ads, inventory, customer, creative**

- [ ] **Step 2: Write `scripts/load-fixtures.sh`**

```bash
#!/usr/bin/env bash
# Copy fixtures into a business folder's exports/ without overwriting non-empty buyer files.
set -euo pipefail
DEST="${1:?usage: load-fixtures.sh <ops-folder>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$DEST/exports/"{sales,ads,inventory,reviews,listings} "$DEST/reference"
copy_if_empty() {
  local src="$1" dest="$2"
  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
  fi
}
copy_if_empty "$ROOT/fixtures/sales/business-report.csv" "$DEST/exports/sales/business-report.csv"
copy_if_empty "$ROOT/fixtures/ads/sp-campaigns.csv" "$DEST/exports/ads/sp-campaigns.csv"
copy_if_empty "$ROOT/fixtures/ads/sp-search-terms.csv" "$DEST/exports/ads/sp-search-terms.csv"
copy_if_empty "$ROOT/fixtures/inventory/fba-inventory.csv" "$DEST/exports/inventory/fba-inventory.csv"
copy_if_empty "$ROOT/fixtures/reviews/reviews.csv" "$DEST/exports/reviews/reviews.csv"
copy_if_empty "$ROOT/fixtures/listings/listings.md" "$DEST/exports/listings/listings.md"
cp "$ROOT/fixtures/sources.md" "$DEST/reference/sources.md"
cp "$ROOT/fixtures/logic.md" "$DEST/reference/logic.md"
echo "fixtures loaded into $DEST"
```

- [ ] **Step 3: Write `weekly-ops.rhai`**

`let meta` name `weekly-ops`. Args: `mode` (`prove` or `weekly`), `asin` optional, `date` required for weekly (pass in from the parent; workflows cannot call `timestamp()`).

Phase 1: `parallel()` five jobs, `agent_type` listing/ads/inventory/customer/creative, `capability_mode: "read-write"`, prompts must command: read AGENTS.md, sources.md, logic.md, then connected sources, write the named artifact, use tools, empty `(not in the data)` only after reading.

Phase 2: ops compiles weekly-report. Guard every specialist: `r != () && r.success`. Failed slot becomes `(not in the data)` in the weekly report.

`agent_budget` 8.

Smoke-check with the workflow tool `validate_only: true` and `args: { "mode": "prove", "date": "2026-09-01" }`. Iterate until compile passes.

- [ ] **Step 4: Write operator-prove skill**

Steps from spec 7.2. `/prove --fixtures` runs `scripts/load-fixtures.sh` on cwd then the workflow. Scoreboard two lines: artifacts 6/6, logic K of M watch metrics had data. Pass = six files exist. Do not fail the run because a watch metric lacks a source.

- [ ] **Step 5: Manual integration (executor, in a throwaway folder)**

```bash
mkdir -p /tmp/northline-ops
cp -R template/. /tmp/northline-ops/
bash scripts/load-fixtures.sh /tmp/northline-ops
# Open grok in /tmp/northline-ops and run /prove
```

Expected: six files under `reports/`. Weekly report north star is TACOS. Ads brief must not treat 35% ACOS as the flag if fixture logic says TACOS 22%.

- [ ] **Step 6: sync, kit_check, commit**

```bash
chmod +x scripts/load-fixtures.sh
git commit -am "feat: prove and weekly workflow fan-out"
```

---

### Task 12: Overnight fan-out, launchd, delivery

**Files:**
- Create: `plugins/amazon-operator-os/workflows/overnight-ops.rhai`
- Create: `plugins/amazon-operator-os/skills/install-overnight/SKILL.md`
- Create: `template/bin/overnight.sh`
- Create: `template/bin/overnight.plist.example`
- Modify: `plugins/amazon-operator-os/skills/overnight-ops/SKILL.md` — add fan-out
- Modify: `plugins/amazon-operator-os/agents/ops.md` — overnight may spawn max 2 flagged specialists

**Interfaces:**
- Consumes: logic.md Overnight section; daily connected sources
- Produces: morning brief + 0–2 specialist artifacts; launchd plist

- [ ] **Step 1: Write `template/bin/overnight.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
OPS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$OPS_DIR"
DATE="$(date +%F)"
mkdir -p logs reports
grok -p --yolo --cwd "$OPS_DIR" --max-turns 40 \
  --allow 'Read(./**)' \
  --allow 'Write(./reports/**)' \
  --allow 'Write(./drafts/**)' \
  --allow 'Write(./logs/**)' \
  --deny 'Write(./exports/**)' \
  --deny 'Bash(rm*)' \
  "Run the overnight-ops skill and overnight-ops workflow for ${DATE}. Follow reference/sources.md and reference/logic.md. Do not spawn listing or creative." \
  >> "logs/overnight-${DATE}.log" 2>&1
```

- [ ] **Step 2: Write plist example**

Label `com.operatoros.overnight`. StartCalendarInterval Hour 5 Minute 0. ProgramArguments `/bin/bash` `-lc` `<OPS_DIR>/bin/overnight.sh`. WorkingDirectory the ops folder. Keep the path as a placeholder `__OPS_DIR__` for install-overnight to replace.

- [ ] **Step 3: Write overnight-ops.rhai**

Ops first (checks from logic). Build spawn list from tripped flags. Priority from logic, default inventory, ads, customer. Cap 2. Never listing or creative. `parallel()` that list. Attach artifact paths to the brief. `agent_budget` 4.

- [ ] **Step 4: Update overnight-ops skill** with the fan-out rules, delivery POST, incomplete brief, retry cap.

- [ ] **Step 5: Write install-overnight skill**

Writes plist to `~/Library/LaunchAgents/com.operatoros.overnight.plist`, `launchctl load`, then tells them to run `/overnight --now` (the wrapper) for a noon dry-run before trusting 5am. Windows: print "out of v1, run /weekly manually." Mac sleep warning.

- [ ] **Step 6: kit_check — overnight.rhai contains `cap` and does not contain listing/creative as overnight agent_types**

- [ ] **Step 7: sync, kit_check, commit**

```bash
chmod +x template/bin/overnight.sh
git commit -am "feat: overnight fan-out cap 2 with launchd installer"
```

---

### Task 13: QA matrix + ship docs

**Files:**
- Create: `docs/WHAT-GOOD-LOOKS-LIKE.md`
- Create: `docs/DELIVER.md`
- Create: `docs/QA.md` (the matrix from spec section 11, as a runbook)
- Create: `scripts/build-zip.sh`
- Create: `amazon-operator-os-buyers-log.md` (empty table)

**Interfaces:**
- Consumes: all prior tasks
- Produces: zip of `template/` after sync; John's fulfillment SOP

- [ ] **Step 1: Write `docs/QA.md` with the spec 11 table, including:**
  - prove fixtures uses TACOS
  - delete ads source → `(not in the data)` + scoreboard
  - wrong columns named
  - overnight inventory-only when only cover flags
  - two flags spawn two
  - three flags spawn inventory+ads
  - delivery 404 → Delivery: failed
  - empty exports overnight → one-line incomplete
  - specialist cannot write exports
  - defaults-not-reviewed warns
  - agent flagging ACOS 35 while logic says TACOS 22 is a fail

- [ ] **Step 2: Run the matrix in `/tmp/northline-ops` (or equivalent). Do not ship if any row fails. Paste results into the commit message or QA.md.**

- [ ] **Step 3: Write WHAT-GOOD-LOOKS-LIKE.md** — a filled weekly report and morning brief from fixtures (anonymized), so support knows the bar.

- [ ] **Step 4: Write DELIVER.md** — Second Brain pattern: Drive walkthrough of Grok install → `/operator-setup` interview → drop one file → `/prove`; email zip from john@goaspi.com; optional GitHub invite to `aspinalljohn/amazon-operator-os`; log the buyer.

- [ ] **Step 5: `scripts/build-zip.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/sync-template-grok.sh"
OUT="$ROOT/dist/amazon-operator-os.zip"
mkdir -p "$ROOT/dist"
rm -f "$OUT"
( cd "$ROOT/template" && zip -r "$OUT" . -x "*.DS_Store" )
echo "wrote $OUT"
```

- [ ] **Step 6: buyers log header**

```markdown
# Amazon Operator OS buyers

| date | email | github | zip sent | prove green | notes |
|---|---|---|---|---|---|
```

- [ ] **Step 7: final kit_check, zip, commit**

```bash
python3 tests/kit_check.py
bash scripts/build-zip.sh
git add docs scripts amazon-operator-os-buyers-log.md
git commit -m "docs: QA matrix, deliver SOP, zip build"
```

---

## Spec coverage

| Spec section | Task |
|---|---|
| Hybrid plugin + folder | 1, 2 |
| sources.md + logic.md + interviews | 3 |
| Parent-only one-sitting setup | 3 |
| Five-bucket catalog, not forced | 2, 3 |
| Fixtures TACOS | 4 |
| Ops weekly + morning brief | 5 |
| Listing / ads / inventory / customer / creative artifacts | 6–10 |
| /prove two-line scoreboard | 11 |
| Overnight cap 2 fan-out + Slack/webhook | 12 |
| Safety cwd lock, exports read-only | 12 overnight.sh allow/deny |
| Commercial zip + DELIVER | 13 |
| v1 out: image gen, Amazon APIs, Claude dual, Windows overnight | enforced in creative kit_check and INSTALL.md |

## Placeholder scan

No TBD. Caps are 2 and max-turns 40. Artifact paths are named. Fixture brand is Northline Home. Interview is parent-only.

## Type / name consistency

- Plugin and marketplace name: `amazon-operator-os`
- Agent types: `ops`, `listing`, `ads`, `inventory`, `customer`, `creative`
- Preamble marker identical in every agent file
- Logic headings: North star, Metrics I watch, Rules, Exceptions, Brief, Overnight, Overrides
- Overnight cap field name: `cap: 2`
