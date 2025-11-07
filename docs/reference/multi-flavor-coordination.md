# Multi-Flavor Coordination Guide

**Purpose:** Guide for using multiple workflow packages (flavors) together in the same project

**Applies to:** Any combination of infrastructure-ops, product-dev, devops, and life flavors

---

## What is Multi-Flavor Coordination?

**Multi-flavor coordination** enables you to use multiple specialized workflow packages simultaneously without context collapse, routing conflicts, or validation issues.

**Why it matters:**
- Real work spans domains (technical + personal, product + infrastructure)
- Different flavors specialize in different workflows
- Context bundles enable cross-flavor work without overload
- AgentOps orchestrates all flavors identically

**Example:** Building a new product feature while tracking personal capability growth
- **Product-dev flavor** - Spec-first development workflow
- **Life flavor** - Capability tracking and career documentation
- **Both active** - Accomplishments feed personal metrics

---

## How Flavors Coordinate

### Same Infrastructure, Different Purpose

All workflow packages share the same AgentOps infrastructure:

**Universal across flavors:**
- ✅ Intelligent routing (task → best agent)
- ✅ 40% rule enforcement (context management)
- ✅ Context bundles (multi-day coordination)
- ✅ Constitutional laws (Five Laws enforced)
- ✅ Institutional memory (git-tracked patterns)

**Different per flavor:**
- Purpose: Technical vs. personal vs. operational
- Tone: Professional vs. reflective vs. task-focused
- Metrics: Success rates vs. insights vs. speedups
- Agents: Domain-specific specialization

### Coordination Patterns

**Pattern 1: Sequential (One Flavor at a Time)**
```bash
# Morning: Technical work (devops flavor)
/prime-simple-task
# Creates Kubernetes application using devops agents

# Afternoon: Personal tracking (life flavor)
/capability-auditor
# Updates MCI with morning's accomplishment
```

**Pattern 2: Parallel (Multiple Flavors Active)**
```bash
# Load both bundles
/bundle-load agentops-roadmap-complete       # Team context
/bundle-load life-career-2025                 # Personal context

# Work spans both domains
# Team accomplishments automatically feed personal metrics
```

**Pattern 3: Nested (Flavor Within Flavor)**
```bash
# Primary: Product development (product-dev flavor)
/plan-feature
# Creates product spec

# Secondary: Document learning (life flavor)
/capability-auditor
# Captures product work as capability growth

# Result: Feature built AND personal growth documented
```

---

## Cross-Flavor Workflows

### Example 1: Technical Project + Personal Tracking

**Scenario:** Build Kubernetes application, track capability growth

**Workflow:**
1. **devops flavor** - Use `applications-create-app` agent
   - Creates Kustomize app structure
   - Validates YAML syntax
   - Tests rendering

2. **life flavor** - Use `capability-auditor` agent
   - Captures accomplishment in MCI
   - Updates technical skills domain
   - Feeds career strategy document

**Integration point:** Both flavors reference same git history
- Team flavor commits = technical proof
- Life flavor captures = personal evidence

### Example 2: Product Launch + Visibility Campaign

**Scenario:** Launch new product feature, promote on LinkedIn

**Workflow:**
1. **product-dev flavor** - Use 7-phase spec workflow
   - Research → Plan → Architect → Implement → QA → Launch → Iterate

2. **life flavor** - Use `linkedin-content-creator` agent
   - Converts launch accomplishment to LinkedIn post
   - Creates carousel showing product value
   - Schedules visibility content

**Integration point:** Product launch metrics → visibility campaign proof

### Example 3: Infrastructure Upgrade + Learning Extraction

**Scenario:** Kubernetes platform upgrade, document patterns

**Workflow:**
1. **infrastructure-ops flavor** - Use Research → Plan → Implement
   - Phase 1: Research upgrade requirements
   - Phase 2: Plan migration approach
   - Phase 3: Implement with validation

2. **life flavor** - Use `philosophy-documenter` agent
   - Extracts patterns from upgrade process
   - Documents learnings for future work
   - Updates personal knowledge base

**Integration point:** Technical patterns → reusable insights

---

## Context Bundle Coordination

### Why Bundles Enable Multi-Flavor Work

**Problem without bundles:**
- Loading full context from multiple flavors → context collapse
- Exceeds 40% rule → degradation begins
- Multi-day work loses context → restarting repeatedly

**Solution with bundles:**
- Compress each flavor's context (5:1 to 10:1 compression)
- Load multiple bundles simultaneously (<40% total)
- Enable multi-day work across flavors

### Loading Multiple Bundles

**Example: Technical + Personal Work**
```bash
# Load technical context (infrastructure work)
/bundle-load infrastructure-operations-complete

# Load personal context (career planning)
/bundle-load life-career-2025

# Both loaded, total context <40%
# Can switch between flavors without reloading
```

**Example: Product + Visibility Work**
```bash
# Load product context
/bundle-load agentops-roadmap-complete

# Load visibility context
/bundle-load life-visibility-campaign

# Product accomplishments automatically feed visibility content
```

### Bundle Naming Convention

**Format:** `[flavor]-[domain]-[year].md`

**Examples:**
- `life-career-2025.md` - Personal career strategy
- `life-visibility-campaign.md` - Professional visibility
- `life-growth-metrics.md` - Capability tracking
- `agentops-roadmap-complete.md` - Team technical work

---

## Validation Approach

### Test Each Flavor Independently

**Step 1: Validate primary flavor**
```bash
# Test devops flavor
/prime-simple-task
# Should route to devops agents

make quick
# Should pass validation
```

**Step 2: Validate secondary flavor**
```bash
# Test life flavor
/life-oracle
# Should route to life agents

# Verify no regression in primary flavor
/prime-simple-task
# Still routes to devops agents correctly
```

**Step 3: Test cross-flavor coordination**
```bash
# Use devops agent
/applications-create-app

# Then use life agent
/capability-auditor

# Verify both work without conflicts
make quick && make validate
```

### Common Validation Issues

**Issue 1: Routing conflicts**
- **Symptom:** `/prime-simple-task` routes to wrong flavor
- **Cause:** Command definitions overlap
- **Fix:** Check `.claude/commands/` for duplicate names
- **Prevention:** Use flavor-specific command prefixes

**Issue 2: Context collapse**
- **Symptom:** Agent forgets earlier work
- **Cause:** Loaded too much context (>40%)
- **Fix:** Use context bundles instead of full docs
- **Prevention:** Enforce 40% rule per session

**Issue 3: Validation failures**
- **Symptom:** `make quick` fails after adding life flavor
- **Cause:** Life flavor files don't meet team standards
- **Fix:** Separate validation (team vs. personal)
- **Prevention:** Different validation rules per flavor

---

## Examples: Real Multi-Flavor Scenarios

### Scenario A: Daily Work Pattern

**Morning (Technical Focus):**
```bash
cd agentops/
/prime-simple-task
# Use devops agents for platform work

# Complete 2-3 technical tasks
# Validate: make quick
```

**Afternoon (Personal Focus):**
```bash
cd agentops/
/life-oracle
# Use life agents for personal work

# Update MCI with morning's work
# Plan visibility content
```

**Result:** Both technical and personal work progress in parallel

### Scenario B: Multi-Day Project

**Day 1 (Research):**
```bash
# Load both contexts
/bundle-load infrastructure-operations-complete
/bundle-load life-career-2025

# Research technical requirements (infrastructure-ops)
# Document as career evidence (life)
```

**Day 2 (Planning):**
```bash
# Same bundles loaded (persistent context)

# Create technical plan (infrastructure-ops)
# Update career strategy (life)
```

**Day 3 (Implementation):**
```bash
# Same bundles loaded

# Implement solution (infrastructure-ops)
# Capture accomplishment (life capability-auditor)
```

**Result:** Multi-day coordination without context loss

### Scenario C: Quarterly Cycle

**Week 1-3 (Building):**
- **Primary flavor:** devops or product-dev (technical work)
- **Secondary flavor:** life (track progress)
- **Pattern:** Daily technical work + weekly MCI updates

**Week 4 (Reflecting):**
- **Primary flavor:** life (quarterly review)
- **Secondary flavor:** devops (gather accomplishments)
- **Pattern:** Extract learnings from technical work

**Week 5 (Teaching):**
- **Primary flavor:** life (visibility campaign)
- **Secondary flavor:** devops (showcase updates)
- **Pattern:** Convert accomplishments to content

**Week 6 (Resting):**
- **Primary flavor:** life (integration)
- **Secondary flavor:** None (rest from technical work)
- **Pattern:** Process learnings, plan next cycle

---

## Best Practices

### Do's

✅ **Load bundles, not full docs** - Keep context <40%
✅ **Test flavors independently first** - Validate before coordinating
✅ **Use flavor-specific commands** - Avoid routing conflicts
✅ **Document cross-flavor patterns** - Improve coordination over time
✅ **Validate after each change** - Catch issues early

### Don'ts

❌ **Don't mix validation rules** - Team validation ≠ personal validation
❌ **Don't load all contexts at once** - Context collapse inevitable
❌ **Don't assume routing** - Test commands after adding flavors
❌ **Don't skip bundle compression** - Full context breaks 40% rule
❌ **Don't commit hook-modified files** - Applies to all flavors

---

## Troubleshooting

### Routing Issues

**Problem:** Commands route to wrong flavor

**Debug:**
```bash
# Check command definitions
cat .claude/commands/[command-name].md

# Verify symlinks
ls -l .claude/commands/ | grep "^l"

# Test routing
/prime-simple-task    # Should route to team
/life-oracle          # Should route to life
```

**Fix:** Ensure commands have unique names or clear flavor prefixes

### Context Issues

**Problem:** Agent forgets earlier work or degrades

**Debug:**
```bash
# Check context size (estimated)
cat .agents/bundles/*.md | wc -w
# Should be <40% of 200k context window (~80k words max)
```

**Fix:** Use context bundles instead of full documents

### Validation Issues

**Problem:** Validation fails after adding flavor

**Debug:**
```bash
# Test team validation
make quick

# Test flavor-specific validation
cd profiles/life/ && make quick
```

**Fix:** Separate validation rules per flavor in Makefile

---

## Success Criteria

**Multi-flavor coordination working when:**
- ✅ All flavors route correctly (no conflicts)
- ✅ Context stays <40% (using bundles)
- ✅ Validation passes (team + flavor)
- ✅ Accomplishments flow between flavors
- ✅ Multi-day projects succeed (persistent context)
- ✅ No regressions (team flavor unaffected)

---

## Further Reading

**Related documentation:**
- [Workflow Packages Catalog](../profiles/README.md) - All available flavors
- [Context Bundles Guide](../../.agents/bundles/README.md) - Bundle system explained
- [40% Rule Explanation](../explanation/concepts/40-percent-rule.md) - Why context limits matter
- [Agent Routing Guide](./agents/agent-routing-guide.md) - How routing works

**Example implementations:**
- Life flavor integration: See `profiles/life/`
- Infrastructure-ops: See `profiles/infrastructure-ops/`
- Product-dev: See `profiles/product-dev/`
- DevOps: See `profiles/devops/`

---

**Document Version:** 1.0.0
**Created:** 2025-11-06
**Status:** Complete, ready for use
**Applies to:** All workflow packages (flavors) in agentops
