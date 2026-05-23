# Training-Claude-Code

This repository stores my custom training artifacts for Claude Code — techniques, prompts, and configurations that teach it capabilities beyond its default behavior.

## What's Inside

### `custom_prompts/` — Core Training Prompts
| File | Purpose |
|------|---------|
| `global-CLAUDE.md` | User-level rules: communication style, code generation, file editing, reasoning |
| `project-CLAUDE.md` | Project-level rules: multi-tool orchestration, browser automation, tool selection |
| `SELF_CHECK.md` | Tactical training: plan-first protocol, 5 hard rules, post-action checklists |
| `AGENT_TEAM.md` | Internal team design: Architect/Tester/Guardian roles and collaboration flow |
| `SKILLS_SOP.md` | Standard operating procedures for all tools and skills |
| `FINETUNING_DATA.md` | Training data collection criteria and DeepSeek v4 fine-tuning format |

### `configs/` — Custom Claude Code Configuration
| File | Purpose |
|------|---------|
| `settings.json` | Hooks (SessionStart, PreToolUse, PostToolUse, Stop) + permissions |
| `hooks/*.sh` | 5 auto-firing shell scripts for validation and reminders |
| `agents/*.md` | 3 specialized sub-agents: connector-dev, edge-guard, task-router |
| `rules/*.md` | 3 path-scoped enforcement rules |
| `skills/*.md` | 3 custom slash commands: /start, /connector-health, /route |

### `examples/` — Training Examples & Reference
| File | Purpose |
|------|---------|
| `MEMORY.md` | Long-term memory with update protocol, user preferences, architecture, lessons |
| `DEPENDENCY_MAP.md` | Component dependency tree and change impact matrix |
| `AAR_TEMPLATE.md` | After-Action Review template for post-task reflection |
| `KNOWLEDGE_INDEX.md` | Quick index of all project knowledge |
| `AAR-stress-test.md` | Real example: stress test against poisoned instructions |
| `sample_training_dialogue.md` | 5 real training conversations showing corrections and improvements |

### `docs/` — Documentation & Guides
| File | Purpose |
|------|---------|
| `QUICK_START.md` | Step-by-step guide for new users to apply these training techniques |
| `GLOSSARY.md` | Bilingual (EN/CN) terminology reference for all terms used in this project |

## Quick Start

### Step 1: Clone
```bash
git clone https://github.com/fly278/Training-Claude-Code.git
cd Training-Claude-Code
```

### Step 2: Apply the Global Prompt
```bash
# Linux/macOS
cp custom_prompts/global-CLAUDE.md ~/.claude/CLAUDE.md

# Windows (PowerShell)
Copy-Item custom_prompts\global-CLAUDE.md $env:USERPROFILE\.claude\CLAUDE.md
```

### Step 3: Test It
Start a new Claude Code session. Try:
```
You: Set up a new Express project with TypeScript and ESLint.
Claude: [Should present a plan first, then ask for confirmation — not just start doing things]
```

For more details, see [docs/QUICK_START.md](docs/QUICK_START.md).

## Why

Claude Code is powerful out of the box, but with the right prompts, configs, and iterative training, it can be tuned to work exactly the way you want. This repo captures that work.

## How I Train Claude Code

1. **Custom Prompts** — Carefully crafted system prompts that define behavior, tone, and constraints
2. **Configuration Tuning** — Settings.json hooks, permissions, and environment variables
3. **Iterative Refinement** — Real conversation examples showing how I correct and guide Claude Code over time
4. **Self-Check Protocol** — Hard rules that prevent common AI mistakes (contradictions, missing dependencies, hardcoded credentials)
5. **Internal Team Simulation** — Architect/Tester/Guardian roles for multi-perspective code review

---

## Example Usage

Here's a typical conversation showing how training changes Claude Code's behavior:

### Before Training
```
You: Add a logging function to the project.

Claude: I'll create a comprehensive logging solution with multiple log levels,
file rotation, structured JSON output, configurable transports, a singleton
pattern, and integration with Winston. Let me design the architecture first...
[Creates 200 lines of code with 5 files]
```

### After Training
```
You: Add a logging function to the project.

Claude: [Presents plan]
- Goal: append timestamped lines to logs/app.log
- Files: src/utils/logger.js (1 file)
- Risk: none (isolated utility)
- Confirm?

You: Go.

Claude: [Creates 10-line file]
const fs = require('fs');
const path = require('path');
const LOG_FILE = path.join(__dirname, '../../logs/app.log');

function log(message) {
  const timestamp = new Date().toISOString();
  fs.appendFileSync(LOG_FILE, `[${timestamp}] ${message}\n`);
}
module.exports = { log };
```

### What Changed
| Behavior | Before | After |
|----------|--------|-------|
| Planning | Jumps straight in | Presents plan, waits for confirmation |
| Complexity | Over-engineers (200 lines) | Minimal solution (10 lines) |
| Scope | Builds for hypothetical needs | Builds only what was asked |
| Security | May introduce vulnerabilities | Checks for injection/leaks automatically |

See [examples/sample_training_dialogue.md](examples/sample_training_dialogue.md) for 5 complete training dialogues.
