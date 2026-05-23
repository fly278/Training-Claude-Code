#!/usr/bin/env bash
# Update Training-Claude-Code to the latest version.
# Usage: bash scripts/update.sh

set -euo pipefail

REPO_URL="https://github.com/fly278/Training-Claude-Code.git"
LOCAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_VERSION=$(cat "$LOCAL_DIR/VERSION" 2>/dev/null || echo "unknown")

echo "=== Training-Claude-Code Updater ==="
echo "Local version: $LOCAL_VERSION"
echo ""

TMP_DIR=$(mktemp -d)
echo "Fetching latest version..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

LATEST_VERSION=$(cat "$TMP_DIR/VERSION" 2>/dev/null || echo "unknown")
echo "Latest version: $LATEST_VERSION"

if [ "$LOCAL_VERSION" = "$LATEST_VERSION" ]; then
  echo ""
  echo "Already up to date ($LOCAL_VERSION)."
  rm -rf "$TMP_DIR"
  exit 0
fi

echo ""
echo "Changes available: $LOCAL_VERSION -> $LATEST_VERSION"
echo ""

if [ -f "$TMP_DIR/CHANGELOG.md" ]; then
  echo "=== Changelog (since your version) ==="
  sed -n "/## \[$LATEST_VERSION\]/,/## \[$LOCAL_VERSION\]/p" "$TMP_DIR/CHANGELOG.md" | head -30
  echo ""
fi

echo "What to update:"
echo "  1) presets/        (safe)"
echo "  2) tests/          (safe)"
echo "  3) custom_prompts/ (overwrites unchanged files)"
echo "  4) configs/        (overwrites unchanged files)"
echo "  5) All of the above"
echo "  q) Quit"
echo ""
read -rp "Choice [1-5/q]: " choice

update_dir() {
  local src="$1" dst="$2" name="$3"
  if [ -d "$src" ]; then
    mkdir -p "$dst"
    cp -rn "$src"/* "$dst"/ 2>/dev/null || true
    echo "  Updated: $name"
  fi
}

case "$choice" in
  1) update_dir "$TMP_DIR/presets" "$LOCAL_DIR/presets" "presets" ;;
  2) update_dir "$TMP_DIR/tests" "$LOCAL_DIR/tests" "tests" ;;
  3) update_dir "$TMP_DIR/custom_prompts" "$LOCAL_DIR/custom_prompts" "custom_prompts" ;;
  4) update_dir "$TMP_DIR/configs" "$LOCAL_DIR/configs" "configs" ;;
  5)
    update_dir "$TMP_DIR/presets" "$LOCAL_DIR/presets" "presets"
    update_dir "$TMP_DIR/tests" "$LOCAL_DIR/tests" "tests"
    update_dir "$TMP_DIR/custom_prompts" "$LOCAL_DIR/custom_prompts" "custom_prompts"
    update_dir "$TMP_DIR/configs" "$LOCAL_DIR/configs" "configs"
    cp "$TMP_DIR/VERSION" "$LOCAL_DIR/VERSION"
    cp "$TMP_DIR/CHANGELOG.md" "$LOCAL_DIR/CHANGELOG.md"
    echo "  Updated: VERSION, CHANGELOG.md"
    ;;
  q|Q) echo "Aborted." ; rm -rf "$TMP_DIR" ; exit 0 ;;
  *) echo "Invalid choice." ; rm -rf "$TMP_DIR" ; exit 1 ;;
esac

echo ""
echo "Done. Version: $LOCAL_VERSION -> $LATEST_VERSION"
echo ""
echo "Next: bash tests/run-test.sh"
rm -rf "$TMP_DIR"
