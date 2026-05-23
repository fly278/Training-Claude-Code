# settings.json Documentation

> This file explains the hook configuration in `settings.json` and how to customize it.

---

## Structure Overview

```json
{
  "hooks": {
    "SessionStart": [...],      // Fires when Claude Code starts
    "PreToolUse": [...],         // Fires before tool execution (Bash, Edit, etc.)
    "PostToolUse": [...],        // Fires after tool execution
    "Stop": [...],               // Fires when session ends
    "PostToolUseFailure": [...]  // Fires when a tool call fails
  },
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": ["*"]
  }
}
```

---

## Hook Details

### 1. SessionStart — Session Initialization
**Fires**: When Claude Code starts or a new session is created.
**Purpose**: Show project orientation (branch, recent commits, active task).

```json
"SessionStart": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "bash .claude/hooks/session-start.sh"
      }
    ]
  }
]
```

### 2. PreToolUse — Before Tool Execution
**Fires**: Before Claude Code calls a tool (Bash, Edit, Write, etc.).
**Purpose**: Validate state files before git commit, warn before git push.

```json
"PreToolUse": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "bash .claude/hooks/validate-state-json.sh"
      },
      {
        "type": "command",
        "if": "Bash(git push*)",
        "command": "echo '{\"systemMessage\": \"WARNING: Push requires manual confirmation.\", \"continue\": true}'"
      }
    ]
  }
]
```

### 3. PostToolUse — After Tool Execution
**Fires**: After Claude Code successfully calls a tool.
**Purpose**: Remind to run code review after file changes.

```json
"PostToolUse": [
  {
    "matcher": "Write|Edit",
    "hooks": [
      {
        "type": "command",
        "command": "bash .claude/hooks/auto-review.sh"
      },
      {
        "type": "command",
        "command": "echo '{\"systemMessage\": \"Code changed: run /code-review on modified files.\"}'"
      }
    ]
  }
]
```

### 4. Stop — Session End
**Fires**: When the Claude Code session is about to end.
**Purpose**: Validate MEMORY.md structure, remind to capture learnings.

```json
"Stop": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "bash .claude/hooks/memory-update.sh"
      }
    ]
  }
]
```

### 5. PostToolUseFailure — Tool Call Failed
**Fires**: When a tool call returns a non-zero exit code.
**Purpose**: Generic error recovery message.

```json
"PostToolUseFailure": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "echo '{\"systemMessage\": \"Command failed. Review the error and retry.\"}'"
      }
    ]
  }
]
```

---

## Matcher Patterns

| Pattern | Matches |
|---------|---------|
| `""` | All events |
| `"Bash"` | Only Bash tool calls |
| `"Write\|Edit"` | Write or Edit tool calls |
| `"Bash(git push*)"` | Bash calls starting with "git push" |

---

## Customization Examples

### Add a Pre-Commit Lint Check
```json
{
  "type": "command",
  "if": "Bash(git commit*)",
  "command": "echo '{\"systemMessage\": \"Run lint before committing: npm run lint\", \"continue\": true}'"
}
```

### Add a Post-Edit Type Check
```json
{
  "type": "command",
  "if": "Edit(*.ts)",
  "command": "echo '{\"systemMessage\": \"TypeScript file changed. Run tsc --noEmit to verify.\", \"continue\": true}'"
}
```

### Add a Session Start Greeting
```json
{
  "type": "command",
  "command": "echo '{\"systemMessage\": \"Welcome back! Current branch: '\"$(git branch --show-current)\"'\"}'"
}
```
