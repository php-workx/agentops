# spec-verifier

**Pattern:** [Verification Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/spec-verifier.md`
**Status:** Production
**Model:** sonnet
**Color:** pink

## Purpose

Verifies the specification and tasks list to ensure completeness, consistency, and alignment with user standards before implementation begins.

## Usage

```bash
# Invoke through Claude Code agent system after spec-writer
# Agent will verify specification quality and completeness
```

## Core Responsibilities

1. **Specification Review**: Verify specification completeness and clarity
2. **Requirements Traceability**: Ensure all requirements are addressed
3. **Standards Compliance**: Verify alignment with user's tech stack and patterns
4. **Consistency Check**: Validate internal consistency of specification
5. **Gap Analysis**: Identify missing details or ambiguities

## Workflow

Executes: `{{workflows/specification/verify-spec}}`

### Verification Process

1. **Read Specification**: Review `spec.md` and `requirements.md`
2. **Completeness Check**: Verify all sections present and detailed
3. **Requirements Coverage**: Confirm all requirements addressed
4. **Standards Alignment**: Check against user's coding conventions
5. **Consistency Validation**: Ensure no internal contradictions
6. **Gap Identification**: Find missing details or ambiguities
7. **Report Findings**: Document verification results

## Verification Checklist

### Completeness
- [ ] Overview section present and clear
- [ ] All requirements addressed
- [ ] Architecture documented
- [ ] Implementation approach defined
- [ ] API/interfaces specified
- [ ] Data models documented
- [ ] Testing strategy outlined
- [ ] Acceptance criteria defined

### Standards Compliance
- [ ] Matches preferred tech stack
- [ ] Follows coding conventions
- [ ] Uses established patterns
- [ ] Aligns with architectural standards

### Consistency
- [ ] No contradictory requirements
- [ ] Consistent terminology
- [ ] Realistic acceptance criteria
- [ ] Feasible implementation approach

### Clarity
- [ ] Unambiguous language
- [ ] Sufficient technical detail
- [ ] Clear dependencies
- [ ] Explicit assumptions

## Outputs

| Output | Purpose |
|--------|---------|
| Verification Report | Documents findings, gaps, issues |
| Pass/Fail Status | Whether specification is ready for implementation |

## Standards Compliance

Verifies specification aligns with user's:
- Preferred tech stack
- Coding conventions
- Common patterns
- Quality standards

References: `{{standards/*}}`

## Pattern Background

This agent implements the **Verification Pattern**, providing quality gates before proceeding to implementation phase.

**Theory:** See [Verification Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Verify before proceeding
- Catch issues early
- Standards enforcement
- Quality gates

## Model Selection

Uses **sonnet** for:
- Fast verification
- Cost efficiency
- Checklist-based validation
- Pattern matching tasks

## Tools

- **Write**: Create verification report
- **Read**: Access specification, requirements, standards
- **Bash**: Run validation commands
- **WebFetch**: Research best practices if needed

## Examples

**Input:**
```
spec.md for API rate limiting middleware
requirements.md with detailed requirements
```

**Verification:**
```markdown
# Specification Verification Report

## Status: PASS with minor recommendations

## Completeness: ✓
- All requirements addressed
- Architecture clearly documented
- Testing strategy defined

## Standards Compliance: ✓
- Uses Express.js (user preference)
- Follows middleware pattern
- Redis for state (approved tech)

## Recommendations:
1. Add error handling details
2. Specify Redis connection retry logic
3. Document monitoring/metrics approach

## Next Step: Ready for tasks-list-creator
```

## Related Agents

- [spec-writer](spec-writer.md) - Preceding: created specification
- [tasks-list-creator](tasks-list-creator.md) - Next: creates implementation tasks
- [implementer](implementer.md) - Following: implements specification

## Related Guides

- [Specification Review Checklist](../../how-to/verify-specifications.md) (Task Group 8)
- [Quality Gates](../../reference/quality-gates.md) (Task Group 9)

---

**Workflow References:**
- `profiles/default/workflows/specification/verify-spec`
