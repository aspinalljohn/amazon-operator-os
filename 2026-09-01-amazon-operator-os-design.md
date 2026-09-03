# Amazon Operator OS — Design Spec

Date: 2026-09-01
Status: draft for review
Venture: Operator Intelligence
Working name: Amazon Operator OS

This is the product spec for a self-serve Grok kit that puts six named agents into an Amazon brand owner's business. They declare what data they actually have (`reference/sources.md`) and the metrics/rules they actually run on (`reference/logic.md`), drop those files, run `/prove`, and each agent writes a real artifact using *their* logic. Overnight, Ops checks *their* flags and may spawn up to two flagged specialists.

---

## 1. Promise

An Amazon brand owner with **Grok Bot** and an eligible Cursor/xAI plan can, in one sitting:

1. Install the kit.
2. Get a business folder at `~/Documents/<brand-slug>-ops/`.
3. Talk to the **main agent** once (`/operator-setup`). It interviews them for sources and logic in that same sitting. `/sources` and `/logic` exist for later edits, not as day-one homework.
4. Drop or connect those sources.
5. Run `/prove` and get six dated artifacts that use *their* metrics.
6. Optionally install overnight. Next morning a brief is in `reports/` and, if they opted in, Slack or email.

They do not need Seller Central API access, image-generation keys, or Claude Code. They do not edit skills.

**Done for a v1 buyer:** every seat shipped its named artifact from their files, using their logic file. Missing data is written as `(not in the data)`, never invented. A watch metric with no source is named on the `/prove` scoreboard.

---

## 2. Key decisions

| Decision | Choice | Why |
|---|---|---|
| What this is | Sellable self-serve kit | Same muscle as Second Brain DIY Kit. Cohort and VS installs reuse the same repo later. |
| Who | Amazon brand owner / operator | Not an agency pack, not a generic coding-agent starter. |
| Runtime | **Grok Bot** desktop app + cloud `/workspace/` (default). Grok Build CLI optional for local dev. | Named Bots, skills, Routines. Skill bodies stay portable `SKILL.md`. `.rhai` workflows = CLI advanced only. |
| Ship shape | Hybrid: Grok plugin + business-folder zip | Zip works offline like Second Brain. Plugin is the update channel. |
| Roster | Full OS: Ops, Listing, Ads, Inventory, Customer, Creative | Buyer-locked. Creative in v1 is briefs only, no image gen. |
| Data | Source registry, not five forced CSVs | Catalog of known Amazon reports exists. `/sources` maps what *they* have (csv / sheet / url / paste / mcp). No Amazon APIs in v1. |
| Personalization | `sources.md` + `logic.md`, never skill edits | Interview captures metrics, flags, exceptions, brief contents. Skills stay generic. Their files win over skill defaults. |
| Setup interview | Parent / Ops session, one sitting | Subagents cannot interview (no back-and-forth). Do not spawn specialists during setup. `/sources` and `/logic` are later-edit commands; day one is `/operator-setup` only. |
| Overnight | Ops always; fan-out only on *their* flags; cap 2 specialists | Default priority inventory > ads > customer unless logic reorders those three. Listing and creative never run overnight. |
| Delivery | File always; Slack webhook or email/webhook optional | Opt-in during setup. Fail loud if delivery is configured and the post fails. |
| Support | Install + green `/prove` + a logic file that looks like them | Not custom skill writing. Not Velocity client pipelines. |
| Price (kit) | $997 | Second Brain is $500 (vault). This is the operating layer. Confirm at checkout build. |
| Working folder | `/workspace/<brand-slug>-ops/` on Grok Bot cloud computer (default). `~/Documents/<brand-slug>-ops/` for Grok Build CLI advanced. | Predictable. Setup does not write into an existing vault. |

---

## 3. Architecture

```
Buyer Grok Bot account
├── Grok Bot desktop app (authenticated with Cursor)
├── Cloud computer: /workspace/<brand>-ops/
├── Six named Bots (Ops, Listing, Ads, Inventory, Customer, Creative)
├── Plugin / vendored .grok/ (agents, skills)
└── Business folder on cloud workspace
    ├── AGENTS.md                 (context every agent reads)
    ├── exports/                  (drop-only, never written by agents)
    ├── reference/
    │   ├── sources.md            (what they have, where it lives, how to refresh)
    │   ├── logic.md              (metrics, flags, exceptions, what to show)
    │   ├── how-to-refresh.md     (one-pager generated from *their* sources)
    │   ├── brand.md, asins.md, delivery.md
    ├── reports/                  (finished artifacts)
    ├── drafts/                   (rewrites, reply drafts)
    └── logs/                     (overnight run log)
```

Grok opened in the business folder *is* the OS. The plugin supplies the six agent types and the skills (generic procedures). The folder supplies the brand, the wiring, the logic, and the outputs. Skills never contain a buyer's ACOS number.

Two install paths, one artifact:

| Path | Who | What happens |
|---|---|---|
| Zip / Drive | Default self-serve | Unzip, `cd` into folder, open Grok, `/operator-setup`. Skills and agents are already under `.grok/` in the zip. |
| Plugin | Updates, GitHub invitees | `grok plugin marketplace add <repo>` then `grok plugin install amazon-operator-os --trust`. Setup still writes the business folder. |

The private GitHub repo is both the marketplace source and the zip source.

---

## 4. Repo layout

Private repo: `aspinalljohn/amazon-operator-os`

```
amazon-operator-os/
  .grok-plugin/
    marketplace.json
  plugins/amazon-operator-os/
    plugin.json
    agents/
      ops.md
      listing.md
      ads.md
      inventory.md
      customer.md
      creative.md
    personas/
      operator.toml
    skills/
      operator-setup/SKILL.md
      operator-sources/SKILL.md
      operator-logic/SKILL.md
      operator-prove/SKILL.md
      install-overnight/SKILL.md
      weekly-operator-report/SKILL.md
      overnight-ops/SKILL.md
      listing-audit/SKILL.md
      amazon-title-compress/SKILL.md
      amazon-qa-generator/SKILL.md
      amazon-attribute-fill-rate/SKILL.md
      amazon-ai-shopping-visibility-audit/SKILL.md
      ppc-exception-brief/SKILL.md
      inventory-risk/SKILL.md
      review-intelligence/SKILL.md
      aplus-brief/SKILL.md
      image-stack-brief/SKILL.md
    workflows/
      weekly-ops.rhai
      overnight-ops.rhai
    commands/
      prove.md
      sources.md
      logic.md
      weekly.md
      overnight.md
  template/
    AGENTS.md
    exports/{sales,ads,inventory,reviews,listings}/README.md
    reports/.gitkeep
    drafts/.gitkeep
    logs/.gitkeep
    reference/{brand.md,asins.md,sources.md,logic.md,how-to-refresh.md,delivery.md}
    .grok/          # vendored copy so the zip runs without a plugin install
  fixtures/         # anonymized CSVs for QA and optional /prove --fixtures
  docs/
    INSTALL.md
    EXPORTS.md
    WHAT-GOOD-LOOKS-LIKE.md
    DELIVER.md      # John's fulfillment SOP
```

The zip is `template/` plus vendored `.grok/` (agents, skills, workflows). The plugin is the same agents/skills without the buyer's files.

---

## 5. Folder, sources, and logic

Skills are generic procedures. The buyer's business lives in two files they own. They never edit a skill to change an ACOS number or add a Helium10 dump.

Every agent, first four steps, non-negotiable:

1. Read `AGENTS.md`
2. Read `reference/sources.md`
3. Read `reference/logic.md`
4. Run the skill using **their** metrics, flags, exceptions, and brief contents. Skill defaults apply only when `logic.md` has no value for that field.

### 5.1 Folders

| Path | Rule |
|---|---|
| `exports/` | Buyer drop zone. Agents read only. Never edit. |
| `reference/` | Standing facts, wiring, logic. Setup and `/sources` `/logic` write these. Buyer may edit. |
| `reports/` | Finished artifacts. Dated when time-bound. |
| `drafts/` | Rewrites and reply drafts, not the audit itself. |
| `logs/` | Overnight stdout/stderr. |

Filenames: lowercase, dashes, `.md` or `.csv`. Dates only on time-bound docs.

### 5.2 Known-source catalog (not a forced list)

The kit ships five *known* Amazon-operator buckets so `/sources` has something to map onto. They are not all required. A source that is not in `sources.md` is not checked overnight and is not demanded by `/prove`.

A missing connected source does **not** fail setup. It fails that seat's artifact honestly: the agent still writes the file, with `(not in the data)` on every claim it could not source.

Newest file in a bucket wins. Dated names are fine.

| Bucket | Typical drop | Amazon / tool source | Minimum columns / shape |
|---|---|---|---|
| `exports/sales/` | `business-report.csv` | Seller Central → Business Reports → Detail Page Sales and Traffic by Child Item. Or a Sheet export of the same. | ASIN (or Child ASIN), Sessions, Units Ordered, Ordered Product Sales, Conversion Rate |
| `exports/ads/` | `sp-campaigns.csv` and/or `sp-search-terms.csv` | Ads console → SP Campaign and Search term reports | Campaigns: Campaign Name, Spend, Sales, ACOS, Impressions, Clicks. Search terms: Customer Search Term, Spend, Sales, ACOS, Orders, Match Type |
| `exports/inventory/` | `fba-inventory.csv` (Inventory Planning / Restock preferred) | Seller Central → Inventory Planning or FBA Manage Inventory | SKU, ASIN, Available, Inbound (if present), Days of Supply (if present). If days of supply is missing, compute from sales velocity when a sales source exists |
| `exports/reviews/` | `reviews.csv` or `reviews.md` | Amazon has no clean SC reviews export. Helium10 / Keepa / pasted last-90-day dump | Per review: date, rating, ASIN or product name, body |
| `exports/listings/` | `catalog.csv` or `listings.md` | All Listings Report, or ASIN + Amazon URL + current title. Public Amazon URL is a fallback | ASIN, title, at least one URL or the full listing text |

Operators who live in Sheets, Helium10, or a pasted dump map those onto the same seats. `/sources` does not invent a sixth Amazon report they do not have.

### 5.3 `reference/sources.md` — the wiring

Written by `/sources`. Buyer may edit. Shape:

```markdown
# Sources

| id | seat | type | path_or_url | freshness | status | how_i_get_it |
|---|---|---|---|---|---|---|
| sales | ops, ads, inventory | csv | exports/sales/ | daily | connected | SC → Business Report → Detail Page by Child → 14 days |
| ads-search-terms | ads, ops | csv | exports/ads/sp-search-terms.csv | daily | connected | Ads → SP → Search term report → 14 days |
| reviews | customer | paste | exports/reviews/reviews.md | weekly | missing | Helium10 Review Insights — not connected yet |
```

`type` is one of: `csv` | `sheet` | `url` | `paste` | `mcp`.

`status` is `connected` | `missing` | `stale` (file older than freshness).

v1 connection types:

1. **File drop** — the floor. CSV, xlsx, markdown.
2. **Google Sheet URL** — source is the URL, or a CSV they export from that sheet. No fake Sheets product.
3. **MCP already connected** — `/sources` runs `grok inspect` (or equivalent) and lists live servers. If Slack/Gmail/Sheets is live, the card points at that server_id. If they want it and it is not live, print the exact `config.toml` snippet, they authenticate, they say "done," setup pings once.
4. **Public Amazon URL** — listing fallback only.

Not v1: Seller Central OAuth, Helium10 API keys, "connect everything" in one click.

`/sources` also writes `reference/how-to-refresh.md` — a one-pager of **only their connected sources**, not the full catalog. Overnight only pulls sources with `freshness: daily` and `status: connected`.

Commands after day one: `/sources add …`, `/sources` to re-interview, edit the markdown.

### 5.4 `reference/logic.md` — their rules

Written by `/logic`. This file beats every default inside a skill. `reference/thresholds.md` does not exist; numbers live here.

Required sections:

```markdown
# Operating logic

## North star
The number that matters: <metric>. Target: <value>. Source: <source id>.

## Metrics I watch
| metric | why | source_id | good | flag | seat |
|---|---|---|---|---|---|
| TACOS | total ads efficiency | sales + ads-campaigns | <18% | >22% | ads, ops |

## Rules
- If cover < 21 days on an ASIN that is still spending, throttle ads. Do not buy clicks we cannot fill.
- Ignore ACOS on ASINs tagged launch for 14 days.

## Exceptions
- FBM SKUs: ignore FBA inbound. Watch vendor lead time instead.
- Retired ASINs in asins.md: never report.

## Brief
Morning must include: <their list>
Morning must never mention: <their list>
Weekly must include: north star, what moved, one decision.

## Overnight
priority: inventory, ads, customer
cap: 2
```

Account-level first. Per-ASIN / per-tag overrides are optional and live in the same file:

```markdown
## Overrides
- B0HERO: always first in every brief, cover flag 60 days
- tag:launch: ignore TACOS for 14 days
- tag:retired: never report
```

`/logic` does not require a per-ASIN spreadsheet on day one. It asks one question: "Any ASINs or groups that do not follow the defaults?"

### 5.5 `/sources` interview

Invoked inline by `/operator-setup` on day one, and as `/sources` later when wiring changes. Operator language, not a 40-field form. Parent session only.

1. "What numbers do you already look at, and where does each one live?" Map answers onto the catalog. Unknown tools get `type: paste` or `type: csv` with a buyer-named path.
2. For each named source: have it now / skip / later. Skip writes `status: missing`.
3. For "have it now": drop path, Sheet URL, paste, or MCP ping.
4. Write `sources.md` + `how-to-refresh.md`. Show them the table. "Is this your stack?"
5. Stop. Do not wait for every file to land.

### 5.6 `/logic` interview

Invoked inline by `/operator-setup` after the sources interview, and as `/logic` later when rules change. May run with missing sources. Four clusters, then compile the file and show it. Parent session only.

1. **What do you check before you do anything else?** 3–7 metrics in their words. Map each to a `source_id`. If they name a metric with no source: "We do not have that file yet. Skip it, or tell me where it lives."
2. **When do you want to be woken up?** One flag per metric. Sentence in, rule out.
3. **What would a generic Amazon dashboard get wrong?** Launch ASINs, kits vs units, FBM, Subscribe & Save, 3P, parent/child, bundles, B2B, seasonal, retired. Written as exceptions.
4. **What should the morning brief include? What should it never mention?**

Then show `logic.md`: "Is this you?" They can edit the markdown. `/logic add If hero TACOS > 25, stop scaling` appends a rule. No reinstall.

If they refuse the interview, write a **starter logic** from defaults (ACOS 35%, sales drop 20% vs 7d, cover 14 days, refund keywords) and stamp `status: defaults-not-reviewed` at the top. Overnight still runs. `/prove` warns: "logic is still defaults — run `/logic` or your briefs will look like every other Amazon dashboard."

### 5.7 Other `reference/` files

`reference/brand.md` — name, what they sell, voice (two lines), marketplaces. Written by setup.

`reference/asins.md` — working ASIN list plus optional tags (`hero`, `launch`, `fbm`, `retired`). Empty is allowed; Listing/Creative then take ASINs from the listing source.

`reference/delivery.md`:

```
method: none | slack | webhook
url:
email:
```

Secrets stay in this local file. Never in the GitHub repo, never in the zip template.

### 5.8 Honesty rule (non-negotiable)

- If a number is not in a connected source, write `(not in the data)`.
- If two sources disagree, surface the conflict. Do not pick silently.
- If a file is unreadable or the wrong report, name the file and the expected columns.
- If `logic.md` asks for a metric whose `source_id` is `missing`, name that metric on the `/prove` scoreboard. Do not drop it quietly.

---

## 6. Agents, artifacts, skills

Default session in the business folder is **ops**. Specialists are custom agent types the parent may spawn, or the buyer may switch to with `/agent <name>`.

Persona `operator` on every specialist: direct, metrics over adjectives, no hype, no emojis, name source files.

Every agent file repeats the section 5 preamble (read AGENTS.md, sources.md, logic.md first). A specialist that flags ACOS 35% while `logic.md` says TACOS 22% is a bug.

Specialists cannot spawn children (Grok depth limit is one). Fan-out always starts from Ops or from a workflow.

### 6.1 Ops

**Agent file:** `agents/ops.md`
**Job:** route, compile, overnight, weekly.
**Reads:** `reference/sources.md`, `reference/logic.md`, connected sources only, specialist reports when present. Top line and "what moved" come from logic's north star and watch list, not a hardcoded revenue/ACOS/units set.
**Artifacts:**

| Command | File |
|---|---|
| `/weekly` or weekly workflow | `reports/weekly-report-YYYY-MM-DD.md` |
| Overnight | `reports/morning-brief-YYYY-MM-DD.md` |

Weekly report shape (from the existing operator-starter skill):

```
# Weekly report → <week ending>

## The number that matters
## What moved
## What needs attention
## One decision for next week
## Specialist attachments
## Sources
```

Morning brief shape:

```
# Morning brief → <date>
**Top line:** revenue, ad spend, ACOS, units vs trailing 7-day avg
**Flagged (do first):** tripped checks, costliest first, with the specialist artifact path if one ran
**Quiet:** sources that came back clean
**Source failures:** named explicitly. If non-empty, prefix title with INCOMPLETE BRIEF
**Delivery:** sent / skipped / failed
```

### 6.2 Listing

**Agent file:** `agents/listing.md`
**Job:** audit the live (or exported) listing. No catalog push.
**Artifact:** `reports/listing-audit-<asin>.md`
**Skills reused (operator-generic copies, strip Velocity / Wood Defender / client paths):** `listing-audit`, `amazon-title-compress`, `amazon-qa-generator`, `amazon-attribute-fill-rate`, `amazon-ai-shopping-visibility-audit`

Audit must include: title (and 75-char compression), bullets, image stack gaps, A+ gaps, attribute holes, AI-shopping / Rufus gaps, Q&A holes. Recommendations go in the audit. Full rewrites are *not* required in v1 (buyer declined "also rewrite"). They can ask Listing in a follow-up session to write drafts.

If multiple ASINs, `/prove` runs the first ASIN in `reference/asins.md`, else the first ASIN in the listing export. `/listing-audit <asin>` does a named one.

### 6.3 Ads

**Agent file:** `agents/ads.md`
**Job:** exception brief, not a bid manager.
**Artifact:** `reports/ppc-exception-brief-YYYY-MM-DD.md`
**Skill (new):** `ppc-exception-brief`

Must include: whatever ads metrics `logic.md` flags (TACOS, ACOS, wasted spend — their names, their numbers), wasted search terms when that source is connected, harvest candidates (converting terms on broad/phrase that deserve exact), `(not in the data)` if a watch metric's source is missing. Skill defaults (ACOS 35%) apply only when logic has no ads flags.

No bid writes. No Amazon Ads API.

### 6.4 Inventory

**Agent file:** `agents/inventory.md`
**Job:** cover and stockout risk.
**Artifact:** `reports/inventory-risk-YYYY-MM-DD.md`
**Skill (new):** `inventory-risk`

Must include: SKUs that trip the cover/stockout flags in `logic.md`, inbound vs gap, recommended action (replenish / throttle ads / do nothing), join to ads spend when both sources exist (do not keep spending into a stockout). Honor exceptions (FBM, launch, retired). Compute days of cover from sales velocity when the inventory source has no days of supply. Skill default (14 days) applies only when logic has no cover flag.

### 6.5 Customer

**Agent file:** `agents/customer.md`
**Job:** review intelligence, not a helpdesk.
**Artifact:** `reports/review-intelligence-YYYY-MM-DD.md`
**Skill (new):** `review-intelligence`

Must include: rating mix, top 5 themes, 1-star / 2-star clusters, listing or product implications (one line each), 3 reply drafts in `drafts/review-replies-YYYY-MM-DD.md`. If the dump has no dates, say so.

### 6.6 Creative

**Agent file:** `agents/creative.md`
**Job:** briefs, not pixels.
**Artifact:** `reports/creative-brief-<asin>.md`
**Skills reused (brief path only):** `aplus-brief`, `image-stack-brief` (a stripped `amazon-image-stack` that stops at the brief and does not call image APIs)

Must include: 5–7 secondary image stack (role + copy + art direction per slot), Premium A+ module list with copy and art direction. No Higgsfield, no gpt-image, no SBV, no Brand Store, no social ads.

Same ASIN selection rule as Listing.

### 6.7 Capability and model

| Agent | Capability | Lane |
|---|---|---|
| ops | all, cwd-locked | day-to-day default; overnight uses the same model with `--max-turns 40` |
| listing, creative | read-write (reports + drafts only) | day-to-day |
| ads, inventory, customer | read-write (reports + drafts only) | day-to-day |

Volume-lane-router is an internal note in overnight-ops (gather/check is cheap; judgment on flags is the same model in v1). Do not expose a model-router UI to the buyer in v1. One xAI model, one bill.

Plugin agent frontmatter must not set `permissionMode: bypassPermissions` (Grok ignores it on plugin agents). Overnight always-approve is a CLI flag on `grok --always-approve`, not an agent file.

---

## 7. Orchestration

### 7.1 `/operator-setup` (parent session only)

This is the interview. The **main agent** (default session / Ops) runs it. Never `spawn_subagent` during setup, sources, or logic. Never a workflow. The operator is answering questions; a child agent cannot do that.

Day one is **one command**: `/operator-setup`. It runs the sources interview and the logic interview inline in the same conversation. `/sources` and `/logic` stay as later-edit commands when the business changes. Do not make the buyer run three slash commands to get live.

Does not wait for files.

1. Check `grok` is on PATH and the user is authenticated. If not, print the two install/auth commands from `docs/INSTALL.md` and stop.
2. Ask, one cluster at a time: brand name, what they sell, 1–3 ASINs (optional), voice (or accept the default operator voice), delivery (none / Slack webhook / email-or-generic webhook).
3. Write `~/Documents/<brand-slug>-ops/` from `template/`. Fill `AGENTS.md`, `reference/brand.md`, `reference/asins.md`, `reference/delivery.md`.
4. **Sources interview (inline).** Follow `operator-sources` in this same session. Write `reference/sources.md` and `reference/how-to-refresh.md`. Show the table: "Is this your stack?"
5. **Logic interview (inline).** Follow `operator-logic` in this same session. They can skip and accept `defaults-not-reviewed`. Write `reference/logic.md`. Show the file: "Is this you?"
6. Print the refresh card and: "Drop or connect those files, then run `/prove` in this folder."
7. Stop. Overnight is a separate command. Do not spawn Listing/Ads/Inventory/Customer/Creative during this sitting.

### 7.2 `/prove`

Smoke test that the OS works on *their* files.

1. Read `sources.md` and `logic.md`. List connected vs missing sources. If logic is `defaults-not-reviewed`, warn.
2. Spawn specialists in parallel (workflow `weekly-ops.rhai` with `mode: prove`): Listing, Ads, Inventory, Customer, Creative. Listing and Creative share the prove ASIN.
3. Ops writes the weekly report from *their* north star and watch list, attaching whatever specialist files exist and naming missing sources under Source failures.
4. Print a two-line scoreboard:
   - Artifacts: 6/6 (or N/6). A file full of `(not in the data)` still counts as shipped.
   - Logic: "K of M watch metrics had data. <metric> = no source."
5. `/prove` passes if all six files exist on disk. It does **not** fail because a watch metric lacks a source — that is the second line, so they can add a source or drop the metric.

Optional support flag: `/prove --fixtures` copies `fixtures/` into `exports/` (does not overwrite non-empty buyer files) and runs the same path. Not buyer-default.

### 7.3 `/weekly`

Same fan-out as `/prove`, dated for this week. Buyer-facing operating command after the first prove.

Workflow `weekly-ops.rhai`:

- Phase 1: parallel listing, ads, inventory, customer, creative (`agent_type` set, `capability_mode: read-write`, prompts command them to read `AGENTS.md`, `reference/sources.md`, `reference/logic.md`, then connected sources, and write the named artifact).
- Phase 2: ops compiles `weekly-report-YYYY-MM-DD.md`.
- Guard every specialist result. A failed slot becomes `(not in the data)` in the weekly report, not a crash.
- `agent_budget` 8 (5 specialists + ops + headroom).

### 7.4 Overnight

Unattended. Launchd (macOS) calls a wrapper script in the business folder:

```
bin/overnight.sh
```

Behavior:

```bash
cd "$OPS_DIR"
DATE=$(date +%F)
grok --always-approve --cwd "$OPS_DIR" --max-turns 40 \
  --allow 'Read(./**)' \
  --allow 'Write(./reports/**)' \
  --allow 'Write(./drafts/**)' \
  --allow 'Write(./logs/**)' \
  --deny 'Write(./exports/**)' \
  --deny 'Bash(rm*)' \
  -p "Run the overnight-ops skill and overnight-ops workflow for ${DATE}. Follow reference/sources.md and reference/logic.md. Do not spawn listing or creative." \
  >> "logs/overnight-${DATE}.log" 2>&1
```

Setup does not write a separate prompt file in v1; the wrapper passes the prompt inline.

Workflow `overnight-ops.rhai` / skill `overnight-ops`:

1. Ops reads `sources.md` + `logic.md`. Pulls only `freshness: daily` connected sources. Writes the skeleton brief using logic's **Brief** section (not a hardcoded revenue/ACOS/units block).
2. Run checks from `logic.md` rules (not skill-default ACOS 35% / cover 14).
3. Build the spawn list from tripped flags. Priority from `logic.md` Overnight section, default **inventory > ads > customer**, cap **2** (logic may not raise the cap). Never spawn listing or creative overnight.
4. `parallel()` those specialists. Attach their artifact paths to the brief.
5. If a configured delivery URL exists, POST the brief. On HTTP failure, the brief's Delivery line is `failed` and the log says so. Do not retry more than twice.
6. If zero sources readable: send/write one line `Overnight run could not read any source` and exit. Never a clean-looking empty brief.
7. Cap: one pass, max two specialist retries of a failed spawn, `--max-turns 40` on the parent.

Launchd: `~/Library/LaunchAgents/com.operatoros.overnight.plist`, 5:00 AM local. `install-overnight` writes the plist, `launchctl load`s it, and runs a noon dry-run (`/overnight --now`) before trusting 5am.

Windows: out of v1. Docs say run `/weekly` manually.

Host must be on at 5am. INSTALL.md says: Mac that sleeps will miss the run; use an always-on Mac mini or disable sleep, or skip overnight.

### 7.5 On-demand

Buyer can talk to Ops in English ("should I keep spending on the moisturizer SKU?") or switch `/agent ads`. Ops may spawn one specialist for a question. Same honesty rules.

---

## 8. Safety

| Rule | v1 |
|---|---|
| Interactive permissions | ask (Grok default) |
| Overnight permissions | `--always-approve` plus allow/deny globs above |
| Writes | `reports/`, `drafts/`, `logs/`, `reference/` (setup, `/sources`, `/logic` only) |
| `exports/` | read-only forever |
| Outside the business folder | deny |
| Amazon writes | none |
| Email/Slack | only if `reference/delivery.md` method is not `none` |
| Secrets | local `reference/delivery.md` and `~/.grok/config.toml` only |
| Plugin trust | install with `--trust`; no plugin hooks that execute arbitrary shell at session start |
| Overnight cost | max 2 specialists, max-turns 40, no listing/creative |

---

## 9. Commercial wrapper

**SKU:** Amazon Operator OS, self-serve kit, **$997** (confirm at checkout).

**Delivery (John):** same muscle as Second Brain DIY Kit.

1. Payment lands.
2. Share Drive walkthrough (Grok install → `/operator-setup` → `/sources` → `/logic` → drop one of *their* files → `/prove`).
3. Email zip from john@goaspi.com (`amazon-operator-os.zip`) plus, if they have a GitHub username, invite to `aspinalljohn/amazon-operator-os`.
4. Log the buyer (reuse the kit buyers-log pattern; new tab or file `amazon-operator-os-buyers-log.md`).

**What's in the box:** zip, INSTALL.md, EXPORTS.md (catalog), plugin/repo access, six agents, `/sources`, `/logic`, `/prove`, optional overnight.

**What's not:** image generation, Seller Central login work, custom skill writing, Claude Code dual install, Windows overnight, advisory time.

**Support boundary:** "I will get you to a green `/prove` on your files and a `logic.md` that looks like you." After that, OI cohort or advisory. They edit `sources.md` / `logic.md` themselves. You do not write them a new skill because they watch TACOS instead of ACOS.

**Reuse later (not v1 work):**

- OI Grok track uses this repo as the week-1–4 implementation asset.
- Velocity Sellers DWY install uses the same plugin, filled with the client's sources and logic.

**IP:** operator-generic skills only. Do not ship Wood Defender, ProductPinion client labs, Velocity-branded PDFs, Higgsfield keys, or John's private MCP configs.

**Name:** Amazon Operator OS. Do not rename in v1 unless the sales page work forces it. It already exists as an OI landing option.

---

## 10. Buyer journey (90 minutes)

1. Buy. Get email + Drive video + zip.
2. Install **Grok Bot** from [x.ai/bot](https://x.ai/bot), sign in with Cursor (video).
3. Create six Bots; deploy kit to `/workspace/`; Ops → `/operator-setup`.
4. Follow *their* refresh card (`reference/how-to-refresh.md`).
5. `/prove`. Read six artifacts and scoreboard.
6. Optional: `/install-overnight` Routine + `/overnight --now` test.

Success email (auto or John): "Reply with the path to `reports/` if `/prove` is not 6/6."

---

## 11. QA bar (v1 does not ship without this)

Internal `fixtures/` is an anonymized Amazon-like brand (5–8 child ASINs, 14 days sales, 2 ad campaigns, mixed inventory cover, 40 reviews, one listing markdown).

Must pass:

| Test | Pass |
|---|---|
| `/prove --fixtures` with fixture `logic.md` (TACOS + cover, not ACOS-only) | six artifacts; briefs use TACOS as north star |
| Delete ads source and re-prove | ads artifact exists, `(not in the data)`; scoreboard says TACOS = no source |
| Wrong-columns CSV | agent names the file and expected columns |
| Overnight dry-run with inventory cover forced under *their* flag | Ops + inventory specialist only (1 of 2), brief attaches inventory-risk path |
| Overnight dry-run with ads and inventory both flagging | both specialists, cap not exceeded |
| Overnight with three flags (inventory, ads, customer) | inventory + ads only unless logic reordered those three |
| `logic.md` still `defaults-not-reviewed` | `/prove` warns; overnight still runs on defaults |
| Agent flags ACOS 35% while logic says TACOS 22% | fail QA — preamble not followed |
| Delivery URL 404 | brief written, Delivery: failed, no crash |
| Empty `exports/` overnight | one-line incomplete alert, no fake-clean brief |
| Specialist cannot write `exports/` | deny |

No live Amazon account required for QA.

---

## 12. v1 out / v2 in

**v1 out**

- Image generation
- Seller Central / Amazon Ads APIs
- Claude Code dual runtime (skills remain portable; we do not test or support Claude install)
- Brand Store, SBV, social ads
- Windows overnight installer
- Live catalog or campaign writes
- Required Slack/email (optional only)
- Buyer-facing demo brand as the default prove path
- Model-router UI

**v2 candidates**

- Live MCP (Sheets, Gmail, Slack app, store/ads if a real connector exists)
- Image gen as an opt-in Creative flag with the buyer's own key
- Windows Task Scheduler overnight
- `/prove` demo brand onboarding
- Listing rewrite pack into `drafts/` as a first-class prove artifact
- OI cohort track wrapper
- VS DWY install SOP

---

## 13. What we reuse vs write

Reuse, operator-generic (copy into the plugin, strip client/path/API specifics):

- `opencode-operator-starter` folder scheme, voice, weekly report shape
- `overnight-ops` run definition and failure-safe rules
- `listing-audit`, `amazon-title-compress`, `amazon-qa-generator`, `amazon-attribute-fill-rate`, `amazon-ai-shopping-visibility-audit`
- `aplus-brief` and the brief-only path of `amazon-image-stack`
- Second Brain delivery SOP as the pattern for `docs/DELIVER.md`
- OI `docs/EXPORTS` thinking from cohort week 2 (CSV / Sheets), rewritten for Grok

Write new:

- Six Grok agent definitions + operator persona
- `operator-setup`, `operator-sources`, `operator-logic`, `operator-prove`, `install-overnight`
- `ppc-exception-brief`, `inventory-risk`, `review-intelligence`, `image-stack-brief` (if the existing image-stack skill cannot be cleanly truncated)
- `weekly-ops.rhai`, `overnight-ops.rhai`
- `bin/overnight.sh` + launchd plist template
- Fixture CSVs
- INSTALL / EXPORTS (catalog) / WHAT-GOOD-LOOKS-LIKE / DELIVER
- Marketplace index + plugin.json

Do not rebuild: Higgsfield creative pipeline, ProductPinion lab, Velocity AI-shopping PDF, mcp-ops-hub as a buyer-facing skill (no required MCP in v1).

---

## 14. Build order

Each increment must leave `/prove --fixtures` no worse than before. After increment 3, Ops + fixtures weekly report must already work.

| # | Increment | Ships |
|---|---|---|
| 1 | Repo + marketplace + plugin.json + template folders + fixture CSVs | Empty kit that Grok can discover |
| 2 | `AGENTS.md` template, source catalog docs, empty `sources.md` / `logic.md` stubs | A human can declare a source and drop a file |
| 2b | `operator-sources` + `operator-logic` + fixture `logic.md` | Interview writes the two files; agents can read them |
| 3 | Ops agent + weekly-operator-report + overnight-ops skill (no fan-out yet) | Weekly report and a file-only morning brief from fixtures **using fixture logic** |
| 4 | Listing agent + ported listing-audit set | `/prove` listing artifact |
| 5 | Ads agent + ppc-exception-brief | ads artifact |
| 6 | Inventory agent + inventory-risk | inventory artifact |
| 7 | Customer agent + review-intelligence | customer artifact |
| 8 | Creative agent + aplus-brief + image-stack-brief | creative artifact; `/prove` can hit 6/6 on fixtures |
| 9 | `operator-setup` + `operator-prove` + weekly-ops workflow | Buyer path without overnight |
| 10 | Overnight fan-out (cap 2) + launchd installer + Slack/webhook delivery | Unattended path |
| 11 | QA matrix in section 11 + `docs/WHAT-GOOD-LOOKS-LIKE.md` | Ship gate |
| 12 | Zip build + `docs/DELIVER.md` + buyers log + Drive walkthrough outline | You can sell it |

---

## 15. Open questions

None that block the spec. Confirm at checkout-build time (not spec-blockers):

- Final price if $997 is wrong.
- GitHub repo visibility (private + invite vs zip-only for buyers who will never use git).
- Exact Drive walkthrough owner (you vs an editor).

---

## 16. Spec self-review

- No TBD in v1 behavior. Price is a number. Caps are numbers. Artifact paths are named.
- Overnight fan-out and optional Slack/email are in, matching the locked overrides.
- Creative cannot generate images. Dual Claude runtime is out. Amazon APIs are out.
- Full OS is six seats, each with a named file. `/prove` requires the files to exist, not the data to be complete.
- Personalization is `sources.md` + `logic.md`. Skills stay generic. The main agent interviews on `/operator-setup` (parent only, one sitting). `/sources` and `/logic` are later-edit commands.
- Scope is one product (the kit). Cohort track and VS DWY are reuse notes, not v1 work.
