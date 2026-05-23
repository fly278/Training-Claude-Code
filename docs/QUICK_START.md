# Quick Start Guide

> New to training Claude Code? This guide walks you through applying these training techniques to your own setup in 5 minutes.

---

## What Is This?

This repository contains **system prompts**, **configuration files**, and **real examples** that teach Claude Code to behave differently from its defaults — more concise, more secure, more structured, and more useful.

Think of it as a "personality transplant" for your AI coding assistant.

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/fly278/Training-Claude-Code.git
cd Training-Claude-Code
```

---

## Step 2: Apply the Global Prompt

The most impactful file is `custom_prompts/global-CLAUDE.md`. This controls how Claude Code communicates, generates code, and handles errors.

### Option A: Copy to Your Global Config (Recommended)
This applies to ALL your Claude Code sessions:

```bash
# Linux/macOS
cp custom_prompts/global-CLAUDE.md ~/.claude/CLAUDE.md

# Windows (PowerShell)
Copy-Item custom_prompts\global-CLAUDE.md $env:USERPROFILE\.claude\CLAUDE.md
```

### Option B: Copy to a Specific Project
This applies only to one project:

```bash
cp custom_prompts/global-CLAUDE.md /path/to/your/project/CLAUDE.md
```

---

## Step 3: Apply the Self-Check Protocol

The `custom_prompts/SELF_CHECK.md` file teaches Claude Code to plan before acting and verify after executing. Append it to your existing CLAUDE.md:

```bash
# Append to global config
cat custom_prompts/SELF_CHECK.md >> ~/.claude/CLAUDE.md

# Or to a specific project
cat custom_prompts/SELF_CHECK.md >> /path/to/your/project/CLAUDE.md
```

---

## Step 4: Set Up Hooks (Optional but Powerful)

Hooks are shell scripts that fire automatically at specific moments. Copy the hooks to your project:

```bash
# In your project directory
mkdir -p .claude/hooks
cp configs/hooks/*.sh .claude/hooks/
cp configs/settings.json .claude/
```

This gives you:
- **SessionStart**: Shows git branch, recent commits, active task
- **PreToolUse**: Validates JSON before git commit, warns before git push
- **PostToolUse**: Reminds to run code review after file changes
- **Stop**: Validates MEMORY.md structure on session end

---

## Step 5: Verify It Works

Start a new Claude Code session and test:

```
You: What's 2+2?
Claude: 4

You: Write a function to read a CSV file.
Claude: [Should give minimal, working code without unnecessary abstractions]

You: Set up a new Express project with TypeScript and ESLint.
Claude: [Should present a plan first, then ask for confirmation]
```

---

## Customization Guide

### I Want Claude Code to Be Even More Concise
Edit `global-CLAUDE.md` and add:
```markdown
## Communication
- Maximum 3 sentences per response unless explicitly asked for more.
- Never repeat information the user already knows.
```

### I Want Claude Code to Be More Careful with Security
Edit `global-CLAUDE.md` and add:
```markdown
## Security
- Always use parameterized queries for database operations.
- Never log sensitive data (passwords, tokens, keys).
- Validate all user input at system boundaries.
```

### I Want Claude Code to Use a Specific Tech Stack
Edit `project-CLAUDE.md` and add:
```markdown
## Tech Stack
- Backend: Node.js + Express + TypeScript
- Database: PostgreSQL with Prisma ORM
- Testing: Vitest + Supertest
- Linting: ESLint + Prettier
```

---

## Understanding the File Structure

```
Training-Claude-Code/
├── custom_prompts/          # Copy these to ~/.claude/ or your project
│   ├── global-CLAUDE.md     # User-level rules (applies everywhere)
│   ├── project-CLAUDE.md    # Project-level rules (applies per-project)
│   ├── SELF_CHECK.md        # Plan-first + verify-after protocol
│   ├── AGENT_TEAM.md        # Internal team simulation (advanced)
│   ├── SKILLS_SOP.md        # Tool usage reference
│   └── FINETUNING_DATA.md   # Training data collection (advanced)
│
├── configs/                 # Copy these to your project's .claude/
│   ├── settings.json        # Hook configuration
│   ├── hooks/               # Auto-firing shell scripts
│   ├── agents/              # Sub-agent definitions
│   ├── rules/               # Path-scoped rules
│   └── skills/              # Custom slash commands
│
├── examples/                # Read these to understand the training method
│   ├── sample_training_dialogue.md  # Real training conversations
│   ├── MEMORY.md            # Long-term memory example
│   └── AAR_TEMPLATE.md      # Post-task review template
│
└── docs/                    # You are here
    ├── QUICK_START.md       # This file
    └── GLOSSARY.md          # Terminology reference
```

---

## FAQ

**Q: Will this work with any Claude Code installation?**
A: Yes. CLAUDE.md files are a standard Claude Code feature. Hooks require Claude Code CLI or desktop app.

**Q: Do I need to use all the files?**
A: No. Start with `global-CLAUDE.md` and `SELF_CHECK.md`. Add more as needed.

**Q: Can I modify the prompts?**
A: Absolutely. These are starting points. Customize them to match your workflow.

**Q: What if Claude Code ignores my CLAUDE.md?**
A: Make sure the file is in the correct location (`~/.claude/CLAUDE.md` for global, or project root for project-level). Restart the session after changes.

**Q: How do I undo the changes?**
A: Delete the CLAUDE.md file you copied. Claude Code reverts to defaults immediately.
