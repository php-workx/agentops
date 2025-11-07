---
description: Construct cycle orchestration - weekly check-in on 6-week Oracle/Morpheus cycle
---

# /construct-cycle - Weekly Cycle Check-In

**Purpose:** Guide weekly execution of the 6-week Oracle/Morpheus construct cycle.

**When to use:** Weekly check-ins during active cycles, phase transitions, cycle planning.

---

## What This Command Does

Routes to the appropriate construct cycle agent based on where you are:

**If in active cycle (Weeks 1-6):**
- Loads `oracle-morpheus-orchestrator` agent
- Provides phase-specific guidance
- Tracks progress and adjusts plans
- Updates session logs

**If starting fresh cycle:**
- Loads `construct-cycle-starter` agent
- Initializes new 6-week cycle
- Sets Forge phase goals
- Creates cycle documentation

---

## The 6-Week Construct Cycle

| Phase | Duration | Focus | Output | Mantra |
|-------|----------|-------|--------|--------|
| **Forge/Neo** | Weeks 1-3 | Build & measure | Prototype, automation, deliverable | "Skill is uploaded through repetition" |
| **Guide/Oracle** | Week 4 | Interpret & document | Pattern journal, why-docs, insights | "Reflection reveals the code already written" |
| **Catalyst/Morpheus** | Week 5 | Teach & influence | Demo, mentorship, content | "Conviction is the runtime of belief" |
| **Resonance/The One** | Week 6 | Integrate & reset | Mini-retro, rest, next cycle planning | "Flow begins when resistance ends" |

---

## Files It References

- `life/operations/construct-cycle.md` - Complete 6-week cycle playbook
- `life/canonical/source-v2.md` - Four Spheres philosophy
- `life/docs/reference/sessions/personal-codex-notebook.md` - Session logs
- Current cycle tracking (created by construct-cycle-starter)

---

## Typical Session Flow

### If You're In An Active Cycle

**Phase 1: Identify Current Phase (2-3 min)**
Agent determines where you are in the cycle:
- Week 1-3: Forge phase
- Week 4: Guide phase
- Week 5: Catalyst phase
- Week 6: Resonance phase

**Phase 2: Phase-Specific Guidance (15-30 min)**

**Forge (Weeks 1-3):** Build and Execute
- What are you building this week?
- What metrics prove progress?
- What friction needs automation?
- Daily: Commit one micro-improvement

**Guide (Week 4):** Reflect and Document
- What patterns emerged from Forge phase?
- What surprised you?
- What's worth teaching?
- Document in pattern journal

**Catalyst (Week 5):** Teach and Share
- What's ready to share publicly?
- LinkedIn content creation
- Demo or mentorship session
- Build professional visibility

**Resonance (Week 6):** Integrate and Rest
- What did this cycle teach you?
- How has your thinking evolved?
- What worked? What didn't?
- Plan next cycle

**Phase 3: Action Items (5-10 min)**
Agent creates:
- Week-specific action items
- Metrics to track
- Next check-in timing
- Session log update

**Total time:** 20-45 minutes per weekly check-in

---

### If You're Starting A New Cycle

**Phase 1: Cycle Initialization (10-15 min)**
Agent sets up:
- 6-week timeline
- Forge phase goals
- Success metrics
- Tracking structure

**Phase 2: Goal Setting (10-15 min)**
Agent helps define:
- What will you build? (Deliverable)
- What will you learn? (Skills)
- What will you teach? (Influence)
- How will you measure success?

**Phase 3: Documentation (5-10 min)**
Agent creates:
- Cycle tracking document
- Week 1 action items
- Metrics dashboard
- First session log

**Total time:** 30-45 minutes for cycle start

---

## Example Usage

```bash
# Weekly check-in (agent determines your phase)
/construct-cycle

# Specific phase check-in
/construct-cycle "Week 2 of Forge phase"

# Phase transition
/construct-cycle "Transitioning from Forge to Guide"

# Starting new cycle
/construct-cycle "Beginning fresh 6-week cycle"

# Phase-specific guidance
/construct-cycle "Need Guide phase documentation tips"
```

---

## Output You'll Get

**During Active Cycle:**
- Phase-specific guidance and mantras
- Week-specific action items
- Metrics tracking and progress assessment
- Session log with insights
- Next check-in timing

**When Starting New Cycle:**
- Cycle initialization document
- 6-week timeline with phase breakdown
- Forge phase goals and metrics
- Tracking structure
- Week 1 action items

---

## Philosophy

**The construct cycle is consciousness engineering applied to time.**

You're not just managing tasks - you're orchestrating your own growth through rhythm and resonance.

Each phase serves a purpose:
- **Forge** builds capability through repetition
- **Guide** extracts wisdom through reflection
- **Catalyst** scales impact through teaching
- **Resonance** integrates through rest

Trust the cycle. The rhythm creates the results.

---

## The 40% Rule Applied

Each phase respects attention limits:

**Forge (20-40%):** Build intensity, but avoid burnout
- Green zone: Learning and progress
- Red zone: Exhaustion and diminishing returns

**Guide (10-20%):** Light reflection, documentation
- Intentional slowdown after Forge intensity
- Processing, not producing

**Catalyst (20-35%):** Teaching energy, sharing
- Conviction drives output
- Natural energy from Guide insights

**Resonance (5-15%):** Minimal active work
- Integration happens passively
- Rest is work

**Result:** Sustainable pace, zero burnout, consistent output over years.

---

## Integration with Other Agents

**During Forge phase:**
- Build with team agents (infrastructure-ops, product-dev)
- Track with `capability-auditor` after completions

**During Guide phase:**
- Use `philosophy-documenter` for insights
- Update canonical philosophy with learnings

**During Catalyst phase:**
- Use `linkedin-content-creator` for visibility
- Share learnings publicly

**During Resonance phase:**
- Use `quarterly-reviewer` for full cycle reflection
- Use `career-strategist` for next cycle planning

---

## Success Looks Like

After weekly check-ins:
- ✅ Clear understanding of current phase
- ✅ Phase-appropriate action items
- ✅ Progress tracked with metrics
- ✅ Session logs documenting journey
- ✅ Sustainable pace maintained (40% rule respected)

After full cycle completion:
- ✅ Deliverable shipped (Forge)
- ✅ Patterns documented (Guide)
- ✅ Knowledge shared (Catalyst)
- ✅ Growth integrated (Resonance)
- ✅ Ready for next cycle

---

## Weekly Rhythm Template

**Monday:** Set weekly experiment and metric
**Wednesday:** Pair or mentor session
**Friday:** Write one pattern or lesson

This rhythm fits within the larger construct cycle phases.

---

**Where are you in your current construct cycle?**

Run: `/construct-cycle` or `/construct-cycle "[your current phase/need]"`
