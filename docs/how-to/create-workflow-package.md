# Create Your Own Workflow Package

A workflow package bundles specialized agents optimized for your domain. agentops orchestrates all packages identically.

This guide walks you through creating a custom workflow package that works for your team, organization, or community.

---

## What You'll Create

By the end, you'll have:
- Clear workflow definition (phases, agents, gates)
- Documentation (README, architecture, examples)
- Reusable pattern (git-tracked, versioned)
- Same orchestration benefits as built-in packages

**Result:** Your custom package gets:
- Intelligent routing (task → right agent)
- Context management (40% rule per phase)
- Constitutional enforcement (Five Laws)
- Institutional memory (git-tracked patterns)
- Parallel execution when beneficial

---

## Step 1: Identify Your Domain

### Questions to Answer

1. **What type of work?** Be specific.
   - Examples: Data pipeline design, incident investigation, legal research, financial analysis
2. **Who are the users?** Knowledge workers, engineers, analysts, etc.
3. **What's the workflow?** How does work flow through the domain?
4. **What problems exist?** Context collapse? Agent guesswork? Inefficiency?

### Real-World Examples

**Data Engineering Package**
- Domain: ETL pipelines, ML data prep
- Problem: Pipeline design requires multiple perspectives (data quality + performance + reliability)
- Workflow: Explore → Design → Implement → Test → Deploy

**SRE/Incident Response Package**
- Domain: Incident investigation and resolution
- Problem: Fast, systematic response needed (detect → understand → fix)
- Workflow: Alert → Investigate → Diagnose → Resolve → Learn

**Financial Analysis Package**
- Domain: Stock analysis, investment research
- Problem: Deep research required before recommendations
- Workflow: Gather → Analyze → Synthesize → Recommend → Report

**Legal Tech Package**
- Domain: Contract analysis, legal research
- Problem: Multiple documents + precedents + regulations to consider
- Workflow: Analyze → Research → Synthesize → Opinions → Summaries

---

## Step 2: Define Your Workflow

### Choose a Pattern

**Pattern 1: Phase-Based (Research → Plan → Implement)**
- Use if: Different cognitive phases needed
- Example: Infrastructure, complex decisions
- Result: 3-4 phases, human gates between each
- Orchestration benefit: Fresh context per phase (40% rule)

**Pattern 2: Spec-First (Plan → Spec → Design → Implement → Test)**
- Use if: Clear vision, need detailed specification
- Example: Product development, feature engineering
- Result: 5-7 phases, emphasis on specification quality
- Orchestration benefit: Catch issues early (architecture review)

**Pattern 3: Task-First (Classify Task → Route → Execute)**
- Use if: Task variety, need intelligent routing
- Example: DevOps, diverse workflow types
- Result: Single routing agent, 10+ specialized agents
- Orchestration benefit: Perfect agent for task (90%+ accuracy)

**Pattern 4: Incident Cycle (Detect → Investigate → Resolve → Learn)**
- Use if: Time-sensitive, need rapid response
- Example: SRE, incident response, customer support
- Result: 4-5 phases, human verification gates
- Orchestration benefit: Structured investigation (prevent missing steps)

### Define Phases for Your Domain

Template:

```markdown
## Workflow

### Phase 1: [Name]
**Purpose:** [Cognitive goal]
**Agents:**
  - Agent A (what role?)
  - Agent B (what role?)
**Input:** [What goes in?]
**Output:** [What comes out?]
**Duration:** [Estimate]

### Phase 2: [Name]
...
```

### Example: Data Engineering Package

```markdown
## Workflow

### Phase 1: Data Exploration
**Purpose:** Understand data sources, schemas, quality
**Agents:** Data Explorer (schema analysis, profiling)
**Input:** Data source descriptions
**Output:** Data quality report, schema mapping
**Duration:** 15-30 minutes

### Phase 2: Pipeline Design
**Purpose:** Design ETL transformations, performance
**Agents:** Pipeline Designer (DAG creation, optimization)
**Input:** Data quality report, transformation requirements
**Output:** Pipeline architecture, transformation specs
**Duration:** 30-60 minutes

### Phase 3: Implementation
**Purpose:** Write transformation code, test
**Agents:** Implementation Agent (code generation, testing)
**Input:** Pipeline specs
**Output:** Working code, unit tests
**Duration:** 60+ minutes (depends on complexity)

### Phase 4: Validation
**Purpose:** Data quality checks, performance tests
**Agents:** Testing Agent (validation scripts, profiling)
**Input:** Pipeline code
**Output:** Validation report, performance metrics
**Duration:** 15-30 minutes

### Phase 5: Deployment
**Purpose:** Deploy to production, monitor
**Agents:** Deployment Agent (setup orchestration, alerts)
**Input:** Validated pipeline
**Output:** Running pipeline, dashboards
**Duration:** 15-30 minutes
```

---

## Step 3: Specify Your Agents

### Agent Design

Each agent should have:
- **Name:** Clear, descriptive
- **Role:** One clear purpose
- **Phases:** Which phases does it work in?
- **Inputs:** What does it need?
- **Outputs:** What does it produce?
- **Time estimate:** How long?

### Template

```yaml
name: [Agent Name]
role: [One clear purpose]
phases: [Phase 1, Phase 2, ...]
inputs:
  - [Input 1]
  - [Input 2]
outputs:
  - [Output 1]
  - [Output 2]
time_estimate: [15 min, 1 hour, etc]
```

### Example: Data Engineering Agents

```yaml
---
name: Data Explorer
role: Analyze data sources, schemas, quality
phases: [Data Exploration]
inputs:
  - Data source descriptions
  - Query samples
outputs:
  - Data quality report
  - Schema mapping
  - Recommendations
time_estimate: 20-30 minutes

---
name: Pipeline Designer
role: Design ETL architecture, transformations
phases: [Pipeline Design]
inputs:
  - Data quality report
  - Transformation requirements
  - Performance targets
outputs:
  - Pipeline architecture (DAG)
  - Transformation specifications
  - Optimization notes
time_estimate: 30-60 minutes

---
name: Implementation Agent
role: Write transformation code and tests
phases: [Implementation]
inputs:
  - Pipeline specifications
  - Code standards
outputs:
  - Transformation code (Python/SQL)
  - Unit tests
  - Documentation
time_estimate: 60+ minutes

---
name: Testing Agent
role: Validate data, performance, reliability
phases: [Validation]
inputs:
  - Pipeline code
  - Validation rules
  - Performance targets
outputs:
  - Validation report
  - Performance metrics
  - Issues/recommendations
time_estimate: 20-30 minutes

---
name: Deployment Agent
role: Deploy to production, setup monitoring
phases: [Deployment]
inputs:
  - Validated code
  - Infrastructure specs
  - Alert rules
outputs:
  - Running pipeline
  - Dashboards
  - Alert configuration
time_estimate: 20-30 minutes
```

### Key Principle: Specialization

Each agent should specialize in one clear thing:
- ✅ "Data Explorer" (explores data sources)
- ❌ "Data Agent" (too vague)
- ✅ "Pipeline Designer" (designs DAGs)
- ❌ "Engineering Agent" (too broad)

---

## Step 4: Document as Workflow Package

Create directory structure:

```
profiles/[your-domain]/
├── README.md              (overview, when to use)
├── WORKFLOW.md            (phase descriptions, agent specs)
├── AGENTS.md              (detailed agent specifications)
├── EXAMPLES.md            (real-world examples)
└── TEMPLATES/             (optional: agent templates, configs)
```

### README.md Template

```markdown
# [Domain] Workflow Package

**Domain:** [Description]
**Pattern:** [Phase-based / Spec-first / Task-first / Incident cycle]
**Agents:** [List agent names]
**Phases:** [Number and names]

## Quick Start

1. Load this package: `agentops --package [domain]`
2. Start with: [Example task]
3. Result: [Expected outcome]

## How It Works

[ASCII diagram of workflow]

```

### WORKFLOW.md Template

(Include phase descriptions and agent specifications from steps 2-3)

### EXAMPLES.md Template

```markdown
# Real-World Examples

## Example 1: [Real task]

**Input:** [What goes in]

**Workflow:**
- Phase 1: [What happens]
- Phase 2: [What happens]
- ...

**Output:** [What comes out]

**Time:** [Estimate]

---

## Example 2: [Another real task]

...
```

---

## Step 5: agentops Orchestrates Identically

Your custom package automatically gets:

✅ **Intelligent Routing**
- Task classification → right package
- No manual agent selection

✅ **Context Management**
- Fresh context per phase (40% rule)
- Context bundles between phases (5:1-10:1 compression)

✅ **Constitutional Enforcement**
- Five Laws enforced across all agents
- Consistent quality everywhere

✅ **Institutional Memory**
- Git-tracked patterns
- Next use of package is better

✅ **Parallel Execution**
- Parallel research agents (3x speedup)
- Parallel validation (3x faster checks)

**Same orchestration as:**
- Product Development Package (40x speedup proven)
- Infrastructure Ops Package (3x speedup proven)
- DevOps Package (90.9% routing accuracy proven)

---

## Step 6: Share or Customize

### Option 1: Keep Internal

- Store in your organization's repo
- Document thoroughly (team-specific context)
- Build institutional knowledge

### Option 2: Contribute to Community

- Sanitize for public release (remove org-specific references)
- Comprehensive documentation
- Example workflows from real use
- Open source license (Apache 2.0)

### Option 3: Extend Existing Package

- Start with built-in package (product-dev, devops, etc.)
- Customize for your specific needs
- Document the customization
- Inherit benefits of base package

---

## Complete Example: Financial Analysis Workflow Package

### Directory Structure

```
profiles/financial-analysis/
├── README.md
├── WORKFLOW.md
├── AGENTS.md
└── EXAMPLES.md
```

### README.md

```markdown
# Financial Analysis Workflow Package

**Domain:** Investment research, stock analysis, portfolio analysis
**Pattern:** Research → Analyze → Synthesize → Recommend → Report
**Agents:** 5 specialized agents
**Phases:** 5-phase workflow

## Quick Start

1. Load: `agentops --package financial-analysis`
2. Example: `Analyze stock ABC for investment thesis`
3. Result: Complete investment thesis with recommendations

## When to Use

- Deep stock analysis needed
- Investment decisions required
- Multiple data sources (financial, industry, macroeconomic)
- Detailed reasoning required before recommendations

## How It Works

[diagram shows: Gather → Analyze → Synthesize → Recommend → Report]
```

### WORKFLOW.md

```markdown
## Financial Analysis Workflow

### Phase 1: Data Gathering
**Purpose:** Collect financial data, reports, competitor info
**Agents:** Financial Data Agent
**Duration:** 20-30 minutes

### Phase 2: Analysis
**Purpose:** Ratio analysis, trend analysis, competitor comparison
**Agents:** Analysis Agent
**Duration:** 30-45 minutes

### Phase 3: Synthesis
**Purpose:** Synthesize findings, risk assessment
**Agents:** Synthesis Agent
**Duration:** 20-30 minutes

### Phase 4: Recommendations
**Purpose:** Investment thesis, actions, ratings
**Agents:** Recommendation Agent
**Duration:** 15-20 minutes

### Phase 5: Reporting
**Purpose:** Executive summary, detailed report
**Agents:** Report Agent
**Duration:** 15-20 minutes
```

### AGENTS.md

```markdown
## Financial Data Agent
- **Role:** Gather financial statements, ratios, industry data
- **Inputs:** Company symbol, period, analysis focus
- **Outputs:** Financial metrics, historical trends, peer comparison
- **Time:** 20-30 min

## Analysis Agent
- **Role:** Detailed financial analysis, ratio interpretation
- **Inputs:** Financial data, company context
- **Outputs:** Analysis report, key insights, concerns
- **Time:** 30-45 min

[... etc for all 5 agents]
```

### EXAMPLES.md

```markdown
## Example 1: Tech Stock Deep Dive

**Input:** "Analyze Microsoft for investment"

**Workflow:**
- Phase 1: Gather MSFT financials, peer data (Azure, cloud revenue)
- Phase 2: Analyze P/E ratios, growth trends, market share
- Phase 3: Synthesize cloud growth potential vs. mature business risk
- Phase 4: Investment thesis + rating (BUY/HOLD/SELL)
- Phase 5: Executive summary + detailed report

**Output:** 10-page investment thesis with financials, risk analysis, recommendations

**Time:** 2-3 hours
```

---

## Key Principles

### 1. Specialization
Each agent does ONE thing well. Don't create agents that do multiple things.

### 2. Clarity
Describe everything clearly. Future agents (and humans) need to understand:
- What each phase is for
- What each agent does
- How they work together

### 3. Reusability
Design for reuse:
- Can agents work in other domains?
- Can phases be adapted?
- Is the pattern documented?

### 4. Measurement
Document success metrics:
- Speed: "Baseline 4 hours → Package 2 hours (2x faster)"
- Quality: "Baseline 15% errors → Package 0% (Constitutional enforcement)"
- Satisfaction: "User says 'wow' at [specific moment]"

---

## Validation Checklist

Before sharing/publishing:

✅ **Workflow Clarity**
- [ ] Can a new user follow the workflow?
- [ ] Are phases clearly defined?
- [ ] Are gates explained?

✅ **Agent Roles**
- [ ] Each agent has ONE clear purpose?
- [ ] Agents don't overlap?
- [ ] Agents can coordinate?

✅ **Documentation**
- [ ] README is clear and complete?
- [ ] Examples are real and concrete?
- [ ] Patterns are documented?

✅ **Orchestration Integration**
- [ ] Package works with agentops routing?
- [ ] 40% rule applied per phase?
- [ ] Constitutional Laws documented?

✅ **Testing**
- [ ] Tried with real tasks?
- [ ] Workflows work as described?
- [ ] Timing estimates accurate?

---

## Next Steps

1. **Choose your domain** - What type of work?
2. **Define workflow phases** - How does work flow?
3. **Specify agents** - Who does each phase?
4. **Document thoroughly** - README, WORKFLOW.md, AGENTS.md, EXAMPLES.md
5. **Test with real tasks** - Does it work?
6. **Share or iterate** - Internal? Community? Extended?

---

## Get Help

- **Understand framework** → [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
- **Study examples** → Browse `profiles/` directory
- **Ask questions** → Open issue, discuss with community

---

## Success Stories

**What makes a great workflow package?**

1. **Solves a real problem**
   - Teams experience 2-3x speedup
   - Quality improves measurably
   - Users say "wow"

2. **Clearly documented**
   - New users can start in <10 minutes
   - Examples are concrete and real
   - Workflow is obvious

3. **Built to last**
   - Reusable across projects
   - Pattern scales to multiple teams
   - Institutional memory compounds

4. **Universally orchestrated**
   - Works identically to built-in packages
   - No custom orchestration needed
   - Scales from startup to enterprise

---

**Ready to create your workflow package?** Start with Step 1 and work through the complete example section.
