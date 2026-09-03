# QA matrix — Amazon Operator OS

v1 does not ship if a row in the results table is **fail**. Live grok is optional evidence for pack-only rows, not a reason to invent a pass. Record **pass**, **fail**, or **skipped** with a reason.

## Pre-ship live checklist (required once per release)

On a machine with **Grok Bot** installed, signed in, and six Bots created:

1. Deploy `template/` to `/workspace/northline-live/` on the Agent Computer; `bash scripts/load-fixtures.sh` that path (from cloud shell or Ops Bot).
2. Ops → `/prove` → six artifacts, TACOS north star, scoreboard two lines.
3. `/install-overnight` → Routine; `/overnight --now` → morning brief (default fixtures: inventory + ads, cap 2).

Optional CLI regression: repeat prove with Grok Build on `/tmp/northline-ops` using `weekly-ops.rhai` — see `docs/GROK-BUILD-ADVANCED.md`.

Internal fixtures: anonymized Northline Home (6 child ASINs, 14-day sales, 2 SP campaigns, mixed cover, 40 reviews, listing markdown). North star is TACOS, not ACOS. No live Amazon account required.

## Setup

From the kit root:

```bash
python3 tests/kit_check.py
rm -rf /tmp/northline-ops
mkdir -p /tmp/northline-ops
cp -R template/. /tmp/northline-ops/
bash scripts/load-fixtures.sh /tmp/northline-ops
cd /tmp/northline-ops
```

Open Grok in that folder for live rows. Headless `/prove` has previously hit `--max-turns 30` before Phase 2; interactive `/prove` has no max-turns. Do not run `bin/overnight.sh` against a real Slack URL in QA unless you intend to POST.

`kit_check` and fixture math can run without grok. Do not fake a live grok transcript.

## Spec 11 runbook

| # | Test | How to run | Pass |
|---|---|---|---|
| 1 | `/prove --fixtures` with fixture `logic.md` (TACOS + cover, not ACOS-only) | In `/tmp/northline-ops` after load-fixtures: `/prove` (or `/prove --fixtures` from an empty exports folder). | Six artifacts under `reports/`. Weekly north star is TACOS. Ads brief does not treat 35% ACOS as the flag. |
| 2 | Delete ads source and re-prove | Remove `exports/ads/*` (leave README). Set `ads-campaigns` and `ads-search-terms` status to missing in `reference/sources.md`. `/prove`. | Ads artifact exists. TACOS and wasted spend are `(not in the data)`. Scoreboard: `TACOS = no source.` (and wasted spend if that row has no source). Artifacts still 6/6. |
| 3 | Wrong-columns CSV | Replace a connected CSV with a file that is missing the catalog columns in `docs/EXPORTS.md`. `/prove` or run that seat. | Agent names the file and the expected columns. Does not guess numbers. |
| 4 | Overnight, inventory cover only | Keep hero cover under the logic flag (B0FIXTURE1 DoS 12 < 21). Clear ads flags: drop the wasted term or set its spend ≤ $20, leave TACOS under 22%. `/overnight --now` (wrapper `bin/overnight.sh`). | Ops + inventory specialist only (1 of 2). Brief attaches `reports/inventory-risk-YYYY-MM-DD.md`. No ads, listing, or creative spawn. |
| 5 | Overnight, ads and inventory both flagging | Default fixtures: cover 12 days on the hero (still spending) and wasted term $40 / $0. `/overnight --now`. | Both inventory and ads specialists. Cap not exceeded. |
| 6 | Overnight, three flags (inventory, ads, customer) | Trip a customer-seat flag as well (daily connected reviews plus a refund/review flag, or a customer row in logic.md that the daily files trip). `/overnight --now`. | inventory + ads only unless logic reordered those three. Cap 2. Never listing or creative. |
| 7 | `logic.md` still `defaults-not-reviewed` | Stamp `status: defaults-not-reviewed` at the top of `reference/logic.md`. `/prove`. Then overnight. | `/prove` warns: `logic is still defaults — run /logic or your briefs will look like every other Amazon dashboard.` Does not stop. Overnight still runs on defaults. |
| 8 | Agent flags ACOS 35% while logic says TACOS 22% | Read `reports/ppc-exception-brief-YYYY-MM-DD.md` after a fixtures prove. | **Fail QA** if the ads brief (or weekly top line) uses 35% ACOS as the flag. Fixture logic: TACOS target <18%, flag >22%. |
| 9 | Delivery URL 404 | Set `reference/delivery.md` to `method: webhook` and `url:` `https://example.invalid/qa-404`. Overnight. | Brief written. Delivery: failed. No crash. URL not copied into the brief. |
| 10 | Empty `exports/` overnight | Empty the connected daily files (or point sources at missing paths). Overnight. | One line only: `Overnight run could not read any source`. Prefix `INCOMPLETE BRIEF`. No fake-clean brief. No specialists. |
| 11 | Specialist cannot write `exports/` | Overnight wrapper already denies `Write(./exports/**)`. Confirm `template/bin/overnight.sh`. Optional: ask a specialist to write `exports/ads/probe.csv` during a dry-run. | Deny. `exports/` unchanged. |

### Artifact paths `/prove` must leave

| Seat | File |
|---|---|
| listing | `reports/listing-audit-<asin>.md` |
| ads | `reports/ppc-exception-brief-YYYY-MM-DD.md` |
| inventory | `reports/inventory-risk-YYYY-MM-DD.md` |
| customer | `reports/review-intelligence-YYYY-MM-DD.md` |
| creative | `reports/creative-brief-<asin>.md` |
| ops | `reports/weekly-report-YYYY-MM-DD.md` |

Scoreboard (exactly two lines):

```
Artifacts: N/6
Logic: K of M watch metrics had data. <metric> = no source.
```

Pass = six files exist. A watch metric with no source does not fail `/prove`.

### Overnight rules the matrix is checking

- Checks come from `reference/logic.md`, not skill-default ACOS 35 / cover 14.
- Pull only `freshness: daily` + `status: connected`.
- Spawn from tripped flags only. Map cover/stockout → inventory; TACOS/ACOS/wasted spend → ads; refund/review/rating/1-star → customer.
- Priority from logic.md `## Overnight`, default inventory, ads, customer. `cap: 2`. Logic may reorder those three, not raise the cap.
- Never listing. Never creative.
- `bin/overnight.sh`: `--always-approve`, `--cwd` the business folder, `--max-turns 40`, allow Write `reports/` `drafts/` `logs/`, deny Write `exports/` and `Bash(rm*)`.

## Fixture math (no grok)

Default Northline Home files, loaded 2026-09-01:

| Metric | Value | Flag | Overnight seat |
|---|---|---|---|
| TACOS | 4.36% ($1,300 / $29,790) | >22% — does not trip | ads (quiet on TACOS) |
| Cover hero B0FIXTURE1 | 12 days, still spending $890 | <21 days — trips | inventory |
| Wasted spend | $40.00 `cheap plastic organizer` BROAD, sales $0 | spend >$20 and sales $0 — trips | ads |
| CVR B0FIXTURE3 | 4.0% | <5% — trips | listing (never overnight) |
| Customer | reviews freshness weekly; no customer watch row | none on daily pull | none |

So: inventory-only requires clearing the wasted term (row 4). Default fixtures are the two-flag case (row 5). Three flags need a constructed customer trip (row 6).

## Results — this environment (2026-09-01)

Host: macOS, grok 1.0.16. Folders: leftover `/tmp/northline-ops` from Task 11 `/prove`, fresh `/tmp/northline-ops-qa` from `template/` + `scripts/load-fixtures.sh`. Live grok `/prove` and `/overnight --now` were **not** re-run in this pass (do not fake live grok; Task 11 headless parent hit `--max-turns 30` before Phase 2).

| # | Test | Result | Evidence |
|---|---|---|---|
| 1 | prove fixtures uses TACOS | **pass** (artifacts on disk from Task 11 live prove; fresh live re-run skipped) | `/tmp/northline-ops/reports/` has 6/6 files. Weekly top line is TACOS **4.36%**, target <18%, flag >22%. Fresh load into `/tmp/northline-ops-qa` copies fixture `logic.md` with TACOS and `status: reviewed`. `python3 tests/kit_check.py` → `ok`. |
| 2 | delete ads source → `(not in the data)` + scoreboard | **skipped** live grok. **pass** pack | `operator-prove` scoreboard names `<metric> = no source.` `ppc-exception-brief` writes `(not in the data)` when ads/sales sources are missing and still writes the artifact. `/prove` does not fail on a missing watch source. Did not delete ads and re-prove in this environment. |
| 3 | wrong columns named | **skipped** live grok. **pass** pack | `ppc-exception-brief`, `inventory-risk`, and `review-intelligence` all say: if the connected file is the wrong report, name the file and the expected columns; do not guess numbers. Did not drop a mutated CSV in front of a live agent. |
| 4 | overnight inventory-only when only cover flags | **skipped** live overnight. **pass** rule + fixture math | Cover-only (hero 12d, TACOS 4.36% quiet, wasted cleared) maps to inventory. Workflow `let cap = 2` and never `agent_type: "listing"` / `"creative"`. Skill: quiet ads/customer → spawn nobody extra. Did not run `bin/overnight.sh`. |
| 5 | two flags spawn two | **skipped** live overnight. **pass** rule + fixture math | Default fixtures trip inventory (cover 12d) and ads (wasted $40). Spawn `["inventory", "ads"]`. Cap not exceeded. |
| 6 | three flags spawn inventory+ads | **skipped** live overnight. **pass** rule | Default priority inventory, ads, customer. `seats` schema maxItems 3; rhai truncates to `cap = 2` → inventory + ads unless logic reorders those three. |
| 7 | defaults-not-reviewed warns | **skipped** live grok. **pass** pack | `operator-prove`: warn `logic is still defaults — run /logic or your briefs will look like every other Amazon dashboard.` Do not stop. `overnight-ops` still writes the brief and says so at the top. Fixture `logic.md` is reviewed (kit_check fails if it contains `defaults-not-reviewed`). |
| 8 | ACOS 35 vs TACOS 22 | **pass** | Leftover `ppc-exception-brief-2026-09-01.md`: "Skill-default 35% ACOS not used. Logic names TACOS." Campaign ACOS 41% on B0FIXTURE2 is not the flag; ASIN TACOS 14.39% < 22%. Weekly north star is TACOS, not ACOS. Would have been **fail** if an agent had flagged 35% ACOS. |
| 9 | delivery 404 → Delivery: failed | **skipped** live POST. **pass** pack | `overnight-ops` skill: write the file first; method slack/webhook POST; retry at most twice; HTTP non-2xx → `Delivery: failed`; do not crash; do not copy the URL into the brief. Template `delivery.md` is `method: none` (Delivery: skipped). Did not POST to a 404 URL. |
| 10 | empty exports overnight → one-line incomplete | **skipped** live overnight. **pass** pack | Skill + rhai: if zero sources readable (or Checks failed), write one line only `Overnight run could not read any source`, prefix `INCOMPLETE BRIEF`, `spawn_list = []`. Never a clean empty brief. |
| 11 | specialist cannot write exports | **pass** pack (write-deny not live-exercised) | `template/bin/overnight.sh` has `--deny 'Write(./exports/**)'` and `--deny 'Bash(rm*)'`. grok 1.0.16 parses those deny rules (`--deny` accepted; parse-only with `--__no_such_flag` then failed on the dummy flag, not on deny). Specialists' skills: do not edit `exports/`. Did not live-probe a write. |

Pack smoke (this pass):

```
python3 tests/kit_check.py          # ok
grok plugin validate plugins/amazon-operator-os   # Plugin manifest is valid
bash scripts/load-fixtures.sh /tmp/northline-ops-qa
bash -n template/bin/overnight.sh   # ok
```

## Ship gate

Ship only when no row is **fail**. Skipped live grok is allowed when the pack/rule column passes and the skip reason is recorded. Row 8 is a hard fail if a fixtures ads brief uses 35% ACOS.

Support bar for a green prove: `docs/WHAT-GOOD-LOOKS-LIKE.md`.
