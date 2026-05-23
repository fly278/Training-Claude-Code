# Rules: orchestrator/state/**/*.json

When editing task state files, enforce:

## Validity
- All JSON must be valid (`jq empty <file>` must pass)
- `current-task.json`: single JSON object with keys `id`, `description`, `created`, `status`, `phases`, `results`
- `task-history.jsonl`: one JSON object per line, append-only

## Field Constraints
- `id`: kebab-case, unique within history
- `status`: one of `pending`, `in_progress`, `completed`, `failed`, `abandoned`
- `created` / `updated`: ISO 8601 UTC (`date -u +%Y-%m-%dT%H:%M:%SZ`)
- `phases[]`: each has `name`, `tool`, `action`, `args`, `status`

## Integrity
- Never truncate `task-history.jsonl` — append only
- Before overwriting `current-task.json`, archive the old state to history
