# Command Catalog and Audit Report

**Task Group 7: Command Migration**

**Date:** 2025-11-06

**Location:** `/Users/fullerbt/workspace/agentops/profiles/default/commands/`

---

## Executive Summary

**Total Commands:** 7

**Command Variants:**
- Single-agent: 6 commands
- Multi-agent: 6 commands
- Single-agent only: 1 command (orchestrate-tasks)
- Multi-agent only: 0 commands

**Total Command Files:** 22 files

**Agents Invoked:** 8 unique agents

**Organization Status:** ✅ All commands correctly located per spec

**Documentation Status:** ✅ Complete reference documentation created

---

## Command Inventory

### 1. /plan-product

**Purpose:** Plan product mission, roadmap, and tech stack

**Location:** `profiles/default/commands/plan-product/`

**Variants:**
- Single-agent: `single-agent/plan-product.md` (progressive 4-phase)
- Multi-agent: `multi-agent/plan-product.md` (delegates to product-planner)

**Agents Used:**
- product-planner

**Pattern:** Product Planning Pattern

**Phase Files (Single-agent):**
- `1-product-concept.md`
- `2-create-mission.md`
- `3-create-roadmap.md`
- `4-create-tech-stack.md`

**Output:**
- `product/mission.md`
- `product/roadmap.md`
- `product/tech-stack.md`

**Next Step:** /shape-spec or /write-spec

---

### 2. /shape-spec

**Purpose:** Initialize spec and gather requirements via interactive questions

**Location:** `profiles/default/commands/shape-spec/`

**Variants:**
- Single-agent: `single-agent/shape-spec.md` (progressive 2-phase)
- Multi-agent: `multi-agent/shape-spec.md` (delegates to spec-initializer + spec-shaper)

**Agents Used:**
- spec-initializer
- spec-shaper

**Pattern:** Specification Shaping Pattern

**Phase Files (Single-agent):**
- `1-initialize-spec.md`
- `2-shape-spec.md`

**Output:**
- `specs/YYYY-MM-DD-feature/planning/requirements.md`
- `specs/YYYY-MM-DD-feature/planning/visuals/`

**Next Step:** /write-spec

---

### 3. /write-spec

**Purpose:** Write formal specification document from requirements

**Location:** `profiles/default/commands/write-spec/`

**Variants:**
- Single-agent: `single-agent/write-spec.md` (single phase)
- Multi-agent: `multi-agent/write-spec.md` (delegates to spec-writer)

**Agents Used:**
- spec-writer

**Pattern:** Specification Writing Pattern

**Phase Files:** None (single file workflow)

**Output:**
- `specs/YYYY-MM-DD-feature/spec.md`

**Next Step:** /create-tasks

---

### 4. /create-tasks

**Purpose:** Break down spec into strategically grouped task list

**Location:** `profiles/default/commands/create-tasks/`

**Variants:**
- Single-agent: `single-agent/create-tasks.md` (progressive 2-phase)
- Multi-agent: `multi-agent/create-tasks.md` (delegates to tasks-list-creator)

**Agents Used:**
- tasks-list-creator

**Pattern:** Task Breakdown Pattern

**Phase Files (Single-agent):**
- `1-get-spec-requirements.md`
- `2-create-tasks-list.md`

**Output:**
- `specs/YYYY-MM-DD-feature/tasks.md`

**Next Step:** /implement-tasks or /orchestrate-tasks

---

### 5. /implement-tasks

**Purpose:** Execute task implementation with verification

**Location:** `profiles/default/commands/implement-tasks/`

**Variants:**
- Single-agent: `single-agent/implement-tasks.md` (progressive 3-phase)
- Multi-agent: `multi-agent/implement-tasks.md` (delegates to implementer + verifier)

**Agents Used:**
- implementer
- implementation-verifier

**Pattern:** Implementation Pattern

**Phase Files (Single-agent):**
- `1-determine-tasks.md`
- `2-implement-tasks.md`
- `3-verify-implementation.md`

**Output:**
- `specs/YYYY-MM-DD-feature/tasks.md` (tasks marked [x])
- `specs/YYYY-MM-DD-feature/verifications/final-verification.md`
- Implementation files in codebase

**Next Step:** Feature complete

---

### 6. /orchestrate-tasks

**Purpose:** Advanced orchestration with subagent assignment and standards mapping

**Location:** `profiles/default/commands/orchestrate-tasks/`

**Variants:**
- Single-agent only: `orchestrate-tasks.md`

**Agents Used:** None directly (user assigns subagents dynamically)

**Pattern:** Advanced Orchestration Pattern

**Phase Files:** None (single file workflow)

**Features:**
- Automatic orchestration.yml generation
- Subagent assignment per task group
- Standards mapping per task group
- Prompt generation for manual execution

**Output:**
- `specs/YYYY-MM-DD-feature/orchestration.yml`
- `specs/YYYY-MM-DD-feature/implementation/prompts/` (if manual mode)
- Implementation files in codebase

**Next Step:** Feature complete (via orchestrated implementation)

---

### 7. /improve-skills

**Purpose:** Improve Claude Code skill descriptions for better discoverability

**Location:** `profiles/default/commands/improve-skills/`

**Variants:**
- Single-agent only: `improve-skills.md`

**Agents Used:** None (direct workflow)

**Pattern:** Skill Improvement Pattern

**Phase Files:** None (single file workflow)

**Output:**
- Improved skill files in `.claude/skills/*/SKILL.md`

**Next Step:** None (utility command)

---

## Agent Usage Matrix

| Command            | Agents Invoked                              |
|--------------------|---------------------------------------------|
| /plan-product      | product-planner                             |
| /shape-spec        | spec-initializer, spec-shaper               |
| /write-spec        | spec-writer                                 |
| /create-tasks      | tasks-list-creator                          |
| /implement-tasks   | implementer, implementation-verifier        |
| /orchestrate-tasks | (user-configured subagents)                 |
| /improve-skills    | (none - direct workflow)                    |

**Total Unique Agents:** 8
- product-planner
- spec-initializer
- spec-shaper
- spec-writer
- tasks-list-creator
- implementer
- implementation-verifier
- spec-verifier (referenced but not directly used by commands)

---

## Command Flow Diagram

```
Start
  ↓
/plan-product (optional)
  ↓
product/mission.md, roadmap.md, tech-stack.md
  ↓
/shape-spec
  ↓
specs/YYYY-MM-DD-feature/planning/requirements.md + visuals/
  ↓
/write-spec
  ↓
specs/YYYY-MM-DD-feature/spec.md
  ↓
/create-tasks
  ↓
specs/YYYY-MM-DD-feature/tasks.md
  ↓
  ├──→ /implement-tasks (simple, automatic)
  │      ↓
  │    Implementation + Verification
  │
  └──→ /orchestrate-tasks (advanced, configurable)
         ↓
       Orchestrated Implementation + Verification

/improve-skills (utility, run anytime)
  ↓
Improved skill discoverability
```

---

## File Organization Analysis

### Directory Structure

```
profiles/default/commands/
├── plan-product/
│   ├── single-agent/
│   │   ├── plan-product.md
│   │   ├── 1-product-concept.md
│   │   ├── 2-create-mission.md
│   │   ├── 3-create-roadmap.md
│   │   └── 4-create-tech-stack.md
│   └── multi-agent/
│       └── plan-product.md
├── shape-spec/
│   ├── single-agent/
│   │   ├── shape-spec.md
│   │   ├── 1-initialize-spec.md
│   │   └── 2-shape-spec.md
│   └── multi-agent/
│       └── shape-spec.md
├── write-spec/
│   ├── single-agent/
│   │   └── write-spec.md
│   └── multi-agent/
│       └── write-spec.md
├── create-tasks/
│   ├── single-agent/
│   │   ├── create-tasks.md
│   │   ├── 1-get-spec-requirements.md
│   │   └── 2-create-tasks-list.md
│   └── multi-agent/
│       └── create-tasks.md
├── implement-tasks/
│   ├── single-agent/
│   │   ├── implement-tasks.md
│   │   ├── 1-determine-tasks.md
│   │   ├── 2-implement-tasks.md
│   │   └── 3-verify-implementation.md
│   └── multi-agent/
│       └── implement-tasks.md
├── orchestrate-tasks/
│   └── orchestrate-tasks.md
└── improve-skills/
    └── improve-skills.md
```

**Organization Assessment:** ✅ Clean, consistent structure

**Observations:**
- Single-agent variants use progressive phase loading
- Multi-agent variants delegate to specialized agents
- Commands without variants (orchestrate-tasks, improve-skills) at root level
- Naming convention consistent throughout

---

## Pattern Analysis

### Single-Agent Pattern

**Characteristics:**
- Main file includes phase files via `{{@commands/...}}`
- Phases load progressively (JIT)
- All work in single conversation context
- Good for: Simple to medium workflows

**Commands using:**
- /plan-product (4 phases)
- /shape-spec (2 phases)
- /write-spec (1 phase)
- /create-tasks (2 phases)
- /implement-tasks (3 phases)

### Multi-Agent Pattern

**Characteristics:**
- Delegates to specialized subagents
- Each subagent has isolated context
- Coordination via parent command
- Good for: Complex multi-step workflows

**Commands using:**
- /plan-product
- /shape-spec
- /write-spec
- /create-tasks
- /implement-tasks

### Hybrid Pattern

**Characteristics:**
- No multi-agent variant OR no single-agent variant
- Specialized workflow needs
- Direct execution

**Commands using:**
- /orchestrate-tasks (single-agent only, advanced orchestration)
- /improve-skills (single-agent only, utility)

---

## Documentation Cross-References

### Created Documentation

All commands now have comprehensive reference documentation:

1. **Index:** `/Users/fullerbt/workspace/agentops/docs/reference/commands/README.md`
   - Command overview
   - Workflow diagrams
   - Quick reference

2. **Individual Command Docs:**
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/plan-product.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/shape-spec.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/write-spec.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/create-tasks.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/implement-tasks.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/orchestrate-tasks.md`
   - `/Users/fullerbt/workspace/agentops/docs/reference/commands/improve-skills.md`

3. **This Catalog:** `/Users/fullerbt/workspace/agentops/docs/reference/commands/COMMAND_CATALOG.md`

### Cross-References Established

Each command doc includes links to:
- **Agents used** → `../agents/[agent-name].md` (created in Task Group 6)
- **Patterns** → `../../explanation/patterns/[pattern-name].md` (placeholder for Task Group 10)
- **How-to guides** → `../../how-to/workflows/[guide-name].md` (placeholder for Task Group 8)
- **Related commands** → Other command docs

---

## Verification Checklist

- [x] All commands identified and cataloged
- [x] Commands in correct location per spec (`profiles/default/commands/`)
- [x] Each command structure validated (frontmatter, content)
- [x] Reference documentation complete for all commands
- [x] Command index created (README.md)
- [x] Cross-references to agents added
- [x] Cross-references to patterns added (placeholders)
- [x] Cross-references to how-to guides added (placeholders)
- [x] Workflow diagrams included
- [x] Agent usage matrix created
- [x] Examples provided for each command
- [x] Tips and troubleshooting sections included

---

## Recommendations

### For Task Group 8 (How-To Guides)

Create guides that commands reference:
- `complete-development-flow.md` (full workflow)
- `product-planning.md` (using /plan-product)
- `specification-workflow.md` (using /shape-spec, /write-spec)
- `task-breakdown.md` (using /create-tasks)
- `implementation-workflow.md` (using /implement-tasks)
- `orchestration.md` (using /orchestrate-tasks)
- `skill-configuration.md` (using /improve-skills)

### For Task Group 10 (Pattern Documentation)

Create pattern docs that commands reference:
- `product-planning.md`
- `spec-shaping.md`
- `spec-writing.md`
- `task-breakdown.md`
- `implementation.md`
- `orchestration.md`
- `skill-improvement.md`

### Maintenance

**Regular updates needed:**
- Add new commands as they're created
- Update agent references when agents change
- Refresh examples based on real usage
- Expand troubleshooting based on user questions

---

## Conclusion

**Task Group 7 Status:** ✅ Complete

All commands have been:
- Identified and cataloged
- Verified in correct location
- Documented comprehensively
- Cross-referenced to agents and patterns
- Organized into clear reference structure

**Next Steps:**
- Task Group 8: Create how-to guides that commands reference
- Task Group 10: Create pattern documentation that commands reference

**Deliverables:**
- ✅ Command catalog (this file)
- ✅ Reference documentation for 7 commands
- ✅ Command index (README.md)
- ✅ Agent usage matrix
- ✅ Workflow diagrams
- ✅ Cross-references established
