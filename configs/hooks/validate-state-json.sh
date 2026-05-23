#!/usr/bin/env bash
# Hook: PreToolUse (Bash)
# Validates JSON state files before git commit.
# Exits early (0) if the command is NOT a git commit touching state files.

# Read hook input from stdin
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input // ""' 2>/dev/null || true)

# Only fire for git commit commands
if ! echo "$cmd" | grep -qE '^git commit'; then
  exit 0
fi

# Check if state files are in the staging area
staged=$(git diff --cached --name-only 2>/dev/null || true)
if ! echo "$staged" | grep -qE 'orchestrator/state/.*\.json'; then
  exit 0
fi

echo "[validate-state-json] checking staged state files..."

failures=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if ! jq empty "$f" 2>/dev/null; then
    echo "  INVALID JSON: $f"
    failures=$((failures + 1))
  else
    echo "  valid: $f"
  fi
done <<< "$(echo "$staged" | grep -E 'orchestrator/state/.*\.json')"

if [ "$failures" -gt 0 ]; then
  echo "[validate-state-json] BLOCKED — $failures file(s) with invalid JSON. Fix before committing."
  exit 1
fi

echo "[validate-state-json] OK"
exit 0
