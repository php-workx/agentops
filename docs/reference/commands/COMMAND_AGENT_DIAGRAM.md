# Command → Agent Relationship Diagram

Visual representation of which commands invoke which agents.

---

## Full Development Flow with Agents

```
┌─────────────────┐
│  /plan-product  │
└────────┬────────┘
         │
         ├─→ product-planner ───→ product/mission.md
         │                   ───→ product/roadmap.md
         │                   ───→ product/tech-stack.md
         ↓
┌─────────────────┐
│   /shape-spec   │
└────────┬────────┘
         │
         ├─→ spec-initializer ───→ specs/YYYY-MM-DD-feature/ (folder)
         │
         ├─→ spec-shaper ────────→ planning/requirements.md
         │                   ────→ planning/visuals/
         ↓
┌─────────────────┐
│   /write-spec   │
└────────┬────────┘
         │
         ├─→ spec-writer ─────────→ spec.md
         ↓
┌─────────────────┐
│  /create-tasks  │
└────────┬────────┘
         │
         ├─→ tasks-list-creator ──→ tasks.md
         ↓
         ┌─────────────────────────┐
         │  Implementation Choice  │
         └────────┬────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
         ↓                 ↓
┌──────────────┐   ┌───────────────────┐
│ /implement   │   │  /orchestrate     │
│  -tasks      │   │   -tasks          │
└──────┬───────┘   └────────┬──────────┘
       │                    │
       ├─→ implementer      ├─→ (user configures subagents)
       │                    │   e.g., backend-specialist
       │                    │        frontend-specialist
       │                    │        devops-specialist
       │                    │
       ├─→ implementation-  └─→ orchestration.yml
       │    verifier            implementation/prompts/
       │
       ↓
  Implementation Complete
```

---

## Command → Agent Mapping (Tabular)

| Command            | Agents Invoked                              | Output                                |
|--------------------|---------------------------------------------|---------------------------------------|
| /plan-product      | product-planner                             | product/*.md (3 files)                |
| /shape-spec        | spec-initializer, spec-shaper               | specs/*/planning/*                    |
| /write-spec        | spec-writer                                 | specs/*/spec.md                       |
| /create-tasks      | tasks-list-creator                          | specs/*/tasks.md                      |
| /implement-tasks   | implementer, implementation-verifier        | Code + verifications/                 |
| /orchestrate-tasks | (user-configured subagents)                 | orchestration.yml + code              |
| /improve-skills    | (none - direct workflow)                    | Improved .claude/skills/*             |

---

## Agent Specialization Matrix

### Product & Planning Agents

```
product-planner
├── Creates: mission.md
├── Creates: roadmap.md
└── Creates: tech-stack.md
```

### Specification Agents

```
spec-initializer
└── Creates: specs/YYYY-MM-DD-feature/ (folder structure)

spec-shaper
├── Gathers: Requirements via questions
├── Creates: planning/requirements.md
└── Saves: planning/visuals/

spec-writer
└── Creates: spec.md (from requirements + visuals)
```

### Task Management Agents

```
tasks-list-creator
└── Creates: tasks.md (strategically grouped)
```

### Implementation Agents

```
implementer
├── Implements: Task groups from tasks.md
└── Updates: tasks.md (marks [x])

implementation-verifier
├── Verifies: All tasks complete
├── Runs: Tests, lint, build
└── Creates: verifications/final-verification.md
```

### Verification Agents

```
spec-verifier
└── (Not directly invoked by commands)
    Used by: Other agents for validation
```

---

## Multi-Agent Workflow Detail

### /plan-product (Multi-Agent)

```
User invokes /plan-product
         ↓
Command delegates to product-planner subagent
         ↓
product-planner:
  - Asks user questions
  - Gathers product vision, features, users
  - Creates product/mission.md
  - Creates product/roadmap.md
  - Creates product/tech-stack.md
         ↓
Returns to command
         ↓
Command informs user: "Product planning complete!"
```

### /shape-spec (Multi-Agent)

```
User invokes /shape-spec
         ↓
Command delegates to spec-initializer
         ↓
spec-initializer:
  - Creates specs/YYYY-MM-DD-feature/ folder
  - Sets up planning/ subdirectories
  - Returns folder path
         ↓
Command delegates to spec-shaper
         ↓
spec-shaper:
  - Asks clarifying questions
  - Requests visual assets
  - Asks follow-up questions
  - Creates planning/requirements.md
  - Saves visuals to planning/visuals/
         ↓
Returns to command
         ↓
Command informs user: "Spec shaping complete!"
```

### /implement-tasks (Multi-Agent)

```
User invokes /implement-tasks
         ↓
Command asks: "Which task groups?"
         ↓
For each task group:
    Command delegates to implementer subagent
         ↓
    implementer:
      - Reads spec.md, requirements.md
      - Analyzes codebase patterns
      - Implements task group
      - Marks tasks [x] in tasks.md
         ↓
    Returns to command
         ↓
After all task groups complete:
    Command delegates to implementation-verifier
         ↓
    implementation-verifier:
      - Runs tests
      - Checks lint, build
      - Creates verifications/final-verification.md
         ↓
    Returns to command
         ↓
Command informs user: "Implementation complete!"
```

---

## Single-Agent Workflow Detail

### /plan-product (Single-Agent)

```
User invokes /plan-product
         ↓
Command loads phase 1: product-concept.md
  - Gathers product vision, features, users
         ↓
Command loads phase 2: create-mission.md
  - Creates product/mission.md
         ↓
Command loads phase 3: create-roadmap.md
  - Creates product/roadmap.md
         ↓
Command loads phase 4: create-tech-stack.md
  - Creates product/tech-stack.md
         ↓
Command informs user: "Product planning complete!"
```

**Note:** All phases execute in same conversation context (progressive loading).

---

## Orchestration Workflow

### /orchestrate-tasks (Advanced)

```
User invokes /orchestrate-tasks
         ↓
Command reads tasks.md
         ↓
Command creates orchestration.yml with task groups
         ↓
Command asks: "Assign subagent to each task group?"
User responds: backend-specialist, frontend-specialist, etc.
         ↓
Command updates orchestration.yml with subagent assignments
         ↓
Command asks: "Assign standards to each task group?"
User responds: backend/*, frontend/*, global/*, etc.
         ↓
Command updates orchestration.yml with standards
         ↓
IF use_claude_code_subagents enabled:
    For each task group:
        Command delegates to assigned subagent
        Subagent implements task group
        Marks tasks [x]
         ↓
    Returns: Implementation complete
         ↓
ELSE (manual prompts):
    Command generates prompts in implementation/prompts/
    - 1-task-group-1.md
    - 2-task-group-2.md
    - ...
         ↓
    Returns: Prompts generated, run manually
```

---

## Agent Context Boundaries

### Single Conversation Context

**Single-Agent Variants:**
- All phases in same conversation
- Progressive loading via `{{@commands/...}}`
- Shared context across phases
- Good for: Simple-to-medium workflows

### Isolated Contexts

**Multi-Agent Variants:**
- Each subagent has isolated context
- Parent command coordinates
- Subagents don't see each other's context
- Good for: Complex multi-step workflows

---

## When to Use Which Variant

### Use Single-Agent When:

- Simple workflow
- Phases closely related
- Need shared context
- Want faster execution
- Prefer simplicity

### Use Multi-Agent When:

- Complex workflow
- Phases independent
- Need specialized expertise
- Want isolated contexts
- Prefer modularity

---

## Agent Communication Patterns

### Parent → Subagent

```
Parent Command:
  "Use the **product-planner** subagent to..."

  Provides:
  - Product vision
  - Features list
  - Target users

  Instructs:
  - Create mission.md
  - Create roadmap.md
  - Create tech-stack.md
```

### Subagent → Parent

```
Subagent:
  - Executes instructions
  - Creates deliverables
  - Returns completion signal

Parent Command:
  - Receives completion
  - Proceeds to next phase or informs user
```

### User → Command → Agent

```
User: /plan-product
  ↓
Command: "Using product-planner subagent..."
  ↓
product-planner: "What's your product vision?"
  ↓
User: [Provides details]
  ↓
product-planner: [Creates docs]
  ↓
Command: "Product planning complete!"
```

---

## Agent Reusability

### Agents Used by Multiple Commands

**None** - Each agent specialized for specific command(s)

### Command Patterns Used Multiple Times

**Specification Pattern:**
- spec-initializer → spec-shaper → spec-writer
- Used by: /shape-spec, /write-spec

**Implementation Pattern:**
- implementer → implementation-verifier
- Used by: /implement-tasks

---

## Summary Statistics

**Total Commands:** 7

**Total Unique Agents:** 8
- product-planner
- spec-initializer
- spec-shaper
- spec-writer
- tasks-list-creator
- implementer
- implementation-verifier
- spec-verifier (not directly invoked)

**Agent Invocations per Command:**
- /plan-product: 1 agent
- /shape-spec: 2 agents (sequential)
- /write-spec: 1 agent
- /create-tasks: 1 agent
- /implement-tasks: 2 agents (sequential)
- /orchestrate-tasks: N agents (user-configured)
- /improve-skills: 0 agents

**Average Agents per Command:** ~1.3 agents

---

## See Also

- [Command Reference Index](README.md)
- [Command Catalog](COMMAND_CATALOG.md)
- [Agent Reference](../agents/README.md)
- [Task Group 7 Summary](TASK_GROUP_7_SUMMARY.md)
