# Integration Failure Analysis: Flatten Skill Nesting Plan
## Index of Analysis Documents

**Analysis Date:** 2026-01-26
**Status:** CRITICAL ISSUES IDENTIFIED
**Recommendation:** DO NOT PROCEED WITHOUT ADDRESSING CRITICAL FINDINGS

---

## Quick Summary

The plan to flatten skill nesting (reduce 6-agent vibe to 2, consolidate 12 agents in post-mortem, batch crank vibe at end) introduces **3 CRITICAL integration failures** that will definitely cause problems:

1. **Task tool concurrency limit unknown** - 12 agents may not dispatch
2. **Token budget explosion** - synthesis step exceeds context window
3. **Conflicting findings have no merge algorithm** - synthesis paralysis

Plus **4 HIGH-severity issues** and **3 MEDIUM-severity issues**.

**Total blocking issues: 7**

---

## Document Index

### Start Here
- **[INTEGRATION-FAILURES-SUMMARY.md](INTEGRATION-FAILURES-SUMMARY.md)** (12k words, 10 min read)
  - Executive summary
  - All findings with severity ratings
  - Decision matrix (proceed/don't proceed/alternatives)
  - Recommended action plan (5 phases)
  - Quick reference table

### Deep Technical Dives

- **[2026-01-26-flatten-nesting-integration-failures.md](2026-01-26-flatten-nesting-integration-failures.md)** (31k words, 25 min read)
  - Complete pre-mortem simulation
  - All 12 findings with detailed failure modes
  - Code locations and evidence
  - Integration test plan
  - Conclusion and verdict

- **[INTEGRATION-TECHNICAL-BREAKDOWN.md](INTEGRATION-TECHNICAL-BREAKDOWN.md)** (17k words, 15 min read)
  - Integration Point 1: Task tool dispatch & concurrency
  - Integration Point 2: Token budget management
  - Integration Point 3: Result synthesis & conflict resolution
  - Token flow analysis with concrete numbers
  - Synthesis algorithm options (5 different approaches)
  - Why current architecture works (6 agents)
  - Why proposed architecture breaks (12 agents)

---

## Finding Categories

### CRITICAL (3) - Will Definitely Fail
1. Task tool concurrency limit unknown
2. Token budget explosion (182k tokens / 91% of 200k budget)
3. Conflicting findings cannot be merged (no synthesis algorithm)

### HIGH (4) - Likely to Cause Problems
4. Vibe scope already optimal (Issue 1 is misdirected)
5. Crank batching increases regression risk (Issue 5 risky)
6. Agent registration not verified
7. No synthesis algorithm defined

### MEDIUM (3) - Could Cause Issues
8. Session token budget overflow
9. Vibe aspect weights unbalanced
10. Haiku model insufficient for complex tasks

### LOW (2) - Minor Concerns
11. Agent name mismatch risk
12. Report template too small

---

## Current State (Verified)

### Agent Dispatch Counts
| Skill | Agents | Pattern |
|-------|--------|---------|
| vibe | 2 | Already optimal |
| research | 4 | Sequential then parallel |
| pre-mortem | 4 | Parallel |
| post-mortem | 6 | Parallel |
| **Total** | **16** | **Max parallel: 6** |

### Agents Used (16/20)
```
assumption-challenger
code-quality-expert
code-reviewer
coverage-expert
data-failure-expert
depth-expert
edge-case-hunter
flywheel-feeder
gap-identifier
goal-achievement-expert
integration-failure-expert
ops-failure-expert
plan-compliance-expert
process-learnings-expert
ratchet-validator
security-reviewer
technical-learnings-expert

(NOT USED: security-expert, architecture-expert, ux-expert)
```

---

## Key Findings

### Finding #1: Concurrency Limit Unknown (CRITICAL)
**What:** Deploying 12 agents simultaneously has undocumented behavior
**Risk:** Silent drop of agents 7-12, or timeout errors
**Evidence:** Current max tested = 6 agents
**Status:** Untested, unknown behavior

### Finding #2: Token Explosion (CRITICAL)
**What:** Post-mortem dispatch (12 agents) uses 72k tokens, synthesis adds 39k
**Risk:** Total 182k tokens (91% of budget), synthesis fails
**Evidence:** Concrete token accounting in technical breakdown
**Status:** Mathematically inevitable

### Finding #3: No Synthesis Algorithm (CRITICAL)
**What:** 12 agents return different answers, no merge strategy defined
**Risk:** Synthesis paralysis, conflicting report, wrong findings
**Evidence:** post-mortem/SKILL.md has no algorithm documented
**Status:** Architectural gap, not fixable with code

### Finding #4: Vibe Already Optimal (HIGH)
**What:** Issue 1 claims vibe needs reduction, but vibe already at 2 agents
**Risk:** Misdirected plan, wasting effort on non-problem
**Evidence:** vibe/SKILL.md only dispatches security-reviewer + code-reviewer
**Status:** Documentation fix needed

### Finding #5: Crank Batching Risky (HIGH)
**What:** Issue 5 proposes batching vibe at end, increasing regression risk
**Risk:** Bugs compound across 4 issues, harder to isolate and fix
**Evidence:** Cascade failure scenario documented in breakdown
**Status:** Keep per-issue validation

---

## Severity Ratings Explained

### CRITICAL
**Definition:** Will definitely fail in production
**Gate:** BLOCKS deployment
**Action:** Must fix before proceeding

### HIGH
**Definition:** Likely to cause problems, workflow failure probable
**Gate:** Should block deployment
**Action:** Must address, can delay only if risk accepted

### MEDIUM
**Definition:** Could cause issues under some conditions
**Gate:** Recommended to address
**Action:** Fix if possible, acceptable as known limitation

### LOW
**Definition:** Minor concerns, unlikely to block workflows
**Gate:** Optional improvements
**Action:** Fix if easy, can defer

---

## Confidence Levels

| Finding Level | Confidence | Basis |
|---|---|---|
| CRITICAL | 100% | Architecture gaps, fundamental conflicts |
| HIGH | 95% | Logical dependencies verified against code |
| MEDIUM | 85% | Token estimates, subject to actual behavior |
| LOW | 70% | Minor concerns, easy to verify/fix |

---

## Recommendations

### DO NOT PROCEED
with flattening plan until CRITICAL issues are resolved.

### Recommended Path Forward

**Phase 1: Documentation Fix (1 day)**
- [ ] Update Issue 1: Vibe already optimal
- [ ] Document current 2-agent vibe architecture
- [ ] List all 16 agents in use with roles

**Phase 2: Research & Design (3-5 days)**
- [ ] Design synthesis algorithm for 12-agent findings
- [ ] Research Task tool concurrency limits (contact Claude Code team)
- [ ] Test algorithm with real epic data
- [ ] Measure actual token consumption

**Phase 3: Incremental Testing (1-2 weeks)**
- [ ] Test 6-agent post-mortem at scale
- [ ] Measure token usage vs predictions
- [ ] Run full crank epic with current architecture
- [ ] Verify no edge cases with nested Skill calls

**Phase 4: Staged Implementation (2-3 weeks, IF Phase 3 passes)**
- [ ] Implement synthesis algorithm
- [ ] Test 8-agent dispatch in staging
- [ ] Test 12-agent dispatch in staging
- [ ] Run both old + new architecture on same epics

**Phase 5: Gradual Rollout (1-2 weeks)**
- [ ] Deploy to test agents first
- [ ] Monitor token usage
- [ ] Prepare rollback plan
- [ ] Measure improvement (if any)

**Estimated total: 3-5 weeks to safe flattening**

---

## Decision Matrix

| Scenario | Recommendation | Rationale |
|---|---|---|
| **Proceed immediately** | ❌ NO | 3 CRITICAL + 4 HIGH issues cause failure |
| **Keep current nested** | ✅ YES | Stable, tested, tokens managed |
| **Improve nested** | ✅ RECOMMENDED | Fix medium issues, better performance |
| **Test flattening parallel** | ✅ GOOD | Run both on same epics, compare |
| **Phase implementation** | ✅ BEST | Design, test, deploy gradually |

---

## Files in This Analysis

**Main documents:**
1. `.agents/pre-mortems/INTEGRATION-FAILURES-SUMMARY.md` (12k) - Start here
2. `.agents/pre-mortems/2026-01-26-flatten-nesting-integration-failures.md` (31k) - Full analysis
3. `.agents/pre-mortems/INTEGRATION-TECHNICAL-BREAKDOWN.md` (17k) - Technical details

**Related pre-mortems:**
- `2026-01-26-flatten-skill-nesting-data-failures.md` - Data failure simulation
- `2026-01-26-crank-flatten-ops-failures.md` - Operations failure simulation
- `2026-01-26-crank-flatten-recommendations.md` - Recommendations

---

## How to Use These Documents

### For Decision Makers
Read: **INTEGRATION-FAILURES-SUMMARY.md**
- Time: 10 minutes
- Output: Decision on whether to proceed
- Contains: Severity table, decision matrix, action plan

### For Technical Leads
Read: **INTEGRATION-TECHNICAL-BREAKDOWN.md**
- Time: 15 minutes
- Output: Understanding of where failures occur
- Contains: Token accounting, synthesis algorithms, conflict scenarios

### For Implementers
Read: **2026-01-26-flatten-nesting-integration-failures.md**
- Time: 25 minutes
- Output: Detailed failure modes and mitigations
- Contains: Failure sequences, code locations, test plans

### For Designers of Fix
Read all three documents
- Time: 50 minutes total
- Output: Complete understanding of system
- Can then design synthesis algorithm and testing strategy

---

## Contact & Feedback

This analysis was performed by Integration Failure Expert agent.

For questions about specific findings:
- CRITICAL-1 (concurrency): See INTEGRATION-TECHNICAL-BREAKDOWN.md, Integration Point 1
- CRITICAL-2 (tokens): See INTEGRATION-TECHNICAL-BREAKDOWN.md, Integration Point 2
- CRITICAL-3 (synthesis): See 2026-01-26-flatten-nesting-integration-failures.md, Section CRITICAL-3

---

## Version History

| Date | Version | Changes |
|---|---|---|
| 2026-01-26 | 1.0 | Initial integration failure analysis |

Last updated: 2026-01-26

---

## Next Steps

1. Read INTEGRATION-FAILURES-SUMMARY.md (10 min)
2. Decide: Proceed or delay?
   - **If delay:** Go to Phase 1 (documentation fix)
   - **If proceed anyway:** Review mitigations section
3. If mitigations chosen: Implement token tracking + partial dispatch
4. Schedule Phase 2 research sprint (synthesis algorithm design)

---

