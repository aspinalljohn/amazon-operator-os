#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/sync-template-grok.sh"

# Buyer-facing docs ship inside the zip so the ops folder is self-contained.
STAGE="$ROOT/dist/stage"
rm -rf "$STAGE"
mkdir -p "$STAGE"
cp -R "$ROOT/template/." "$STAGE/"
mkdir -p "$STAGE/docs"
for doc in INSTALL.md EXPORTS.md WHAT-GOOD-LOOKS-LIKE.md GROK-BUILD-ADVANCED.md SUPPORT.md; do
  cp "$ROOT/docs/$doc" "$STAGE/docs/$doc"
done
cp "$ROOT/LICENSE" "$STAGE/LICENSE"

OUT="$ROOT/dist/amazon-operator-os.zip"
rm -f "$OUT"
( cd "$STAGE" && zip -rq "$OUT" . -x "*.DS_Store" )
rm -rf "$STAGE"
echo "wrote $OUT"
