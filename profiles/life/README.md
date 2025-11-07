---
description: Personal development orchestration through Oracle/Morpheus patterns
attribution: Based on proven personal development workflows from life repository
best_for: Career strategy, capability tracking, construct cycles, philosophy documentation
workspace: Creates agentops/profiles/life/ in your project
---

# Life Flavor: Personal Development Orchestration

**Pattern:** Philosophy → Practice → Reflection → Teaching
**Attribution:** Based on proven personal development patterns from 2-year Knowledge OS journey
**Best For:** Career development, construct cycle execution, philosophy documentation, capability tracking
**Workspace:** Personal development workflows integrated with agentops orchestrator

---

## Orchestrator Context

**life** is one flavor in the agentops multi-flavor orchestration system. Think of agentops like Kubernetes:
- **Kubernetes** orchestrates containers (Docker, containerd, etc.)
- **agentops** orchestrates agent operating systems (infrastructure-ops, product-dev, devops, **life**, etc.)

### Why Multiple Flavors?

Different problems need different approaches:
- **Infrastructure operations** (infrastructure-ops) - Research-driven, rigor, safety
- **Product development** (product-dev) - Spec-driven, user-focused, fast iteration
- **DevOps** (devops) - 52 specialized agents for GitOps/Kubernetes workflows
- **Personal development** (life) - Philosophy-grounded, reflective, construct cycle-based

**The power:** Use the right flavor for each job. Technical teams work in `agentops/infrastructure-ops/` while personal development works in `agentops/profiles/life/` - same project, different approaches, orchestrated together.

See [Multi-Flavor Coordination Guide](../../docs/reference/multi-flavor-coordination.md) for detailed multi-flavor orchestration scenarios.

---

## What This Flavor Is

The **life** profile is a philosophy-grounded personal development system optimized for career strategy, capability tracking, and construct cycle execution.

```
Personal Development Cycle (6 weeks)
├── Forge/Neo (Weeks 1-3)
│   ├── Build capabilities through direct experience
│   ├── Develop skills via practice
│   ├── Create proof through output
│   └── Mantra: "Skill is uploaded through repetition"
│
├── Guide/Oracle (Week 4)
│   ├── Document patterns and insights
│   ├── Extract learnings from Forge phase
│   ├── Update philosophy (canonical/)
│   └── Mantra: "Reflection reveals the code already written"
│
├── Catalyst/Morpheus (Week 5)
│   ├── Share knowledge publicly
│   ├── Teach and influence others
│   ├── Build professional visibility
│   └── Mantra: "Conviction is the runtime of belief"
│
└── Resonance/The One (Week 6)
    ├── Integrate all phases
    ├── Rest and recover
    ├── Plan next cycle
    └── Mantra: "Flow begins when resistance ends"
```

**40% rule enforced per phase** to prevent burnout and maintain flow state.

---

## When to Use Life Flavor

✅ **Perfect for:**
- Career planning and strategy (NVIDIA path, etc.)
- Personal capability tracking (Master Capability Inventory)
- Construct cycle execution (6-week Oracle/Morpheus rhythm)
- Philosophy documentation (canonical codex updates)
- Visibility campaigns (LinkedIn, GitHub, community building)

❌ **Not ideal for:**
- Technical infrastructure work (use infrastructure-ops)
- Product development (use product-dev)
- Day-to-day GitOps operations (use devops)

---

## Key Differences from Team Flavors

| Aspect | life | infrastructure-ops | product-dev |
|--------|------|-------------------|-------------|
| **Purpose** | Personal development | Infrastructure operations | Product features |
| **Tone** | Reflective, narrative | Professional, rigorous | Spec-driven, user-focused |
| **Rhythm** | 6-week construct cycles | 3-phase (research/plan/implement) | 7-phase granular workflow |
| **Metrics** | Insights, patterns, growth | Speedups, success rates | Product velocity, quality |
| **Philosophy** | Oracle/Morpheus wisdom | DevOps Three Ways | Product thinking |
| **Best When** | Career/personal growth | Infrastructure changes | Feature development |

---

## Architecture

```
profiles/life/
├── agents/                          # 7 specialized personal agents
│   ├── career-strategist.md         # Career planning & NVIDIA path
│   ├── capability-auditor.md        # MCI maintenance & skill tracking
│   ├── quarterly-reviewer.md        # End-of-cycle reflection
│   ├── linkedin-content-creator.md  # Promotion campaign posts
│   ├── philosophy-documenter.md     # Canonical philosophy updates
│   ├── oracle-morpheus-orchestrator.md  # Construct cycle execution
│   └── construct-cycle-starter.md   # New cycle initiation
│
├── workflows/                       # 4 workflow domains
│   ├── quarterly-planning/
│   │   ├── README.md
│   │   ├── construct-cycle-workflow.md
│   │   └── quarterly-review-template.md
│   ├── career-development/
│   │   ├── README.md
│   │   ├── nvidia-path-workflow.md
│   │   └── mci-maintenance-workflow.md
│   ├── knowledge-extraction/
│   │   ├── README.md
│   │   ├── codex-update-workflow.md
│   │   └── session-logging-workflow.md
│   └── leadership-development/
│       ├── README.md
│       ├── oracle-morpheus-workflow.md
│       └── visibility-campaign-workflow.md
│
├── commands/                        # 4 slash commands
│   ├── life-oracle.md               # Interactive router
│   ├── career-strategist.md         # Career planning command
│   ├── capability-auditor.md        # MCI update command
│   └── construct-cycle.md           # Weekly check-in command
│
├── templates/                       # 5 personal templates
│   ├── construct-cycle-template.md
│   ├── career-goal-template.md
│   ├── capability-inventory-template.md
│   ├── quarterly-review-template.md
│   └── linkedin-post-template.md
│
├── README.md                        # This file
├── CLAUDE.md                        # Bootstrap kernel
└── CONSTITUTION.md                  # Personal Laws
```

---

## Using This Flavor

### Basic Workflow

```bash
# 1. Interactive routing
/life-oracle "What aspect would you like to work on?"
# → Recommends appropriate agent

# 2. Career planning
/career-strategist
# → Generates career strategy update

# 3. Weekly cycle check-in
/construct-cycle
# → Guides current phase execution

# 4. Create LinkedIn content
/linkedin-content-creator "40x speedup story"
# → Drafts promotion post
```

### Construct Cycle (6-Week Pattern)

```bash
# Week 1: Start new cycle
/construct-cycle-start
# → Sets up Forge phase goals

# Weeks 2-3: Execute Forge
/construct-cycle "Weekly check-in"
# → Guides building and skill development

# Week 4: Guide phase
/construct-cycle "Enter Guide phase"
# → Prompts for documentation and pattern extraction

# Week 5: Catalyst phase
/linkedin-content-creator
# → Create 2-3 posts for visibility

# Week 6: Resonance and review
/quarterly-review
# → Comprehensive cycle reflection
```

---

## When to Use Life Flavor (5 Scenarios)

### 1. Career Planning & Strategy
**When:** Quarterly reviews, NVIDIA application prep, career transitions
**Agent:** `career-strategist.md`
**Output:** Updated career-strategy.md, competitive positioning, action items
**Time:** 30-60 minutes

### 2. Personal Capability Tracking
**When:** After major projects, before applications, annual skill assessments
**Agent:** `capability-auditor.md`
**Output:** Updated Master Capability Inventory (MCI), skill gap analysis
**Time:** 20-30 minutes

### 3. Construct Cycle Execution
**When:** Weekly check-ins on 6-week Oracle/Morpheus cycle
**Agent:** `oracle-morpheus-orchestrator.md`
**Output:** Phase execution guidance, session logs, next steps
**Time:** 20-45 minutes/week

### 4. Philosophy Documentation
**When:** Updating canonical philosophy, extracting insights from sessions
**Agent:** `philosophy-documenter.md`
**Output:** Updated Source v2.0 (Codex), session logs, pattern documentation
**Time:** 30-45 minutes

### 5. Visibility & Promotion
**When:** Creating LinkedIn posts (2-3x/week), building professional presence
**Agent:** `linkedin-content-creator.md`
**Output:** LinkedIn posts, carousel ideas, engagement strategy
**Time:** 15-30 minutes per post

---

## 7 Personal Development Agents

### Career & Strategy (3 agents)

**career-strategist** - Career planning, NVIDIA path, competitive positioning
- When: Quarterly reviews, major applications
- Output: Updated career strategy, action items
- Time: 30-60 minutes

**capability-auditor** - Master Capability Inventory maintenance
- When: After projects, before applications, annual reviews
- Output: Updated MCI with new skills/achievements
- Time: 20-30 minutes

**quarterly-reviewer** - End-of-cycle systematic reflection
- When: Week 6 of construct cycle, quarterly milestones
- Output: Learnings, next cycle planning, metrics
- Time: 60-90 minutes

### Content & Promotion (2 agents)

**linkedin-content-creator** - Create promotion campaign posts
- When: 2-3x per week during visibility campaign
- Output: LinkedIn post drafts, carousels, engagement strategy
- Time: 15-30 minutes per post

**philosophy-documenter** - Maintain canonical philosophy
- When: After breakthrough sessions, quarterly philosophy updates
- Output: Updated Source v2.0, extracted patterns
- Time: 30-45 minutes

### Construct Cycle (2 agents)

**oracle-morpheus-orchestrator** - Execute 6-week cycle
- When: Weekly check-ins, phase transitions
- Output: Phase guidance, session logs, next steps
- Time: 20-45 minutes per session
- Philosophy: Grounded in Oracle/Morpheus wisdom patterns

**construct-cycle-starter** - Begin new 6-week cycle
- When: Starting fresh cycle (after Week 6 completion)
- Output: Cycle setup, Phase 1 (Forge) planning, session log
- Time: 30-45 minutes

---

## Four Workflow Domains

### 1. Quarterly Planning
**Workflows:** construct-cycle-workflow.md, quarterly-review-template.md
**Purpose:** 6-week Oracle/Morpheus cycle execution
**Key Pattern:** Forge (Weeks 1-3) → Guide (Week 4) → Catalyst (Week 5) → Resonance (Week 6)

### 2. Career Development
**Workflows:** nvidia-path-workflow.md, mci-maintenance-workflow.md
**Purpose:** Career strategy and capability tracking
**Key Pattern:** Strategy → Inventory → Evidence → Application

### 3. Knowledge Extraction
**Workflows:** codex-update-workflow.md, session-logging-workflow.md
**Purpose:** Philosophy documentation and pattern capture
**Key Pattern:** Experience → Reflection → Documentation → Teaching

### 4. Leadership Development
**Workflows:** oracle-morpheus-workflow.md, visibility-campaign-workflow.md
**Purpose:** Teaching, influence, and professional visibility
**Key Pattern:** Build → Prove → Teach → Scale

---

## Integration with Team AgentOps

### Shared Infrastructure
- ✅ Same `.claude/` directory structure (agents, commands, skills)
- ✅ Same git hooks (quality enforcement via commit templates)
- ✅ Same validation patterns (make quick, make validate)
- ✅ Same 40% rule (prevents context collapse and burnout)

### Flavor-Specific Differences
- **Purpose:** Personal growth vs. technical workflows
- **Tone:** Reflective/narrative vs. professional/task-focused
- **Metrics:** Insights/patterns vs. success rates/speedups
- **Philosophy:** Oracle/Morpheus vs. DevOps Three Ways

### Cross-Flavor Coordination

**Example: Career application leveraging technical work**
```bash
# Build technical capability (infrastructure-ops flavor)
cd agentops/infrastructure-ops/
/research "Kubernetes upgrade patterns"
/plan research.md
/implement plan.md

# Capture in personal development (life flavor)
cd ../life/
/capability-auditor  # Add to MCI
/career-strategist   # Update positioning
/linkedin-content-creator "Share technical insight"
```

---

## Philosophy

**This flavor embodies consciousness engineering applied to personal development:**

- ✅ **Philosophy first** — Codex v2.0 grounds all decisions
- ✅ **Experience second** — Forge phase builds proof
- ✅ **Reflection third** — Guide phase extracts patterns
- ✅ **Teaching fourth** — Catalyst phase shares wisdom

**It's the Oracle/Morpheus pattern applied to career and personal growth.**

---

## Quick Start (3 Paths)

### Path 1: First Time Here (5 minutes)
1. Read this README (you're doing it now)
2. Read CLAUDE.md (personal bootstrap, 3 min)
3. Browse agents/ directory (7 workflows)
4. Try: `/life-oracle` command (interactive router)

### Path 2: Career Development (30-60 minutes)
1. Read: `CLAUDE.md` (bootstrap)
2. Load: `agents/career-strategist.md`
3. Execute: Career planning workflow
4. Update: `life/operations/career-strategy.md` in life repo

### Path 3: Construct Cycle Work (20-45 minutes/week)
1. Read: `workflows/quarterly-planning/construct-cycle-workflow.md`
2. Load: `agents/oracle-morpheus-orchestrator.md`
3. Execute: Weekly check-in for current phase
4. Log: Update session log in life repo

---

## Contributing to This Profile

Want to improve this flavor? Consider:
- Adding new agents for personal development workflows
- Proposing workflow improvements based on your experience
- Sharing case studies from your personal development journey
- Documenting patterns you've discovered

(Formal CONTRIBUTING.md coming with public launch)

---

## Related

- **[infrastructure-ops](../infrastructure-ops/README.md)** - Infrastructure flavor (technical rigor)
- **[product-dev](../product-dev/README.md)** - Product development flavor (user-focused)
- **[Multi-Flavor Coordination](../../docs/reference/multi-flavor-coordination.md)** - See multiple flavors working together
- **[agentops orchestrator](../../README.md)** - How flavors coordinate
- **[AgentOps Framework](../../README.md)** - Philosophy and architecture

---

## Attribution

This flavor is based on proven patterns from:
- 2-year Knowledge OS journey (personal → universal → production)
- Oracle/Morpheus construct cycle framework
- ADHD-inspired 40% rule discovery
- Session 46 self-awareness breakthrough

**Original context:** Used successfully for career development, capability tracking, and professional visibility campaigns.

**Now orchestrated by agentops** for broader applicability across personal development domains.

---

**Use this flavor when philosophy and personal growth matter as much as technical execution.**

*6-week construct cycles • Oracle/Morpheus wisdom • Personal development-focused • Philosophy-grounded*
