# Install Amazon Operator OS

One sitting. Install Grok, open the business folder, run `/operator-setup`, drop your files, run `/prove`. Overnight is optional and last.

## 1. Install Grok CLI

macOS / Linux:

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
```

Verify:

```bash
grok --version
```

## 2. Authenticate xAI

```bash
grok login
```

Or launch `grok` once and complete browser login. For headless / CI, set `XAI_API_KEY` from [console.x.ai](https://console.x.ai) instead.

## 3. Open the kit folder

Unzip the kit (or clone the repo), then:

```bash
cd <path-to-amazon-operator-os>
# or, after setup creates it:
cd ~/Documents/<brand-slug>-ops
```

If you received a zip with agents already under `.grok/`, work from that unzipped folder. Plugin install is optional for updates:

```bash
grok plugin marketplace add <repo>
grok plugin install amazon-operator-os --trust
```

## 4. Run setup

From the business folder:

```text
/operator-setup
```

Answer the sources and logic interview in that same session. Setup writes `~/Documents/<brand-slug>-ops/` (or fills this folder) and prints your refresh card.

## 5. Drop your files

Follow the generated `reference/how-to-refresh.md` — only the sources you connected, not the full catalog in `docs/EXPORTS.md`. Newest file in each `exports/` bucket wins.

## 6. Prove

```text
/prove
```

Expect six dated artifacts under `reports/`. Missing data shows as `(not in the data)`. A watch metric with no source is named on the scoreboard; that does not fail `/prove`.

## 7. Overnight (optional, last)

Only after `/prove` is green. Run `/install-overnight` if you want a 5am local brief.

**Mac sleep warning:** a Mac that sleeps will miss the 5am run. Use an always-on Mac mini, disable sleep for that window, or skip overnight and run `/weekly` by hand. Windows overnight is out of v1.
