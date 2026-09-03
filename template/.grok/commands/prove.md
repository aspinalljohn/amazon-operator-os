Follow the operator-prove skill.

**Grok Bot (default):** Do not start a workflow. Run the five specialist seats — prefer `@Listing`, `@Ads`, `@Inventory`, `@Customer`, `@Creative` when those Bots exist, otherwise run each seat's skill from Ops. Then write the weekly report with weekly-operator-report. Print the two-line scoreboard.

**Grok Build CLI (advanced):** When the workflow tool is available, start the weekly-ops workflow with args.mode prove, today's date as YYYY-MM-DD, and agent_budget 8 instead of running seats yourself.

If the user said /prove --fixtures and `scripts/load-fixtures.sh` exists in this folder or the kit root, run it on cwd first. That script ships in the repo, not the buyer zip — skip this step when it is absent and say so.
