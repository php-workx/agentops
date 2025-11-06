# How to Plan a Product

**Goal:** Create comprehensive product documentation (mission, roadmap, tech stack) for a new product idea

**Time:** 10-15 minutes

**Prerequisites:**
- Product idea or concept (even if rough)
- Understanding of target users

## Overview

The `/plan-product` workflow helps you transform a product idea into structured documentation. It interactively gathers information about your product vision, target users, problems solved, and technical decisions, then creates three core documents:

- `product/mission.md` - Product vision and strategy
- `product/roadmap.md` - Phased development plan
- `product/tech-stack.md` - Technical architecture decisions

These documents serve as the foundation for all future feature development.

## Steps

### 1. Start the Workflow

Run the command in your repository:

```bash
/plan-product
```

**What happens:**
The workflow starts and asks if you already have product details to share.

### 2. Provide Initial Product Details

You can provide details upfront or answer interactively. Example:

```bash
/plan-product

Building a code review automation tool.
Target: Engineering teams at startups (10-100 developers)
Problems: Manual reviews slow, inconsistent feedback, knowledge silos
Key features: AI-powered suggestions, style enforcement, learning from team patterns
Tech: Node.js API, React dashboard, PostgreSQL, deployed on AWS
```

Or just run `/plan-product` and answer questions as prompted.

### 3. Answer Interactive Questions

The **product-planner** agent will ask clarifying questions such as:

- **Target Users:** Who will use this product? Be specific (e.g., "DevOps engineers at mid-sized companies" vs. "developers")
- **Problems Solved:** What specific pain points does this address?
- **Key Features:** What are the core capabilities? (Start with MVP, avoid feature creep)
- **Success Metrics:** How will you measure success? (e.g., "Reduce review time by 50%")
- **Tech Stack:** What technologies will you use? Why those choices?

**Tips for good answers:**
- Be specific: "Engineering teams at startups (10-100 devs)" beats "developers"
- Think MVP first: Focus on core features, defer nice-to-haves
- Quantify success: "Reduce time by 50%" beats "make things faster"
- Justify tech choices: Explain why Node.js vs. Python, PostgreSQL vs. MongoDB

### 4. Review Generated Documentation

The agent creates three files in `product/`:

**mission.md** contains:
- Product vision and purpose
- Target users and their problems
- Core value proposition
- Success metrics
- Key differentiators

**roadmap.md** contains:
- Phase 1 (MVP): Core features needed to validate concept
- Phase 2 (Growth): Features to expand user base
- Phase 3 (Scale): Features for scaling and optimization
- Dependencies and priorities for each phase

**tech-stack.md** contains:
- Frontend stack choices
- Backend stack choices
- Infrastructure decisions
- Development tools
- Rationale for each choice

### 5. Verify and Refine

Review the generated files:

```bash
cat product/mission.md
cat product/roadmap.md
cat product/tech-stack.md
```

**If refinement needed:**
- Edit files directly in `product/` directory
- Or re-run `/plan-product` to regenerate completely

## Expected Output

After completion, you'll have:

```
product/
├── mission.md       # Product vision, goals, success metrics
├── roadmap.md       # Phased development plan (3 phases)
└── tech-stack.md    # Technical architecture with rationale
```

These documents guide all future feature development.

## Common Issues

### Issue: Not sure about tech stack yet

**Solution:** That's fine! Answer questions about requirements and problems first. The agent will suggest appropriate technologies based on your needs. You can always refine tech-stack.md later.

### Issue: Product idea is still vague

**Solution:** Start with what you know. The interactive questions will help clarify scope. Don't worry about having everything figured out - that's what this workflow is for.

### Issue: Want to update docs later

**Solution:** Product docs are living documents. Edit files in `product/` directly as your understanding evolves. Consider re-running `/plan-product` if changes are substantial.

### Issue: Unsure about multi-agent vs. single-agent variant

**Solution:** Use multi-agent (default) for most cases. Single-agent gives more control over each phase but requires more manual orchestration.

## Next Steps

After planning your product:

1. **Review and validate** - Share product docs with stakeholders, get feedback
2. **Plan first feature** - Run `/shape-spec` to start defining your first feature
3. **Or write spec directly** - If first feature is clear, run `/write-spec`
4. **Update as you learn** - Revisit and refine product docs based on user feedback

## Related

- [Command Reference: /plan-product](../reference/commands/plan-product.md)
- [Agent Reference: product-planner](../reference/agents/product-planner.md)
- [How to Shape a Specification](run-shape-spec.md)
- [Complete Development Workflow](workflows/complete-development-flow.md) (placeholder)
- [Pattern: Product Planning](https://github.com/boshu2/12-factor-agentops) (12-Factor AgentOps)

## Tips for Success

1. **Be specific about target users** - "Engineering teams at Series A startups" is better than "developers"
2. **Define quantifiable success metrics** - Measurable goals help prioritize features
3. **Justify technical choices** - Document WHY, not just WHAT (helps future decisions)
4. **Phase roadmap realistically** - Start with minimal viable product, add complexity in later phases
5. **Keep mission focused** - Avoid feature creep by having clear vision
6. **Update as you learn** - Product understanding evolves with user feedback
