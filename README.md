# Amazon Operator OS

Private kit repo for Operator Intelligence: a Grok plugin plus business-folder template for Amazon brand operators.

## Docs

- Product spec: [`2026-09-01-amazon-operator-os-design.md`](./2026-09-01-amazon-operator-os-design.md)
- Implementation plan: [`2026-09-01-amazon-operator-os-implementation-plan.md`](./2026-09-01-amazon-operator-os-implementation-plan.md)
- Install guide: `INSTALL.md` (not written yet)

## Layout

- `.grok-plugin/` — marketplace metadata
- `plugins/amazon-operator-os/` — plugin source (agents, skills, workflows)
- `template/` — business-folder zip source (synced from the plugin via `scripts/sync-template-grok.sh`)
- `tests/kit_check.py` — pack invariants

## Checks

```bash
python3 tests/kit_check.py
```

Do not treat unbuilt slash commands or overnight flows as working until their tasks land.
