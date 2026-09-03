# Changelog

Kit versioning follows `plugins/amazon-operator-os/plugin.json`. Buyers see the version in the zip's `plugin.json` / `.grok/`.

## [0.2.0] — unreleased (GTM prep)
### Changed
- **Default runtime is Grok Bot** (desktop app + cloud computer), not Grok Build CLI. Buyer folder is `/workspace/<brand>-ops/`.
- `/prove`, `/weekly`, and overnight run on Grok Bot without `.rhai` workflows; CLI workflow path is now the advanced fallback.
- Overnight scheduling defaults to a Grok Bot **Routine** (works on macOS, Windows, Linux) instead of macOS launchd.
- `scripts/build-zip.sh` ships buyer docs (`INSTALL`, `EXPORTS`, `WHAT-GOOD-LOOKS-LIKE`, `GROK-BUILD-ADVANCED`) inside the zip.
- `scripts/sync-template-grok.sh` copies commands/personas/workflows flat (previously nested `commands/commands/`).

### Added
- `docs/INSTALL.md` rewritten for Grok Bot on Mac, Windows, and Linux.
- `template/README.md` — brand-owner guide shipped in the zip.
- `template/reference/bot-roster.md` — six Bot names and skills to enable.
- `docs/GTM.md` — launch checklist, positioning, objection handling, roster decision.
- `docs/DRIVE-WALKTHROUGH.md` — recording script with screenshot beats and chapters.
- `docs/GROK-BUILD-ADVANCED.md` — optional local CLI + launchd path.
- `docs/SUPPORT.md` — support scope, refunds, response expectations.
- `/operator-setup` and `/install-overnight` slash commands.
- Composite `source_id` convention (`sales + ads-campaigns`) documented for TACOS.
- `template/bin/README.md` warning that `bin/` is CLI-only.
- `kit_check.py`: template/.grok byte-sync, Grok Bot language gates, bot-roster ↔ skills validation.

### Fixed
- Design spec no longer documents `--yolo` or a prompt file; matches `bin/overnight.sh` (`--always-approve`).
- Implementation plan stamped as partially superseded by the Grok Bot pivot.
- QA matrix rows rewritten to run on Grok Bot, with CLI equivalents noted.
- Fixture listings source type corrected to `paste`.

## [0.1.0]

- Initial six-seat kit: Ops, Listing, Ads, Inventory, Customer, Creative.
- `sources.md` + `logic.md` personalization; `/prove` six-artifact scoreboard.
- Northline Home fixtures, QA matrix, delivery SOP.
