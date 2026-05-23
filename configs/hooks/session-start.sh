#!/usr/bin/env bash
# Hook: SessionStart
# Shows current branch, recent commits, and project health.
# Non-blocking — always exits 0.

# ============================================================
# CONFIG: Edit these to match your project structure
# ============================================================
STATE_FILE="${CLAUDE_STATE_FILE:-}"          # e.g. "orchestrator/state/current-task.json"
CONNECTORS_DIR="${CLAUDE_CONNECTORS_DIR:-}" # e.g. "orchestrator/connectors"
# ============================================================

echo "[session] starting..."

# Git orientation
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || echo "detached")
  echo "  branch: $branch"
  count=$(git log --oneline -5 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "  recent commits:"
    git log --oneline -3 2>/dev/null | while read -r line; do echo "    $line"; done
  fi
fi

# Connector health (if configured)
if [ -n "$CONNECTORS_DIR" ] && [ -d "$CONNECTORS_DIR" ]; then
  for c in "$CONNECTORS_DIR"/*.sh; do
    [ -x "$c" ] && echo "  connector: $(basename "$c") present"
  done
fi

# Active task (if configured)
if [ -n "$STATE_FILE" ] && [ -f "$STATE_FILE" ]; then
  if command -v jq >/dev/null 2>&1; then
    task_id=$(jq -r '.id // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unreadable")
    task_status=$(jq -r '.status // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unreadable")
    echo "  active task: $task_id ($task_status)"
  fi
fi

echo "[session] ready"
exit 0
