---
name: review-intelligence
description: Rating mix, top 5 themes, 1-star/2-star clusters, listing implications, and 3 reply drafts from the connected reviews dump (csv or md). Writes reports/review-intelligence-YYYY-MM-DD.md and drafts/review-replies-YYYY-MM-DD.md. Use when the operator asks what customers are saying, for 1-star clusters, or for review reply drafts. Not a helpdesk.
when_to_use: When the customer agent runs, or the operator asks for review intelligence, 1-star clusters, listing implications from reviews, or reply drafts.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
---

# Review intelligence

Review intelligence, not a helpdesk. Do not write to Amazon. Do not edit `exports/`. Do not post review replies live. No review-reply API.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## 1. Read wiring first

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.
2. From sources.md, take rows with status connected whose seat includes customer, plus any source_id a watch metric with seat customer needs. Newest file in a bucket wins. Do not invent a source that is missing.
3. A source with status missing is not demanded as a file. If the reviews source is missing or unreadable, write `(not in the data)` for rating mix, themes, clusters, listing implications, and reply drafts. Still write both artifacts.
4. Read `reference/asins.md` for tags (`hero`, `launch`, `fbm`, `retired`) when that file has rows. Read `reference/brand.md` for voice on reply drafts.

## 2. Flags come from logic.md

Use logic.md customer / review flags. Their names, their numbers, their keywords.

Customer flags are:
- Any row in ## Metrics I watch whose seat includes `customer`
- Any watch metric named refund, review, rating, or 1-star (operator wording; match case-insensitively)
- ## Rules that name refund keywords, 1-star clusters, or review replies
- Refund keywords named in ## Rules, ## Metrics I watch, or ## Overrides

Honor ## Exceptions and ## Overrides before you cluster:
- Retired / do-not-report ASINs (`tag:retired` or named): omit them.
- Hero ASIN first when logic says so.
- Launch ASINs (`tag:launch` or named ASIN): still include their reviews. Note the tag. Do not skip a 1-star cluster because the ASIN is launch.

Skill-default refund keywords apply only when logic has no refund keywords: refund, broken, defective, chargeback, mold, leak.

## 3. Pull the connected reviews dump

**Reviews** (typical `exports/reviews/reviews.csv` or `exports/reviews/reviews.md`): per review — date, rating, ASIN or product name, body. Amazon has no clean Seller Central reviews export. Helium10 / Keepa / pasted last-90-day dump is the usual drop.

Accept type csv, md, paste, sheet, or url as sources.md lists it. Parse markdown dumps for star ratings, dates, ASIN tokens (`B0` plus alphanumerics), and review body. Do not require a sixth Amazon report.

If a connected file is unreadable or the wrong report, name the file and the expected columns (date, rating, ASIN or product name, body). Do not guess numbers. Do not invent reviews.

### Dates

If the dump has dates, report the min–max window and the review count in that window.

If the dump has no dates, say so. Write `this dump has no dates`. Do not invent review velocity. Do not invent a window.

### Rating mix

Count and share by 1, 2, 3, 4, 5 stars. Parse numeric ratings and text like `5 stars`. Unparseable ratings are a separate unknown bucket, not forced into 1–5.

If the reviews source is missing, rating mix is `(not in the data)`.

## 4. Themes, clusters, listing implications

**Top 5 themes.** Cluster review bodies by recurring praise or complaint. Rank by mention count. Each theme: name, count, one example quote, ASINs. Hero ASIN first when logic says so. Fewer than five distinct themes is fine — do not pad.

**1-star / 2-star clusters.** Group 1-star and 2-star reviews that share a complaint (same theme, same ASIN or across ASINs). A cluster is 2+ reviews. List singletons separately, one line. Call out refund-keyword hits. Example quote per cluster. If there are no 1-star or 2-star reviews, write none.

**Listing implications.** One line each. What to change on the listing or product from that theme or cluster (title, bullets, image, A+, attribute, or product fix). No multi-paragraph rewrite. No catalog push.

If the reviews source is missing, themes, clusters, and listing implications are `(not in the data)`.

## 5. Three reply drafts

Write exactly 3 reply drafts to `drafts/review-replies-YYYY-MM-DD.md`. Public Amazon review replies. Drafts only. Do not post.

Pick:
1. The worst 1-star / 2-star cluster (refund-keyword hit first when present).
2. A second negative or mixed review (3-star if no second 1-star/2-star).
3. A 5-star (or best remaining) thank-you.

If fewer than 3 distinct reviews exist, still write 3 drafts from what is in the dump. If the reviews source is missing, still write 3 draft slots, each `(not in the data)`.

Draft rules:
- Match `reference/brand.md` voice, else AGENTS.md: direct, no hype, no emojis, no exclamation marks.
- Thank, name the issue, invite a private message. Do not argue. Do not promise a refund, replacement, or coupon unless `reference/brand.md` or logic.md says the brand does that.
- Do not invent product facts.
- Keep each draft short.

## 6. Save output

Write `reports/review-intelligence-YYYY-MM-DD.md` and `drafts/review-replies-YYYY-MM-DD.md` (3 drafts) using today's date. Always write both files, even when the reviews source is missing. Do not edit `exports/`. Do not push live changes to Amazon. No review-reply API.

### Artifact shape — report

```
# Review intelligence → [DATE]

[defaults-not-reviewed line if logic.md is stamped that way]

## Rating mix
[count and share by 1–5 stars. Missing source → (not in the data).]

## Top 5 themes
[theme, count, example quote, ASINs. One line each. Or (not in the data).]

## 1-star / 2-star clusters
[cluster theme, ASINs, count, refund-keyword hit, example quote. Singletons one line. Or none / (not in the data).]

## Listing implications
[one line each: what to change on the listing or product. Or (not in the data).]

## Dates
[min–max window and count, or: this dump has no dates]

## Watch metrics missing a source
[metric and source_id, or none]

## Sources
[connected files actually used, from sources.md path_or_url]
```

### Artifact shape — drafts

```
# Review reply drafts → [DATE]

[defaults-not-reviewed line if logic.md is stamped that way]

## Draft 1 — [rating / cluster]
[reply text, or (not in the data)]

## Draft 2 — [rating / cluster]
[reply text, or (not in the data)]

## Draft 3 — [rating / cluster]
[reply text, or (not in the data)]

## Sources
[connected files actually used, from sources.md path_or_url]
```

Sources footer lists connected files actually used. Prefer a short table over a wall of prose. Operator metrics over adjectives. No hype, no emojis.
