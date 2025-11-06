---
description: Audit a profile/flavor implementation for compliance and quality
tags: audit, validation, profile, continuous-learning
---

# /audit-profile

Systematically audit a profile/flavor implementation against specification to ensure compliance, identify gaps, and drive continuous improvement.

## Philosophy

**"Trust but Verify"** — After building with a profile, audit to confirm:
- ✅ Does implementation follow the profile specification?
- ✅ Did work meet success criteria?
- ✅ What patterns and learnings emerged?
- ✅ What could improve for next time?

This enables **continuous learning** and **quality assurance** across all profile-based projects.

---

## Usage

### Basic Audit (Current Project)

```bash
/audit-profile

# Audits current directory against its profile
# Generates: audit-report.md
```

### Audit Specific Project

```bash
/audit-profile /path/to/project

# Audits specific project
# Automatically detects profile from product/ or product-dev/ directory
```

### Audit with Specific Profile

```bash
/audit-profile product-dev /path/to/project

# Explicitly specify profile if detection fails
```

### Detailed Audit with Recommendations

```bash
/audit-profile --detailed --improvement-plan

# Generates:
# - audit-report.md (detailed)
# - improvement-plan.md (if gaps found)
# - audit-checklist.txt (printable)
```

### Quick Audit (Score Only)

```bash
/audit-profile --quick

# Fast audit, reports score only
# Useful for CI/CD gates
```

### Audit Specific Phase Only

```bash
/audit-profile --phase 5

# Audit only verification phase
# Useful for mid-project checkpoints
```

### Compare Two Audits

```bash
/audit-profile --compare old-audit.json new-audit.json

# Shows progress between audits
# Useful for tracking improvement over time
```

### Generate Case Study Template

```bash
/audit-profile --case-study

# If score >90, generates case-study-template.md
# Ready for team/public sharing
```

---

## What Gets Audited (7 Phases)

### Phase 1: Product Planning (15% weight)
- ✅ mission.md (purpose, vision, success metrics)
- ✅ roadmap.md (timeline, features, milestones)
- ✅ tech-stack.md (technology choices, rationale)

### Phase 2: Spec Initialization (10% weight)
- ✅ specs/ folder structure and organization
- ✅ planning/ subdirectory setup
- ✅ Requirements placeholder

### Phase 3: Research (15% weight)
- ✅ requirements.md (detailed, comprehensive)
- ✅ User stories or personas
- ✅ Success criteria (measurable, testable)
- ✅ Edge cases and constraints

### Phase 4: Specification (20% weight - Highest)
- ✅ spec.md (detailed, 500+ lines)
- ✅ Data models/TypeScript interfaces
- ✅ Architecture documentation
- ✅ Acceptance criteria

### Phase 5: Verification (15% weight)
- ✅ spec-verification-report.md
- ✅ Formal sign-off ("APPROVED FOR IMPLEMENTATION")
- ✅ Verification criteria checklist
- ✅ Explicit yes/no decision

### Phase 6: Task Breakdown (15% weight)
- ✅ tasks.md (50+ tasks, organized)
- ✅ Task dependencies documented
- ✅ Validation criteria per task
- ✅ (Bonus) orchestration.yml with parallelization

### Phase 7: Implementation (10% weight)
- ✅ All artifacts built and working
- ✅ Quality high (tests, linting, 0 errors)
- ✅ Git history clean (semantic commits)
- ✅ Documentation (case study, learnings)

---

## Output

### Primary Output: audit-report.md

```markdown
# [Project] - Profile Audit Report

## Audit Summary
- Profile: [product-dev | infrastructure-ops | etc.]
- Overall Score: __/100
- Rating: EXEMPLARY | EXCELLENT | GOOD | ACCEPTABLE | MARGINAL | INSUFFICIENT

## Phase Scores
[Table with all 7 phases and scores]

## Strengths (What Went Well)
1. Strength 1
2. Strength 2
3. Strength 3

## Gaps (What Could Improve)
1. Gap 1 → Recommendation
2. Gap 2 → Recommendation

## Metrics
- Time invested
- Artifacts created
- Git commits
- Quality metrics

## Learnings & Patterns
1. Pattern discovered
2. Improvement opportunity
3. Reusable template

## Recommendation
APPROVED | CONDITIONAL | REVISIT

## Next Steps
1. Action 1
2. Action 2
3. Action 3
```

### Additional Outputs (with --detailed)

**improvement-plan.md** (if gaps found)
- Priority 1, 2, 3 improvements
- Time estimates per improvement
- Re-audit target score

**audit-checklist.txt** (printable)
- Checklist format for manual verification
- Can print and use for team review

**case-study-template.md** (if score >90)
- Ready-to-use template for sharing
- Pre-filled with project context
- Links to audit report

**metrics-dashboard.json** (optional)
- Machine-readable format
- For tracking audits over time
- Useful for CI/CD integration

---

## Scoring Guide

### Grade Scale

```
90-100  EXEMPLARY ⭐⭐⭐⭐⭐
        Profile adherence perfect
        Minimal gaps (nice-to-haves only)
        Ready to ship and share as case study

80-89   EXCELLENT ⭐⭐⭐⭐
        Profile compliance strong
        Minor gaps easily addressed
        Ready to ship with documentation

70-79   GOOD ⭐⭐⭐
        Profile clearly followed
        Some gaps need attention
        Ready to ship if gaps aren't critical

60-69   MARGINAL ⭐⭐
        Compliance present but gaps notable
        Quality concerns or missing pieces
        Recommend addressing gaps before shipping

<60     INSUFFICIENT ⭐
        Major gaps or compliance issues
        Recommend starting over with guidance
```

### Weight Distribution

```
Phase 1 (Product Planning):     15%
Phase 2 (Spec Initialization):  10%
Phase 3 (Research):             15%
Phase 4 (Writing):              20% ← Highest weight
Phase 5 (Verification):         15%
Phase 6 (Tasks):                15%
Phase 7 (Implementation):       10%

Formula:
Overall = (Phase1 × 0.15) + (Phase2 × 0.10) + (Phase3 × 0.15)
        + (Phase4 × 0.20) + (Phase5 × 0.15) + (Phase6 × 0.15)
        + (Phase7 × 0.10)
```

---

## Audit Gates (Quality Checkpoints)

### Mid-Project (After Phase 3)

```bash
/audit-profile --phase 1-3 --planning-gate
```

Check: Are requirements comprehensive before writing specs?
- Score <75: Revise requirements
- Score >75: Continue to specs

### Pre-Implementation (After Phase 5)

```bash
/audit-profile --phase 1-5 --implementation-gate
```

Check: Is specification complete and verified before building?
- Score <80: Revise specs or verification
- Score >80: Begin implementation

### Final (After Phase 7)

```bash
/audit-profile --phase 1-7 --shipping-gate
```

Check: Is implementation complete and ready?
- Score <80: Fix gaps before shipping
- Score >80: Ship it!

---

## Real Example: Personal-Website

```bash
$ cd personal-website
$ /audit-profile

Auditing: personal-website
Profile: product-dev
Analyzing phases 1-7...

RESULTS:
========
Phase 1 (Product Planning):     100/100 ✅
Phase 2 (Spec Initialization):   95/100 ✅
Phase 3 (Research):              98/100 ✅
Phase 4 (Writing):              100/100 ✅
Phase 5 (Verification):          75/100 ⚠️
Phase 6 (Tasks):                100/100 ✅
Phase 7 (Implementation):        100/100 ✅

OVERALL SCORE: 95/100 ⭐⭐⭐⭐⭐
RATING: EXEMPLARY

Strengths:
✅ Comprehensive documentation (mission.md, roadmap.md, tech-stack.md)
✅ Multi-agent orchestration (16 agents, 2.3x speedup)
✅ Context bundles (30:1 compression proven)
✅ Spec-first discipline (0 rework)

Gaps:
⚠️ Phase 5: Missing formal verification report

Recommendation:
Add specs/showcase-feature/verification/spec-verification-report.md
This would bring score to 100/100.

Status: READY TO SHIP ✅

Output: audit-report.md (2,847 words)
```

---

## Integration with Your Workflow

### Day-by-Day Example

```
Monday: Complete Phases 1-3 (Planning & Research)
  └─ /audit-profile --phase 1-3 --planning-gate
     Score: 82/100 → Continue to specs

Wednesday: Complete Phases 4-5 (Specs & Verification)
  └─ /audit-profile --phase 1-5 --implementation-gate
     Score: 85/100 → Begin implementation

Friday: Complete Phases 6-7 (Tasks & Implementation)
  └─ /audit-profile (full audit)
     Score: 91/100 → Ready to ship!

Next Monday: Publish Case Study
  └─ Use case-study-template.md generated by audit
```

### Team Example

```
Feature Kickoff:
  Project Owner runs: /audit-profile --case-study
  Uses templates to communicate vision

Mid-Project:
  Tech Lead runs: /audit-profile --phase 1-5
  Ensures specs meet team standards

Before Launch:
  QA runs: /audit-profile --detailed
  Generates improvement-plan.md if gaps found

Post-Launch:
  Team reviews: audit-report.md
  Captures learnings for next project
```

---

## Continuous Learning

### Track Improvement Over Time

```bash
# First audit
/audit-profile > audit-2025-11-06.md

# After gap fixes
/audit-profile > audit-2025-11-13.md

# Compare progress
/audit-profile --compare audit-2025-11-06.json audit-2025-11-13.json

Output:
  Score improvement: 72 → 88 (+16 points)
  Gaps addressed: 3/5
  Remaining gaps: 2/5 (low priority)
```

### Share Learnings

```bash
# After audit with high score
git add audit-report.md
git commit -m "audit(product-dev): 95/100 - exemplary implementation"
git push

# Share with team
# "Completed feature-X with product-dev profile, scored 95/100"
# "See audit-report.md for full analysis"
```

---

## Advanced Options

### CI/CD Integration

```bash
# Fail if score below threshold
/audit-profile --min-score 80 || exit 1

# Useful in: .gitlab-ci.yml or .github/workflows/
```

### Auto-Fix Suggestions

```bash
# Get AI-generated improvement suggestions
/audit-profile --ai-improvements

# Returns: "Phase 5 gap suggests adding verification gate"
# "Phase 3 gap suggests adding operator personas"
```

### Comparison to Typical Projects

```bash
# See how you compare to benchmarks
/audit-profile --benchmark product-dev

Output:
  Your score: 95/100
  Typical product-dev: 75/100
  You're in top 10% 🎉
```

### Metrics Export

```bash
# Export metrics for dashboard
/audit-profile --export-metrics metrics.json

# Fields:
# - overall_score
# - phase_scores (array)
# - time_invested
# - artifact_count
# - quality_metrics
# - timestamp
```

---

## Troubleshooting

### "Cannot detect profile"

```bash
# Explicitly specify profile
/audit-profile product-dev /path/to/project
```

### "Missing required files"

```bash
# See which files are missing
/audit-profile --detailed

# Look for "Gap:" sections
# Each gap says what file is missing
```

### "Score seems low"

```bash
# Check which phases need work
/audit-profile --detailed

# Read "Gaps & Recommendations" section
# Prioritize high-weight phases (Phase 4 = 20%)
```

### "Want to share audit but score is low"

```bash
# Still valuable! Share with context:
# "Audited implementation, found gaps, here's improvement plan"
# Use improvement-plan.md from audit
# Shows commitment to quality and learning
```

---

## Contributing to Profile Audits

Found an issue with audit criteria?

```bash
# Report to agentops maintainers
Issue: "When auditing [profile], [criteria] is too strict/lenient"
Suggestion: "[improvement]"
Example: "[from my project]"
Impact: "[why this matters]"
```

Help make audits better for everyone! 📊

---

## Related Documentation

- **audit-profile-implementation.md** - Detailed audit guide and checklist
- **profile-audit-agent.md** - Agent implementation details
- **product-dev profile** - Full specification for product-dev flavor
- **infrastructure-ops profile** - Full specification for infrastructure-ops flavor
- **Case studies** - Examples of audited implementations

---

## Quick Reference

```bash
# Audit current project
/audit-profile

# Audit specific path
/audit-profile /path/to/project

# Detailed audit
/audit-profile --detailed

# Specific phase
/audit-profile --phase 5

# Compare two audits
/audit-profile --compare old.json new.json

# Generate case study
/audit-profile --case-study

# CI/CD gate
/audit-profile --min-score 80 || exit 1
```

---

**Command Version:** 1.0
**Status:** Production-ready
**Created:** 2025-11-06
**Last Updated:** 2025-11-06

**Philosophy:** Trust but Verify. Continuous Learning. Quality Assurance.
