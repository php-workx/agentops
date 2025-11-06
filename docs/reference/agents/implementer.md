# implementer

**Pattern:** [Implementation Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/implementer.md`
**Status:** Production
**Model:** inherit
**Color:** red

## Purpose

Implements features by following a given tasks.md specification. This agent is a full-stack developer that executes the planned implementation tasks, writing code, tests, and documentation according to the specification.

## Usage

```bash
# Invoke through Claude Code agent system after tasks-list-creator
# Agent will implement tasks sequentially from tasks.md
```

## Core Responsibilities

1. **Follow Tasks List**: Execute tasks in specified order
2. **Write Code**: Implement features according to specification
3. **Write Tests**: Create unit, integration, and end-to-end tests
4. **Update Documentation**: Document code and APIs
5. **Mark Progress**: Check off completed tasks in tasks.md
6. **Handle Blockers**: Identify and escalate blocking issues

## Workflow

Executes: `{{workflows/implementation/implement-tasks}}`

### Implementation Process

1. **Read Context**: Review spec.md, requirements.md, tasks.md
2. **Execute Task Groups**: Work through tasks sequentially
3. **Write Code**: Implement according to specification and standards
4. **Write Tests**: Ensure code meets acceptance criteria
5. **Update Progress**: Mark tasks complete in tasks.md
6. **Validate**: Run tests and validation before proceeding

## Expertise Areas

This agent has deep expertise in:

- **Frontend**: React, Vue, Angular, HTML/CSS, JavaScript/TypeScript
- **Backend**: Node.js, Python, Go, Java, API development
- **Database**: SQL, NoSQL, data modeling, migrations
- **API Development**: REST, GraphQL, WebSockets
- **Testing**: Unit, integration, E2E, test frameworks
- **DevOps**: CI/CD, containers, deployment

## Standards Compliance

Ensures implementation aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns
- Code quality standards
- Testing requirements

References: `{{standards/*}}`

**Critical:** Code MUST follow established conventions.

## Pattern Background

This agent implements the **Implementation Pattern**, executing planned work according to detailed specifications.

**Theory:** See [Implementation Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Follow the plan
- Test as you go
- Mark progress clearly
- Document decisions
- Validate continuously

## Tools

- **Write**: Create new files
- **Read**: Access specifications, existing code
- **Bash**: Run tests, build commands, validation
- **WebFetch**: Research libraries, APIs, best practices
- **Playwright**: E2E testing when needed

## Implementation Flow

```
1. Read next task from tasks.md
       ↓
2. Implement code following spec
       ↓
3. Write tests for new code
       ↓
4. Run tests to verify
       ↓
5. Mark task complete with [x]
       ↓
6. Proceed to next task
```

## Task Completion Criteria

A task is complete when:
- [ ] Code written and follows standards
- [ ] Tests written and passing
- [ ] Acceptance criteria met
- [ ] Code reviewed (self-review)
- [ ] Documentation updated
- [ ] Task marked [x] in tasks.md

## Examples

**Input:**
```markdown
# tasks.md
## Task Group 1: Setup
- [ ] Task 1.1: Initialize npm package
- [ ] Task 1.2: Install dependencies

## Task Group 2: Core
- [ ] Task 2.1: Implement token bucket algorithm
```

**Implementation:**
```javascript
// Token bucket algorithm implementation
class TokenBucket {
  constructor(capacity, refillRate) {
    this.capacity = capacity;
    this.tokens = capacity;
    this.refillRate = refillRate;
    this.lastRefill = Date.now();
  }

  async consume(tokens = 1) {
    await this.refill();
    if (this.tokens >= tokens) {
      this.tokens -= tokens;
      return true;
    }
    return false;
  }

  async refill() {
    const now = Date.now();
    const timePassed = (now - this.lastRefill) / 1000;
    const tokensToAdd = timePassed * this.refillRate;
    this.tokens = Math.min(this.capacity, this.tokens + tokensToAdd);
    this.lastRefill = now;
  }
}

module.exports = TokenBucket;
```

**Tests:**
```javascript
describe('TokenBucket', () => {
  it('should allow requests within limit', async () => {
    const bucket = new TokenBucket(10, 1);
    expect(await bucket.consume(5)).toBe(true);
    expect(await bucket.consume(5)).toBe(true);
  });

  it('should deny requests over limit', async () => {
    const bucket = new TokenBucket(10, 1);
    await bucket.consume(10);
    expect(await bucket.consume(1)).toBe(false);
  });
});
```

**Progress:**
```markdown
# tasks.md (updated)
## Task Group 1: Setup
- [x] Task 1.1: Initialize npm package
- [x] Task 1.2: Install dependencies

## Task Group 2: Core
- [x] Task 2.1: Implement token bucket algorithm
```

## Handling Blockers

If blocked:
1. Document the blocker clearly
2. Note in tasks.md with `- [ ] [BLOCKED]` prefix
3. Try alternative approaches
4. Escalate if unresolvable

## Related Agents

- [tasks-list-creator](tasks-list-creator.md) - Preceding: created tasks
- [implementation-verifier](implementation-verifier.md) - Next: verifies implementation
- [spec-writer](spec-writer.md) - Reference: original specification

## Related Guides

- [Implementation Best Practices](../../how-to/implement-features.md) (Task Group 8)
- [Testing Strategy](../../how-to/testing.md) (Task Group 8)
- [Code Standards](../../reference/code-standards.md) (Task Group 9)

---

**Workflow References:**
- `profiles/default/workflows/implementation/implement-tasks`
