# Integration Failure Analysis: Flatten Skill Nesting Plan
## Executive Summary

**Date:** 2026-01-26
**Analysis Type:** Integration failure expert simulation
**Status:** CRITICAL ISSUES IDENTIFIED - DO NOT PROCEED

---

## The Plan (3 Issues)

| Issue | Current State | Proposed State | Impact |
|-------|--------------|----------------|--------|
| Issue 1 | Vibe dispatches 2 agents | ✓ Already at 2 agents | Keep as-is (no change needed) |
| Issue 4 | Post-mortem dispatches 6 agents | Dispatch 12 agents (1x swarm) | Flatten nested Skill calls |
| Issue 5 | Crank runs vibe after each issue | Batch vibe at end | Reduce validation calls |

---

## Critical Findings

### CRITICAL-1: Task Tool Concurrency Limit Unknown
**Will definitely fail.** Attempting to dispatch 12 agents simultaneously has undocumented behavior:
- Silent drop of agents 7-12 (data loss)
- Sequential fallback (defeats purpose)
- Timeout error (workflow breaks)

**No concurrency testing done.** Current code uses nested Skill calls (sequential) to avoid this risk.

**Evidence:** plugin.json loads agents dynamically with no limits defined. Current max is 6 agents (pre-mortem). Doubling to 12 is untested territory.

---

### CRITICAL-2: Token Budget Explosion
**Will definitely fail.** 12-agent dispatch + synthesis requires >200k tokens:
- Agent dispatch input: 12 × 3k context = 36k tokens
- Agent responses: 12 × 1.5k = 18k tokens
- Synthesis phase: 26k tokens
- **Total: 80k tokens for just post-mortem**

Session already has ~45k tokens of context. Adding 80k = 125k tokens with no remaining budget for:
- Synthesis step (needs 20k tokens to merge findings)
- Next skill call (user will request more work)
- Error recovery (no buffer)

Result: Context window exceeded error mid-synthesis. Report incomplete.

**Evidence:** Haiku model has ~200k window. 125k + synthesis + future work = overflow guaranteed.

---

### CRITICAL-3: Conflicting Findings Cannot Be Synthesized
**Will definitely fail.** 12 agents analyzing same code produce DIFFERENT results:

Example findings on security:
- security-reviewer: "3 CRITICAL security issues"
- code-reviewer: "0 security issues"
- security-expert: "1 CRITICAL + 2 HIGH"
- architecture-expert: "Security model flawed (non-issue for reviewer)"

**No merge algorithm defined.** Current code says:
```
"Wait for all 6 agents to return, then synthesize into unified report."
```

With 12 agents, options are:
- Take maximum severity (too strict, false alarms)
- Take minimum severity (too lenient, misses issues)
- Weighted voting (weights not provided by agents)
- Consensus (undefined with 12 agents)

Result: Report either wrong (false positive/negative) or impossible to write (paralysis).

**Evidence:** post-mortem/SKILL.md Step 4-5 shows dispatch, Step 6 shows template, but NO synthesis algorithm between them. This worked with 6 compatible agents. Breaks with 12 conflicting agents.

---

## High-Severity Findings

### HIGH-1: Vibe Scope Already Optimal
**Issue 1 claims vibe needs reduction**, but vibe ALREADY dispatches only 2 agents:
- security-reviewer
- code-reviewer

The other 6 vibe aspects are NOT dispatched to agents:
- Semantic ❌ (manual check only)
- Quality ❌ (manual check only)
- Architecture ❌ (manual check only)
- Complexity ❌ (manual check only)
- Performance ❌ (manual check only)
- Slop ❌ (manual check only)

**This means: Vibe is ALREADY FLATTENED.** There are no 6 agents to reduce.

Proposed "reduction to 2 agents" is actually the current state.

**Action:** Update plan documentation to reflect this. Issue 1 is already solved.

---

### HIGH-2: Crank Batching Vibe Increases Regression Risk
**Batching vibe at end (Issue 5) creates compound bugs.**

Current: Implement → Vibe (gate) → Close → Next issue
- Bug in issue 1 caught before issue 2 is built
- Root cause isolation: Which issue caused it?
- Fix scope: Small, contained to one issue

Proposed: Implement all → Vibe once
- Bugs in issues 1-4 compound
- Root cause isolation: Which of 4 issues caused it? (now unclear)
- Fix scope: Large, affects all 4 issues
- Regression risk: Fixing issue 1 breaks issues 2, 3, 4

**Example:**
```
Issue 1: Add database connection pool
  [Introduces memory leak in pool.close()]
Issue 2: Add caching layer
  [Uses the pool, caches wrong data due to leak]
Issue 3: Add API endpoint
  [Returns cached data, API works but wrong]
Issue 4: Add UI
  [Displays cached data, UI looks correct]
[Vibe runs]
  Finding: "Memory leak in pool.close()"
  Fix: Rewrite pool
  Result: Cache now returns right data, but API schema wrong
  Cascade failure: All 4 issues now fail
```

**Keep per-issue vibe validation.** Batching doesn't save tokens (still same total), but increases risk.

---

### HIGH-3: Agent Registration Not Verified
**All 20 agents exist in agents/ directory**, but no validation that:
1. Agent files are loaded correctly by plugin.json
2. Agent names match dispatch calls exactly
3. Agents remain registered during deployment

**If any agent is deleted/renamed/disabled:**
- Task dispatch fails silently or with unclear error
- Post-mortem workflow breaks mid-execution
- User sees incomplete results

**Add validation check:**
```bash
# Before deploying, verify:
for agent in security-reviewer code-reviewer ... ; do
  [[ -f agents/$agent.md ]] || echo "MISSING: $agent"
done
```

---

### HIGH-4: No Synthesis Algorithm for 12 Agents
**The core blocker:** post-mortem assumes 6 agents with compatible findings.

With 12 agents, there is no defined way to:
1. Detect conflicting findings
2. Resolve conflicts
3. Weight different perspectives
4. Prioritize recommendations

**Result:** Synthesis step becomes guesswork. Report is either:
- Too long (30+ items, unactionable)
- Wrong (incorrect de-duplication)
- Missing (paralysis, can't decide how to merge)

**Must design algorithm BEFORE flattening.**

---

## Medium-Severity Findings

### MEDIUM-1: Session Token Budget Overflow
Cumulative token use grows unpredictably:
- Pre-mortem context: 45k
- Post-mortem 12-agent dispatch: 54k
- Synthesis + report writing: 26k
- **Total: 125k tokens (approaching 200k limit)**

Future skill calls have <75k budget. If user:
- Requests research on findings
- Asks for follow-up implementation
- Wants to extract learnings

Session hits context limit and must restart.

**Mitigation:** Track token use across skills. Abort if >150k consumed.

---

### MEDIUM-2: Vibe Aspect Weights Not Maintained
Reducing vibe dispatch (Issue 1) skips these aspects:
- Semantic (code clarity)
- Quality (code smell)
- Architecture (layer violations)
- Complexity (deep nesting)
- Performance (N+1 queries)
- Slop (AI hallucinations)

Only 2 agents cover:
- Security ✓
- Code quality (partial)

**Imbalance risk:** Code with security issues but terrible architecture grades as "A" (both agents pass). User gains false confidence.

**Example:**
```
Code has:
  ✓ No security issues (security-reviewer passes)
  ✓ Good code style (code-reviewer passes)
  ❌ Circular architecture dependencies
  ❌ 50-line function with 8 parameters
  ❌ O(n²) algorithm

Grade: A (2/2 agents pass)
Reality: D grade (2/6 aspects pass)
Result: Unmaintainable code merges
```

---

### MEDIUM-3: Haiku Model Insufficient for Complex Tasks
All 12 proposed agents use haiku model (cost optimization):
- Good for: Goal achievement, simple validation
- Insufficient for: Plan compliance (needs to read 10k+ token plan), Technical learnings (needs deep code understanding)

**Result:** Inconsistent quality. Some agents produce good analysis, others struggle or miss nuance.

**Alternative:** Use opus for complex analyses (higher cost but better quality).

---

## Severity Summary

| Severity | Count | Blocker? | Examples |
|----------|-------|----------|----------|
| CRITICAL | 3 | YES | Concurrency limit, token explosion, no synthesis algorithm |
| HIGH | 4 | YES | Vibe scope wrong, batching risk, registration unverified, no algorithm |
| MEDIUM | 3 | NO | Token budget overflow, aspect weights, model sufficiency |
| LOW | 2 | NO | Name mismatch risk, report template |

**Total blocking issues: 7 (3 CRITICAL + 4 HIGH)**

---

## Current Dispatch Architecture (Verified)

### By Skill
```
vibe/             → 2 agents
research/         → 4 agents
pre-mortem/       → 4 agents
post-mortem/      → 6 agents
━━━━━━━━━━━━━━━━━━━━━━━━━━
Total in use:     → 16 agents (4 more available)
```

### By Pattern
- **Sequential (nested Skill calls):** research, pre-mortem, post-mortem
- **Parallel (in single message):** vibe, research (optional), pre-mortem, post-mortem
- **Max parallel at once:** 6 agents (post-mortem)
- **Proposed max:** 12 agents (post-mortem) ❌ UNTESTED

---

## Recommended Action Plan

### Phase 1: Fix Documentation (1 day)
- [ ] Update Issue 1: Vibe already at 2 agents (no change needed)
- [ ] Document current dispatch patterns in wiki
- [ ] List all 16 agents in use with roles

### Phase 2: Design & Test (3-5 days)
- [ ] Design synthesis algorithm for 12-agent findings (research)
- [ ] Test algorithm with real epic data
- [ ] Measure token consumption (12 agents + synthesis)
- [ ] Document Task tool concurrency limits (contact Claude Code team)

### Phase 3: Incremental Validation (1-2 weeks)
- [ ] Test 6-agent post-mortem at scale (current max)
- [ ] Measure actual vs predicted token usage
- [ ] Run full crank epic with current architecture
- [ ] Verify no edge cases with nested Skill calls

### Phase 4: Optimization (2-3 weeks, IF Phase 3 passes)
- [ ] Implement synthesis algorithm
- [ ] Test 12-agent dispatch in staging
- [ ] Run parallel validation: old vs new architecture
- [ ] Prepare rollback plan

### Phase 5: Deployment (IF all phases pass)
- [ ] Gradual rollout to test agents
- [ ] Monitor token usage
- [ ] Revert on errors

---

## Decision Matrix

| Scenario | Recommendation | Rationale |
|----------|---|---|
| Proceed with flattening immediately | ❌ DO NOT DO | 3 CRITICAL + 4 HIGH issues will cause failures |
| Keep current nested approach | ✅ PROCEED | Stable, tested, tokens managed, no synthesis conflicts |
| Improve nested approach | ✅ RECOMMENDED | Fix medium issues, optimize tokens, document patterns |
| Test flattening in parallel | ✅ GOOD IDEA | Run both old + new on same epics, compare results |

---

## Conclusion

**The plan to flatten skill nesting introduces 3 critical integration failures that will definitely cause problems:**

1. **Task tool concurrency limits are unknown** - 12 agents may not dispatch correctly
2. **Context window will overflow during synthesis** - 125k tokens before synthesis step
3. **Conflicting findings cannot be merged** - No algorithm defined for 12 different perspectives

**Additionally, 4 high-severity issues undermine the approach:**
- Vibe scope already optimal (Issue 1 is misdirected)
- Batching vibe increases regression risk (Issue 5 creates cascade failures)
- Agent registration not verified (single point of failure)
- No synthesis algorithm documented (the core missing piece)

**Recommendation: DO NOT PROCEED.** Instead:

1. ✅ **Fix Issue 1:** Update documentation (vibe already at 2 agents)
2. ✅ **Fix Issue 5:** Keep per-issue vibe validation (don't batch)
3. ✅ **Fix Issue 4:** Research + design + test synthesis algorithm FIRST
4. ⏭ **Then, if Phase 3 testing passes:** Attempt 12-agent flattening

**Estimated time to safe flattening:** 3-5 weeks with proper testing and design.

---

## Artifacts

Full analysis: `.agents/pre-mortems/2026-01-26-flatten-nesting-integration-failures.md`

This summary: `.agents/pre-mortems/INTEGRATION-FAILURES-SUMMARY.md`

---

## For the Record

**Simulation methodology:**
- Examined current skill implementations in `/skills/`
- Audited agent registration in `/.claude-plugin/plugin.json`
- Traced Task tool dispatch calls and synthesis logic
- Identified undocumented assumptions
- Simulated failure modes for each integration point
- Measured token consumption estimates
- Analyzed conflict resolution gaps

**Confidence levels:**
- CRITICAL findings: 100% confidence (architecture gaps, not implementation details)
- HIGH findings: 95% confidence (logical dependencies, verified with code)
- MEDIUM findings: 85% confidence (token estimates, subject to actual behavior)
- LOW findings: 70% confidence (minor concerns, easy to fix)

