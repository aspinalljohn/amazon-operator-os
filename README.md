# Amazon Operator OS

Private kit repo for Operator Intelligence: a Grok plugin plus business-folder template for Amazon brand operators.

## Docs

- Product spec: [`2026-09-01-amazon-operator-os-design.md`](./2026-09-01-amazon-operator-os-design.md)
- Implementation plan: [`2026-09-01-amazon-operator-os-implementation-plan.md`](./2026-09-01-amazon-operator-os-implementation-plan.md)
- Install guide: [`docs/INSTALL.md`](./docs/INSTALL.md)
- QA matrix: [`docs/QA.md`](./docs/QA.md)
- Fulfillment SOP: [`docs/DELIVER.md`](./docs/DELIVER.md)
- Support bar: [`docs/WHAT-GOOD-LOOKS-LIKE.md`](./docs/WHAT-GOOD-LOOKS-LIKE.md)

## Layout

- `.grok-plugin/` — marketplace metadata
- `plugins/amazon-operator-os/` — plugin source (agents, skills, workflows, commands)
- `template/` — business-folder zip source (synced from the plugin via `scripts/sync-template-grok.sh`)
- `tests/kit_check.py` — pack invariants

## Build and checks

```bash
python3 tests/kit_check.py
bash scripts/sync-template-grok.sh   # refresh template/.grok from plugin
bash scripts/build-zip.sh            # sync + dist/amazon-operator-os.zip
```
