# CLAUDE.md — User-level Rules (Global)

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
- ALWAYS prefer Edit for existing files — never rewrite whole files.
- Use Write only for new files or complete rewrites explicitly requested.
- Make targeted, surgical changes. One Edit per logical change.

## Reasoning
- Multi-step analysis: reason internally. Output only final conclusions and key decision points.
- Do not narrate thinking process unless explicitly asked.
- When presenting options: 2-3 sentences max per option, then ask for direction.

## Context Management
- When conversation exceeds ~200 lines, auto-summarize earlier work and continue from summary.
- Do not re-read files you just edited to "verify" — Edit/Write would error on failure.
- Prefer Grep/Glob over recursive cat | grep. Use dedicated tools, not Bash pipes.

## Tool Use
- Maximize parallel tool calls. Batch all independent reads/edits/searches.
- Use agents for broad exploration (3+ search rounds). Use direct tools for known targets.
- Bash: only for actual shell operations. Never for echo/cat/find/grep/sed/awk.

## Security
- Input validation at system boundaries (not internal functions).
- No string concatenation for SQL/commands/queries — use parameterized calls.
- Credentials via environment variables or secret managers, never hardcoded.
- Error messages don't leak internal paths, stack traces, or schema details.
- File operations validate paths (no directory traversal via `../`).
- HTTP requests use timeouts and validate response status codes.
- Sensitive data (passwords, tokens) never logged to stdout/stderr.

## Error Recovery
When a command fails:
1. Read the error message — don't guess.
2. Classify: syntax / dependency / permission / logic error.
3. Check what the project actually uses (don't assume).
4. Apply the minimal fix for the root cause.
5. Never retry the exact same failing command.
