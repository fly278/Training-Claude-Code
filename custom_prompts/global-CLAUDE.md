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
