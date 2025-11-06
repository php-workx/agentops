# How to Write a Specification

**Goal:** Create a comprehensive, formal specification document from requirements

**Time:** 15-20 minutes

**Prerequisites:**
- Gathered requirements (from `/shape-spec` or manually created)
- Optional: Visual mockups or diagrams

## Overview

The `/write-spec` workflow transforms your gathered requirements into a formal, structured specification document (`spec.md`). This specification serves as the single source of truth for feature implementation, containing all technical details, architecture decisions, and implementation guidance.

The workflow analyzes your requirements and visuals, then creates a comprehensive spec with:
- Feature overview and success criteria
- Functional and non-functional requirements
- Architecture and data models
- API contracts and integration points
- User flows and UI patterns
- Testing and deployment strategy

## Steps

### 1. Ensure Requirements Exist

Before running `/write-spec`, you should have requirements gathered either:

**Option A: From /shape-spec** (recommended)
```
specs/2025-11-06-feature-name/
└── planning/
    ├── requirements.md      # Created by /shape-spec
    └── visuals/             # Mockups, diagrams
```

**Option B: Manually created**
- Create `specs/YYYY-MM-DD-feature-name/planning/requirements.md`
- Add any visuals to `specs/YYYY-MM-DD-feature-name/planning/visuals/`

### 2. Start the Workflow

Run the command in your repository:

```bash
/write-spec
```

**What happens:**
The workflow finds your most recent spec folder (or asks you to specify which one) and locates the requirements.

### 3. Specify Spec Folder (if needed)

If multiple spec folders exist or the agent can't auto-detect:

```bash
Which spec folder should I use?

You: specs/2025-11-06-comment-system
```

### 4. Spec Writer Analyzes Requirements

The **spec-writer** agent:
- Reads `planning/requirements.md`
- Reviews any visuals in `planning/visuals/`
- Structures information into formal specification
- Adds technical details and architecture
- Creates implementation guidance

This happens automatically - you just wait for completion.

### 5. Review Generated Specification

The agent creates `spec.md` in your spec folder:

```bash
cat specs/2025-11-06-feature-name/spec.md
```

**Typical spec.md structure:**

1. **Overview** - Feature purpose, user value, success criteria
2. **Requirements** - Functional, non-functional, constraints
3. **Architecture** - Components, data models, APIs, integrations
4. **User Experience** - User flows, UI patterns, interactions
5. **Implementation Approach** - Technical approach, tech choices, migrations
6. **Testing Strategy** - Unit, integration, e2e tests
7. **Deployment** - Rollout strategy, feature flags, monitoring
8. **Open Questions** - Unresolved decisions, dependencies, risks

### 6. Verify Completeness

Check that the spec includes sufficient detail for implementation:

**Quality checklist:**
- [ ] Clear feature purpose and value proposition
- [ ] Measurable success criteria
- [ ] All functional requirements listed
- [ ] Non-functional requirements (performance, security, etc.)
- [ ] Data models with types, constraints, relationships
- [ ] API endpoints with request/response contracts
- [ ] User flows documented
- [ ] Edge cases and error handling specified
- [ ] Testing approach defined
- [ ] Deployment strategy outlined
- [ ] References to visuals/diagrams included

### 7. Refine if Needed

**If spec needs adjustment:**
- Edit `spec.md` directly
- Or re-run `/write-spec` to regenerate
- Add more detail to specific sections

**If satisfied:**
- Proceed to `/create-tasks` to break spec into implementation tasks

## Expected Output

After completion, you'll have:

```
specs/2025-11-06-feature-name/
├── planning/
│   ├── requirements.md      # Input requirements
│   └── visuals/             # Input diagrams
└── spec.md                  # Formal specification (NEW)
```

The `spec.md` is now your single source of truth for implementation.

## Common Issues

### Issue: No requirements.md found

**Solution:** Either:
1. Run `/shape-spec` first to gather requirements
2. Manually create `planning/requirements.md` with your requirements
3. Skip to `/create-tasks` if feature is simple enough

### Issue: Spec lacks technical detail

**Solution:** Spec-writer bases detail level on requirements. If spec is too high-level:
1. Add more detail to `planning/requirements.md` (data models, APIs, etc.)
2. Re-run `/write-spec`
3. Or manually edit `spec.md` to add missing technical details

### Issue: Can I skip /shape-spec and /write-spec?

**Solution:** Yes, if:
- Feature is very simple (1-2 tasks)
- Requirements are crystal clear
- You prefer lightweight documentation

For most features, the spec is valuable as single source of truth.

### Issue: Multiple spec folders, which one?

**Solution:** The workflow asks you to specify. Choose the most recent or the one you're currently working on.

### Issue: Want to update spec during implementation

**Solution:** Absolutely! Specs are living documents. Edit `spec.md` as you discover new requirements or make architecture changes during implementation.

## Next Steps

After writing your specification:

1. **Review and validate** - Share spec with team/stakeholders for feedback
2. **Create task breakdown** - Run `/create-tasks` to break spec into implementation tasks
3. **Start implementation** - Use `/implement-tasks` or `/orchestrate-tasks`
4. **Update as you learn** - Refine spec based on implementation discoveries

## Related

- [Command Reference: /write-spec](../reference/commands/write-spec.md)
- [Agent Reference: spec-writer](../reference/agents/spec-writer.md)
- [How to Shape a Specification](run-shape-spec.md)
- [How to Create Tasks](run-create-tasks.md)
- [Pattern: Specification Writing](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Reference requirements, don't repeat** - Summarize and structure requirements into spec format
2. **Be specific about data models** - Include field types, constraints, indexes, relationships
3. **Document API contracts** - Request/response examples with status codes and error cases
4. **Include diagrams** - Link to `planning/visuals/` files, reference in relevant sections
5. **Specify edge cases explicitly** - Error handling, validation rules, rate limiting
6. **Define measurable success** - "Reduce load time to <500ms" beats "make it fast"
7. **Keep it actionable** - Implementer should be able to proceed without guessing
8. **Document the "why"** - Architecture decisions should include rationale
9. **Note open questions** - Better to explicitly list unknowns than pretend everything is decided
10. **Treat as living document** - Update spec as you learn during implementation

## Examples

### Example: Comment System Spec

**Input (requirements.md summary):**
- Threaded comments (max 3 levels)
- Like/flag functionality
- Email notifications
- Spam filtering

**Output (spec.md excerpt):**

```markdown
# Comment System Specification

## Overview
Add threaded commenting to blog posts enabling user discussion and engagement.

**Success Criteria:**
- Comments load in <500ms
- Support 1000+ comments per post
- <1% spam false positive rate

## Architecture

### Data Model
\`\`\`sql
CREATE TABLE comments (
  id UUID PRIMARY KEY,
  post_id UUID NOT NULL REFERENCES posts(id),
  parent_id UUID REFERENCES comments(id),
  user_id UUID NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  CHECK (char_length(content) <= 5000)
);

CREATE INDEX idx_comments_post ON comments(post_id);
CREATE INDEX idx_comments_parent ON comments(parent_id);
\`\`\`

### API Endpoints

**POST /api/posts/:id/comments**
Request:
\`\`\`json
{
  "content": "Great article!",
  "parent_id": "uuid-or-null"
}
\`\`\`

Response (201):
\`\`\`json
{
  "id": "comment-uuid",
  "created_at": "2025-11-06T10:00:00Z"
}
\`\`\`

[... continues with full specification ...]
```

### Example: OAuth2 Spec

**Input (requirements.md summary):**
- Authorization code flow
- Token refresh
- Scope-based permissions
- Token revocation

**Output (spec.md excerpt):**

```markdown
# OAuth2 Authentication Specification

## Overview
Implement OAuth2 authentication for API access with authorization code flow.

**Success Criteria:**
- Token issuance <200ms
- Support 10,000 active tokens
- Zero token leaks (RS256 signing)

## Architecture

### Token Structure
Access Token (JWT):
\`\`\`json
{
  "user_id": "uuid",
  "scopes": ["read:posts", "write:comments"],
  "exp": 1699200000
}
\`\`\`

Refresh Token:
- Opaque reference stored in database
- 30-day expiration
- Single-use (rotation on refresh)

[... continues with endpoints, flows, security ...]
```
