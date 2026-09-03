#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/template/.grok"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$ROOT/plugins/amazon-operator-os/agents" "$DEST/agents"
cp -R "$ROOT/plugins/amazon-operator-os/skills" "$DEST/skills"
cp -R "$ROOT/plugins/amazon-operator-os/personas" "$DEST/personas"
cp -R "$ROOT/plugins/amazon-operator-os/workflows" "$DEST/workflows"
cp -R "$ROOT/plugins/amazon-operator-os/commands" "$DEST/commands"
echo "synced template/.grok"
