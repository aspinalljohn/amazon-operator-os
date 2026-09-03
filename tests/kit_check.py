#!/usr/bin/env python3
"""Pack invariants for Amazon Operator OS. Run from repo root: python3 tests/kit_check.py"""
from __future__ import annotations
import json
import re
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
        "template/README.md",
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
        "docs/GROK-BUILD-ADVANCED.md",
    ]:
        require(ROOT / rel)
    install_doc = ROOT / "docs" / "INSTALL.md"
    if install_doc.exists() and "Grok Bot" not in install_doc.read_text():
        fail("docs/INSTALL.md must describe Grok Bot app install, not CLI-only")
    buyer_readme = TEMPLATE / "README.md"
    if buyer_readme.exists() and "Grok CLI" in buyer_readme.read_text():
        low = buyer_readme.read_text().lower()
        if "do not" not in low and "not need" not in low and "ignore" not in low:
            fail("template/README.md must not tell buyers to install Grok CLI without negation")
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
            if name == "operator-setup" and "Grok Bot" not in text:
                fail("operator-setup must describe Grok Bot as default runtime")
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
    inventory = PLUGIN / "agents" / "inventory.md"
    require(inventory)
    if inventory.exists() and PREAMBLE not in inventory.read_text():
        fail("inventory.md missing READ_ORDER preamble")
    inv_path = PLUGIN / "skills" / "inventory-risk" / "SKILL.md"
    require(inv_path)
    if inv_path.exists():
        inv = inv_path.read_text()
        if "logic.md" not in inv:
            fail("inventory-risk skill must mention logic.md")
        fallback = "only when logic has no cover flag"
        pos = 0
        while True:
            i = inv.find("14", pos)
            if i < 0:
                break
            if fallback not in inv[:i]:
                fail(
                    "14 must not appear as the primary flag instruction unless preceded by "
                    '"only when logic has no cover flag"'
                )
                break
            pos = i + 2
    customer = PLUGIN / "agents" / "customer.md"
    require(customer)
    if customer.exists() and PREAMBLE not in customer.read_text():
        fail("customer.md missing READ_ORDER preamble")
    ri_path = PLUGIN / "skills" / "review-intelligence" / "SKILL.md"
    require(ri_path)
    if ri_path.exists():
        ri = ri_path.read_text()
        if "logic.md" not in ri:
            fail("review-intelligence skill must mention logic.md")
    creative = PLUGIN / "agents" / "creative.md"
    require(creative)
    if creative.exists():
        creative_text = creative.read_text()
        if PREAMBLE not in creative_text:
            fail("creative.md missing READ_ORDER preamble")
        if "reports/creative-brief-" not in creative_text:
            fail("creative.md missing artifact path string reports/creative-brief-")
    banned = ["higgsfield", "gpt-image", "image_gen", "generate the image"]
    ip_needles = ["02 aspi/", "05 fractional/", "Wood Defender", "velocity-sellers"]
    for skill_name in ["aplus-brief", "image-stack-brief"]:
        p = PLUGIN / "skills" / skill_name / "SKILL.md"
        require(p)
        if p.exists():
            text = p.read_text()
            lower = text.lower()
            if PREAMBLE not in text:
                fail(f"{skill_name} missing READ_ORDER preamble")
            if "reports/creative-brief-" not in text:
                fail(f"{skill_name} missing artifact path string reports/creative-brief-")
            for needle in banned:
                if needle.lower() in lower:
                    fail(f"{skill_name} mentions {needle}")
            for needle in ip_needles:
                if needle in text:
                    fail(f"{skill_name} still contains client IP path {needle}")
    wf = PLUGIN / "workflows" / "weekly-ops.rhai"
    require(wf)
    if wf.exists():
        wt = wf.read_text()
        for at in ["listing", "ads", "inventory", "customer", "creative"]:
            needle = f'agent_type: "{at}"'
            if needle not in wt:
                fail(f"weekly-ops.rhai missing {needle}")
    require(PLUGIN / "skills" / "operator-prove" / "SKILL.md")
    require(PLUGIN / "skills" / "operator-setup" / "SKILL.md")
    require(PLUGIN / "commands" / "operator-setup.md")
    require(PLUGIN / "commands" / "install-overnight.md")
    require(PLUGIN / "commands" / "prove.md")
    require(PLUGIN / "commands" / "weekly.md")
    require(ROOT / "scripts" / "load-fixtures.sh")
    owf = PLUGIN / "workflows" / "overnight-ops.rhai"
    require(owf)
    if owf.exists():
        ot = owf.read_text()
        if "cap" not in ot:
            fail("overnight-ops.rhai missing cap")
        if "retry_cap" not in ot:
            fail("overnight-ops.rhai missing retry_cap")
        if "checks_failed" not in ot:
            fail("overnight-ops.rhai missing checks_failed")
        if re.search(r'"maxItems":\s*2\b', ot):
            fail("overnight-ops.rhai seats schema must not use maxItems 2 (workflow truncates to cap)")
        for at in ["listing", "creative"]:
            needle = f'agent_type: "{at}"'
            if needle in ot:
                fail(f"overnight-ops.rhai must not contain {needle}")
    require(PLUGIN / "skills" / "install-overnight" / "SKILL.md")
    require(PLUGIN / "skills" / "overnight-ops" / "SKILL.md")
    require(PLUGIN / "commands" / "overnight.md")
    overnight_cmd = PLUGIN / "commands" / "overnight.md"
    if overnight_cmd.exists():
        oc = overnight_cmd.read_text()
        if "overnight-ops" not in oc:
            fail("overnight.md must reference overnight-ops skill")
        if "agent_budget 8" not in oc:
            fail("overnight.md missing agent_budget 8")
    install_skill = PLUGIN / "skills" / "install-overnight" / "SKILL.md"
    if install_skill.exists() and "Routine" not in install_skill.read_text():
        fail("install-overnight must describe Grok Bot Routine path")
    oskill = PLUGIN / "skills" / "overnight-ops" / "SKILL.md"
    if oskill.exists() and "`agent_budget`: 8" not in oskill.read_text() and "agent_budget` 8" not in oskill.read_text() and "agent_budget 8" not in oskill.read_text():
        fail("overnight-ops skill missing agent_budget 8")
    require(TEMPLATE / "bin" / "overnight.sh")
    require(TEMPLATE / "bin" / "overnight.plist.example")
    require(TEMPLATE / ".grok" / "commands" / "operator-setup.md")
    require(TEMPLATE / ".grok" / "commands" / "install-overnight.md")
    nested_cmd = TEMPLATE / ".grok" / "commands" / "commands"
    if nested_cmd.exists():
        fail("template/.grok/commands/commands nested dir — run sync-template-grok.sh (flat copy)")
    osh = TEMPLATE / "bin" / "overnight.sh"
    if osh.exists():
        sh = osh.read_text()
        if "--always-approve" not in sh:
            fail("overnight.sh missing --always-approve")
        if "-p " not in sh and "--single " not in sh:
            fail("overnight.sh missing -p prompt")
        if "--yolo" in sh:
            fail("overnight.sh still uses --yolo")
    if failures:
        print("FAIL")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
