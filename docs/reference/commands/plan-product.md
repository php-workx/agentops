# /plan-product

**Pattern:** [Product Planning Pattern](../../explanation/patterns/product-planning.md) (placeholder)

**Location:** `profiles/default/commands/plan-product/`

**Variants:** Single-agent, Multi-agent

## Purpose

Creates comprehensive product documentation that serves as the foundation for feature development. Captures product vision, strategy, roadmap, and technical decisions in structured documents.

## Usage

```bash
/plan-product
```

Optionally provide product details upfront:

```bash
/plan-product

I want to build a task management app for developers.
Target users: Software engineers and tech teams
Key features: GitHub integration, CLI support, time tracking
Tech stack: Python backend, React frontend
```

## Workflow

### Multi-Agent Variant (Recommended)

**Location:** `profiles/default/commands/plan-product/multi-agent/plan-product.md`

#### Phase 1: Gather Product Requirements

Delegates to **product-planner** subagent to:
- Confirm or gather product idea
- Identify target users and problems
- Define key features
- Establish tech stack choices

User provides details interactively.

#### Phase 2: Create Documentation

The product-planner creates:
- `product/mission.md` - Product vision and strategy
- `product/roadmap.md` - Phased development plan
- `product/tech-stack.md` - Technical architecture decisions

#### Phase 3: Inform User

Outputs completion message with next steps.

**Agents Used:**
- [product-planner](../agents/product-planner.md) - Gathers requirements and creates all product docs

---

### Single-Agent Variant

**Location:** `profiles/default/commands/plan-product/single-agent/plan-product.md`

Progressively loads four phase files:

1. `1-product-concept.md` - Gather product vision
2. `2-create-mission.md` - Draft mission document
3. `3-create-roadmap.md` - Create phased roadmap
4. `4-create-tech-stack.md` - Document tech decisions

Each phase executes in sequence within the same conversation.

---

## When to Use

### Use /plan-product when:

- Starting a new product from scratch
- Need to document product vision and strategy
- Want structured roadmap for development phases
- Need to establish technical stack decisions
- Building foundation before feature work

### Skip /plan-product if:

- Product docs already exist
- Working on existing product with established direction
- Only implementing single feature (jump to /shape-spec)

---

## Output Files

```
product/
├── mission.md       # Product vision, goals, success metrics
├── roadmap.md       # Phased development plan with priorities
└── tech-stack.md    # Technical architecture decisions
```

### mission.md Structure

- Product vision
- Target users
- Problems solved
- Success metrics
- Core differentiators

### roadmap.md Structure

- Phase 1 (MVP)
- Phase 2 (Growth)
- Phase 3 (Scale)
- Each phase: Features, priorities, dependencies

### tech-stack.md Structure

- Frontend stack
- Backend stack
- Infrastructure
- Development tools
- Rationale for choices

---

## Examples

### Example 1: SaaS Product

```bash
/plan-product

Building a code review automation tool.
Target: Engineering teams at startups (10-100 developers)
Problems: Manual reviews slow, inconsistent feedback, knowledge silos
Key features: AI-powered suggestions, style enforcement, learning from team patterns
Tech: Node.js API, React dashboard, PostgreSQL, deployed on AWS
```

**Output:**
- mission.md: Focus on reducing review time, improving consistency
- roadmap.md: Phase 1 (basic automation), Phase 2 (learning), Phase 3 (integrations)
- tech-stack.md: Node.js for API flexibility, React for rich UI, PostgreSQL for structured data

### Example 2: CLI Tool

```bash
/plan-product

Creating a deployment orchestration CLI.
Target: DevOps engineers, SREs
Problems: Complex multi-service deploys, rollback difficulties, config drift
Key features: Declarative config, automatic rollback, drift detection
Tech: Python for CLI, YAML for configs, Kubernetes backend
```

**Output:**
- mission.md: Simplify complex deployments, enable safe rollbacks
- roadmap.md: Phase 1 (basic deploy), Phase 2 (rollback), Phase 3 (drift detection)
- tech-stack.md: Python Click for CLI, Kubernetes client, YAML for portability

---

## Pattern Background

Implements **Product Planning Pattern** from 12-Factor AgentOps.

**Theory:** Product documentation serves as declarative configuration for feature development. Clear vision prevents scope creep and misaligned features.

**Practice:**
- Mission drives feature prioritization
- Roadmap informs scheduling decisions
- Tech stack ensures consistency

**12-Factor Alignment:**
- Factor I: Declarative - Product docs are declarative, not imperative
- Factor VI: Context Preservation - Captures decisions for future reference
- Factor IX: Rapid Iteration - Clear roadmap enables fast feature cycles

---

## Related Commands

- **Next:** [/shape-spec](shape-spec.md) - Shape requirements for first feature
- **Alternative:** [/write-spec](write-spec.md) - Write spec directly if requirements clear

## Related Guides

- **[How to Plan a Product](../../how-to/run-plan-product.md)** - Step-by-step guide for this workflow
- [How-To Guide Index](../../how-to/README.md) - All available how-to guides

## Related Agents

- [product-planner](../agents/product-planner.md) - Creates all product documentation

---

## Tips

1. **Be specific about target users** - "Engineering teams at startups" better than "developers"
2. **Define success metrics** - Quantifiable goals help prioritization
3. **Justify tech choices** - Document why, not just what
4. **Phase roadmap realistically** - Start with MVP, add complexity incrementally
5. **Update as you learn** - Product docs are living documents

---

## Troubleshooting

**Q: Should I use single-agent or multi-agent variant?**

A: Multi-agent recommended for most cases. Single-agent useful if you want more control over each phase.

**Q: Can I update product docs later?**

A: Yes! Edit files in `product/` directory directly. Consider re-running /plan-product to regenerate completely.

**Q: What if I don't know tech stack yet?**

A: That's fine - product-planner will ask questions to help you decide based on requirements.

---

## See Also

- [Command Index](README.md)
- [Agent Reference](../agents/README.md)
- [12-Factor AgentOps](https://github.com/boshu2/12-factor-agentops)
