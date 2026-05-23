#!/usr/bin/env bash
# Auto-Review Hook — PostToolUse (Write|Edit)
# When connector or core script files are modified, reminds to run cross-review.
set -euo pipefail

TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
if [ -z "$TOOL_INPUT" ]; then
  echo '{"continue":true}'
  exit 0
fi

# Check if the modified file is a connector, script, or settings file
if echo "$TOOL_INPUT" | grep -qE '(orchestrator/connectors/|scripts/|\.claude/settings|\.claude/hooks/|token-saver/)'; then
  echo '{"systemMessage":"CROSS-REVIEW: Modified a core infrastructure file. Run health check on affected connectors. Check DEPENDENCY_MAP.md for downstream impact.","continue":true}'
fi

echo '{"continue":true}'
