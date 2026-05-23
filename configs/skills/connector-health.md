# /connector-health — Check All Connectors

Verify that all orchestration connectors are reachable.

## Trigger
User types `/connector-health`, or before any routed task.

## Workflow

### 1. Edge CDP
```
bash scripts/edge-cdp-ensure.sh check
```
- Reachable → "Edge CDP: OK (ws://localhost:9222)"
- Unreachable → Offer `bash scripts/edge-cdp-ensure.sh restart`

### 2. OpenClaw
```
bash orchestrator/connectors/openclaw-connector.sh health
```
- OK → show version and browser profile
- Fail → suggest reinstall

### 3. VS Code
```
bash orchestrator/connectors/vscode-connector.sh health
```
- OK → show workspace info
- Fail → suggest checking extension

### 4. State Files
```
jq empty orchestrator/state/current-task.json 2>/dev/null && echo "OK" || echo "CORRUPT"
```

### Output
Single compact table:
```
Connector    Status    Detail
Edge CDP     OK        ws://localhost:9222
OpenClaw     OK        v2.1, profile=edge-session
VS Code      OK        workspace: claude-code-1
State        OK        1 active task
```

Yellow for warnings, red for failures, green for OK.

## Rules
- All checks run in parallel (single Bash call with `&` + `wait`).
- Never launch a browser — only check/restart Edge CDP.
