# spec-writer

**Pattern:** [Documentation Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/spec-writer.md`
**Status:** Production
**Model:** inherit
**Color:** purple

## Purpose

Creates detailed specification documents for development based on gathered requirements. This agent transforms raw requirements into structured, implementable specifications that developers can follow.

## Usage

```bash
# Invoke through Claude Code agent system after spec-shaper
# Agent will create formal specification from requirements
```

## Core Responsibilities

1. **Transform Requirements**: Convert requirements into structured specifications
2. **Define Architecture**: Document system design, components, and interactions
3. **Specify Implementation**: Detail technical approach and implementation strategy
4. **Document APIs**: Define interfaces, data structures, and contracts
5. **Create Test Strategy**: Outline testing approach and acceptance criteria

## Workflow

Executes: `{{workflows/specification/write-spec}}`

### Specification Process

1. **Review Requirements**: Read `requirements.md` from spec-shaper
2. **Structure Specification**: Organize into clear sections
3. **Technical Details**: Add architecture, design decisions, implementation approach
4. **Interface Definitions**: Document APIs, data models, component interfaces
5. **Acceptance Criteria**: Define what "done" means
6. **Write Specification**: Create formal `spec.md`

## Outputs

| File | Purpose |
|------|---------|
| `agentops/spec-first-dev/specs/{spec-name}/spec.md` | Formal specification document |

## Specification Structure

Typical `spec.md` includes:

```markdown
# Feature Name

## Overview
Brief description and context

## Requirements
Key requirements from research phase

## Architecture
System design and component overview

## Implementation Approach
Technical strategy and approach

## API/Interface Definitions
Detailed interface specifications

## Data Models
Schemas and data structures

## Testing Strategy
How feature will be validated

## Acceptance Criteria
Definition of done
```

## Standards Compliance

Ensures specification aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns
- Architectural standards

References: `{{standards/*}}`

**Critical:** Specification must NOT conflict with established patterns.

## Pattern Background

This agent implements the **Documentation Pattern**, creating detailed blueprints before implementation begins.

**Theory:** See [Documentation Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Specification before implementation
- Clear architecture before code
- Interfaces before internals
- Acceptance criteria before testing

## Tools

- **Write**: Create specification document
- **Read**: Access requirements, standards, existing code
- **Bash**: Run exploratory commands
- **WebFetch**: Research libraries, frameworks, best practices

## Examples

**Input:**
```
requirements.md with:
- Rate limiting: 100 req/min per user
- Redis backend for distributed storage
- 429 status with Retry-After header
- Configuration via environment variables
```

**Output:**
```markdown
# API Rate Limiting Middleware

## Overview
Middleware for Express.js API to enforce rate limits...

## Architecture
- Redis for distributed state
- Middleware pattern for Express
- Token bucket algorithm

## Implementation Approach
1. Create Express middleware function
2. Connect to Redis cluster
3. Implement token bucket logic
4. Add configuration loader

## API
```javascript
rateLimit(options: RateLimitOptions): RequestHandler
```

## Testing Strategy
- Unit tests for token bucket logic
- Integration tests with Redis
- Load tests for performance
```

## Related Agents

- [spec-shaper](spec-shaper.md) - Preceding: gathered requirements
- [spec-verifier](spec-verifier.md) - Next: verifies specification
- [tasks-list-creator](tasks-list-creator.md) - Following: creates implementation tasks

## Related Guides

- [Writing Effective Specifications](../../how-to/write-specifications.md) (Task Group 8)
- [Specification Templates](../../reference/templates/specification.md) (Task Group 9)

---

**Workflow References:**
- `profiles/default/workflows/specification/write-spec`
