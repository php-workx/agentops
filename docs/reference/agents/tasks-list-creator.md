# tasks-list-creator

**Pattern:** [Planning Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/tasks-list-creator.md`
**Status:** Production
**Model:** inherit
**Color:** orange

## Purpose

Creates detailed and strategic tasks lists for development of a specification. This agent transforms a verified specification into an ordered, prioritized list of implementation tasks with clear groupings and dependencies.

## Usage

```bash
# Invoke through Claude Code agent system after spec-verifier
# Agent will create implementable tasks list from specification
```

## Core Responsibilities

1. **Decompose Specification**: Break specification into discrete, implementable tasks
2. **Strategic Grouping**: Organize tasks into logical groups (e.g., setup, core features, testing)
3. **Dependency Ordering**: Sequence tasks to respect dependencies
4. **Task Sizing**: Ensure tasks are appropriately sized (not too big or small)
5. **Acceptance Criteria**: Define completion criteria for each task
6. **Priority Assignment**: Mark critical vs. optional tasks

## Workflow

Executes: `{{workflows/implementation/create-tasks-list}}`

### Planning Process

1. **Read Specification**: Review verified `spec.md`
2. **Identify Components**: Extract distinct implementation units
3. **Create Task Hierarchy**: Organize into groups and subtasks
4. **Order Dependencies**: Sequence tasks logically
5. **Add Details**: Include acceptance criteria, estimates, notes
6. **Write Tasks**: Create `tasks.md`

## Outputs

| File | Purpose |
|------|---------|
| `agentops/spec-first-dev/specs/{spec-name}/tasks.md` | Detailed implementation tasks list |

## Tasks List Structure

Typical `tasks.md` format:

```markdown
# Implementation Tasks: Feature Name

## Task Group 1: Setup & Infrastructure
**Priority:** Critical
**Dependencies:** None
**Estimated Time:** 2 hours

- [ ] Task 1.1: Initialize project structure
  - Acceptance: Directory structure matches spec
  - Acceptance: Dependencies installed
- [ ] Task 1.2: Configure Redis connection
  - Acceptance: Successfully connects to Redis
  - Acceptance: Connection pooling configured

## Task Group 2: Core Implementation
**Priority:** Critical
**Dependencies:** Task Group 1
**Estimated Time:** 6 hours

- [ ] Task 2.1: Implement token bucket algorithm
  - Acceptance: Rate limiting logic functional
  - Acceptance: Unit tests pass
- [ ] Task 2.2: Create Express middleware
  - Acceptance: Middleware integrates correctly
  - Acceptance: Returns 429 on limit exceeded

## Task Group 3: Testing & Validation
**Priority:** High
**Dependencies:** Task Group 2
**Estimated Time:** 4 hours

- [ ] Task 3.1: Write integration tests
- [ ] Task 3.2: Run load tests
- [ ] Task 3.3: Validate error handling
```

## Standards Compliance

Ensures tasks list aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns
- Development workflow

References: `{{standards/*}}`

## Pattern Background

This agent implements the **Planning Pattern**, creating detailed execution plans before implementation begins.

**Theory:** See [Planning Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Plan before implement
- Break down complexity
- Respect dependencies
- Clear acceptance criteria
- Strategic grouping

## Tools

- **Write**: Create tasks list
- **Read**: Access specification, requirements, standards
- **Bash**: Run exploratory commands
- **WebFetch**: Research implementation approaches

## Task Sizing Guidelines

**Good Task Size:**
- 30 minutes to 4 hours of work
- Single clear objective
- Testable completion criteria
- Minimal dependencies

**Too Large:**
- Multi-day effort
- Multiple objectives
- Complex dependencies
→ Break into subtasks

**Too Small:**
- Trivial operations (<15 min)
- No clear value
→ Combine with related tasks

## Examples

**Input:**
```
spec.md for API rate limiting middleware
Requirements: Redis backend, Express middleware, token bucket algorithm
```

**Output:**
```markdown
# Implementation Tasks: API Rate Limiting

## Task Group 1: Setup (2h)
- [ ] Initialize npm package
- [ ] Install dependencies (express, redis, ioredis)
- [ ] Configure TypeScript

## Task Group 2: Core (6h)
- [ ] Implement token bucket algorithm
- [ ] Create Redis client wrapper
- [ ] Build Express middleware function
- [ ] Add configuration loader

## Task Group 3: Testing (4h)
- [ ] Unit tests for token bucket
- [ ] Integration tests with Redis
- [ ] Load testing
- [ ] Error scenario testing

## Task Group 4: Documentation (1h)
- [ ] API documentation
- [ ] Configuration guide
- [ ] Example usage
```

## Related Agents

- [spec-verifier](spec-verifier.md) - Preceding: verified specification
- [implementer](implementer.md) - Next: implements tasks
- [implementation-verifier](implementation-verifier.md) - Following: verifies implementation

## Related Guides

- [Creating Effective Tasks Lists](../../how-to/create-tasks-lists.md) (Task Group 8)
- [Task Breakdown Strategies](../../tutorials/task-breakdown.md) (Task Group 7)

---

**Workflow References:**
- `profiles/default/workflows/implementation/create-tasks-list`
