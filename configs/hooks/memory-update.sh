#!/usr/bin/env bash
# Hook: Stop (session end)
# Validates MEMORY.md structure if it exists.

MEMORY_FILE="${CLAUDE_PROJECT_DIR:-.}/MEMORY.md"

if [ ! -f "$MEMORY_FILE" ]; then
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

# Basic structure check
if ! grep -q "^#" "$MEMORY_FILE" 2>/dev/null; then
  echo '{"systemMessage":"MEMORY.md exists but has no headers. Consider adding structure.","continue":true}'
  exit 0
fi

exit 0
