#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/sync-template-grok.sh"
OUT="$ROOT/dist/amazon-operator-os.zip"
mkdir -p "$ROOT/dist"
rm -f "$OUT"
( cd "$ROOT/template" && zip -r "$OUT" . -x "*.DS_Store" )
echo "wrote $OUT"
