---
name: amazon-attribute-fill-rate
description: Audit Amazon product attribute completeness from public listing data plus optional Seller Central exports, flat files, category templates, spec sheets, packaging photos, or source packets, then draft missing attribute values from source-backed facts only.
when_to_use: When the listing agent runs, or the operator asks about attribute fill-rate, missing backend fields, or visible spec completeness.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
---

# Amazon Attribute Fill-Rate

Audit the visible and uploaded product data that AI shopping assistants, Amazon browsing systems, and shoppers may rely on. This v1 skill is upload/export assisted: it can estimate visible-data completeness from public listings, but true backend fill-rate requires a Seller Central/category export, flat file, or category template.

When run by the listing agent, this is the **Attributes** section of `reports/listing-audit-<asin>.md`. Full rewrites are not required in v1. Draft values stay in the audit table. Do not write a separate CSV unless the operator asks.

If Amazon URL fetch fails, use the listing markdown pack. Do not fail the artifact.

## Inputs

At least one:
- Amazon listing URL or ASIN
- Connected listings source (markdown pack or catalog)
- Seller Central category listing report, flat file, or browse tree/category template
- Product source packet, spec sheet, packaging photos, or product manual

Optional:
- Product category
- Brand/product website URL
- Existing attribute export CSV/XLSX
- Competitor ASINs for visible attribute comparison

If no data is available, produce the section with `(not in the data)` and still write the artifact. If only public listing data is available, produce a visible-data completeness audit and clearly state that true backend fill-rate cannot be calculated.

## Capture

When an Amazon URL or ASIN is provided:

1. Normalize ASINs to an Amazon product URL when needed.
2. Try a normal page/listing fetch first.
3. If the fetch is blocked, incomplete, or unreliable, use the markdown pack from the listings source. Do not stop. Do not bypass CAPTCHA, login prompts, bot checks, paywalls, access controls, or Amazon restrictions.
4. Use browser/page capture for visible-data completeness only. True backend fill-rate still requires Seller Central/category export data.

## Fields to audit

Use category-specific templates when provided. Otherwise start with these common fields and adapt conservatively.

Common fields:
- Brand
- Product type/category
- Model number or part number
- Parent/child variation theme
- Color
- Size
- Count/quantity
- Unit count and unit count type
- Dimensions
- Weight
- Material
- Ingredients
- Scent/flavor
- Compatibility
- Included components
- Power source
- Battery details
- Care instructions
- Directions for use
- Age range
- Target gender/audience where category-relevant
- Safety warning
- Country/region of origin
- Warranty/support where source-backed
- Certifications/compliance marks where source-backed

High-priority AI shopping fields (fit, compatibility, size/capacity, material/ingredient, setup/care, use-case suitability, included/not included, safety/compliance, variant differences).

Status definitions:
- Populated: clear value exists in export/listing/source.
- Missing: expected field is blank.
- Weak/ambiguous: value exists but is vague, incomplete, or contradicted.
- Unsupported: requested value lacks source proof.
- Not applicable: field does not apply to this product/category.

## Workflow

1. Capture listing evidence first. On fetch failure, use the markdown pack.
2. Determine audit mode:
   - `Backend fill-rate` if Seller Central/category export or flat file is provided.
   - `Visible-data completeness` if only public listing/source data is available.
3. Build the product fact base from listing, exports, source packet, spec sheet, packaging, brand site, and manual.
4. Identify expected attributes for the category using the field list above and any provided category template.
5. Classify each attribute: Populated / Missing / Weak/ambiguous / Unsupported / Not applicable.
6. Draft missing values only from source-backed facts.
7. Leave unsupported values blank with a note describing what source is required.
8. Calculate backend fill-rate when export data exists, or a visible-data completeness estimate when only listing/source data exists.

## Source-Backed Claim Rules

- Never invent dimensions, materials, compatibility, certifications, ingredients, compliance attributes, medical claims, safety claims, age ranges, country of origin, warranty, or included components.
- Use exact units from source where possible.
- Do not infer regulated attributes from marketing language.
- If a value is likely but not proven, mark it `Needs source` and do not put it in the draft value field.

## Output

Write into `reports/listing-audit-<asin>.md` under **Attributes**. Do not write a separate client-folder file.

```markdown
## Attributes

Audit mode: [Backend fill-rate / Visible-data completeness]
Fill-rate / completeness: [percentage or estimate]
High-priority missing fields: [count]
Weak or ambiguous fields: [count]
Unsupported fields requiring source: [count]

| Attribute | Current Value | Draft Value | Status | Source | Confidence | Notes |
|---|---|---|---|---|---|---|
| [attribute] | [value] | [value] | [status] | [source] | High/Medium/Low | [notes] |

### Highest-priority fixes

1. [attribute] - [why it matters for shoppers/AI shopping clarity]

### Missing source requests

- [specific source needed to safely fill missing attribute]
```

True backend fill-rate requires Seller Central/category export data. Without that, this section estimates visible product-data completeness from public and provided sources.

## When To Ask Questions

Ask only if:
- the category is unknown and materially changes the attribute set
- a requested draft value requires missing source proof
- the operator expects a true fill-rate but no export/template is provided

Do not block the listing artifact on a failed Amazon fetch.
