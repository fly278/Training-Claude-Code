# settings.json Documentation

> 配置 hooks（自动触发脚本）和权限控制。

---

## 权限配置

```json
{
  "permissions": {
    "defaultMode": "askEveryTime",
    "allow": ["Read", "Glob", "Grep", "WebSearch"],
    "deny": [],
    "ask": []
  }
}
```

| 字段 | 说明 |
|------|------|
| `defaultMode` | 默认权限模式。`askEveryTime` = 每次工具调用都需确认 |
| `allow` | 自动允许的工具列表（只读操作安全放行） |
| `deny` | 禁止的工具列表 |
| `ask` | 需要确认的工具列表 |

### 常见配置

**开发环境（推荐）：**
```json
"defaultMode": "askEveryTime",
"allow": ["Read", "Glob", "Grep", "WebSearch"]
```

**宽松模式（注意安全）：**
```json
"defaultMode": "allowEdits",
"allow": ["Read", "Glob", "Grep", "WebSearch", "Edit", "Write"]
```

**完全信任（不推荐）：**
```json
"defaultMode": "bypassPermissions",
"allow": ["*"]
```

---

## Hooks 结构

```json
{
  "hooks": {
    "SessionStart": [...],      // 会话开始时触发
    "PreToolUse": [...],         // 工具调用前触发
    "PostToolUse": [...],        // 工具调用后触发
    "Stop": [...],               // 会话结束时触发
    "PostToolUseFailure": [...]  // 工具调用失败时触发
  }
}
```

---

## Hook 事件详解

### SessionStart — 会话开始
```json
"SessionStart": [{
  "matcher": "",
  "hooks": [{"type": "command", "command": "bash .claude/hooks/session-start.sh"}]
}]
```

### PreToolUse — 工具调用前
```json
"PreToolUse": [{
  "matcher": "Bash",
  "hooks": [
    {"type": "command", "command": "bash .claude/hooks/validate-state-json.sh"},
    {"type": "command", "if": "Bash(git push*)", "command": "echo '{\"systemMessage\": \"...\"}'"}
  ]
}]
```

### PostToolUse — 工具调用后
```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "hooks": [{"type": "command", "command": "bash .claude/hooks/auto-review.sh"}]
}]
```

### Stop — 会话结束
```json
"Stop": [{
  "matcher": "",
  "hooks": [{"type": "command", "command": "bash .claude/hooks/memory-update.sh"}]
}]
```

---

## Matcher 模式

| 模式 | 匹配 |
|------|------|
| `""` | 所有事件 |
| `"Bash"` | 仅 Bash 工具调用 |
| `"Write\|Edit"` | Write 或 Edit 调用 |
| `"Bash(git push*)"` | 以 git push 开头的 Bash 调用 |

---

## 环境变量

Hooks 脚本支持以下环境变量进行自定义：

| 变量 | 用途 | 默认值 |
|------|------|--------|
| `CLAUDE_STATE_FILE` | 状态文件路径 | 空（不检查） |
| `CLAUDE_CONNECTORS_DIR` | 连接器目录 | `orchestrator/connectors` |
| `CLAUDE_REVIEW_PATTERNS` | 触发审查的文件模式 | `(\.claude/\|src/)` |
| `CLAUDE_PROJECT_DIR` | 项目根目录 | `.` |
| `CLAUDE_TOOL_INPUT` | 工具输入（hook 自动设置） | 由 Claude Code 注入 |

在 `.claude/settings.json` 同目录创建 `.env` 文件设置这些变量：
```bash
CLAUDE_STATE_FILE=my-project/state.json
CLAUDE_CONNECTORS_DIR=my-connectors/
CLAUDE_REVIEW_PATTERNS=(src/|lib/)
```

---

## 自定义示例

### 添加 commit 前 lint 检查
```json
{
  "type": "command",
  "if": "Bash(git commit*)",
  "command": "echo '{\"systemMessage\": \"Run lint before committing.\", \"continue\": true}'"
}
```

### 添加 TypeScript 类型检查
```json
{
  "type": "command",
  "if": "Edit(*.ts)",
  "command": "echo '{\"systemMessage\": \"TypeScript file changed. Run tsc --noEmit.\"}'"
}
```
