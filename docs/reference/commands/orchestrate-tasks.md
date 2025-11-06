# /orchestrate-tasks

**Pattern:** [Advanced Orchestration Pattern](../../explanation/patterns/orchestration.md) (placeholder)

**Location:** `profiles/default/commands/orchestrate-tasks/`

**Variants:** Single-agent only

## Purpose

Advanced task orchestration with custom subagent assignment, standards mapping per task group, and optional prompt generation for manual control. Provides powerful, flexible workflow for complex multi-domain features.

## Usage

```bash
/orchestrate-tasks
```

Run after `/create-tasks` with `tasks.md` in spec folder.

**Note:** This is an interactive command that asks questions to configure orchestration.

## Workflow

**Location:** `profiles/default/commands/orchestrate-tasks/orchestrate-tasks.md`

### Phase 1: Get tasks.md

- Verifies spec has `tasks.md`
- If missing, asks user to run `/create-tasks` first

### Phase 2: Create orchestration.yml

Creates `orchestration.yml` in spec folder with structure:

```yaml
task_groups:
  - name: [task-group-name]
  - name: [task-group-name]
  - name: [task-group-name]
```

Lists all task groups from `tasks.md`.

### Phase 3: Assign Subagents (if enabled)

**If `use_claude_code_subagents` flag enabled:**

Asks user to assign subagent to each task group:

```
Please specify the name of each subagent to be assigned to each task group:

1. database-schema
2. api-endpoints
3. frontend-components
[... all task groups ...]

Simply respond with the subagent names and corresponding task group number.
```

Updates `orchestration.yml`:

```yaml
task_groups:
  - name: database-schema
    claude_code_subagent: backend-specialist
  - name: api-endpoints
    claude_code_subagent: backend-specialist
  - name: frontend-components
    claude_code_subagent: frontend-specialist
```

**Then delegates to assigned subagents:**

For each task group:
- Delegates to assigned subagent
- Provides: task group, spec.md, requirements.md, standards
- Subagent implements and marks tasks [x]

### Phase 4: Assign Standards (if not using skills)

**If `standards_as_claude_code_skills` flag disabled:**

Asks user to assign standards per task group:

```
Please specify the standard(s) that should be used to guide the implementation of each task group:

1. database-schema
2. api-endpoints
3. frontend-components
[... all task groups ...]

For each task group number, you can specify:
"all" to include all standards
"global/*" to include all global standards
"frontend/css.md" to include specific standard
"none" to include no standards
```

Updates `orchestration.yml`:

```yaml
task_groups:
  - name: database-schema
    standards:
      - backend/database.md
      - global/error-handling.md
  - name: api-endpoints
    standards:
      - backend/api-design.md
      - global/*
  - name: frontend-components
    standards:
      - frontend/components.md
      - frontend/css.md
```

### Phase 5: Generate Prompts (if not using subagents)

**If `use_claude_code_subagents` flag disabled:**

Generates prompt files in `specs/[spec]/implementation/prompts/`:

```
implementation/
└── prompts/
    ├── 1-database-schema.md
    ├── 2-api-endpoints.md
    ├── 3-frontend-components.md
    └── ...
```

Each prompt file contains:
- Task group to implement
- Reference to spec.md and requirements.md
- Implementation workflow instructions
- Standards to follow (if applicable)

**Output to user:**

```
Ready to begin implementation of [spec-title]!

Use the following list of prompts to direct implementation:

1. implementation/prompts/1-database-schema.md
2. implementation/prompts/2-api-endpoints.md
3. implementation/prompts/3-frontend-components.md
[...]

Input those prompts into this chat one-by-one or queue them to run in order.

Progress will be tracked in tasks.md
```

**Agents Used:** None (orchestration only, user delegates manually)

---

## When to Use

### Use /orchestrate-tasks when:

- Building complex, multi-domain features
- Want custom subagent per task group
- Need different standards per task group
- Want generated prompts for manual control
- Require fine-grained orchestration control

### Use /implement-tasks instead if:

- Building simple-to-medium features
- Don't need custom subagent assignment
- Same standards apply across all task groups
- Prefer simpler, automatic workflow

---

## Output Files

### With Subagents

```
specs/YYYY-MM-DD-feature-name/
├── spec.md
├── tasks.md                       # Tasks marked [x] by subagents
├── orchestration.yml              # Subagent assignments, standards
└── (implementation in codebase)
```

### With Manual Prompts

```
specs/YYYY-MM-DD-feature-name/
├── spec.md
├── tasks.md                       # Tasks marked [x] manually
├── orchestration.yml              # Standards per task group
├── implementation/
│   └── prompts/
│       ├── 1-task-group-1.md
│       ├── 2-task-group-2.md
│       └── ...
└── (implementation in codebase)
```

---

## Examples

### Example 1: Full-Stack Feature with Subagents

```bash
/orchestrate-tasks
```

**System creates orchestration.yml with task groups.**

**System asks:** "Specify subagent for each task group"

**User responds:**
```
1. backend-specialist
2. backend-specialist
3. frontend-specialist
4. frontend-specialist
5. backend-specialist
```

**System asks:** "Specify standards for each task group"

**User responds:**
```
1. backend/*
2. backend/*, global/*
3. frontend/*
4. frontend/*
5. backend/testing.md, global/*
```

**Final orchestration.yml:**

```yaml
task_groups:
  - name: database-schema
    claude_code_subagent: backend-specialist
    standards:
      - backend/*

  - name: api-endpoints
    claude_code_subagent: backend-specialist
    standards:
      - backend/*
      - global/*

  - name: ui-components
    claude_code_subagent: frontend-specialist
    standards:
      - frontend/*

  - name: user-dashboard
    claude_code_subagent: frontend-specialist
    standards:
      - frontend/*

  - name: integration-tests
    claude_code_subagent: backend-specialist
    standards:
      - backend/testing.md
      - global/*
```

**System delegates to subagents automatically.**

### Example 2: Manual Prompts for Fine Control

```bash
/orchestrate-tasks
```

**With `use_claude_code_subagents` disabled:**

**System generates prompts:**

```
implementation/prompts/
├── 1-database-schema.md
├── 2-api-endpoints.md
├── 3-ui-components.md
├── 4-user-dashboard.md
└── 5-integration-tests.md
```

**Each prompt contains:**

```markdown
We're continuing implementation of Full-Stack Feature by implementing task group 1:

## Implement this task and its sub-tasks:

**Task Group 1: Database Schema**
- [ ] Task 1.1: Create tables
- [ ] Task 1.2: Add indexes
- [ ] Task 1.3: Set up migrations

## Understand the context

Read @specs/YYYY-MM-DD-feature/spec.md to understand context.

Also read:
- @specs/YYYY-MM-DD-feature/planning/requirements.md
- @specs/YYYY-MM-DD-feature/planning/visuals

## Perform the implementation

{{workflows/implementation/implement-tasks}}

## User Standards & Preferences Compliance

Ensure implementation aligns with:

@standards/backend/database.md
@standards/global/error-handling.md
```

**User runs each prompt manually or queues them.**

---

## Pattern Background

Implements **Advanced Orchestration Pattern** from 12-Factor AgentOps.

**Theory:** Complex features benefit from specialized agents and context-specific standards. Orchestration coordinates without coupling.

**Practice:**
- Map specialists to domains
- Apply relevant standards per context
- Generate reusable prompts
- Track orchestration decisions

**12-Factor Alignment:**
- Factor III: Agent Specialization - Custom subagent per domain
- Factor VII: Standards as Code - Standards mapped to task groups
- Factor X: Session Boundaries - Task groups map to sessions
- Factor VI: Context Preservation - orchestration.yml captures decisions

---

## Orchestration Strategies

### Subagent Assignment

**By domain:**
- Backend tasks → backend-specialist
- Frontend tasks → frontend-specialist
- Infrastructure tasks → devops-specialist

**By technology:**
- API tasks → api-specialist
- Database tasks → database-specialist
- UI tasks → ui-specialist

**By complexity:**
- Simple CRUD → implementer
- Complex logic → domain-specialist
- Performance work → optimization-specialist

### Standards Assignment

**All standards:**
```yaml
standards:
  - all
```

**Domain-specific:**
```yaml
standards:
  - backend/*
  - global/*
```

**Specific files:**
```yaml
standards:
  - backend/api-design.md
  - global/error-handling.md
```

**No standards:**
```yaml
# No standards key
```

---

## Configuration Flags

### use_claude_code_subagents

**Enabled:** Delegates to subagents automatically

**Disabled:** Generates prompts for manual execution

**Use case:**
- Enable: Want automatic delegation
- Disable: Want manual control, complex coordination

### standards_as_claude_code_skills

**Enabled:** Standards loaded via Claude Code skills (not in prompts)

**Disabled:** Standards explicitly listed in prompts/orchestration

**Use case:**
- Enable: Standards already in skills
- Disable: Need explicit standards per task group

---

## Related Commands

- **Previous:** [/create-tasks](create-tasks.md) - Create tasks first
- **Alternative:** [/implement-tasks](implement-tasks.md) - Simpler implementation

## Related Guides

- [Orchestration Guide](../../how-to/workflows/orchestration.md) (placeholder)
- [Subagent Configuration](../../how-to/workflows/subagent-config.md) (placeholder)
- [Standards Mapping](../../how-to/workflows/standards-mapping.md) (placeholder)

## Related Agents

- All subagents assigned in orchestration.yml
- No direct agent invocation (user configures)

---

## Tips

1. **Use domain specialists** - Assign subagents by expertise area
2. **Map standards carefully** - Only include relevant standards per group
3. **Consider task dependencies** - Respect orchestration.yml order
4. **Review orchestration.yml** - Captures your coordination decisions
5. **Manual prompts for learning** - Good way to understand workflow

---

## Troubleshooting

**Q: When should I use /orchestrate-tasks vs /implement-tasks?**

A: Use /orchestrate-tasks for:
- Complex multi-domain features
- Need specialized subagents per domain
- Different standards per task group
- Want generated prompts for control

Use /implement-tasks for:
- Simple-to-medium features
- Same agent can handle all tasks
- Same standards apply throughout
- Want simpler automatic workflow

**Q: What if I don't have custom subagents?**

A: Disable `use_claude_code_subagents` flag and use manual prompts instead.

**Q: Can I change orchestration.yml after creation?**

A: Yes! Edit directly to reassign subagents or standards.

**Q: What are "standards"?**

A: User-defined coding standards, patterns, preferences. Located in `standards/` directory.

---

## Advanced Usage

### Custom Workflows

Edit generated prompts before executing to:
- Add custom instructions
- Reference additional docs
- Modify verification steps

### Hybrid Approach

- Use subagents for straightforward task groups
- Use manual prompts for complex, sensitive groups
- Mix both in same orchestration

### Progressive Enhancement

1. Start with /implement-tasks (simple)
2. Move to /orchestrate-tasks as complexity grows
3. Add custom subagents as needs arise

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [/implement-tasks](implement-tasks.md) - Simpler alternative
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
