#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/sync-template-grok.sh"
# Buyer-facing docs at zip root (repo keeps them under docs/)
cp "$ROOT/docs/INSTALL.md" "$ROOT/template/INSTALL.md"
cp "$ROOT/docs/EXPORTS.md" "$ROOT/template/EXPORTS.md"
cp "$ROOT/docs/ONBOARDING.md" "$ROOT/template/ONBOARDING.md"
OUT="$ROOT/dist/amazon-operator-os.zip"
mkdir -p "$ROOT/dist"
rm -f "$OUT"
( cd "$ROOT/template" && zip -r "$OUT" . -x "*.DS_Store" )
rm -f "$ROOT/template/INSTALL.md" "$ROOT/template/EXPORTS.md" "$ROOT/template/ONBOARDING.md"
echo "wrote $OUT"
