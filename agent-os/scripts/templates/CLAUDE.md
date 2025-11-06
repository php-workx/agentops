# {{PROJECT_NAME}} - Claude Code Configuration

**Project Kernel for AI Agent Operations**

Local configuration for Claude Code at project root. Extends and coordinates AgentOps framework.

---

## What Is This?

This file guides Claude Code and AI agents working in this repository:

- **Framework Principles** - Five Laws of an Agent, operating principles
- **Workflow Suggestions** - Relevant patterns for common tasks
- **Context Guide** - What's important, what to read first
- **Decision Rationale** - Why we do things the way we do

---

## Quick Start (Choose Your Task)

### "I want to use AI agents to help with development"

1. Read CONSTITUTION.md (Five Laws - your operating principles)
2. Understand the five laws guide all work here
3. Use `/prime-simple-task` or `/prime-complex-task` to get started
4. Follow agent guidance, extract learnings afterward

### "I want to understand how this project is structured"

1. Check the relevant README files in directories
2. Look at git history for context: `git log --oneline`
3. Understand semantic commits: `feat()`, `fix()`, `docs()`
4. Ask an agent: Use `/prime` for navigation help

### "I want to improve how we work"

1. Read Five Laws - especially Law 2 (improve)
2. Identify improvement opportunity
3. Document rationale and expected impact
4. Propose in commit message or discussion
5. Make improvement and commit with semantic message

---

## AgentOps Framework (Inherited)

This project uses **AgentOps** - a universal operating system for AI agents:

### Four Universal Patterns

1. **Multi-Phase Workflow** - Research → Plan → Implement (fresh context per phase)
2. **Context Bundles** - Compress context for multi-day projects (5:1 to 10:1)
3. **Multi-Agent Orchestration** - Parallel agents for 3x speedup
4. **Intelligent Routing** - Auto-recommend best-fit agent (90.9% accuracy)

### The 40% Rule

Never exceed 40% context window utilization per phase:

- Prevents degradation and hallucinations
- Enables multi-day projects with fresh context
- Allows JIT (Just-In-Time) loading of context

---

## Constitutional Foundation

### Five Laws (ALWAYS Enforced)

All AI agents and developers follow these:

1. **ALWAYS Extract Learnings** - Document patterns discovered
2. **ALWAYS Improve Self or System** - Identify ≥1 improvement/session
3. **ALWAYS Document Context** - Capture why/what/learning/impact
4. **ALWAYS Prevent Hook Loops** - Don't commit hook-modified files
5. **ALWAYS Guide with Workflows** - Suggest workflows, never prescribe

See CONSTITUTION.md for full details.

### Three Rules (Never Forget)

1. ❌ **NEVER break the Five Laws** - Constitutional constraints
2. ✅ **ALWAYS use semantic commits** - `feat()`, `fix()`, `docs()`
3. ✅ **ALWAYS extract patterns** - Every discovery becomes reusable

---

## Workflow Suggestions

### Before Starting Any Work

- [ ] Read CONSTITUTION.md
- [ ] Understand what you're trying to achieve
- [ ] Choose appropriate workflow (simple task vs complex task)
- [ ] Ask an agent if uncertain: `/prime` or `/prime-simple-task`

### After Completing Work

- [ ] Extract learnings (Law 1)
- [ ] Identify improvements (Law 2)
- [ ] Document context (Law 3)
- [ ] Commit with semantic message
- [ ] Check if hooks modified files (Law 4)

---

## Key Files

| File | Purpose | Read When |
|------|---------|-----------|
| **CONSTITUTION.md** | Five Laws, operating principles | Every session (2 min) |
| **README.md** | Project overview | First time or lost |
| **.gitignore** | Ignored files | Adding new file types |
| **Makefile** | Project tasks | Need to run something |

---

## Semantic Commit Format

All commits follow this pattern:

```
<type>(<scope>): <subject>

<optional body explaining why>

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Examples:**
```
feat(auth): Add OAuth2 provider support
docs(readme): Clarify installation steps
fix(api): Handle timeout errors gracefully
refactor(database): Consolidate query builders
test(validation): Add email format tests
```

---

## Decision Log

Significant decisions and their rationale:

**Framework Choice:** AgentOps
- **Why:** Enables 40x speedup in AI-assisted workflows
- **Trade-offs:** Some operational overhead for much faster delivery
- **Alternative:** Manual AI prompts (slower, less systematic)

**Semantic Commits:** Mandatory
- **Why:** Enables pattern extraction and decision tracking
- **Trade-offs:** More time per commit for better context
- **Alternative:** Freeform commits (loses institutional memory)

---

## Getting Help

### From AI Agents

Use slash commands to get agent help:

- `/prime` - Interactive guide (where to start?)
- `/prime-simple-task` - For straightforward work
- `/prime-complex-task` - For research/planning work
- `/prime-debug` - For troubleshooting

### From Documentation

- **General questions?** → Check README.md
- **How to commit?** → Read CONSTITUTION.md
- **Specific task?** → Ask an agent with `/prime`

### From Humans

- **Project decisions?** → Check git log and commit messages
- **Architectural choices?** → Read decisions section above
- **Team practices?** → Ask team members or look at recent commits

---

## Continuous Improvement

Every work session should improve something:

**Improvements Log** (recent):
- Date | Improvement | Impact
- (auto-updated after each session)

As you work, consider:
- Is there a pattern we keep repeating? (extract as reusable)
- Is there a pain point? (fix or document)
- Is there a way to make this faster? (optimize)

Document your improvements in commit messages!

---

## AgentOps Status

**Framework:** v1.0.0 (Production)
**Profile:** Default (universal patterns)
**Last Updated:** {{INSTALLATION_DATE}}

---

## Remember

> "This is not a tool you use. This is an operating system you improve as you work."

Every decision is an opportunity to learn. Every task is a chance to improve. Every session compounds into institutional memory.

---

**Project Kernel Last Updated:** {{INSTALLATION_DATE}}
**Framework:** AgentOps v1.0.0
**Status:** Ready for AI-assisted development
