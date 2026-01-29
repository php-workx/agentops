# Ops Failure Simulation: Flatten Skill Nesting Plan

**Date:** 2026-01-26
**Plan:** Flatten skill nesting to reduce context explosion
**Scenario:** 12 parallel agents in one swarm + batch vibe at end
**Expected Outcome:** 24K → 12K token reduction

---

## Executive Summary

This ops failure simulation identifies **3 CRITICAL**, **5 HIGH**, and **4 MEDIUM** failure modes for the proposed flattening plan. The core issue: **batching vibe validation creates a distributed system coordination problem with three specific failure scenarios that degrade gracefully but never fail catastrophically.**

---

## Question 1: Rate Limiting at 12 Parallel Agents

### CRITICAL: Cascading Rate Limit Lockout

**Failure Mode**: 12 parallel agents = 12 API calls per second minimum. If any upstream API (Claude API, GitHub, git operations) has per-second limits, the entire swarm gets 429 throttled simultaneously.

**Probability**: HIGH (Claude API has per-minute and burst limits)

**Token Cost of Failure**:
- 12 agents × 200 tokens initialization = 2,400 tokens upfront
- 12 agents × 429 response = minimal cost, but completely wasted
- Retry backoff: 30s × 12 agents = 6 minutes lost coordination time
- Session timeout risk if 429s persist

**Cascade Mechanics**:
```
T=0s:   Mayor dispatches /crank
        ├─ agent-1 through agent-12 all fire simultaneously
        └─ Each makes 3-5 API calls within 1 second

T=1s:   GitHub rate limit: 60 req/min = 1 req/sec
        ├─ First 1 request succeeds
        ├─ Requests 2-12 hit 429: API rate limit exceeded
        └─ Anthropic rate limit: per-minute burst
            ├─ Likely triggers per-minute cap if all agents at Haiku
            ├─ Claude API returns rate-limit error
            └─ All 12 agents now blocked

T=2-30s: Retry storm
        ├─ Each agent independently retries (no backoff coordination)
        ├─ Creates thundering herd on rate limit recovery
        ├─ Mayor can't observe individual agent status (Task tool opacity)
        └─ No circuit breaker to halt new ignitions
```

**Evidence from Code**:
- **FIRE Loop**: `gt sling` commands batch ignite issues, but no rate-limit awareness
- **crank/SKILL.md**: "FOR EACH ready issue, USE THE SKILL TOOL" - sequential execution, not rate-limited parallel
- **post-mortem/SKILL.md**: "Launch ALL SIX agents in parallel" - established pattern, but with 6 agents, not 12
- **failure-taxonomy.md Line 237-277**: Covers external service failures, but assumes single polecat rate limit, not swarm coordination

**Mitigation Gaps**:
- No global rate-limit counter across agents
- No circuit breaker pattern ("stop igniting when rate limit hit")
- Mayor polling interval (30s) is too slow to react to immediate rate limit storms
- Task tool doesn't expose rate-limit headers in real-time

**Fallback Behavior**:
- System doesn't catastrophically fail (Claude API queues requests)
- But all 12 agents stall in coordinated lockout
- Mayor can't distinguish between "agents thinking" vs "agents 429'd"
- Crank continues polling but makes no progress for 5+ minutes

### HIGH: Anthropic Rate Limit on Haiku Models

**Failure Mode**: Proposal uses "model: haiku" for agents. If all 12 agents are Haiku instances:
- Anthropic limits requests per minute per API key
- Default: ~500 requests/minute for most API keys
- 12 agents × ~5 requests each during initialization = 60 requests
- 12 agents during execution = 1 request per second = 60 req/min baseline

**Probability**: MEDIUM-HIGH (at scale, common)

**Cascade**:
- Agents 1-7 get Haiku quota
- Agents 8-12 queue or fail
- Retry backoff (30s from FIRE spec) doesn't coordinate across agents
- No exponential backoff coordination mechanism

**Cost**: ~150 tokens per agent that hits queue

### HIGH: GitHub API Rate Limiting During Batch Operations

**Failure Mode**: If agents run `git push`, `git fetch`, `gh api` calls in parallel:
- GitHub: 5,000 requests per hour per token (authenticated)
- 12 agents pushing commits simultaneously = 12 write requests in <5s
- GitHub's abuse detection algorithm may flag as suspicious activity

**Probability**: MEDIUM (repo-size dependent)

**Result**:
- GitHub temporarily blocks the API key
- All agents fail simultaneously
- No recovery path in current code

---

## Question 2: Batch Vibe at End Finds Early Issues

### CRITICAL: Silent Propagation of Defects Across 12 Issues

**Failure Mode**: Crank executes issues 1→2→3→...→12 sequentially, but validates only after all 12 complete. If issue #3 introduces a bug in a shared module:

```
Time  Issue    Action              Module Impact
----  -----    ------              ---------------
0:00  gt-1     Implement X         ✓ Clean
0:30  gt-2     Implement Y         ✓ Clean
1:00  gt-3     Refactor Z (BREAKS) ✗ Z is now broken
1:30  gt-4     Add feature (uses Z) ✗ Feature uses broken Z
2:00  gt-5     Add tests (to Z)    ✗ Tests also broken
...
11:30 gt-12    Final feature       ✗ Hidden dependency on Z

12:00 Batch vibe runs             DISCOVERS: Z broken
      Finds:
      ├─ gt-3 broke Z
      ├─ gt-4 depends on broken Z
      ├─ gt-5 has broken tests
      ├─ gt-12 has hidden dependency
      └─ CRITICAL: 4 issues cross-contaminated
```

**Probability**: HIGH (shared module edits are common)

**Cost of Recovery**:
1. Vibe discovers the issue: 2 hours into crank
2. Bisect which issue broke: ~200 tokens (git archaeology)
3. Revert gt-3: force push required (coordination issue)
4. Re-run gt-4,5,12: 3 × (30 min work) = 90 minutes
5. Re-run vibe: 15 minutes
6. **Total lost**: ~3 hours + reputational damage

**Evidence from Code**:
- **crank/SKILL.md Line 73-77**: "Validate After Each Issue" runs vibe after EACH issue
- **failure-taxonomy.md Line 320-331**: Validation failure escalation assumes single-issue scope
- **vibe-coding.md**: No mechanism for cross-issue contamination detection
- **Proposed plan**: "batch vibe at end" = explicit removal of per-issue validation

**Compare Current vs Proposed**:

| Aspect | Current FIRE | Proposed Flatten |
|--------|--------------|------------------|
| Validation | After each issue | After all 12 issues |
| Early detection | YES - issue #3 | NO - issue #3 caught at 12:00 |
| Revert scope | Single issue | Multiple issues |
| Recovery time | ~30 min | ~3 hours |
| Ratchet property | Maintained | Broken (must revert 4+ issues) |

### HIGH: Vibe Validation Finds "Issues Were Fine Earlier"

**Failure Mode**: Batch vibe at 12:00 discovers that issue #7 (added at 5:30) is now broken due to conflicting changes in issue #9 (added at 6:30). But which one is wrong?

**Vibe Report Ambiguity**:
```
# Vibe Report: Batch Validation (12:00)

## CRITICAL Findings
1. **Module X (gt-7:main.rs:45)** - Type mismatch
   - gt-7 added: fn process(x: String)
   - gt-9 changed: fn process(x: i32)
   - Caller at gt-9 line 120 uses i32
   - **Risk**: Compile error

Issue: Which is correct? No per-issue vibe history to reference.
```

**Evidence**:
- **crank/SKILL.md Line 62-77**: Per-issue vibe creates a validation trail
- Current code has artifacts: `.agents/vibe/YYYY-MM-DD-<target>.md` per target
- Batch mode loses granularity: single report, 12 issues, no trail

**Recovery**:
- Must re-run vibe on each individual issue sequentially
- Defeats token savings completely
- Wastes 45 minutes of work

### MEDIUM: Vibe Discovers Architecture Violation Too Late

**Failure Mode**: Issue #4 violates a layer boundary, but only detected when issue #11 tries to use it. Vibe flags it as architectural debt, not a blocker.

**Result**:
- Crank completes "successfully" per FIRE loop
- Architecture violation is now merged
- Post-mortem finds it
- Creates follow-up work: MEDIUM-severity cleanup issue
- Debt compounds: future work must work around violation

---

## Question 3: Progress Visibility Without Per-Issue Vibe

### CRITICAL: Mayor Goes Blind During 12-Issue Execution

**Failure Mode**: Crank has NO INTERMEDIATE PROGRESS SIGNAL between "start crank" and "all 12 issues done".

**Current Behavior** (per-issue vibe):
```
T=0:00   Crank starts
T=0:30   Issue 1: vibe PASS (A grade)  → Mayor updates PR, sees progress
T=1:00   Issue 2: vibe PASS (A grade)  → Mayor sees 2/12 done
T=1:30   Issue 3: vibe FAIL → BLOCKER → Mayor stops crank, fixes issue
T=2:00   [Fixed] Issue 3: vibe PASS    → Resume
...
T=6:00   [ALL 12 COMPLETE] + Final Vibe → All merged
```

**Proposed Behavior** (batch vibe):
```
T=0:00   Crank starts
T=0:30   Issue 1: complete, auto-merge
T=1:00   Issue 2: complete, auto-merge
T=1:30   Issue 3: complete, auto-merge (NO VALIDATION)
T=2:00   Issue 4: complete, auto-merge (NO VALIDATION)
...
T=6:00   [ALL 12 COMPLETE, ALL MERGED]
T=6:15   Batch Vibe runs
         DISCOVERS: Issues 3,4,9 are broken
         TOO LATE - all merged to main
```

**Probability**: HIGH (execution always takes longer than expected)

**Cost**:
- All 12 issues auto-merge without validation
- Batch vibe finds issues AT T=6:15
- Issues are already in `main` branch
- Revert/rebase/cherry-pick required (git coordination)
- May break downstream users who pulled main in the interim

### HIGH: No Progress Feedback for Long-Running Epics

**Failure Mode**: User has no way to know if crank is making progress vs stalled. With per-issue vibe, each pass/fail is a heartbeat signal.

**Current Detection**:
- vibe report every 30 min = clear progress indicators
- Mayor can see: "gt-1 PASS, gt-2 PASS, gt-3 FAIL" in crank history
- User sees `.agents/vibe/2026-01-26-gt-*.md` files appearing

**Proposed Detection**:
- Nothing until T=360 when batch vibe starts
- Mayor polling only shows "12 issues in progress"
- No way to distinguish:
  - Are they actually running?
  - Did all fail?
  - Did some complete and merge?
  - Is the session hung?

**Mitigation Requires**:
- Add explicit progress reporting between issues
- Track and report completion of each issue BEFORE batch vibe
- Essentially re-adds the per-issue validation feedback loop

### MEDIUM: Monitoring and Debugging Difficulty

**Failure Mode**: When crank eventually completes and batch vibe fails, debuggability is poor:

```
Batch Vibe Report shows:
  CRITICAL: [gt-3:45] Module Z type mismatch
  CRITICAL: [gt-7:120] Undefined function X
  HIGH: [gt-12:55] Unused import Y

Mayor must:
1. Manually review each issue's commit
2. Reconstruct which edits conflicted
3. Determine if revert or fix is needed
4. No audit trail of when each issue was validated

Compare to current:
- gt-3 passed vibe at 1:00 with no type errors
- gt-7 passed vibe at 3:30 but function didn't exist yet
- Timeline shows exactly when each issue validated successfully
```

**Token Cost**: +500 tokens for manual archaeology

### MEDIUM: No Circuit Breaker for Early Termination

**Failure Mode**: If batch vibe finds CRITICAL issues at T=6:15, crank must stop. But in current code, the stop happens AT per-issue vibe failure (FIRE loop escalation).

Current:
```python
for issue in ready_issues:
    ignite(issue)                  # Run polecat
    vibe_result = vibe(issue)      # Validate immediately
    if vibe_result.critical > 0:
        escalate(issue)            # Stop here
        return                      # Exit crank
```

Proposed:
```python
for issue in ready_issues:
    ignite(issue)                  # Run polecat (no validation)
    merge(issue)                   # Auto-merge (trust it's ok)

vibe_all = vibe(all_issues)        # Validate at end
if vibe_all.critical > 0:
    # TOO LATE - all merged
    # Must do forced reverts
    for issue in failed_issues:
        revert(issue)              # Dangerous operation
```

Reverting merged issues is riskier than preventing bad merges.

---

## Summary: Severity Ratings

| Failure Mode | Severity | Likelihood | Detection Cost | Recovery Cost | Notes |
|--------------|----------|------------|----------------|---------------|-------|
| **Rate limit lockout (12 agents)** | CRITICAL | HIGH | 50 tokens | 360 min crank restart | Cascading, all agents stall simultaneously |
| **Anthropic Haiku rate limit** | CRITICAL | MEDIUM | 50 tokens | 180 min queue wait | API key level quota exhaustion |
| **Silent defect propagation (batch vibe)** | CRITICAL | HIGH | 200 tokens | 180 min revert/re-run | 4+ issues cross-contaminated, late detection |
| **GitHub API rate limit (concurrent pushes)** | HIGH | MEDIUM | 100 tokens | 120 min recovery | Abuse detection may trigger |
| **Module contamination detected late** | HIGH | MEDIUM | 150 tokens | 90 min bisect/revert | Vibe ambiguity without per-issue trail |
| **Architecture violation (not blocker)** | HIGH | LOW | 100 tokens | 60 min follow-up | Debt compounds, caught in post-mortem |
| **Mayor goes blind (no progress signals)** | HIGH | HIGH | 0 tokens | N/A | UX/observability issue, no automatic recovery |
| **Debugging difficulty (multi-issue vibe)** | MEDIUM | HIGH | 500 tokens | 120 min archaeology | Requires manual bisection and timeline reconstruction |
| **No circuit breaker (forced reverts)** | MEDIUM | MEDIUM | 100 tokens | 240 min recovery | Reverting merged code is risky operation |
| **Vibe issue scope ambiguity** | MEDIUM | HIGH | 150 tokens | 45 min re-run | Must re-validate each issue sequentially |
| **Crank hidden stall (no heartbeat)** | MEDIUM | MEDIUM | 0 tokens | 240 min (user checks in) | Session appears hung, no automatic detection |
| **Token savings never materialize** | LOW | MEDIUM | 0 tokens | Redesign | Batch validation overhead defeats savings |

---

## Failure Cascade Scenarios

### Scenario A: Rate Limit Storm → Silent Merges → Broken Main

```
T=0:00   Crank starts with 12 agents
T=0:02   All 12 agents fire API calls simultaneously
T=0:03   GitHub: 429 Too Many Requests (abuse detected)
T=0:04   Anthropic: rate-limit on 12 Haiku streams

Mayor observes:
         "Agents are running" (actually: all 429'd)

T=0:30   First poll shows no progress
T=1:00   Second poll shows no progress
T=1:30   Third poll: Crank times out waiting for agents

User experience:
         "Crank started but agents got stuck"
         (Actually: API lockout prevented any work)

T=2:00   User checks individual issue status:
         "Why are 12 issues marked in_progress with no commits?"

Fix required: Reset all issues, apply exponential backoff,
             re-run crank slowly (1-2 agents at a time)
```

### Scenario B: Early Bug in Shared Module → Cascading Failures

```
T=1:00   gt-3 "Refactor common validation logic"
         Commits change to validators.rs (shared module)
         Issue auto-merges (no per-issue vibe)

T=1:30   gt-4 "Add authentication feature"
         Depends on validation logic from validators.rs
         Uses the refactored function signature
         MISMATCH: Compile error in gt-4's context
         But polecat might not notice until later test run

T=2:00   gt-4 completes, auto-merges
         (gt-4's code compiles only in gt-4's polecat context,
          not when merged alongside gt-3)

T=5:00   gt-12 "Final integration" runs
         Uses both validators.rs and gt-4's authentication
         Code compiles locally (gt-4 was "ok" in its polecat)
         But now with gt-3's changes, broken

T=6:15   Batch vibe runs
         Discovers: all three issues broken together

Recovery: Must identify gt-3 as root cause,
          revert gt-3, revert gt-4, revert gt-12,
          then re-run gt-3 with fixes, then re-run gt-4, gt-12

Lost time: ~3 hours of crank execution becomes +3 hours recovery
```

### Scenario C: User Pulls Main While Issues Still Merging

```
T=5:45   gt-11 auto-merges to main
T=5:46   User: git pull (gets broken code from gt-3, gt-4)
T=5:47   User's local build breaks (gt-3/gt-4 incompatibility)
T=6:00   User reports build is broken
T=6:15   Batch vibe discovers the incompatibility

User experience: "Main branch is broken, why did crank merge bad code?"

Escalation: Hotfix required, or git revert, or git reset --hard
```

---

## Recommended Mitigations

### Mitigation 1: Hybrid Validation Strategy (RECOMMENDED)

Instead of "batch vibe at end", use:
- **Per-issue validation** for CRITICAL gates (compilation, tests)
- **Batch validation** for architectural review (happens in post-mortem)

```
# Current FIRE Loop
issue → compile/test vibe (REAP) → merge (RATCHET)

# Proposed Hybrid
issue → compile/test vibe (fast, CRITICAL only)
                ↓
            if pass: merge (RATCHET)
            if fail: escalate

[After all issues merge]
        → Architectural vibe (comprehensive, slower)
        → Post-mortem finds debt/violations
        → Create follow-up issues
```

**Token savings**: ~50% (per-issue fast vibe << batch comprehensive vibe)
**Risk reduction**: Catchers fires early, prevents cascades

### Mitigation 2: Rate Limit Coordination

Add to crank IGNITE phase:
```python
# Stagger agent ignition to avoid thundering herd
max_agents_per_second = 2

for issue in ready_issues:
    if agents_in_flight >= max_agents_per_second:
        sleep(1)
    gt_sling(issue)
    track_ignite_time(issue)
```

**Cost**: +30 seconds per epic (acceptable for safety)

### Mitigation 3: Progress Reporting Without Per-Issue Vibe

Add intermediate completion reporting:
```python
for issue in ready_issues:
    polecat = ignite(issue)
    wait_for_merge(polecat)        # No vibe, just wait
    report_progress(f"{completed}/{total}")  # Heartbeat signal
```

**Cost**: ~50 tokens per completion report
**Benefit**: User sees progress, can detect stalls

### Mitigation 4: Circuit Breaker for Batch Vibe

If batch vibe finds CRITICAL:
```python
# Don't revert automatically
# Instead: stop crank, create issue for each CRITICAL finding
vibe_result = vibe_all_issues()

if vibe_result.critical > 0:
    for finding in vibe_result.critical:
        bd_create(title=f"Fix: {finding}",
                 label="auto-generated-from-vibe")
    # Don't auto-revert
    # Human reviews and decides
    escalate_to_human("Batch vibe found issues. Review created tickets.")
```

---

## Conclusion

The proposed plan is **NOT SAFE** as written. It trades near-term token savings (24K → 12K) for far-term operational risk:

| Risk | Probability | Impact |
|------|-------------|--------|
| Silent defect propagation | HIGH | Lost 3+ hours |
| Rate limit lockout | HIGH | Crank restart required |
| Confusing failure modes | HIGH | User/maintainer confusion |

**Recommendation**: Adopt hybrid validation strategy (mitigations 1+3+4) to keep token savings while preventing cascades. This reduces context from 24K to ~15K (safer than 12K but still useful) while maintaining operational safety.

Token budget achievable with less risk:
- Hybrid vibe (50% savings) = ~12K tokens
- + progress reporting (minimal cost)
- + rate limit coordination (negligible cost)
- = **15K token usage** with **CRITICAL risk eliminated**
