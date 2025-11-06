# Multi-Flavor Example: Using Both Profiles in One Project

This example shows how **agentops orchestrates multiple agent operating systems** in a single project—the core innovation of the orchestrator layer.

---

## The Scenario

You're building a modern application with two distinct workstreams:

1. **Product Development** - Building customer-facing features
2. **Infrastructure Operations** - Building and maintaining the platform

Each workstream needs a different agent operating system (flavor).

---

## Project Structure

```
my-startup/
├── agentops/                                    # Orchestration layer
│   ├── product-dev/                             # Product flavor
│   │   ├── product/
│   │   │   ├── mission.md
│   │   │   ├── roadmap.md
│   │   │   └── tech-stack.md
│   │   └── specs/
│   │       ├── 2025-11-06-user-authentication/
│   │       ├── 2025-11-07-payment-integration/
│   │       └── 2025-11-08-notification-system/
│   │
│   └── infrastructure-ops/                      # Ops flavor
│       ├── research/
│       │   ├── k8s-upgrade-research.md
│       │   ├── monitoring-strategy-research.md
│       │   └── disaster-recovery-research.md
│       └── plans/
│           ├── k8s-upgrade-plan.md
│           ├── monitoring-plan.md
│           └── dr-plan.md
│
├── src/                                         # Product code
│   ├── auth/                                    # From product-dev/specs/2025-11-06-*
│   ├── payments/                                # From product-dev/specs/2025-11-07-*
│   └── notifications/                           # From product-dev/specs/2025-11-08-*
│
└── infrastructure/                              # Infrastructure code
    ├── kubernetes/                              # From infrastructure-ops/plans/k8s-*
    ├── monitoring/                              # From infrastructure-ops/plans/monitoring-*
    └── disaster-recovery/                       # From infrastructure-ops/plans/dr-*
```

---

## Timeline: Two Parallel Workstreams

### Week 1: Product Work (product-dev flavor)

**Goal:** Define authentication system

```
Monday:
  Product manager → Writes feature description
  Researcher agent (product-dev) → Researches auth patterns
  Output: agentops/product-dev/specs/2025-11-06-auth/planning/requirements.md

Tuesday:
  Spec writer agent (product-dev) → Creates detailed spec
  Output: agentops/product-dev/specs/2025-11-06-auth/spec.md

Wednesday-Thursday:
  Developer agents → Implement auth system
  Output: /src/auth/ (production code)

Friday:
  QA → Verification
  Product → Validation against roadmap
```

### Week 1: Ops Work (infrastructure-ops flavor)

**Goal:** Plan Kubernetes upgrade

```
Monday-Tuesday:
  Researcher agent (infrastructure-ops) → Deep research on K8s 1.29 upgrade
  Output: agentops/infrastructure-ops/research/k8s-upgrade-research.md

Wednesday-Thursday:
  Planner agent (infrastructure-ops) → Create detailed upgrade plan
  Output: agentops/infrastructure-ops/plans/k8s-upgrade-plan.md

Friday:
  Team review → Approve plan
  Scheduled for Week 3 implementation
```

### Week 2: Parallel Development

Both workstreams continue in parallel:

```
product-dev working on:
  - Payment integration (spec → implementation)
  - Notification system (spec → implementation)

infrastructure-ops working on:
  - Monitoring strategy (research → planning)
  - Disaster recovery (research → planning)
```

### Week 3: Implementation Sprint

```
Monday-Tuesday:
  Both teams implement their planned work
  - Product: auth, payments, notifications
  - Ops: Kubernetes upgrade, monitoring rollout

Wednesday:
  Both teams test and validate

Thursday-Friday:
  Both teams resolve issues and merge to production
```

---

## Context Bundles in Action

### Product Team (product-dev) - Multi-Day Features

```bash
# Day 1: Research phase
/research "Payment integration requirements"
# → Generates research.md with findings

# Save for reuse
/bundle-save payment-integration-research

# Day 2: Plan from bundle
/bundle-load payment-integration-research
/plan research.md
# → Generates plan.md with implementation details

# Save for implementation
/bundle-save payment-integration-plan

# Day 3: Implement from bundle
/bundle-load payment-integration-plan
/implement plan.md
# → Executes with validation gates
```

### Ops Team (infrastructure-ops) - Multi-Week Projects

```bash
# Week 1: Deep research
/research "Kubernetes upgrade strategy"
# → Generates comprehensive research.md

/bundle-save k8s-upgrade-research

# Week 2: Planning from bundle
/bundle-load k8s-upgrade-research
/plan research.md
# → Generates detailed, phased plan

/bundle-save k8s-upgrade-plan

# Week 3: Execute from bundle
/bundle-load k8s-upgrade-plan
/implement plan.md --dry-run        # Dry run first
/implement plan.md --execute        # Then execute
```

---

## The Orchestration Magic ✨

**What makes this powerful:**

1. **Right tool for right job**
   - Product team uses product-dev (fast, focused on features)
   - Ops team uses infrastructure-ops (thorough, focused on reliability)

2. **Parallel execution**
   - Both teams work simultaneously on different problems
   - agentops orchestrates both without conflict

3. **Service mesh between systems**
   ```
   When product changes authentication:
   → Ops needs to update monitoring rules
   → agentops routes: "product-dev specs" → "infrastructure-ops planning"
   → Ops team can research monitoring implications
   ```

4. **Shared institutional knowledge**
   ```
   Bundles are shared across teams:
   - Product research → useful for ops understanding
   - Ops research → informs product constraints
   - Both teams benefit from combined knowledge
   ```

5. **Multi-day projects with context preservation**
   ```
   Day 1 (Monday):   Research phase (fresh context)
   Day 2 (Tuesday):  Load bundle (context restored)
   Day 3 (Wednesday): Load plan bundle (continue with fresh context)

   No context collapse thanks to bundles + orchestration
   ```

---

## Why This Is Better Than Single-Flavor Approach

### Single Flavor (Old Way)
```
Everything uses 7-phase granular workflow:
- Product features: overkill ceremony
- Infrastructure: insufficient research depth

Result: Friction, context collapse, suboptimal decisions
```

### Multi-Flavor Orchestrated (New Way)
```
product-dev (7 phases, spec-driven):
✅ Fast iteration for features
✅ Clear product vision
✅ User feedback loop

infrastructure-ops (3 phases, research-driven):
✅ Deep understanding for complex infrastructure
✅ Careful planning for high-stakes changes
✅ Built-in safety and validation

agentops orchestrates both:
✅ No context collapse (bundles)
✅ Parallel execution (faster)
✅ Service mesh (integration)
✅ Right tool for right job
```

---

## Key Lessons

### 1. **Different problems need different approaches**
- Fast feature development ≠ Infrastructure changes
- Spec-driven workflow works great for product
- Research-driven workflow works great for ops

### 2. **Orchestration enables both**
- agentops doesn't force you to choose
- Use the right flavor for the right work
- Both flavors coexist peacefully

### 3. **Bundles enable multi-day work**
- Research bundles (5:1 compression) preserve findings
- Plan bundles preserve specifications
- Enables fresh context per phase without context collapse

### 4. **Context windows are the constraint**
- Not token limits (those are managed)
- But cognitive load per phase
- Bundles solve this: compress → reuse → fresh context

### 5. **DevOps principles apply to knowledge work**
- Parallel execution (microservices pattern)
- Service mesh (agent communication)
- Orchestration layer (agentops)
- Observability (metrics on agent performance)

---

## The Orchestrator Value

**agentops = Kubernetes for agent systems**

```
Kubernetes does for containers:
├── Schedules workloads
├── Orchestrates parallel execution
├── Provides service mesh
├── Enforces deployment patterns
└── Manages lifecycle

agentops does for agent systems:
├── Schedules agent work to right flavor
├── Orchestrates parallel agent teams
├── Provides service mesh (agent communication)
├── Enforces constitutional laws
└── Manages lifecycle (research → plan → implement)
```

**Result:** Your team can work faster, safer, and more intelligently on diverse problems using the exact right tool for each job.

---

## Try This Structure

Copy this structure for your project:

```bash
mkdir -p agentops/product-dev/{product,specs}
mkdir -p agentops/infrastructure-ops/{research,plans}

# Sync both flavors
git add agentops/
git commit -m "feat(agentops): add multi-flavor orchestration structure"
```

Then:
- Use `product-dev` for feature work
- Use `infrastructure-ops` for infrastructure/operations work
- Let agentops orchestrate both
- Watch your team's productivity and decision quality improve

---

**This is the future of knowledge work orchestration.** 🚀

*Kubernetes showed us that orchestration layer > individual system design*
*agentops applies that lesson to AI agent operating systems*
