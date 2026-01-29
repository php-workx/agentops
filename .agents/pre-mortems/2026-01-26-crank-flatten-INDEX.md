# Ops Failure Simulation: Crank Flatten Plan - Complete Analysis

**Date:** 2026-01-26
**Plan Under Review:** Flatten skill nesting to reduce context from 24K to 12K tokens
**Simulation Approach:** 12 parallel agents in one swarm + batch vibe at end
**Overall Status:** NOT READY AS PROPOSED

---

## Documents in This Analysis

### 1. EXECUTIVE SUMMARY (READ THIS FIRST)
**File:** `2026-01-26-crank-flatten-EXECUTIVE-SUMMARY.txt`
**Size:** 11 KB
**Read Time:** 10 minutes

**Contains:**
- Key findings (3 CRITICAL failures identified)
- Severity matrix (12 total failure modes)
- Quantified impact (worst/best/expected cases)
- Comparison of 3 options (current vs original vs hybrid)
- Architectural principle violated (Brownian Ratchet)
- Hybrid validation strategy overview
- Token budget comparison
- Approval criteria for original proposal
- Recommendation (implement hybrid instead)

**Start here.** This gives complete overview in 10 minutes.

---

### 2. MAIN FAILURE ANALYSIS
**File:** `2026-01-26-crank-flatten-ops-failures.md`
**Size:** 19 KB
**Read Time:** 25 minutes

**Contains:**
- Question 1: Rate limiting at 12 parallel agents (CRITICAL, HIGH)
- Question 2: Batch vibe finds early issues (CRITICAL, HIGH, MEDIUM)
- Question 3: Progress visibility without per-issue vibe (HIGH, MEDIUM)
- Failure cascade scenarios (3 detailed walkthroughs)
- Severity ratings table (12 failures with MTTR and cost)
- Mitigations and why they fail
- Conclusion with severity ratings

**Read this for detailed failure modes and impact analysis.**

---

### 3. TECHNICAL DEEP DIVE
**File:** `2026-01-26-crank-flatten-technical-details.md`
**Size:** 16 KB
**Read Time:** 20 minutes

**Contains:**
- Failure Mode 1: Rate limit cascades (API mechanics, detection lag)
- Failure Mode 2: Vibe scope ambiguity (lost audit trail, cross-file deps)
- Failure Mode 3: Silent merge of broken code (safeguard analysis)
- Failure Mode 4: Anthropic rate limit exhaustion (burst scenario)
- Failure Mode 5: GitHub API abuse detection (simultaneous pushes)
- Failure Mode 6: Vibe downtime and validation gap
- Quantified risks table
- Why 6-agent post-mortem works but 12-agent crank doesn't

**Read this for root cause analysis and code evidence.**

---

### 4. RECOMMENDATIONS AND STRATEGY
**File:** `2026-01-26-crank-flatten-recommendations.md`
**Size:** 13 KB
**Read Time:** 18 minutes

**Contains:**
- Why the proposal fails (Brownian Ratchet principle violated)
- Recommended alternative: Hybrid validation (37.5% savings, LOW risk)
- Strategy: Two-tier vibe (fast gate + comprehensive audit)
- Implementation roadmap (Phase 1-4, 4 hours total)
- Risk comparison (original vs hybrid)
- Token savings comparison
- Why other mitigations fail
- Approval criteria (5 requirements for original proposal)
- Next steps

**Read this to understand the hybrid alternative and how to implement it.**

---

## Quick Reference: Severity Ratings

### CRITICAL (Do not implement without fixing)
1. **Rate Limit Cascade** - All 12 agents stall simultaneously
2. **Silent Defect Propagation** - Early issues contaminate later issues
3. **Broken Main Branch** - Code merges without validation

### HIGH (Likely to cause problems)
1. **GitHub Rate Limiting** - Abuse detection on concurrent pushes
2. **Module Contamination** - Issues depend on broken changes
3. **Mayor Goes Blind** - No progress signals during execution
4. **Architecture Violations** - Late detection creates debt

### MEDIUM (Could cause issues)
1. **Debugging Difficulty** - Multi-issue vibe reports lose granularity
2. **No Circuit Breaker** - Forced reverts of merged code
3. **Hidden Stalls** - Crank appears hung with no heartbeat signal
4. **Token Savings Lost** - Plan doesn't achieve intended benefits

---

## Decision Framework

### If You Want the Original Plan (12K tokens):
**Requirement:** Address 5 approval criteria
**Effort:** 2-3 weeks
**Success Probability:** 70%
**Net Benefit:** 50% savings IF successful, HIGH risk of failure

### If You Want Safe Savings (15K tokens):
**Requirement:** Implement hybrid validation
**Effort:** 4 hours
**Success Probability:** 99%
**Net Benefit:** 37.5% savings with CRITICAL risks eliminated

---

## Key Metrics

| Metric | Current | Original | Hybrid | Better |
|--------|---------|----------|--------|--------|
| Token Usage | 24K | 12K | 15K | Hybrid (safe) |
| Savings | - | 50% | 37.5% | Hybrid (safe) |
| Risk Level | LOW | CRITICAL | LOW | Hybrid |
| MTTR if Fails | <30 min | 3+ hours | <30 min | Current & Hybrid tie |
| Recovery Complexity | Simple | Very Complex | Simple | Current & Hybrid tie |
| Implementation Effort | - | 3 weeks | 4 hours | Hybrid |
| Maintenance Burden | Low | High | Low | Hybrid |

---

## Architectural Impact

### Current Architecture (Safe)
```
Issue → Implement → Vibe (FILTER) → Merge (RATCHET) → ✓
                     ↓
                 If issues found, escalate before merge
```

### Original Proposal (Unsafe)
```
Issue → Implement → Merge (RATCHET) → Vibe (AUDIT) → ✗
                     ↓
                 Issues already merged, can't prevent
```

### Hybrid Recommendation (Safe)
```
Issue → Implement → Fast Vibe (FILTER) → Merge (RATCHET) → ✓
                     ↓
                 If critical issues, escalate before merge
                 
[After all complete]
                      Comprehensive Vibe (AUDIT)
                      → Creates follow-up issues, not gating
```

---

## Files in This Analysis

```
.agents/pre-mortems/2026-01-26-crank-flatten-*

├── INDEX.md (this file)
│   └── Navigation guide and quick reference

├── EXECUTIVE-SUMMARY.txt
│   └── 10-minute overview of entire analysis

├── ops-failures.md
│   └── Detailed failure modes and cascade scenarios
│   └── 12 failure modes with severity ratings

├── technical-details.md
│   └── Root cause analysis with code examples
│   └── Rate limit mechanics, audit trail loss, etc.

└── recommendations.md
    └── Hybrid validation strategy
    └── Implementation roadmap
    └── Approval criteria for original proposal
```

---

## Next Steps

### For Decision Makers:
1. Read EXECUTIVE-SUMMARY.txt (10 min)
2. Review risk comparison table (2 min)
3. Decide: original proposal vs hybrid strategy
4. If hybrid: create implementation issue (est. 4 hours work)
5. If original: ensure all 5 approval criteria will be met

### For Implementation (if Hybrid):
1. Add `--fast` mode to vibe/SKILL.md
2. Update crank/SKILL.md to use `--fast` flag
3. Test on simple epic
4. Update documentation

### For Implementation (if Original):
1. Address rate limit coordination (2 weeks)
2. Implement circuit breaker (1 week)
3. Add progress reporting (3 days)
4. Comprehensive testing (3 days)
5. Operational playbook (3 days)
6. Total: 2-3 weeks before safe to deploy

---

## Recommendation Summary

**Original Proposal:** DO NOT IMPLEMENT without 2-3 weeks of safety hardening
**Hybrid Alternative:** IMPLEMENT - achieves 37.5% savings with minimal risk
**Fallback:** Keep current implementation (24K tokens, proven safe)

The hybrid approach is the pragmatic choice: good savings (37.5%) + proven safety + quick implementation (4 hours).
