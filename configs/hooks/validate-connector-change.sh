#!/usr/bin/env bash
# Hook: PostToolUse (Write/Edit)
# After editing a connector script, reminds to run health check and update docs.
# Exits early (0) if the file is NOT in orchestrator/connectors/.

input=$(cat)
file_path=$(echo "$input" | jq -r '.file_path // ""' 2>/dev/null || true)
action=$(echo "$input" | jq -r '.tool_name // ""' 2>/dev/null || true)

# Only fire for Write/Edit on connector files
if ! echo "$file_path" | grep -qE 'orchestrator/connectors/'; then
  exit 0
fi

echo "[validate-connector-change] connector modified: $(basename "$file_path")"
echo "  reminder: run health check — bash $file_path health"
echo "  reminder: if CLI changed, update INTEGRATION.md"

exit 0
