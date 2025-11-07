# Pattern: Multi-Phase Workflow

**Abstract:** Break complex work into 3 distinct phases with human gates, fresh context per phase.

**Domains validated:** Product development, Infrastructure/DevOps

---

## The Pattern

```
Phase 1: Exploration (40-60k tokens, 20-30% context)
  - Research, gather information, understand system
  - Output: Compressed findings (1-2k tokens)
  - Human gate: Review findings

Phase 2: Specification (40-60k tokens, 20-30% context)
  - Plan exact changes, specify file:line precision
  - Output: Detailed plan with validation (1-2k tokens)
  - Human gate: Approval required before execution

Phase 3: Execution (40-80k tokens, 20-40% context)
  - Execute approved plan, validate each step
  - Output: Code changes, commit
  - Human gate: Review before push
```

**Key:** Each phase in separate context window = no bias, fresh thinking

---

## Why It Works

**Problem:** Complex tasks can't fit in one context window without 40% rule violation

**Solution:** Split into 3 phases, each with fresh context

**Benefit:**
- Phase 1 explores without planning pressure
- Phase 2 plans without implementation pressure
- Phase 3 executes without redesign temptation

---

## Implementation in Commands

### Phase 1: Research/Exploration

**Product Dev:** `/research "What approach should we take?"`
**DevOps:** `/research "How to implement Redis caching?"`
**SRE:** `/research "What caused this incident?"`

Output: research.md (compressed findings)

### Phase 2: Planning/Specification

**Product Dev:** `/plan research.md` → specifications
**DevOps:** `/plan research.md` → infrastructure plan (file:line)
**SRE:** `/plan incident-research.md` → postmortem outline

Output: plan.md (detailed, requires approval)

### Phase 3: Execution/Implementation

**Product Dev:** `/implement plan.md` → code changes
**DevOps:** `/implement plan.md` → manifests + commit
**SRE:** `/implement postmortem-plan.md` → postmortem doc

Output: Changes + commit

---

## Session Spanning with Bundles

**Day 1:**
```bash
/research "Your question"
/bundle-save research-name
# Finish session
```

**Day 2:**
```bash
/bundle-load research-name    # Load previous research
/plan research-name.md         # Plan in fresh context
/bundle-save plan-name
# Finish session
```

**Day 3:**
```bash
/bundle-load plan-name         # Load approved plan
/implement plan-name.md        # Execute in fresh context
git push
```

---

## Metrics

| Metric | Measurement |
|--------|------------|
| Context pollution | 0 (separate windows per phase) |
| Token budget violation | 0 (each phase under 40% threshold) |
| Multi-day projects | ✅ Enabled |
| Human oversight | ✅ Gate at each phase |
| Plan redesign prevention | ✅ Enforce plan, don't replan |

---

## Validation Strategy

Each phase includes validation:

**Phase 1:** Are findings complete? Any approaches missed?
**Phase 2:** Is every change specified? Will validation pass? Can we rollback?
**Phase 3:** Does each change work? Does full validation pass? Ready to push?

---

## Applicable Across Domains

| Domain | Phase 1 | Phase 2 | Phase 3 |
|--------|---------|---------|---------|
| Product | Gather requirements | Write specs | Implement code |
| DevOps | Research architecture | Plan changes | Deploy manifests |
| SRE | Investigate incident | Document findings | Write runbooks |
| Data Eng | Analyze requirements | Design schema | Build pipeline |

**Pattern is universal; artifacts vary by domain.**

---

## Comparison: Single-Phase vs Multi-Phase

### Single Phase (Old Way)
```bash
/prime-complex-task "Do everything"
# Research + Plan + Implement in one session
# Limited by context budget
# Hard to split across days
# Redesign happens during execution
```

### Multi-Phase (New Way)
```bash
/research "Explore"           # Fresh context, explore fully
/plan research.md             # Fresh context, plan carefully
/implement plan.md            # Fresh context, execute precisely
```

Benefits:
- Each phase has fresh thinking
- Multi-day projects possible
- Human gates prevent mistakes
- Plan integrity maintained

---

## See Also

- `context-bundles.md` - Store phase outputs for reuse
- `intelligent-routing.md` - Auto-select best agent for phase
- Commands: `/research`, `/plan`, `/implement`, `/bundle-save`, `/bundle-load`
