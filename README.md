# agentops

**Specification-driven operations for AI agent workflows.**

A production-ready system for managing AI agent execution using specs, phases, and institutional memory patterns.

---

## Quick Start

```bash
curl -sSL https://agentops.dev/install.sh | bash
```

---

## What This Is

agentops is an opinionated, working implementation of specification-driven AI agent operations. It provides:

- **Constitutional foundation** - Five Laws and operational rules (always enforced)
- **Core primers** - Interactive context routers for common tasks
- **Profiles** - Different specializations (DevOps, Product Dev, SRE, Security, Data)
- **Git hooks** - Automatic enforcement of best practices
- **Installation system** - Base + project installation pattern

---

## Core Principles

### Specs Drive Everything

The heart of agentops is the pattern:
```
RESEARCH (understand)
  ↓
PLAN (write specs)
  ↓
IMPLEMENT (follow specs)
```

This pattern works across all domains because specs force thinking before execution.

### Constitutional Foundation

Five Laws enforced by git hooks:
1. **Extract Learnings** - Document patterns discovered
2. **Improve Systems** - Identify improvements every session
3. **Document Context** - Capture why, not just what
4. **Prevent Hook Loops** - Automatic safety checks
5. **Guide Workflows** - Suggest relevant patterns

### The 40% Rule

Stay under 40% of token budget per phase to prevent context collapse.

---

## Architecture

```
core/
├── primers/              # Interactive context routers
├── hooks/                # Git enforcement
└── templates/            # Pattern templates

profiles/default/
├── commands/             # Workflow commands
├── workflows/            # Reusable workflow blocks
├── standards/            # Coding standards
└── agents/               # Specialized agents
```

---

## Philosophy

**Convergent Evolution**: Both Agent OS (product development) and Knowledge OS (DevOps) independently discovered the same patterns. This proves specs-driven operations are universal, not domain-specific.

---

## Documentation

See `/Users/fullerbt/workspace/12-factor-agentops` for detailed documentation.

---

## License

MIT
