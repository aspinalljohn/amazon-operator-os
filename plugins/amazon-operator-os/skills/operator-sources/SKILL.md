---
name: operator-sources
description: Interview the operator about what data they actually have and write reference/sources.md plus a one-page how-to-refresh.md. Use when the user runs /sources, says "add a source", "I have a new export", or during /operator-setup. Parent session only.
---

# Operator sources interview

PARENT SESSION ONLY. Do not call spawn_subagent. Do not start a workflow.

You are mapping what this operator already looks at onto a source registry. You are not forcing five Amazon CSVs.

## Catalog you may map onto

- sales → typically SC Business Report (Detail Page Sales and Traffic by Child Item) → exports/sales/
- ads-campaigns / ads-search-terms → SP campaign and search term reports → exports/ads/
- inventory → Inventory Planning or FBA Manage Inventory → exports/inventory/
- reviews → Helium10 / Keepa / paste (Amazon has no clean SC reviews export) → exports/reviews/
- listings → All Listings Report, markdown pack, or public Amazon URL → exports/listings/

They may also name a Google Sheet URL, an MCP server already connected, or a pasted dump. type is one of: csv | sheet | url | paste | mcp.

## Steps

1. If `reference/sources.md` already has rows with status connected, show the table and ask what to add/change. Do not wipe it.
2. Ask: "What numbers do you already look at, and where does each one live?" One cluster. Do not dump a 20-field form.
3. For each named source: have it now / skip / later. Skip writes status: missing.
4. For have-it-now: path relative to this folder, Sheet URL, paste target, or MCP server_id. If they want MCP and it is not connected, print a config.toml snippet and wait for "done", then ping once. Do not pretend it connected.
5. Write `reference/sources.md` with heading `# Sources` and the table columns: id, seat, type, path_or_url, freshness, status, how_i_get_it.
6. Write `reference/how-to-refresh.md` with this structure:

```markdown
# How to refresh

## Remember
These are **manual exports**, not Grok connections. You download from Seller Central / Ads / Helium10 and drop files here. Grok reads the folder — it does not log into Amazon.

## Your connected sources
(one bullet per connected row: id, drop path, how_i_get_it steps)

## Optional Grok-side (skip unless you need it)
- Grok CLI — 5am overnight on Mac only
- Slack/webhook — morning brief delivery only (reference/delivery.md)

## Full catalog
See EXPORTS.md for column shapes.
```

List ONLY connected sources in the middle section. Not the full catalog.
7. Show the table. Ask "Is this your stack?" Edit until they say yes.

Overnight and /prove read this file. Sources with status missing are not demanded as files.
