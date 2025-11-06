# AgentOps Flavors Catalog

**Like Kubernetes supports different workload types, agentops orchestrates different agent operating system flavors.**

Each flavor is an opinionated agent OS optimized for specific domains. Choose the flavor that matches your work.

---

## Available Flavors

### 🏗️ infrastructure-ops

**Pattern:** Research → Plan → Implement
**Best for:** Infrastructure, operations, SRE, data engineering
**Phases:** 3-phase workflow
**Complexity:** Streamlined

**Use when:**
- Deep understanding needed before action
- Working with infrastructure-as-code
- Multi-day projects with context bundles
- Rigorous planning required (k8s upgrades, migrations, security hardening)

**Key features:**
- 40% rule enforced per phase
- Context bundles for multi-day work
- Systematic validation gates
- Research-driven approach

**[Read more →](./infrastructure-ops/)**

---

### 📦 product-dev

**Pattern:** Spec-first development
**Best for:** Product development, feature building
**Phases:** 7-phase granular workflow
**Complexity:** Comprehensive

**Use when:**
- Building new products or features
- Product vision is clear
- Need detailed specifications
- Coordinating product + implementation

**Key features:**
- Product planning (mission, roadmap, tech stack)
- Detailed specification workflow
- Task breakdown and implementation
- Standards and conventions enforcement

**[Read more →](./product-dev/)**

---

### ⚙️ devops

**Pattern:** Multi-agent specialization
**Best for:** DevOps, Kubernetes, GitOps operations
**Agents:** 52 specialized agents
**Complexity:** Domain-specific

**Use when:**
- Working with Kubernetes/containerized infrastructure
- Managing applications, sites, deployments
- Debugging infrastructure issues
- Operating databases, security policies, monitoring

**Key features:**
- 52 production-validated agents
- Intelligent routing (90.9% accuracy)
- Parallel validation (3x faster)
- GitOps patterns integrated

**[Read more →](./devops/)**

---

## Flavor Comparison

| Aspect | infrastructure-ops | product-dev | devops |
|--------|-------------------|-------------|--------|
| **Phases** | 3 (research/plan/implement) | 7 (granular workflow) | Agent-specific |
| **Focus** | Deep understanding | Product specification | Infrastructure specialization |
| **Best for** | Operations, SRE | Product development | Kubernetes, GitOps |
| **Agents** | 3 core agents | 8 workflow agents | 52 specialized agents |
| **Routing** | Workflow-based | Product-focused | Intelligent classification |
| **Complexity** | Streamlined | Comprehensive | Domain-specific |
| **Learning curve** | Low (3 commands) | Medium (7 phases) | High (52 agents) |
| **Time to value** | <10 min (start research) | <30 min (plan product) | Immediate (use agents) |

---

## Choosing a Flavor

### Decision Tree

```
What are you building?

├─ Infrastructure / operations
│  └─ Need deep research first?
│     ├─ YES → infrastructure-ops
│     └─ NO → devops (use specific agents)
│
├─ Product / features
│  └─ Have product vision?
│     ├─ YES → product-dev
│     └─ NO → infrastructure-ops (research first)
│
└─ Kubernetes / GitOps work
   └─ devops (52 agents ready)
```

---

## Using Multiple Flavors

**You can use multiple flavors in one project!**

```
my-project/
├── agentops/
│   ├── product-dev/                  # Feature development
│   │   ├── product/
│   │   └── specs/
│   │
│   ├── infrastructure-ops/           # Infrastructure work
│   │   ├── research/
│   │   └── plans/
│   │
│   └── devops/                       # K8s operations
│       └── configs/
│
└── code/
    ├── src/                          # From product-dev
    ├── infrastructure/               # From infrastructure-ops
    └── k8s/                          # From devops
```

**Use the right flavor for each type of work.**

---

## Quick Start by Domain

### Infrastructure & Operations
→ Start with **infrastructure-ops**
```bash
/research "How should we upgrade our k8s cluster?"
/plan research.md
/implement plan.md
```

### Product Development
→ Start with **product-dev**
```bash
/plan-product
/shape-spec
/write-spec
/create-tasks
/implement-tasks
```

### Kubernetes / GitOps
→ Start with **devops**
```bash
/prime-with-routing "Create Redis application"
# Auto-recommends: applications-create-app-jren

# Or use specific agent
# See devops/README.md for 52 agent catalog
```

---

## Flavor Principles

All flavors follow agentops universal patterns:

### 1. The 40% Rule
Stay under 40% context capacity per phase to prevent collapse.

### 2. Context Bundles
Save/load compressed context for multi-day projects.

### 3. Validation Gates
Test before deploying, validate at each step.

### 4. Institutional Memory
Git commits = memory writes, patterns compound over time.

### 5. Multi-Agent Coordination
Parallel execution where appropriate (3-5x speedup).

---

## Creating Custom Flavors

Want to create your own domain-specific flavor?

**Pattern:**
1. Start with a universal pattern (3-phase or spec-first)
2. Add domain-specific agents
3. Create domain workflows
4. Document standards and conventions
5. Share back to community

**Example domains that could benefit from custom flavors:**
- Data engineering (ETL, pipelines, warehouses)
- Security engineering (pentesting, audits, compliance)
- Mobile development (iOS/Android patterns)
- ML/AI engineering (model training, deployment)
- Platform engineering (IDP, developer experience)

**See:** [Creating Custom Flavors Guide](../docs/how-to/create-custom-flavor.md) *(coming soon)*

---

## Flavor Status

| Flavor | Status | Agents | Production Use |
|--------|--------|--------|----------------|
| **infrastructure-ops** | ✅ Stable | 3 core | 200+ sessions |
| **product-dev** | ✅ Stable | 8 workflow | 50+ projects |
| **devops** | ✅ Production | 52 specialized | 20+ clusters |

---

## Philosophy: The Kubernetes Model

Like Kubernetes orchestrates different container runtimes and workload types:

```
Kubernetes
├── Pods (different container types)
├── Deployments (different scaling strategies)
└── Services (different networking patterns)
```

**AgentOps orchestrates different agent OS flavors:**

```
agentops
├── infrastructure-ops (research-driven workflows)
├── product-dev (spec-first workflows)
└── devops (specialized agent swarm)
```

**Each flavor is:**
- ✅ **Opinionated** - Best practices built in
- ✅ **Optimized** - For specific domains
- ✅ **Composable** - Use multiple in one project
- ✅ **Universal** - Built on agentops patterns

**Together they enable a complete agent operating system ecosystem.**

---

## Contributing Flavors

Have a domain that needs a custom flavor?

**We're looking for:**
- Production-validated patterns (not theoretical)
- Domain-specific agent catalogs
- Workflow templates proven in real work
- Standards and conventions documentation

**Submit via:**
1. Propose in [GitHub Discussions](https://github.com/boshu2/agentops/discussions)
2. Validate in your domain (20+ sessions minimum)
3. Document following flavor template
4. Submit PR with example usage

**See:** [CONTRIBUTING.md](../CONTRIBUTING.md) for flavor contribution guidelines

---

## Related

- **12-factor-agentops** - Philosophy behind flavors
- **agentops README** - Orchestrator documentation
- **Architecture docs** - How flavors work together

---

## Examples

### Real Projects Using Multiple Flavors

**GitOps Platform (20+ clusters):**
- infrastructure-ops: Cluster upgrades, migrations
- devops: Day-to-day operations (52 agents)
- product-dev: Platform features

**SaaS Product:**
- product-dev: Feature development
- infrastructure-ops: Database migrations
- devops: k8s deployment

**Data Platform:**
- infrastructure-ops: Pipeline design
- devops: k8s operations
- Custom data-eng flavor: ETL workflows

---

## FAQ

### Can I use multiple flavors in one project?
**Yes!** Use the right flavor for each type of work.

### How do I know which flavor to use?
**Start with your domain:** Infrastructure → infrastructure-ops, Product → product-dev, K8s → devops

### Can flavors interoperate?
**Yes!** They all use agentops universal patterns (context bundles, validation gates, etc.)

### What if no flavor fits my domain?
**Create a custom flavor** or **adapt an existing one**. See contribution guidelines.

### Are flavors required?
**No.** You can use agentops universal patterns directly. Flavors are opinionated optimizations.

---

**Choose your flavor, or use them all. The orchestrator supports any combination.**

*Updated: 2025-11-06*
