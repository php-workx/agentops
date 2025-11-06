# Infrastructure-Ops Flavor

**Pattern:** Deep research → detailed planning → systematic implementation
**Attribution:** Based on proven GitOps patterns from infrastructure operations
**Best For:** Infrastructure, operations, data engineering, any domain needing rigorous research before execution
**Workspace:** Creates `agentops/infrastructure-ops/` in your project

---

## What This Flavor Is

The **infrastructure-ops** profile is a 3-phase workflow optimized for operational work where deep understanding precedes action.

```
Phase 1: RESEARCH (40-60k tokens)
├── Understand the problem deeply
├── Gather context and constraints
├── Explore multiple approaches
├── Document findings & recommendations
└── Output: research.md bundle

Phase 2: PLAN (30-50k tokens)
├── Design specific implementation
├── Detail exact changes file-by-file
├── Create specification with validation
├── Document decision rationale
└── Output: plan.md bundle

Phase 3: IMPLEMENT (remaining budget)
├── Execute approved plan
├── Validate at each step
├── Document learnings
└── Output: working code + commits
```

**40% rule enforced per phase** to prevent context collapse.

---

## When to Use This Flavor

✅ **Perfect for:**
- Infrastructure operations (k8s upgrades, cluster changes)
- Site reliability engineering (incident investigation, runbooks)
- Data engineering (pipeline design and optimization)
- Security hardening (comprehensive audit + planning + implementation)
- Any work where research depth is critical

❌ **Not ideal for:**
- Quick feature development (use product-dev instead)
- Rapid prototyping (too much ceremony)
- Well-understood problems (skip to plan phase)

---

## Key Differences from product-dev

| Aspect | infrastructure-ops | product-dev |
|--------|------------------------|-----------------|
| **Phases** | 3 (research → plan → implement) | 7 (granular workflow) |
| **Research Focus** | Deep, comprehensive | Targeted for product |
| **Planning** | Detailed implementation specs | Product specification |
| **Use Case** | Infrastructure & operations | Product development |
| **Best When** | Deep understanding needed | Product vision clear |
| **Ceremony** | Streamlined | Comprehensive |

---

## Architecture

```
profiles/infrastructure-ops/
├── agents/                          # Specialized agents
│   ├── researcher.md                # Conducts deep research phase
│   ├── planner.md                   # Creates detailed plans
│   └── implementer.md               # Executes implementation
│
├── workflows/                       # Phase workflows
│   ├── research/
│   │   ├── explore-problem.md
│   │   ├── gather-context.md
│   │   └── document-findings.md
│   ├── plan/
│   │   ├── design-solution.md
│   │   └── create-specification.md
│   └── implementation/
│       ├── execute-plan.md
│       └── validate-results.md
│
├── skills/                          # Reusable skills
│   ├── bundle-save.sh
│   └── bundle-load.sh
│
└── README.md                        # This file
```

---

## Using This Flavor

### Basic Workflow

```bash
# 1. Start research phase
/research "Your question or problem"
# → Generates research.md

# 2. Review and save findings
/bundle-save my-research-topic
# → Compressed bundle for reuse

# 3. Plan based on research
/plan research.md
# → Generates plan.md

# 4. Implement with validation
/implement plan.md
# → Executes with safety gates
```

### Multi-Day Projects (Context Bundles)

```bash
# Day 1: Deep research
/research "Complex infrastructure upgrade"
/bundle-save k8s-upgrade-research

# Day 2: Plan from bundle
/bundle-load k8s-upgrade-research
/plan research.md
/bundle-save k8s-upgrade-plan

# Day 3: Implement from bundle
/bundle-load k8s-upgrade-plan
/implement plan.md
```

---

## Example: Using Both Flavors in One Project

```
my-project/
├── agentops/
│   ├── product-dev/              # Product development
│   │   ├── product/
│   │   │   ├── mission.md
│   │   │   └── roadmap.md
│   │   └── specs/
│   │       └── 2025-11-06-auth-system/
│   │
│   └── infrastructure-ops/     # Infrastructure work
│       ├── research/
│       │   └── k8s-upgrade-research.md
│       └── plans/
│           └── k8s-upgrade-plan.md
│
└── code/
    ├── src/                         # Built from product-dev
    └── infrastructure/              # Built from infrastructure-ops
```

**Use the right flavor for the right work!**

---

## Agents in This Flavor

### Researcher
Conducts deep, comprehensive investigation of problems.

**Responsibilities:**
- Explore problem space thoroughly
- Gather all relevant context
- Document findings and recommendations
- Create research bundles for reuse

**When to use:** Before any major change or unfamiliar problem

---

### Planner
Creates detailed, file-by-file implementation plans.

**Responsibilities:**
- Design specific implementation approach
- Detail exact changes needed
- Document assumptions and constraints
- Create validation gates

**When to use:** After research is complete, before implementation

---

### Implementer
Executes plans with systematic validation.

**Responsibilities:**
- Follow approved plan precisely
- Validate at each step
- Document learnings and decisions
- Create implementation reports

**When to use:** Execute approved plans with confidence

---

## Context Bundles (Multi-Day Projects)

This flavor heavily uses bundles to enable multi-day projects:

```
Bundle = Compressed intermediate artifacts (5:1 to 10:1 compression)

research.md bundle
└── Contains: findings, approaches, recommendations
    └── Reused in: plan phase, shared with team

plan.md bundle
└── Contains: detailed specifications, validation gates
    └── Reused in: implementation phase, shared with team
```

**Benefits:**
- Resume work next day with fresh context
- Share research/plans across team
- Avoid duplicate research
- Maintain 40% rule across days

---

## Philosophy

**This flavor embodies DevOps discipline applied to knowledge work:**

- ✅ **Research first** — Understand before acting
- ✅ **Specification second** — Plan before implementing
- ✅ **Validation third** — Test before deploying
- ✅ **Documentation always** — Capture learnings for future

**It's the scientific method applied to infrastructure and operations.**

---

## Contributing to This Profile

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for:
- How to add new agents to this flavor
- How to propose workflow improvements
- How to share case studies from your domain

---

## Related

- **product-dev** - Product development flavor (better for features)
- **agentops orchestrator** - How these flavors work together
- **12-factor-agentops** - Philosophy behind this approach
- **GitOps patterns** - Original foundation for this flavor

---

## Attribution

This flavor is based on proven patterns from:
- Infrastructure-as-code operations
- GitOps automation workflows
- Site reliability engineering (SRE) practices
- DevOps discipline and rigor

**Original context:** Used successfully across 20+ Kubernetes clusters, federal/DoD infrastructure, complex multi-tenant systems.

**Now orchestrated by agentops** for broader applicability across domains.

---

**Use this flavor when research and planning matter more than speed.**

*3-phase workflow • Context bundles • Infrastructure-focused • DevOps-inspired*
