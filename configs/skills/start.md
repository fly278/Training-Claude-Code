# /start — Session Initialization & Health Check

Initialize a Claude Code session for the multi-tool orchestration hub.

## Trigger
User types `/start` or session is new/fresh.

## Workflow

### Phase 1: Connector Health
Run all connector health checks in parallel:
```
bash orchestrator/connectors/openclaw-connector.sh health
bash orchestrator/connectors/vscode-connector.sh health
bash scripts/edge-cdp-ensure.sh check
```

Report reachable / unreachable with clear status indicators.

### Phase 2: Project Stage Detection
Check for existing state to determine where the user is:
- `orchestrator/state/current-task.json` exists → mid-task, show status
- `orchestrator/state/task-history.jsonl` non-empty → has history, show last 3 tasks
- Neither → fresh start

### Phase 3: Orient
Based on detected stage, present options:
| State | Options |
|-------|---------|
| Mid-task | Resume / Abandon / Status |
| Has history | New task / Review history |
| Fresh | Quick classify / Browse skills |

### Phase 4: Summarize
Show one-line status per connector, current task breadcrumb, and 1-2 suggested next actions.

## Rules
- Never block on connector health — warn and continue.
- Keep output under 15 lines total.
