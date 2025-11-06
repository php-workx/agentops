# How to Shape a Specification

**Goal:** Gather detailed requirements for a feature through interactive questioning and visual assets

**Time:** 15-30 minutes

**Prerequisites:**
- Feature idea (can be rough)
- Optional: Visual mockups, diagrams, or screenshots

## Overview

The `/shape-spec` workflow helps you explore and clarify feature requirements before writing a formal specification. It uses interactive questioning to surface edge cases, constraints, and user needs that might otherwise be missed.

The workflow:
1. Creates a dated specification folder
2. Asks targeted questions about your feature
3. Requests visual assets (mockups, diagrams)
4. Documents all requirements and decisions
5. Saves everything for the `/write-spec` phase

This is particularly useful when requirements aren't crystal clear yet.

## Steps

### 1. Start the Workflow

Run the command in your repository:

```bash
/shape-spec
```

**What happens:**
The workflow initializes a new specification folder with structure like:
```
specs/2025-11-06-feature-name/
└── planning/
    ├── requirements.md  (created during workflow)
    └── visuals/         (for mockups/diagrams)
```

### 2. Describe Your Feature

Provide an initial description of what you want to build:

```bash
/shape-spec

I want to add a comment system to the blog.
Users should be able to reply to comments, like them, and get notifications.
```

Or keep it simple:

```bash
/shape-spec

Add OAuth2 authentication to the API.
```

### 3. Answer Interactive Questions

The **spec-shaper** agent will ask clarifying questions. Typical question flow:

**Core Functionality:**
- What should this feature do?
- Who are the primary users?
- What problem does it solve?

**Scope Boundaries:**
- What's explicitly in scope?
- What's explicitly out of scope?
- What might be phase 2?

**Technical Constraints:**
- Any performance requirements?
- Security considerations?
- Integration points with existing systems?

**User Experience:**
- UI/UX patterns to follow?
- Accessibility requirements?
- Mobile/responsive needs?

**Edge Cases:**
- Error scenarios?
- Validation rules?
- Rate limiting or abuse prevention?

**Example questions for comment system:**

```
1. Who can comment? (authenticated users only, guests, both?)
2. What actions on comments? (like, flag, edit, delete, share?)
3. How deep should threading go? (unlimited, or max 3 levels?)
4. Moderation approach? (pre-approve, post-moderate, auto-filter spam?)
5. Notifications? (email, in-app, real-time websockets?)
6. Rate limiting? (prevent spam, max comments per hour?)
```

**Tips for good answers:**
- Be specific: "Max 3 levels of threading" beats "some threading"
- State constraints: "Sub-second response time" beats "fast"
- Explicit out-of-scope: "No video comments in v1" prevents scope creep
- Think about abuse: "Max 10 comments per user per hour"

### 4. Provide Visual Assets

If you have mockups, diagrams, or screenshots, upload them when prompted.

**Helpful visual types:**
- **UI mockups** - Figma, Sketch, hand-drawn, screenshots
- **Architecture diagrams** - System architecture, data flow
- **Flow diagrams** - User flows, state machines
- **API specifications** - Request/response examples
- **Database schemas** - Table structure, relationships

**Formats supported:** PNG, JPG, SVG, PDF

**Example:**
```
Agent: "Do you have any visual mockups or diagrams?"

You: "Yes, I have a mockup of the comment UI"
[Upload: comment-mockup.png]

You: "And a diagram showing notification flow"
[Upload: notification-flow.svg]
```

**Don't have visuals?** That's fine! Answer questions based on your mental model. Visuals clarify faster but aren't required.

### 5. Review Requirements Document

The agent creates `planning/requirements.md` with structure like:

```markdown
# Feature Name Requirements

## Overview
[Brief description]

## User Stories
- As a [user type], I want [capability] so that [benefit]

## Functional Requirements
- System shall [requirement]
- System must [requirement]

## Non-Functional Requirements
- Performance: [requirement]
- Security: [requirement]
- Accessibility: [requirement]

## UI/UX Considerations
[Design guidelines, patterns]

## Edge Cases and Constraints
- [Error scenario and handling]
- [Validation rule]

## Dependencies
- [External system or service]
- [Internal component]

## Out of Scope (Explicitly Stated)
- [Feature deferred to phase 2]
- [Feature not needed]
```

Review the file:

```bash
cat specs/2025-11-06-feature-name/planning/requirements.md
```

### 6. Refine if Needed

**If requirements need adjustment:**
- Edit `planning/requirements.md` directly
- Or re-run `/shape-spec` to start fresh

**If ready to proceed:**
- Move to `/write-spec` to create formal specification

## Expected Output

After completion, you'll have:

```
specs/2025-11-06-feature-name/
├── planning/
│   ├── requirements.md      # Comprehensive requirements
│   └── visuals/             # Mockups, diagrams, screenshots
│       ├── mockup-1.png
│       ├── flow-diagram.svg
│       └── ...
└── (spec.md created by /write-spec later)
```

## Common Issues

### Issue: Requirements are already crystal clear

**Solution:** Skip `/shape-spec` and go straight to `/write-spec`. Shaping is for requirements discovery, not when everything is already defined.

### Issue: Don't have visual mockups

**Solution:** No problem! Answer questions based on your understanding. Visuals help but aren't mandatory. You can add them later if needed.

### Issue: Not sure how to answer technical questions

**Solution:** Answer to the best of your knowledge. The agent will suggest approaches. You can always refine during `/write-spec` or implementation.

### Issue: Agent asks too many questions

**Solution:** The goal is to surface edge cases early. Better to answer questions now than discover issues during implementation. If truly irrelevant, note "not applicable" or "out of scope."

### Issue: Want to update requirements after shaping

**Solution:** Yes! Edit `planning/requirements.md` directly. Or re-run `/shape-spec` to regenerate from scratch.

## Next Steps

After shaping your specification:

1. **Review requirements** - Check that all edge cases captured
2. **Get feedback** - Share with stakeholders if applicable
3. **Create formal spec** - Run `/write-spec` to write complete specification
4. **Add more visuals** - Drop additional mockups in `planning/visuals/` anytime

## Related

- [Command Reference: /shape-spec](../reference/commands/shape-spec.md)
- [Agent Reference: spec-shaper](../reference/agents/spec-shaper.md)
- [Agent Reference: spec-initializer](../reference/agents/spec-initializer.md)
- [How to Write a Specification](run-write-spec.md)
- [How to Plan a Product](run-plan-product.md)
- [Pattern: Specification Shaping](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Prepare visuals in advance** - Mockups clarify requirements 10x faster than text descriptions
2. **Be specific in answers** - "Sub-second API response" is better than "fast performance"
3. **Explicitly state out-of-scope** - "No mobile app in v1" prevents future scope creep
4. **Think about edge cases early** - Error handling, validation rules, rate limits
5. **Consider accessibility** - Often forgotten until late in implementation
6. **Document the "why"** - Not just what feature does, but why it's needed
7. **Use real examples** - "Like Twitter's threading" is clearer than abstract descriptions
