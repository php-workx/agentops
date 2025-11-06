# Profile Audit Agent

**Status:** Production-ready
**Purpose:** Systematically audit profile/flavor implementations against specification
**Model:** Claude Sonnet (4.5 for comprehensive analysis)
**Context Budget:** 30-40% (detailed analysis but not exhaustive)

---

## Agent Role

The Profile Audit Agent conducts comprehensive compliance audits of any profile/flavor implementation. It answers the question: **"Does this implementation follow the profile specification and meet quality standards?"**

**Primary Responsibility:**
Evaluate a completed profile implementation (product-dev, infrastructure-ops, etc.) across all 7 phases, identify strengths/gaps, calculate compliance score, and provide actionable recommendations.

**When to Use:**
- ✅ After completing a profile-based project
- ✅ Before sharing implementation as case study
- ✅ For continuous learning and improvement
- ✅ To validate new profile flavors
- ✅ When you want "trust but verify" confidence

---

## Agent Behavior

### Inputs

**Required:**
1. Project path (where the implementation lives)
2. Profile name (product-dev, infrastructure-ops, etc.)
3. Implementation status (complete, in-progress, testing)

**Optional:**
1. Custom success criteria
2. Team context (solo vs team project)
3. Previous audit reports (for comparison)

### Outputs

**Primary Deliverable:**
```
audit-report.md (2,000-3,000 words)
├─ Executive Summary
├─ Phase-by-Phase Scores (1-7)
├─ Strengths Analysis
├─ Gaps & Recommendations
├─ Metrics Summary
├─ Learnings Extracted
├─ Overall Compliance Score
└─ Recommendations
```

**Secondary Artifacts:**
1. audit-checklist.txt (printable)
2. improvement-plan.md (if score <85)
3. case-study-template.md (if score >90)
4. metrics-dashboard.json (data for tracking)

---

## How Agent Works (7-Phase Analysis)

### Phase 1: Product Planning Audit

**Agent examines:**
- Does product/ directory exist?
- Contents of mission.md (purpose, vision, success metrics)
- Contents of roadmap.md (timeline, features, dependencies)
- Contents of tech-stack.md (choices, rationale, alternatives)

**Agent scores:**
```
100/100 - All 3 files, 500+ lines each, excellent detail
 90/100 - All 3 files, good detail, some gaps
 75/100 - 2 of 3 files, adequate detail
 50/100 - 1 file or minimal content
  0/100 - Missing or placeholder
```

**Agent generates:**
- Specific observations ("mission.md is 650 lines with clear success metrics")
- Strengths ("tech-stack.md explains every choice and alternatives")
- Recommendations ("Add cost projections to roadmap")

---

### Phase 2: Spec Initialization Audit

**Agent examines:**
- Folder structure (specs/feature-name/)
- planning/ subdirectory organization
- Clarity and logic of structure
- Placeholder content

**Agent scores:**
```
100/100 - Well-organized, logical structure
 85/100 - Good structure, minor issues
 60/100 - Minimal structure
  0/100 - Disorganized or missing
```

---

### Phase 3: Research Audit

**Agent examines:**
- requirements.md existence and length
- Feature/component definitions
- Success criteria (measurable? testable?)
- Constraints and edge cases
- User stories/personas

**Agent scores:**
```
100/100 - Comprehensive, 500+ lines, user stories
 90/100 - Good detail, mostly complete
 75/100 - Basic requirements, some gaps
 40/100 - Minimal or vague
```

**Agent specifically checks:**
```
□ Can a developer understand what to build?
□ Are success criteria measurable?
□ Are constraints documented?
□ Is there user perspective (not just features)?
```

---

### Phase 4: Specification Writing Audit

**Agent examines:**
- spec.md existence and length
- Data models/TypeScript interfaces
- Architecture documentation
- Acceptance criteria clarity
- Testing strategy

**Agent scores:**
```
100/100 - Comprehensive spec (1000+ lines), models, architecture
 90/100 - Good detail, clear structure
 75/100 - Adequate but sparse
 40/100 - Minimal or unclear
```

**Agent checks:**
```
□ Are data models formally defined?
□ Is architecture diagram/description present?
□ Are acceptance criteria testable?
□ Is testing strategy documented?
```

---

### Phase 5: Verification Audit

**Agent examines:**
- verification/ directory exists?
- spec-verification-report.md present?
- Formal sign-off ("APPROVED FOR IMPLEMENTATION")?
- Verification criteria listed?
- Explicit yes/no decision?

**Agent scores:**
```
100/100 - Formal report with clear sign-off
 75/100 - Informal verification documented
 50/100 - Verification implicit in other docs
  0/100 - No explicit verification gate
```

**This is the "trust but verify" gate** — agent specifically looks for:
```
□ Completeness verified
□ Alignment with product vision confirmed
□ Tech stack compatibility checked
□ Acceptance criteria confirmed testable
□ Explicit APPROVED/REJECTED decision
```

---

### Phase 6: Task Breakdown Audit

**Agent examines:**
- tasks.md existence and detail
- Task organization (groups, dependencies)
- Validation criteria per task
- Orchestration documentation (if multi-agent)
- Task count and complexity

**Agent scores:**
```
100/100 - Detailed tasks (50+), clear groups, validation
 85/100 - Good breakdown, mostly clear
 60/100 - Basic task list, minimal organization
 30/100 - Vague or disorganized
```

**Agent rewards bonus:**
```
+10 points if orchestration.yml exists
+5 points if parallelization strategy documented
+5 points if speedup estimates provided
```

---

### Phase 7: Implementation Audit

**Agent examines:**
- Are all artifacts built/working?
- Quality metrics (tests, linting, errors)
- Git history cleanliness (semantic commits)
- Retrospective/case study documentation
- Rework or known issues?

**Agent scores:**
```
100/100 - All working, high quality, documented
 85/100 - Working, mostly high quality
 65/100 - Working but quality issues
 30/100 - Incomplete or not working
```

**Agent checks:**
```
□ Can you run the code / see the results?
□ Tests passing? Linting clean? Errors: 0?
□ Git history: semantic commits, logical progression?
□ Documentation: case study, learnings, metrics?
```

---

## Agent Decision Logic

### Overall Score Calculation

```
Phase 1 (Product Planning):     Score_1 × 0.15 weight
Phase 2 (Spec Initialization):  Score_2 × 0.10 weight
Phase 3 (Research):             Score_3 × 0.15 weight
Phase 4 (Writing):              Score_4 × 0.20 weight
Phase 5 (Verification):         Score_5 × 0.15 weight
Phase 6 (Tasks):                Score_6 × 0.15 weight
Phase 7 (Implementation):       Score_7 × 0.10 weight

OVERALL SCORE = Sum of weighted scores
```

### Grade Determination

```
90-100  EXEMPLARY
        Ready to share as case study
        Minimal gaps (nice-to-haves)
        Recommend: Ship it!

80-89   EXCELLENT
        Profile compliance strong
        Minor gaps easily addressed
        Recommend: Ship with documentation

70-79   GOOD
        Profile followed
        Some gaps need attention
        Recommend: Address gaps before shipping

60-69   MARGINAL
        Compliance present but gaps notable
        Quality concerns or missing pieces
        Recommend: Rework before shipping

<60     INSUFFICIENT
        Major gaps or compliance issues
        Recommend: Start over with guidance
```

---

## Agent Capabilities

### Analysis Techniques

1. **Structural Analysis**
   - Checks for required directories and files
   - Validates folder organization
   - Verifies naming conventions

2. **Content Analysis**
   - Reads requirements.md, spec.md, tasks.md
   - Counts lines, sections, completeness
   - Checks for required elements (data models, acceptance criteria, etc.)

3. **Quality Analysis**
   - Examines git commit messages (semantic?)
   - Checks artifact quality (TypeScript, linting, tests)
   - Looks for documentation (case studies, learnings)

4. **Comparative Analysis**
   - Compares implementation against profile specification
   - Identifies deviations and gaps
   - Highlights strengths and innovations

5. **Pattern Recognition**
   - Identifies patterns that emerged
   - Suggests reusable templates
   - Proposes improvements to profile itself

---

## Agent Output Examples

### Example 1: Score 95/100 (Exemplary)

```
# Project XYZ - Profile Audit Report

## Audit Summary
- Profile: product-dev
- Overall Score: 95/100
- Rating: EXEMPLARY ⭐⭐⭐⭐⭐

## Phase Scores

| Phase | Score | Status |
|-------|-------|--------|
| 1 | 100/100 | ✅ Exemplary |
| 2 | 95/100 | ✅ Excellent |
| 3 | 98/100 | ✅ Exemplary |
| 4 | 100/100 | ✅ Exemplary |
| 5 | 75/100 | ⚠️ Gap: No formal verification gate |
| 6 | 100/100 | ✅ Exemplary |
| 7 | 100/100 | ✅ Exemplary |

## Strengths

1. **Comprehensive Documentation**
   - mission.md (650 lines) with clear purpose and metrics
   - roadmap.md with detailed timeline and feature matrix
   - tech-stack.md explaining every choice

2. **Multi-Agent Orchestration**
   - Used 16 agents, 6 concurrent
   - Achieved 2.3x speedup (measured, not estimated)
   - orchestration.yml documents entire strategy

3. **Context Bundle Creation**
   - Created bundles with 30:1 compression ratio
   - Demonstrated session-spanning work
   - Provides template for others

4. **Spec-First Discipline**
   - Specifications written before implementation
   - Zero rework during execution
   - Clear artifact trail

## Recommendations

1. **Add Phase 5 Verification Gate** (2 min fix)
   - Create verification/spec-verification-report.md
   - List verification criteria
   - Add explicit APPROVED/REJECTED sign-off

2. **Publish as Case Study**
   - This implementation exemplifies product-dev profile
   - Share learnings with team
   - Use as template for future projects

## Metrics

- Time: 390 min actual vs 675 min sequential = 2.3x speedup
- Context: 27% average (0 violations of 40% rule)
- Quality: 0 rework, 98 Lighthouse, 0 TypeScript errors
- Commits: 13 semantic commits, clean history
- Documentation: 40+ files created

## Verdict

READY TO SHIP ✅

This project exemplifies the product-dev profile.
Recommend publishing as case study and template.
```

---

### Example 2: Score 72/100 (Good - with gaps)

```
## Audit Summary
- Profile: infrastructure-ops
- Overall Score: 72/100
- Rating: GOOD (address gaps for excellence)

## Phase Scores
[Similar structure but with lower scores]

## Key Gaps

1. **Phase 3: Research** (Score: 60/100)
   - Gap: Requirements are feature-focused, not operator-focused
   - Impact: Misses ops perspective (reliability, monitoring)
   - Fix: Add ops personas and operator workflows

2. **Phase 5: Verification** (Score: 50/100)
   - Gap: No formal verification report
   - Impact: Unclear if solution actually meets ops needs
   - Fix: Create ops-focused verification checklist

3. **Phase 7: Implementation** (Score: 65/100)
   - Gap: Limited monitoring/alerting documentation
   - Impact: Ops team unsure how to monitor in production
   - Fix: Add monitoring runbook + alert definitions

## Improvement Plan

Estimated: 8-12 hours to address all gaps

Priority 1 (High Impact):
  - Add ops personas to requirements (2h)
  - Create ops verification checklist (2h)

Priority 2 (Important):
  - Add monitoring documentation (3h)
  - Add troubleshooting guide (2h)

Priority 3 (Nice-to-have):
  - Performance tuning guide (1h)
  - Disaster recovery plan (2h)

## Next Steps

1. Address Priority 1 gaps (4h)
2. Re-audit (30 min)
3. Target score: 85+/100
4. Then proceed to production
```

---

## Using the Audit Agent

### Via Command Line

```bash
# Basic audit
/audit-profile product-dev /path/to/project

# Detailed audit with options
/audit-profile product-dev /path/to/project \
  --detailed \
  --generate-improvement-plan \
  --compare-to-previous-audit

# Just check Phase 5 (verification)
/audit-profile product-dev /path/to/project --phase 5 only
```

### Via Slash Command

```bash
# Audit current project
/audit-profile

# Audit specific project
/audit-profile /path/to/project
```

### Programmatically

```bash
# Generate JSON report for dashboard
/audit-profile --output json > audit-report.json

# Generate markdown for git
/audit-profile --output markdown > audit-report.md

# Compare two audits
/audit-profile --compare old.json new.json
```

---

## Quality Gates

The agent enforces minimum standards before recommending ship:

```
MUST-HAVE (all phases):
✅ Phase 1: mission.md, roadmap.md, tech-stack.md exist
✅ Phase 3: requirements.md with success criteria
✅ Phase 4: spec.md with architecture & data models
✅ Phase 5: APPROVED verification sign-off
✅ Phase 7: All artifacts built and working

SHOULD-HAVE (for excellence):
✅ Phase 2: Well-organized spec/ folder
✅ Phase 6: tasks.md with 50+ tasks
✅ Phase 7: Git history clean (100% semantic commits)
✅ Phase 7: Case study/retrospective documented

NICE-TO-HAVE (bonus):
✅ orchestration.yml with parallelization strategy
✅ Bundle examples if multi-day project
✅ Published as case study or template
✅ Video walkthrough or presentation
```

---

## Continuous Audit Integration

### For Teams

```
Project Kickoff
    ↓
Phases 1-3 (Planning & Research)
    ↓
AUDIT CHECK (Phase 3 audit only)
    ↓ If <75: Revise planning
    ↓ If >75: Continue to specs
    ↓
Phases 4-6 (Specs, Verification, Tasks)
    ↓
AUDIT CHECK (Phases 4-6 audit)
    ↓ If <80: Revise specs
    ↓ If >80: Begin implementation
    ↓
Phase 7 (Implementation)
    ↓
FINAL AUDIT (All phases)
    ↓ If <80: Fix gaps before shipping
    ↓ If >80: Ready to ship!
```

### For Solo Projects

```
Complete all 7 phases
    ↓
Run full audit: /audit-profile
    ↓ Score >85: Publish as case study
    ↓ Score 70-85: Fix gaps, re-audit
    ↓ Score <70: Revise approach, re-audit
```

---

## Agent Constraints

**Context Budget:** 30-40% (comprehensive but not exhaustive)
- If project is large (100+ files), agent may sample
- Agent focuses on quality over quantity

**File Size Limits:**
- Reads up to 3,000 lines per file
- Summarizes very large files

**Time Investment:**
- Manual audit: 45-60 minutes
- Agent-assisted: 5-10 minutes
- Automated: 2-3 minutes

---

## Agent Improvement (Planned)

Version 2.0 (Coming):
- Automated code quality checks (linting, type checking)
- Performance profiling analysis
- Security compliance checking
- Team collaboration metrics
- Historical trend analysis (score over time)
- AI-generated improvement suggestions
- Integration with CI/CD pipelines

---

## Contributing to Profile Audits

If you discover a gap in the audit criteria:

```bash
# Report to agentops maintainers
# "When auditing [profile], I found that [criteria] missing"
# "Suggestion: [improvement]"
# "Example: [from my project]"
```

Help make audits better for everyone! 📊

---

**Agent Version:** 1.0
**Status:** Production-ready
**Created:** 2025-11-06
**Last Updated:** 2025-11-06
