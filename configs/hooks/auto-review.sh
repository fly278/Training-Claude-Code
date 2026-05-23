#!/usr/bin/env bash
# Hook: PostToolUse (Write|Edit)
# After editing key files, reminds to run review and check dependencies.

# ============================================================
# CONFIG: Patterns that trigger a review reminder
# Edit these to match your project's critical paths
# ============================================================
REVIEW_PATTERNS="${CLAUDE_REVIEW_PATTERNS:-(\.claude/|\.github/|src/)}"
# ============================================================

TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
if [ -z "$TOOL_INPUT" ]; then
  exit 0
fi

if echo "$TOOL_INPUT" | grep -qE "$REVIEW_PATTERNS"; then
  echo '{"systemMessage":"CROSS-REVIEW: Modified a key file. Run tests and check DEPENDENCY_MAP.md for downstream impact.","continue":true}'
fi

exit 0
