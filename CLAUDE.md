# AgentOps Repository Kernel

**Purpose:** Guide Claude Code to build, improve, and contribute to the AgentOps framework
**Status:** Alpha reference implementation (Dec 1, 2025 public launch)
**Last Updated:** Nov 5, 2025

---

## What is AgentOps?

**Universal framework for reliable AI agent operations** applying DevOps/SRE patterns to AI workflows.

- **Proven:** 40x speedup (product dev), 3x speedup (infrastructure)
- **Universal:** Works across product development, infrastructure, SRE, data engineering, custom domains
- **Reference Implementation:** This repo shows how patterns work in practice
- **Framework Agnostic:** Complemented by [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops) theory

**Key Insight:** The same patterns that optimize human cognitive load work universally for AI agents.

---

## Strategic Context: Read STRATEGY.md First

**File:** `STRATEGY.md` (in repo root)
**Time:** 5 minutes
**Contains:**

- The mission: Why AgentOps exists
- The problem it solves
- Path to v1.0 (Alpha → Beta → v1.0)
- How this framework fits the bigger picture
- Non-negotiable principles
- How contributors help

**This answers:** "What are we building toward?" and "Why does my work matter?"

**When in doubt about direction:** Reread STRATEGY.md to realign with mission.

---

## Constitutional Foundation (ALWAYS Enforced)

### Five Laws
1. **ALWAYS Extract Learnings** — Document patterns discovered
2. **ALWAYS Improve Self or System** — Identify ≥1 improvement per session
3. **ALWAYS Document Context** — Capture why/what/learning/impact
4. **ALWAYS Prevent Hook Loops** — Check after push, don't commit hook-modified files
5. **ALWAYS Guide with Workflows** — Suggest relevant workflows to user

### Three Rules
1. ❌ **NEVER modify read-only upstream** (kubic-cm, etc.)
2. ✅ **ALWAYS edit source of truth** (never generated files)
3. ✅ **ALWAYS use semantic commits** (`feat:`, `fix:`, `docs:`, `refactor:`)

### The 40% Rule
- Never exceed 40% context utilization per phase
- Enables multi-day projects via context bundles
- Prevents context collapse and cognitive overload

---

## Four Universal Patterns (All Domains)

These patterns power AgentOps across any domain:

### Pattern 1: Multi-Phase Workflow
- **Phase 1:** Research/Explore (understand, gather, validate)
- **Phase 2:** Plan/Specify (detail exact changes, design)
- **Phase 3:** Implement/Execute (deploy with validation, verify)

Each phase gets fresh context (40% rule enforced).

### Pattern 2: Context Bundles
- Compress intermediate artifacts (5:1 to 10:1 compression ratio)
- Reuse across sessions (enables multi-day projects)
- Share with team (prevent duplicate research)

### Pattern 3: Multi-Agent Orchestration
- Multiple agents research simultaneously (3x wall-clock speedup)
- Same token budget, faster results
- Synergistic specialization

### Pattern 4: Intelligent Routing
- Auto-recommend best-fit agent (90.9% accuracy)
- NLP task classification
- User can override

---

## Repository Structure

### Core Framework (Public-Ready)

```
agentops/
├── claude.md                          ← You are here (kernel)
├── STRATEGY.md                        ← Mission & direction
├── README.md                          ← Main documentation
├── CONSTITUTION.md                    ← Five Laws + Three Rules
├── INSTALL.md                         ← Installation guide
│
├── architecture/                      ← 4 universal patterns
│   ├── phase-based-workflow.md
│   ├── context-bundles.md
│   ├── multi-agent-orchestration.md
│   └── intelligent-routing.md
│
├── docs/
│   ├── explanation/                   ← Why patterns work (conceptual)
│   │   ├── agentops-manifesto.md
│   │   └── PATTERN_EXTRACTION_METHODOLOGY.md
│   ├── how-to/                        ← How to use patterns (procedural)
│   │   ├── CREATE_CUSTOM_PROFILE.md
│   │   └── [domain-specific guides]
│   └── case-studies/                  ← Validated multi-domain proof
│       ├── MULTI_DOMAIN_VALIDATION.md
│       └── CASE_STUDY_GITOPS_INTEGRATION.md
│
├── profiles/                          ← Domain-specific templates
│   ├── default/                       ← Generic foundation
│   ├── product-dev/                   ← Product development profile
│   ├── devops/                        ← Infrastructure/DevOps profile
│   └── [your-domain]/                 ← Community custom profiles
│
├── scripts/                           ← Installation & setup
│   ├── base-install.sh
│   └── project-install.sh
│
├── .claude/                           ← Claude Code configuration
│   ├── settings.json
│   └── README.md
│
├── .git/                              ← Git history (institutional memory)
└── LICENSE                            ← Apache 2.0 (code) + CC BY-SA 4.0 (docs)
```

### Working Space (Experimental, Sanitized Before Dec 1)

```
agentops/launch/                       ← REMOVE before public release
├── README.md                          ← Working space guide + timeline
├── case-studies/                      ← In-progress multi-domain validation
├── profiles/                          ← Draft profile templates
├── guides/                            ← Draft contributor/adopter guides
└── examples/                          ← Working proof-of-concepts
```

**This is a temporary working space for Nov 11-Dec 1 preparation.** All content is reviewed, sanitized, and moved to permanent locations before the Dec 1 public release. See [`launch/README.md`](launch/README.md) for detailed workflow and cleanup checklist.

---

## When Building AgentOps

### Your Focus: Three Areas

**1. Framework Documentation** (Architecture Layer)
- Clarify universal patterns
- Document convergent evolution evidence
- Improve explanations of why patterns work

**2. Profile Templates** (Specialization Layer)
- Extend existing profiles (product-dev, devops)
- Create new domain profiles (SRE, data-eng)
- Reference real implementation examples

**3. Case Studies & Validation** (Proof Layer)
- Document multi-domain validation
- Show speedup metrics and improvements
- Capture learnings from each domain

### Phases for Work

**Phase 1: Research**
- Understand current state
- Read relevant docs
- Explore structure
- Note questions/gaps

**Phase 2: Plan**
- Design specific changes
- Document exact improvements
- Create specification
- Get approval before implementing

**Phase 3: Implement**
- Make changes
- Validate against spec
- Commit with clear messages
- Document learnings

---

## Commit Message Pattern

**Format:** `<type>(<scope>): <subject>`

**Examples:**
```
feat(architecture): Add multi-agent orchestration pattern
docs(manifesto): Clarify operating-system-for-minds philosophy
docs(case-studies): Add SRE profile validation results
refactor(profiles): Consolidate product-dev and devops templates
```

**Types:**
- `feat` - New pattern, profile, or capability
- `docs` - Documentation, guides, case studies
- `refactor` - Reorganizing or simplifying existing work
- `fix` - Bug fixes or clarifications
- `test` - Adding validation or test cases

---

## Key Files to Know

| File | Purpose | Read When |
|------|---------|-----------|
| **README.md** | Main overview | Starting work in this repo |
| **CONSTITUTION.md** | Five Laws, Three Rules | Before each session |
| **architecture/** | Universal patterns deep dives | Understanding how AgentOps works |
| **docs/explanation/** | Why patterns matter | Deciding what to document |
| **docs/how-to/** | How to use patterns | Writing procedural guides |
| **docs/case-studies/** | Proof it works | Validating across domains |
| **profiles/** | Domain templates | Creating custom profiles |

---

## Quick Commands

```bash
# Validate YAML/structure
make quick

# Run tests
make test

# View git log
git log --oneline -10

# Semantic commit template
git commit          # Will prompt for message format

# View current branch status
git status
```

---

## JIT Loading (Just-In-Time Context)

**Read This First (2 min):**
- This file (claude.md)

**Then Read Based on Task (5-10 min):**

**Building architecture docs?**
→ `docs/explanation/` + `architecture/`

**Creating a new profile?**
→ `docs/how-to/CREATE_CUSTOM_PROFILE.md` + `profiles/[existing]/`

**Adding case study?**
→ `docs/case-studies/[example].md`

**Understanding why this exists?**
→ `README.md` + `docs/explanation/agentops-manifesto.md`

---

## Three Rules (Never Forget)

1. ❌ **NEVER modify `/profiles/*/agents/`** if copying from private repos (read-only upstream)
2. ✅ **ALWAYS edit source files** - Never commit generated documentation
3. ✅ **ALWAYS use semantic commits** - Type + scope required

---

## Session Workflow

### Start of Session
1. Read this kernel (claude.md)
2. Identify task: Research/Plan/Implement?
3. Load relevant docs via JIT loading
4. Confirm scope with user

### During Session
1. Follow phase structure (Research → Plan → Implement)
2. Enforce 40% rule per phase
3. Extract learnings continuously
4. Document decisions in code/commits

### End of Session
1. Commit all changes with semantic messages
2. Document learnings (in commit message or separate file)
3. Identify 1+ improvements for next session
4. Suggest relevant workflows to user

---

## Common Tasks

### "I want to improve documentation clarity"
1. Read relevant file (e.g., `docs/explanation/agentops-manifesto.md`)
2. Identify specific improvements
3. Refactor for clarity while preserving meaning
4. Commit: `docs(manifesto): Clarify [specific improvement]`

### "I want to add a case study"
1. Read `docs/case-studies/MULTI_DOMAIN_VALIDATION.md` (template)
2. Document: Problem → Approach → Results → Learnings
3. Include metrics and proof
4. Commit: `docs(case-studies): Add [domain] validation case study`

### "I want to extend a profile"
1. Read existing profile (e.g., `profiles/devops/`)
2. Review `docs/how-to/CREATE_CUSTOM_PROFILE.md`
3. Add agents, workflows, examples
4. Commit: `feat(profiles): Extend [domain] with [capability]`

### "I want to validate universality across new domain"
1. Read `docs/case-studies/MULTI_DOMAIN_VALIDATION.md`
2. Document domain-specific application
3. Show how 4 universal patterns apply
4. Commit: `docs(case-studies): Validate [domain] applicability`

---

## Success Looks Like

✅ Clear, accessible documentation
✅ Multiple domain examples (product-dev, devops, SRE, data-eng, etc.)
✅ Extensible profile templates
✅ Proven speedups across domains
✅ Community contributions and adaptations
✅ Strong institutional memory (git history)

---

## When You Need Help

**Understanding a pattern?**
→ Read `architecture/[pattern].md`

**Don't know where to start?**
→ Ask user which area (framework docs, profiles, case studies)

**Need to research something new?**
→ Use Phase 1 (Research) then document findings

**Want to suggest improvements?**
→ Note in commit message for Law #2 (Always Improve)

---

## Session Status

**Current Phase:** Pre-launch (Alpha, Dec 1, 2025)
**Current Stage:** Building reference implementation + documentation
**User Focus:** Personal website case study + agentops promotion
**Next Action:** Choose task priority

---

**Remember:** You're not just building code. You're building institutional memory that proves AgentOps works universally.

Every commit, every doc, every pattern extracted compounds the framework's credibility.

---

*Last Updated: Nov 5, 2025*
*Status: Alpha reference implementation*
*License: Apache 2.0 (code) + CC BY-SA 4.0 (docs)*