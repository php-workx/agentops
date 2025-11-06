# How to Create Tasks from a Specification

**Goal:** Break down a specification into strategically grouped, actionable task list

**Time:** 5-10 minutes

**Prerequisites:**
- Completed specification (`spec.md`)
- Optional: Requirements document and visuals

## Overview

The `/create-tasks` workflow analyzes your specification and breaks it down into logical, dependency-ordered task groups. Each task group contains related tasks that can be implemented together, typically in 2-6 hour chunks.

The workflow:
1. Verifies spec.md exists
2. Analyzes spec comprehensively
3. Identifies logical groupings (foundation, core, polish)
4. Orders tasks by dependencies
5. Estimates complexity and priority
6. Creates `tasks.md` with actionable breakdown

This structured breakdown enables incremental implementation and clear progress tracking.

## Steps

### 1. Ensure Specification Exists

Before running `/create-tasks`, you should have:

```
specs/2025-11-06-feature-name/
├── spec.md                  # Required
└── planning/
    ├── requirements.md      # Optional but helpful
    └── visuals/             # Optional
```

If `spec.md` doesn't exist, run `/write-spec` first.

### 2. Start the Workflow

Run the command in your repository:

```bash
/create-tasks
```

**What happens:**
The workflow locates your most recent spec folder and verifies `spec.md` exists.

### 3. Specify Spec Folder (if needed)

If multiple specs exist or auto-detection fails:

```bash
Which spec should I create tasks for?

You: specs/2025-11-06-comment-system
```

### 4. Task Creator Analyzes Spec

The **tasks-list-creator** agent:
- Reads `spec.md` (and requirements.md if present)
- Identifies logical components and groupings
- Determines dependency order
- Estimates complexity/priority
- Creates strategic task breakdown

This happens automatically.

### 5. Review Generated Tasks

The agent creates `tasks.md` in your spec folder:

```bash
cat specs/2025-11-06-feature-name/tasks.md
```

**Typical tasks.md structure:**

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

[... more task groups ...]
```

### 6. Verify Task Organization

Check that tasks are well-organized:

**Quality checklist:**
- [ ] Tasks grouped logically (related work together)
- [ ] Dependencies clearly noted
- [ ] Foundation tasks come before dependent tasks
- [ ] Task groups are right-sized (2-6 hours typically)
- [ ] Each task is actionable (clear what to do)
- [ ] Priority levels make sense (Critical > High > Medium > Low)
- [ ] Testing/documentation tasks included

### 7. Adjust if Needed

**If tasks need refinement:**
- Edit `tasks.md` directly to add/remove/reorder tasks
- Adjust time estimates based on your experience
- Break large task groups into smaller ones
- Add more detail to individual tasks

**If satisfied:**
- Proceed to implementation with `/implement-tasks` or `/orchestrate-tasks`

## Expected Output

After completion, you'll have:

```
specs/2025-11-06-feature-name/
├── spec.md                  # Source specification
├── planning/
│   └── requirements.md      # Original requirements
└── tasks.md                 # Task breakdown (NEW)
```

The `tasks.md` serves as your implementation roadmap.

## Common Task Group Patterns

### Common Groupings:

1. **Foundation** - Database schema, models, core data structures
2. **Core API** - Main endpoints and business logic
3. **Authentication** - Auth flows, permissions, security
4. **UI Components** - Frontend components, views, forms
5. **Integration** - External service connections, webhooks
6. **Validation** - Input validation, error handling, edge cases
7. **Testing** - Test suites, fixtures, test data
8. **Documentation** - API docs, user guides, comments
9. **Deployment** - Configuration, migrations, monitoring
10. **Polish** - Performance optimization, UX refinement

### Dependency Flow:

```
Foundation (database, models)
    ↓
Core API (endpoints, business logic)
    ↓
Authentication (if needed)
    ↓
UI Components (if applicable)
    ↓
Integration (external services)
    ↓
Testing (comprehensive tests)
    ↓
Documentation (guides, API docs)
    ↓
Deployment (config, monitoring)
    ↓
Polish (optimization, refinement)
```

## Common Issues

### Issue: No spec.md found

**Solution:** Run `/write-spec` first to create the specification. `/create-tasks` needs a spec to work from.

### Issue: Tasks too granular or too high-level

**Solution:** Edit `tasks.md` directly:
- **Too granular:** Combine related small tasks into larger ones
- **Too high-level:** Break complex tasks into smaller subtasks with bullet points

### Issue: Task groups are too large (>6 hours)

**Solution:** Split into multiple task groups. Example:
```markdown
# Before
## Task Group 2: Complete API (10 hours)
- [ ] All CRUD endpoints

# After
## Task Group 2: Read API (3 hours)
- [ ] GET endpoints

## Task Group 3: Write API (4 hours)
- [ ] POST/PUT/DELETE endpoints

## Task Group 4: API Validation (3 hours)
- [ ] Request validation
- [ ] Error handling
```

### Issue: Not sure about dependencies

**Solution:** When in doubt, order conservatively:
1. Data/foundation first
2. Backend logic second
3. Frontend third
4. Testing/polish last

You can always reorder during implementation.

### Issue: Want to track progress during implementation

**Solution:** Check off tasks as you complete them:
```markdown
- [x] Task 1.1: Set up database schema ✅
- [x] Task 1.2: Create data models ✅
- [ ] Task 2.1: Implement POST endpoint (in progress)
```

## Next Steps

After creating tasks:

1. **Review task breakdown** - Ensure logical flow and dependencies
2. **Adjust estimates** - Refine based on your experience/context
3. **Start implementation:**
   - **Simple approach:** Use `/implement-tasks` (single-agent execution)
   - **Advanced approach:** Use `/orchestrate-tasks` (multi-agent parallelization)
4. **Track progress** - Check off tasks as you complete them

## Related

- [Command Reference: /create-tasks](../reference/commands/create-tasks.md)
- [Agent Reference: tasks-list-creator](../reference/agents/tasks-list-creator.md)
- [How to Implement Tasks](run-implement-tasks.md)
- [How to Write a Specification](run-write-spec.md)
- [Pattern: Task Breakdown](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Start with foundation tasks** - Database, models, core infrastructure before features
2. **Group by logical domain** - Keep related functionality together
3. **Note dependencies explicitly** - Prevents implementing in wrong order
4. **Include acceptance criteria** - "Done when API returns 200 with valid JSON"
5. **Right-size task groups** - Too large = overwhelming, too small = overhead
6. **Don't forget testing** - Dedicated testing task group often valuable
7. **Plan for documentation** - API docs, user guides, inline comments
8. **Include deployment tasks** - Configuration, migrations, monitoring setup
9. **Leave room for discovery** - Implementation may reveal new tasks
10. **Update as you go** - tasks.md is a living document

## Examples

### Example: Comment System Tasks

**Input:** Comment system spec.md with threading, likes, notifications

**Output tasks.md excerpt:**

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
  - Threading depth constraint (max 3 levels)

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
  - Validate content (max 5000 chars)
  - Check parent_id valid if replying
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

### Example: OAuth2 Tasks

**Input:** OAuth2 authentication spec.md

**Output tasks.md excerpt:**

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
  - JWT signing function (RS256)
  - JWT verification function
  - Token expiration logic
  - Refresh token rotation

## Task Group 2: Authorization Code Flow
**Priority:** Critical
**Dependencies:** Task Group 1
**Estimated Time:** 6 hours

- [ ] POST /oauth/authorize endpoint
  - Validate client_id
  - Validate redirect_uri
  - Generate authorization code
  - Store code with 10-minute expiration

- [ ] POST /oauth/token endpoint
  - Validate authorization code
  - Validate client credentials
  - Generate access token (1 hour exp)
  - Generate refresh token (30 day exp)
  - Return token response

[... 4 more task groups ...]
```
