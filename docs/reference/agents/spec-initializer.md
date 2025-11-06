# spec-initializer

**Pattern:** [Initialization Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/spec-initializer.md`
**Status:** Production
**Model:** sonnet
**Color:** green

## Purpose

Initializes the specification folder structure and saves the user's raw idea. This is the first agent in the specification phase, creating the foundation for detailed requirements gathering.

## Usage

```bash
# Invoke through Claude Code agent system
# Provide raw feature/product idea
```

## Core Responsibilities

1. **Create Spec Folder**: Initialize directory structure for specification artifacts
2. **Save Raw Idea**: Capture user's initial concept without modification
3. **Set Up Workflow**: Prepare structure for subsequent specification phases

## Workflow

Executes: `{{workflows/specification/initialize-spec}}`

### Actions

1. Creates specification directory structure
2. Saves raw user input to initial idea file
3. Prepares for requirements gathering phase

## Outputs

| File/Directory | Purpose |
|----------------|---------|
| `agentops/spec-first-dev/specs/{spec-name}/` | Specification workspace |
| `agentops/spec-first-dev/specs/{spec-name}/idea.md` | Raw user idea (unmodified) |

## Pattern Background

This agent implements the **Initialization Pattern**, establishing clean workspace boundaries before detailed work begins.

**Theory:** See [Initialization Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Capture raw ideas without interpretation
- Establish clear workspace boundaries
- Prepare for structured workflow
- Minimal processing for speed

## Model Selection

Uses **sonnet** for:
- Fast initialization
- Simple file operations
- Cost efficiency
- No complex reasoning required

## Examples

**Input:**
```
"I want to build a CLI tool for managing development environments"
```

**Output:**
```
agentops/spec-first-dev/specs/dev-env-manager/
├── idea.md          # Raw idea captured verbatim
└── (ready for spec-shaper)
```

## Related Agents

- [product-planner](product-planner.md) - Preceding: overall product planning
- [spec-shaper](spec-shaper.md) - Next: gather detailed requirements
- [spec-writer](spec-writer.md) - Following: write formal specification

## Related Guides

- [Starting a New Specification](../../how-to/start-specification.md) (Task Group 8)
- [Specification Workflow](../../tutorials/specification-workflow.md) (Task Group 7)

---

**Workflow References:**
- `profiles/default/workflows/specification/initialize-spec`
