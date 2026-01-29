# Pre-Mortem: Flatten Skill Nesting Plan

**Date:** 2026-01-26
**Spec:** .agents/plans/2026-01-26-flatten-skill-nesting.md

## Summary

Plan to flatten skill nesting (post-mortem, vibe, crank) by eliminating nested Skill calls and dispatching swarms directly. Four failure expert simulations identified **7 CRITICAL**, **10 HIGH**, and **8 MEDIUM** issues that must be addressed before implementation.

## Simulation Findings

### CRITICAL (Must Fix)

1. **12-Agent Concurrency Limit Unknown**
   - **Why it will fail:** Attempting to dispatch 12 agents simultaneously has undocumented behavior. Current max tested: 6 agents.
   - **Recommended fix:** Test with 8, 10, 12 agents before implementing. Document limits.

2. **Token Budget Explosion**
   - **Why it will fail:** 12 agents × 6K tokens = 72K for dispatch alone. With synthesis: ~147K tokens. Session budget 200K means 91% consumed by post-mortem alone.
   - **Recommended fix:** Reduce parallel agents to 8 max, or implement agent batching.

3. **Conflicting Findings - No Resolution Algorithm**
   - **Why it will fail:** 12 agents analyzing same code produce conflicting findings (security-reviewer: CRITICAL, code-reviewer: no issues). No merge strategy documented.
   - **Recommended fix:** Design conflict resolution protocol (majority vote, severity escalation, etc).

4. **Vibe with 0 Files Returns Ambiguous Status**
   - **Why it will fail:** Git diff empty → vibe enters validation with 0 files → reports unclear status
   - **Recommended fix:** Add guard: if file_count == 0, return "PASS (no changes)"

5. **Nested Agent Timeout Without Cancellation**
   - **Why it will fail:** One agent hangs → entire post-mortem stalls indefinitely
   - **Recommended fix:** Add per-agent timeout (3 min), proceed with N-1 results

6. **Post-Mortem Before Any Work Done**
   - **Why it will fail:** No commits → all 12 agents report "no work found" → misleading success
   - **Recommended fix:** Pre-check: if no commits since epic, reject with error

7. **All Agents Return "No Findings"**
   - **Why it will fail:** Empty swarm completes but no learnings captured → knowledge flywheel breaks
   - **Recommended fix:** If all agents find 0 issues + 0 learnings, escalate for manual review

### HIGH (Should Fix)

1. **Crank Batching Increases Regression Risk**
   - **Risk:** Batch vibe at end finds bugs introduced in issue 1, but issues 2-4 built on it. Fixing cascades.
   - **Mitigation:** Add fast validation (tests + secrets) per-issue, comprehensive vibe at end only.

2. **Rate Limit Cascade**
   - **Risk:** 12 parallel agents = 12 API calls simultaneously → rate limiting → recovery consumes more tokens than saved
   - **Mitigation:** Stagger agent dispatch (3 at a time) or use documented concurrency limits.

3. **Vibe Report Format Coupling**
   - **Risk:** Retro depends on vibe report structure. Format change breaks retro silently.
   - **Mitigation:** Define vibe report schema contract, add validation in retro.

4. **Partial Agent Failures**
   - **Risk:** 10 of 12 agents return → synthesis logic undefined → incomplete validation marked complete
   - **Mitigation:** Define behavior for N<12: minimum quorum (e.g., 80%) or explicit incomplete status.

5. **User Cancellation Mid-Swarm**
   - **Risk:** Ctrl+C at agent 4/12 → partial results never written → corrupt state
   - **Mitigation:** Signal handler: write partial report with "INCOMPLETE" marker.

6. **Empty Epic (No Issues)**
   - **Risk:** Epic with 0 issues → crank completes instantly → "epic done" with no work
   - **Mitigation:** Pre-check in crank: if ready_issues == 0, error "No issues to work on"

7. **Prescan Secrets Found - No Recovery Path**
   - **Risk:** Prescan finds API key → blocks gate → user doesn't know WHERE the secret is
   - **Mitigation:** Capture prescan output, add as CRITICAL finding with file:line.

8. **100+ Files Exhausts Context**
   - **Risk:** Large refactor → vibe tries to read 200 files → context overflow mid-review
   - **Mitigation:** Batch files: max 20 per vibe, split into multiple reports.

9. **Agent Dispatch Timeout in Vibe Step 6**
   - **Risk:** Security-reviewer hangs on complex auth code → vibe stalls
   - **Mitigation:** Per-agent timeout with fallback to self-analysis.

10. **Single-Issue Epic Edge Case**
    - **Risk:** 1 issue with high complexity → implement times out → crank stalls with no fallback
    - **Mitigation:** Warn user if single issue with high estimate.

### MEDIUM (Consider)

1. **Crank retry loop with no escape** - User stuck in fix loop on single issue
2. **Missing session ID for provenance** - flywheel-feeder gets literal "<current-session-id>"
3. **Retro idempotency** - Called twice creates duplicate learnings
4. **Non-git directory breaks vibe** - git commands fail silently
5. **Report filename collisions** - Parallel execution overwrites reports
6. **Model availability not validated** - "haiku" dispatch fails if model unavailable
7. **Knowledge indexing fails silently** - ao forge 2>/dev/null hides errors
8. **Agent findings vs vibe grade contradiction** - Report says "A" but vibe was "C"

## Ambiguities Found

- What is the actual concurrency limit for Task tool? (Need to test)
- How should 12 agents' conflicting findings be merged? (Need algorithm)
- What's the minimum quorum for partial agent completion? (80%? 100%?)
- Should batch vibe preserve per-issue fast validation? (Yes - hybrid approach)

## Spec Enhancement Recommendations

1. **Add:** Conflict resolution protocol for multi-agent findings
2. **Add:** Per-agent timeout with partial completion handling
3. **Add:** Pre-flight checks (work exists, files to review, git available)
4. **Reduce:** 12 parallel agents → 8 max (or batched dispatch)
5. **Clarify:** Minimum agent quorum for valid synthesis
6. **Hybrid:** Keep fast per-issue vibe (tests + secrets), batch comprehensive vibe

## Alternative: Hybrid Validation Strategy

Instead of pure "batch at end", implement two-tier validation:

| Tier | When | What | Cost |
|------|------|------|------|
| Fast | Per-issue | Tests, secrets, compilation | ~100 tokens |
| Deep | Post-epic | Architecture, complexity, accessibility | ~12K tokens |

**Benefits:**
- 37.5% token savings (vs 50% for pure batch, but safer)
- Maintains per-issue validation gate
- LOW risk vs CRITICAL risk for pure batch

## Verdict

- [ ] ~~READY - Proceed to implementation~~
- [x] **NEEDS WORK** - Address critical/high issues first

## Blocking Issues Before Implementation

| # | Issue | Effort | Priority |
|---|-------|--------|----------|
| 1 | Test 12-agent concurrency | 2h | P0 |
| 2 | Design conflict resolution | 4h | P0 |
| 3 | Add pre-flight checks | 2h | P0 |
| 4 | Implement agent timeouts | 4h | P1 |
| 5 | Define partial completion behavior | 2h | P1 |
| 6 | Consider hybrid validation | 4h | P1 |

**Estimated remediation:** 1-2 weeks before safe to implement original plan.
**Alternative:** Implement hybrid approach (4h) for immediate 37.5% savings with LOW risk.
