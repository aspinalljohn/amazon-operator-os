---
name: aplus-brief
description: Write an A+ content creative brief for an Amazon listing — module list, per-module type, dimensions, layout, copy, and art direction. Writes into reports/creative-brief-<asin>.md. Use when the creative agent runs, or the operator asks for A+, A+ brief, EBC, or enhanced brand content. Briefs only, not pixels.
when_to_use: When the creative agent runs, or the operator asks for an A+ brief, A+ content, EBC, or below-the-fold modules.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# A+ content brief

A+ creative brief for an Amazon listing. Not a pixel pipeline. Do not call image APIs. Do not produce mockup files. Specify modules, copy, and art direction, then stop.

READ_ORDER: AGENTS.md then sources.md then logic.md

Before any analysis or artifact, read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`. Their metrics, flags, exceptions, and brief contents win over any default in this skill. If logic.md is stamped `defaults-not-reviewed`, say so at the top of the artifact.

This is the **A+** section of `reports/creative-brief-<asin>.md`. The creative agent combines it with `image-stack-brief` in that same file.

## 1. Read wiring first

1. Read `AGENTS.md`, then `reference/sources.md`, then `reference/logic.md`.
2. From sources.md, take rows with status connected whose seat includes creative or listing. Newest file in a bucket wins. Do not invent a source that is missing.
3. A source with status missing is not demanded as a file. If listing or brand facts are missing, write `(not in the data)` for that fact. Still write the artifact.
4. Read `reference/asins.md` for tags when that file has rows. Read `reference/brand.md` for voice, colors, type, and tagline when that file has content.

## 2. Which ASIN

Same rule as Listing:

- Named ASIN if the operator gave one.
- Else the first ASIN in `reference/asins.md`.
- Else the first ASIN in the connected listings source.

Note the hero ASIN from logic.md. Hero is context, not a reason to skip the chosen ASIN.

Honor retired / do-not-report ASINs: omit them and take the next ASIN under the same rule.

Do not interview for a client roster. Brand name comes from `AGENTS.md` / `reference/brand.md`. Do not write into a client folder.

## 3. Research

Do this before writing modules.

**Product.** Fetch the Amazon listing when a URL or ASIN is available. Extract title, bullets, price band, features, materials, current A+ status, category, review themes (from the connected reviews source when present), certifications or unique claims that are source-backed. If Amazon URL fetch fails, use the markdown pack (or catalog CSV). Do not fail the artifact.

**Brand.** From `reference/brand.md` and a brand-site URL if sources.md has one: voice, colors, type, tagline, photography style. Missing hex codes or fonts are `(not in the data)`. Do not invent a palette.

**Competitors.** If the operator named 2–3 competitor ASINs, use those. Else, if fetch works, note 2–3 category leaders' A+ patterns. If neither is available, competitive landscape is `(not in the data)`.

**Current A+.** If screenshots or live A+ are in the pack, assess module by module. If none, say no current A+ in the data.

Facts not in those sources are `(not in the data)`. Never invent claims.

Do not write SBV, Brand Store, or social-ad direction.

## 4. Module selection

Judgment, not a fixed template. 5–7 modules is the sweet spot. Last module almost always cross-sells.

Always include a **Premium A+ module list** with copy and art direction. If Brand Registry / Premium eligibility is unknown, still write the Premium list and mark eligibility `(not in the data)`.

### Standard A+ modules

| Module Type | Dimensions | Best For |
|-------------|-----------|----------|
| Standard Image Header with Text | 970 × 600 px | Hero banner — brand + lead USP |
| Standard Image & Text Overlay | 970 × 300 px | Feature highlights, image + baked-in text |
| Standard Comparison Chart | 970 × variable | Variant comparison (size, model, lineup) |
| Standard Four Image & Text | 220 × 220 px each (4 images) | Feature grid — icons + short descriptions |
| Standard Single Image & Sidebar | 300 × 400 px (image) + text | Detailed feature with longer copy |
| Standard Three Image & Text | 300 × 300 px each (3 images) | Three-column feature or use-case |
| Standard Image & Light Text Overlay | 970 × 300 px | Subtle text over lifestyle imagery |
| Standard Technical Specifications | Table format | Spec-heavy products |

### Premium A+ modules (Brand Registry + eligibility)

| Module Type | Dimensions | Best For |
|-------------|-----------|----------|
| Premium Video | 970 × 546 px (16:9) | Product demo, brand story, how-to — brief the video, do not produce it |
| Premium Comparison Table | 970 × variable | Detailed multi-ASIN comparison |
| Premium Image Carousel | 970 × 600 px per slide | Multiple lifestyle / feature angles |
| Premium Hotspot Module | 970 × 600 px | Interactive feature callouts |
| Premium Q&A Module | Text-based | Address top customer questions |
| Premium Navigation Carousel | 970 × 600 px | Cross-sell to other products |

Choose modules by conversion job:

- Shopper does not understand the product → lead with clear feature modules.
- Shopper understands but is not convinced → social proof and lifestyle.
- Shopper is comparing options → comparison chart.
- Mobile is the default. Full-width baked-in text must read small. Avoid tiny type in complex layouts.
- Cross-sell last.

## 5. Copy rules

A+ copy is not listing bullets:

- **Headlines:** 3–8 words. Benefit-first. "Drawers That Stay Organized" not "Expandable Bamboo Utensil Tray".
- **Body:** Under 25 words per module. One idea per module. Split if you need more words.
- **Exact copy, not placeholders.** Write the headline and body.
- **Tone from brand.md.** If brand.md is empty, match the listing voice: direct, no hype, no emojis.
- All display text is baked into the module art. Do not rely on Amazon text fields.

## 6. Save output

Write `reports/creative-brief-<asin>.md`. When the creative agent runs, this is one section of that combined file (with `image-stack-brief`). Always write the file. Do not edit `exports/`. Do not push live changes to Amazon. Do not write into client folders. Do not call image APIs. Do not produce mockup files.

### Artifact shape — A+ section

```
## A+

**Module type:** [Standard / Premium / Mix]
**Total modules:** [N]
**Premium eligibility:** [yes / no / (not in the data)]

### Brand identity

| Element | Value |
|---------|-------|
| Primary color | [hex or (not in the data)] |
| Secondary color | |
| Accent | |
| Dark / text | |
| Light background | |
| Font | |
| Tagline | |
| Trust line | |
| Logo | |

### Competitive landscape
[2–3 paragraphs, or (not in the data)]

### Current A+
[module-by-module, or no current A+ in the data]

### Template architecture

| Module | Amazon module type | Dimensions | Purpose |
|--------|-------------------|------------|---------|
| M1 | | | |
| ... | | | |

### Premium A+ module list

| Module | Premium type | Dimensions | Purpose |
|--------|----------------|------------|---------|
| P1 | | | |
| ... | | | |

### Module specs

### M[N] — [name] ([dimensions])

**Layout:** [composition]
**Copy:**
- Headline: [exact]
- Body: [exact, under 25 words]
**Art direction:** [scene, product, lighting, mood, type treatment]
**Design notes:** [mobile readability, color, execution]

(repeat for each Standard module, then each Premium module with copy and art direction)

### Design execution checklist

- [ ] All text baked into the module art — no Amazon text fields
- [ ] Exported at the spec dimensions
- [ ] RGB, 72 DPI, JPEG or PNG, under 2 MB
- [ ] Text readable at mobile scale (test at 50% zoom)
- [ ] Brand logo on M1
- [ ] Brand colors consistent
- [ ] No competitor names or logos
- [ ] No pricing, promotions, or time-sensitive claims
- [ ] No unsubstantiated superlatives
- [ ] All claims verifiable

### Amazon A+ compliance

- [ ] No URLs, QR codes, or external links
- [ ] No customer review quotes or star ratings
- [ ] No warranty details that contradict the listing
- [ ] No "Amazon's Choice" or "Best Seller" claims
- [ ] No "new" claims
- [ ] No borders that double Amazon's layout border
```

Sources footer lives once at the bottom of the combined file. Prefer a short table over a wall of prose. Operator metrics over adjectives. No hype, no emojis.

## Combined file shape (creative agent)

The creative agent writes one file:

```
# Creative brief → [ASIN]

[defaults-not-reviewed line if logic.md is stamped that way]

## Image stack
[from image-stack-brief — 5–7 secondary slots, each role / copy / art direction]

## A+
[from this skill — Premium A+ module list with copy and art direction]

## Sources
[connected files actually used, from sources.md path_or_url]
```
