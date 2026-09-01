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
    import csv
    require(FIXTURES / "logic.md")
    if (FIXTURES / "logic.md").exists():
        lt = (FIXTURES / "logic.md").read_text()
        if "TACOS" not in lt:
            fail("fixture logic.md must use TACOS as a watch metric so we catch ACOS-default bugs")
        if "defaults-not-reviewed" in lt:
            fail("fixture logic.md must be a reviewed example, not defaults")
    sales = FIXTURES / "sales" / "business-report.csv"
    require(sales)
    if sales.exists():
        rows = list(csv.DictReader(sales.open()))
        if len(rows) < 6:
            fail("sales fixture needs at least 6 child ASIN rows")
        for col in ["(Child) ASIN", "Sessions", "Units Ordered", "Ordered Product Sales", "Conversion Rate"]:
            if col not in (rows[0] if rows else {}):
                fail(f"sales fixture missing column {col}")
    ops = PLUGIN / "agents" / "ops.md"
    require(ops)
    if ops.exists() and PREAMBLE not in ops.read_text():
        fail("ops.md missing READ_ORDER preamble")
    listing = PLUGIN / "agents" / "listing.md"
    require(listing)
    if listing.exists():
        listing_text = listing.read_text()
        if PREAMBLE not in listing_text:
            fail("listing.md missing READ_ORDER preamble")
        if "reports/listing-audit-" not in listing_text:
            fail("listing.md missing artifact path string reports/listing-audit-")
    la_path = PLUGIN / "skills" / "listing-audit" / "SKILL.md"
    require(la_path)
    if la_path.exists():
        la = la_path.read_text()
        if PREAMBLE not in la:
            fail("listing-audit missing READ_ORDER preamble")
        if "reports/listing-audit-" not in la:
            fail("listing-audit missing artifact path string reports/listing-audit-")
        for needle in ["02 aspi/", "05 fractional/", "Wood Defender"]:
            if needle in la:
                fail(f"listing-audit still contains client IP path {needle}")
    ads = PLUGIN / "agents" / "ads.md"
    require(ads)
    if ads.exists() and PREAMBLE not in ads.read_text():
        fail("ads.md missing READ_ORDER preamble")
    ppc_path = PLUGIN / "skills" / "ppc-exception-brief" / "SKILL.md"
    require(ppc_path)
    if ppc_path.exists():
        ppc = ppc_path.read_text()
        if "logic.md" not in ppc:
            fail("ppc-exception-brief skill must mention logic.md")
        fallback = "only when logic has no ads flags"
        pos = 0
        while True:
            i = ppc.find("35", pos)
            if i < 0:
                break
            if fallback not in ppc[:i]:
                fail(
                    "35 must not appear as the primary flag instruction unless preceded by "
                    '"only when logic has no ads flags"'
                )
                break
            pos = i + 2
    if failures:
        print("FAIL")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
