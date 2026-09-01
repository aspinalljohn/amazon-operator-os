---
name: amazon-ai-shopping-visibility-audit
description: Audit an Amazon ASIN or product source packet for AI shopping assistant visibility by generating natural-language buyer questions, scoring whether listing surfaces answer them, and recommending gap-closing copy. Use when the operator mentions Rufus, Alexa for Shopping, AI shopping visibility, conversational shopping, natural-language buyer questions, or listing gap audit.
when_to_use: When the listing agent runs, or the operator asks about Rufus, Alexa for Shopping, or AI shopping visibility.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# Amazon AI Shopping Visibility Audit

Audit an Amazon listing the way an AI shopping assistant-aware buyer would interrogate it: natural-language questions first, listing evidence second, gap recommendations third.

When run by the listing agent, this is the **AI-shopping / Rufus gaps** section of `reports/listing-audit-<asin>.md`. Full rewrites are not required in v1. Put recommended copy in the audit; do not write a separate rewrite pack unless the operator asks.

Use durable positioning:
- Preferred: AI shopping visibility, AI shopping assistant readiness, Rufus/Alexa for Shopping readiness.
- Avoid: guaranteed Rufus ranking, Rufus ranking score, direct Rufus interrogation, Amazon-approved optimization.

If Amazon URL fetch fails, use the listing markdown pack (and connected reviews if present). Do not fail the artifact.

## Inputs

At least one:
- Amazon listing URL or ASIN
- Connected listings source (markdown pack or catalog)
- Product source packet with title, bullets, A+ copy, specs, packaging, reviews, Q&A, or product photos

Optional:
- Product category
- Competitor ASINs or URLs
- Review export
- Q&A export
- Spec sheet or compliance sheet
- Brand/product website URL
- Target customer
- Price band
- Target use cases

If no listing, source packet, or product facts are available, write the section with `(not in the data)` and still produce the artifact. Otherwise proceed and document assumptions.

## Capture

When an Amazon URL or ASIN is provided:

1. Normalize ASINs to an Amazon product URL when needed.
2. Try a normal page/listing fetch first.
3. If the fetch is blocked, incomplete, or unreliable, use the markdown pack from the listings source. Do not stop. Do not bypass CAPTCHA, login prompts, bot checks, paywalls, access controls, or Amazon restrictions.
4. Capture these visible surfaces when available:
   - title, brand, price band, rating/review count
   - bullets/about-this-item
   - product details/spec tables
   - variation names and visible variant facts
   - main image and secondary image text/themes
   - A+ content sections visible on page
   - visible Q&A and review themes
   - storefront/brand link and any visible manufacturer details
5. Cite captured facts as `listing pack` or `page fetch` in output tables.

## Question taxonomy

Generate buyer-style natural-language questions from:

- Fit and user: "Is this good for [specific person/use case]?"
- Budget and value: "Best [product] under [price]?", "Is this worth it compared with [alternative]?"
- Compatibility: "Will this work with [model/system/context]?"
- Material and ingredient: "What is it made from?", "Is it [ingredient/material concern]?"
- Size and capacity: "Will this fit [space/body/item]?", "How many does it hold?"
- Setup and care: "Is it easy to install, clean, maintain, assemble, or store?"
- Durability and risk: "Will it last outdoors?", "Does it leak, fade, break, rust, pill, warp, or smell?"
- Use-case specifics: "Can I use this for [scenario]?"
- Comparison: "How is this different from [competitor/category alternative]?"
- Objection handling: "What should I know before buying?"
- Gifting and occasion: "Is this good as a gift for [person/occasion]?"
- Safety and compliance: "Is it safe for [child/pet/skin/food/contact]?" only when source-backed.

Prioritize questions that affect click or purchase confidence, expose common returns/negative reviews, reveal missing specs or compatibility, distinguish the product from close substitutes, match high-intent search behavior, and can be answered with source-backed product facts.

Avoid questions that require unsupported medical, legal, financial, or compliance claims.

## Workflow

1. Capture listing evidence first. On fetch failure, use the markdown pack.
2. Build the product fact base from available sources:
   - title, brand, category, price band, variant, size/count, materials/ingredients/specs
   - bullets, description, A+ content, current Q&A, review themes, image text if available
   - source-backed claims and unsupported/risky claims
3. Generate 20-30 natural-language buyer questions:
   - include fit/use-case questions, price/value questions, compatibility, material/ingredient, setup/care, durability, comparison, gifting, objections, and edge cases
   - include 5 high-intent long-tail prompts like "good for [specific user/use case] under [price]?"
4. Score answer coverage for each question across surfaces: Title, Bullets, Description/A+, Images/image text, Q&A, Reviews, Specs/attributes.
5. Score scale:
   - `3 = directly answered with clear source-backed detail`
   - `2 = partially answered or implied`
   - `1 = weak, scattered, or ambiguous`
   - `0 = not answered`
   - `N/A = not relevant to this product`
6. Identify the top 8-12 gaps that matter most commercially.
7. Recommend (not a full rewrite pack in v1):
   - title notes when applicable, not title stuffing
   - bullet notes
   - A+ module notes
   - Q&A additions
   - infographic callouts as append-only image expansion candidates
   - attribute/spec additions when source-backed
8. Add a demo-safe caveat:
   - This audit estimates AI shopping assistant readiness from visible/product-provided data. It does not access Amazon's proprietary models, ranking systems, or recommendation logic.

## Source-Backed Claim Rules

- Use only facts from listing, packaging, source packet, brand site, spec sheet, review/Q&A evidence, or operator-provided materials.
- Do not invent dimensions, materials, compatibility, certifications, ingredients, clinical proof, warranties, guarantees, awards, origin claims, or compliance attributes.
- For review-derived language, phrase as shopper perception or review theme, not as a guaranteed product fact.
- Flag regulated or risky claims instead of polishing them into stronger language.

## Image Callout Rules

Image and infographic callouts are recommendations for the image stack, not a replacement for its core structure.

- Treat callouts as optional expansion images that come after the core six-image stack.
- Rank callouts by commercial importance, source confidence, and whether the current image stack fails to answer the buyer question.
- Default to 1-3 strongest expansion candidates unless the operator requests more.
- Do not recommend image callouts for gaps better solved in bullets, Q&A, attributes, or A+ copy.
- Each callout must include the buyer question or gap it answers, source, confidence, suggested visual treatment, and claim-risk notes.

## Output

Write into `reports/listing-audit-<asin>.md` under **AI-shopping / Rufus gaps**. Do not write a separate client-folder file.

```markdown
## AI-shopping / Rufus gaps

[3-5 bullets on what the listing answers well, where AI-style shopper questions break down, and the highest-value fix.]

### Natural-language buyer questions

| # | Buyer Question | Intent | Current Answer Coverage | Priority |
|---:|---|---|---:|---|
| 1 | [question] | [fit/use/comparison/etc.] | [0-3/N/A] | High/Med/Low |

### Surface coverage

| Question | Title | Bullets | A+/Description | Images | Q&A | Reviews | Specs/Attributes | Gap |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| [question] | 0-3 | 0-3 | 0-3 | 0-3 | 0-3 | 0-3 | 0-3 | [gap] |

### Highest-value gaps

1. [Gap] - [why it matters commercially]

### Recommended copy (not a rewrite pack)

- Bullets / A+ / Q&A / attributes: source-backed notes only
- Image callouts: append-only candidates after the core stack
```

Caveat: this is an AI shopping visibility audit based on available listing and source data. It does not access Amazon's proprietary AI shopping assistant, ranking system, or recommendation logic.

## When To Ask Questions

Ask only if:
- no listing/source data is available and the operator is in an interactive session
- the product category is ambiguous and category materially changes the question set
- the operator asks for exact compliance/legal review
- the requested rewrite needs facts that are missing or unsupported

Do not block the listing artifact on a failed Amazon fetch.
