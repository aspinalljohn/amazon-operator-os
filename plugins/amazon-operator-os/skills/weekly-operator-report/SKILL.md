---
name: weekly-operator-report
description: Read this week's connected business exports and write a one-page operator report from logic.md's north star. Use when the operator says "run the weekly report", "what happened this week", or every Friday.
when_to_use: End of week, or any time the operator wants a fast read on the numbers from the latest connected exports.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Weekly operator report

Produce a one-page weekly report from the connected sources in `reference/sources.md`, scored against `reference/logic.md`. Follow the AGENTS.md voice and do/don't rules.

READ_ORDER: AGENTS.md then sources.md then logic.md

Do not spawn specialists. Compile from connected files and any specialist reports already on disk. If none exist, Specialist attachments is none.

## Steps

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the report.
2. From sources.md, take rows with status connected. Read those files (or URLs / pastes / MCP as listed). Newest file in a bucket wins. Do not invent a source that is missing.
3. Pull the metrics in logic.md ## North star and ## Metrics I watch. Honor ## Exceptions and ## Overrides. If a watch metric's source is missing or unreadable, write `(not in the data)` for that metric.
4. Compute week-over-week change where you have both weeks. If you only have one week, say so — do not guess the prior week.
5. Write the report to `reports/weekly-report-YYYY-MM-DD.md` using today's date. Get the date from `date +%F` when a shell is available; otherwise use the date passed by the caller, or ask the operator. Do not guess a date.

## Report shape

```
# Weekly report → [WEEK ENDING DATE]

## The number that matters
[logic.md north star — the metric named there, with target/flag and direction vs last week. Not a generic revenue line.]

## What moved
[3-6 bullets from the watch list. Each: metric, value, change, one-line why if the data shows it.]

## What needs attention
[1-3 things trending the wrong way or breaking against logic.md flags. Operator framing, not alarm.]

## One decision for next week
[The single action the data argues for. Specific. Weekly must include north star, what moved, one decision (logic.md Brief).]

## Specialist attachments
[Paths of specialist reports already in reports/ for this week. None in this version if none exist.]

## Sources
[Connected files actually used, from sources.md path_or_url. Name each file. Do not list unused exports.]
```

## Rules

- Operator metrics only. No adjectives where a number works. No hype, no emojis.
- The number that matters is logic's north star, not a generic revenue line.
- Missing data is `(not in the data)` — never invented.
- One page. If it runs long, cut, do not summarize into mush.
- Sources footer lists connected files actually used. Every time.
- Do not edit `exports/`.
