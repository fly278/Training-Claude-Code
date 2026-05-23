# SKILLS_SOP.md — Standard Operating Procedures

> Version: 1.0 | Created: 2026-05-21 | Updated: 2026-05-21

## 1. File Operations

### 1.1 Read — 读取文件
- **何时用**: 需要查看文件内容时。修改前必须先Read。
- **怎么用**: `Read(file_path="<absolute-path>")` — 必须绝对路径。
- **陷阱**: 读大文件时用 `offset` + `limit` 分段读；PDF需指定 `pages`；图片自动视觉识别。

### 1.2 Write — 创建/覆盖文件
- **何时用**: 创建新文件或完整重写。已有文件必须先用Read读过。
- **怎么用**: `Write(file_path="<path>", content="<content>")`
- **陷阱**: 会覆盖已有文件！修改现有文件优先用Edit。

### 1.3 Edit — 精确字符串替换
- **何时用**: 修改文件中的部分内容。**默认首选工具。**
- **怎么用**: `Edit(file_path, old_string, new_string)` — old_string必须在文件中唯一。
- **陷阱**: 缩进必须完全匹配（含tab/space）；非唯一匹配会报错，用更多上下文或 `replace_all=true`。

### 1.4 Grep — 内容搜索
- **何时用**: 搜索代码中的符号、关键字、模式。
- **怎么用**: `Grep(pattern="<regex>", path="<dir>", output_mode="content|files_with_matches|count")`
- **陷阱**: 用ripgrep语法，花括号需转义 `\{`；多行模式用 `multiline: true`。

### 1.5 Glob — 文件名匹配
- **何时用**: 按文件名模式查找文件。
- **怎么用**: `Glob(pattern="**/*.ts", path="<dir>")`
- **陷阱**: 结果按修改时间排序，非字母序。

---

## 2. Shell Operations

### 2.1 Bash — 执行Shell命令
- **何时用**: 运行构建、测试、git、安装包等Shell操作。**不用**于 cat/find/grep/echo（有专用工具）。
- **怎么用**: `Bash(command="<cmd>", description="<what>")`
- **关键规则**:
  - Windows环境用Git Bash，路径用 `/d/ai/...` 格式，非 `D:\ai\...`
  - 独立命令并行发送多个Bash调用；依赖命令用 `&&` 串联
  - 禁用交互式命令（如 `git rebase -i`）
- **错误处理**: 非0退出码会显示stderr，检查输出定位问题。

---

## 3. Web Operations

### 3.1 WebSearch — 网络搜索
- **何时用**: 需要最新信息、当前事件、库/框架最新文档时。
- **怎么用**: `WebSearch(query="<keywords>")`
- **陷阱**: 仅US可用；搜索词要包含年份（当前2026）。

### 3.2 WebFetch — 网页抓取
- **何时用**: 获取特定URL内容并分析。
- **怎么用**: `WebFetch(url="<url>", prompt="<what to extract>")`
- **陷阱**: 认证页面会失败（Google Docs, Jira等）；15分钟缓存；自动升级HTTP→HTTPS。

---

## 4. Browser Automation (Playwright MCP)

### 4.1 页面导航
```
browser_navigate(url="https://...")         # 当前tab导航
browser_tabs(action="new", url="...")       # 新tab打开
browser_navigate_back()                     # 后退
```

### 4.2 页面交互
```
browser_click(target="<ref>")               # 点击元素
browser_type(target="<ref>", text="...")    # 输入文本
browser_select_option(target="<ref>", values=["..."])  # 下拉选择
browser_fill_form(fields=[{...}])           # 批量填表
browser_hover(target="<ref>")               # 悬停
browser_press_key(key="Enter")              # 按键
```

### 4.3 信息采集
```
browser_snapshot()                           # 无障碍快照（首选）
browser_take_screenshot(type="png")         # 截图
browser_console_messages(level="error")     # 控制台错误
browser_network_requests(static=false)      # 网络请求列表
```

### 4.4 关键规则
- **始终用现有Edge会话** (localhost:9222)，绝不开新Chrome
- 操作前先snapshot了解页面结构
- target用snapshot中的元素引用
- 文件上传用绝对路径
- **危险**: `browser_run_code_unsafe` 是RCE等价操作

---

## 5. Documentation (Context7 MCP)

### 5.1 标准流程
1. `resolve-library-id(query="<task>", libraryName="<name>")` — 获取库ID
2. `query-docs(libraryId="/org/project", query="<question>")` — 查询文档
- **何时用**: 任何API语法、配置、版本迁移、库特定调试问题。
- **陷阱**: 最多3次query-docs调用/问题；需先resolve得到正确的libraryId。

---

## 6. Connectors (Orchestrator)

### 6.1 OpenClaw — 浏览器/桌面自动化
```bash
bash orchestrator/connectors/openclaw-connector.sh health
bash orchestrator/connectors/openclaw-connector.sh exec navigate <url>
bash orchestrator/connectors/openclaw-connector.sh exec click <ref>
bash orchestrator/connectors/openclaw-connector.sh exec snapshot
```
- **何时用**: 网页交互、截图、桌面GUI、消息发送(Telegram/Slack/Discord)
- **前置**: `bash scripts/edge-cdp-ensure.sh check`

### 6.2 VS Code — 复杂代码操作
```bash
bash orchestrator/connectors/vscode-connector.sh exec open <file> [line]
bash orchestrator/connectors/vscode-connector.sh exec diff <f1> <f2>
bash orchestrator/connectors/vscode-connector.sh exec refactor <dir> <old> <new>
```
- **何时用**: 5+文件重构、调试断点、合并冲突、多光标编辑
- **陷阱**: VS Code必须正在运行且已打开当前工作区。

### 6.3 DB — 数据库操作 (新增)
```bash
bash orchestrator/connectors/db-connector.sh health
bash orchestrator/connectors/db-connector.sh exec sql <db> '<sql>'
bash orchestrator/connectors/db-connector.sh exec script <db> <file.sql>
bash orchestrator/connectors/db-connector.sh status [db]
```
- **何时用**: 本地SQLite数据库查询、数据验证、schema查看
- **依赖**: Node.js >=22.5.0 (node:sqlite内置)

---

## 7. Agent Dispatch

### 7.1 选择Agent类型
| 场景 | Agent | 触发条件 |
|------|-------|----------|
| 代码探索(>3轮搜索) | Explore | 不确定文件位置，需要广撒网 |
| 功能开发架构 | feature-dev:code-architect | 新功能需要架构设计 |
| 代码审查 | feature-dev:code-reviewer | 写完代码后自查 |
| 代码简化 | code-simplifier | 代码改动后优化 |
| Connector修改 | connector-dev | 修改orchestrator/connectors/*.sh |
| 路由调优 | task-router | 分类结果不正确 |
| Edge CDP修复 | edge-guard | 浏览器自动化连接失败 |
| 代码现代化 | code-modernization:* | 遗留系统改造 |
| PR审查 | pr-review-toolkit:review-pr | 全面PR审查 |

### 7.2 使用模式
- **前台**: 需要Agent结果才能继续时。等待返回。
- **后台**: 独立并行工作。用 `run_in_background=true`。
- **并行**: 多个独立Agent同时派发，单消息多tool call。

---

## 8. Task Management

### 8.1 TodoWrite — 任务跟踪
- **何时用**: 3个以上步骤的复杂任务。
- **规则**: 只有一个in_progress；完成立即标记；完成后清理。
- **格式**: 每个todo必须有 `content`(祈使句)和 `activeForm`(进行时)。

### 8.2 CronCreate — 定时调度
```bash
# 一次性提醒
CronCreate(cron="30 14 21 5 *", recurring=false, prompt="check deploy")
# 周期任务
CronCreate(cron="*/5 * * * *", recurring=true, prompt="poll status")
```
- **陷阱**: 避免整点/半点触发（如9:00→用8:57或9:03）；周期任务7天自动过期。

---

## 9. Skills Quick Reference

| Skill | 用途 | 触发词 |
|-------|------|--------|
| `/start` | 会话初始化 | 新会话开始 |
| `/connector-health` | 检查所有连接器 | 怀疑连接问题 |
| `/route` | 分类+派发任务 | 复杂多域任务 |
| `feature-dev` | 引导式功能开发 | 新功能开发 |
| `code-review` | 代码审查PR | PR审查请求 |
| `security-review` | 安全审查 | 安全相关改动 |
| `verify` | 验证改动生效 | PR验证、修复确认 |
| `simplify` | 代码简化优化 | 改动后清理 |
| `hookify` | 创建防错hooks | 重复犯错后 |
| `claude-api` | Claude API开发 | SDK/API相关 |
| `update-config` | 修改settings.json | 权限/环境变量/行为配置 |

---

## 10. Common Error Patterns & Recovery

| 症状 | 可能原因 | 修复 |
|------|----------|------|
| Edit报"not unique" | old_string匹配多处 | 加更多上下文使其唯一，或用replace_all |
| Bash权限被拒 | settings.json未授权 | `/update-config` 添加权限 |
| Edge CDP unreachable | Edge未以debug模式启动 | `bash scripts/edge-cdp-ensure.sh restart` |
| WebFetch认证失败 | 页面需登录 | 改用Playwright浏览器访问已登录Edge |
| Playwright超时 | 页面加载慢 | `browser_wait_for(time=5)` 等待 |
| Agent返回不完整 | 描述不够具体 | 提示中明确文件路径、行号、预期改动 |
| npm/node not found | 环境路径问题 | node在 `/d/ai/huanjing node/` |
