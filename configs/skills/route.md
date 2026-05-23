# /route — Classify + Dispatch Task

Classify a task description and route it to the right tool(s).

## Trigger
User types `/route <task description>` or asks to run a task through the orchestrator.

## Workflow

### 1. Classify
```
bash orchestrator/orchestrate.sh classify "<task>"
```
Parse the JSON routing decision.

### 2. Show Plan
Present routing to user:
```
Task: "deploy landing page with new hero section"
Route: openclaw (high) → browser deployment
       claude-code (medium) → HTML/CSS edits
Proceed? [y/n]
```

### 3. Execute
Run classified phases in dependency order. For each phase:
- Update `orchestrator/state/current-task.json` with phase progress
- Run the connector action
- Capture output

### 4. Aggregate
```
bash orchestrator/orchestrate.sh status <task-id>
```
Show results: completed phases, pending phases, errors.

### 5. Archive
On completion, append to `orchestrator/state/task-history.jsonl`.

## Routing Rules
- **OpenClaw** for: browser navigation, form filling, screenshots, web scraping, GUI automation
- **VS Code** for: multi-file refactors (5+ files), breakpoint debugging, visual diff/merge
- **Claude Code** (self) for: single-file edits, code gen, git, tests, analysis

## Rules
- Always classify before executing — never skip to a tool directly.
- When routing confidence is "low", ask user to confirm tool choice.
- Parallel phases: run simultaneously. Sequential phases: wait for each.
