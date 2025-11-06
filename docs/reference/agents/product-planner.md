# product-planner

**Pattern:** [Phase-Based Workflow](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/product-planner.md`
**Status:** Production
**Model:** inherit
**Color:** cyan

## Purpose

Creates comprehensive product documentation including mission, development roadmap, and tech stack specifications. This agent establishes the foundation for all subsequent product development work.

## Usage

```bash
# Invoke through Claude Code agent system
# Agent will prompt for product information
```

## Core Responsibilities

1. **Gather Requirements**: Collect product idea, key features, target users, and additional details
2. **Create Product Documentation**: Generate mission and roadmap files
3. **Define Product Vision**: Establish clear product purpose and differentiators
4. **Plan Development Phases**: Create structured roadmap with prioritized features
5. **Document Product Tech Stack**: Document technology stack for all aspects of the codebase

## Workflow

### Step 1: Gather Product Requirements
Executes: `{{workflows/planning/gather-product-info}}`

Collects comprehensive product information from user through targeted questions.

### Step 2: Create Mission Document
Executes: `{{workflows/planning/create-product-mission}}`

Generates `agentops/spec-first-dev/product/mission.md` with:
- Product purpose
- Target users
- Key differentiators
- Success criteria

### Step 3: Create Development Roadmap
Executes: `{{workflows/planning/create-product-roadmap}}`

Generates `agentops/spec-first-dev/product/roadmap.md` with:
- Prioritized feature list
- Development phases
- Dependencies
- Timeline estimates

### Step 4: Document Tech Stack
Executes: `{{workflows/planning/create-product-tech-stack}}`

Documents technology choices for:
- Frontend frameworks
- Backend systems
- Database technologies
- APIs and integrations
- DevOps tooling

### Step 5: Final Validation

Verifies all product files were created successfully:
- `agentops/spec-first-dev/product/mission.md`
- `agentops/spec-first-dev/product/roadmap.md`

## Outputs

| File | Purpose |
|------|---------|
| `agentops/spec-first-dev/product/mission.md` | Product vision and goals |
| `agentops/spec-first-dev/product/roadmap.md` | Development phases and features |

## Standards Compliance

Ensures product documentation aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns

References: `{{standards/global/*}}`

## Pattern Background

This agent implements the **Phase-Based Workflow** pattern, establishing clear product vision before technical specification work begins.

**Theory:** See [Phase-Based Workflow](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Documentation before implementation
- Clear vision before tactical planning
- User alignment throughout process

## Examples

**Input:**
```
Product: Developer productivity tool
Features: Code analysis, metrics tracking, team insights
Users: Engineering teams, tech leads
```

**Output:**
- Mission document with clear value proposition
- Roadmap with 3-4 development phases
- Tech stack aligned with modern development practices

## Related Agents

- [spec-initializer](spec-initializer.md) - Next step: initialize specific feature specs
- [spec-shaper](spec-shaper.md) - Gather detailed requirements for features
- [spec-writer](spec-writer.md) - Write detailed specifications

## Related Guides

- [Product Planning Guide](../../how-to/product-planning.md) (Task Group 8)
- [Creating Your First Product](../../tutorials/first-product.md) (Task Group 7)

---

**Workflow References:**
- `profiles/default/workflows/planning/gather-product-info`
- `profiles/default/workflows/planning/create-product-mission`
- `profiles/default/workflows/planning/create-product-roadmap`
- `profiles/default/workflows/planning/create-product-tech-stack`
