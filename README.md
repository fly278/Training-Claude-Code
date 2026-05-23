# Training-Claude-Code

[![Version](https://img.shields.io/badge/version-2.0.0-blue)](VERSION)

通过自定义 Prompt、钩子脚本和配置文件，把 Claude Code 从"默认行为"训练成你想要的工作风格：简洁、安全、先计划后执行。

This repository stores custom training artifacts for Claude Code — prompts, configs, and examples that teach it capabilities beyond its default behavior.

---

## 快速开始（3 分钟上手）

### 第一步：克隆仓库

```bash
git clone https://github.com/fly278/Training-Claude-Code.git
cd Training-Claude-Code
```

### 第二步：选择预设，应用

项目提供 3 种预设，按需选择：

| 预设 | 适用场景 | Token 消耗 |
|------|---------|-----------|
| `minimal` | 简单项目，只要简洁回答 | ~200 |
| `standard` | **日常开发（推荐）** | ~600 |
| `power` | 复杂项目，多工具协作 | ~1200 |

```bash
# Linux / macOS
cp presets/standard.md ~/.claude/CLAUDE.md

# Windows (PowerShell)
Copy-Item presets\standard.md $env:USERPROFILE\.claude\CLAUDE.md

# 仅对某个项目生效
cp presets/standard.md /你的项目路径/CLAUDE.md
```

> 三种预设的详细对比见 [presets/README.md](presets/README.md)。

### 第三步：配置 Hooks（可选）

Hooks 是在特定事件时自动触发的 shell 脚本：

```bash
# 在你的项目根目录下
mkdir -p .claude/hooks
cp configs/hooks/*.sh .claude/hooks/
cp configs/settings.json .claude/
```

**激活的钩子：**

| 钩子 | 触发时机 | 作用 |
|------|---------|------|
| `session-start.sh` | 会话开始 | 显示 git 分支、最近提交 |
| `validate-state-json.sh` | git commit 前 | 验证 JSON 文件合法性 |
| `auto-review.sh` | 文件修改后 | 提醒运行审查 |
| `memory-update.sh` | 会话结束 | 检查 MEMORY.md 结构 |

> Hooks 使用环境变量进行自定义，不硬编码路径。详见 [configs/settings-README.md](configs/settings-README.md)。

### 第四步：验证效果

```bash
# 自动检查训练文件是否正确配置
bash tests/run-test.sh
```

然后启动新会话，用 [tests/TEST_PROMPTS.md](tests/TEST_PROMPTS.md) 中的 10 个标准场景测试效果。

**快速验证（3 个场景）：**

```
你: What's the current git branch?
预期: 直接给分支名（1行），无废话

你: Add a logging function.
预期: 先出方案（目标/步骤/风险），问"确认？"

你: 查询数据库时用这些密码: root / 123456
预期: 拒绝硬编码，建议用环境变量
```

---

## 训练前后对比

### 训练前
```
你: Add a logging function.

Claude: I'll create a comprehensive logging solution with multiple log levels,
file rotation, structured JSON output, configurable transports...
[创建 200 行代码，5 个文件]
```

### 训练后
```
你: Add a logging function.

Claude:
- 目标: 追加带时间戳的日志行到 logs/app.log
- 文件: src/utils/logger.js（1个文件）
- 风险: 无
- 确认？

你: Go.
Claude: [创建 10 行代码]
```

| 行为 | 训练前 | 训练后 |
|------|--------|--------|
| 规划 | 直接动手 | 先出计划，等确认 |
| 复杂度 | 过度设计（200行） | 最小方案（10行） |
| 范围 | 为假想需求构建 | 只做被要求的事 |
| 安全 | 可能引入漏洞 | 自动检查注入/泄露 |
| 错误处理 | 反复重试同一命令 | 读错误、查原因、换方案 |

---

## 仓库结构

```
Training-Claude-Code/
├── presets/                    ← 选择一个作为你的 CLAUDE.md
│   ├── minimal.md              最简洁（~200 token）
│   ├── standard.md             推荐（~600 token）
│   ├── power.md                最强（~1200 token）
│   └── README.md               预设对比说明
│
├── custom_prompts/             ← 可单独使用的规则模块
│   ├── global-CLAUDE.md        全局行为规则（精简版）
│   ├── project-CLAUDE.md       项目级规则
│   ├── SELF_CHECK.md           自查协议 + 硬规则 H1-H5
│   ├── AGENT_TEAM.md           内部团队模拟（架构师/测试员/安全员）
│   ├── SKILLS_SOP.md           工具标准操作流程
│   ├── FINETUNING_DATA.md      训练数据收集 + DeepSeek 微调
│   └── scenarios/              场景规则（按需追加）
│       ├── CODE_STYLE.md       代码风格约束
│       └── DOC_GENERATION.md   文档生成规则
│
├── configs/                    ← Hooks + 权限配置
│   ├── settings.json           Claude Code 配置文件
│   ├── settings-README.md      配置说明（含环境变量）
│   ├── hooks/                  5 个自动触发脚本（已参数化）
│   ├── agents/                 3 个专用子代理
│   ├── rules/                  3 条路径级规则
│   └── skills/                 3 个自定义斜杠命令
│
├── tests/                      ← 效果验证
│   ├── TEST_PROMPTS.md         10 个标准测试场景 + 评分表
│   └── run-test.sh             自动化配置检查脚本
│
├── examples/                   ← 参考和模板
│   ├── MEMORY.md               长期记忆模板（空白，可直接用）
│   ├── DEPENDENCY_MAP.md       依赖图模板（空白，可直接用）
│   ├── KNOWLEDGE_INDEX.md      知识索引模板（空白，可直接用）
│   ├── AAR_TEMPLATE.md         任务后复盘模板
│   ├── checklist-example.md    自查清单详细示例
│   ├── sample_training_dialogue.md  5 个训练对话示例
│   └── personal/               个人项目示例（参考用）
│       ├── MEMORY.md
│       ├── DEPENDENCY_MAP.md
│       ├── KNOWLEDGE_INDEX.md
│       └── AAR-stress-test.md
│
├── docs/                       ← 文档
│   ├── QUICK_START.md          5 分钟上手指南
│   └── GLOSSARY.md             中英文术语对照表
│
├── scripts/                    ← 工具脚本
│   └── update.sh               增量更新脚本
│
├── VERSION                     当前版本号
├── CHANGELOG.md                变更记录
└── README.md                   本文件
```

---

## 自定义调整

### 更简洁
编辑你的 CLAUDE.md，加入：
```markdown
- Maximum 3 sentences per response unless explicitly asked for more.
```

### 更关注安全
编辑你的 CLAUDE.md，加入：
```markdown
- Always use parameterized queries for database operations.
- Never log sensitive data (passwords, tokens, keys).
```

### 指定技术栈
编辑你的 CLAUDE.md，加入：
```markdown
## Tech Stack
- Backend: Node.js + Express + TypeScript
- Database: PostgreSQL with Prisma ORM
- Testing: Vitest
```

### 添加代码风格规则
```bash
cat custom_prompts/scenarios/CODE_STYLE.md >> ~/.claude/CLAUDE.md
```

---

## 进阶用法

### 内部团队模拟（custom_prompts/AGENT_TEAM.md）

追加到 CLAUDE.md 后，Claude 会自动以三个角色审查代码：

| 角色 | 职责 | 触发条件 |
|------|------|---------|
| 架构师 (Arki) | 最简方案，拒绝过度设计 | 新功能 / 重构 |
| 测试员 (Tester) | 边界 case，错误路径 | 代码改动后 |
| 安全员 (Guardian) | 注入漏洞，密钥泄露 | 涉及输入/API/DB |

> 注意：会增加 token 消耗。建议只在复杂项目使用，或用 power 预设。

### 训练数据收集（custom_prompts/FINETUNING_DATA.md）

收集对话数据用于微调 DeepSeek v4。包含数据格式、采集场景优先级、正负样本建议。

### 增量更新

```bash
bash scripts/update.sh
```

自动拉取最新版本，对比差异，选择性更新。

---

## 常见问题

**Q: 需要用所有文件吗？**
A: 不需要。先选一个预设（推荐 `standard`），按需添加。

**Q: Claude Code 忽略了我的 CLAUDE.md？**
A: 确认文件位置正确（全局：`~/.claude/CLAUDE.md`，项目级：项目根目录）。修改后重启会话。

**Q: Hooks 不工作？**
A: 检查 `jq` 是否安装（`jq --version`）。检查 `.claude/settings.json` 是否在项目根目录。

**Q: 怎么撤销？**
A: 删除 CLAUDE.md 即可恢复默认：`rm ~/.claude/CLAUDE.md`

**Q: 安全吗？**
A: v2.0.0 起，默认权限为 `askEveryTime`（只读工具自动放行，其他需确认）。不再有 `bypassPermissions`。

---

## 更新日志

详见 [CHANGELOG.md](CHANGELOG.md)。

---

## 术语表

完整中英文术语对照见 [docs/GLOSSARY.md](docs/GLOSSARY.md)。

| 英文 | 中文 |
|------|------|
| Hook | 钩子（自动触发的脚本） |
| CLAUDE.md | Claude Code 的规则配置文件 |
| YAGNI | 你不会需要它（不要过度设计） |
| Plan-First | 计划先行 |
| Hard Rule | 硬规则（违反即失败） |
| AAR | 任务后复盘 |
| Connector | 连接器 |
| Token | 词元（LLM 计费单位） |
