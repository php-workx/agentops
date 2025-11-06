# How to Implement Tasks

**Goal:** Execute implementation of task groups from tasks.md with verification

**Time:** Varies by feature size (1-8 hours typical)

**Prerequisites:**
- Completed `tasks.md` (from `/create-tasks`)
- Specification (`spec.md`)
- Development environment set up

## Overview

The `/implement-tasks` workflow executes the implementation of your task groups systematically. It provides a straightforward, effective approach to feature development by:

1. Working through task groups incrementally
2. Following your specification and requirements
3. Analyzing codebase patterns for consistency
4. Marking tasks complete as you progress
5. Running final verification when all tasks done

This workflow is ideal for small-to-medium features where you want a simple, proven implementation approach.

## Steps

### 1. Ensure Tasks are Ready

Before running `/implement-tasks`, you should have:

```
specs/2025-11-06-feature-name/
├── spec.md                  # Specification
├── tasks.md                 # Task breakdown
└── planning/
    ├── requirements.md      # Requirements
    └── visuals/             # Mockups/diagrams
```

If `tasks.md` doesn't exist, run `/create-tasks` first.

### 2. Start the Workflow

Run the command in your repository:

```bash
/implement-tasks
```

**What happens:**
The workflow locates your most recent spec folder and reads `tasks.md`.

### 3. Choose Task Groups

The workflow asks which task groups to implement:

**Option A: Implement all**
```bash
Agent: "Implement all task groups or specify which ones?"

You: "All"
```

**Option B: Implement specific groups**
```bash
Agent: "Implement all task groups or specify which ones?"

You: "Just task groups 1, 2, and 3 for now"
```

**Option C: Specify upfront**
```bash
/implement-tasks

Implement task groups 1 and 2
```

**Tip:** Incremental implementation (a few groups at a time) is often easier to review and validate.

### 4. Implementation Begins

For each task group, the **implementer** agent:

1. **Loads Context**
   - Reads spec.md for feature overview
   - Reads requirements.md for details
   - Reviews visuals for UI/UX guidance
   - Reads current task group tasks

2. **Analyzes Patterns**
   - Examines existing codebase
   - Identifies similar implementations
   - Follows established conventions

3. **Implements Tasks**
   - Writes code following patterns
   - Creates tests
   - Updates documentation
   - Handles edge cases per spec

4. **Marks Complete**
   - Updates tasks.md with `[x]` for completed tasks
   - Moves to next task group

**You'll see progress like:**
```
Implementing Task Group 1: Database Schema...
- Created migration file
- Added comments table with indexes
- Added likes and notifications tables
- Migration tested successfully

Marking tasks complete in tasks.md...

Moving to Task Group 2: Comment API...
```

### 5. Track Progress

Check progress anytime:

```bash
cat specs/2025-11-06-feature-name/tasks.md
```

Look for `[x]` (complete) vs `[ ]` (pending) markers:

```markdown
## Task Group 1: Database Schema
- [x] Create comments table
- [x] Create likes table
- [x] Create notifications table

## Task Group 2: Comment API
- [x] POST /api/posts/:id/comments
- [x] GET /api/posts/:id/comments
- [ ] PUT /api/comments/:id (next)
```

### 6. Final Verification

Once ALL tasks are marked `[x]`, the **implementation-verifier** agent runs final checks:

**Verification includes:**
- Run full test suite
- Code quality checks (linting, type checking)
- Build verification
- Performance benchmarks (if applicable)
- Security checks (if applicable)
- Documentation completeness

**Creates report:**
```
specs/2025-11-06-feature-name/
└── verifications/
    └── final-verification.md
```

### 7. Review Verification Report

Read the final verification:

```bash
cat specs/2025-11-06-feature-name/verifications/final-verification.md
```

**Typical report structure:**

```markdown
# Final Verification Report

## Test Results
- Unit tests: 47 passed
- Integration tests: 12 passed
- E2E tests: 8 passed
- Coverage: 87%

## Code Quality
- Lint: No errors
- Type checking: No errors
- Build: Successful

## Performance
- API response time: <300ms (target: <500ms)
- Database queries: <50ms

## Security
- No SQL injection vulnerabilities
- Input validation implemented
- Rate limiting configured

## Documentation
- API endpoints documented
- README updated
- Inline comments added

## Known Issues
None

## Follow-up Items
- Consider adding rate limit monitoring
- May want to optimize threading query in future
```

### 8. Address Issues (if any)

If verification report lists issues:
- Fix critical problems
- Document known limitations
- Create follow-up tasks if appropriate

## Expected Output

After completion, you'll have:

```
specs/2025-11-06-feature-name/
├── spec.md                        # Original spec
├── tasks.md                       # All tasks marked [x]
├── verifications/
│   └── final-verification.md      # Verification report
└── (implementation files throughout codebase)
```

Plus all your implementation code, tests, and documentation.

## Common Issues

### Issue: Not sure whether to implement all or incrementally

**Solution:** Incremental is often better:
- Implement foundation first (task groups 1-2)
- Test and validate
- Continue with next groups
- Easier to review and catch issues early

### Issue: Implementation reveals problems with spec

**Solution:** That's normal! Update as you go:
1. Edit `spec.md` to reflect new understanding
2. Edit `tasks.md` to add/modify tasks
3. Continue implementation with updated plan

### Issue: Verification fails

**Solution:** Review `final-verification.md`:
- Fix test failures
- Address code quality issues
- Resolve build problems
- Re-run verification (manually or via `/implement-tasks` again)

### Issue: Want more control over implementation

**Solution:** Consider `/orchestrate-tasks` instead:
- Assign custom subagents per task group
- Map standards/preferences per group
- Generate prompts for manual control
- More flexibility for complex features

### Issue: Agent didn't mark tasks complete

**Solution:** Manually update `tasks.md`:
```markdown
- [x] Task completed but not marked
```

The tracking is for your benefit - update as needed.

### Issue: Task group too large, taking too long

**Solution:** For large task groups:
1. Stop current implementation
2. Edit `tasks.md` to break large group into smaller ones
3. Resume with `/implement-tasks` on smaller groups

## Next Steps

After implementing tasks:

1. **Review implementation** - Code review, manual testing
2. **Address verification issues** - Fix any problems found
3. **Test feature end-to-end** - User acceptance testing
4. **Update documentation** - User guides, API docs, changelog
5. **Deploy** - Follow your deployment process
6. **Monitor** - Track metrics, errors, user feedback

## Related

- [Command Reference: /implement-tasks](../reference/commands/implement-tasks.md)
- [Agent Reference: implementer](../reference/agents/implementer.md)
- [Agent Reference: implementation-verifier](../reference/agents/implementation-verifier.md)
- [Command Reference: /orchestrate-tasks](../reference/commands/orchestrate-tasks.md) (advanced alternative)
- [How to Create Tasks](run-create-tasks.md)
- [Pattern: Implementation](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Implement incrementally** - Do a few task groups, review, continue
2. **Review each group** - Check implementation quality before moving to next
3. **Update docs as you go** - Spec and tasks are living documents
4. **Run tests frequently** - Catch issues early
5. **Follow codebase patterns** - Agent analyzes patterns but verify consistency
6. **Read verification report carefully** - May contain important follow-up items
7. **Don't skip testing task groups** - Dedicated testing often reveals integration issues
8. **Keep commits atomic** - One task group per commit (or related subtasks)
9. **Document decisions** - Add comments explaining non-obvious choices
10. **Consider edge cases** - Spec should cover these, but verify implementation handles them

## Implementation vs. Orchestration

### Use /implement-tasks when:
- Small-to-medium features
- Want straightforward workflow
- Standard implementation approach
- Single implementer agent sufficient

### Use /orchestrate-tasks when:
- Complex, multi-domain features
- Need custom subagent per task group
- Want to map standards/preferences per group
- Require generated prompts for manual execution
- Advanced orchestration needed

**Most features:** `/implement-tasks` is sufficient and simpler.

## Examples

### Example 1: Complete Comment System

```bash
/implement-tasks
```

**User:** "Implement all task groups"

**Execution:**
1. Task Group 1: Database Schema (2 hours)
   - Creates migration files
   - Implements comments, likes, notifications tables
   - Marks complete

2. Task Group 2: Comment API (4 hours)
   - Implements POST and GET endpoints
   - Adds validation and error handling
   - Marks complete

3. Task Groups 3-8 continue... (12 more hours)

4. Final Verification
   - All 67 tests passing
   - Lint clean, build successful
   - Creates verification report

**Result:** Feature fully implemented and verified.

### Example 2: Incremental OAuth2

**Session 1:**
```bash
/implement-tasks

Implement task groups 1 and 2
```

**Result:**
- Token infrastructure complete
- Authorization code flow complete
- Tasks.md shows groups 1-2 marked [x]
- No final verification yet (more groups remain)

**Session 2 (next day):**
```bash
/implement-tasks

Implement remaining task groups
```

**Result:**
- Task groups 3-6 complete
- All tasks now [x]
- Final verification runs
- Feature complete

**Benefit:** Easier to review in chunks, catch issues early.
