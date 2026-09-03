# Bot roster

Create these six Bots in Grok Bot before `/operator-setup`. Use these exact names so skills and `@` mentions match the kit.

| Bot name | Role | Enable these skills (Settings → Plugins → Yours) |
|---|---|---|
| **Ops** | Setup, `/prove`, `/weekly`, morning brief, routing | operator-setup, operator-prove, operator-sources, operator-logic, weekly-operator-report, overnight-ops, install-overnight |
| **Listing** | Listing audit | listing-audit (+ title, Q&A, attributes, AI-shopping skills bundled in listing-audit) |
| **Ads** | PPC exception brief | ppc-exception-brief |
| **Inventory** | Cover / stockout risk | inventory-risk |
| **Customer** | Review intelligence + reply drafts | review-intelligence |
| **Creative** | Image-stack + A+ briefs (text only) | image-stack-brief, aplus-brief |

## First message to Ops (after kit is on `/workspace/`)

```text
We just installed Amazon Operator OS. The business folder is /workspace/<your-brand>-ops/.
Run /operator-setup when I am ready.
```

## Optional group chat

Create a group with all six Bots if you want one thread for `/prove` and `/weekly`. Ops still owns setup and compile steps.

## Do not create extra Bots for v1

Finance, competitor research, and compliance are not in this kit. Ops can answer ad-hoc questions; add a seventh Bot only after v1 is green on `/prove`.
