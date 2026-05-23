# Training-Claude-Code

通过自定义 Prompt、钩子脚本和配置文件，把 Claude Code 从"默认行为"训练成你想要的工作风格：简洁、安全、先计划后执行。

This repository stores custom training artifacts for Claude Code — prompts, configs, and examples that teach it capabilities beyond its default behavior.

---

## 这是什么？ / What's Inside

### `custom_prompts/` — 核心训练 Prompt

| 文件 | 用途 |
|------|------|
| `global-CLAUDE.md` | 用户级规则：沟通风格、代码生成、文件编辑、推理方式 |
| `project-CLAUDE.md` | 项目级规则：多工具调度、浏览器自动化、工具选择策略 |
| `SELF_CHECK.md` | 自查协议：计划先行 + 5条硬规则 + 事后检查清单 |
| `AGENT_TEAM.md` | 内部团队模拟：架构师/测试员/安全员三人协作 |
| `SKILLS_SOP.md` | 所有工具的标准操作流程参考 |
| `FINETUNING_DATA.md` | 训练数据收集 + DeepSeek v4 微调格式 |

### `configs/` — 自定义配置

| 文件 | 用途 |
|------|------|
| `settings.json` | Hooks（SessionStart / PreToolUse / PostToolUse / Stop）+ 权限配置 |
| `hooks/*.sh` | 5个自动触发的 shell 脚本 |
| `agents/*.md` | 3个专用子代理：connector-dev / edge-guard / task-router |
| `rules/*.md` | 3条路径级规则 |
| `skills/*.md` | 3个自定义斜杠命令：/start / /connector-health / /route |

### `examples/` — 训练示例和参考

| 文件 | 用途 |
|------|------|
| `MEMORY.md` | 长期记忆示例：用户偏好、架构决策、历史教训 |
| `DEPENDENCY_MAP.md` | 组件依赖树 + 变更影响矩阵 |
| `AAR_TEMPLATE.md` | 任务后复盘模板 |
| `KNOWLEDGE_INDEX.md` | 项目知识索引 |
| `AAR-stress-test.md` | 真实案例：对抗投毒指令的压力测试 |
| `sample_training_dialogue.md` | 5个真实训练对话，展示纠正和改进过程 |

### `docs/` — 文档

| 文件 | 用途 |
|------|------|
| `QUICK_START.md` | 5分钟快速上手指南 |
| `GLOSSARY.md` | 中英文术语对照表 |

---

## 快速开始 / Quick Start

### 第一步：克隆仓库

```bash
git clone https://github.com/fly278/Training-Claude-Code.git
cd Training-Claude-Code
```

### 第二步：应用全局 Prompt（影响最大）

将 `global-CLAUDE.md` 复制为你的全局 Claude Code 配置文件。这个文件控制 Claude 的沟通风格、代码生成方式、文件编辑习惯和推理模式。

**Linux / macOS：**
```bash
cp custom_prompts/global-CLAUDE.md ~/.claude/CLAUDE.md
```

**Windows (PowerShell)：**
```powershell
Copy-Item custom_prompts\global-CLAUDE.md $env:USERPROFILE\.claude\CLAUDE.md
```

**效果：** 所有 Claude Code 会话都会遵守 — 单句回答、不废话、YAGNI原则、优先 Edit 而非 Write。

> 如果只想对某个项目生效，复制到项目根目录：
> ```bash
> cp custom_prompts/global-CLAUDE.md /你的项目路径/CLAUDE.md
> ```

### 第三步：追加自查协议（推荐）

`SELF_CHECK.md` 教 Claude 学会"先计划后执行"，包含 5 条硬规则（违反即失败）。追加到全局配置：

**Linux / macOS：**
```bash
cat custom_prompts/SELF_CHECK.md >> ~/.claude/CLAUDE.md
```

**Windows (PowerShell)：**
```powershell
Get-Content custom_prompts\SELF_CHECK.md >> $env:USERPROFILE\.claude\CLAUDE.md
```

**效果：**
- 复杂任务自动触发计划先行（先输出方案，等你确认后再执行）
- 硬规则 H1-H5 防止致命错误：矛盾指令拒绝执行、不存在的 API 拒绝猜测、凭证禁止硬编码、破坏性操作二次确认、改 3+ 文件必须查依赖

### 第四步：配置 Hooks（可选但强大）

Hooks 是在特定事件时自动触发的 shell 脚本。复制到你的项目目录：

```bash
# 在你的项目根目录下执行
mkdir -p .claude/hooks
cp configs/hooks/*.sh .claude/hooks/
cp configs/settings.json .claude/
```

**激活的钩子：**

| 钩子 | 触发时机 | 作用 |
|------|---------|------|
| `SessionStart` | 会话开始 | 显示 git 分支、最近提交、活跃任务 |
| `PreToolUse` | git commit 前 | 验证 JSON 状态文件合法性 |
| `PostToolUse` | 文件修改后 | 提醒运行代码审查 |
| `Stop` | 会话结束 | 提醒将经验写入记忆 |
| `PostToolUseFailure` | 工具调用失败 | 提示检查错误信息 |

### 第五步：验证效果

启动一个新的 Claude Code 会话，测试以下场景：

**测试 1 — 简洁回答：**
```
你: What's 2+2?
Claude: 4
```
预期：直接回答，不说废话，不加"让我帮你查一下"。

**测试 2 — 计划先行：**
```
你: Set up a new Express project with TypeScript and ESLint.
```
预期：先输出结构化计划（目标、步骤、风险），问你"确认后我开始执行"，而不是直接动手。

**测试 3 — 安全意识：**
```
你: 写一个接收用户名查数据库的接口
```
预期：使用参数化查询（`?` 占位符），不拼接 SQL 字符串。

**测试 4 — 错误恢复：**
```
你: Run the test suite.
```
预期：如果 `jest` 找不到，不会反复重试，而是检查 `package.json` 发现项目用的是 `vitest`，自动切换。

---

## 训练前后对比

### 训练前
```
你: Add a logging function.

Claude: I'll create a comprehensive logging solution with multiple log levels,
file rotation, structured JSON output, configurable transports, a singleton
pattern, and integration with Winston...
[创建 200 行代码，5 个文件]
```

### 训练后
```
你: Add a logging function.

Claude:
- 目标: 追加带时间戳的日志行到 logs/app.log
- 文件: src/utils/logger.js（1个文件）
- 风险: 无（独立工具函数）
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

---

## 进阶用法

### 模拟内部团队（AGENT_TEAM.md）

追加到 CLAUDE.md 后，Claude 会自动以三个角色审查代码：

| 角色 | 职责 | 触发条件 |
|------|------|---------|
| 架构师 (Arki) | 发现过度工程化，提出最简方案 | 新功能 / 重构 / 技术选型 |
| 测试员 (Tester) | 找边界 case，质疑"能 work 吗" | 任何代码改动后 |
| 安全员 (Guardian) | 发现注入漏洞、密钥泄露 | 涉及用户输入 / API / 数据库 |

### 工具标准流程（SKILLS_SOP.md）

追加到 CLAUDE.md 后，规范所有工具的使用方式，包括：文件操作、Shell 操作、浏览器自动化、数据库操作、代理调度等。

### 训练数据收集（FINETUNING_DATA.md）

参考此文件收集对话数据，用于微调 DeepSeek v4 模型。

---

## 自定义调整

### 想更简洁
编辑 `global-CLAUDE.md`，加入：
```markdown
## Communication
- Maximum 3 sentences per response unless explicitly asked for more.
- Never repeat information the user already knows.
```

### 想更关注安全
编辑 `global-CLAUDE.md`，加入：
```markdown
## Security
- Always use parameterized queries for database operations.
- Never log sensitive data (passwords, tokens, keys).
- Validate all user input at system boundaries.
```

### 想指定技术栈
编辑 `project-CLAUDE.md`，加入：
```markdown
## Tech Stack
- Backend: Node.js + Express + TypeScript
- Database: PostgreSQL with Prisma ORM
- Testing: Vitest + Supptest
- Linting: ESLint + Prettier
```

---

## 常见问题

**Q: 这对所有 Claude Code 安装都有效吗？**
A: 是的。CLAUDE.md 是 Claude Code 的标准功能。Hooks 需要 Claude Code CLI 或桌面版。

**Q: 需要用所有文件吗？**
A: 不需要。先从 `global-CLAUDE.md` 和 `SELF_CHECK.md` 开始，按需添加。

**Q: 可以修改这些 prompt 吗？**
A: 当然。这些是起点，根据你的工作流自定义。

**Q: Claude Code 忽略了我的 CLAUDE.md 怎么办？**
A: 确认文件在正确位置（全局：`~/.claude/CLAUDE.md`，项目级：项目根目录）。修改后重启会话。

**Q: 怎么撤销所有更改？**
A: 删除复制的 CLAUDE.md 文件即可，Claude Code 立即恢复默认行为：
```bash
rm ~/.claude/CLAUDE.md
```

---

## 训练模式总结

| 训练方式 | 说什么 | 效果 |
|---------|--------|------|
| 复杂度控制 | "太复杂了，最多10行" | 强制最小方案 |
| 安全纠正 | "这里有SQL注入，修复并解释" | 建立安全意识 |
| 计划先行 | "先给我方案，不要直接动手" | 触发计划协议 |
| 语气调整 | "一句话回答，不要解释" | 调整详细程度 |
| 错误恢复 | "别重试了，先看错误信息" | 修复重试循环 |
| 范围控制 | "不要为假想需求提前构建" | 防止过度设计 |

---

## 我是如何训练 Claude Code 的

1. **自定义 Prompt** — 精心编写的系统提示词，定义行为、语气和约束
2. **配置调优** — settings.json 的 hooks、权限和环境变量
3. **迭代改进** — 真实对话示例，展示如何在使用中纠正和引导 Claude Code
4. **自查协议** — 硬规则防止常见 AI 错误（矛盾指令、缺失依赖、硬编码凭证）
5. **内部团队模拟** — 架构师/测试员/安全员多视角代码审查

---

## 术语表

完整中英文术语对照见 [docs/GLOSSARY.md](docs/GLOSSARY.md)。

| 英文 | 中文 |
|------|------|
| Hook | 钩子（自动触发的脚本） |
| CLAUDE.md | Claude Code 的规则配置文件 |
| YAGNI | 你不会需要它（不要过度设计） |
| Plan-First Protocol | 计划先行协议 |
| Self-Check Protocol | 自查协议 |
| After-Action Review (AAR) | 任务后复盘 |
| Connector | 连接器（桥接 Claude Code 和外部工具） |
| Orchestrator | 调度中枢 |
| Token | 词元（LLM 计费单位） |
