# /implement-tasks

**Pattern:** [Implementation Pattern](../../explanation/patterns/implementation.md) (placeholder)

**Location:** `profiles/default/commands/implement-tasks/`

**Variants:** Single-agent, Multi-agent

## Purpose

Executes implementation of task groups from `tasks.md` with verification. Provides straightforward, effective workflow for feature implementation.

## Usage

```bash
/implement-tasks
```

Run after `/create-tasks` with `tasks.md` in spec folder.

Can specify which task groups to implement:

```bash
/implement-tasks

Implement task groups 1, 2, and 3
```

## Workflow

### Multi-Agent Variant (Recommended)

**Location:** `profiles/default/commands/implement-tasks/multi-agent/implement-tasks.md`

#### Phase 1: Determine Task Groups

- Checks if user specified which task groups to implement
- If not, reads `tasks.md` and asks user
- User confirms: all tasks or specific groups

#### Phase 2: Delegate to Implementer

Delegates to **implementer** subagent for each task group:

Provides:
- Specific task group from `tasks.md`
- `spec.md` for context
- `planning/requirements.md` for details
- `planning/visuals/` for reference

Instructs implementer to:
1. Analyze spec and requirements
2. Analyze codebase patterns
3. Implement task group
4. Mark tasks complete with `[x]` in `tasks.md`

Repeats for each task group until all complete.

#### Phase 3: Final Verification

Once ALL tasks marked `[x]`, delegates to **implementation-verifier** subagent:

Provides:
- Spec folder path

Instructs verifier to:
1. Run final verifications (tests, lint, build)
2. Produce verification report in `verifications/final-verification.md`

**Agents Used:**
- [implementer](../agents/implementer.md) - Implements each task group
- [implementation-verifier](../agents/implementation-verifier.md) - Verifies completion

---

### Single-Agent Variant

**Location:** `profiles/default/commands/implement-tasks/single-agent/implement-tasks.md`

Progressively loads three phase files:

1. `1-determine-tasks.md` - Which task groups to implement
2. `2-implement-tasks.md` - Execute implementation
3. `3-verify-implementation.md` - Final verification

Each phase executes in sequence within the same conversation.

**Note:** Single-agent variant executes all phases in one session, which can exceed context limits for large features.

---

## When to Use

### Use /implement-tasks when:

- Have completed `tasks.md` via /create-tasks
- Want straightforward, effective implementation workflow
- Prefer simpler approach over advanced orchestration
- Working on small-to-medium features

### Use /orchestrate-tasks instead if:

- Need custom subagent assignment per task group
- Want standards/preferences mapped per task group
- Require generated prompts for manual control
- Building complex, multi-domain features

---

## Output Files

```
specs/YYYY-MM-DD-feature-name/
├── spec.md                        # (from /write-spec)
├── tasks.md                       # Tasks marked [x] as completed
├── verifications/
│   └── final-verification.md      # Created after all tasks done
└── (implementation files in codebase)
```

### tasks.md Progress Tracking

Before:
```markdown
## Task Group 1: Foundation
- [ ] Task 1.1: Create database schema
- [ ] Task 1.2: Create data models
```

After implementation:
```markdown
## Task Group 1: Foundation
- [x] Task 1.1: Create database schema
- [x] Task 1.2: Create data models
```

### final-verification.md Structure

- All tests passing
- Code quality checks (linting, type checking)
- Build successful
- Performance benchmarks (if applicable)
- Security checks (if applicable)
- Documentation updated
- Known issues or follow-up items

---

## Examples

### Example 1: Comment System Implementation

```bash
/implement-tasks
```

**Agent asks:** "Implement all task groups or specify which ones?"

**User responds:** "All"

**Implementation flow:**

1. **Task Group 1: Database Schema**
   - implementer creates migration files
   - Creates comments, likes, notifications tables
   - Runs migration
   - Marks tasks [x] in tasks.md

2. **Task Group 2: Comment API**
   - implementer creates API endpoints
   - POST /api/posts/:id/comments
   - GET /api/posts/:id/comments
   - Tests endpoints
   - Marks tasks [x]

3. **Task Groups 3-8** continue similarly...

4. **Final Verification**
   - implementation-verifier runs test suite
   - Checks lint, build
   - Creates verification report

**Output:**
- All tasks.md items marked [x]
- `verifications/final-verification.md` with passing checks
- Comment system fully implemented

### Example 2: Incremental Implementation

```bash
/implement-tasks

Just implement task groups 1 and 2 for now
```

**Implementation flow:**

1. **Task Group 1: Token Infrastructure**
   - implementer creates RSA key utilities
   - JWT signing/verification functions
   - Marks tasks [x]

2. **Task Group 2: Authorization Code Flow**
   - implementer creates /oauth endpoints
   - Authorization code generation
   - Token generation
   - Marks tasks [x]

**Output:**
- Task groups 1-2 marked [x]
- Task groups 3+ remain [ ]
- No final verification yet (not all tasks done)
- Can run `/implement-tasks` again later for remaining groups

---

## Pattern Background

Implements **Implementation Pattern** from 12-Factor AgentOps.

**Theory:** Implementation guided by spec and tasks prevents scope creep and ensures completeness.

**Practice:**
- Spec provides "what" and "why"
- Tasks provide "how" broken down
- Verification ensures quality
- Incremental progress tracked in tasks.md

**12-Factor Alignment:**
- Factor VI: Context Preservation - Progress tracked in tasks.md
- Factor VIII: Atomic Operations - Each task group is atomic
- Factor IX: Rapid Iteration - Incremental implementation
- Factor XI: Verification Gates - Final verification before done

---

## Implementation Flow Detail

### For Each Task Group:

1. **Context Loading**
   - Read spec.md (feature overview)
   - Read requirements.md (details)
   - Read visuals (mockups, diagrams)
   - Read current task group

2. **Pattern Analysis**
   - Analyze existing codebase patterns
   - Identify similar implementations
   - Follow established conventions

3. **Implementation**
   - Write code following patterns
   - Create tests
   - Update documentation

4. **Verification**
   - Run tests for this task group
   - Check functionality
   - Mark tasks [x] in tasks.md

### After All Task Groups:

1. **Final Verification**
   - Run full test suite
   - Check code quality (lint, types)
   - Verify build successful
   - Check performance/security
   - Document any issues

2. **Report Generation**
   - Create final-verification.md
   - List all checks performed
   - Note any follow-up items

---

## Progress Tracking

### During Implementation

Check progress anytime:

```bash
cat specs/YYYY-MM-DD-feature/tasks.md
```

Look for `[x]` vs `[ ]` markers.

### Task Group States

- `[ ]` - Not started
- `[x]` - Complete

**Note:** No "in progress" state. Task group either done or not.

---

## Related Commands

- **Previous:** [/create-tasks](create-tasks.md) - Create tasks first
- **Alternative:** [/orchestrate-tasks](orchestrate-tasks.md) - Advanced orchestration

## Related Guides

- **[How to Implement Tasks](../../how-to/run-implement-tasks.md)** - Step-by-step guide for this workflow
- [How to Create Tasks](../../how-to/run-create-tasks.md) - Previous step (creating task breakdown)
- [How to Debug Workflow Issues](../../how-to/debug-workflow.md) - Troubleshooting guide
- [How-To Guide Index](../../how-to/README.md) - All available how-to guides

## Related Agents

- [implementer](../agents/implementer.md) - Implements task groups
- [implementation-verifier](../agents/implementation-verifier.md) - Verifies completion

---

## Tips

1. **Implement incrementally** - Don't have to do all task groups at once
2. **Review each task group** - Check implementation before moving to next
3. **Update tasks.md manually if needed** - If agent misses marking [x]
4. **Read verification report** - May contain follow-up items
5. **Consider testing task group** - Dedicated testing often reveals issues

---

## Troubleshooting

**Q: Should I use single-agent or multi-agent variant?**

A: Multi-agent strongly recommended. Single-agent can exceed context limits on medium+ features.

**Q: Can I implement task groups out of order?**

A: Technically yes, but respect dependencies. Task Group 3 may depend on Task Group 1.

**Q: What if implementation reveals issues in spec?**

A: Update spec.md and tasks.md as you learn. Treat as living documents.

**Q: What if verification fails?**

A: implementation-verifier will note issues in final-verification.md. Fix and re-verify.

**Q: /implement-tasks vs /orchestrate-tasks?**

A: /implement-tasks is simpler and works great for most features. /orchestrate-tasks adds advanced features (custom subagents, standards per group) for complex work.

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [/orchestrate-tasks](orchestrate-tasks.md) - Advanced alternative
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
