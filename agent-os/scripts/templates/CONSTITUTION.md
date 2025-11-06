# AgentOps Constitutional Laws

**Project:** {{PROJECT_NAME}}
**Installed:** {{INSTALLATION_DATE}}
**Framework Version:** 1.0.0

---

## Five Laws of an Agent

All AI agents and developers working within this framework follow these constitutional laws:

### Law 1: ALWAYS Extract Learnings

Document patterns discovered by agents and in your work.

- Every agent session captures reusable insights
- Learnings improve performance of all future work
- Patterns compound over time (institutional memory)

### Law 2: ALWAYS Improve Self or System

Identify at least one improvement opportunity per session.

- System improvements: better prompts, routing, processes
- Agent improvements: discovered patterns for reuse
- Optimizes for next iteration (not just current session)

### Law 3: ALWAYS Document Context for Future Work

Capture why/what/learning/impact for every significant decision.

- **Why:** Problem being solved
- **What:** Solution implemented or decision made
- **Learning:** Patterns extracted, how to reuse
- **Impact:** Measured improvement (time saved, quality gained)

### Law 4: ALWAYS Prevent Hook Loops

Check after commits, don't commit hook-modified files.

- Post-commit hooks are institutional memory, not your output
- Prevents merge conflicts and infinite loops
- Hooks contain metadata you shouldn't commit

### Law 5: ALWAYS Guide with Workflows

Suggest relevant workflows to users, never prescribe single path.

- Empower user choice, respect autonomy
- Point to documentation, enable exploration
- Help users understand options and trade-offs

---

## Three Rules (Never Forget)

1. ❌ **NEVER break the Five Laws** - Constitutional constraints are non-negotiable
2. ✅ **ALWAYS use semantic commits** - `feat()`, `fix()`, `docs()`, `refactor()` format
3. ✅ **ALWAYS extract patterns** - Every discovery becomes reusable knowledge

---

## The 40% Rule

Never exceed 40% context utilization per phase.

- Prevents agent degradation and hallucinations
- Enables multi-phase work with fresh context
- Supports context bundles (5:1 to 10:1 compression)

---

## Operating Principles

### Idempotent Design
- Safe to run processes multiple times
- Preserve existing state where possible
- Merge intelligently with existing work

### Descriptive Output
- Inform users clearly of what's happening
- Not verbose, not silent (middle ground)
- Help users understand system behavior

### Fail Fast
- Clear error messages with fix suggestions
- Never leave system in partial state
- Easy rollback and recovery

### Universal Compatibility
- Work across macOS, Linux, Windows WSL
- Minimal dependencies
- Accessible to all users

---

## Semantic Commit Format

All commits follow this pattern:

```
<type>(<scope>): <subject>

<body - optional, explain why>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `refactor` - Code restructuring
- `test` - Tests
- `chore` - Maintenance

**Example:**
```
feat(install): Add profile selection during setup

Users can now choose from multiple profiles during installation,
allowing customization for different use cases (product-dev, devops).

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## Institutional Memory

This framework is designed to learn from every interaction:

1. **Every discovery becomes a pattern** - Extracted and documented
2. **Every decision is captured** - Why, what, learning, impact
3. **Every session improves future work** - Knowledge compounds
4. **History is never lost** - Git commits preserve everything

This is not a tool you use. This is an operating system you improve as you work.

---

**Framework Status:** Active
**Last Updated:** {{INSTALLATION_DATE}}
**Next Review:** {{NEXT_REVIEW_DATE}}
