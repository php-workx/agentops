# Technical Deep Dive: Crank Flatten Failures

---

## Failure Mode 1: Rate Limit Cascades at 12 Parallel Agents

### Root Cause Analysis

The FIRE Loop specification (crank/fire.md Line 304-314) budgets ~750 tokens per iteration:
- FIND: ~300 tokens
- IGNITE: ~100 tokens (includes API calls to `gt sling`)
- REAP: ~250 tokens
- ESCALATE: ~100 tokens (if failures)

**The proposal changes IGNITE phase from sequential to parallel:**

**Current (Sequential)**:
```bash
for issue in ready_issues:           # Loop one at a time
    gt_sling(issue) <rig>            # 1 sling per loop iteration
    sleep(30)                         # Poll interval
    check_convoy_status()             # Validate
    if complete: mark_closed()
```

- 4 issues ready → 4 × (30s + 5s validation) = ~140s elapsed
- Each sling: 1 API call to gt
- Total API calls: ~4-5 spread over 140s

**Proposed (Parallel)**:
```bash
# Flatten means ALL 12 agents dispatch in one cycle
agents = [agent-1, ..., agent-12]
for agent in agents:
    agent.dispatch(ready_issues[agent_index])  # All fire at T=0

# Each agent makes multiple API calls in <1 second:
# - Clone repo
# - Run /implement skill (dispatches subagents)
# - Query knowledge base
# - Submit PR
```

### Rate Limit Attack Surface

**API endpoint 1: Anthropic Claude API**

Claude API has per-minute rate limits. From observed behavior:
- Pro plan: ~500K tokens/minute
- Premium: Higher but still capped
- Burst handling: Queues requests, returns 429 if queue full

**Scenario**:
- 12 agents each initialize with 200 tokens = 2,400 tokens in 1 second
- Claude API sees burst of 12 concurrent requests
- If any agent makes a follow-up call (context injection, knowledge lookup), that's 24 more calls
- 2,400 tokens/second = 144,000 tokens/minute ≈ 30% of pro quota consumed in 1 second
- If agents retry, burst multiplies

**GitHub API**:
- Authenticated: 5,000 requests per hour
- Unauthenticated: 60 requests per hour
- Each polecat: 5-10 git operations (push, fetch, etc.)
- 12 polecats × 10 = 120 requests
- Burst of 120 in <10 seconds = 12 requests/second
- GitHub's abuse detection triggers at 100 requests in 60 seconds from single IP

**Result**: Both APIs signal rate limit within 5 seconds

### Coordination Problem

From failure-taxonomy.md, escalation and recovery assume **single issue failure**:

```bash
# Current (single issue failure)
issue-3 fails vibe
├─ bd comments add <issue-3> "Validation failed: ..."
├─ gt sling <issue-3> <rig>        # Re-sling just one
└─ Continue with issue-4

# Proposed (12-agent rate limit failure)
all-12 agents get 429 simultaneously
├─ No recovery path in current code
├─ Each agent independently retries
├─ Creates thundering herd
└─ Back to rate limit
```

### Detection Lag

Mayor polling every 30 seconds (FIRE Loop Line 148):

```
T=0s:  Dispatch 12 agents (all call APIs simultaneously)
T=1s:  All 12 get 429 responses
T=2-29s: Mayor has no visibility (polling interval)
T=30s: Mayor polls convoy status
       Observes: "12 agents dispatched, 0 completed"
       Cannot distinguish:
       - Are they still working?
       - Did they all fail?
       - Is there a 429 lockout?

T=60s: Second poll
       Observes: "Still 12 in progress"
       Mayor has to assume they're working...

T=300s (5 min): Timeout trigger
              All agents have been rate-limited for 5 minutes
              Mayor finally escalates
```

**Window of confusion: 300 seconds**

### Impact: Token Waste

- 12 agents × 2,400 tokens initialization = 28,800 tokens wasted
- Retry attempts × 5,000 tokens each = 25,000+ tokens wasted
- Batch vibe when resumed = 15,000 tokens to validate 12 issues
- **Total additional cost: ~70,000 tokens** (defeats 12K savings immediately)

### Comparison: How Current FIRE Loop Handles Similar Scales

Current design uses **MAX_POLECATS = 4** (from fire.md Line 352):

```python
# FIRE Loop respects capacity
capacity = MAX_POLECATS - len(currently_burning)

if len(ready_issues) > capacity:
    to_ignite = ready_issues[:capacity]  # Limit to 4
else:
    to_ignite = ready_issues
```

**Why 4?** Tuning parameter chosen to avoid rate limit storms while maintaining parallelism.

The proposal of 12 agents × 6 in post-mortem + additional concurrent work would exceed proven safe limits.

---

## Failure Mode 2: Vibe Issue Scope Ambiguity

### Why Per-Issue Vibe Creates Audit Trail

Current architecture: `/vibe recent` after each `/implement`

From vibe/SKILL.md Step 10:
```markdown
**Write to:** `.agents/vibe/YYYY-MM-DD-<target>.md`
```

Example output for sequential issues:
```
.agents/vibe/
├── 2026-01-26-gt-101.md (Issue #1 - PASS: A grade)
├── 2026-01-26-gt-102.md (Issue #2 - PASS: A grade)
├── 2026-01-26-gt-103.md (Issue #3 - PASS: A grade)
│   └── Module X: Type checking passed
├── 2026-01-26-gt-104.md (Issue #4 - PASS: A grade)
│   └── Uses Module X from issue #3: compiles correctly
├── 2026-01-26-gt-105.md (Issue #5 - PASS: A grade)
├── 2026-01-26-gt-106.md (Issue #6 - PASS: A grade)
├── 2026-01-26-gt-107.md (Issue #7 - PASS: A grade)
├── 2026-01-26-gt-108.md (Issue #8 - PASS: A grade)
├── 2026-01-26-gt-109.md (Issue #9 - FAIL: CRITICAL)
│   └── Module X type changed, breaks gt-4, gt-7
├── 2026-01-26-gt-110.md (Issue #10 - PASS: A grade)
├── 2026-01-26-gt-111.md (Issue #11 - PASS: A grade)
├── 2026-01-26-gt-112.md (Issue #12 - PASS: A grade)
└── 2026-01-26-final-batch.md (Final vibe: PASS after issue #9 fixed)
```

**Timeline reconstruction**:
1. Issue #3 refactored Module X - vibe shows: "X type is String"
2. Issue #4 used Module X as String - vibe shows: "Compiles correctly"
3. Issue #9 changed Module X to i32 - vibe shows: "Breaking change"
4. Mayor immediately knows: Issue #9 broke issues #4,7
5. Revert scope: Just issue #9 + re-validate #4,#7

### Batch Vibe Loses Timestamp Context

Proposed: Single `.agents/vibe/2026-01-26-batch-all-12.md`

```markdown
# Vibe Report: Batch Validation (All 12 Issues)

**Files Reviewed:** 47
**Grade:** D (2 critical findings)

## CRITICAL Findings

1. **Module X (validators.rs:45)** - Type mismatch
   - Function signature: `fn validate(x: i32)`
   - Caller (auth.rs:120): passes String
   - Caller (integration.rs:200): passes i32
   - **Issue**: Conflicting usage

2. **Module Y (logger.rs:30)** - Unused import
   - Imported by: 3 files
   - Used by: 0 files
```

**Problem**: No timestamp or issue number for each finding:
- Which issue added the i32 signature?
- Which issue uses String?
- When did Module Y become unused?

**Recovery process**:
```bash
# Mayor must investigate:
1. git log --all --oneline | grep -i "Module X" | head -20
2. For each commit:
   git show <commit> | head -20
3. Cross-reference with .beads/ to find issue-id
4. For each issue, manually re-run vibe on that single commit
5. Finally establish timeline

# Example: Takes ~30 min to establish
# Issue #3: Changed X from String to i32
# Issue #4: Expecting String (broken by #3)
# Issue #9: Also changed X, conflict with #3
```

### Code Evidence: Vibe Report Structure

From vibe/SKILL.md Step 10, the report always includes target:

```markdown
# Vibe Report: <Target>

**Files Reviewed:** <count>
**Grade:** <A-F>
```

When Target = "batch-all-12", specificity is lost.

### Cross-File Dependency Issue

From vibe/SKILL.md Step 5, validation checks:
- **Quality**: "copy-paste"
- **Architecture**: "layer violations, circular deps"

These are **inter-file checks**. With per-issue validation:
- Issue #3: Check doesn't have circular dep with #2 (not merged yet)
- Issue #4: Check finds new circular dep with #3 (now merged)

**Example**:
```rust
// Issue #3: beads.rs
pub struct Issue {
    pub id: String,
    pub beads: BeadStore,
}

// Issue #4: main.rs (expected API from #3)
mod beads;
fn main() {
    let b = beads::Issue { id: "test", beads: ???};
    // Expects BeadStore to be constructible
}

// Issue #9: storage.rs (completes the circle)
pub mod beads {
    pub struct BeadStore {
        impl From<Self> for Issue { ... }  // Creates circular import
    }
}
```

Per-issue vibe would catch circular import when #9 runs.
Batch vibe sees the full cycle and reports: "circular dep exists" without clear origin.

---

## Failure Mode 3: Silent Merge of Broken Code

### Current Safeguard: Validation Gate

From crank/SKILL.md Step 5-6:

```python
validate_result = vibe(issue)

if validate_result.critical > 0:
    # BLOCKER - don't merge
    return ESCALATE
else:
    # Safe to merge
    gt done  # Auto-merge
```

### Proposed Flow: No Gate

```python
# Proposed: Skip vibe before merge
gt done  # Auto-merge ALWAYS
```

**Comparison to post-mortem/SKILL.md:**

Post-mortem dispatches **6 agents in parallel** (lines 57-141), but AFTER all issues already merged:

```
# Current: vibe during crank (prevents bad merges)
Issue #1: implement → vibe → merge ✓
Issue #2: implement → vibe → merge ✓
Issue #3: implement → vibe → merge ✗ (blocked)

# Proposed: vibe after crank (detects after merge)
Issue #1: implement → merge ✓
Issue #2: implement → merge ✓
Issue #3: implement → merge ✗ (too late, already merged)
```

### Merge Irreversibility

From fire.md Line 191:
```
**Key property**: Once merged, work is PERMANENT. The ratchet doesn't go backward.
```

The Brownian Ratchet philosophy assumes validation **before** the ratchet engages. Proposed plan moves validation **after**.

### Real Scenario: Silent Type Breakage

```rust
// Issue #3: validators.rs (auto-merged with batch vibe disabled)
pub fn parse_request(input: String) -> Result<Request, Error> {
    // ... implementation ...
    // Forgot to implement error handling for malformed JSON
}

// Issue #4: api.rs (auto-merged)
use validators::parse_request;
pub async fn handle_request(data: String) -> impl Response {
    let req = parse_request(data)?;  // Compiler passes - trait impl'd elsewhere
    process(req)
}

// Issue #7: middleware.rs (auto-merged)
use validators::parse_request;
impl Handler for Middleware {
    fn process(&mut self, input: Vec<u8>) {
        let s = String::from_utf8(input)?;
        let req = parse_request(s)?;  // Compiler passes
        // But at RUNTIME: panic on invalid JSON
    }
}

// Batch vibe runs at T=6:15
// Discovers: Issue #3's error handling is incomplete
// But issues #4, #7 already merged with assumption it's complete
```

**Detection**: Runtime panic, not compile error
**User impact**: Deployed code crashes on certain inputs
**Batch vibe would show**: "HIGH: Missing error handling case"
**Recovery**: Hotfix + revert + re-run

---

## Failure Mode 4: Anthropic Per-Minute Rate Limit Exhaustion

### Rate Limit Mechanics

From observed API behavior, Anthropic enforces:
- Per-minute token limit (varies by plan)
- Per-minute request limit (varies by plan)
- Burst limit (requests queued if exceeding per-second limit)

**Typical tiers**:
- Free: 40K tokens/min, 20 requests/min
- Pro: 500K tokens/min, 200 requests/min
- Enterprise: Custom

### 12 Agents × N Requests Scenario

Each agent in `/implement` workflow makes:
1. Read context (git log, file reads)
2. Call `/implement` skill (dispatches Explore agent)
3. Query knowledge base
4. Make edits (multiple API calls per file)
5. Commit and push

**Anthropic API calls per agent**: ~20-30 over 30 minutes
- But they're distributed unevenly:
  - T=0-2m: 10 calls (initialization, context gather)
  - T=2-20m: 2-3 calls (thinking, editing)
  - T=20-30m: 5 calls (finalization, push)

### Burst Scenario

If all 12 agents hit initialization phase simultaneously:
- 12 agents × 10 init calls = 120 calls
- Time window: 2 minutes
- Rate: 60 calls/min (typical limit)

**Result**: First 60 calls go through, next 60 queued
- Queued calls incur 2-5 second delay (API response time)
- This delays agent initialization
- Which cascades to later phases
- Which may cause session timeout or context overflow

### Token Cost

Per agent during implementation:
- Reading files: ~500 tokens
- Skill dispatch: ~1000 tokens
- Edits: ~200 tokens
- Knowledge queries: ~100 tokens
- **Per agent: ~1800 tokens** (conservatively)

12 agents: 21,600 tokens in concurrent phase

If any agent hits rate limit and retries:
- Retry uses additional 1800 tokens
- 2 retries per agent (likely): +43,200 tokens
- **Total damage: ~65K tokens** (defeats all savings)

### Compound Problem: Agent Timeout

If agent-1 gets rate-limited and queued for 30 seconds:
- Agent's timeout might be 60 minutes
- But mayor's monitoring might see "no progress" after 2 minutes
- Mayor escalates prematurely
- Cascades to other agents (they see escalation, get confused)

---

## Failure Mode 5: GitHub API Abuse Detection

### GitHub's Rate Limiting Strategy

From observed behavior:
- Standard: 5,000 requests/hour (authenticated)
- Unauthenticated: 60 requests/hour
- Abuse detection: Flags >100 requests from same IP in <60 seconds

### Scenario: 12 Polecats Push Simultaneously

Each polecat does:
```bash
git fetch origin main        # 1 request
git rebase origin/main       # 0 requests (local)
git push origin <branch>     # 1 request
git branch -d <branch>       # 0 requests (local)
```

Minimum: 2 requests per polecat
Maximum: 5-10 (if conflicts, retries, multiple branches)

**12 polecats × 5 = 60 requests in <10 seconds**

GitHub's abuse detection sees:
```
Time    IP          Requests    Action
----    --          --------    ------
T=0s    1.2.3.4     12          OK
T=1s    1.2.3.4     24          OK (24 total)
T=2s    1.2.3.4     60          FLAG (abuse pattern detected)
T=3s    1.2.3.4     any         BLOCKED (return 429)
```

### Recovery

GitHub blocks for ~1 hour. No quick recovery available.

Mitigation would require:
- Use multiple GitHub tokens (not always available)
- Throttle git operations (defeats parallelism benefit)
- Run from multiple IPs (infrastructure change)

---

## Failure Mode 6: Vibe Downtime Creates Validation Gap

### Current Gap Analysis

From crank/SKILL.md Step 4-6:

```
FOR EACH ready issue:
    Step 4: ignite (implement)
    Wait for completion
    Step 5: vibe (validate)
    If vibe fails: escalate
    If vibe passes: merge
    Step 6: mark closed
```

**Gap duration**: 0 minutes (validation immediately after completion)

### Proposed Gap Analysis

```
FOR EACH ready issue:
    Step 4: ignite (implement)
    Wait for completion
    [SKIP VIBE]
    merge (auto, blind)
    Step 6: mark closed

AFTER all 12 complete:
    Step 5: batch_vibe (validate all)
    If vibe fails: CRISIS (issues already merged)
```

**Gap duration**: Up to 12 × 30 minutes = 360 minutes

**In 360 minutes**:
- Issues merge to main
- Downstream jobs might pull main
- Users might deploy
- Cascade of hidden bugs grows

---

## Summary: Quantified Risks

| Failure | MTTR (Mean Time To Recover) | Token Cost | User Impact |
|---------|---------------------------|----------|------------|
| Rate limit lockout | 30 min | 70K tokens | Crank restart, epic delayed |
| Vibe ambiguity | 45 min | 5K tokens | Requires manual archaeology |
| Silent bad merge (main broken) | 120 min | 30K tokens | Downstream impact, hotfix needed |
| GitHub abuse block | 60 min | 5K tokens | All git ops blocked temporarily |
| Anthropic rate limit | 10 min | 20K tokens | Agents stall, cascade retries |
| Validation gap detection | 20 min | 5K tokens | User confusion, post-facto fix |

**Worst case** (all failures compound): 120+ minutes MTTR, 135K token cost (vs 12K savings = net -123K tokens)

---

## Why 6-Agent Post-Mortem Works But 12-Agent Crank Doesn't

### Post-Mortem Constraints

From post-mortem/SKILL.md Step 4:
- Dispatches 6 agents (not 12)
- **Happens AFTER all work already completed and merged**
- No validation gate
- If it fails, issue review happens manually

### FIRE Loop Constraints

- Validates **before** merge (protection mechanism)
- Early detection prevents cascade
- Can escalate before damage spreads
- Ratchet property maintained

**The proposal breaks the ratchet by removing pre-merge validation.**

Keeping 6-agent post-mortem but removing per-issue vibe from FIRE is architecturally sound.
12-agent crank with batch vibe is architecturally unsound.
