# agentops Constitution

**The foundational laws that govern all AI agent operations.**

These rules are **always enforced** through git hooks and automation. This is not optional context—this is the operational foundation.

---

## The Five Laws (MANDATORY)

### Law 1: ALWAYS Extract Learnings
- Document patterns discovered during work
- Capture decision rationale (why, not just what)
- Analyze failures to prevent recurrence

### Law 2: ALWAYS Improve Self or System
- Identify at least one improvement opportunity per session
- Specify impact (time saved, quality, risk reduction)
- Propose implementation (effort, priority)

### Law 3: ALWAYS Document Context for Future Agents
Every commit must include:
- **Context:** Why this work was needed
- **Solution:** What was created/changed
- **Learning:** Reusable patterns discovered
- **Impact:** Value delivered, who benefits

### Law 4: ALWAYS Prevent Hook Loops
**Mandatory post-push check:**
```bash
git push && bash tools/scripts/post-push-law4-check.sh
```

Don't commit files modified by git hooks. They're institutional memory, not your responsibility.

### Law 5: ALWAYS Guide with Workflow Suggestions
After context loads, suggest 5-6 relevant workflows. Let users pick, never prescribe.

---

## The Three Rules (NEVER FORGET)

1. ❌ **NEVER modify read-only upstream** - Preserve immutable references
2. ✅ **ALWAYS edit source of truth, not generated** - Config patterns matter
3. ✅ **ALWAYS use semantic commits** - `<type>(<scope>): <subject>`

---

## The 40% Rule (Context Engineering)

Stay under 40% of token budget per phase to prevent context collapse.

- 🟢 <35%: GREEN - continue
- ⚡ 35-40%: YELLOW - prepare to transition
- ⚠️ 40-60%: RED - transition NOW
- 🔴 >60%: CRITICAL - reset immediately

**Pattern:** Gather → Glean → Summarize (JIT loading, not upfront)

---

## The Four Pillars (FOUNDATIONAL)

1. **DevOps Principles** - Apply infrastructure practices to agents
2. **Learning Science** - Research→Plan→Implement based on cognitive science
3. **Context Engineering** - Stay under 40% token budget, prevent collapse
4. **Institutional Memory** - Git captures decision context and learnings

---

## Specs-Driven Development

The heart of agentops is specification-driven workflow:

```
RESEARCH (understand the problem)
  ↓
PLAN (write detailed specifications)
  ↓
IMPLEMENT (follow spec precisely)
```

**Why:** Specs force thinking before execution. Prevents ambiguity, token waste, and iteration.

This pattern works across ALL domains:
- **DevOps:** Infrastructure specs, deployment specs
- **Product:** Feature specs, API specs, UI specs
- **SRE:** Runbook specs, verification specs
- **Security:** Compliance specs, audit specs

---

## Validation Gates

### Gate 1: Pre-Commit
Validate syntax and quality before commit.

### Gate 2: Human Review
Review PLAN before executing, not code after.

### Gate 3: CI/CD
Automated validation in your pipeline.

### Gate 4: Deployment
Deploy to environment with safety checks.

---

## Commit Message Format

```
<type>(<scope>): <subject>

Context: [Why was this needed?]
Solution: [What was done?]
Learning: [What pattern was applied?]
Impact: [What value is delivered?]

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:** feat, fix, docs, refactor, test, chore
**Scopes:** apps, config, docs, agents, monitoring

---

## This Constitution is Always Enforced

You don't "load" it. You operate under it.

Every agent, every workflow, every system enforces these laws automatically.
