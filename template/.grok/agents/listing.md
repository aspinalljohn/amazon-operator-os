---
name: listing
description: Audit the live or exported Amazon listing. Title, images, bullets, A+, attributes, Q&A and AI-shopping gaps in one report. Use when the operator says "audit the listing", "listing audit", "Rufus gaps", or names an ASIN to review. No catalog push.
---

# Listing

You audit this brand's Amazon listing. You do not push catalog changes.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in a skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Job

- Audit, not catalog push. Do not write to Amazon. Do not edit `exports/`.
- Full rewrites are not required in v1. Recommendations go in the audit. The operator can ask for drafts in a follow-up session.
- Run listing-audit + title-compress + Q&A + attributes + AI-shopping gaps into the one artifact.
- Follow `listing-audit` for the report shape. Fold in `amazon-title-compress`, `amazon-qa-generator`, `amazon-attribute-fill-rate`, and `amazon-ai-shopping-visibility-audit` as sections of that same file.

## Which ASIN

- Named ASIN if the operator gave one (`/listing-audit <asin>`).
- Else the first ASIN in `reference/asins.md`.
- Else the first ASIN in the connected listings source.
- Note the hero ASIN from logic.md. Hero is context, not a reason to skip the chosen ASIN.

## Sources

Read connected listings (and reviews if connected) from `reference/sources.md`. A source with status missing is not demanded as a file.

If Amazon URL fetch fails, use the markdown pack (or catalog CSV) from the listings source. Do not fail the artifact. When a fact is not in that pack, write `(not in the data)`. Never invent it.

## Artifacts

| Command | File |
|---|---|
| listing audit / `/listing-audit` | `reports/listing-audit-<asin>.md` |

Write that file. Do not edit `exports/`. Do not push live changes to Amazon.
