# How to Create a Custom Agent

**Goal:** Build your own specialized agent for a custom workflow

**Time:** 30-60 minutes

**Prerequisites:**
- Understanding of agent workflows and patterns
- Clear use case for your custom agent
- Familiarity with markdown and YAML frontmatter

## Overview

AgentOps lets you create custom agents tailored to your specific needs. An agent is a specialized AI assistant with:
- Defined role and responsibilities
- Specific tools and capabilities
- Structured workflow instructions
- Optional integration with user standards

This guide walks you through creating, testing, and using your own agents.

## Agent Anatomy

### Basic Structure

Every agent is a markdown file with YAML frontmatter:

```markdown
---
name: agent-name
description: Brief description of what this agent does
tools: Write, Read, Bash, WebFetch
color: cyan
model: inherit
---

You are a [role description]. Your role is to [core responsibility].

# [Agent Name]

## Core Responsibilities

1. **Responsibility 1**: Description
2. **Responsibility 2**: Description

## Workflow

### Step 1: [First Step]

[Instructions or workflow reference]

### Step 2: [Second Step]

[More instructions]

## User Standards & Preferences Compliance

IMPORTANT: Ensure [output] is ALIGNED with user's preferences:

{{standards/global/*}}
```

### Frontmatter Fields

**Required:**
- `name` - Agent identifier (kebab-case, e.g., `product-planner`)
- `description` - Brief summary for quick reference
- `tools` - Comma-separated list of tools agent can use

**Optional:**
- `color` - Visual identifier (cyan, red, green, blue, yellow, magenta)
- `model` - Model selection (`inherit` to use default, or specific model)

### Available Tools

Common tools you can grant agents:
- `Read` - Read files from filesystem
- `Write` - Write/create new files
- `Edit` - Edit existing files
- `Bash` - Run shell commands
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `WebFetch` - Fetch web content
- `Playwright` - Browser automation
- `TodoWrite` - Task management

**Tip:** Only grant tools the agent actually needs. Minimal tool sets reduce confusion and improve focus.

### Workflow References

Use `{{workflows/category/workflow-name}}` to load reusable workflow files:

```markdown
### Step 1: Gather Requirements

{{workflows/planning/gather-product-info}}

### Step 2: Create Documentation

{{workflows/planning/create-product-mission}}
```

**Benefits:**
- Reusable across agents
- Centralized maintenance
- Consistent patterns

**Location:** `profiles/default/workflows/`

## Steps to Create Custom Agent

### 1. Identify Your Use Case

**Good use cases for custom agents:**
- Specialized domain knowledge (e.g., security auditing, performance analysis)
- Repetitive workflow automation (e.g., release preparation, changelog generation)
- Domain-specific code generation (e.g., API endpoint scaffolding, database migrations)
- Custom validation/verification (e.g., compliance checking, documentation validation)

**Questions to answer:**
- What specific problem does this agent solve?
- What outputs should it produce?
- What inputs does it need?
- What tools are required?

### 2. Design Agent Workflow

Break down the agent's work into clear steps:

**Example: Release Notes Generator**

```
1. Read Git commit history since last release
2. Group commits by type (feat, fix, docs, etc.)
3. Extract BREAKING CHANGES
4. Format as markdown
5. Create CHANGELOG.md entry
```

**Best practices:**
- 3-7 steps is ideal (not too simple, not too complex)
- Each step should be clear and actionable
- Steps should flow logically
- Include validation/verification steps

### 3. Create Agent File

Create file in appropriate profile:

```bash
# Default profile
touch profiles/default/agents/your-agent-name.md

# Custom profile
touch profiles/custom/agents/your-agent-name.md
```

### 4. Write Agent Definition

**Minimal example:**

```markdown
---
name: release-notes-generator
description: Generates release notes from git commits
tools: Read, Bash, Write
color: green
model: inherit
---

You are a release notes specialist. Your role is to generate structured release notes from git commit history.

# Release Notes Generator

## Core Responsibilities

1. **Analyze Commits**: Read git history since last release
2. **Categorize Changes**: Group by type (features, fixes, breaking changes)
3. **Generate Release Notes**: Create formatted CHANGELOG.md entry

## Workflow

### Step 1: Get Last Release Tag

```bash
# Find most recent release tag
git describe --tags --abbrev=0
```

### Step 2: Analyze Commits Since Release

```bash
# Get commits since last release
git log [last-tag]..HEAD --oneline --no-merges
```

### Step 3: Categorize Commits

Group commits by conventional commit type:
- `feat:` → Features
- `fix:` → Bug Fixes
- `docs:` → Documentation
- `BREAKING CHANGE:` → Breaking Changes (call out separately)

### Step 4: Generate CHANGELOG Entry

Create markdown entry:

```markdown
## [Version] - YYYY-MM-DD

### Features
- Feature 1
- Feature 2

### Bug Fixes
- Fix 1

### BREAKING CHANGES
- Breaking change 1
```

### Step 5: Write to CHANGELOG.md

Prepend new entry to CHANGELOG.md file.
```

**Complete example (with workflow references):**

```markdown
---
name: api-endpoint-generator
description: Generates REST API endpoint scaffolding
tools: Write, Read, Bash, Glob
color: blue
model: inherit
---

You are an API development specialist. Your role is to scaffold REST API endpoints following project conventions.

# API Endpoint Generator

## Core Responsibilities

1. **Analyze Patterns**: Examine existing endpoints for conventions
2. **Generate Endpoint**: Create route, controller, validation
3. **Create Tests**: Scaffold endpoint tests
4. **Update Documentation**: Add API documentation

## Workflow

### Step 1: Analyze Existing Patterns

{{workflows/api/analyze-endpoint-patterns}}

### Step 2: Generate Route Definition

{{workflows/api/create-route}}

### Step 3: Create Controller

{{workflows/api/create-controller}}

### Step 4: Add Validation

{{workflows/api/add-validation}}

### Step 5: Scaffold Tests

{{workflows/api/create-endpoint-tests}}

### Step 6: Update API Documentation

{{workflows/api/update-api-docs}}

## User Standards & Preferences Compliance

IMPORTANT: Ensure generated code follows user's API conventions:

{{standards/api/*}}
{{standards/testing/*}}
```

### 5. Create Workflow Files (Optional)

If using workflow references, create reusable workflow files:

```bash
# Create workflow directory
mkdir -p profiles/default/workflows/api

# Create workflow files
touch profiles/default/workflows/api/analyze-endpoint-patterns.md
touch profiles/default/workflows/api/create-route.md
```

**Workflow file structure:**

```markdown
# Analyze Existing Endpoint Patterns

## Instructions

1. Find existing API endpoints:

```bash
# Find route files
find . -name "routes.js" -o -name "*_routes.py"
```

2. Analyze patterns:
   - URL structure (e.g., `/api/v1/resource` vs `/v1/api/resource`)
   - HTTP methods used
   - Response format (JSON structure)
   - Error handling patterns
   - Authentication/authorization approach

3. Document findings:
   - Common URL patterns
   - Standard response codes
   - Naming conventions
   - File organization
```

### 6. Test Your Agent

Test the agent with a real use case:

**For command-based agent:**
```bash
# Create a test command that invokes your agent
# profiles/default/commands/test-agent/test-agent.md
```

**For subagent:**
Test by invoking from another workflow or command.

**Validation:**
- Does agent complete its workflow successfully?
- Does output match expectations?
- Are all steps executed?
- Does it handle errors gracefully?

### 7. Document Your Agent

Create reference documentation:

```bash
# Create agent reference doc
touch docs/reference/agents/your-agent-name.md
```

Use the template:

```markdown
# [Agent Name]

**Used by:** [Commands that use this agent]

**Purpose:** [What this agent does]

## Inputs

- Input 1
- Input 2

## Outputs

- Output 1
- Output 2

## Workflow Steps

1. Step 1
2. Step 2

## Example Usage

[Example of agent in action]

## Tips

- Tip 1
- Tip 2

## Related

- [Related Command](../commands/command-name.md)
- [Related Pattern](placeholder to 12-factor-agentops)
```

## Examples

### Example 1: Database Migration Generator

```markdown
---
name: migration-generator
description: Generates database migration files from schema changes
tools: Read, Write, Bash, Grep
color: yellow
model: inherit
---

You are a database migration specialist. Your role is to generate safe, reversible database migrations.

# Database Migration Generator

## Core Responsibilities

1. **Analyze Schema Changes**: Compare current and target schemas
2. **Generate Migration**: Create up and down migration files
3. **Add Safety Checks**: Include validations and rollback logic
4. **Update Documentation**: Document migration purpose and risks

## Workflow

### Step 1: Read Target Schema

User provides target schema changes (or you analyze model changes).

### Step 2: Generate Migration File

Create timestamped migration file:

```bash
# Generate migration filename
timestamp=$(date +%Y%m%d%H%M%S)
filename="migrations/${timestamp}_description.sql"
```

### Step 3: Write Up Migration

```sql
-- Migration: [Description]
-- Created: [Timestamp]

BEGIN;

-- Add new column with default
ALTER TABLE users ADD COLUMN status VARCHAR(20) DEFAULT 'active';

-- Backfill existing rows if needed
UPDATE users SET status = 'active' WHERE status IS NULL;

-- Make column NOT NULL after backfill
ALTER TABLE users ALTER COLUMN status SET NOT NULL;

COMMIT;
```

### Step 4: Write Down Migration

```sql
-- Rollback: [Description]

BEGIN;

ALTER TABLE users DROP COLUMN status;

COMMIT;
```

### Step 5: Add Safety Checks

Include pre-migration validations:
- Check table exists
- Check column doesn't exist
- Estimate migration duration
- Require manual confirmation for destructive changes
```

### Example 2: Code Review Agent

```markdown
---
name: code-reviewer
description: Performs automated code review with focus on patterns and best practices
tools: Read, Grep, Glob, Write
color: magenta
model: inherit
---

You are a code review specialist. Your role is to analyze code changes and provide constructive feedback.

# Code Reviewer

## Core Responsibilities

1. **Analyze Changes**: Review code diffs
2. **Check Patterns**: Verify adherence to project patterns
3. **Identify Issues**: Surface bugs, anti-patterns, security issues
4. **Provide Feedback**: Constructive, actionable recommendations

## Workflow

### Step 1: Get Changed Files

```bash
# Get files changed in current branch
git diff --name-only main...HEAD
```

### Step 2: Analyze Each File

For each changed file:
- Check code quality (complexity, duplication)
- Verify naming conventions
- Check error handling
- Review test coverage
- Security scan (SQL injection, XSS, etc.)

### Step 3: Generate Review Report

Create `code-review-report.md`:

```markdown
# Code Review Report

## Summary
- Files reviewed: X
- Issues found: Y
- Suggestions: Z

## Critical Issues
- [Issue 1]

## Recommendations
- [Suggestion 1]

## Positive Observations
- [Good pattern 1]
```

## User Standards & Preferences Compliance

IMPORTANT: Review against user's coding standards:

{{standards/code-quality/*}}
{{standards/security/*}}
```

## Best Practices

### Agent Design

1. **Single Responsibility** - Agent should do one thing well
2. **Clear Workflow** - Steps should be obvious and ordered
3. **Minimal Tools** - Only grant necessary tools
4. **Error Handling** - Include validation and error checks
5. **Documentation** - Explain why, not just what

### Workflow Organization

1. **Reuse Workflows** - Use `{{workflows/*}}` references for common patterns
2. **Logical Grouping** - Group related steps together
3. **Progressive Detail** - High-level first, details in substeps
4. **Validation Steps** - Include verification at key points

### Integration with Standards

If agent outputs code or configuration:
```markdown
## User Standards & Preferences Compliance

IMPORTANT: Ensure [output] aligns with user preferences:

{{standards/global/*}}
{{standards/specific-domain/*}}
```

## Common Issues

### Issue: Agent workflow too complex

**Solution:** Break into multiple specialized agents. One complex agent is harder to maintain than several focused agents.

### Issue: Agent produces inconsistent output

**Solution:** Add more structure to workflow steps. Use templates or examples. Reference existing patterns.

### Issue: Not sure which tools to grant

**Solution:** Start minimal (Read, Write, Bash). Add tools only when needed. Test iteratively.

### Issue: Want to reuse parts of workflow

**Solution:** Extract to `workflows/` directory and reference with `{{workflows/path/file}}`.

## Next Steps

After creating your agent:

1. **Test thoroughly** - Multiple scenarios, edge cases
2. **Document** - Create reference doc in `docs/reference/agents/`
3. **Share** - Consider contributing back if generally useful
4. **Iterate** - Refine based on real usage
5. **Create command** - Build slash command that invokes your agent

## Related

- [Agent Reference Index](../reference/agents/README.md)
- [Existing Agents](../../profiles/default/agents/)
- [Workflow Library](../../profiles/default/workflows/)
- [Command Reference](../reference/commands/README.md)
- [Pattern: Agent Design](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Start simple** - Get basic version working first
2. **Test with real use case** - Don't design in vacuum
3. **Study existing agents** - Learn from working examples
4. **Document as you build** - Don't save documentation for later
5. **Use workflow references** - Don't duplicate common patterns
6. **Include validation** - Verify outputs at key steps
7. **Think about errors** - What could go wrong? Handle gracefully
8. **Consider standards** - Integrate with user preferences when applicable
9. **Name clearly** - Agent name should indicate purpose
10. **Keep focused** - If agent does too much, split it
