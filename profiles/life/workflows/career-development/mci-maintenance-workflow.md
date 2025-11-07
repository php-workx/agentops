# MCI Maintenance Workflow

**Purpose:** Keep Master Capability Inventory (MCI) current with skills, achievements, and evidence.

**Philosophy:** Your MCI is your professional story, told through evidence.

---

## Overview

This workflow guides systematic capability tracking and skill progression documentation. Use with `capability-auditor` agent for structured updates.

**Frequency:** After projects, before applications, monthly reviews, quarterly assessments
**Time:** 20-30 minutes per session

---

## When to Update MCI

### After Completing Work

**Immediately after projects:**
- Capture achievements while fresh
- Document metrics and outcomes
- Gather evidence links (commits, docs, dashboards)
- Update skill progression levels

**Best practice:** Block 20 minutes after project completion for MCI update

### Before Applications

**Application preparation:**
- Refresh all capability entries
- Verify evidence links still work
- Update progression levels
- Add recent proof points
- Tailor narrative to role requirements

**Lead time:** Update MCI 1-2 weeks before application deadlines

### Regular Cadence

**Monthly reviews (light touch):**
- Quick scan for missing entries
- Add any forgotten achievements
- Update 1-2 skill progression levels
- 15-20 minutes

**Quarterly assessments (comprehensive):**
- Full MCI review and refresh
- Skill progression across all domains
- Gap analysis for career goals
- Evidence validation
- 30-45 minutes

---

## Step 1: Identify What to Document (5-10 min)

### Recent Work Completed

**Ask yourself:**
- What projects did I complete since last MCI update?
- What technical challenges did I solve?
- What new skills did I practice or learn?
- What measurable outcomes did I achieve?

**Sources to review:**
- Git commit history (last 2-4 weeks)
- Project documentation and notes
- Session logs from construct cycles
- Team feedback or recognition

### Capability Changes

**Skill progression:**
- Which skills moved from Learning → Practicing?
- Which moved from Practicing → Proficient?
- Which reached Mastered level?
- What evidence proves the progression?

**New capabilities:**
- What tools or technologies did you use for first time?
- What patterns or practices did you adopt?
- What domain knowledge did you acquire?

---

## Step 2: Capability Documentation (10-15 min)

### Skill Entry Template

```markdown
## [Capability Name]

**Level:** [Learning | Practicing | Proficient | Mastered]
**Last Updated:** [Date]

**Description:**
[1-2 sentences explaining the capability]

**Key Activities:**
- [Specific work performed]
- [Technologies or practices used]
- [Outcomes achieved]

**Evidence:**
- [Link to git commits, PRs, or repos]
- [Link to documentation created]
- [Reference to metrics/dashboards]
- [Portfolio artifacts]

**Progression History:**
- [Date]: Learning - [brief note]
- [Date]: Practicing - [brief note]
- [Date]: Proficient - [brief note]

**Related Capabilities:**
- [Links to related skill entries]
```

### Achievement Entry Template

```markdown
### [Achievement Title]

**Date:** [When completed]
**Context:** [Project or initiative]

**Challenge:**
[What problem were you solving?]

**Approach:**
[How did you solve it?]

**Results:**
- [Quantified outcome #1]
- [Quantified outcome #2]
- [Quantified outcome #3]

**Evidence:**
- [Links to work products]
- [Metrics or dashboards]
- [Documentation references]

**Skills Demonstrated:**
- [Capability #1]
- [Capability #2]
- [Capability #3]
```

---

## Step 3: Evidence Gathering (5-10 min)

### Types of Evidence

**Code and Infrastructure:**
- Git commits with specific changes
- Pull requests with problem/solution descriptions
- Repository links (sanitized for public sharing)
- Architecture diagrams

**Documentation:**
- How-to guides you wrote
- Architecture decision records
- Runbooks and playbooks
- Knowledge base articles

**Metrics and Outcomes:**
- Dashboard screenshots (sanitized)
- Before/after performance comparisons
- Adoption rates or usage statistics
- Time savings or efficiency gains

**Artifacts:**
- Demo videos or recordings
- Presentation decks
- Blog posts or articles
- Conference talk materials

### Evidence Best Practices

**Do:**
- Link to specific commits, not just repos
- Include context (what problem, what solution)
- Quantify outcomes whenever possible
- Sanitize sensitive information

**Don't:**
- Link to private repos (create sanitized versions)
- Include proprietary details
- Use broken or temporary links
- Forget to verify links work

---

## Step 4: Skill Progression Assessment (5-10 min)

### Progression Criteria

**Learning** → **Practicing:**
- Used capability in real project (not just tutorial)
- Completed work with occasional guidance
- Building pattern recognition

**Practicing** → **Proficient:**
- Used capability across multiple projects
- Can work independently without guidance
- Understands trade-offs and best practices
- Can mentor others at Learning/Practicing level

**Proficient** → **Mastered:**
- Deep expertise across many contexts
- Can architect complex solutions
- Recognized expert by peers
- Contributing to field advancement (blogs, talks, OSS)

### Assessment Questions

For each capability:
1. How many times have I used this in real projects?
2. How independently can I work with this?
3. Can I explain trade-offs and best practices?
4. Can I teach this to others effectively?
5. Am I recognized for this expertise?

Be honest. Accurate self-assessment builds credibility.

---

## Step 5: Gap Analysis (5-10 min)

### Career Goal Alignment

**Review career strategy:**
- What skills does my target role require?
- Where do I excel? (Strengths)
- Where am I adequate? (Baseline)
- Where do I have gaps? (Development needed)

**Gap categories:**
- **Critical gaps:** Required for target role, need immediate attention
- **Nice-to-have gaps:** Beneficial but not required
- **Emerging gaps:** Future skills worth monitoring

### Development Planning

**For each critical gap:**
- What learning resources are available?
- What projects could provide practice?
- What mentors or experts can help?
- What timeline is realistic?

**Document in MCI:**
```markdown
## Development Priorities

**Q[X] 20XX Focus:**

### Priority 1: [Critical Gap]
- Current level: [Learning/Practicing]
- Target level: [Practicing/Proficient]
- Timeline: [X weeks/months]
- Actions:
  - [Specific action #1]
  - [Specific action #2]
  - [Specific action #3]

[Repeat for Priority 2, 3, etc.]
```

---

## Step 6: MCI Quality Check (3-5 min)

### Verification Checklist

- ✅ All recent work documented (last 1-2 months)
- ✅ Skill progression levels accurate and evidence-based
- ✅ Evidence links work and are properly sanitized
- ✅ Achievements quantified with metrics
- ✅ Gaps identified and development plans created
- ✅ Last updated date current
- ✅ Formatting consistent throughout

### Common Quality Issues

**Avoid:**
- Vague descriptions ("worked on Kubernetes")
  - Better: "Designed multi-tenant Kubernetes architecture with RBAC policies"
- Missing metrics ("improved performance")
  - Better: "Reduced deployment time by 40%, from 45 min to 27 min"
- Broken evidence links
  - Test all links before closing session
- Stale progression levels
  - Update levels if skills have grown

---

## Integration with Career Workflows

### MCI → Career Strategy

**Use MCI to inform:**
- Competitive positioning (strengths)
- Development priorities (gaps)
- Application narratives (proof points)
- Interview preparation (evidence)

**Pattern:** MCI provides evidence, career strategy provides direction.

### MCI → Applications

**Application preparation workflow:**
1. Update MCI (this workflow)
2. Review target role requirements
3. Extract relevant capabilities and achievements
4. Tailor resume/cover letter with MCI evidence
5. Prepare interview talking points from MCI

**MCI becomes your application foundation.**

### MCI → Visibility

**LinkedIn content from MCI:**
- Share recent achievements
- Explain technical challenges solved
- Teach skills you've mastered
- Demonstrate progression over time

**Pattern:** MCI documents, LinkedIn amplifies.

---

## Automation Opportunities

### Git Integration

**Track commits automatically:**
```bash
# Generate capability contribution report
git log --author="[Your Name]" --since="1 month ago" --pretty=format:"%h %s" > recent-work.txt

# Count contributions by area
git log --author="[Your Name]" --since="1 month ago" --pretty=format:"%s" | grep -i "kubernetes" | wc -l
```

### Metrics Dashboard

**Pull automated metrics:**
- Deployment frequency (CI/CD dashboards)
- Lead time (git commit to deploy)
- MTTR (incident tracking systems)
- Documentation contributions (git stats)

Link these in MCI as living evidence.

---

## Success Looks Like

**After MCI update:**
- ✅ All recent work documented
- ✅ Skill progressions current
- ✅ Evidence links verified
- ✅ Gaps identified with plans
- ✅ Ready for applications or reviews

**Over time:**
- ✅ Clear capability trajectory visible
- ✅ Consistent documentation habit
- ✅ Evidence package always ready
- ✅ Career story told through proof
- ✅ Professional confidence grounded in data

---

## Tips for Effective MCI Maintenance

1. **Update frequently** - 20 min monthly > 2 hours quarterly
2. **Be specific** - Details create credibility
3. **Quantify everything** - Metrics matter
4. **Link evidence** - Proof strengthens claims
5. **Track progression** - Show growth over time
6. **Be honest** - Accurate assessment builds trust
7. **Use for reflection** - MCI reveals your journey

---

**Your MCI is your professional autobiography. Write it well, update it often, use it strategically.**

**Ready to update your capabilities? Use the `capability-auditor` agent.**
