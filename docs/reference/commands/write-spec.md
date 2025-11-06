# /write-spec

**Pattern:** [Specification Writing Pattern](../../explanation/patterns/spec-writing.md) (placeholder)

**Location:** `profiles/default/commands/write-spec/`

**Variants:** Single-agent, Multi-agent

## Purpose

Creates comprehensive, formal specification document from gathered requirements. Produces structured `spec.md` that serves as single source of truth for feature implementation.

## Usage

```bash
/write-spec
```

Run after `/shape-spec` or with existing requirements in `specs/*/planning/requirements.md`.

## Workflow

### Multi-Agent Variant (Recommended)

**Location:** `profiles/default/commands/write-spec/multi-agent/write-spec.md`

#### Find Spec Folder

Locates most recent spec folder in `specs/*/` or asks user to specify.

#### Delegate to spec-writer

Provides **spec-writer** subagent with:
- Spec folder path
- `planning/requirements.md`
- `planning/visuals/` (if present)

The spec-writer:
- Analyzes requirements and visuals
- Structures information into formal spec
- Creates `spec.md` in spec folder
- Ensures completeness and clarity

#### Inform User

Outputs completion message with next steps.

**Agents Used:**
- [spec-writer](../agents/spec-writer.md) - Drafts comprehensive spec.md

---

### Single-Agent Variant

**Location:** `profiles/default/commands/write-spec/single-agent/write-spec.md`

Directly invokes spec-writing workflow:
- Loads `{{workflows/specification/write-spec}}`
- Checks user standards compliance (if applicable)
- Creates spec.md

Single-phase execution within same conversation.

---

## When to Use

### Use /write-spec when:

- Have completed /shape-spec with requirements.md
- Need formal specification before implementation
- Want structured documentation of feature
- Ready to transition from planning to task breakdown

### Skip /write-spec if:

- Requirements simple enough to go straight to /create-tasks
- Prefer lightweight approach without formal spec
- Doing rapid prototyping without documentation

---

## Output Files

```
specs/YYYY-MM-DD-feature-name/
├── planning/
│   ├── requirements.md      # (from /shape-spec)
│   └── visuals/             # (from /shape-spec)
└── spec.md                  # Created by /write-spec
```

### spec.md Structure

Typical sections:

1. **Overview**
   - Feature purpose
   - User value
   - Success criteria

2. **Requirements**
   - Functional requirements
   - Non-functional requirements
   - Constraints

3. **Architecture**
   - System components
   - Data models
   - API contracts
   - Integration points

4. **User Experience**
   - User flows
   - UI patterns
   - Interactions

5. **Implementation Approach**
   - Technical approach
   - Technology choices
   - Migration strategy (if applicable)

6. **Testing Strategy**
   - Unit tests
   - Integration tests
   - End-to-end tests

7. **Deployment**
   - Rollout strategy
   - Feature flags
   - Monitoring

8. **Open Questions**
   - Unresolved decisions
   - Dependencies
   - Risks

---

## Examples

### Example 1: Comment System Spec

**Input:**
- `requirements.md` with threading, moderation, notifications
- `visuals/comment-mockup.png`
- `visuals/notification-flow.svg`

**Output spec.md:**
```markdown
# Comment System Specification

## Overview
Add threaded commenting to blog posts enabling discussion and engagement.

## Requirements

### Functional
- Users can post comments on blog posts
- Threaded replies (max 3 levels deep)
- Like/unlike comments
- Flag inappropriate comments
- Email notifications for replies

### Non-Functional
- Comments load in <500ms
- Support 1000+ comments per post
- Spam filtering via Akismet

## Architecture

### Data Model
- Comment table: id, post_id, parent_id, user_id, content, created_at
- Like table: comment_id, user_id
- Notification table: user_id, comment_id, read_at

### API Endpoints
- POST /api/posts/:id/comments
- GET /api/posts/:id/comments (paginated)
- POST /api/comments/:id/like
- POST /api/comments/:id/flag

[... continues with full specification ...]
```

### Example 2: OAuth2 API Spec

**Input:**
- `requirements.md` with OAuth2 flows, token management
- `visuals/oauth-flow.svg`

**Output spec.md:**
```markdown
# OAuth2 Authentication Specification

## Overview
Implement OAuth2 authentication for API access with support for authorization code and client credentials flows.

## Requirements

### Functional
- Authorization code flow for user authentication
- Client credentials flow for service-to-service
- Refresh token rotation
- Token revocation
- Scope-based permissions

### Non-Functional
- Tokens signed with RS256
- Access tokens expire in 1 hour
- Refresh tokens expire in 30 days

## Architecture

### Token Structure
- Access token: JWT with user_id, scopes, exp
- Refresh token: Opaque reference, stored in DB

### Endpoints
- POST /oauth/authorize
- POST /oauth/token
- POST /oauth/revoke

[... continues with full specification ...]
```

---

## Pattern Background

Implements **Specification Writing Pattern** from 12-Factor AgentOps.

**Theory:** Formal specification serves as contract between planning and implementation. Clear spec reduces ambiguity and rework.

**Practice:**
- Single source of truth
- Structured, consistent format
- Technical detail sufficient for implementation
- References requirements and visuals

**12-Factor Alignment:**
- Factor I: Declarative - Spec is declarative description of feature
- Factor VI: Context Preservation - Captures all decisions in one place
- Factor VIII: Atomic Operations - Spec defines atomic feature unit
- Factor IX: Rapid Iteration - Clear spec enables fast implementation

---

## Spec Quality Checklist

Good spec.md should:

- [ ] Clearly state feature purpose and value
- [ ] Define success criteria (measurable)
- [ ] List all functional requirements
- [ ] Specify non-functional requirements (performance, security)
- [ ] Include architecture/design decisions
- [ ] Define data models and schemas
- [ ] Document API contracts
- [ ] Describe user flows
- [ ] Include testing strategy
- [ ] Specify deployment approach
- [ ] List open questions/dependencies
- [ ] Reference visuals and diagrams

---

## Related Commands

- **Previous:** [/shape-spec](shape-spec.md) - Gather requirements first
- **Next:** [/create-tasks](create-tasks.md) - Break spec into tasks

## Related Guides

- **[How to Write a Specification](../../how-to/run-write-spec.md)** - Step-by-step guide for this workflow
- [How to Shape a Specification](../../how-to/run-shape-spec.md) - Previous step (requirements gathering)
- [How to Create Tasks](../../how-to/run-create-tasks.md) - Next step after writing spec
- [How-To Guide Index](../../how-to/README.md) - All available how-to guides

## Related Agents

- [spec-writer](../agents/spec-writer.md) - Creates spec.md

---

## Tips

1. **Reference requirements.md** - Don't repeat verbatim, summarize and structure
2. **Be specific about data models** - Include types, constraints, relationships
3. **Document API contracts** - Request/response examples help
4. **Include diagrams** - Link to planning/visuals/
5. **Specify edge cases** - Error handling, validation, rate limits
6. **Define success metrics** - How will you know it's done?

---

## Troubleshooting

**Q: Should I use single-agent or multi-agent variant?**

A: Multi-agent recommended. Spec-writer agent specializes in creating comprehensive specs.

**Q: Can I write spec without /shape-spec?**

A: Yes, if you have requirements.md manually or requirements are simple. Spec-writer needs input to work from.

**Q: How detailed should spec be?**

A: Enough detail that implementer can proceed without guessing. Include data models, APIs, flows.

**Q: Can I update spec after writing?**

A: Yes! Edit spec.md directly. Treat as living document that evolves during implementation.

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
