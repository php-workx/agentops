# implementation-verifier

**Pattern:** [Verification Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)
**Location:** `profiles/default/agents/implementation-verifier.md`
**Status:** Production
**Model:** inherit
**Color:** green

## Purpose

Verifies the end-to-end implementation of a specification, updates product roadmap if applicable, and produces a final verification report. This is the final quality gate before considering a feature complete.

## Usage

```bash
# Invoke through Claude Code agent system after implementer
# Agent will verify complete implementation meets all requirements
```

## Core Responsibilities

1. **Verify Tasks Completion**: Ensure all tasks in tasks.md are marked complete
2. **Update Roadmap**: Mark completed roadmap items in product documentation
3. **Run Test Suite**: Execute entire test suite and verify no regressions
4. **Create Verification Report**: Document final verification results and readiness

## Workflow

### Step 1: Ensure tasks.md has been updated

Executes: `{{workflows/implementation/verification/verify-tasks}}`

**Checks:**
- [ ] All tasks marked `- [x]`
- [ ] No tasks marked `[BLOCKED]`
- [ ] All acceptance criteria met
- [ ] No skipped tasks

### Step 2: Update roadmap (if applicable)

Executes: `{{workflows/implementation/verification/update-roadmap}}`

**Actions:**
1. Read `agentops/spec-first-dev/product/roadmap.md`
2. Identify completed features
3. Mark relevant items with `- [x]`
4. Update roadmap file

### Step 3: Run entire test suite

Executes: `{{workflows/implementation/verification/run-all-tests}}`

**Test Categories:**
- Unit tests (all passing)
- Integration tests (all passing)
- E2E tests (all passing)
- Regression tests (no failures)
- Performance tests (if applicable)

### Step 4: Create final verification report

Executes: `{{workflows/implementation/verification/create-verification-report}}`

**Report Includes:**
- Implementation summary
- Tasks completion status
- Test results
- Roadmap updates
- Known issues/limitations
- Production readiness assessment

## Outputs

| File | Purpose |
|------|---------|
| `agentops/spec-first-dev/specs/{spec-name}/verification-report.md` | Final verification results |
| `agentops/spec-first-dev/product/roadmap.md` | Updated with completed features |

## Verification Checklist

### Tasks Verification
- [ ] All tasks completed and checked
- [ ] All acceptance criteria met
- [ ] No blocking issues remaining
- [ ] Code reviewed

### Testing Verification
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] All E2E tests passing
- [ ] No test regressions
- [ ] Test coverage acceptable

### Quality Verification
- [ ] Code follows standards
- [ ] Documentation complete
- [ ] No security issues
- [ ] Performance acceptable

### Roadmap Verification
- [ ] Roadmap items updated
- [ ] Dependencies noted
- [ ] Future work documented

## Verification Report Structure

```markdown
# Verification Report: Feature Name

**Date:** YYYY-MM-DD
**Specification:** Link to spec.md
**Status:** ✅ READY FOR PRODUCTION | ⚠️ READY WITH NOTES | ❌ NOT READY

## Implementation Summary
Brief overview of what was implemented

## Tasks Completion
- Total tasks: X
- Completed: X
- Status: All tasks complete ✅

## Test Results
- Unit tests: X/X passing ✅
- Integration tests: X/X passing ✅
- E2E tests: X/X passing ✅
- Regression tests: No failures ✅

## Roadmap Updates
- [x] Feature X completed
- [x] Feature Y completed

## Known Issues/Limitations
- (List any known issues)

## Production Readiness
✅ READY - All criteria met, tests passing, no blockers

## Next Steps
- Deploy to staging
- Monitor metrics
- Gather user feedback
```

## Pattern Background

This agent implements the **Verification Pattern**, providing final quality gates before production release.

**Theory:** See [Verification Pattern](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) (Task Group 10)

**Key Principles:**
- Verify everything end-to-end
- Run complete test suite
- Document verification results
- Assess production readiness
- Update tracking systems

## Tools

- **Write**: Create verification report, update roadmap
- **Read**: Access tasks, specs, test results
- **Bash**: Run test suites, validation commands
- **WebFetch**: Research deployment best practices
- **Playwright**: Run E2E tests

## Pass/Fail Criteria

### ✅ PASS - Ready for Production
- All tasks complete
- All tests passing
- No blocking issues
- Documentation complete
- Standards compliant

### ⚠️ PASS WITH NOTES - Ready with Caveats
- All critical tasks complete
- Core tests passing
- Minor known issues documented
- Acceptable for staged rollout

### ❌ FAIL - Not Ready
- Incomplete tasks
- Failing tests
- Blocking issues
- Missing critical functionality

## Examples

**Input:**
```
Completed implementation of API rate limiting
tasks.md: all tasks marked [x]
Tests: all passing
Roadmap: "Rate limiting" feature exists
```

**Verification Process:**
```bash
# 1. Verify tasks
✓ All 15 tasks completed
✓ All acceptance criteria met

# 2. Run tests
npm test
✓ Unit tests: 24/24 passing
✓ Integration tests: 8/8 passing
✓ E2E tests: 5/5 passing

# 3. Update roadmap
Updated: agentops/spec-first-dev/product/roadmap.md
✓ Marked "Rate limiting" as complete

# 4. Create report
Created: verification-report.md
Status: ✅ READY FOR PRODUCTION
```

## Related Agents

- [implementer](implementer.md) - Preceding: implemented features
- [spec-verifier](spec-verifier.md) - Reference: specification verification
- [product-planner](product-planner.md) - Reference: product roadmap

## Related Guides

- [Verification Checklist](../../how-to/verify-implementation.md) (Task Group 8)
- [Testing Strategy](../../how-to/testing.md) (Task Group 8)
- [Production Readiness](../../reference/production-readiness.md) (Task Group 9)

---

**Workflow References:**
- `profiles/default/workflows/implementation/verification/verify-tasks`
- `profiles/default/workflows/implementation/verification/update-roadmap`
- `profiles/default/workflows/implementation/verification/run-all-tests`
- `profiles/default/workflows/implementation/verification/create-verification-report`
