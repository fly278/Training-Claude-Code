#!/usr/bin/env bash
# Hook: PostToolUse (Write/Edit)
# After editing a connector or script, reminds to run health check.

# ============================================================
# CONFIG: Directory containing your connectors/scripts
# ============================================================
CONNECTORS_DIR="${CLAUDE_CONNECTORS_DIR:-orchestrator/connectors}"
# ============================================================

input=$(cat)
file_path=$(echo "$input" | jq -r '.file_path // ""' 2>/dev/null || true)

if [ -z "$file_path" ]; then
  exit 0
fi

if echo "$file_path" | grep -qE "${CONNECTORS_DIR}/"; then
  echo "[connector-check] modified: $(basename "$file_path")"
  echo "  reminder: run health check — bash $file_path health"
fi

exit 0
