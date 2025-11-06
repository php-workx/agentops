# How to Audit Profile/Flavor Implementation

**Purpose:** Systematically verify that a profile implementation follows the specification and maintains quality standards.

**When to Use:** After completing a profile flavor implementation (product-dev, infrastructure-ops, etc.)

**Time Required:** 30-60 minutes (depending on project size)

**Output:** Audit report with compliance score and recommendations

---

## Overview

The audit workflow validates:
- ✅ **Compliance:** Does implementation follow the profile specification?
- ✅ **Quality:** Did work meet success criteria?
- ✅ **Learning:** What patterns emerged? What can improve?
- ✅ **Documentation:** Is the artifact trail complete?

This enables "trust but verify" culture and continuous improvement.

---

## Quick Start

### Option 1: Use Audit Command (Easiest)

```bash
cd /path/to/your/project
/audit-profile product-dev
```

Expected output: Compliance score (80-100), recommendations

### Option 2: Manual Audit Using Guide (Most Control)

Follow the checklist below step-by-step.

---

## Phase-by-Phase Audit Checklist

### Phase 1: Product Planning

**Profile Requirement:** Create mission.md, roadmap.md, tech-stack.md

**Audit Questions:**

```
□ Does product/mission.md exist?
  └─ What does it contain? (mission, vision, success metrics)

□ Does product/roadmap.md exist?
  └─ Does it show progression (Alpha → Beta → v1.0)?

□ Does product/tech-stack.md exist?
  └─ Does it explain choices + alternatives considered?

□ Is there clear rationale for each decision?
  └─ Can you understand WHY this direction?
```

**Scoring:**
- All 3 files exist with substance: ✅ 100%
- 2 of 3 files, good detail: ✅ 75%
- 1 file or minimal detail: ⚠️ 50%
- None or placeholder: ❌ 0%

**Example Pass (from personal-website):**
```
✅ mission.md (650 lines) - Clear purpose, metrics, timeline
✅ roadmap.md (500 lines) - Detailed releases, feature matrix
✅ tech-stack.md (600 lines) - Every choice explained
Score: 100/100 (EXEMPLARY)
```

---

### Phase 2: Spec Initialization

**Profile Requirement:** Create spec/ folder structure, set up planning workspace

**Audit Questions:**

```
□ Is there a specs/ directory?
  └─ Does it follow naming convention (e.g., specs/feature-name/)?

□ Is there a planning/ subdirectory?
  └─ Contains requirements placeholder?

□ Is folder structure organized logically?
  └─ Can you navigate and find things easily?
```

**Scoring:**
- Proper structure, organized: ✅ 95%
- Adequate structure, minor issues: ✅ 80%
- Minimal structure: ⚠️ 60%
- Disorganized or missing: ❌ 30%

**Example Pass (from personal-website):**
```
✅ specs/showcase-feature/
   ├── planning/requirements.md
   ├── spec.md
   ├── tasks.md
   └── orchestration.yml
Score: 95/100 (Excellent)
```

---

### Phase 3: Research (Requirements Gathering)

**Profile Requirement:** Gather detailed requirements, document comprehensive needs

**Audit Questions:**

```
□ Does requirements.md exist and have substance?
  └─ How many lines? (200+ = good, 500+ = excellent)

□ Are features/components clearly defined?
  └─ Can a developer understand what to build?

□ Are success criteria listed?
  └─ Are they measurable and testable?

□ Are constraints documented?
  └─ Edge cases, performance targets, dependencies?

□ Are user stories or personas included?
  └─ Does it show user perspective, not just features?
```

**Scoring:**
- Comprehensive requirements with stories: ✅ 95%
- Good detail, mostly complete: ✅ 85%
- Basic requirements, some gaps: ⚠️ 70%
- Minimal or vague: ❌ 40%

**Example Pass (from personal-website):**
```
✅ requirements.md (600 lines)
   - 5 components fully specified
   - Success criteria listed
   - User stories (5 personas)
   - Edge cases documented
Score: 98/100 (Exemplary)
```

---

### Phase 4: Specification Writing

**Profile Requirement:** Create detailed spec with architecture and data models

**Audit Questions:**

```
□ Does spec.md exist with substance?
  └─ How many lines? (500+ = good, 1000+ = excellent)

□ Are data models/interfaces defined?
  └─ TypeScript interfaces, JSON schemas, etc.?

□ Is architecture documented?
  └─ Component structure, integration points, data flow?

□ Are acceptance criteria listed?
  └─ Can these be tested/verified?

□ Is there a clear testing strategy?
  └─ Unit tests, integration tests, E2E tests?
```

**Scoring:**
- Comprehensive spec with models, architecture: ✅ 100%
- Good detail, clear structure: ✅ 90%
- Adequate but sparse: ⚠️ 75%
- Minimal or unclear: ❌ 40%

**Example Pass (from personal-website):**
```
✅ spec.md (1,000+ lines)
   - 5 component specs with props/features
   - 5 TypeScript interfaces defined
   - Architecture diagram (implicit in structure)
   - Testing strategy included
Score: 100/100 (Exemplary)
```

---

### Phase 5: Verification

**Profile Requirement:** Formal verification gate before implementation

**Audit Questions:**

```
□ Does verification/ directory exist?
  └─ Contains spec-verification-report.md?

□ Is there formal sign-off?
  └─ "APPROVED FOR IMPLEMENTATION" explicitly stated?

□ Are verification criteria listed?
  └─ Completeness, alignment, compatibility, testability?

□ Is there explicit YES/NO decision?
  └─ "Go" or "No-Go" stated clearly?
```

**Scoring:**
- Formal report with clear sign-off: ✅ 100%
- Informal verification documented: ⚠️ 75%
- Verification implicit in other documents: ⚠️ 50%
- No explicit verification gate: ❌ 0%

**Example Pass (from personal-website after fix):**
```
✅ specs/showcase-feature/verification/
   └── spec-verification-report.md
   - All criteria verified
   - Sign-off: "APPROVED FOR IMPLEMENTATION"
Score: 100/100 (Exemplary)
```

---

### Phase 6: Task Breakdown

**Profile Requirement:** Break spec into tasks, create strategic groups, define validation

**Audit Questions:**

```
□ Does tasks.md exist?
  └─ How detailed? (50+ tasks = good, 100+ = excellent)

□ Are tasks organized into groups?
  └─ Logical grouping by feature/component?

□ Are task dependencies clear?
  └─ Can you see blocking/parallel relationships?

□ Is validation defined per task?
  └─ "How will we know this is done?"

□ Is there orchestration plan?
  └─ (Bonus) orchestration.yml with parallelization strategy?
```

**Scoring:**
- Detailed tasks, clear groups, validation: ✅ 100%
- Good task breakdown, mostly clear: ✅ 85%
- Basic task list, minimal organization: ⚠️ 60%
- Vague or disorganized: ❌ 30%

**Example Pass (from personal-website):**
```
✅ tasks.md (1,000+ lines)
   - 42 tasks across 6 groups
   - Validation criteria per group
   - Blocking/parallel relationships shown
✅ orchestration.yml
   - Multi-agent strategy documented
   - Speedup estimates provided
Score: 100/100 (Exemplary)
```

---

### Phase 7: Implementation

**Profile Requirement:** Execute tasks, validate at each step, document decisions

**Audit Questions:**

```
□ Are all artifacts built?
  └─ Can you run the code/see the results?

□ Is quality high?
  └─ Tests passing, linting clean, no errors?

□ Are there unresolved issues?
  └─ TODO comments, bugs, known problems?

□ Is git history clean?
  └─ Semantic commit messages, logical progression?

□ Is there retrospective/case study?
  └─ What was learned, what would change?
```

**Scoring:**
- All working, high quality, documented: ✅ 100%
- Working, mostly high quality: ✅ 85%
- Working but quality issues: ⚠️ 65%
- Incomplete or not working: ❌ 30%

**Example Pass (from personal-website):**
```
✅ All artifacts built and working
   - 5 React components (1,456 lines)
   - Pages, documentation, container setup
✅ Quality high
   - 0 rework, 98 Lighthouse, 0 TypeScript errors
✅ Git history clean
   - 13 semantic commits, clear progression
✅ Documentation complete
   - Case study, metrics, learnings
Score: 100/100 (Exemplary)
```

---

## Overall Audit Report Template

```markdown
# [Project Name] - Profile Audit Report

## Audit Summary
- Profile: [product-dev | infrastructure-ops | etc.]
- Implementation Date: YYYY-MM-DD
- Audit Date: YYYY-MM-DD
- Overall Score: __/100

## Phase Scores

| Phase | Requirement | Your Score | Notes |
|-------|------------|-----------|-------|
| 1 | Product Planning | __/100 | |
| 2 | Spec Initialization | __/100 | |
| 3 | Research | __/100 | |
| 4 | Writing | __/100 | |
| 5 | Verification | __/100 | |
| 6 | Tasks | __/100 | |
| 7 | Implementation | __/100 | |
| **TOTAL** | | **__/100** | |

## Strengths (What Went Well)

1. [Strength 1]
2. [Strength 2]
3. [Strength 3]

## Gaps (What Could Improve)

1. [Gap 1] → Recommendation
2. [Gap 2] → Recommendation
3. [Gap 3] → Recommendation

## Key Metrics (If Applicable)

- Time invested: __ hours
- People involved: __
- Artifacts created: __ files
- Git commits: __ (semantic: __%)
- Quality: __ (0 rework, __ Lighthouse score, __ test coverage)

## Learnings & Patterns

1. Pattern discovered: __
2. Improvement opportunity: __
3. Reusable template: __

## Recommendation

**APPROVED / CONDITIONAL / REJECTED**

If conditional or rejected, explain what's needed.

## Next Steps

1. [Action 1]
2. [Action 2]
3. [Action 3]
```

---

## Audit Scoring Guide

### Grading Scale

```
100/100 - EXEMPLARY
  Perfect adherence to profile
  High quality, no gaps
  Exceeds expectations

90-99   - EXCELLENT
  Full profile compliance
  Minor gaps easily addressed
  Quality work

80-89   - GOOD
  Clear profile compliance
  Some gaps, guidance needed
  Solid work

70-79   - ACCEPTABLE
  Profile followed
  Notable gaps or quality issues
  Functional but needs improvement

60-69   - MARGINAL
  Partial compliance
  Significant gaps
  Requires rework

<60     - INSUFFICIENT
  Major gaps or non-compliance
  Quality concerns
  Recommend starting over with guidance
```

### How to Calculate Overall Score

```
Phase 1 Score: __/100  (weight: 15%)
Phase 2 Score: __/100  (weight: 10%)
Phase 3 Score: __/100  (weight: 15%)
Phase 4 Score: __/100  (weight: 20%)
Phase 5 Score: __/100  (weight: 15%)
Phase 6 Score: __/100  (weight: 15%)
Phase 7 Score: __/100  (weight: 10%)

OVERALL = (Phase1 × 0.15) + (Phase2 × 0.10) + (Phase3 × 0.15)
        + (Phase4 × 0.20) + (Phase5 × 0.15) + (Phase6 × 0.15)
        + (Phase7 × 0.10)
```

---

## Real Example: Personal-Website Audit

```
Phase 1 (Product Planning):     100/100  (All files, excellent detail)
Phase 2 (Spec Initialization):   95/100  (Structure excellent, minor gaps)
Phase 3 (Research):              98/100  (User stories + edge cases)
Phase 4 (Writing):              100/100  (1,000+ line spec, data models)
Phase 5 (Verification):          75/100  (Implicit, needs formal gate ← FIXED)
Phase 6 (Tasks):                100/100  (42 tasks, orchestration.yml)
Phase 7 (Implementation):        100/100  (All artifacts, 0 rework)

OVERALL = (100×0.15) + (95×0.10) + (98×0.15) + (100×0.20)
        + (75×0.15) + (100×0.15) + (100×0.10)
        = 15 + 9.5 + 14.7 + 20 + 11.25 + 15 + 10
        = 95.45/100 ≈ 95/100

RATING: EXEMPLARY ✅
```

---

## Running the Audit

### Manual Approach (Using This Guide)

1. Read each phase section above
2. Answer all audit questions for your project
3. Score each phase
4. Write the audit report (using template)
5. Identify strengths and gaps
6. Create improvement plan

**Time:** 45-60 minutes

---

### Automated Approach (Using Agent)

```bash
# Invoke audit agent (when available)
/audit-profile product-dev [project-path]

# Agent will:
# 1. Scan project structure
# 2. Check for all required files
# 3. Analyze file content
# 4. Score each phase
# 5. Generate report
# 6. Provide recommendations

# Output: audit-report.md in current directory
```

**Time:** 5-10 minutes

---

## After the Audit

### If Score 80+: Ship It!

```
✅ Project meets profile expectations
✅ Ready for production/sharing
✅ Can be case study/template for others
```

**Next steps:**
- Share audit report with team
- Document learnings
- Consider as template for next project

### If Score 60-79: Address Gaps

```
⚠️ Some improvements needed
⚠️ Quality is acceptable, but could improve
```

**Next steps:**
1. Prioritize gaps (quick wins first)
2. Create improvement tasks
3. Re-audit after fixes
4. Target 80+ on next audit

### If Score <60: Consider Rework

```
❌ Significant deviations from profile
❌ Quality or compliance concerns
```

**Next steps:**
1. Review profile spec thoroughly
2. Get mentorship/guidance
3. Plan rework phases
4. Target 80+ on next attempt

---

## Continuous Learning

### Build Audit Into Your Workflow

```
Project Planning
    ↓
Profile Implementation (Phases 1-7)
    ↓
AUDIT → Score: 85/100 ← Checkpoint!
    ↓
Gap Improvement (if needed)
    ↓
RE-AUDIT → Score: 92/100
    ↓
Project Complete
```

### Share Learnings

When you complete an audit:

```bash
# Save audit report for others
git add audit-report.md
git commit -m "audit: profile compliance report (95/100)"
git push

# Share findings
# "We used product-dev flavor, scored 95/100, here's what worked well..."
```

---

## Audit Checklist (Printable)

```
PROFILE AUDIT CHECKLIST
Project: ________________
Profile: ________________
Date: ___________________

Phase 1: Product Planning
  □ mission.md exists with substance
  □ roadmap.md exists with timeline
  □ tech-stack.md exists with rationale
  Score: __/100

Phase 2: Spec Initialization
  □ specs/ directory structure created
  □ planning/ subdirectory organized
  □ Folder structure is logical
  Score: __/100

Phase 3: Research
  □ requirements.md exists (200+ lines)
  □ User stories documented
  □ Success criteria listed
  □ Edge cases documented
  Score: __/100

Phase 4: Writing
  □ spec.md exists (500+ lines)
  □ Data models/interfaces defined
  □ Architecture documented
  □ Testing strategy included
  Score: __/100

Phase 5: Verification
  □ verification/ directory exists
  □ spec-verification-report.md exists
  □ Sign-off explicit ("APPROVED")
  □ Verification criteria listed
  Score: __/100

Phase 6: Tasks
  □ tasks.md exists (50+ tasks)
  □ Tasks organized into groups
  □ Dependencies documented
  □ Validation criteria per task
  □ (Bonus) orchestration.yml exists
  Score: __/100

Phase 7: Implementation
  □ All artifacts built
  □ Quality high (tests, linting, 0 errors)
  □ Git history clean (semantic commits)
  □ Retrospective/case study documented
  Score: __/100

OVERALL SCORE: __/100
```

---

## Contributing to Profile Improvements

If audit reveals issues with the profile itself (not your project):

```bash
# Report to agentops maintainers
# "When using product-dev flavor, I found that [gap]"
# "Suggestion: [improvement]"
# "Impact: [why this matters]"
```

This helps make profiles better for everyone! 📈

---

## Related Resources

- **product-dev profile:** agentops/profiles/product-dev/README.md
- **infrastructure-ops profile:** agentops/profiles/infrastructure-ops/README.md
- **Profile comparison:** agentops/docs/how-to/choose-profile.md
- **Multi-flavor projects:** agentops/docs/how-to/multi-flavor-workflows.md

---

**Version:** 1.0
**Status:** Production-ready
**Last Updated:** 2025-11-06
