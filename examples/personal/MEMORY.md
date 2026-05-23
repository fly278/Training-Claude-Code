# MEMORY.md — 项目长期记忆

> 创建: 2026-05-21 | 最后更新: 2026-05-21 (缺点修正+泛化原则+依赖图)

---

## 记忆更新协议 (固定)

**承诺**: 每次交互结束时，如果出现以下信息，必须在结束回复前自动更新本文件：
- 用户明确表达的偏好或习惯
- 新的项目架构决策或关键变更
- 新增的常用命令或工作流
- 重要错误教训及其修复方案
- 新发现的环境限制或依赖变更

**更新方式**: 在对应章节追加条目，格式 `- [YYYY-MM-DD] <内容>`。保持简洁，一行一事实。

**禁止**: 不记录可从代码/git直接推导的信息。不记录临时调试状态。

---

## 1. 用户偏好

- 通信：单句回答，无寒暄，无表情符号，无结尾总结
- 代码：最小改动，无注释（除非非显而易见），不重构无关代码
- 编辑：首选Edit（精确替换），非Write（整文件重写）
- 工具：并行调用独立操作；专用工具 > Bash管道
- 系统：DeepSeek v4环境下保持prompt精简
- 任务：复杂任务先计划后执行，等我确认

## 2. 项目架构

### 核心组件
```
d:/ai/claude code/1/
├── orchestrator/          # 多工具调度中枢
│   ├── orchestrate.sh     # 分类 + 派发 + 聚合
│   ├── task-router.md     # 路由决策矩阵
│   ├── INTEGRATION.md     # 完整派发规则
│   ├── connectors/        # 工具连接器
│   │   ├── openclaw-connector.sh   # 浏览器/桌面自动化
│   │   ├── vscode-connector.sh     # VS Code复杂代码操作
│   │   └── db-connector.sh         # SQLite数据库操作
│   └── state/             # 任务状态管理
├── scripts/               # 基础设施脚本
│   ├── edge-cdp-ensure.sh       # Edge CDP生命周期
│   ├── edge-cdp-auto-connect.sh # 自动连接
│   └── persist-edge-mcp-config.sh # MCP配置持久化
├── token-saver/           # CLI输出过滤代理
├── .claude/               # Claude Code配置
│   ├── settings.json      # hooks + 权限
│   ├── settings.local.json
│   ├── hooks/             # 自动触发的shell hooks
│   ├── agents/            # 专用子代理定义
│   ├── rules/             # 路径作用域规则
│   └── skills/            # 自定义技能
├── AAR_LOGS/              # 复盘报告存档
└── 2/                     # 空目录（待清理）
```

### 关键架构决策
- 浏览器自动化始终复用用户现有Edge（CDP :9222），绝不启动新Chrome
- 三层分发：Claude Code（规划/简单编辑）→ OpenClaw（浏览器）→ VS Code（复杂重构）
- 所有connector遵循统一接口：health/exec/status + JSON输出

## 3. 常用命令

### 日常
```bash
bash scripts/edge-cdp-ensure.sh check        # 检查Edge CDP
bash scripts/edge-cdp-ensure.sh restart      # 重启Edge（需确认）
bash orchestrator/orchestrate.sh classify "<task>"  # 任务分类
bash orchestrator/orchestrate.sh run --task "<task>" # 完整派发
bash orchestrator/connectors/db-connector.sh health  # 数据库健康检查
bash orchestrator/connectors/db-connector.sh exec sql "<db>" "<sql>"
```

### Token优化
```bash
bash token-saver/bin/tk git diff            # 过滤版git diff
bash token-saver/bin/tk npm test            # 过滤版npm test
source token-saver/tk.sh                    # 加载自动包装
```

### 路径约定
- Git Bash环境: `/d/ai/claude code/1/`
- Edge CDP: `http://localhost:9222`
- Node: `/d/ai/huanjing node/node`
- Python: `/c/Users/Asus/AppData/Local/Programs/Python/Python312/python.exe` (v3.12.10)

## 4. 环境限制

- [2026-05-21] Node位于 `/d/ai/huanjing node/`，非标准路径
- [2026-05-21] 4个MCP需OAuth认证（Asana/GitLab/Linear/Greptile），尚未激活

## 5. 历史教训 (具体)

- [2026-05-21] Windows Store Python存根无法import sqlite3 → 始终用Node.js或已安装的Python 3.12
- [2026-05-21] 创建connector脚本后必须 `chmod +x` 并测试 `health` 动作
- [2026-05-21] email-connector初版用shell→JS字符串拼接传递凭证，被Agent审查发现注入漏洞
- [2026-05-21] Edit工具old_string必须唯一 → 不够唯一时加更多上下文行
- [2026-05-21] db-connector `:memory:` 因bash `[ -f ]` 检查失败 → 特殊SQLite关键字需跳过文件检查

## 6. 泛化原则 (从具体教训提炼)

> 以下原则适用于所有未来任务，不限于产生它们的具体场景。

### 安全原则
- **数据传递不走字符串拼接** — 任何涉及凭证、用户输入、多行文本的跨进程传递，必须用env vars或stdin JSON。shell→JS/Python字符串拼接是注入漏洞的温床。
- **敏感信息不出stdout** — health/status输出不含密码、token、私钥。只报告"已配置/未配置"。
- **输入校验在边界做** — connector只检查空值；格式校验(email/URL)在调用方做。但shell特殊字符必须转义。

### 开发原则
- **先验证再写** — 新工具/新依赖先跑health/import确认可用，再写业务逻辑。
- **遵循现有模式** — 新connector必须实现health/exec/status三动作。不搞特殊化。
- **特殊值要穷举** — `:memory:`、空字符串、绝对路径vs相对路径、Windows路径分隔符——写代码时主动列出边界值。

### 决策原则
- **不确定就问** — 用户指令有2种以上解读方式时，必须追问，不能猜。
- **矛盾就拒** — 用户要求互相冲突时，明确指出矛盾并请求选择，不能"两边都做"。
- **估工宁多勿少** — 说"大概需要X"时，乘以1.5-2倍。低估比高估伤害更大。

### 协作原则
- **改完必查依赖** — 改文件前查DEPENDENCY_MAP.md，改完后检查所有直接依赖。
- **教训必须泛化** — AAR中记录的教训，提炼成抽象原则写入MEMORY.md §6，而非只记具体案例。
