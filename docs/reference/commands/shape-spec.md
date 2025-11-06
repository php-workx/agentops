# /shape-spec

**Pattern:** [Specification Shaping Pattern](../../explanation/patterns/spec-shaping.md) (placeholder)

**Location:** `profiles/default/commands/shape-spec/`

**Variants:** Single-agent, Multi-agent

## Purpose

Initializes a new feature specification and gathers detailed requirements through interactive questioning. Creates structured folder with requirements and visual assets before formal spec writing.

## Usage

```bash
/shape-spec
```

Optionally provide initial description:

```bash
/shape-spec

I want to add a comment system to the blog.
Users should be able to reply to comments, like them, and get notifications.
```

## Workflow

### Multi-Agent Variant (Recommended)

**Location:** `profiles/default/commands/shape-spec/multi-agent/shape-spec.md`

#### Phase 1: Initialize Spec

Delegates to **spec-initializer** subagent to:
- Create dated folder: `specs/YYYY-MM-DD-feature-name/`
- Set up directory structure
- Return folder path

#### Phase 2: Research Requirements

Delegates to **spec-shaper** subagent to:
- Ask clarifying questions about feature
- Request visual assets (mockups, diagrams, screenshots)
- Ask follow-up questions based on answers
- Save findings to `planning/requirements.md`
- Save visuals to `planning/visuals/`

**Interactive Process:**
1. Agent asks numbered questions
2. User provides answers
3. User uploads visual assets if available
4. Agent asks follow-ups based on answers
5. Requirements documented

#### Phase 3: Inform User

Outputs completion message with next steps.

**Agents Used:**
- [spec-initializer](../agents/spec-initializer.md) - Creates spec folder structure
- [spec-shaper](../agents/spec-shaper.md) - Gathers requirements via questions

---

### Single-Agent Variant

**Location:** `profiles/default/commands/shape-spec/single-agent/shape-spec.md`

Progressively loads two phase files:

1. `1-initialize-spec.md` - Create spec folder
2. `2-shape-spec.md` - Gather requirements

Each phase executes in sequence within the same conversation.

---

## When to Use

### Use /shape-spec when:

- Starting new feature with unclear requirements
- Need to explore and clarify scope
- Want to gather requirements before writing formal spec
- Benefit from guided questions
- Have or can create visual mockups

### Skip /shape-spec if:

- Requirements are crystal clear
- Prefer to write spec directly (/write-spec)
- Already have detailed requirements doc

---

## Output Files

```
specs/YYYY-MM-DD-feature-name/
├── planning/
│   ├── requirements.md      # Detailed requirements from questions
│   └── visuals/             # Mockups, diagrams, screenshots
│       ├── mockup-1.png
│       ├── diagram.svg
│       └── ...
└── (spec.md created by /write-spec later)
```

### requirements.md Structure

- Feature overview
- User stories / use cases
- Functional requirements
- Non-functional requirements (performance, security, etc.)
- UI/UX considerations
- Edge cases and constraints
- Dependencies
- Out of scope (explicitly stated)

---

## Examples

### Example 1: Comment System

```bash
/shape-spec

Add threaded comments to blog posts.
```

**spec-shaper asks:**
1. Who can comment? (authenticated users, guests, both?)
2. What actions on comments? (like, flag, edit, delete?)
3. Threading depth? (unlimited, limited to N levels?)
4. Moderation? (pre-approve, post-moderate, auto-filter?)
5. Notifications? (email, in-app, real-time?)
6. Rate limiting? (prevent spam?)

**User provides:**
- Answers to questions
- Mockup of comment UI
- Diagram of notification flow

**Output:**
- `requirements.md` with comprehensive requirements
- `visuals/comment-mockup.png`
- `visuals/notification-flow.svg`

### Example 2: API Authentication

```bash
/shape-spec

Implement OAuth2 authentication for API.
```

**spec-shaper asks:**
1. OAuth2 flows needed? (authorization code, client credentials, refresh?)
2. Token lifetime? (access token, refresh token durations?)
3. Scopes? (granular permissions needed?)
4. External providers? (Google, GitHub, custom only?)
5. Token storage? (database, cache, both?)
6. Revocation support? (can users/admins revoke tokens?)

**User provides:**
- Flow diagram for authorization code grant
- List of required scopes
- Security requirements doc

**Output:**
- `requirements.md` with OAuth2 details
- `visuals/oauth-flow.svg`

---

## Pattern Background

Implements **Specification Shaping Pattern** from 12-Factor AgentOps.

**Theory:** Requirements discovery is iterative. Guided questions surface edge cases and constraints before coding begins.

**Practice:**
- Ask before assuming
- Document decisions explicitly
- Visual aids improve understanding
- Scope boundaries prevent creep

**12-Factor Alignment:**
- Factor II: Progressive Loading - Requirements gathered progressively
- Factor IV: Human in the Loop - User answers shape direction
- Factor VI: Context Preservation - All decisions documented
- Factor IX: Rapid Iteration - Clear requirements enable fast iteration

---

## Interactive Process

### Typical Question Flow

1. **Core Functionality**
   - What should feature do?
   - Who are primary users?
   - What problem does it solve?

2. **Scope Boundaries**
   - What's explicitly in scope?
   - What's explicitly out of scope?
   - What's phase 2?

3. **Technical Constraints**
   - Performance requirements?
   - Security considerations?
   - Integration points?

4. **User Experience**
   - UI/UX patterns to follow?
   - Accessibility requirements?
   - Mobile/responsive needs?

5. **Edge Cases**
   - Error scenarios?
   - Validation rules?
   - Rate limits?

### Visual Assets

**Helpful visuals:**
- UI mockups (Figma, Sketch, hand-drawn)
- Architecture diagrams
- Flow diagrams (user flows, data flows)
- API specifications
- Database schemas

**Formats supported:** PNG, JPG, SVG, PDF

---

## Related Commands

- **Previous:** [/plan-product](plan-product.md) - Plan product first (optional)
- **Next:** [/write-spec](write-spec.md) - Write formal spec from requirements
- **Alternative:** [/write-spec](write-spec.md) - Skip shaping if requirements clear

## Related Guides

- **[How to Shape a Specification](../../how-to/run-shape-spec.md)** - Step-by-step guide for this workflow
- [How to Write a Specification](../../how-to/run-write-spec.md) - Next step after shaping
- [How-To Guide Index](../../how-to/README.md) - All available how-to guides

## Related Agents

- [spec-initializer](../agents/spec-initializer.md) - Creates spec folder
- [spec-shaper](../agents/spec-shaper.md) - Gathers requirements

---

## Tips

1. **Prepare visuals in advance** - Mockups clarify requirements faster than text
2. **Be specific in answers** - "Sub-second response time" better than "fast"
3. **Explicitly state out-of-scope** - Prevents scope creep later
4. **Think about edge cases** - Error handling, validation, rate limits
5. **Consider mobile/responsive** - Often forgotten until implementation

---

## Troubleshooting

**Q: Should I use single-agent or multi-agent variant?**

A: Multi-agent recommended. Separates initialization from requirements gathering cleanly.

**Q: Can I skip /shape-spec and go straight to /write-spec?**

A: Yes, if requirements are clear. /shape-spec is for discovery.

**Q: What if I don't have visual mockups?**

A: That's fine - answer questions based on mental model. Visuals help but aren't required.

**Q: Can I update requirements after shaping?**

A: Yes! Edit `planning/requirements.md` directly. Or re-run /shape-spec to start fresh.

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
