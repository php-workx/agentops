# /improve-skills

**Pattern:** [Skill Improvement Pattern](../../explanation/patterns/skill-improvement.md) (placeholder)

**Location:** `profiles/default/commands/improve-skills/`

**Variants:** Single-agent only

## Purpose

Improves Claude Code skill descriptions to make them more discoverable and usable. Rewrites skill frontmatter descriptions and adds "When to use this skill" sections.

## Usage

```bash
/improve-skills
```

Interactive command that confirms which skills to improve.

## Workflow

**Location:** `profiles/default/commands/improve-skills/improve-skills.md`

### Step 1: Confirm Skills to Improve

Asks user:

```
Before I proceed with improving your Claude Code Skills, can you confirm that you want me to revise and improve ALL Skills in your .claude/skills/ folder?

If not, then please specify which Skills I should include or exclude.
```

**User options:**
- "All" - Improve all skills
- "Only X, Y, Z" - Specific skills
- "All except A, B" - Exclude specific skills

### Step 2: Analyze Each Skill

For each skill in `.claude/skills/`:

- Reads skill file name
- Reads skill.md content
- Follows link to standards (if present)
- Understands purpose and use cases

### Step 3: Rewrite Skill Description

Rewrites `description` in skill.md frontmatter:

**Guidelines:**
- First sentence: Clear description of what skill does
- Subsequent sentences: Multiple use case examples
- Include file types/extensions where applicable
- Include situations/tools where skill applies
- No maximum length
- Focus on when TO use (not when NOT to use)

**Example:**

Before:
```yaml
---
description: CSS utilities and patterns
---
```

After:
```yaml
---
description: Write Tailwind CSS code and structure front-end UIs using Tailwind CSS utility classes. Use when writing or editing HTML templates, React components, Vue components, or any files containing CSS class names. Use when implementing responsive designs, creating reusable UI components, or applying consistent styling patterns across the application.
---
```

### Step 4: Insert "When to use this skill" Section

Adds H2 section at top of skill.md content:

```markdown
## When to use this skill:

- [Descriptive example A]
- [Descriptive example B]
- [Descriptive example C]
...
```

Examples expand on description use cases.

### Step 5: Advise User on Further Improvements

After all skills improved, displays:

```
All Claude Code Skills have been analyzed and revised!

RECOMMENDATION → Review and revise them further using these tips:

- Make Skills as descriptive as possible
- Use their 'description' frontmatter to tell Claude Code when it should proactively use this skill
- Include all relevant instructions, details and directives within the content of the Skill
- You can link to other files (like your Agent OS standards files) using markdown links
- You can consolidate multiple similar skills into single skills where it makes sense for Claude to find and use them together

For more best practices, refer to the official Claude Code documentation on Skills:
https://docs.claude.com/en/docs/claude-code/skills
```

**Agents Used:** None (direct workflow)

---

## When to Use

### Use /improve-skills when:

- Skills are not being discovered/used by Claude Code
- Skill descriptions are vague or generic
- Want to increase skill usage frequency
- Skills lack clear use cases
- Setting up new skills system

### Skip /improve-skills if:

- Skills already have excellent descriptions
- Don't use Claude Code skills feature
- Skills working perfectly as-is

---

## What Gets Improved

### Skill File Structure

Before:
```markdown
---
description: Basic description
name: skill-name
---

# Skill Name

[Skill content...]
```

After:
```markdown
---
description: Comprehensive description with multiple use cases explaining when to use this skill. Use when writing or editing specific file types. Use when implementing particular features or patterns. Use when working with specific tools or frameworks.
name: skill-name
---

## When to use this skill:

- Writing or editing [file types]
- Implementing [feature types]
- Working with [tools/frameworks]
- Creating [component types]
- Applying [pattern types]

# Skill Name

[Skill content...]
```

### Description Quality Improvements

**Vague → Specific:**

Before: "CSS utilities"

After: "Write Tailwind CSS code using utility classes for responsive design, component styling, and layout patterns. Use when editing HTML, JSX, Vue, or Svelte files containing CSS class names."

**Generic → Use-case focused:**

Before: "Database operations"

After: "Perform database schema migrations, query optimization, and data modeling. Use when creating or modifying database tables, indexes, or constraints. Use when writing SQL queries or ORMs. Use when designing data models or relationships."

**Incomplete → Comprehensive:**

Before: "API design"

After: "Design RESTful APIs following best practices for resource naming, HTTP methods, status codes, and versioning. Use when creating or modifying API endpoints. Use when defining request/response schemas. Use when implementing authentication, pagination, or filtering. Use when writing API documentation."

---

## Examples

### Example 1: Tailwind CSS Skill

**Before:**

```markdown
---
description: Tailwind CSS patterns
name: tailwind-css
---

Use Tailwind utility classes.
```

**After:**

```markdown
---
description: Write Tailwind CSS code and structure front-end UIs using Tailwind CSS utility classes. Use when writing or editing HTML templates, React components (.jsx, .tsx), Vue components (.vue), or any files containing CSS class names. Use when implementing responsive designs, creating reusable UI components, applying hover/focus states, or maintaining consistent spacing and typography across the application.
name: tailwind-css
---

## When to use this skill:

- Writing or editing HTML, JSX, TSX, or Vue files
- Implementing responsive designs with breakpoint utilities (sm:, md:, lg:, xl:)
- Creating reusable UI components with consistent styling
- Applying hover, focus, and active states
- Implementing dark mode with dark: variant
- Setting up spacing, typography, and color systems
- Building layouts with flexbox and grid utilities

[Original skill content...]
```

### Example 2: API Design Skill

**Before:**

```markdown
---
description: REST API guidelines
name: api-design
---

Follow REST principles.
```

**After:**

```markdown
---
description: Design RESTful APIs following best practices for resource naming, HTTP methods, status codes, error handling, and versioning. Use when creating or modifying API endpoints in route files, controller files, or API specification files. Use when defining request/response schemas, implementing authentication middleware, or writing API documentation. Use when designing pagination, filtering, sorting, or batch operations.
name: api-design
---

## When to use this skill:

- Creating or modifying API routes in Express, FastAPI, Django, Rails, etc.
- Defining OpenAPI/Swagger specifications
- Writing controller or handler functions for endpoints
- Implementing request validation and error responses
- Designing resource relationships and nested routes
- Adding authentication/authorization to endpoints
- Implementing pagination, filtering, and sorting
- Writing API documentation or integration tests

[Original skill content...]
```

---

## Pattern Background

Implements **Skill Improvement Pattern** from 12-Factor AgentOps.

**Theory:** Skills are only useful if discoverable. Descriptions act as trigger conditions for Claude Code.

**Practice:**
- Descriptive triggers in frontmatter
- Use case examples guide discovery
- Clear boundaries prevent misuse
- Comprehensive coverage increases usage

**12-Factor Alignment:**
- Factor XII: Continuous Improvement - Skills evolve based on usage
- Factor VI: Context Preservation - Clear descriptions preserve intent
- Factor VII: Standards as Code - Skills encode standards

---

## Skill Description Best Practices

### Do:

- Start with clear "what this skill does" sentence
- List specific file types/extensions
- Include concrete use cases
- Mention tools/frameworks where applicable
- Be verbose - no length limit
- Focus on trigger conditions

### Don't:

- Use vague language ("helps with", "useful for")
- Only describe what skill is (describe when to use)
- Include when NOT to use (focus on positive triggers)
- Keep descriptions short (longer = more discoverable)

### Example Patterns:

**File-based triggers:**
```
Use when writing or editing .tsx, .jsx, .ts, .js files
Use when modifying HTML templates or Vue components
Use when creating or updating database migration files
```

**Feature-based triggers:**
```
Use when implementing authentication flows
Use when creating form validation
Use when optimizing database queries
Use when writing unit tests
```

**Tool-based triggers:**
```
Use when working with Tailwind CSS
Use when using React hooks
Use when configuring Webpack
Use when writing SQL queries
```

---

## Related Commands

- None - Standalone utility command

## Related Guides

- [Skill Configuration](../../how-to/workflows/skill-configuration.md) (placeholder)
- [Standards as Skills](../../how-to/workflows/standards-as-skills.md) (placeholder)

## Related Agents

- None - Direct workflow execution

---

## Tips

1. **Run periodically** - Improve skills as you learn what works
2. **Monitor skill usage** - Track which skills Claude uses
3. **Consolidate similar skills** - Easier for Claude to find one comprehensive skill
4. **Link to standards** - Skills can reference detailed standards files
5. **Test descriptions** - Try triggering skills in conversations

---

## Skill Structure Reference

### Complete Skill File

```markdown
---
description: [Comprehensive description with use cases]
name: skill-name
tools: Read, Write, Edit, Bash  # Optional: limit tools
model: sonnet | opus             # Optional: specify model
---

## When to use this skill:

- [Use case 1]
- [Use case 2]
- [Use case 3]

# Skill Name

## Purpose

[What this skill helps accomplish]

## Guidelines

[Detailed instructions, patterns, preferences]

## Examples

[Code examples demonstrating skill application]

## References

- [Link to standards file]
- [Link to documentation]
```

---

## Troubleshooting

**Q: How often should I run /improve-skills?**

A: Run when:
- Skills aren't being used as expected
- Adding new skills
- Learning which descriptions work best
- After significant codebase changes

**Q: Will this overwrite my skill content?**

A: No. Only modifies:
- Frontmatter description
- Adds "When to use" section at top
- Preserves all other content

**Q: Can I manually edit after running?**

A: Yes! Command provides starting point. Manual refinement recommended.

**Q: How long should descriptions be?**

A: No limit. 2-5 sentences typical. Include all relevant triggers.

---

## See Also

- [Command Index](README.md)
- [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
