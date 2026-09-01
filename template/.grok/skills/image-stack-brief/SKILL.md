---
name: image-stack-brief
description: Write a brief-only Amazon secondary image stack (5–7 slots after the hero). Each slot gets role, copy, and art direction. Writes into reports/creative-brief-<asin>.md. Use when the creative agent runs, or the operator asks for an image-stack brief, carousel brief, or listing image strategy. Briefs only, not pixels.
when_to_use: When the creative agent runs, or the operator asks for an image-stack brief, carousel images strategy, or secondary listing-image direction.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# Image stack brief

Brief-only secondary image stack for an Amazon listing. Not a pixel pipeline. Do not call image APIs. Do not produce mockup files. Stop after role, copy, and art direction for each slot.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

This is the **Image stack** section of `reports/creative-brief-<asin>.md`. The creative agent combines it with `aplus-brief` in that same file.

## 1. Read wiring first

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.
2. From sources.md, take rows with status connected whose seat includes creative or listing. Newest file in a bucket wins. Do not invent a source that is missing.
3. A source with status missing is not demanded as a file. If listing facts are missing, write `(not in the data)` for that fact. Still write the artifact.
4. Read `reference/asins.md` for tags (`hero`, `launch`, `fbm`, `retired`) when that file has rows. Read `reference/brand.md` for voice, colors, and photography notes when that file has content.

## 2. Which ASIN

Same rule as Listing:

- Named ASIN if the operator gave one.
- Else the first ASIN in `reference/asins.md`.
- Else the first ASIN in the connected listings source.

Note the hero ASIN from logic.md. Hero is context, not a reason to skip the chosen ASIN.

Honor retired / do-not-report ASINs: omit them and take the next ASIN under the same rule.

## 3. Pull product facts

Read the connected listings source from `reference/sources.md`. If Amazon URL fetch fails, use the markdown pack (or catalog CSV). Do not fail the artifact.

Capture when present:

- Title, brand, category, variant, size/count, materials, specs
- Bullet claims (soften anything unsupported)
- Current secondary-image themes and gaps
- Review themes when a reviews source is connected
- Brand colors, type feel, photography style from `reference/brand.md` or the brand site if that URL is in sources

Facts not in those sources are `(not in the data)`. Never invent claims, dimensions, certifications, ingredients, compatibility, or guarantees.

Do not write SBV, Brand Store, or social-ad direction. This skill is listing secondary images only.

## 4. Build 5–7 secondary slots

Exclude the hero / main image. Default to **6** secondary slots. Use 5 if the product story is thin. Use 7 if one benefit, use case, or spec deserves its own frame.

Each slot is a 2000×2000 square (Amazon secondary spec). Copy must read on a phone.

Default arc — adapt when the category needs a sharper story:

| Slot | Default role |
|------|----------------|
| 02 | Primary benefit or problem / solution |
| 03 | Feature / spec breakdown |
| 04 | Lifestyle or use-case moment |
| 05 | Differentiation or comparison without naming competitors |
| 06 | Trust, materials, process, compatibility, or proof |
| 07 | Size, what's included, variants, directions, or buying confidence |

For 5 slots, merge the two weakest themes. For 7, split the strongest benefit, use case, or technical detail.

For every slot write all three:

- **Role** — the conversion job (what question it answers, why it sits here in the carousel)
- **Copy** — exact headline and short body. Headline 3–8 words. Body under 12 words. Mobile-first. No placeholder copy.
- **Art direction** — scene, product placement, lighting, mood, text placement, brand color use. Specific, not "lifestyle photo".

Stop. Do not call image APIs. Do not produce pixels, PNG/JPEG files, or mockup files. Do not write a prompt pack for an image API.

## 5. Copy and claims

- Use exact product facts from the listing, pack, brand.md, or brand site.
- Translate long bullets into short visual copy.
- Keep text large, sparse, and mobile-readable.
- No reviews, star ratings, ranking badges, discount language, warranties, or certification badges unless source-backed and allowed.
- No "cures", "prevents", "clinically proven", "guaranteed", or disease claims unless the operator explicitly requests and the source supports them.
- Do not name competitors on the image.

## 6. Save output

Write `reports/creative-brief-<asin>.md`. When the creative agent runs, this is one section of that combined file (with `aplus-brief`). Always write the file. Do not edit `exports/`. Do not push live changes to Amazon. Do not write into client folders.

### Artifact shape — Image stack section

```
## Image stack

[slot count, 5–7 secondary, hero excluded]

### Slot 02 — [role name]
- **Role:** [conversion job]
- **Copy:** [headline] / [body]
- **Art direction:** [scene, product, lighting, mood, text placement]

### Slot 03 — [role name]
...

### Slot 0N — [role name]
...
```

Sources footer lives once at the bottom of the combined file. Prefer a short table over a wall of prose. Operator metrics over adjectives. No hype, no emojis.
