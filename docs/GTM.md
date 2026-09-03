# GTM — Amazon Operator OS

Go-to-market checklist and positioning. Confirm price at checkout ($997 per design spec).

---

## Positioning (one sentence)

**Six Grok Bots that read your Amazon exports and write operator reports using your metrics — not a generic dashboard.**

---

## Who buys

- Amazon brand owner / operator ($1M–$20M, 3–30 SKUs)
- Already pulls Business Reports and ads CSVs
- Has or will get Grok Bot (SuperGrok / Cursor Pro+ tier)
- Wants a morning brief and exception artifacts, not an agency

## Who does not (say no early)

- Wants hands-off Seller Central API automation
- Will not drop weekly exports
- Expects image generation or live bid changes in v1
- Windows-only and refuses Grok Bot desktop app

---

## Should we add more Bots out of the box?

**No — ship six for v1 GTM.**

| Reason | Detail |
|---|---|
| Setup friction | Each Bot needs create + skill enable; seventh adds support calls |
| `/prove` contract | Six artifacts, six files, one scoreboard — clean pass/fail |
| Cost | Every `/prove` and `/weekly` runs up to six jobs |
| Overlap | Ops already routes ad-hoc questions; Finance/competitor questions do not need a seat yet |
| Overnight cap | Design caps at two specialists; more Bots does not help unattended runs |

### The six (keep)

| Bot | Job |
|---|---|
| Ops | Route, compile, setup, prove, weekly, overnight |
| Listing | Listing audit |
| Ads | PPC exceptions |
| Inventory | Cover / stockout |
| Customer | Reviews + reply drafts |
| Creative | Briefs only |

### v2 candidates (do not ship now)

| Candidate | When | Notes |
|---|---|---|
| **Finance** | P&L / unit economics seat | Needs COGS source; most brands lack clean margin CSV |
| **Competitor** | Share-of-voice / pricing | Needs external tool or scrape policy |
| **Compliance** | Policy / account health | Overlaps Ops flags; SP-API later |
| **Catalog** | Parent/child / variation fixes | Overlaps Listing; split only if listing audit too heavy |

**Optional v1.1 without a seventh Bot:** a **group chat** with all six (documented in `reference/bot-roster.md`) — visibility, not a new seat.

---

## Launch checklist

### Product

- [ ] `python3 tests/kit_check.py` → ok
- [ ] `bash scripts/build-zip.sh` → `dist/amazon-operator-os.zip`
- [ ] Live Grok Bot: six Bots, `/workspace/` deploy, `/prove` 6/6 on fixtures (see `docs/QA.md`)
- [ ] Drive walkthrough recorded (`docs/DRIVE-WALKTHROUGH.md`)
- [ ] Screenshot PDF or chapter markers uploaded

### Checkout / delivery

- [ ] Price confirmed ($997)
- [ ] Payment → auto or manual email template (`docs/DELIVER.md`)
- [ ] Zip + INSTALL + walkthrough link
- [ ] `amazon-operator-os-buyers-log.md` ready

### Support

- [ ] `docs/WHAT-GOOD-LOOKS-LIKE.md` internal bar
- [ ] Support reply: “send scoreboard + path to reports/”
- [ ] Boundary: green prove + logic looks like them — no custom skills

### Legal / IP

- [ ] Operator-generic skills only (no client brands in repo)
- [ ] Grok Bot / xAI terms — buyer brings own subscription

---

## Sales page bullets (copy-ready)

- Six named Grok Bots: Ops, Listing, Ads, Inventory, Customer, Creative
- Works with CSVs you already export — no Seller Central API in v1
- Your TACOS, cover days, and launch rules — not a generic ACOS template
- `/prove` ships six dated reports in one sitting
- Optional morning Routine on Grok Bot cloud (laptop can sleep)
- $997 self-serve kit + setup support to green `/prove`

**Not included:** image generation, live bid/catalog changes, agency done-for-you, Grok CLI required.

---

## Objection handling

| Objection | Response |
|---|---|
| “Is this Grok CLI?” | No — **Grok Bot** desktop app. Download at x.ai/bot. |
| “Do you log into Amazon?” | No. You drop exports; agents read files only. |
| “I only have three reports connected” | Fine — missing data is “(not in the data)”; prove still passes with six files. |
| “Can I add a Finance bot?” | Not in v1. Ops handles one-off questions; v2 may add a seat. |
| “Windows?” | Grok Bot runs on Windows. Overnight Routine runs in cloud. |
| “How much does Grok cost?” | Buyer’s Grok Bot / Cursor plan — separate from kit price. |

---

## Docs map (buyer-facing)

| Doc | Use |
|---|---|
| `template/README.md` | In zip — start here |
| `docs/INSTALL.md` | Platform install |
| `reference/bot-roster.md` | Six Bot names + skills |
| `docs/EXPORTS.md` | Export catalog |
| `docs/DRIVE-WALKTHROUGH.md` | Video script (you record) |
| `docs/GROK-BUILD-ADVANCED.md` | Power users only — do not lead with this |

---

## Post-launch metrics

Track in buyers log:

- Time to first `/prove`
- Artifacts 6/6 rate
- `defaults-not-reviewed` rate
- Overnight Routine adoption
- Support tickets per buyer (target: ≤1 through green prove)
