# Rules: orchestrator/connectors/**/*.sh

When editing connector scripts, enforce:

## Structure
- Every connector must implement: `health`, `exec`, `status` actions
- `health` returns JSON: `{"status":"ok|error","detail":"...",...}`
- `exec` accepts `--action <name> [args...]` and returns JSON with `{"status":"...","output":"..."}`
- Help text on `--help` or no args

## Robustness
- All network calls have timeouts: `curl --connect-timeout 5 --max-time 30`
- Handle missing dependencies gracefully: `if ! command -v jq &>/dev/null; then ... fi`
- Stderr for errors/diagnostics, stdout for machine-readable output

## Portability
- `#!/usr/bin/env bash` shebang
- No bashisms: use `[ ]` not `[[ ]]`, `printf` not `echo -e`, `${var##*/}` not `${var//}`
- Test with `shellcheck` before committing
