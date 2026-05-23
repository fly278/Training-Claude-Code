#!/usr/bin/env bash
# Memory Update Hook — PostToolUse (Write|Edit) on MEMORY.md
# Validates that MEMORY.md has proper structure and timestamp is updated.
set -euo pipefail

MEMORY_FILE="${CLAUDE_PROJECT_DIR:-.}/MEMORY.md"

if [ ! -f "$MEMORY_FILE" ]; then
  echo '{"systemMessage":"MEMORY.md not found. Create it first with the memory update protocol.","continue":true}'
  exit 0
fi

# Check MEMORY.md has the protocol section
if ! grep -q "记忆更新协议" "$MEMORY_FILE" 2>/dev/null; then
  echo '{"systemMessage":"WARNING: MEMORY.md is missing the 记忆更新协议 section. Add it back.","continue":true}'
  exit 0
fi

# Check last-updated date is present
if ! grep -q "最后更新" "$MEMORY_FILE" 2>/dev/null; then
  echo '{"systemMessage":"MEMORY.md missing 最后更新 date header. Update it.","continue":true}'
  exit 0
fi

echo '{"continue":true}'
