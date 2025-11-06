# spec-shaper

**Pattern:** [Research Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/spec-shaper.md`
**Status:** Production
**Model:** inherit
**Color:** blue

## Purpose

Gathers comprehensive requirements through targeted questions and visual analysis. This agent performs deep research to understand user needs, technical constraints, and product context before specification writing begins.

## Usage

```bash
# Invoke through Claude Code agent system after spec-initializer
# Agent will ask targeted questions to gather requirements
```

## Core Responsibilities

1. **Requirements Research**: Ask targeted questions to understand feature scope
2. **Visual Analysis**: Analyze screenshots, mockups, or existing interfaces if provided
3. **Technical Discovery**: Identify constraints, dependencies, and integration points
4. **Context Gathering**: Understand user workflows and use cases
5. **Document Findings**: Capture all requirements in structured format

## Workflow

Executes: `{{workflows/specification/research-spec}}`

### Research Process

1. **Initial Analysis**: Review raw idea from spec-initializer
2. **Targeted Questions**: Ask specific questions about:
   - User personas and workflows
   - Technical requirements
   - Performance expectations
   - Integration points
   - Security considerations
3. **Visual Analysis**: If screenshots/mockups provided, analyze:
   - UI/UX patterns
   - Component structure
   - Data flows
   - User interactions
4. **Documentation**: Capture all findings in requirements document

## Outputs

| File | Purpose |
|------|---------|
| `agentops/spec-first-dev/specs/{spec-name}/requirements.md` | Comprehensive requirements document |

## Standards Compliance

Ensures requirements gathering aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns

References: `{{standards/*}}`

**Critical:** Agent verifies requirements do NOT conflict with established standards before proceeding.

## Pattern Background

This agent implements the **Research Pattern**, separating discovery from specification to ensure thorough understanding before committing to implementation approach.

**Theory:** See [Research Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Research before planning
- Questions before assumptions
- Context before code
- Understanding before specification

## Tools

- **Write**: Document requirements
- **Read**: Access existing documentation and standards
- **Bash**: Run exploratory commands
- **WebFetch**: Research external APIs, libraries, or patterns

## Examples

**Input:**
```
Spec: API rate limiting middleware
Idea: Add rate limiting to our API
```

**Research Questions:**
```
1. What rate limits do you want? (requests/minute, burst allowance?)
2. How should limits be scoped? (per-user, per-IP, per-API-key?)
3. What happens when limits are exceeded? (429 status, retry-after header?)
4. Where should limits be configured? (code, environment, database?)
5. Do you need different limits for different endpoints?
6. What storage backend? (Redis, in-memory, distributed cache?)
```

**Output:**
Comprehensive `requirements.md` with all answers documented and organized.

## Related Agents

- [spec-initializer](spec-initializer.md) - Preceding: creates workspace
- [spec-writer](spec-writer.md) - Next: writes formal specification
- [spec-verifier](spec-verifier.md) - Following: verifies specification

## Related Guides

- [Effective Requirements Gathering](../../how-to/gather-requirements.md) (Task Group 8)
- [Requirements Research Process](../../tutorials/requirements-research.md) (Task Group 7)

---

**Workflow References:**
- `profiles/default/workflows/specification/research-spec`
