#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/template/.grok"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$ROOT/plugins/amazon-operator-os/agents" "$DEST/agents"
cp -R "$ROOT/plugins/amazon-operator-os/skills" "$DEST/skills"
mkdir -p "$DEST/personas" "$DEST/workflows" "$DEST/commands"
if [ -d "$ROOT/plugins/amazon-operator-os/personas" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/personas/" "$DEST/personas/"
fi
if [ -d "$ROOT/plugins/amazon-operator-os/workflows" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/workflows/" "$DEST/workflows/"
fi
if [ -d "$ROOT/plugins/amazon-operator-os/commands" ]; then
  cp -R "$ROOT/plugins/amazon-operator-os/commands/" "$DEST/commands/"
fi
echo "synced template/.grok"
