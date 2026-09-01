---
name: amazon-qa-generator
description: Generate source-backed Amazon Q&A recommendations from a listing, ASIN, product source packet, reviews, current Q&A, spec sheet, target use cases, or competitor questions. Use when the operator asks for Amazon Q&A, customer questions, Rufus/Alexa Q&A, AI shopping questions, or listing FAQ content.
when_to_use: When the listing agent runs, or the operator asks for Amazon Q&A, Rufus questions, or listing FAQ content.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# Amazon Q&A Generator

Create seller-ready Q&A recommendations that answer real shopper questions and improve product clarity for humans and AI shopping assistants.

When run by the listing agent, this is the **Q&A holes** section of `reports/listing-audit-<asin>.md`. Full rewrites are not required in v1 — 5–10 recommended Q&As plus the hole list is enough. A 15–20 bank is optional if the operator asks.

If Amazon URL fetch fails, use the listing markdown pack (and connected reviews if present). Do not fail the artifact. Do not invent answers.

## Inputs

At least one:
- Amazon listing URL or ASIN
- Connected listings source (markdown pack or catalog)
- Product source packet, spec sheet, manual, packaging photos, or product page

Optional:
- Review export
- Current Q&A export
- Competitor questions
- Target use cases
- Target customer
- Brand voice notes

If product facts are too thin to answer safely, mark those Q&As as Needs source. Still write the artifact.

## Capture

When an Amazon URL or ASIN is provided:

1. Normalize ASINs to an Amazon product URL when needed.
2. Try a normal page/listing fetch first.
3. If the fetch is blocked, incomplete, or unreliable, use the markdown pack from the listings source. Do not stop. Do not bypass CAPTCHA, login prompts, bot checks, paywalls, access controls, or Amazon restrictions.
4. Use visible listing facts, current Q&A, review themes, product details, image text, and A+ sections when available.

Capture only what a normal session or the pack can show.

## Answer rules

- Answer the question directly in the first sentence.
- Use source-backed product facts.
- Keep most answers to 1-3 short sentences.
- Use natural buyer language, not keyword stuffing.
- Mention limitations clearly when they prevent returns or bad-fit purchases.
- Include exact sizes, materials, counts, compatibility, or care details when source-backed.
- Do not fake customer voice, reviews, testimonials, awards, or Amazon approval.
- Do not invent product facts.
- Medical, safety, compliance, or certification claims need exact source proof.
- "Yes" answers are wrong when the real answer is conditional.

## Workflow

1. Capture listing evidence first. On fetch failure, use the markdown pack.
2. Build a product fact base from listing, source packet, specs, packaging, manual, reviews, current Q&A, competitor questions, and brand site.
3. Identify recurring shopper doubts and AI-shopping-style natural-language questions.
4. Cover this mix (scale to 5–10 in v1, 15–20 if asked):
   - compatibility / fit
   - size / capacity / spec
   - material / ingredient / care
   - setup / use-case
   - durability / objection
   - variant / included components
   - comparison / value (do not name competitors unless the operator provides approved language)
   - gifting / occasion where relevant
5. Write concise, on-brand answers using source-backed facts only.
6. Mark any Q&A that needs source confirmation instead of inventing an answer.
7. Add recommended placement: public Q&A, bullets, A+ module, infographic, attribute/spec field.

## Output

Write into `reports/listing-audit-<asin>.md` under **Q&A holes**. Do not write a separate client-folder file.

```markdown
## Q&A holes

Strategy: [which buyer doubts this set answers]

| # | Question | Answer | Intent | Source | Confidence | Recommended Placement |
|---:|---|---|---|---|---|---|
| 1 | [question] | [answer] | [compatibility/use/etc.] | [source] | High/Medium/Needs source | [Q&A/A+/image/etc.] |

### Highest-value questions to add first

1. [question] - [why this matters]

### Needs source confirmation

| Question | Missing Fact Needed | Suggested Source |
|---|---|---|
| [question] | [fact] | [spec/photo/manual/etc.] |
```

Caveat: these are seller-drafted Q&A recommendations based on available product sources. They should be reviewed before publishing and should not be represented as customer-submitted content.

## When To Ask Questions

Ask only if:
- the answer would require unsupported facts and the operator is in an interactive session
- the product has regulated claims requiring legal/compliance review
- the operator wants exact brand voice but no brand examples exist

Do not block the listing artifact on a failed Amazon fetch.
