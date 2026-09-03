# Deliver Amazon Operator OS

John's fulfillment SOP. Same muscle as the Second Brain DIY Kit: Drive walkthrough, zip in email, optional GitHub invite, log the buyer.

SKU: Amazon Operator OS, self-serve kit, $997 (confirm at checkout).

You (John) do this. Buyers do not see this file as a homework list.

## After payment

1. **Share the Drive walkthrough** (record once, reuse).
2. **Email the zip** from john@goaspi.com.
3. **Optional GitHub invite** if they sent a username.
4. **Log the buyer** in `amazon-operator-os-buyers-log.md`.

Do not start custom skill work. Do not log into Seller Central for them.

## Drive walkthrough (outline)

One sitting. Camera on the kit folder, not a sales deck.

1. **Grok Bot install** — download from [x.ai/bot](https://x.ai/bot) (macOS / Windows / Linux), sign in with Cursor. Point at `docs/INSTALL.md`. **Do not** send buyers to Grok CLI unless they chose `docs/GROK-BUILD-ADVANCED.md`.
2. **Create six Bots** — Ops, Listing, Ads, Inventory, Customer, Creative. Enable kit skills under Settings → Plugins.
3. **Deploy kit** — unzip to `/workspace/<brand-slug>-ops/` on the Agent Computer (skills under `.grok/`). Plugin marketplace is optional.
4. **`/operator-setup` interview** — parent session only with Ops. Brand, sources, and logic in that same sitting. Do not send them to `/sources` and `/logic` as homework.
5. **Drop exports** — follow `reference/how-to-refresh.md`. One real export is enough to see the path.
6. **`/prove`** — six artifacts under `reports/` plus scoreboard. Compare to `docs/WHAT-GOOD-LOOKS-LIKE.md`.

Overnight is optional: `/install-overnight` creates a **Grok Bot Routine** (cloud, laptop can sleep). Test with `/overnight --now`. For launchd + CLI, see advanced doc only.

## Email the zip

From: **john@goaspi.com**

Attachment: `dist/amazon-operator-os.zip` built with `bash scripts/build-zip.sh` (syncs `template/.grok/` from the plugin, then zips `template/`).

Also attach or link: `docs/INSTALL.md` (Grok Bot app). Optional: `docs/GROK-BUILD-ADVANCED.md` for CLI power users only.

Subject line can be short: `Amazon Operator OS — zip + walkthrough`.

Body, keep it this thin:

- Drive walkthrough link.
- Unzip, create six Grok Bots, deploy to `/workspace/…`, Ops → `/operator-setup`, drop a file, `/prove`.
- Reply with the path to `reports/` if `/prove` is not 6/6.
- If they have a GitHub username, they will get an invite to `aspinalljohn/amazon-operator-os`.

## GitHub invite (optional)

Private repo: **aspinalljohn/amazon-operator-os**

Invite only if they asked or sent a username. Zip-only is the default self-serve path. Plugin updates:

```text
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

Do not make the repo public in v1.

## Log the buyer

Append one row to `amazon-operator-os-buyers-log.md` in this repo:

| column | what |
|---|---|
| date | payment / send date |
| email | the address you mailed |
| github | username or blank |
| zip sent | yes / date |
| prove green | blank until they reply 6/6 or you confirm |
| notes | Drive sent, invite sent, defaults-not-reviewed, etc. |

Do not put webhook URLs, xAI keys, or Seller Central logins in the log.

## What's in the box

- Zip of the business folder (`template/` + vendored `.grok/`)
- `docs/INSTALL.md`, `docs/EXPORTS.md` (catalog)
- Plugin / repo access if invited
- Six agents: ops, listing, ads, inventory, customer, creative
- `/operator-setup`, `/sources`, `/logic`, `/prove`, `/weekly`, `/install-overnight`, `/overnight --now`
- Optional overnight (`/install-overnight`, `/overnight --now`)

## What's not

- Image generation
- Seller Central login work
- Custom skill writing
- Claude Code dual install
- Windows overnight
- Advisory time
- Live catalog or campaign writes
- Required Slack/email (optional only)

## Support boundary

"I will get you to a green `/prove` on your files and a `logic.md` that looks like you."

After that: Operator Intelligence cohort or advisory. They edit `sources.md` / `logic.md` themselves. You do not write them a new skill because they watch TACOS instead of ACOS.

If `/prove` is not 6/6: they reply with the path to `reports/`. You read the scoreboard and the logic file. You do not rebuild the pack for one brand.

## IP

Operator-generic skills only. Do not ship Wood Defender, ProductPinion client labs, Velocity-branded PDFs, Higgsfield keys, or private MCP configs.
