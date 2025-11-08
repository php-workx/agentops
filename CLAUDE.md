# AgentOps Repository Kernel

**AI Agent Operations Framework** – Operating System for Multi-Agent Intelligence

**Purpose:** Guide AI agents and developers to build, improve, and contribute reliable AI agent systems
**Status:** Alpha reference implementation (Dec 1, 2025 public launch)
**Last Updated:** Nov 5, 2025

---

## What is AgentOps?

**"One Skill to Rule Them All" - The meta orchestrator for AI agent workflows.**

AgentOps is **THE meta-skill** that orchestrates all other plugins automatically. With a single `/orchestrate` command, it discovers available plugins, plans optimal workflows, executes tasks, and learns patterns for future reuse.

**The Magic:**
```bash
/orchestrate "any task description"
# → All 4 phases execute automatically
# → Pattern saved to Neo4j
# → Available for reuse via /browse-patterns
```

**Core Capabilities:**

- **Single-Command Orchestration:** One `/orchestrate` command runs all phases (Discover → Plan → Execute → Learn)
- **Autonomous Execution:** No manual plugin selection - automatically finds and composes optimal tools
- **Browsable Pattern Library:** Explore and reuse discovered workflows via `/browse-patterns`, `/inspect-pattern`, `/replay-pattern`
- **Intelligent Prompt Engineering:** `/craft-prompt` helps craft perfect prompts based on Neo4j knowledge graph
- **Continuous Learning:** Every execution improves the system - 90%+ success rate on AI-generated workflows

**Proven Results:**

- 40x speedup in product development (AI-assisted workflows)
- 3x speedup in multi-plugin orchestration tasks
- 90%+ success rate for AI-generated workflows
- 95% success rate across 204 documented sessions
- Applied universally: product dev, infrastructure, SRE, data engineering, plugin marketplace

**Core Insight:** One command discovers, plans, executes, and learns. No complex workflows - just describe what you want. The more you use `/orchestrate`, the smarter it gets.

---

## Understanding AgentOps: Meta Orchestrator Architecture

**Like Kubernetes for plugin orchestration:**

```ascii
CORE PLATFORM (Always Installed)
├── 12 universal commands (research, plan, implement, validate, learn)
├── 9 base agent personas (explorer, architect, executor roles)
├── 6 workflow orchestrations (complete-cycle, debug-cycle, etc.)
└── Skills framework (automation hooks)
         ↓ Extends to...

PROFILES (Like Kubernetes CRDs)
├── example profile (template for creating custom)
├── devops profile (K8s, containers, CI/CD)
├── product-dev profile (APIs, UIs, databases)
├── data-eng profile (pipelines, transformations, quality)
└── your custom profile (your domain, your stack)
         ↓ Applied by...

FRAMEWORK (12-factor-agentops)
└── Philosophical foundation (Four Pillars, Five Laws, 40% rule)

VALIDATION LAYER: OPERATORS (watch-reconcile loops)
         ├── Workflow Operator (ensures outputs pass validation)
         ├── Context Operator (enforces 40% rule)
         └── Memory Operator (maintains knowledge navigability)
```

**This repository (agentops) is the META ORCHESTRATOR:**

- Provides intelligent plugin orchestration (discovery, planning, execution, learning)
- Meta-level reasoning about available tools and how to compose them
- Enables orchestration across any plugin marketplace or tool ecosystem
- Learns patterns from executions to improve future orchestrations
- Community contributes discovered patterns to shared library

**Kubernetes metaphor:**

- **Core platform** = Kubernetes control plane (universal orchestration)
- **Profiles** = Custom Resource Definitions (domain-specific resources)
- **Commands** = Controllers (execute workflows)
- **Agents** = Operators (specialized automation)
- **Skills** = Admission webhooks (validation, mutation)
- **Community** = Ecosystem (shared profiles and patterns)

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

**File:** `docs/project/STRATEGY.md`
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

**File:** `docs/guides/EXECUTION_GUIDE.md`
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

## Workflow Packages & Operators: Making Agents Reliable

### What Are Workflow Packages?

**Workflow Packages are reusable, domain-specific bundles of agents and workflows** (like Helm charts for Kubernetes):

**Examples:**

- **product-dev package** - Spec-first product workflows (design → implement → test → ship)
- **infrastructure-ops package** - Research-first DevOps workflows (research → plan → implement)
- **devops package** - 52 GitOps agents for production infrastructure
- **custom packages** - Organizations build domain-specific bundles (legal-tech, financial-analysis, medical-research)

**Just like Helm charts:**

- Versioned (v1.0.0, v1.1.0)
- Customizable (values.yaml → profile customization)
- Installable (agentops orchestrates identically regardless of package)
- Reusable (same package works across organizations)

**Key insight:** The **orchestrator (agentops) works identically for any workflow package**. Like Kubernetes doesn't care if you deploy nginx (web server) or postgres (database)—same orchestration patterns apply.

---

### What Are Operators?

**Operators are watch-reconcile loops that continuously validate agent work and enforce quality standards.**

Three types of operators ensure agent reliability:

#### 1. Workflow Operator

**Watches:** Agent outputs (files, commands, decisions)
**Ensures:** Validation passes before execution
**Reconciles:** Rejects non-compliant outputs, requests rework

**Example:** Agent creates Kubernetes application

```yaml
WATCH: New files created in apps/my-app/
VALIDATE:
  ✓ kustomize build succeeds
  ✓ YAML syntax valid
  ✓ Required files present
  ✓ Naming conventions followed
RECONCILE:
  If validation fails → Reject + feedback
  If validation passes → Allow commit
```

**Result:** 95% success rate, zero invalid configs in production

---

#### 2. Context Operator

**Watches:** Token usage and context window utilization
**Ensures:** Context stays under 40% threshold (prevents degradation)
**Reconciles:** Compresses context, archives to bundles, or restarts session

**Why:** Agents degrade at ~40% context capacity (hallucinations, lost instructions). Operators prevent this automatically.

---

#### 3. Memory Operator

**Watches:** Institutional memory (codex) growth and organization
**Ensures:** Knowledge base remains navigable and useful
**Reconciles:** Deduplicates patterns, reorganizes, archives dormant knowledge

**Why:** As Git history grows, future agents need to find relevant patterns quickly.

---

### Why Operators + Packages = Reliable Agent Operations

**Without operators:**

- Agent produces output → No validation → Errors reach production → Human debugs → Slow recovery

**With operators:**

- Agent produces output → Operator validates → Errors caught immediately → Auto-feedback → Agent self-corrects → Faster execution

**Result:** Self-healing, continuously validated agent workflows that improve over time.

---

## Repository Structure

### Core Platform (Always Installed)

```
agentops/
├── claude.md                          ← You are here (kernel)
├── STRATEGY.md                        ← Mission & direction
├── README.md                          ← Main documentation
├── CONSTITUTION.md                    ← Five Laws + Three Rules
│
├── core/                              ← Universal orchestration (like K8s control plane)
│   ├── CONSTITUTION.md                Five Laws, 40% rule, core rules
│   ├── commands/                      12 universal commands
│   │   ├── prime.md, prime-simple.md, prime-complex.md
│   │   ├── research.md, research-multi.md
│   │   ├── plan.md, implement.md
│   │   ├── validate.md, validate-multi.md
│   │   ├── learn.md
│   │   └── bundle-save.md, bundle-load.md
│   ├── agents/                        9 reusable personas
│   │   ├── code-explorer.md, doc-explorer.md, history-explorer.md
│   │   ├── spec-architect.md, validation-planner.md, risk-assessor.md
│   │   └── change-executor.md, test-generator.md, continuous-validator.md
│   ├── workflows/                     6 universal workflows
│   │   ├── complete-cycle.md, quick-fix.md, debug-cycle.md
│   │   ├── knowledge-synthesis.md, continuous-improvement.md
│   │   └── multi-domain.md
│   └── skills/                        Automation framework
│       └── README.md
│
├── profiles/                          ← Domain extensions (like K8s CRDs)
│   ├── example/                       Template for creating custom
│   │   ├── profile.yaml               Manifest (like CRD definition)
│   │   ├── README.md
│   │   ├── agents/                    Domain-specific agents
│   │   ├── commands/                  Command overrides (optional)
│   │   ├── workflows/                 Domain workflows
│   │   └── skills/                    Domain automation
│   ├── devops/                        K8s, containers, CI/CD
│   ├── product-dev/                   APIs, UIs, databases
│   ├── data-eng/                      Pipelines, transformations
│   └── [your-custom]/                 Community profiles
│
├── docs/                              ← Developer guides
│   ├── CREATE_PROFILE.md              How to create profiles
│   ├── EXTEND_CORE.md                 How to extend core
│   └── GET_STARTED.md                 Installation & usage
│
├── scripts/                           ← Installation & validation
│   ├── install.sh                     Install core + profiles
│   └── validate-profile.sh            Profile validation
│
└── .git/                              ← Institutional memory
```

**Key insight:** Core is stable platform. Profiles evolve independently. Community contributes profiles.

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
| **docs/architecture/** | Universal patterns deep dives | Understanding how AgentOps works |
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
→ `docs/explanation/` + `docs/architecture/`

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
3. Read `docs/architecture/` - Understand the 4 universal patterns
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

→ Read `docs/architecture/[pattern-name].md` for deep dive

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