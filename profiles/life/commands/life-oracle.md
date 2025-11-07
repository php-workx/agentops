---
description: Interactive routing command for life flavor - guides to appropriate personal development agent
---

# /life-oracle - Personal Development Routing

**Purpose:** Guide you to the right personal development agent based on your current focus.

**When to use:** Starting personal work, unsure which agent to use, beginning a session.

---

## How It Works

This command analyzes your current need and recommends one of the 7 personal development agents:

| Current Focus | Recommended Agent | Time |
|---------------|-------------------|------|
| Career planning, NVIDIA application | career-strategist | 30-60m |
| Skills assessment, capability updates | capability-auditor | 20-30m |
| End-of-cycle reflection | quarterly-reviewer | 60-90m |
| LinkedIn posts, visibility campaign | linkedin-content-creator | 15-30m |
| Philosophy updates, insight capture | philosophy-documenter | 30-45m |
| Weekly cycle check-in | oracle-morpheus-orchestrator | 20-45m |
| Starting new 6-week cycle | construct-cycle-starter | 30-45m |

---

## Interactive Guide

**What aspect would you like to work on today?**

### Option 1: Career & Strategy
If you're thinking about career goals, positioning, or applications:
- Use: `/career-strategist`
- Updates: `life/operations/career-strategy.md`
- Focus: NVIDIA path, competitive positioning, strategic planning

### Option 2: Skills & Capabilities
If you need to update your capability inventory or track growth:
- Use: `/capability-auditor`
- Updates: `life/operations/mci.md`
- Focus: Skills tracking, achievement documentation, evidence gathering

### Option 3: Construct Cycle Work
If you're in the middle of a 6-week cycle and need weekly guidance:
- Use: `/construct-cycle` (loads oracle-morpheus-orchestrator)
- Updates: Session logs, phase guidance
- Focus: Current phase execution (Forge/Guide/Catalyst/Resonance)

### Option 4: Quarterly Review
If you're at the end of Week 6 or a quarter boundary:
- Use: `quarterly-reviewer` agent directly
- Updates: Reflection logs, next cycle planning
- Focus: Learnings, metrics, pattern extraction

### Option 5: Visibility & Content
If you're creating LinkedIn content or building professional presence:
- Use: `linkedin-content-creator` agent directly
- Updates: LinkedIn post drafts, carousel ideas
- Focus: Promotion campaign, 2-3 posts per week

### Option 6: Philosophy & Wisdom
If you've had a breakthrough or need to update your canonical philosophy:
- Use: `philosophy-documenter` agent directly
- Updates: `life/canonical/source-v2.md`, session logs
- Focus: Pattern extraction, philosophical insights

### Option 7: Starting Fresh
If you're beginning a new 6-week construct cycle:
- Use: `construct-cycle-starter` agent directly
- Updates: Cycle setup, Forge phase planning
- Focus: New cycle initialization, goal setting

---

## Quick Decision Tree

```
What's your current state?

├─ Planning career moves? → /career-strategist
├─ Just completed a project? → /capability-auditor
├─ In the middle of a cycle? → /construct-cycle
├─ At end of Week 6? → quarterly-reviewer
├─ Need to create content? → linkedin-content-creator
├─ Had a breakthrough? → philosophy-documenter
└─ Starting fresh? → construct-cycle-starter
```

---

## Philosophy

**Personal development is not prescriptive.**

This routing command suggests, but you always choose. Trust your intuition - you know what you need right now.

The 40% rule applies: If you're not sure, start with the lightest option. You can always shift later.

---

## Example Usage

```bash
# Interactive - I'll ask what you need
/life-oracle

# With context - Tell me your focus
/life-oracle "I need to update my resume for NVIDIA"
# → Recommends: career-strategist

/life-oracle "Just shipped a major feature"
# → Recommends: capability-auditor

/life-oracle "Week 3 of my Forge phase"
# → Recommends: construct-cycle (oracle-morpheus-orchestrator)
```

---

## Integration with Team Flavors

Life flavor is separate but complementary to team flavors:

- **Team work** (infrastructure-ops, product-dev) → Technical execution
- **Life work** (this flavor) → Personal development, career strategy

**Pattern:** Build with team agents, reflect with life agents, teach with both.

---

**What aspect of your personal development would you like to work on today?**
