# How-To Guides

**Task-oriented documentation for common workflows.**

How-to guides provide step-by-step instructions for accomplishing specific goals with AgentOps. Each guide focuses on a practical task and assumes you have basic familiarity with the system.

---

## Quick Start: Which Guide Do I Need?

**Decision tree:**

```
Starting a new product?
  → [How to Plan a Product](run-plan-product.md)

Planning a new feature?
  ├─ Requirements unclear → [How to Shape a Specification](run-shape-spec.md)
  └─ Requirements clear → [How to Write a Specification](run-write-spec.md)

Have a specification ready?
  → [How to Create Tasks](run-create-tasks.md)

Have tasks ready?
  → [How to Implement Tasks](run-implement-tasks.md)

Want to create your own agent?
  → [How to Create a Custom Agent](create-custom-agent.md)

Something not working?
  → [How to Debug Workflow Issues](debug-workflow.md)
```

---

## Workflow Guides

### Product Planning

**[How to Plan a Product](run-plan-product.md)**
- **Goal:** Create product documentation (mission, roadmap, tech stack)
- **Time:** 10-15 minutes
- **When:** Starting a new product from scratch
- **Outputs:** `product/mission.md`, `product/roadmap.md`, `product/tech-stack.md`

---

### Specification Workflows

**[How to Shape a Specification](run-shape-spec.md)**
- **Goal:** Gather detailed requirements through interactive questioning
- **Time:** 15-30 minutes
- **When:** Feature idea exists but requirements unclear
- **Outputs:** `specs/*/planning/requirements.md`, visual assets

**[How to Write a Specification](run-write-spec.md)**
- **Goal:** Create formal specification from requirements
- **Time:** 15-20 minutes
- **When:** Requirements gathered, ready for formal spec
- **Outputs:** `specs/*/spec.md`

---

### Implementation Workflows

**[How to Create Tasks](run-create-tasks.md)**
- **Goal:** Break specification into task groups
- **Time:** 5-10 minutes
- **When:** Specification complete, ready to plan implementation
- **Outputs:** `specs/*/tasks.md`

**[How to Implement Tasks](run-implement-tasks.md)**
- **Goal:** Execute implementation of task groups
- **Time:** 1-8 hours (varies by feature size)
- **When:** Task breakdown complete, ready to implement
- **Outputs:** Implementation code, tests, `verifications/final-verification.md`

---

## Customization & Debugging

**[How to Create a Custom Agent](create-custom-agent.md)**
- **Goal:** Build specialized agent for custom workflow
- **Time:** 30-60 minutes
- **When:** Need workflow not covered by existing agents
- **Outputs:** Custom agent file, optional workflow files

**[How to Debug Workflow Issues](debug-workflow.md)**
- **Goal:** Troubleshoot and resolve workflow problems
- **Time:** 10-30 minutes
- **When:** Something isn't working as expected
- **Outputs:** Problem diagnosed and resolved

---

## Complete Development Flow

### End-to-End Example

Here's how the guides fit together for a complete feature:

#### 1. Plan Product (Optional, for new products)

```bash
/plan-product
```

**Guide:** [How to Plan a Product](run-plan-product.md)

**Creates:**
- `product/mission.md`
- `product/roadmap.md`
- `product/tech-stack.md`

---

#### 2. Shape Specification (Requirements Discovery)

```bash
/shape-spec
```

**Guide:** [How to Shape a Specification](run-shape-spec.md)

**Creates:**
- `specs/2025-11-06-feature/planning/requirements.md`
- `specs/2025-11-06-feature/planning/visuals/`

---

#### 3. Write Specification (Formal Spec)

```bash
/write-spec
```

**Guide:** [How to Write a Specification](run-write-spec.md)

**Creates:**
- `specs/2025-11-06-feature/spec.md`

---

#### 4. Create Tasks (Task Breakdown)

```bash
/create-tasks
```

**Guide:** [How to Create Tasks](run-create-tasks.md)

**Creates:**
- `specs/2025-11-06-feature/tasks.md`

---

#### 5. Implement Tasks (Build Feature)

```bash
/implement-tasks
```

**Guide:** [How to Implement Tasks](run-implement-tasks.md)

**Creates:**
- Implementation code and tests
- `specs/2025-11-06-feature/verifications/final-verification.md`

---

#### 6. Debug Issues (If Needed)

If something goes wrong at any step:

**Guide:** [How to Debug Workflow Issues](debug-workflow.md)

---

## Workflow Shortcuts

### Skip Steps When Appropriate

**Skip /plan-product if:**
- Working on existing product
- Product docs already exist

**Skip /shape-spec if:**
- Requirements crystal clear
- Prefer to write spec directly

**Go directly to /write-spec:**
- Skip /shape-spec when requirements are clear

**Skip /write-spec if:**
- Feature extremely simple
- Prefer lightweight approach

---

## Guide by Audience

### For Product Managers

- [How to Plan a Product](run-plan-product.md) - Define product vision
- [How to Shape a Specification](run-shape-spec.md) - Gather requirements

### For Developers

- [How to Write a Specification](run-write-spec.md) - Create technical specs
- [How to Create Tasks](run-create-tasks.md) - Break down work
- [How to Implement Tasks](run-implement-tasks.md) - Build features
- [How to Debug Workflow Issues](debug-workflow.md) - Fix problems

### For DevOps/Platform Engineers

- [How to Create a Custom Agent](create-custom-agent.md) - Build automation
- [How to Debug Workflow Issues](debug-workflow.md) - Troubleshoot

---

## Related Documentation

### By Documentation Type

- **Tutorials:** [Step-by-step learning paths](../tutorials/README.md)
- **How-To Guides:** You are here
- **Reference:** [Detailed technical reference](../reference/README.md)
- **Explanation:** [Conceptual background](../explanation/README.md)

### By Topic

- **Commands:** [Command reference docs](../reference/commands/README.md)
- **Agents:** [Agent reference docs](../reference/agents/README.md)
- **Patterns:** [12-Factor AgentOps patterns](https://github.com/boshu2/12-factor-agentops)

---

## Tips for Using How-To Guides

1. **Follow step-by-step** - Guides are designed to be followed in order
2. **Check prerequisites** - Ensure you have what you need before starting
3. **Adapt to your context** - Examples are illustrative, not prescriptive
4. **Refer to reference docs** - For detailed technical information
5. **Debug when stuck** - Use debug guide for troubleshooting
6. **Skip what you don't need** - Not every step required for every project

---

## Contributing

Have a workflow that would make a good how-to guide?

1. Check if it fits the "how-to" category (task-oriented, practical)
2. Follow existing guide structure (Goal, Time, Prerequisites, Steps)
3. Include examples and troubleshooting
4. Submit as contribution to [agentops repository](https://github.com/boshu2/agentops)

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for details.

---

**Navigation:**
- [Home](../../README.md)
- [Documentation Index](../README.md)
- [Tutorials](../tutorials/README.md)
- [Reference](../reference/README.md)
- [Explanation](../explanation/README.md)
