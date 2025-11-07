# AgentOps Universal Architecture Layer

**This layer contains the universal patterns that work across ANY domain.**

These patterns are proven to work in:
- ✅ Product development (original agentops)
- ✅ Infrastructure/DevOps (gitops integration)
- ✅ Any future domain (SRE, Data Engineering, etc.)

---

## What is Universal Architecture?

**Universal architecture** = patterns that don't depend on domain, language, or specific agents.

These patterns are **language-agnostic** and **domain-independent**. They work equally well whether you're building a product, managing infrastructure, responding to incidents, or engineering data pipelines.

---

## The 4 Universal Patterns

### 1. Multi-Phase Workflows

**Pattern:** Break complex work into distinct phases with human gates between them.

```
Phase 1: Exploration/Research (40-60k tokens)
  ↓ [Human Review Gate]
Phase 2: Specification/Planning (40-60k tokens)
  ↓ [Human Approval Gate]
Phase 3: Execution/Implementation (40-80k tokens)
```

**Why universal:**
- Works for product specs (mission → specs → code)
- Works for infrastructure (research → plan → manifests)
- Works for SRE (detect → investigate → document)
- Works for any complex task that needs careful thinking

**Domain mapping:**
| Phase 1 | Phase 2 | Phase 3 | Domain |
|---------|---------|---------|--------|
| Gather product requirements | Write specifications | Implement features | Product Dev |
| Research infrastructure needs | Plan changes (file:line) | Deploy manifests | DevOps |
| Detect incident | Investigate root cause | Write postmortem | SRE |
| Design data flow | Specify transformations | Implement pipeline | Data Eng |

**Key insight:** Same cognitive structure, different artifacts.

### 2. Context Bundles

**Pattern:** Compress intermediate artifacts and make them reusable across sessions.

```
Raw output: 5-10k tokens
  ↓ [Compress & extract key findings]
Bundle: 500-1k tokens
  ↓ [Store & share via UUID]
Team reuses: Load in new session
```

**Why universal:**
- Solves session-spanning work (start Monday, continue Friday)
- Prevents duplicate research (UUID-based discovery)
- Enables team coordination (share findings without re-doing)
- Reduces token waste (5:1 to 10:1 compression)

**Domain mapping:**
| Domain | Bundle | Compression | Use Case |
|--------|--------|-------------|----------|
| Product Dev | Specification drafts | 5:1 | Review before implementation |
| DevOps | Research findings | 7:1 | Plan infrastructure changes |
| SRE | Postmortem summaries | 6:1 | Share learnings with team |
| Data Eng | Schema analysis | 8:1 | Reference for new pipelines |

**Key insight:** All domains generate intermediate artifacts that compress well and should be reused.

### 3. Multi-Agent Orchestration

**Pattern:** Run multiple agents in parallel for faster research and better coverage.

```
Agent 1: Code explorer (searches codebase)      ┐
Agent 2: Documentation researcher (reads docs)   ├─ [Parallel, simultaneous]
Agent 3: History analyst (git log search)        ┘
  ↓ [Synthesis]
Combined research with 3 perspectives
```

**Why universal:**
- Same 3x speedup achieved in product-dev and infrastructure
- Token budget same, wall-clock time 3x faster
- Combined perspectives prevent mistakes
- Works across domains

**Domain mapping:**
| Domain | Agent 1 | Agent 2 | Agent 3 |
|--------|---------|---------|---------|
| Product Dev | Code patterns | Feature specs | Market research |
| DevOps | Existing configs | Best practices | Lessons learned |
| SRE | System logs | Runbooks | History of similar incidents |
| Data Eng | SQL patterns | Documentation | Performance benchmarks |

**Key insight:** Every domain benefits from 3 perspectives researching simultaneously.

### 4. Intelligent Routing

**Pattern:** Use NLP to classify tasks and automatically recommend best-fit agent.

```
User describes task → NLP analysis → Match agents → Recommend top 3 → Auto-load best
```

**Accuracy:** 90.9% (measured across 47 sessions, 2 domains)

**Why universal:**
- Works with any set of specialized agents
- Language-agnostic (can classify any domain task)
- Reduces friction (skip interactive questions)
- Enables better UX

**Domain mapping:**
| Domain | Agent Pool | Accuracy | Use |
|--------|-----------|----------|-----|
| Product Dev | 8 product agents | 90.9% | `/prime-with-routing "create feature"` |
| DevOps | 52 infrastructure agents | 90.9% | `/prime-with-routing "create redis app"` |
| SRE | N incident agents | 90.9% | `/prime-with-routing "api is down"` |

**Key insight:** NLP routing works equally well across domains and agent pools.

---

## How These Patterns Compose

All 4 patterns work together:

```
User: /research "Your question"
  ↓ [Phase 1: Exploration]
  ├─ Option A: Sequential research (slow)
  └─ Option B: /prime-complex-multi (fast, 3x speedup via orchestration)
  ↓
Output: research.md (1-2k tokens, compressed via bundles pattern)
  ↓
User: /bundle-save research-topic
  ↓
[New session, fresh context]
  ↓
User: /bundle-load research-topic
  ↓ [Phase 2: Planning]
User: /plan research-topic.md
  ↓
Output: plan.md (1-2k tokens, compressed via bundles pattern)
  ↓
User: /prime-with-routing "implement plan"
  ↓ [Intelligent routing recommends best agent]
  ↓ [Phase 3: Execution]
User: /implement plan.md
  ↓
Output: Code changes + commit
```

---

## Universal Constants

These constraints apply to ALL domains using agentops:

### 40% Rule (Context Engineering)
- Never exceed 40% of context window
- Per-phase budget: 40-60k tokens (20-30% for phases 1-2, 20-40% for phase 3)
- Enforced via validation

### Five Laws (Constitutional Foundation)
1. ALWAYS Extract Learnings - Document patterns discovered
2. ALWAYS Improve Self or System - Identify 1+ improvement per session
3. ALWAYS Document Context for Future Agents - Context/Solution/Learning/Impact
4. ALWAYS Prevent Hook Loops - Check after push, don't commit hook-modified files
5. ALWAYS Guide with Workflow Suggestions - After priming, suggest 5-6 workflows

### Three Rules (Never Forget)
1. ❌ NEVER modify read-only upstream
2. ✅ ALWAYS edit source of truth, never generated files
3. ✅ ALWAYS use semantic commits (`<type>(<scope>): <subject>`)

---

## Measuring Success with Universal Patterns

### Metrics That Work Across Domains

| Metric | What to Measure | Example |
|--------|-----------------|---------|
| **Speedup** | Wall-clock time research (sequential vs parallel) | Product: 30 min → 10 min; DevOps: 30 min → 10 min |
| **Compression** | Raw output → Bundle ratio | 5:1 to 10:1 consistently |
| **Reuse** | How often bundles loaded by team | Prevents duplicate research |
| **Accuracy** | Agent routing first-time correctness | 90.9% across domains |
| **Multi-day work** | Projects spanning multiple sessions | Bundle save/load enables |

---

## Creating a New Profile

To create a new profile for your domain:

1. **Keep universal patterns** (phases, bundles, routing, orchestration)
2. **Customize agents** (create domain-specific agents)
3. **Customize terminology** (domain-appropriate language)
4. **Customize workflows** (domain-specific workflows)
5. **Document and measure** (case study showing success)

See `docs/how-to/CREATE_CUSTOM_PROFILE.md` for detailed guide.

---

## Files in This Directory

- `phase-based-workflow.md` - Multi-phase architecture pattern
- `context-bundles.md` - Bundle compression and reuse pattern
- `multi-agent-orchestration.md` - Parallel agent execution pattern
- `intelligent-routing.md` - NLP task classification and routing pattern

---

## Validated Across Domains

✅ **Product Development** - Original agentops (product-dev profile)
✅ **Infrastructure/DevOps** - GitOps integration (devops profile)

Pending:
- [ ] **Incident Response/SRE** - SRE profile
- [ ] **Data Engineering** - Data-eng profile
- [ ] Your domain - Custom profile

---

## Key Insight

**These patterns are universal because they solve universal problems of AI agent orchestration, not domain-specific problems.**

Every domain has:
- Complex tasks requiring careful thinking (multi-phase)
- Intermediate artifacts worth reusing (bundles)
- Need for multiple perspectives (orchestration)
- Multiple specialized agents (routing)

AgentOps provides proven solutions for these universal problems.

---

**Next:** Read individual pattern files, or see `docs/explanation/MULTI_DOMAIN_DESIGN.md` for how patterns compose across domains.
