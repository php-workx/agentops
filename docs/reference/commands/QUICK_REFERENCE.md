# Command Quick Reference

One-page cheat sheet for all AgentOps commands.

---

## Commands Overview

| Command | Purpose | Time | Agents | Output |
|---------|---------|------|--------|--------|
| /plan-product | Product planning | 30-60m | product-planner | product/*.md |
| /shape-spec | Gather requirements | 15-30m | spec-initializer, spec-shaper | planning/requirements.md |
| /write-spec | Write specification | 15-30m | spec-writer | spec.md |
| /create-tasks | Break into tasks | 10-20m | tasks-list-creator | tasks.md |
| /implement-tasks | Implement feature | 2-8h | implementer, verifier | Code + verifications/ |
| /orchestrate-tasks | Advanced orchestration | 2-8h | User-configured | orchestration.yml + code |
| /improve-skills | Improve skill descriptions | 10-20m | None | Improved skills/ |

---

## Full Workflow

```bash
# 1. Plan product (optional, ~1 hour)
/plan-product

# 2. Shape requirements (~30 min)
/shape-spec

# 3. Write formal spec (~30 min)
/write-spec

# 4. Break into tasks (~15 min)
/create-tasks

# 5. Implement (2-8 hours)
/implement-tasks
# OR for advanced control:
/orchestrate-tasks
```

---

## Command Details

### /plan-product

**When:** Starting new product from scratch

**Input:** Product vision, features, target users

**Output:**
- `product/mission.md`
- `product/roadmap.md`
- `product/tech-stack.md`

**Variants:** Single-agent (4 phases), Multi-agent

**Next:** /shape-spec

---

### /shape-spec

**When:** Starting new feature, need requirements

**Input:** Feature idea, optional description

**Output:**
- `specs/YYYY-MM-DD-feature/planning/requirements.md`
- `specs/YYYY-MM-DD-feature/planning/visuals/`

**Variants:** Single-agent (2 phases), Multi-agent

**Interactive:** Yes (asks questions, requests visuals)

**Next:** /write-spec

---

### /write-spec

**When:** Have requirements, need formal spec

**Input:** requirements.md + visuals/

**Output:**
- `specs/YYYY-MM-DD-feature/spec.md`

**Variants:** Single-agent (1 phase), Multi-agent

**Next:** /create-tasks

---

### /create-tasks

**When:** Have spec, need task breakdown

**Input:** spec.md, requirements.md (optional)

**Output:**
- `specs/YYYY-MM-DD-feature/tasks.md`

**Variants:** Single-agent (2 phases), Multi-agent

**Next:** /implement-tasks or /orchestrate-tasks

---

### /implement-tasks

**When:** Have tasks, ready to implement (simple approach)

**Input:** tasks.md

**Output:**
- tasks.md (tasks marked [x])
- Code implementation
- `verifications/final-verification.md`

**Variants:** Single-agent (3 phases), Multi-agent

**Interactive:** Asks which task groups to implement

**Next:** Feature complete

---

### /orchestrate-tasks

**When:** Complex feature, need custom orchestration

**Input:** tasks.md

**Output:**
- `orchestration.yml`
- `implementation/prompts/` (if manual mode)
- Code implementation

**Variants:** Single-agent only

**Features:**
- Custom subagent per task group
- Standards mapping per task group
- Generated prompts for manual control

**Interactive:** Yes (asks for subagent and standards assignments)

**Next:** Feature complete

---

### /improve-skills

**When:** Skills not being discovered/used properly

**Input:** `.claude/skills/*/SKILL.md`

**Output:** Improved skill descriptions

**Variants:** Single-agent only

**Interactive:** Asks which skills to improve

**Next:** None (utility command)

---

## Decision Tree

### Starting Point

```
Do you have product docs?
├─ No  → /plan-product
└─ Yes → Do you have a feature idea?
          ├─ No  → Check product/roadmap.md
          └─ Yes → Are requirements clear?
                   ├─ No  → /shape-spec
                   └─ Yes → Do you have spec.md?
                            ├─ No  → /write-spec
                            └─ Yes → Do you have tasks.md?
                                     ├─ No  → /create-tasks
                                     └─ Yes → Simple or complex feature?
                                              ├─ Simple  → /implement-tasks
                                              └─ Complex → /orchestrate-tasks
```

### Implementation Choice

```
/implement-tasks or /orchestrate-tasks?

Use /implement-tasks if:
- Simple to medium feature
- Same agent can handle all tasks
- Same standards throughout
- Want automatic workflow

Use /orchestrate-tasks if:
- Complex multi-domain feature
- Need specialized agents per domain
- Different standards per task group
- Want fine-grained control
```

---

## Single-Agent vs Multi-Agent

### When to Use Single-Agent

✅ Simple workflow
✅ Phases closely related
✅ Need shared context
✅ Want faster execution
✅ Prefer simplicity

### When to Use Multi-Agent

✅ Complex workflow
✅ Phases independent
✅ Need specialized expertise
✅ Want isolated contexts
✅ Prefer modularity

---

## Common Patterns

### Quick Feature (Skip Product Planning)

```bash
/shape-spec
/write-spec
/create-tasks
/implement-tasks
```

**Time:** 1-2 hours prep + 2-8 hours implementation

---

### Thorough Feature (Full Process)

```bash
/plan-product      # If new product
/shape-spec
/write-spec
/create-tasks
/implement-tasks
```

**Time:** 2-3 hours prep + 2-8 hours implementation

---

### Complex Feature (Advanced)

```bash
/plan-product      # If needed
/shape-spec
/write-spec
/create-tasks
/orchestrate-tasks
```

**Time:** 2-3 hours prep + 2-8 hours implementation

**Benefit:** Custom subagents + standards per task group

---

### Incremental Implementation

```bash
# After /create-tasks
/implement-tasks

"Just implement task groups 1 and 2"

# Later...
/implement-tasks

"Now implement task groups 3 and 4"
```

**Benefit:** Implement in chunks, test progressively

---

## Tips

### Product Planning
- Be specific about target users
- Define success metrics
- Justify tech choices
- Phase roadmap realistically

### Specification
- Prepare visuals in advance
- Be specific in answers ("sub-second" vs "fast")
- Explicitly state out-of-scope
- Think about edge cases

### Task Breakdown
- Start with foundation
- Group by domain
- Note dependencies explicitly
- Right-size groups (2-6 hours)

### Implementation
- Implement incrementally
- Review each task group
- Update docs as you learn
- Read verification report

### Orchestration
- Use domain specialists
- Map standards carefully
- Consider dependencies
- Review orchestration.yml

---

## File Locations

### Commands
`profiles/default/commands/[command-name]/`

### Agents
`profiles/default/agents/[agent-name].md`

### Product Docs
```
product/
├── mission.md
├── roadmap.md
└── tech-stack.md
```

### Spec Structure
```
specs/YYYY-MM-DD-feature-name/
├── spec.md
├── tasks.md
├── orchestration.yml (if using /orchestrate-tasks)
├── planning/
│   ├── requirements.md
│   └── visuals/
├── implementation/
│   └── prompts/ (if manual orchestration)
└── verifications/
    └── final-verification.md
```

---

## Command Flags

### use_claude_code_subagents

**Enabled:** /orchestrate-tasks delegates to subagents automatically

**Disabled:** /orchestrate-tasks generates prompts for manual execution

### standards_as_claude_code_skills

**Enabled:** Standards loaded via Claude Code skills

**Disabled:** Standards explicitly in prompts

---

## Getting Help

### Documentation
- Command index: `docs/reference/commands/README.md`
- Individual commands: `docs/reference/commands/[command].md`
- Agent reference: `docs/reference/agents/README.md`

### Examples
Each command doc includes 2-3 realistic examples

### Troubleshooting
Each command doc includes Q&A section

---

## Quick Links

- [Command Index](README.md)
- [Command Catalog](COMMAND_CATALOG.md)
- [Command-Agent Diagram](COMMAND_AGENT_DIAGRAM.md)
- [Agent Reference](../agents/README.md)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)

---

**Print this page for quick reference during development!**
