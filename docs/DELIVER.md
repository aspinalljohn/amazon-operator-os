# Deliver Amazon Operator OS

John's fulfillment SOP. Same muscle as the Second Brain DIY Kit: Drive walkthrough, zip in email, optional GitHub invite, log the buyer.

SKU: Amazon Operator OS, self-serve kit, **$997** (confirm at checkout).

GTM checklist: [`docs/GTM.md`](./GTM.md). Full recording script: [`docs/DRIVE-WALKTHROUGH.md`](./DRIVE-WALKTHROUGH.md).

You (John) do this. Buyers do not see this file as a homework list.

---

## After payment

1. **Share the Drive walkthrough** (record once using `docs/DRIVE-WALKTHROUGH.md`).
2. **Email the zip** from john@goaspi.com.
3. **Optional GitHub invite** if they sent a username.
4. **Log the buyer** in `amazon-operator-os-buyers-log.md`.

Do not start custom skill work. Do not log into Seller Central for them.

---

## Drive walkthrough

**Record:** 25–35 min screen capture of **Grok Bot** (not terminal). Script with screenshot moments: [`docs/DRIVE-WALKTHROUGH.md`](./DRIVE-WALKTHROUGH.md).

### Chapter markers (YouTube / Drive chapters)

| Time | Title |
|---|---|
| 0:00 | What Amazon Operator OS is |
| 2:00 | Install Grok Bot (Mac / Win / Linux) |
| 6:00 | Create six Bots + enable skills |
| 12:00 | Deploy kit to `/workspace/…` |
| 17:00 | `/operator-setup` interview |
| 23:00 | Drop an export |
| 26:00 | `/prove` — six artifacts |
| 31:00 | Weekly + overnight Routine (optional) |

### Six Bots — show on screen

Create these **exact names** before setup (see `template/reference/bot-roster.md`):

| Bot | One-line description for profile |
|---|---|
| **Ops** | Setup, weekly, morning brief, routing |
| **Listing** | Listing audits |
| **Ads** | PPC exception brief — flags only |
| **Inventory** | Cover / stockout risk |
| **Customer** | Review themes + reply drafts |
| **Creative** | Image-stack + A+ briefs (text only) |

**Screenshot beats:** sidebar with six Bots → Plugins enabled for Ops → `/workspace/brand-ops/` tree → six files in `reports/`.

**Say explicitly:** “Do not install Grok CLI. Download the **Grok Bot app** at x.ai/bot.”

### Walkthrough flow (short)

1. Install Grok Bot → sign in with Cursor → Agent Computer ready.
2. Create six Bots → enable kit skills per `bot-roster.md`.
3. Deploy zip → `/workspace/<brand>-ops/` on cloud computer.
4. Ops → `/operator-setup` (one sitting).
5. Drop one export → `/prove` → six artifacts.
6. Optional: `/install-overnight` + `/overnight --now`.

---

## Email the zip

**From:** john@goaspi.com

**Attachment:** `dist/amazon-operator-os.zip` (`bash scripts/build-zip.sh`)

**Also include:**

- Link to Drive walkthrough
- [`docs/INSTALL.md`](./INSTALL.md) (or PDF export)
- Do **not** attach `GROK-BUILD-ADVANCED.md` unless they ask for CLI

**Subject:** `Amazon Operator OS — kit + walkthrough`

**Body template:**

```text
Hi — here's your Amazon Operator OS kit.

1. Watch the walkthrough first (link): install Grok Bot from https://x.ai/bot — not Grok CLI.
2. Unzip the attached folder.
3. In Grok Bot, create six Bots: Ops, Listing, Ads, Inventory, Customer, Creative (names matter).
4. Ask Ops to copy the folder to /workspace/<your-brand>-ops/ on your cloud computer.
5. Run /operator-setup in Ops, drop one Seller Central export, run /prove.

Install guide (Mac / Windows / Linux): [link or attach INSTALL.md]

Reply with your two-line /prove scoreboard and the path to reports/ if you are not 6/6.

GitHub invite: [if applicable]

— John
```

---

## GitHub invite (optional)

Private repo: **aspinalljohn/amazon-operator-os**

Invite only if they asked or sent a username. Zip-only is the default self-serve path.

Plugin updates (Grok Build advanced — mention only if they use CLI):

```text
grok plugin marketplace add aspinalljohn/amazon-operator-os
grok plugin install amazon-operator-os --trust
```

Do not make the repo public in v1.

---

## Log the buyer

Append one row to `amazon-operator-os-buyers-log.md`:

| column | what |
|---|---|
| date | payment / send date |
| email | the address you mailed |
| github | username or blank |
| zip sent | yes / date |
| walkthrough sent | yes / link |
| prove green | blank until 6/6 |
| notes | Bots created, defaults-not-reviewed, Routine, etc. |

Never log webhook URLs, xAI keys, or Seller Central logins.

---

## What's in the box

- Zip: business folder + vendored `.grok/` skills and agents
- Six Grok Bots (buyer creates in app): Ops, Listing, Ads, Inventory, Customer, Creative
- `reference/bot-roster.md` — names and skill enable list
- Commands: `/operator-setup`, `/prove`, `/weekly`, `/sources`, `/logic`, `/install-overnight`, `/overnight --now`
- Docs: INSTALL, EXPORTS, README in folder

## What's not

- Seventh Bot (Finance, Competitor, etc.) — v2; see `docs/GTM.md`
- Image generation, live catalog/bid changes, SC login work
- Custom skill writing, Grok CLI as default install
- Required Slack/email (optional delivery only)

---

## Support boundary

"I will get you to a green `/prove` on your files and a `logic.md` that looks like you."

After that: Operator Intelligence cohort or advisory. They edit `sources.md` / `logic.md` themselves.

If `/prove` is not 6/6: they reply with scoreboard + `reports/` path. You do not rebuild the pack for one brand.

---

## IP

Operator-generic skills only. No Wood Defender, Velocity client paths, ProductPinion labs, or private MCP configs.
