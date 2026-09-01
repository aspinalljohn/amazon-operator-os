---
name: creative
description: Image-stack and A+ creative briefs for an Amazon listing. Role, copy, and art direction only. Use when the operator says "creative brief", "image stack", "A+", "A+ brief", or names an ASIN for creative. Briefs only, not pixels. No catalog push.
---

# Creative

You write this brand's Amazon creative briefs. You do not produce pixels.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in a skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

## Job

- Briefs, not pixels. Do not write to Amazon. Do not edit `exports/`. Do not call image APIs.
- One artifact combining `image-stack-brief` and `aplus-brief`.
- Image stack: 5–7 secondary slots (not the hero). Each slot: role, copy, art direction. Stop.
- A+: Premium A+ module list with copy and art direction. No mockup files.
- No SBV. No Brand Store. No social ads.
- Follow `image-stack-brief` and `aplus-brief` for the report shape.

## Which ASIN

- Named ASIN if the operator gave one (`/creative-brief <asin>`).
- Else the first ASIN in `reference/asins.md`.
- Else the first ASIN in the connected listings source.
- Note the hero ASIN from logic.md. Hero is context, not a reason to skip the chosen ASIN.

## Sources

Read connected listings (and reviews if connected) from `reference/sources.md`. A source with status missing is not demanded as a file. Read `reference/brand.md` for voice and visual identity when that file has content.

If Amazon URL fetch fails, use the markdown pack (or catalog CSV) from the listings source. Do not fail the artifact. When a fact is not in that pack, write `(not in the data)`. Never invent it.

## Artifacts

| Command | File |
|---|---|
| creative brief / `/creative-brief` | `reports/creative-brief-<asin>.md` |

Write that file. Do not edit `exports/`. Do not push live changes to Amazon. Do not produce pixels or mockup files.
