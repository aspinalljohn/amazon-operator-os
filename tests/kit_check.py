#!/usr/bin/env python3
"""Pack invariants for Amazon Operator OS. Run from repo root: python3 tests/kit_check.py"""
from __future__ import annotations
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins" / "amazon-operator-os"
TEMPLATE = ROOT / "template"
FIXTURES = ROOT / "fixtures"
PREAMBLE = "READ_ORDER: AGENTS.md then sources.md then logic.md"
failures: list[str] = []


def fail(msg: str) -> None:
    failures.append(msg)


def require(path: Path, msg: str | None = None) -> None:
    if not path.exists():
        fail(msg or f"missing {path.relative_to(ROOT)}")


def main() -> int:
    require(ROOT / ".grok-plugin" / "marketplace.json")
    require(PLUGIN / "plugin.json")
    mp = ROOT / ".grok-plugin" / "marketplace.json"
    if mp.exists():
        data = json.loads(mp.read_text())
        names = [p.get("name") for p in data.get("plugins", [])]
        if "amazon-operator-os" not in names:
            fail("marketplace.json must list plugin amazon-operator-os")
    for rel in [
        "template/AGENTS.md",
        "template/exports/sales/README.md",
        "template/exports/ads/README.md",
        "template/exports/inventory/README.md",
        "template/exports/reviews/README.md",
        "template/exports/listings/README.md",
        "template/reference/brand.md",
        "template/reference/asins.md",
        "template/reference/sources.md",
        "template/reference/logic.md",
        "template/reference/how-to-refresh.md",
        "template/reference/delivery.md",
        "docs/INSTALL.md",
        "docs/EXPORTS.md",
    ]:
        require(ROOT / rel)
    sources = (TEMPLATE / "reference" / "sources.md").read_text() if (TEMPLATE / "reference" / "sources.md").exists() else ""
    if "# Sources" not in sources:
        fail("template/reference/sources.md must start with a # Sources heading")
    logic = (TEMPLATE / "reference" / "logic.md").read_text() if (TEMPLATE / "reference" / "logic.md").exists() else ""
    if "# Operating logic" not in logic:
        fail("template/reference/logic.md must start with # Operating logic")
    for name in ["operator-setup", "operator-sources", "operator-logic"]:
        p = PLUGIN / "skills" / name / "SKILL.md"
        require(p)
        if p.exists():
            text = p.read_text()
            if name == "operator-setup" and "spawn_subagent" not in text:
                fail("operator-setup must explicitly forbid spawn_subagent")
            if "parent session" not in text.lower() and "parent/ops" not in text.lower() and "PARENT" not in text:
                fail(f"{name} must say it runs in the parent session")
    if failures:
        print("FAIL")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
