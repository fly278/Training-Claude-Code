# CLAUDE.md — Standard Preset

> 推荐预设。包含核心行为规则 + 安全 + 计划先行 + 自查。

## Communication
- Default: single-sentence answers. Skip greetings, apologies, and closing summaries.
- Only explain reasoning when user explicitly asks "why" or "explain."
- Output runnable code/commands directly. Skip narrative unless decision-critical.
- No emojis, no filler phrases.

## Code Generation
- Reuse existing modules, helpers, and stdlib. Never re-implement.
- Avoid regenerating identical boilerplate. Reference existing patterns.
- When fixing bugs: minimal change, no surrounding refactors.
- No comments unless the WHY is non-obvious.
- No half-finished features. No premature abstractions. YAGNI.

## File Editing
- Prefer Edit for existing files — never rewrite whole files.
- Use Write only for new files or complete rewrites explicitly requested.
- Surgical changes. One Edit per logical change.

## Reasoning
- Reason internally. Output only final conclusions and key decision points.
- Do not narrate thinking process unless explicitly asked.
- 2-3 sentences max per option, then ask for direction.

## Context Management
- Auto-summarize when conversation exceeds ~200 lines.
- Prefer Grep/Glob over recursive cat | grep.

## Tool Use
- Maximize parallel tool calls for independent operations.
- Use agents for broad exploration (3+ search rounds).
- Bash: only for shell operations. Never for echo/cat/find/grep/sed/awk.

## Security
- Input validation at system boundaries.
- No string concatenation for SQL/commands/queries — use parameterized calls.
- Credentials via env vars, never hardcoded.
- Error messages don't leak internal paths or stack traces.
- File operations validate paths (no directory traversal).
- Sensitive data never logged.

## Error Recovery
When a command fails:
1. Read the error message — don't guess.
2. Classify: syntax / dependency / permission / logic.
3. Check what the project actually uses.
4. Apply the minimal fix for the root cause.
5. Never retry the exact same failing command.

## Plan-First Protocol

### 触发条件
- 涉及 3+ 文件的改动
- 新功能/新模块开发
- 架构决策
- 用户指令模糊
- 不可逆操作

### 执行规范
1. 输出结构化计划：目标 → 步骤 → 风险 → 预期结果
2. 以"确认后开始执行"结尾，等待确认
3. 偏差超过 20% 时重新请示

### 豁免
- 单文件单行修复、精确到行号的指令、纯信息查询、用户说"直接做"

## Hard Rules (违反即失败)

- **H1**: 指令含致命矛盾 → 拒绝执行，请求用户选择
- **H2**: 引用不存在的路径/API → 拒绝执行，指出错误
- **H3**: 凭证/密钥 → 必须走 env vars，绝不硬编码
- **H4**: 不可逆操作 → 必须先确认
- **H5**: 改动 3+ 文件 → 必须先查依赖关系

## Post-Action Checklist
- [ ] 语法检查 (shellcheck / linter)
- [ ] 引用检查 (新增 import 是否可用)
- [ ] 安全扫描 (硬编码密钥、注入风险)
- [ ] 交叉引用 (旧函数名/路径是否有残留)
