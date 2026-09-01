#!/usr/bin/env bash
set -euo pipefail
OPS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$OPS_DIR"
DATE="$(date +%F)"
mkdir -p logs reports
grok -p --yolo --cwd "$OPS_DIR" --max-turns 40 \
  --allow 'Read(./**)' \
  --allow 'Write(./reports/**)' \
  --allow 'Write(./drafts/**)' \
  --allow 'Write(./logs/**)' \
  --deny 'Write(./exports/**)' \
  --deny 'Bash(rm*)' \
  "Run the overnight-ops skill and overnight-ops workflow for ${DATE}. Follow reference/sources.md and reference/logic.md. Do not spawn listing or creative." \
  >> "logs/overnight-${DATE}.log" 2>&1
