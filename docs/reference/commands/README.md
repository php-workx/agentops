# Command Reference

Complete reference for all AgentOps slash commands.

## Command Index

### Product Planning

- [/plan-product](#plan-product) - Plan product mission, roadmap, and tech stack

### Specification Workflow

- [/shape-spec](#shape-spec) - Initialize and shape requirements for a new feature
- [/write-spec](#write-spec) - Write formal specification document
- [/create-tasks](#create-tasks) - Break down spec into actionable tasks

### Implementation Workflow

- [/implement-tasks](#implement-tasks) - Execute task implementation
- [/orchestrate-tasks](#orchestrate-tasks) - Advanced multi-agent task orchestration

### Utility Commands

- [/improve-skills](#improve-skills) - Improve Claude Code skill descriptions

---

## Command Overview

### /plan-product

**Pattern:** [Product Planning Pattern](../../explanation/patterns/product-planning.md) (placeholder)

**Location:** `profiles/default/commands/plan-product/`

**Variants:** Single-agent, Multi-agent

Creates comprehensive product documentation including mission, roadmap, and tech stack.

**Agents Used:**
- [product-planner](../agents/product-planner.md) - Gathers requirements and creates product docs

[Full Documentation →](plan-product.md)

---

### /shape-spec

**Pattern:** [Specification Shaping Pattern](../../explanation/patterns/spec-shaping.md) (placeholder)

**Location:** `profiles/default/commands/shape-spec/`

**Variants:** Single-agent, Multi-agent

Initializes a new spec folder and gathers detailed requirements through interactive questions.

**Agents Used:**
- [spec-initializer](../agents/spec-initializer.md) - Creates dated spec folder structure
- [spec-shaper](../agents/spec-shaper.md) - Gathers requirements via questions

[Full Documentation →](shape-spec.md)

---

### /write-spec

**Pattern:** [Specification Writing Pattern](../../explanation/patterns/spec-writing.md) (placeholder)

**Location:** `profiles/default/commands/write-spec/`

**Variants:** Single-agent, Multi-agent

Creates formal specification document from gathered requirements.

**Agents Used:**
- [spec-writer](../agents/spec-writer.md) - Drafts comprehensive spec.md

[Full Documentation →](write-spec.md)

---

### /create-tasks

**Pattern:** [Task Breakdown Pattern](../../explanation/patterns/task-breakdown.md) (placeholder)

**Location:** `profiles/default/commands/create-tasks/`

**Variants:** Single-agent, Multi-agent

Breaks down specification into strategically grouped, actionable task list.

**Agents Used:**
- [tasks-list-creator](../agents/tasks-list-creator.md) - Creates tasks.md from spec

[Full Documentation →](create-tasks.md)

---

### /implement-tasks

**Pattern:** [Implementation Pattern](../../explanation/patterns/implementation.md) (placeholder)

**Location:** `profiles/default/commands/implement-tasks/`

**Variants:** Single-agent, Multi-agent

Executes implementation of tasks from tasks.md with verification.

**Agents Used:**
- [implementer](../agents/implementer.md) - Implements task groups
- [implementation-verifier](../agents/implementation-verifier.md) - Verifies completion

[Full Documentation →](implement-tasks.md)

---

### /orchestrate-tasks

**Pattern:** [Advanced Orchestration Pattern](../../explanation/patterns/orchestration.md) (placeholder)

**Location:** `profiles/default/commands/orchestrate-tasks/`

**Variants:** Single-agent only

Advanced task orchestration with subagent assignment and standards mapping.

**Features:**
- Automatic orchestration.yml generation
- Subagent assignment per task group
- Standards mapping per task group
- Prompt generation for manual execution

[Full Documentation →](orchestrate-tasks.md)

---

### /improve-skills

**Pattern:** [Skill Improvement Pattern](../../explanation/patterns/skill-improvement.md) (placeholder)

**Location:** `profiles/default/commands/improve-skills/`

**Variants:** Single-agent only

Improves Claude Code skill descriptions for better discoverability.

**Agents Used:** None (direct workflow)

[Full Documentation →](improve-skills.md)

---

## Command Workflow Diagrams

### Full Development Flow

```
/plan-product
    ↓
product/mission.md
product/roadmap.md
product/tech-stack.md
    ↓
/shape-spec
    ↓
specs/YYYY-MM-DD-feature/planning/requirements.md
    ↓
/write-spec
    ↓
specs/YYYY-MM-DD-feature/spec.md
    ↓
/create-tasks
    ↓
specs/YYYY-MM-DD-feature/tasks.md
    ↓
/implement-tasks (simple)
OR
/orchestrate-tasks (advanced)
    ↓
Implementation Complete
```

### Agent Invocation Map

```
Command                  → Agents Invoked
--------------------------------------------
/plan-product           → product-planner
/shape-spec             → spec-initializer → spec-shaper
/write-spec             → spec-writer
/create-tasks           → tasks-list-creator
/implement-tasks        → implementer → implementation-verifier
/orchestrate-tasks      → (user assigns subagents dynamically)
/improve-skills         → (none - direct workflow)
```

---

## Command Variants

Most commands have two variants:

### Single-Agent Variant

**Location:** `profiles/default/commands/[command]/single-agent/`

**Structure:**
- Main entry point: `[command].md`
- Phase files: `1-phase-name.md`, `2-phase-name.md`, etc.

**How it works:**
- Main file includes phase files in sequence
- Each phase loaded progressively via `{{@commands/...}}`
- Phases execute in order within single conversation

**Use when:**
- Simple, straightforward workflow
- No need for specialized subagents
- All work happens in one session

### Multi-Agent Variant

**Location:** `profiles/default/commands/[command]/multi-agent/`

**Structure:**
- Single file: `[command].md`

**How it works:**
- Delegates to specialized subagents
- Subagents have their own context and prompts
- Parent command coordinates between subagents

**Use when:**
- Complex multi-step process
- Benefit from specialized agents
- Need isolated contexts per phase

---

## Usage Patterns

### Starting Fresh

```bash
# 1. Plan product (optional but recommended)
/plan-product

# 2. Shape requirements
/shape-spec

# 3. Write formal spec
/write-spec

# 4. Break into tasks
/create-tasks

# 5. Implement
/implement-tasks
```

### Quick Feature Development

```bash
# Skip product planning if already done
/shape-spec
/write-spec
/create-tasks
/implement-tasks
```

### Advanced Orchestration

```bash
# After /create-tasks
/orchestrate-tasks

# Enables:
# - Custom subagent assignment
# - Standards per task group
# - Generated prompts for manual control
```

---

## Cross-References

### How-To Guides

- [Complete Development Workflow](../../how-to/workflows/complete-development-flow.md) (placeholder)
- [Product Planning Guide](../../how-to/workflows/product-planning.md) (placeholder)
- [Specification Workflow](../../how-to/workflows/specification-workflow.md) (placeholder)
- [Implementation Workflow](../../how-to/workflows/implementation-workflow.md) (placeholder)

### Agent Documentation

- [Agent Reference Index](../agents/README.md)
- Individual agent docs: `../agents/[agent-name].md`

### Pattern Background

All commands implement patterns from the [12-Factor AgentOps framework](https://github.com/boshu2/12-factor-agentops).

**Relevant factors:**
- Factor I: Declarative Workflows (all commands use structured YAML/Markdown)
- Factor II: Progressive Loading (single-agent variants use phase-based loading)
- Factor III: Agent Specialization (multi-agent variants delegate to specialists)
- Factor VII: Standards as Code (orchestrate-tasks enables standards mapping)

---

## Command File Format

All command files follow this structure:

```markdown
---
description: Brief command description
---

# Command Content

[Command instructions and workflow]
```

The `description` frontmatter is used by Claude Code for command discovery.

---

## See Also

- [Agent Reference](../agents/README.md)
- [Workflow Patterns](../../explanation/patterns/README.md) (placeholder)
- [How-To Guides](../../how-to/workflows/README.md) (placeholder)
- [12-Factor AgentOps Framework](https://github.com/boshu2/12-factor-agentops)
