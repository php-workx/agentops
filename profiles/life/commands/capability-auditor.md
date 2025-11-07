---
description: Master Capability Inventory maintenance and skill tracking command
---

# /capability-auditor - Capability Tracking

**Purpose:** Update Master Capability Inventory (MCI), track skill progression, document achievements.

**When to use:** After projects, before applications, quarterly reviews, skill assessments.

---

## What This Command Does

Loads the `capability-auditor` agent to help you:

1. **Update Capability Inventory**
   - Add new skills acquired
   - Update skill progression levels
   - Document achievements with evidence
   - Track capability growth over time

2. **Skill Progression Tracking**
   - Learning → Practicing → Proficient → Mastered
   - Evidence-based assessment
   - Gap identification
   - Development planning

3. **Achievement Documentation**
   - Capture recent accomplishments
   - Quantify impact and metrics
   - Gather proof points for applications
   - Build showcase materials

4. **Evidence Gathering**
   - Link to specific work products
   - Reference git commits and PRs
   - Document measurable outcomes
   - Create portfolio artifacts

---

## Files It References

- `life/operations/mci.md` - Master Capability Inventory (main document)
- `life/operations/career-strategy.md` - Career goals and skill priorities
- Recent session logs and project notes
- Git history from team repositories (for proof points)

---

## Typical Session Flow

### Phase 1: Context Review (5-10 min)
Agent reviews:
- Current MCI state
- Recent work completed
- Skills demonstrated
- Achievements to capture

### Phase 2: Capability Assessment (10-15 min)
Agent analyzes:
- New skills acquired or practiced
- Progression on existing skills
- Evidence of capability growth
- Quantifiable achievements

### Phase 3: Documentation (5-10 min)
Agent updates:
- MCI with new entries
- Skill progression levels
- Achievement descriptions with metrics
- Evidence links and proof points

### Phase 4: Gap Analysis (5-10 min)
Agent identifies:
- Skills needed for career goals
- Development priorities
- Learning opportunities
- Action items for growth

**Total time:** 20-30 minutes

---

## Example Usage

```bash
# After completing a project
/capability-auditor "Just finished Kubernetes multi-tenant platform"

# Before an application
/capability-auditor "Preparing evidence for NVIDIA application"

# Quarterly review
/capability-auditor "Q1 skill progression and achievements"

# Skill-specific assessment
/capability-auditor "GitOps expertise level check"
```

---

## Output You'll Get

After running this command, you'll have:

1. **Updated MCI**
   - New skills added with progression level
   - Existing skills updated with evidence
   - Achievements documented with metrics
   - Timestamps for tracking growth

2. **Skill Progression Analysis**
   - Current capability levels across domains
   - Growth trajectory over time
   - Strengths and specializations
   - Gaps relative to career goals

3. **Evidence Package**
   - Specific accomplishments with metrics
   - Proof points for applications
   - Portfolio recommendations
   - Showcase material ideas

4. **Development Plan**
   - Priority skills to develop
   - Learning resources or projects
   - Timeline for skill acquisition
   - Next capability audit timing

---

## Skill Progression Levels

The capability-auditor uses a 4-level framework:

**Learning** - Actively studying, following tutorials, early experiments
- Can describe concepts
- Needs guidance for implementation
- Limited independent work

**Practicing** - Applying in real projects, building proficiency
- Can implement with occasional help
- Growing confidence and speed
- Developing patterns and intuition

**Proficient** - Comfortable and effective, can mentor others
- Can implement independently
- Understands trade-offs and best practices
- Can teach and guide others

**Mastered** - Deep expertise, industry recognition, innovation
- Can architect complex solutions
- Recognized expert in domain
- Contributing to field advancement

---

## Philosophy

**Capability tracking is self-awareness applied to growth.**

You're not just collecting skills - you're documenting your transformation. Each capability represents time invested, challenges overcome, and wisdom gained.

The MCI becomes your professional story, told through evidence.

---

## Integration with Other Agents

**Before capability-auditor:**
- Complete work that demonstrates capabilities
- Gather metrics and evidence from recent projects

**After capability-auditor:**
- Use `career-strategist` to align skills with career goals
- Use `linkedin-content-creator` to showcase new capabilities
- Reference updated MCI in applications and interviews

**During applications:**
- Pull specific evidence from MCI for resume/cover letters
- Use capability-auditor to refresh proof points

---

## Success Looks Like

After this session:
- ✅ MCI current with recent work
- ✅ Skill progressions accurately reflect growth
- ✅ Achievements documented with quantifiable metrics
- ✅ Evidence links ready for applications
- ✅ Clear understanding of capability trajectory
- ✅ Development priorities identified

---

## Tips for Effective Capability Tracking

1. **Be specific** - "Kubernetes multi-tenant platform" > "Kubernetes work"
2. **Quantify impact** - "40% faster deployments" > "improved deployments"
3. **Include evidence** - Link to commits, docs, metrics
4. **Track progression** - Update levels as you grow
5. **Regular cadence** - Monthly updates > annual dump

---

**Ready to update your capability inventory?**

Run: `/capability-auditor` or `/capability-auditor "[recent work or focus]"`
