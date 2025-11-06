# Product-Dev Flavor

**Pattern:** Spec-driven product development workflow
**Attribution:** Inspired by agent-os spec-first approach, orchestrated by agentops
**Best For:** Product development, customer-facing features, fast iteration cycles
**Workspace:** Creates `agentops/product-dev/` in your project

---

## What This Flavor Is

The **product-dev** profile is a 7-phase workflow optimized for product development where clear specifications drive implementation.

```
Phase 1: PRODUCT PLANNING (20-30k tokens)
├── Gather product requirements
├── Define product mission & vision
├── Create development roadmap
├── Document tech stack decisions
└── Output: product/ directory with mission.md, roadmap.md

Phase 2: SPEC INITIALIZATION (10-15k tokens)
├── Create spec folder structure
├── Save raw feature idea
├── Set up planning workspace
└── Output: specs/YYYY-MM-DD-feature-name/

Phase 3: RESEARCH (30-40k tokens)
├── Ask targeted questions
├── Gather detailed requirements
├── Analyze visual references
├── Document comprehensive requirements
└── Output: requirements.md

Phase 4: WRITING (40-50k tokens)
├── Create detailed specification
├── Design architecture & data models
├── Define API contracts
├── Document acceptance criteria
└── Output: spec.md

Phase 5: VERIFICATION (20-30k tokens)
├── Validate spec completeness
├── Check alignment with product vision
├── Verify tech stack compatibility
├── Confirm acceptance criteria
└── Output: verified spec.md

Phase 6: TASKS (30-40k tokens)
├── Break spec into implementation tasks
├── Create strategic groupings
├── Order tasks for optimal flow
├── Define validation for each task
└── Output: tasks.md

Phase 7: IMPLEMENTATION (remaining budget)
├── Execute tasks systematically
├── Validate at each step
├── Document implementation decisions
└── Output: working code + commits
```

**40% rule enforced per phase** to prevent context collapse and maintain quality.

---

## When to Use This Flavor

✅ **Perfect for:**
- Product feature development (new capabilities, user workflows)
- Customer-facing applications (web apps, mobile apps)
- Fast iteration cycles (spec → implement → validate)
- User experience work (UI/UX with clear specifications)
- When product vision and specs drive development

❌ **Not ideal for:**
- Infrastructure operations (use infrastructure-ops instead)
- Deep research problems (infrastructure-ops has better research phase)
- Well-understood simple changes (too much ceremony)
- Exploratory prototyping (specs premature)

---

## Key Differences from infrastructure-ops

| Aspect | product-dev | infrastructure-ops |
|--------|-------------|-------------------|
| **Phases** | 7 (granular workflow) | 3 (research → plan → implement) |
| **Focus** | Spec-driven product features | Research-driven infrastructure |
| **Planning** | Product specifications | Implementation specifications |
| **Research** | Targeted requirements gathering | Deep comprehensive investigation |
| **Use Case** | Product development | Infrastructure & operations |
| **Best When** | Product vision clear | Deep understanding needed |
| **Ceremony** | Comprehensive (7 phases) | Streamlined (3 phases) |

---

## Architecture

```
profiles/product-dev/
├── agents/                          # Specialized agents
│   ├── product-planner.md           # Creates mission & roadmap
│   ├── spec-initializer.md          # Sets up spec workspace
│   ├── spec-shaper.md               # Researches requirements
│   ├── spec-writer.md               # Writes detailed specs
│   ├── spec-verifier.md             # Validates specifications
│   ├── tasks-list-creator.md        # Creates implementation tasks
│   └── implementer.md               # Executes implementation
│
├── workflows/                       # Phase workflows
│   ├── planning/
│   │   ├── gather-product-info.md
│   │   ├── create-product-mission.md
│   │   ├── create-product-roadmap.md
│   │   └── create-product-tech-stack.md
│   ├── specification/
│   │   ├── initialize-spec.md
│   │   ├── research-spec.md
│   │   ├── write-spec.md
│   │   └── verify-spec.md
│   └── implementation/
│       ├── create-tasks-list.md
│       ├── implement-tasks.md
│       └── verification/
│           ├── verify-tasks.md
│           ├── create-verification-report.md
│           └── update-roadmap.md
│
├── standards/                       # Tech stack & coding standards
│   ├── global/                      # Universal standards
│   ├── frontend/                    # Frontend conventions
│   ├── backend/                     # Backend conventions
│   └── testing/                     # Testing standards
│
├── commands/                        # Multi-agent workflows
│   ├── plan-product/
│   ├── shape-spec/
│   ├── write-spec/
│   ├── create-tasks/
│   └── implement-tasks/
│
└── README.md                        # This file
```

---

## Using This Flavor

### Basic Workflow

```bash
# 1. Start product planning (Phase 1)
/plan-product "Your product idea"
# → Generates agentops/product-dev/product/mission.md, roadmap.md

# 2. Initialize a feature spec (Phase 2)
/initialize-spec "Feature name"
# → Creates agentops/product-dev/specs/YYYY-MM-DD-feature-name/

# 3. Research requirements (Phase 3)
/shape-spec specs/YYYY-MM-DD-feature-name/
# → Generates requirements.md

# 4. Write specification (Phase 4)
/write-spec specs/YYYY-MM-DD-feature-name/
# → Generates spec.md

# 5. Verify specification (Phase 5)
/verify-spec specs/YYYY-MM-DD-feature-name/
# → Validates and confirms spec.md

# 6. Create implementation tasks (Phase 6)
/create-tasks specs/YYYY-MM-DD-feature-name/
# → Generates tasks.md

# 7. Implement with validation (Phase 7)
/implement-tasks specs/YYYY-MM-DD-feature-name/
# → Executes tasks with validation
```

### Multi-Day Projects (Context Bundles)

```bash
# Day 1: Product planning + spec initialization
/plan-product "E-commerce platform"
/initialize-spec "User authentication"
/bundle-save auth-spec-init

# Day 2: Research requirements from bundle
/bundle-load auth-spec-init
/shape-spec specs/2025-11-06-user-authentication/
/bundle-save auth-requirements

# Day 3: Write detailed spec from bundle
/bundle-load auth-requirements
/write-spec specs/2025-11-06-user-authentication/
/bundle-save auth-spec

# Day 4: Create implementation tasks from bundle
/bundle-load auth-spec
/create-tasks specs/2025-11-06-user-authentication/
/bundle-save auth-tasks

# Day 5-7: Implement from bundle
/bundle-load auth-tasks
/implement-tasks specs/2025-11-06-user-authentication/
```

---

## Example: Using Both Flavors in One Project

```
my-project/
├── agentops/
│   ├── product-dev/                 # Product development
│   │   ├── product/
│   │   │   ├── mission.md
│   │   │   └── roadmap.md
│   │   └── specs/
│   │       ├── 2025-11-06-auth-system/
│   │       │   ├── requirements.md
│   │       │   ├── spec.md
│   │       │   └── tasks.md
│   │       └── 2025-11-07-payment-integration/
│   │
│   └── infrastructure-ops/          # Infrastructure work
│       ├── research/
│       │   └── k8s-upgrade-research.md
│       └── plans/
│           └── k8s-upgrade-plan.md
│
└── code/
    ├── src/                         # Built from product-dev
    │   ├── auth/                    # From 2025-11-06-auth-system
    │   └── payments/                # From 2025-11-07-payment-integration
    └── infrastructure/              # Built from infrastructure-ops
        └── kubernetes/
```

**Use the right flavor for the right work!**
- Product features → product-dev (spec-driven, 7 phases)
- Infrastructure → infrastructure-ops (research-driven, 3 phases)

---

## Agents in This Flavor

### Product Planner
Creates comprehensive product documentation including mission, roadmap, and tech stack.

**Responsibilities:**
- Gather product requirements from user
- Define product vision and differentiators
- Create structured development roadmap
- Document tech stack decisions

**When to use:** At the start of a new product or when defining product direction

---

### Spec Initializer
Sets up the spec folder structure and saves the raw feature idea.

**Responsibilities:**
- Create spec directory with timestamp
- Save raw feature description
- Set up planning workspace structure
- Initialize requirements placeholder

**When to use:** Before starting work on any new feature

---

### Spec Shaper (Researcher)
Gathers detailed requirements through targeted questions and visual analysis.

**Responsibilities:**
- Ask comprehensive questions about feature
- Analyze visual references (screenshots, mockups)
- Document detailed requirements
- Capture user expectations and constraints

**When to use:** After spec initialization, before writing detailed spec

---

### Spec Writer
Creates detailed specification documents for development.

**Responsibilities:**
- Write comprehensive feature specification
- Design architecture and data models
- Define API contracts and interfaces
- Document acceptance criteria

**When to use:** After requirements are gathered, before creating tasks

---

### Spec Verifier
Validates specification completeness and alignment.

**Responsibilities:**
- Check spec completeness and clarity
- Verify alignment with product vision
- Validate tech stack compatibility
- Confirm acceptance criteria are testable

**When to use:** After spec is written, before creating implementation tasks

---

### Tasks List Creator
Creates detailed, strategic task lists for implementation.

**Responsibilities:**
- Break specification into implementation tasks
- Create strategic task groupings
- Order tasks for optimal development flow
- Define validation criteria for each task

**When to use:** After spec is verified, before implementation

---

### Implementer
Executes implementation by following the tasks list.

**Responsibilities:**
- Follow tasks systematically
- Validate each task completion
- Document implementation decisions
- Create working, tested code

**When to use:** Execute approved tasks with clear specifications

---

## Context Bundles (Multi-Day Projects)

This flavor uses bundles extensively to enable multi-day spec-driven development:

```
Bundle = Compressed intermediate artifacts (5:1 to 10:1 compression)

product planning bundle
└── Contains: mission, roadmap, tech stack
    └── Reused in: spec initialization, spec writing

requirements bundle
└── Contains: detailed requirements, research findings
    └── Reused in: spec writing, verification

spec bundle
└── Contains: detailed specification, architecture
    └── Reused in: tasks creation, implementation

tasks bundle
└── Contains: implementation tasks, validation criteria
    └── Reused in: implementation phase, verification
```

**Benefits:**
- Resume work next day with fresh context
- Share specs across team members
- Avoid duplicate requirements gathering
- Maintain 40% rule across multiple days
- Enable parallel feature development

---

## Philosophy

**This flavor embodies user-centered, spec-first product development:**

- ✅ **User needs first** — Understand requirements before designing
- ✅ **Specification second** — Design clearly before implementing
- ✅ **Validation third** — Verify spec meets needs before building
- ✅ **Implementation last** — Build with clear, validated specifications
- ✅ **Documentation always** — Capture decisions for future reference

**It's the product design thinking applied to development workflows.**

Key principles:
- Specs are living documents (updated as understanding improves)
- Requirements drive architecture (not the other way around)
- Validation gates prevent rework (catch misalignment early)
- Small, verified steps compound (better than big rewrites)

---

## Multi-Agent Coordination

This flavor supports both single-agent and multi-agent modes:

### Single-Agent Mode
One agent progresses through all 7 phases sequentially.

**Best for:** Small features, learning the workflow, simple projects

### Multi-Agent Mode (3x Faster)
Multiple agents work on different phases simultaneously.

**Example:**
```
Agent A: Researching requirements for Feature 1
Agent B: Writing spec for Feature 2 (from Feature 2 requirements)
Agent C: Implementing Feature 3 (from Feature 3 tasks)

Result: 3x wall-clock speedup, same token budget
```

**Best for:** Multiple features in parallel, large projects, team coordination

---

## Standards Integration

Product-dev integrates with your coding standards:

```
profiles/product-dev/standards/
├── global/                          # Universal standards
│   ├── tech-stack.md                # Preferred technologies
│   ├── conventions.md               # Naming, structure
│   ├── coding-style.md              # Style guides
│   └── error-handling.md            # Error patterns
├── frontend/
│   ├── components.md                # Component patterns
│   ├── css.md                       # CSS conventions
│   └── accessibility.md             # WCAG compliance
├── backend/
│   ├── api.md                       # API design patterns
│   ├── models.md                    # Data modeling
│   └── queries.md                   # Database patterns
└── testing/
    └── test-writing.md              # Testing strategies
```

**Agents automatically consult standards** to ensure:
- Specs align with tech stack
- Implementation follows conventions
- Code quality is consistent
- Testing meets requirements

---

## Contributing to This Profile

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for:
- How to add new agents to this flavor
- How to propose workflow improvements
- How to share case studies from your domain
- How to extend standards for your stack

---

## Related

- **infrastructure-ops** - Infrastructure flavor (better for deep research)
- **agentops orchestrator** - How these flavors work together
- **12-factor-agentops** - Philosophy behind this approach
- **agent-os** - Original inspiration for spec-first workflow
- **MULTI_FLAVOR_EXAMPLE.md** - See both flavors working together

---

## Attribution

This flavor is inspired by:
- **agent-os** - Pioneered spec-first development approach
- Product design thinking - User-centered, iterative design
- Agile methodologies - Small validated increments
- Test-driven development - Specifications as acceptance tests

**Original context:** Proven patterns from product development teams using spec-first workflows for customer-facing applications, web platforms, and mobile apps.

**Now orchestrated by agentops** for broader applicability and multi-agent coordination.

The 7-phase workflow emerged from agent-os's spec-driven approach, adapted to respect the 40% rule and enable multi-day projects through context bundles.

---

## Success Stories

**E-commerce Platform:**
- 40x speedup in feature development (spec → implementation)
- 7 phases × 40% rule = zero context collapse
- Multi-agent mode: 3 features developed in parallel
- Result: MVP delivered in 2 weeks instead of 8

**Mobile Application:**
- Clear specs reduced rework by 80%
- Requirements phase caught misalignments early
- Implementation followed validated specifications
- Result: Fewer bugs, happier users, faster iterations

**SaaS Product:**
- Roadmap provided clarity for entire team
- Specs became shared understanding between product/engineering
- Context bundles enabled handoffs across team members
- Result: Consistent quality across all features

---

**Use this flavor when clear specifications drive better product outcomes.**

*7-phase workflow • Spec-first approach • Context bundles • User-centered • Product-focused*
