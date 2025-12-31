---
date: 2025-12-30
type: Research
topic: "Restructure agentops as Kelsey Hightower-style educational marketplace"
tags: [research, education, restructure, kelsey-hightower]
status: COMPLETE
---

# Research: Kelsey Hightower-Style Educational Restructure

**Created:** 2025-12-30
**Goal:** Transform agentops from conceptual framework documentation to hands-on, progressive learning experience

---

## Executive Summary

Agentops has 28 commands averaging 400+ lines of conceptual framework content (PDC, FAAFO, Three Loops) but minimal working examples. Kelsey Hightower's approach is the opposite: hands-on tutorials, progressive complexity, meeting learners where they are. Restructure agentops around "learning by building" with tiered levels.

---

## Current State

### What Exists

| Component | Count | Avg Lines | Character |
|-----------|-------|-----------|-----------|
| Commands | 28 | ~400 | Framework-heavy, conceptual |
| Skills | 12 | ~300 | Knowledge reference, triggers |
| Profiles | 3 | ~50 | Role-based skill groupings |
| Workflows | 15 | ~100 | Pattern documentation |
| Archived Agents | 56 | ~35 | Legacy, consolidated into skills |

### Key Files

| File | Purpose | Relevance |
|------|---------|-----------|
| `commands/implement.md` | 516 lines | 80% framework, 20% procedure |
| `commands/plan.md` | 516 lines | Heavy on PDC/FAAFO, light on examples |
| `commands/research.md` | 422 lines | Token budgets, option value formula |
| `skills/*/SKILL.md` | 12 files | Good reference material |

### Existing Patterns

- RPI workflow (Research → Plan → Implement) is sound
- Bundle system for context persistence works
- Skill trigger patterns are useful
- 12-domain consolidation was correct move

### Problem: Conceptual Over Operational

Current `implement.md` structure:
```
## Opus 4.5 Behavioral Standards (20 lines)
## FAAFO Alignment (15 lines)
## Three Loops Context (20 lines)
## When to Use (15 lines)
## PDC Framework for Implementation (40 lines)
## How It Works (100 lines)
## Failure Pattern Defense (50 lines)
## Universal Emergency Procedures (30 lines)
## Integration with RPI Flow (20 lines)
## Command Options (20 lines)
...
```

**Result:** 516 lines, ~50 of which are actionable procedure.

---

## Findings

### Finding 1: Kelsey Hightower's Teaching Philosophy

**Evidence:** [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) - 100k+ stars

**Core principles:**
1. **Hands-on first** - "No scripts. No automation." Build understanding through doing
2. **Step-by-step** - Each step produces visible output
3. **From scratch** - Don't hide complexity, reveal it progressively
4. **Document, contribute, be pragmatic** - His advice to community

**Key quote:** "Breaking down complex concepts into accessible information, meeting people where they are in terms of knowledge."

**Application:** agentops commands should be runnable demos, not framework documentation.

### Finding 2: Progressive Complexity Works

**Evidence:** Kubernetes the Hard Way structure:
- Prerequisites (what you need)
- 14 numbered labs
- Each builds on previous
- Clear verification at each step

**Application:** agentops should have L1-L5 levels:
- L1: Single session, no state, just works
- L2: Add persistent output (.agents/)
- L3: Add issue tracking concepts
- L4: Add parallelization (waves)
- L5: Full orchestration (autopilot)

### Finding 3: Framework Content Should Be Reference, Not Inline

**Evidence:** Comparing ~/.claude vs agentops:
- ~/.claude/implement.md: 367 lines, mostly procedure
- agentops/implement.md: 516 lines, mostly framework

**The difference:** ~/.claude puts frameworks in `includes/` and references them. agentops embeds framework in every command.

**Application:** Extract PDC, FAAFO, Three Loops to `/reference/` directory. Commands become tight procedures.

### Finding 4: Working Examples Are Non-Negotiable

**Evidence:** Current agentops commands have:
- `## Example Session` sections with fake output
- No recorded real sessions
- No demo directories

**Application:** Each level should have:
- `demo/` directory with real session transcripts
- Before/after state
- Expected output at each step

---

## Constraints

| Constraint | Impact | Mitigation |
|------------|--------|------------|
| No beads dependency | Can't use bd commands in examples | Use generic state patterns, show beads as L3+ |
| Must work standalone | Can't assume user's tooling | Self-contained demos |
| Educational focus | Not production optimization | Clarity over efficiency |
| Backward compatible | Existing users | Keep current commands, add levels/ |

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Scope creep | High | High | Focus on L1-L2 first, defer L3-L5 |
| Breaking existing | Medium | High | Additive changes, don't modify current commands yet |
| Too simple | Low | Medium | L1 is gateway, complexity in higher levels |

---

## Recommendation

**Approach:** Add `levels/` directory with progressive tutorials, keep existing `commands/` as reference.

### Phase 1: L1-Basics (MVP)
Create tight, runnable versions of core commands:
- `/levels/L1-basics/research.md` (~50 lines)
- `/levels/L1-basics/implement.md` (~50 lines)
- `/levels/L1-basics/demo/` with real transcripts

### Phase 2: L2-Persistence
Add .agents/ output, session recovery:
- `/levels/L2-persistence/` builds on L1
- Shows how to persist learnings

### Phase 3: Reference Extraction
Move framework content from commands to reference:
- `/reference/pdc-framework.md`
- `/reference/faafo-alignment.md`
- `/reference/failure-patterns.md`

### Phase 4: L3-L5
- L3: Issue tracking patterns (generic, not beads-specific)
- L4: Parallelization concepts
- L5: Orchestration patterns

**Why this order:** L1-L2 delivers immediate value. Reference extraction cleans up existing commands. L3-L5 adds sophistication for advanced users.

---

## Proposed Structure

```
agentops/
├── levels/                      # NEW: Progressive learning
│   ├── README.md                # Level overview and progression
│   ├── L1-basics/               # Single-session, no state
│   │   ├── README.md            # What you'll learn
│   │   ├── research.md          # ~50 lines, works standalone
│   │   ├── implement.md         # ~50 lines, single file changes
│   │   └── demo/                # Real session transcripts
│   │       ├── research-session.md
│   │       └── implement-session.md
│   ├── L2-persistence/          # Add .agents/ output
│   ├── L3-state-management/     # Issue tracking patterns
│   ├── L4-parallelization/      # Wave execution
│   └── L5-orchestration/        # Full autopilot
├── reference/                   # NEW: Framework content
│   ├── pdc-framework.md
│   ├── faafo-alignment.md
│   ├── three-loops.md
│   └── failure-patterns.md
├── commands/                    # KEEP: Full reference versions
├── skills/                      # KEEP: Domain knowledge
├── profiles/                    # KEEP: Role configurations
└── workflows/                   # KEEP: Pattern documentation
```

---

## Next Steps

1. Run `/plan` to create beads issues with dependencies
2. Implement L1-basics first (MVP)
3. Create demo transcripts from real usage
4. Extract reference content from existing commands

---

## Sources

- [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) - Kelsey's flagship tutorial
- [CNCF: Year-end reflection with Kelsey Hightower](https://www.cncf.io/blog/2024/01/22/kubernetes-and-beyond-a-year-end-reflection-with-kelsey-hightower/)
- [Container Days: Kelsey's role in growing Kubernetes](https://www.containerdays.io/blog/how-kelsey-hightower-inspired-a-community-to-build-kubernetes/)

**Output:** .agents/research/2025-12-30-kelsey-style-restructure.md
