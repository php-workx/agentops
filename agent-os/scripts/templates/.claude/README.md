# Claude Code Configuration

**AgentOps Framework for {{PROJECT_NAME}}**

This directory contains your Claude Code configuration for AI-assisted development using AgentOps.

---

## Quick Start

### Use an Agent
```bash
# From terminal in Claude Code:
/prime              # Interactive guide
/prime-simple-task  # For straightforward work
/prime-complex-task # For research/planning
```

### Read First
1. `../CONSTITUTION.md` - Five Laws guiding all work
2. `../CLAUDE.md` - Project kernel and context
3. `settings.json` - This project's configuration

---

## Directory Structure

```
.claude/
├── settings.json       ← Your configuration
├── settings.local.json ← Local overrides (gitignored)
├── README.md           ← This file
├── agents/             ← Specialized AI agents
├── commands/           ← Slash commands (/prime, etc.)
└── skills/             ← Reusable capabilities
```

---

## Configuration Files

### settings.json (Framework)
Central configuration for your project:
- Model selection (opus, sonnet, haiku)
- Permissions (git, python, docker, etc.)
- Feature flags
- Profile and installation info

### settings.local.json (Personal)
Your personal overrides (gitignored):
- Local-only customizations
- Your preferred model for this session
- Personal environment variables
- Never committed to repository

---

## AgentOps Framework

### Five Laws (Constitutional)

All AI agents follow these laws:

1. **ALWAYS Extract Learnings** - Document patterns discovered
2. **ALWAYS Improve Self or System** - Identify ≥1 improvement per session
3. **ALWAYS Document Context** - Capture why/what/learning/impact
4. **ALWAYS Prevent Hook Loops** - Don't commit hook-modified files
5. **ALWAYS Guide with Workflows** - Suggest workflows, never prescribe

Read `CONSTITUTION.md` for full details.

### The 40% Rule

Never exceed 40% context window utilization per phase:

- Prevents AI degradation and hallucinations
- Enables multi-day projects with fresh context
- Supports context compression (5:1 to 10:1)

### Four Universal Patterns

1. **Multi-Phase Workflow** - Research → Plan → Implement
2. **Context Bundles** - Compress context for reuse
3. **Multi-Agent Orchestration** - Parallel agents for 3x speedup
4. **Intelligent Routing** - Auto-recommend best agent

---

## Workflow Guide

### For Simple Tasks

Use `/prime-simple-task` for:
- Adding a feature
- Fixing a bug
- Creating documentation
- One-phase work (implement directly)

### For Complex Tasks

Use `/prime-complex-task` for:
- Architecture decisions
- Multi-phase research and planning
- Large refactoring
- Cross-domain work

### For Debugging

Use `/prime-debug` for:
- Troubleshooting
- Understanding failures
- Root cause analysis
- System diagnostics

---

## Semantic Commits

All commits follow this format:

```
<type>(<scope>): <subject>

<body - optional, explain why>

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Why:** Enables pattern extraction and decision tracking for institutional memory.

---

## Agents & Commands

### Available Agents

Specialized agents for different tasks:
- See `.claude/agents/` directory
- Each agent has specific expertise

### Available Commands

Slash commands that guide workflows:
- See `.claude/commands/` directory
- Use `/prime` to discover available commands

### Available Skills

Reusable capabilities:
- See `.claude/skills/` directory
- Composable building blocks

---

## Learning & Improvement

### Extract Patterns (Law 1)
After each session, document:
- What pattern did we discover?
- How can we reuse this?
- What should future agents know?

### Improve the System (Law 2)
Always identify:
- What could be better?
- How much effort? How much impact?
- Should we implement now or later?

### Document Decisions (Law 3)
In commit messages capture:
- **Why** we did this
- **What** we implemented
- **Learning** for future work
- **Impact** (time saved, quality gained)

---

## Troubleshooting

### Agent acting strange?
→ Run `/prime` for guidance
→ Check if context is getting full (40% rule)
→ Start fresh phase with clean context

### Unsure what to do?
→ Read `CONSTITUTION.md` for principles
→ Read `../CLAUDE.md` for project context
→ Use `/prime` command to get help

### Need to understand something?
→ Ask the agent with context
→ Look at git history for patterns
→ Check README files in project

---

## Common Commands

```bash
# View configuration
cat settings.json

# Create personal overrides (optional)
cp settings.json settings.local.json
# Edit settings.local.json with your preferences

# Validate configuration
jq . settings.json  # Check JSON syntax

# See available agents
ls agents/

# See available commands
ls commands/

# See available skills
ls skills/
```

---

## Getting Help

**From AI Agents:**
- `/prime` - Start here if lost
- `/prime-simple-task` - For straightforward work
- `/prime-complex-task` - For complex tasks

**From Documentation:**
- `CONSTITUTION.md` - Laws and principles
- `../CLAUDE.md` - Project kernel
- Project README.md - Project overview

**From Git:**
- `git log --oneline` - Recent work
- `git log -p <file>` - Changes to specific file
- `git blame <file>` - Who changed what, when, why

---

## Remember

> This is not just a configuration file. This is an operating system for AI-assisted development that improves with every use.

Every work session:
- Follows the Five Laws
- Extracts learnings
- Improves the system
- Builds institutional memory

---

**Framework:** AgentOps v1.0.0
**Profile:** {{PROFILE_NAME}}
**Installed:** {{INSTALLATION_DATE}}
**Status:** Ready for AI-assisted development

For more info: https://agentops.dev/docs
