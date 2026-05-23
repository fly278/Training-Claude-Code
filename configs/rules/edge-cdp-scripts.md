# Rules: scripts/edge-cdp-*.sh

When editing Edge CDP scripts, enforce:

## Safety
- Never auto-restart Edge without explicit user consent
- Never launch Chrome/Chromium — only connect to existing Edge
- CDP endpoint is always `http://localhost:9222`

## Idempotency
- `check`: read-only, exits 0 if reachable, 1 if not
- `restart`: kills Edge gracefully, relaunches with `--remote-debugging-port=9222`, waits for port
- Running `check` twice produces same result with no side effects

## Windows Compatibility
- Use Git Bash or WSL paths: `/c/Program Files...` not `C:\Program Files...`
- Edge executable path: auto-detect via `find` in Program Files, with fallback to hardcoded path
- Handle spaces in paths with quotes
