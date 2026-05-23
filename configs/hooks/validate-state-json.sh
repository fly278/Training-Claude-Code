#!/usr/bin/env bash
# Hook: PreToolUse (Bash)
# Validates JSON files before git commit.
# Exits early (0) if the command is NOT a git commit touching JSON files.

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input // ""' 2>/dev/null || true)

# Only fire for git commit commands
if ! echo "$cmd" | grep -qE '^git commit'; then
  exit 0
fi

# Check staged JSON files
staged=$(git diff --cached --name-only 2>/dev/null || true)
json_files=$(echo "$staged" | grep -E '\.json$' || true)

if [ -z "$json_files" ]; then
  exit 0
fi

echo "[validate-json] checking staged JSON files..."

# Require jq
if ! command -v jq >/dev/null 2>&1; then
  echo "[validate-json] WARNING: jq not installed, skipping validation"
  exit 0
fi

failures=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if ! jq empty "$f" 2>/dev/null; then
    echo "  INVALID JSON: $f"
    failures=$((failures + 1))
  else
    echo "  valid: $f"
  fi
done <<< "$json_files"

if [ "$failures" -gt 0 ]; then
  echo "[validate-json] BLOCKED — $failures file(s) with invalid JSON."
  exit 1
fi

echo "[validate-json] OK"
exit 0
