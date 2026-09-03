Run the weekly operator rhythm. Same fan-out as /prove, dated for this week.

**Grok Bot (default):** Do not start a workflow. Run the five specialist seats — prefer `@Listing`, `@Ads`, `@Inventory`, `@Customer`, `@Creative` when those Bots exist, otherwise run each seat's skill from Ops. Then follow weekly-operator-report and write `reports/weekly-report-YYYY-MM-DD.md`.

**Grok Build CLI (advanced):** When the workflow tool is available, run the weekly-ops workflow with args.mode weekly, agent_budget 8. Prefer name weekly-ops or script_path .grok/workflows/weekly-ops.rhai; if folder trust refuses the path, pass the script inline.

Pass today's date as YYYY-MM-DD (workflows cannot call timestamp()). Optional ASIN from the user, else first in reference/asins.md, else first listing ASIN. Remind the operator to refresh exports before the run.
