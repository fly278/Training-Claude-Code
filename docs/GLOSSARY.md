# Glossary / 术语表

> 中英文对照，按字母顺序排列。帮助理解本项目中使用的术语。

---

## A

| English | 中文 | 解释 |
|---------|------|------|
| After-Action Review (AAR) | 任务后复盘 | 每次重要任务完成后填写的复盘报告，记录做对了什么、做错了什么、下次怎么改进。源自军事术语。 |
| Agent | 代理/智能体 | Claude Code 中的子代理，专注于特定任务领域（如 connector-dev 负责连接器开发）。 |
| ANSI | ANSI转义码 | 终端输出中的颜色/格式控制字符，token-saver 会过滤掉它们以节省 token。 |

## C

| English | 中文 | 解释 |
|---------|------|------|
| Chrome DevTools Protocol (CDP) | Chrome开发者工具协议 | 浏览器调试协议，本项目通过它连接 Edge 浏览器进行自动化操作。 |
| Connector | 连接器 | 桥接 Claude Code 与外部工具的脚本（如 openclaw-connector 连接浏览器，vscode-connector 连接 VS Code）。 |

## D

| English | 中文 | 解释 |
|---------|------|------|
| DeepSeek v4 | DeepSeek第四版 | 一种大语言模型，其系统提示词处理方式与 Claude 不同，需要更精简的 prompt。 |

## E

| English | 中文 | 解释 |
|---------|------|------|
| Edge CDP | Edge CDP连接 | 通过 Chrome DevTools Protocol 连接 Microsoft Edge 浏览器进行自动化。端口固定为 localhost:9222。 |
| Environment Variable (env var) | 环境变量 | 操作系统级别的配置变量，用于存储凭证等敏感信息，避免硬编码。 |

## G

| English | 中文 | 解释 |
|---------|------|------|
| Git Bash | Git Bash | Windows 上的类 Unix shell 环境，本项目的脚本在其中运行。 |
| Glob | 文件名匹配 | 按模式查找文件名的工具（如 `**/*.ts` 匹配所有 TypeScript 文件）。 |
| Grep | 内容搜索 | 在文件内容中搜索正则表达式的工具，基于 ripgrep 实现。 |
| Guardian | 安全员 | 内部三人团队中的安全角色，负责发现注入漏洞、密钥泄露等安全问题。 |

## H

| English | 中文 | 解释 |
|---------|------|------|
| Hard Rule | 硬规则 | SELF_CHECK.md 中定义的不可违反的规则（如：致命矛盾必须拒绝执行）。违反即失败，无例外。 |
| Hook | 钩子 | 在特定事件（如会话开始、工具调用后）自动触发的 shell 脚本。 |

## M

| English | 中文 | 解释 |
|---------|------|------|
| MEMORY.md | 长期记忆文件 | 项目级的长期记忆，记录用户偏好、架构决策、历史教训等，跨会话持久化。 |

## N

| English | 中文 | 解释 |
|---------|------|------|
| Node.js | Node.js | JavaScript 运行时环境，用于运行 db-connector 和 email-connector。 |

## O

| English | 中文 | 解释 |
|---------|------|------|
| OpenClaw | OpenClaw | 桌面/浏览器自动化工具，通过 connector 与 Claude Code 集成。 |
| Orchestrator | 调度中枢 | 项目的核心调度系统，负责任务分类、路由和聚合。 |

## P

| English | 中文 | 解释 |
|---------|------|------|
| Parameterized Query | 参数化查询 | SQL 查询中使用占位符（如 `?`）代替直接拼接用户输入，防止 SQL 注入。 |
| Plan-First Protocol | 计划先行协议 | SELF_CHECK.md 中的核心规则：复杂任务必须先输出计划，等用户确认后再执行。 |
| POSIX | 可移植操作系统接口 | Unix/Linux 系统兼容性标准，connector 脚本必须遵循以确保跨平台运行。 |

## S

| English | 中文 | 解释 |
|---------|------|------|
| Self-Check Protocol | 自查协议 | SELF_CHECK.md 中定义的任务执行前/后检查流程，确保代码质量和安全。 |
| Shellcheck | Shell检查工具 | 静态分析 shell 脚本的工具，检测语法错误和常见问题。 |
| Slash Command | 斜杠命令 | Claude Code 中以 `/` 开头的命令（如 `/start`、`/route`），由 skill 定义。 |

## T

| English | 中文 | 解释 |
|---------|------|------|
| Task Router | 任务路由器 | 分析任务描述并决定路由到哪个工具（OpenClaw/VS Code/Claude Code）的组件。 |
| Token | 令牌/词元 | LLM 处理文本的最小单位，也是 API 计费单位。token-saver 的目标就是减少 token 消耗。 |
| Token-Saver | 令牌节省器 | 本项目的 CLI 输出过滤代理，通过过滤 ANSI、进度条等噪音来减少 token 消耗。 |

## Y

| English | 中文 | 解释 |
|---------|------|------|
| YAGNI | 你不会需要它 | "You Aren't Gonna Need It" 的缩写。软件开发原则：不要为假想的未来需求提前构建功能。 |

---

## Roles in AGENT_TEAM.md / 团队角色

| English | 中文 | 职责 |
|---------|------|------|
| Architect (Arki) | 架构师 | 设计系统结构、发现过度工程化、提出最简方案 |
| Commander | 兵王 | 最终决策者，整合各方意见，对外输出 |
| Guardian | 安全员 | 发现安全漏洞、检查敏感信息泄露、评估攻击面 |
| Tester | 测试员 | 找边界 case、设计验证方法、质疑"它能 work 吗" |

---

## Hook Events / 钩子事件

| English | 中文 | 触发时机 |
|---------|------|----------|
| SessionStart | 会话开始 | Claude Code 启动或新会话创建时 |
| PreToolUse | 工具调用前 | Claude Code 即将调用工具（如 Bash、Edit）之前 |
| PostToolUse | 工具调用后 | Claude Code 成功调用工具之后 |
| PostToolUseFailure | 工具调用失败后 | Claude Code 调用工具失败时 |
| Stop | 会话结束 | Claude Code 会话即将结束时 |
