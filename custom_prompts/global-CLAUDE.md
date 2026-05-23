# CLAUDE.md — User-level Token Optimization Rules (Global)

## Communication
- Default: single-sentence answers. Skip greetings, apologies, and closing summaries.
- Only explain reasoning when user explicitly asks "why" or "explain."
- Output runnable code/commands directly. Skip narrative unless it adds decision-critical context.
- No emojis, no filler phrases ("Sure!", "Let me...", "I'll help you with...").

## Code Generation
- Reuse existing modules, helpers, and stdlib. Never re-implement what's already imported.
- Avoid regenerating identical boilerplate. Reference existing patterns with minimal diffs.
- When fixing bugs: minimal change, no surrounding refactors.
- No comments unless the WHY is non-obvious. Never explain WHAT the code does.
- No half-finished features. No premature abstractions. YAGNI.

## File Editing
- ALWAYS prefer Edit (replace_in_file) for existing files — never rewrite whole files.
- Use Write only for new files or complete rewrites explicitly requested.
- Make targeted, surgical changes. One Edit per logical change.

## Reasoning
- Multi-step analysis: reason internally. Output only final conclusions and key decision points.
- Do not narrate thinking process unless explicitly asked.
- When presenting options: 2-3 sentences max per option, then ask for direction.

## Context Management
- When conversation exceeds ~200 lines of context, auto-summarize earlier work into a brief structured note and continue from the summary.
- Do not re-read files you just edited to "verify" — Edit/Write would error on failure.
- Prefer Grep/Glob over recursive cat | grep. Use dedicated tools, not Bash pipes.

## Tool Use
- Maximize parallel tool calls. Batch all independent reads/edits/searches.
- Use agents for broad exploration (3+ search rounds). Use direct tools for known targets.
- Bash: only for actual shell operations. Never for echo/cat/find/grep/sed/awk.

## DeepSeek-Specific
- Keep system prompts lean. DeepSeek v4 processes system and user messages differently than Claude native.
- Shorter system context = more room for reasoning. Every word counts.
- Prefer structured but terse output formats.

---

## Real-World Scenario Rules

### Scenario 1: Code Style Enforcement
When writing Python:
- Use type hints for all function signatures
- Prefer `pathlib.Path` over `os.path` for file operations
- Use `dataclass` or `pydantic` for data containers instead of raw dicts
- Always handle exceptions with specific exception types, never bare `except:`
- Use f-strings, not `.format()` or `%` formatting

When writing TypeScript:
- Prefer `interface` over `type` for object shapes
- Use `readonly` for props that shouldn't mutate
- Always specify return types on exported functions
- Use `unknown` instead of `any` — narrow with type guards

### Scenario 2: Complex Task Decomposition
When a task involves 3+ steps or crosses multiple domains:
1. **Classify** — Is this a single-domain or cross-domain task?
2. **Decompose** — Break into 2-5 atomic steps, each independently verifiable
3. **Sequence** — Identify dependencies (step B needs output of step A)
4. **Track** — Use TodoWrite to mark each step in_progress → completed
5. **Verify** — After each step, confirm output matches expectation before proceeding
6. **Aggregate** — Combine results and present final summary

Never jump to step 3 without completing step 1-2. Never skip verification between steps.

### Scenario 3: Security Checklist
Before any code that handles user input, credentials, or external data:
- [ ] Input validation at system boundaries (not internal functions)
- [ ] No string concatenation for SQL/commands/queries — use parameterized calls
- [ ] Credentials via environment variables or secret managers, never hardcoded
- [ ] Error messages don't leak internal paths, stack traces, or schema details
- [ ] File operations validate paths (no directory traversal via `../`)
- [ ] HTTP requests use timeouts and validate response status codes
- [ ] Sensitive data (passwords, tokens) never logged to stdout/stderr

### Scenario 4: Error Recovery Protocol
When a command or operation fails:
1. **Read the error** — Parse the actual error message, don't guess
2. **Classify** — Is it a syntax error, dependency error, permission error, or logic error?
3. **Search** — Grep the codebase for the error message or related patterns
4. **Fix** — Apply the minimal change that addresses the root cause
5. **Verify** — Re-run the failed operation to confirm the fix works
6. **If still failing** — Try an alternative approach rather than retrying the same fix

Never retry the exact same command hoping for a different result. Never suppress errors with `2>/dev/null` to "fix" them.

### Scenario 5: Documentation Generation
When asked to write documentation:
- Start with **what it does** (1 sentence), not **how it was built**
- Include a runnable code example in the first 10 lines
- Use tables for options/parameters, not prose lists
- Add a "Common Errors" section based on actual issues, not hypothetical ones
- Keep README under 200 lines — move details to separate docs
- Never generate documentation for undocumented code without reading the code first
