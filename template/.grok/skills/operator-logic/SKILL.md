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
