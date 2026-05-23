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

## Why

Claude Code is powerful out of the box, but with the right prompts, configs, and iterative training, it can be tuned to work exactly the way you want. This repo captures that work.

## How I Train Claude Code

1. **Custom Prompts** — Carefully crafted system prompts that define behavior, tone, and constraints
2. **Configuration Tuning** — Settings.json hooks, permissions, and environment variables
3. **Iterative Refinement** — Real conversation examples showing how I correct and guide Claude Code over time
4. **Self-Check Protocol** — Hard rules that prevent common AI mistakes (contradictions, missing dependencies, hardcoded credentials)
5. **Internal Team Simulation** — Architect/Tester/Guardian roles for multi-perspective code review
