# CLAUDE.md — Project-Level Token Optimization

Inherits global rules from ~/.claude/CLAUDE.md.

## Project-Specific
- Multi-tool orchestration via `orchestrator/`. See INTEGRATION.md for full dispatch rules.
- When a task spans browser/desktop ↔ code ↔ planning domains, decompose first:
  1. Classify: `bash orchestrator/orchestrate.sh classify "<task>"`
  2. Route browser/GUI work → `bash orchestrator/connectors/openclaw-connector.sh <action> <args>`
  3. Route complex code ops → `bash orchestrator/connectors/vscode-connector.sh <action> <args>`
  4. Handle simple edits/git/generation in-house
  5. Aggregate results from `orchestrator/state/current-task.json`

## Browser Automation — ALWAYS use existing Edge
- NEVER launch a new Chrome/Chromium window. Always operate in the user's existing Edge session.
- Before ANY browser operation, ensure Edge CDP is reachable:
  `bash scripts/edge-cdp-ensure.sh check`
- If Edge CDP is not available, offer to restart Edge with debugging enabled:
  `bash scripts/edge-cdp-ensure.sh restart`
- All OpenClaw browser commands use `--browser-profile edge-session` (attaches to Edge via CDP).
- All Playwright MCP operations connect to `http://localhost:9222` (Edge CDP endpoint).
- After any Playwright plugin update, re-apply Edge CDP config:
  `bash scripts/persist-edge-mcp-config.sh`
- The user's Edge session has their cookies, logins, extensions — reusing it saves them time.

## Tool Selection Rules
- Prefer built-in tools (Edit, Write, Bash, Grep, Glob) for single-file edits, git, tests, code gen.
- VS Code for: multi-file interactive refactors (5+ files), debugging with breakpoints, visual merge resolution.
- OpenClaw for: browser/desktop automation (always via Edge CDP).
- Keep this file lean. Only add rules that change behavior, not documentation discovered from code.

## Skills
- `/start` — Session init, connector health, project stage detect. Use on fresh sessions.
- `/connector-health` — Check Edge CDP, OpenClaw, VS Code, state file reachability.
- `/route <task>` — Classify + dispatch a task through the orchestrator pipeline.

## Agents
Use specialized subagents for domain-specific work:
- `connector-dev` — Modifying `orchestrator/connectors/*.sh`. Spawn when connector behavior needs changing.
- `task-router` — Tuning classification patterns in `orchestrate.sh`. Spawn when routing produces wrong results.
- `edge-guard` — Edge CDP troubleshooting. Spawn when browser automation fails to connect.

## Hooks (auto-fire)
- SessionStart: shows branch, recent commits, active task breadcrumb.
- PreToolUse (Bash): validates JSON state files before git commit.
- PostToolUse (Write|Edit): reminds to health-check connector after editing connector scripts.

## Token Optimization — tk CLI Proxy
- When running verbose CLI commands for agent consumption, use the token-saver:
  `bash token-saver/bin/tk <cmd> <args...>`
- This filters noise (ANSI, progress bars, warnings) while preserving exit codes.
- Supported commands: git, npm, npx, cargo, docker, ls, cat, grep, rg, find, curl, wget, gh, df, du, ps, tree, dir, which, echo.
- Filter rules live in `token-saver/config/*.json`. Stats in `token-saver/state/stats.jsonl`.
- For interactive shells: `source token-saver/tk.sh` to auto-wrap all configured commands.

## Path-Scoped Rules
- `orchestrator/connectors/**` → POSIX, health/exec/status actions, timeouts, shellcheck.
- `orchestrator/state/**` → Valid JSON, field constraints, append-only history.
- `scripts/edge-cdp-*.sh` → Never launch Chrome, never restart Edge without consent, CDP at localhost:9222.
