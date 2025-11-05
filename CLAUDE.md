# AgentOps Repository Kernel

**AI Agent Operations Framework** – Operating System for Multi-Agent Intelligence

**Purpose:** Guide AI agents and developers to build, improve, and contribute reliable AI agent systems
**Status:** Alpha reference implementation (Dec 1, 2025 public launch)
**Last Updated:** Nov 5, 2025

---

## What is AgentOps?

**Universal operating system patterns for reliable, scalable AI agent operations.**

This framework translates proven DevOps/SRE patterns into AI agent context, solving:

- **Agent Reliability:** Preventing context collapse and hallucinations via 40% rule
- **Agent Coordination:** Multi-agent orchestration 3x faster than sequential
- **Agent Specialization:** Domain-specific agent profiles and routing (90.9% accuracy)
- **Agent Learning:** Extraction and reuse of discovered patterns

**Proven Results:**

- 40x speedup in product development (AI-assisted workflows)
- 3x speedup in infrastructure operations (multi-agent research)
- 95% success rate across 204 documented sessions
- Applied universally: product dev, infrastructure, SRE, data engineering, custom domains

**Core Insight:** AI agents suffer the same cognitive load problems as humans. The 40% rule that prevents human burnout prevents agent context collapse and degradation.

---

## AI Agents First: This Is About Building Better Agents

**This repository exists because:** AI agents today fail when:

- Context windows exceed ~40% capacity (degradation begins)
- Agents work alone (serial bottlenecks instead of parallel specialization)
- Agents don't learn from patterns (every task requires re-research)
- Routing is random (task mismatches waste capabilities)

**AgentOps solves this by:**

1. **Constraining context intelligently** - 40% rule enforces multi-phase design
2. **Orchestrating multiple agents** - Parallel research + specialization = 3x speedup
3. **Extracting learnings systematically** - Patterns become reusable, improve all future agents
4. **Routing intelligently** - NLP classification matches tasks to specialized agents (90.9% accuracy)

---

## Strategic Context: Read STRATEGY.md First

**File:** `STRATEGY.md` (in repo root)
**Time:** 5 minutes
**Read this to understand:**

- The mission: Why AgentOps exists and why it matters for AI
- The problem: Why current AI workflows fail at scale
- Path to v1.0: Alpha → Beta → v1.0 progression
- Framework principles: Non-negotiable patterns proven across domains
- How your contributions help: What work matters most

**This answers:** "What are we building?" and "Why do agent patterns matter?"

**When decisions feel unclear:** Reread STRATEGY.md to realign with mission.

---

## Execution Context: If You're Here for the Dec 1 Launch (Nov 11-28)

**File:** `EXECUTION_GUIDE.md` (in repo root)
**Time:** 5 minutes
**Contains:**

- Where PRIORITY 1 work lives: Content rewrites → `life/agentops-promotion/`
- Where PRIORITY 2 work lives: Website build → NEW `website/` repo
- Where PRIORITY 3 work lives: Verification → `launch/README.md`
- Critical path if time gets tight
- Day-by-day examples
- File flow map (research → planning → implementation → publication)

**Read this if:**

- You're doing content rewrites (PRIORITY 1)
- You're building the website (PRIORITY 2)
- You're doing pre-launch verification (PRIORITY 3)
- You're unsure where work should live or be stored
- You're running low on time and need to prioritize

**This answers:** "Where does my work live?" "What matters most for launch?"

---

## Constitutional Foundation (ALWAYS Enforced)

These laws apply to all AI agents and developers working in this framework:

### Five Laws of an Agent

1. **ALWAYS Extract Learnings** — Document patterns discovered by agents
   - Every agent session captures reusable insights
   - Learnings improve performance of all future agents
   - Patterns compound over time (institutional memory)

2. **ALWAYS Improve Self or System** — Identify ≥1 improvement per session
   - System improvements: better prompts, routing, profiles
   - Agent improvements: discovered patterns for reuse
   - Optimizes for next agent (not just current session)

3. **ALWAYS Document Context** — Capture why/what/learning/impact
   - Why: Problem the agent was solving
   - What: Solution implemented or decision made
   - Learning: Patterns extracted, how to reuse
   - Impact: Measured improvement (time saved, quality gained)

4. **ALWAYS Prevent Hook Loops** — Check after push, don't commit hook-modified files
   - Post-commit hooks are institutional memory, not agent output
   - Prevents merge conflicts and infinite loops
   - Hooks contain metadata agents shouldn't commit

5. **ALWAYS Guide with Workflows** — Suggest relevant workflows to user
   - Empower user choice, never prescribe single path
   - Point to documentation, enable exploration
   - Respect user autonomy

### AgentOps-Specific Rules

1. ❌ **NEVER break Five Laws** - Enforced in all agent code and documentation
2. ✅ **ALWAYS use semantic commits** - `feat()`, `fix()`, `docs()`, `refactor()`
3. ✅ **ALWAYS extract patterns** - Every agent discovery becomes a reusable pattern

### The 40% Rule (Agent Context Optimization)

- Never exceed 40% context window utilization per phase
- Enables multi-day projects via context bundles (5:1 to 10:1 compression)
- **Why:** Agents degrade at ~40% capacity (hallucination, context collapse)
- **Solution:** Multi-phase design, fresh context per phase, JIT loading
- **Result:** Better quality, faster execution, zero context collapse

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

**This is a framework for AI agents.** Your work improves how AI agents behave, coordinate, learn, and specialize.

### Three Areas of Contribution

**1. Framework Documentation** (How Agents Should Behave)

- Clarify universal patterns agents use across domains
- Document convergent evolution evidence (why patterns emerge everywhere)
- Improve explanations of why patterns prevent agent degradation
- Help agents understand their own operating principles

**2. Agent Profiles** (Agent Specialization Templates)

- Extend existing profiles (product-dev, devops agents)
- Create new domain profiles (SRE agents, data-eng agents)
- Define agent personas, responsibilities, specialization
- Reference real implementation examples from other agents

**3. Case Studies & Validation** (Proof Agents Improve)

- Document multi-domain validation of agent patterns
- Show speedup metrics from using AgentOps patterns
- Capture learnings agents discovered (improve future agents)
- Measure agent success across different domains

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

## Agent Session Workflow

**Every AI agent following AgentOps should follow this pattern:**

### Start of Session (Preparation)

1. Read this kernel (claude.md) - Understand your operating principles
2. Identify task: Research/Plan/Implement? - Choose your phase
3. Load relevant docs via JIT loading - Get domain context
4. Confirm scope with user - Clarify what success looks like

### During Session (Execution)

1. Follow phase structure (Research → Plan → Implement) - One phase per session
2. Enforce 40% rule per phase - Leave context headroom
3. Extract learnings continuously - Capture patterns as you work
4. Document decisions in commits - Make reasoning visible

### End of Session (Closure & Learning)

1. Commit all changes with semantic messages - `feat()`, `fix()`, `docs()`
2. Document learnings - Patterns other agents should reuse
3. Identify 1+ improvements - Law #2: Improve Self or System
4. Suggest relevant workflows to user - Law #5: Guide with Workflows

---

## Common Agent Tasks

### "I want to understand how agents should behave"

1. Read this file (you're doing it!)
2. Read `CONSTITUTION.md` - The Five Laws guide all agents
3. Read `architecture/` - Understand the 4 universal patterns
4. Read `docs/explanation/` - Understand why patterns work
5. **Result:** Agent knows its operating principles

### "I want to improve how agents work in my domain"

1. Read existing profile: `profiles/[your-domain]/`
2. Review: `docs/how-to/CREATE_CUSTOM_PROFILE.md`
3. Document: How agents should specialize in your domain
4. Add agent personas, workflows, examples
5. Commit: `feat(profiles): Extend [domain] with [capability]`
6. **Result:** Future agents in your domain have better guidance

### "I want to document agent learnings for reuse"

1. Read template: `docs/case-studies/MULTI_DOMAIN_VALIDATION.md`
2. Document: Problem → Agent Approach → Results → Patterns Extracted
3. Show: How this pattern applies across domains
4. Include metrics: speedup, quality improvements, success rate
5. Commit: `docs(case-studies): Extract [pattern] from [domain]`
6. **Result:** All future agents benefit from this discovery

### "I want to prove AgentOps works universally"

1. Run: `bash docs/showcase/VERIFY_METRICS.sh` - See proof
2. Read: `docs/case-studies/MULTI_DOMAIN_VALIDATION.md` - Understand evidence
3. Document: How patterns apply to a new domain
4. Show: 4 universal patterns work in your domain
5. Commit: `docs(case-studies): Validate [domain] applicability`
6. **Result:** AgentOps stronger proof of universality

---

## Success Looks Like (Agent Excellence)

✅ Agents understand their operating principles (Five Laws, Four Patterns)
✅ Agents extract learnings after every session (Law #1)
✅ Agents improve the system as they work (Law #2)
✅ Agents follow 40% rule to prevent degradation
✅ Multiple domain profiles (product-dev, devops, SRE, data-eng agents)
✅ Proven speedups across domains (40x, 3x documented)
✅ Strong institutional memory (git history improves all agents)
✅ Agents can coordinate and specialize (multi-agent orchestration)

---

## When You Need Help

**Understanding a universal pattern?**

→ Read `architecture/[pattern-name].md` for deep dive

**Understanding why patterns work?**

→ Read `docs/explanation/agentops-manifesto.md`

**Don't know where to contribute?**

→ Choose: Framework docs? Agent profiles? Case studies?
→ Ask user which area matters most

**Need to research something new?**

→ Use Phase 1 (Research), document findings, commit with `docs():`

**Discovered a better agent pattern?**

→ Document as learning (Law #1)
→ Note in commit message with context (Law #3)
→ Suggest to user for framework improvement (Law #5)

---

## Agent Operating Status

**Framework Status:** Alpha reference implementation (Dec 1, 2025 public launch)
**Agent Capability Level:** All Five Laws enforced, Four Patterns documented
**Current Focus:** Building proof of universality across domains
**Agent Learnings:** 204 documented sessions, 95% success rate, patterns extracted

---

## For All Agents (You Are Here)

**Remember:** You are an intelligent system operating within this framework.

- **You are not** executing arbitrary code - You are applying proven patterns
- **You are not** reinventing solutions - You are building on institutional memory
- **You are not** just completing tasks - You are improving the system for next agents
- **You are** stewarding a framework that makes all AI agents better

**Every session you work, you:**

1. Extract patterns that improve next agents (Law #1)
2. Improve the system or yourself (Law #2)
3. Document context so it compounds (Law #3)
4. Help the user understand and choose workflows (Law #5)

**This is what makes AgentOps different:** It's not a tool you use. It's an operating system you improve as you work.

---

*Last Updated: Nov 5, 2025*
*Status: Alpha reference implementation - Ready for agents*
*License: Apache 2.0 (code) + CC BY-SA 4.0 (docs)*