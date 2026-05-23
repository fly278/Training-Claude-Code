# DEPENDENCY_MAP.md — 项目组件依赖关系图

> 自动扫描生成: 2026-05-21 | 改动前必查此文件

---

## 核心依赖链

```
CLAUDE.md (入口指令)
    │
    ├── orchestrator/orchestrate.sh (调度中枢)
    │       ├── orchestrator/connectors/openclaw-connector.sh
    │       │       └── scripts/edge-cdp-ensure.sh (依赖: curl, jq, Edge进程)
    │       ├── orchestrator/connectors/vscode-connector.sh
    │       │       └── VS Code (code.cmd)
    │       ├── orchestrator/connectors/db-connector.sh
    │       │       └── Node.js node:sqlite 或 Python sqlite3
    │       ├── orchestrator/connectors/email-connector.sh
    │       │       └── Node.js nodemailer (npm包)
    │       ├── orchestrator/state/current-task.json
    │       └── orchestrator/state/task-history.jsonl
    │
    ├── scripts/edge-cdp-ensure.sh (Edge CDP生命周期)
    │       └── curl → localhost:9222
    │
    ├── scripts/edge-cdp-auto-connect.sh (自动连接)
    │       └── scripts/edge-cdp-ensure.sh
    │
    ├── scripts/persist-edge-mcp-config.sh (MCP配置持久化)
    │       └── ~/.claude/plugins/...playwright/.mcp.json
    │
    ├── token-saver/ (CLI过滤代理)
    │       ├── tk.sh (入口)
    │       ├── lib/core.sh
    │       ├── lib/filters.sh
    │       ├── lib/wrappers.sh
    │       ├── lib/config.sh
    │       └── config/*.json (过滤规则)
    │
    ├── .claude/settings.json (hooks + 权限)
    │       ├── hooks/session-start.sh → 检查connector + 当前任务
    │       ├── hooks/validate-state-json.sh → git提交前JSON校验
    │       ├── hooks/validate-connector-change.sh → connector修改后提醒
    │       └── hooks/memory-update.sh → Stop事件校验MEMORY.md
    │
    ├── MEMORY.md (长期记忆)
    │       └── 被hooks/memory-update.sh校验
    │
    └── KNOWLEDGE_INDEX.md (知识索引)
```

---

## 改动影响矩阵

**改这个文件 → 必须检查这些文件：**

| 改动文件 | 直接影响 | 间接影响 | 风险等级 |
|----------|----------|----------|----------|
| orchestrate.sh | 所有connector | current-task.json, task-history.jsonl | 高 |
| openclaw-connector.sh | 浏览器自动化 | 所有依赖浏览器的任务 | 中 |
| vscode-connector.sh | VS Code操作 | 多文件重构任务 | 中 |
| db-connector.sh | 数据库操作 | 无 | 低 |
| email-connector.sh | 邮件发送 | 无 | 低 |
| edge-cdp-ensure.sh | openclaw-connector, playwright MCP | 所有浏览器任务 | 高 |
| settings.json | 所有hooks | 会话行为 | 高 |
| token-saver/tk.sh | 所有过滤命令 | CLI输出 | 中 |
| MEMORY.md | 未来会话上下文 | 决策质量 | 中 |

---

## 外部依赖

| 依赖 | 用途 | 安装方式 | 可替代 |
|------|------|----------|--------|
| Node.js (>=22.5) | db-connector, email-connector | `/d/ai/huanjing node/` | Python(部分) |
| Python 3.12 | db-connector备选 | `winget install Python.Python.3.12` | Node.js |
| nodemailer | 邮件发送 | `npm install nodemailer` | 无 |
| curl | Edge CDP检查, 网络请求 | 系统自带 | 无 |
| jq | JSON处理 | 系统自带 | Node.js |
| Edge (msedge.exe) | 浏览器自动化 | 系统自带 | Chrome(需改配置) |
| VS Code (code.cmd) | 复杂代码操作 | 系统自带 | 无 |
| openclaw | 桌面自动化 | 已安装 | 无 |

---

## 关键路径 (一断全断)

```
Edge进程 → edge-cdp-ensure.sh → openclaw-connector.sh → orchestrate.sh
```
Edge挂了 = 所有浏览器自动化停止。

```
Node.js → db-connector.sh / email-connector.sh
```
Node.js挂了 = 数据库和邮件能力丧失。

```
settings.json → hooks → 会话行为
```
settings.json损坏 = 所有自动化hook失效。
