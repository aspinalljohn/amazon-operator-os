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
    if failures:
        print("FAIL")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
