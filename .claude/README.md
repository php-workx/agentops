# AgentOps Claude Code Configuration

**Quick Navigation for Building AgentOps**

---

## Start Here

1. **Read:** `/agentops/claude.md` (2 min kernel)
2. **Understand:** Five Laws, Three Rules, 40% Rule
3. **Load context JIT:** Only read what's needed for your task

---

## Configuration Files

- **`settings.json`** - Base configuration (model, permissions, hooks)
  - Enforces semantic commits
  - Enforces 40% rule per phase
  - Prevents hook loops

---

## Repository Kernel & Strategy

**Primary File:** `/agentops/claude.md`
**Time:** 2-3 minutes
**Contains:**

- Constitutional foundation (Five Laws, Three Rules, 40% Rule)
- Four universal patterns explained
- Repository structure overview
- Session workflow and common tasks
- Commit message patterns

**Read this at the start of every session.**

**Strategic File:** `/agentops/STRATEGY.md`
**Time:** 5 minutes
**Contains:**

- Mission: Why AgentOps exists
- The problem we solve
- Path to v1.0 (Alpha → Beta → v1.0)
- Non-negotiable principles
- How contributors help

**Read this to understand WHY your work matters and WHERE we're headed.**

---

## Main Documentation (JIT Loading)

### If Building Framework Docs
```
/agentops/README.md                          (main overview)
/agentops/CONSTITUTION.md                    (Five Laws detail)
/agentops/architecture/                      (four patterns)
/agentops/docs/explanation/                  (why patterns work)
```

### If Creating a Profile
```
/agentops/docs/how-to/CREATE_CUSTOM_PROFILE.md
/agentops/profiles/default/                  (generic template)
/agentops/profiles/[existing]/               (reference example)
```

### If Adding a Case Study
```
/agentops/docs/case-studies/MULTI_DOMAIN_VALIDATION.md
/agentops/docs/case-studies/CASE_STUDY_GITOPS_INTEGRATION.md
```

### If Understanding Why AgentOps Exists
```
/agentops/docs/explanation/agentops-manifesto.md
/agentops/docs/explanation/PATTERN_EXTRACTION_METHODOLOGY.md
/agentops/README.md (Philosophy section)
```

---

## Launch Execution (Nov 11-28, 2025)

**If you're here for the Dec 1 launch**, read `EXECUTION_GUIDE.md` first:
- **PRIORITY 1:** Content rewrites → `life/agentops-promotion/`
- **PRIORITY 2:** Website build → NEW `website/` repo
- **PRIORITY 3:** Launch verification → `launch/README.md`

See `EXECUTION_GUIDE.md` for complete roadmap, critical path, and day-by-day examples.

---

## Task-Based Workflows

### I want to improve documentation clarity
**Time:** 30 min - 1 hour
1. Identify doc that needs improvement
2. Read `/agentops/claude.md` (kernel)
3. Read the doc in question
4. Refactor for clarity
5. Commit: `docs(<area>): <specific improvement>`

### I want to add a case study
**Time:** 1-2 hours
1. Read `/agentops/docs/case-studies/MULTI_DOMAIN_VALIDATION.md` (template)
2. Research domain applicability
3. Document: Problem → Approach → Results → Learnings
4. Add metrics and proof
5. Commit: `docs(case-studies): Add <domain> validation`

### I want to extend a profile
**Time:** 2-4 hours
1. Read `/agentops/docs/how-to/CREATE_CUSTOM_PROFILE.md`
2. Study existing profile: `/agentops/profiles/[product-dev|devops]/`
3. Add domain-specific agents, workflows, examples
4. Validate structure matches pattern
5. Commit: `feat(profiles): Extend <domain> with <capability>`

### I want to validate universality
**Time:** 3-6 hours
1. Read `/agentops/docs/case-studies/MULTI_DOMAIN_VALIDATION.md`
2. Study `/agentops/architecture/` (all four patterns)
3. Document domain-specific application
4. Show how patterns generalize
5. Add metrics/proof
6. Commit: `docs(case-studies): Validate <domain> applicability`

---

## Constitutional Foundation (Always)

### Five Laws
1. **Extract Learnings** - Patterns compound
2. **Improve System** - Stagnation = regression
3. **Document Context** - Future you will thank you
4. **Prevent Hook Loops** - Prevention > recovery
5. **Guide Workflows** - Suggest 5-6 options

### Three Rules
1. ❌ Never modify read-only upstream
2. ✅ Always edit source (never generated)
3. ✅ Always use semantic commits

### 40% Rule
- Never exceed 40% context utilization per phase
- Enables multi-day projects via bundles
- Prevents cognitive overload

---

## Commit Messages

**Format:** `<type>(<scope>): <subject>`

**Examples:**
```
feat(architecture): Add multi-agent pattern explanation
docs(manifesto): Clarify why this matters
docs(case-studies): Add SRE domain validation
refactor(profiles): Consolidate templates
```

**Types:**
- `feat` - New pattern, guide, or profile capability
- `docs` - Documentation, guides, case studies
- `refactor` - Reorganizing or improving existing docs
- `fix` - Corrections or clarifications

---

## When You're Stuck

**Not sure where to start?**
→ Ask user which area: framework docs, profiles, or case studies?

**Don't understand a pattern?**
→ Read `/agentops/architecture/[pattern].md`

**Need to research something?**
→ Use Phase 1 (Research), document findings, then move to Phase 2 (Plan)

**Want to suggest improvements?**
→ Include in commit message: notes what could be improved next

---

## Session Checklist

- [ ] Read `/agentops/claude.md` (kernel)
- [ ] Confirm task type with user
- [ ] Load relevant docs via JIT
- [ ] Follow phase structure (Research → Plan → Implement)
- [ ] Enforce 40% rule
- [ ] Extract learnings (in commits)
- [ ] Use semantic commits
- [ ] Suggest workflows at end

---

## Quick Links

| Path | Purpose |
|------|---------|
| `claude.md` | Repository kernel (start here) |
| `README.md` | Main documentation |
| `CONSTITUTION.md` | Five Laws + Three Rules |
| `architecture/` | Four universal patterns |
| `docs/explanation/` | Conceptual (why) |
| `docs/how-to/` | Procedural (how) |
| `docs/case-studies/` | Validation (proof) |
| `profiles/` | Domain templates |

---

## Remember

- **You're building institutional memory** - Every doc, every commit compounds
- **Follow the 40% rule** - Prevents context collapse across multi-day projects
- **Extract patterns** - What works once should be documented for reuse
- **Suggest workflows** - Guide user to next logical step at end of session

---

**Status:** Alpha (Dec 1, 2025 public launch)
**Framework:** AgentOps - Universal AI Agent Operations
**License:** Apache 2.0 (code) + CC BY-SA 4.0 (docs)
