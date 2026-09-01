#!/usr/bin/env bash
# Copy fixtures into a business folder's exports/ without overwriting non-empty buyer files.
set -euo pipefail
DEST="${1:?usage: load-fixtures.sh <ops-folder>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$DEST/exports/"{sales,ads,inventory,reviews,listings} "$DEST/reference"
copy_if_empty() {
  local src="$1" dest="$2"
  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
  fi
}
copy_if_empty "$ROOT/fixtures/sales/business-report.csv" "$DEST/exports/sales/business-report.csv"
copy_if_empty "$ROOT/fixtures/ads/sp-campaigns.csv" "$DEST/exports/ads/sp-campaigns.csv"
copy_if_empty "$ROOT/fixtures/ads/sp-search-terms.csv" "$DEST/exports/ads/sp-search-terms.csv"
copy_if_empty "$ROOT/fixtures/inventory/fba-inventory.csv" "$DEST/exports/inventory/fba-inventory.csv"
copy_if_empty "$ROOT/fixtures/reviews/reviews.csv" "$DEST/exports/reviews/reviews.csv"
copy_if_empty "$ROOT/fixtures/listings/listings.md" "$DEST/exports/listings/listings.md"
cp "$ROOT/fixtures/sources.md" "$DEST/reference/sources.md"
cp "$ROOT/fixtures/logic.md" "$DEST/reference/logic.md"
echo "fixtures loaded into $DEST"
