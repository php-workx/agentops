# /create-tasks

**Pattern:** [Task Breakdown Pattern](../../explanation/patterns/task-breakdown.md) (placeholder)

**Location:** `profiles/default/commands/create-tasks/`

**Variants:** Single-agent, Multi-agent

## Purpose

Breaks down specification into strategically grouped, actionable task list. Creates `tasks.md` with task groups that can be implemented incrementally.

## Usage

```bash
/create-tasks
```

Run after `/write-spec` or with existing `spec.md` in spec folder.

## Workflow

### Multi-Agent Variant (Recommended)

**Location:** `profiles/default/commands/create-tasks/multi-agent/create-tasks.md`

#### Phase 1: Get Spec Documents

Verifies presence of:
- `specs/[spec]/spec.md` (required)
- `specs/[spec]/planning/requirements.md` (optional)
- `specs/[spec]/planning/visuals/` (optional)

If missing, asks user to run `/shape-spec` or `/write-spec` first.

#### Phase 2: Create tasks.md

Delegates to **tasks-list-creator** subagent with:
- spec.md
- requirements.md (if present)
- visuals/ (if present)

The tasks-list-creator:
- Analyzes spec comprehensively
- Identifies logical task groupings
- Orders tasks by dependencies
- Estimates complexity/priority
- Creates `tasks.md` in spec folder

#### Phase 3: Inform User

Outputs completion message with next steps.

**Agents Used:**
- [tasks-list-creator](../agents/tasks-list-creator.md) - Creates tasks.md from spec

---

### Single-Agent Variant

**Location:** `profiles/default/commands/create-tasks/single-agent/create-tasks.md`

Progressively loads two phase files:

1. `1-get-spec-requirements.md` - Verify spec documents exist
2. `2-create-tasks-list.md` - Generate tasks.md

Each phase executes in sequence within the same conversation.

---

## When to Use

### Use /create-tasks when:

- Have completed spec.md
- Need structured breakdown for implementation
- Want to implement incrementally in task groups
- Planning to use /implement-tasks or /orchestrate-tasks

### Skip /create-tasks if:

- Spec is trivial (1-2 straightforward tasks)
- Prefer to implement without formal task tracking
- Doing exploratory/prototype work

---

## Output Files

```
specs/YYYY-MM-DD-feature-name/
├── spec.md                  # (from /write-spec)
├── planning/
│   └── requirements.md      # (from /shape-spec)
└── tasks.md                 # Created by /create-tasks
```

### tasks.md Structure

```markdown
# Feature Name - Tasks

## Task Group 1: Foundation Setup
**Priority:** Critical
**Dependencies:** None
**Estimated Time:** 2 hours

- [ ] Task 1.1: Set up database schema
  - Create tables for X, Y, Z
  - Add indexes on commonly queried fields
  - Set up foreign key constraints

- [ ] Task 1.2: Create data models
  - Define model classes
  - Add validation rules
  - Implement serialization

## Task Group 2: Core API Endpoints
**Priority:** Critical
**Dependencies:** Task Group 1
**Estimated Time:** 4 hours

- [ ] Task 2.1: Implement POST /api/resource
  - Validate request payload
  - Create database record
  - Return response with 201 status

- [ ] Task 2.2: Implement GET /api/resource
  - Add pagination support
  - Implement filtering
  - Return paginated response

[... additional task groups ...]
```

---

## Examples

### Example 1: Comment System Tasks

**Input:** Comment system spec.md

**Output tasks.md:**

```markdown
# Comment System - Tasks

## Task Group 1: Database Schema
**Priority:** Critical
**Dependencies:** None
**Estimated Time:** 2 hours

- [ ] Create comments table
  - id, post_id, parent_id, user_id, content, created_at
  - Index on post_id, parent_id
  - Foreign keys to posts and users

- [ ] Create likes table
  - comment_id, user_id, created_at
  - Composite unique index on (comment_id, user_id)

- [ ] Create notifications table
  - user_id, comment_id, read_at, created_at
  - Index on user_id and read_at

## Task Group 2: Comment API
**Priority:** Critical
**Dependencies:** Task Group 1
**Estimated Time:** 4 hours

- [ ] POST /api/posts/:id/comments
  - Validate comment content (max 5000 chars)
  - Check parent_id is valid if replying
  - Enforce max threading depth (3 levels)
  - Create comment record
  - Trigger notification if reply

- [ ] GET /api/posts/:id/comments
  - Paginate results (50 per page)
  - Return threaded structure
  - Include like counts
  - Order by created_at desc

[... 6 more task groups ...]
```

### Example 2: OAuth2 Tasks

**Input:** OAuth2 authentication spec.md

**Output tasks.md:**

```markdown
# OAuth2 Authentication - Tasks

## Task Group 1: Token Infrastructure
**Priority:** Critical
**Dependencies:** None
**Estimated Time:** 3 hours

- [ ] Generate RSA key pair
  - Private key for signing
  - Public key for verification
  - Store securely in environment

- [ ] Create token utilities
  - JWT signing function
  - JWT verification function
  - Token expiration logic

## Task Group 2: Authorization Code Flow
**Priority:** Critical
**Dependencies:** Task Group 1
**Estimated Time:** 6 hours

- [ ] POST /oauth/authorize endpoint
  - Validate client_id
  - Validate redirect_uri
  - Generate authorization code
  - Store code with expiration

- [ ] POST /oauth/token endpoint
  - Validate authorization code
  - Validate client credentials
  - Generate access token (1 hour expiration)
  - Generate refresh token (30 day expiration)
  - Return token response

[... 4 more task groups ...]
```

---

## Task Group Strategy

### Good Task Groups:

1. **Logical cohesion** - Related tasks grouped together
2. **Clear dependencies** - Can't do B before A
3. **Right-sized** - 2-6 hours per group typically
4. **Testable** - Can verify group completion
5. **Ordered strategically** - Foundation → Core → Polish

### Common Task Group Patterns:

- **Foundation**: Database, models, schemas
- **Core API**: Main endpoints and business logic
- **Authentication**: Auth flows, permissions
- **UI Components**: Frontend components
- **Integration**: External service connections
- **Testing**: Test suites and fixtures
- **Documentation**: API docs, guides
- **Deployment**: Config, migrations, monitoring

---

## Pattern Background

Implements **Task Breakdown Pattern** from 12-Factor AgentOps.

**Theory:** Strategic task grouping enables incremental delivery. Clear dependencies prevent rework.

**Practice:**
- Group by logical cohesion
- Order by dependencies
- Size for 2-6 hour chunks
- Include acceptance criteria

**12-Factor Alignment:**
- Factor VIII: Atomic Operations - Each task group is atomic unit
- Factor IX: Rapid Iteration - Incremental implementation
- Factor X: Session Boundaries - Task groups map to sessions
- Factor VI: Context Preservation - Tasks document intent

---

## Task Complexity Estimation

**Simple (1-2 hours):**
- CRUD operations
- Basic validation
- Simple UI components

**Medium (3-4 hours):**
- Complex business logic
- Multiple integrations
- State management

**Complex (5-6 hours):**
- Complex algorithms
- Performance optimization
- Multi-step workflows

**Very Complex (6+ hours):**
- Consider breaking into multiple task groups

---

## Related Commands

- **Previous:** [/write-spec](write-spec.md) - Write spec first
- **Next (Simple):** [/implement-tasks](implement-tasks.md) - Implement tasks
- **Next (Advanced):** [/orchestrate-tasks](orchestrate-tasks.md) - Orchestrate with subagents

## Related Guides

- **[How to Create Tasks](../../how-to/run-create-tasks.md)** - Step-by-step guide for this workflow
- [How to Write a Specification](../../how-to/run-write-spec.md) - Previous step (creating spec)
- [How to Implement Tasks](../../how-to/run-implement-tasks.md) - Next step after creating tasks
- [How-To Guide Index](../../how-to/README.md) - All available how-to guides

## Related Agents

- [tasks-list-creator](../agents/tasks-list-creator.md) - Creates tasks.md

---

## Tips

1. **Start with foundation** - Database, models, core infrastructure first
2. **Group by domain** - Keep related functionality together
3. **Note dependencies explicitly** - Prevents wrong order
4. **Include acceptance criteria** - How will you know task is done?
5. **Right-size groups** - Too large = overwhelming, too small = overhead
6. **Think about testing** - Dedicated testing task group often helpful

---

## Troubleshooting

**Q: Should I use single-agent or multi-agent variant?**

A: Multi-agent recommended. Tasks-list-creator specializes in strategic breakdown.

**Q: Can I modify tasks.md after creation?**

A: Yes! Edit directly. Add/remove/reorder tasks as you learn during implementation.

**Q: How many task groups is typical?**

A: 5-10 for medium features. <5 for simple, >10 for complex.

**Q: Should every task have time estimate?**

A: Task groups should have estimates. Individual tasks optional but helpful.

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
