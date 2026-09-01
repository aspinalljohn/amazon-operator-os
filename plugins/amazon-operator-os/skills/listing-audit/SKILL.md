---
name: listing-audit
description: Run a full Amazon listing audit covering title, images, bullets, A+, attributes, Q&A holes, and AI-shopping gaps. Use when the operator asks to audit a listing, review an ASIN, or score a product page.
when_to_use: When the operator asks to audit a listing, review an ASIN, or score a product page.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# Amazon Listing Audit

Comprehensive audit of an Amazon product listing covering every conversion lever. Write one artifact. Do not push catalog changes.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Inputs

Parse:
- **ASIN** — named if given; else first ASIN in `reference/asins.md`; else first ASIN in the connected listings source
- **Primary keyword** (optional) — for competitive context
- **Depth** (optional) — "quick" (hero + title only) or "full" (default, everything)

Note the hero ASIN from logic.md. Hero is context, not a reason to skip the chosen ASIN.

## Step 1: Pull Listing Data

Read the connected listings source from `reference/sources.md`. Newest file in the bucket wins.

Research the ASIN to gather:
- Product title
- Brand name
- Category and subcategory
- Price and any variations
- BSR
- Review count and rating
- Number of images
- A+ content presence
- Brand Store presence
- Video presence

If Amazon URL fetch fails, use the markdown pack (or catalog CSV) from the listings source. Do not fail the artifact. Facts not in that pack are `(not in the data)`. Never invent them.

Also run, as sections of the same artifact:
- `amazon-title-compress` — 75-character title + 125-character Item Highlights recommendation
- `amazon-qa-generator` — Q&A holes (recommended questions, not a published bank)
- `amazon-attribute-fill-rate` — attribute holes from visible/source data
- `amazon-ai-shopping-visibility-audit` — AI-shopping / Rufus gaps

Full rewrites are not required in v1. Recommendations go in the audit. Do not write a separate rewrite pack unless the operator asks.

## Step 2: Title Audit

- [ ] Primary keyword in first 80 characters (mobile cutoff)
- [ ] Brand name present
- [ ] Key differentiator included
- [ ] Readable (not keyword-stuffed)
- [ ] Under 200 characters
- **Score:** /10

Include the 75-character compressed title and Item Highlights from `amazon-title-compress` under this section.

## Step 3: Hero Image Audit — 5-point mobile check

Score each criterion 1–5. Use this table. No external image-audit file is required.

| Criteria | Score (1-5) | Notes |
|----------|-------------|-------|
| Product fill (80-85% of frame) | | |
| Instant recognition (<1 sec on a phone) | | |
| Differentiation vs typical search-result neighbors | | |
| Visual hierarchy (product first, props second) | | |
| Emotional pull (why pick this one up) | | |
| **Total** | **/25** | |

If no image is in the pack, score `(not in the data)` and still write the table.

## Step 4: Image Stack Audit (Full Only)

For each image position (2-9):
- What type? (Infographic, lifestyle, scale, comparison, etc.)
- Does it answer a buyer question?
- Mobile readability?
- Visual consistency with hero?

| Position | Type | Purpose | Quality (1-5) |
|----------|------|---------|---------------|
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |
| 6 | | | |
| 7 | | | |
| 8 | | | |
| 9 | | | |

- **Missing opportunities:** [What image types are absent?]
- **Video:** Present? Quality?

## Step 5: Bullet Points Audit (Full Only)

- [ ] Lead with benefit, not feature
- [ ] Primary keywords naturally integrated
- [ ] Scannable — not walls of text
- [ ] Address top customer concerns/questions
- [ ] All 5 bullets used
- **Score:** /10

## Step 6: A+ Content Audit (Full Only)

- [ ] A+ content exists
- [ ] Module variety (not all text or all image)
- [ ] Cross-sell / brand story integration
- [ ] Mobile-optimized
- [ ] Keyword-rich (A+ is indexed)
- [ ] Comparison chart present
- **Score:** /10

## Step 7: Reviews & Social Proof

If a reviews source is connected, use it. If not, use what the listing pack or live page shows.

- Total reviews and rating
- Review velocity (recent reviews per month)
- Top positive themes
- Top negative themes (opportunities for improvement)
- Answered questions count

Missing numbers are `(not in the data)`.

## Step 8: Attributes, Q&A, AI-shopping

Fold the other four skills into these headings of the same file:

- **Attributes** — fill-rate / visible-data completeness, high-priority missing fields
- **Q&A holes** — unanswered shopper questions; 5–10 recommended Q&As is enough in v1
- **AI-shopping / Rufus gaps** — natural-language buyer questions the listing does not answer

## Step 9: Overall Assessment

| Element | Score | Priority |
|---------|-------|----------|
| Title | /10 | |
| Hero Image | /25 | |
| Image Stack | /50 | |
| Bullets | /10 | |
| A+ Content | /10 | |
| **Total** | **/105** | |

Rating scale:
- **85-105**: Optimized — fine-tune only
- **65-84**: Competitive — targeted improvements
- **45-64**: Below average — significant work needed
- **Below 45**: Critical — full rebuild

If a block is `(not in the data)`, omit it from the total and say which elements were scored.

## Step 10: Prioritized Action Plan

1. **Quick wins** (do this week): [highest impact, lowest effort]
2. **High impact** (do this month): [biggest CTR/CVR movers]
3. **Full optimization** (ongoing): [everything else]

Recommendations only. Do not produce full copy rewrites unless asked.

## Step 11: Save Output

Write `reports/listing-audit-<asin>.md`. Always write the file, even when the Amazon URL fetch failed or the pack is thin.

Do not write into client folders. Do not edit `exports/`. Do not push live changes to Amazon.

### Artifact shape

```
# Listing audit → [ASIN]

[defaults-not-reviewed line if logic.md is stamped that way]

## Title
## 75-character compression
## Hero image (5-point mobile check)
## Image stack
## Bullets
## A+
## Reviews and social proof
## Attributes
## Q&A holes
## AI-shopping / Rufus gaps
## Overall assessment
## Prioritized action plan
## Sources
```

Sources footer lists connected files actually used, from sources.md `path_or_url`.
