#!/usr/bin/env bash
# Hook: SessionStart
# Shows current branch, recent commits, connector health summary.
# Non-blocking — always exits 0.

echo "[orchestrator] session starting..."

# Git orientation (if in a repo)
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || echo "detached")
  echo "  branch: $branch"
  count=$(git log --oneline -5 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "  recent commits:"
    git log --oneline -3 2>/dev/null | while read -r line; do echo "    $line"; done
  fi
fi

# Quick connector health (fast checks only, no network calls that might hang)
if [ -x orchestrator/connectors/openclaw-connector.sh ]; then
  echo "  openclaw-connector: present"
fi
if [ -x orchestrator/connectors/vscode-connector.sh ]; then
  echo "  vscode-connector: present"
fi

# Check for active task
if [ -f orchestrator/state/current-task.json ]; then
  task_id=$(jq -r '.id // "unknown"' orchestrator/state/current-task.json 2>/dev/null || echo "unreadable")
  task_status=$(jq -r '.status // "unknown"' orchestrator/state/current-task.json 2>/dev/null || echo "unreadable")
  echo "  active task: $task_id ($task_status)"
fi

# Suggest /start for fresh projects with no state files
if [ ! -f orchestrator/state/current-task.json ] && [ ! -f orchestrator/state/task-history.jsonl ]; then
  echo "  hint: no task history found — try /start"
fi

echo "[orchestrator] ready"
exit 0
