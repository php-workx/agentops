# Integration Failure Technical Breakdown
## Deep Dive into Integration Points

**Date:** 2026-01-26
**Scope:** Technical analysis of 3 integration points for skill flattening plan

---

## Integration Point 1: Task Tool Dispatch & Concurrency

### Current Architecture
```
Skill A: /research
  ├─ Task call #1 → Explore agent (returns report)
  └─ Task call #2-5 (parallel) → 4 quality agents
      ├─ coverage-expert
      ├─ depth-expert
      ├─ gap-identifier
      └─ assumption-challenger

Skill B: /pre-mortem
  └─ Task call #1-4 (parallel) → 4 failure agents
      ├─ integration-failure-expert
      ├─ ops-failure-expert
      ├─ data-failure-expert
      └─ edge-case-hunter

Skill C: /post-mortem
  └─ Task call #1-6 (parallel) → 6 analysis agents
      ├─ plan-compliance-expert
      ├─ goal-achievement-expert
      ├─ ratchet-validator
      ├─ flywheel-feeder
      ├─ technical-learnings-expert
      └─ process-learnings-expert

Skill D: /vibe
  └─ Task call #1-2 (parallel) → 2 reviewers
      ├─ security-reviewer
      └─ code-reviewer
```

### Proposed Architecture (Issue 4)
```
Skill C: /post-mortem
  └─ Task call #1-12 (parallel) → 12 agents
      ├─ plan-compliance-expert ✓ (currently in 6)
      ├─ goal-achievement-expert ✓ (currently in 6)
      ├─ ratchet-validator ✓ (currently in 6)
      ├─ flywheel-feeder ✓ (currently in 6)
      ├─ technical-learnings-expert ✓ (currently in 6)
      ├─ process-learnings-expert ✓ (currently in 6)
      ├─ security-reviewer (NEW from vibe)
      ├─ code-reviewer (NEW from vibe)
      ├─ code-quality-expert (NEW, currently unused)
      ├─ architecture-expert (NEW, currently unused)
      ├─ security-expert (NEW, currently unused)
      └─ ux-expert (NEW, currently unused)
```

### Risk: Undocumented Concurrency Limit

**Question:** What is the maximum number of Task tool calls that can be dispatched in parallel?

**Current evidence:**
- No documentation found in plugin.json
- No documented limits in skill descriptions
- Current max tested: 6 agents (post-mortem)
- Current max ever: Unknown (possibly 4 if research is excluded)

**Unknown behavior of Task tool:**
```
IF num_agents <= limit:
  ✓ All dispatch successfully
ELSE IF num_agents > limit:
  ? Option A: Silent drop (agents 7-12 never execute)
  ? Option B: Queue sequentially (takes 2+ minutes)
  ? Option C: Timeout error (workflow breaks)
  ? Option D: Partial dispatch with warning
```

**Why this matters:**
- **Silent drop scenario:** Synthesis gets 6/12 results but expects 12
  - Missing data silences warnings (false positive: code passes when it shouldn't)
  - Findings from agents 7-12 never evaluated
  - Post-mortem report incomplete but looks complete

- **Timeout scenario:** Skill execution exceeds 2-minute limit
  - Task tool cancels remaining agents
  - Synthesis step starts with incomplete data
  - Synthesis fails (missing expected fields)

- **Sequential fallback:** Defeats the purpose
  - Flattening was supposed to speed things up
  - If queued sequentially, takes longer than nested Skill calls
  - Token budget still exhausted
  - No benefit, same cost

**How to test:**
```bash
# Hypothesis: What is the limit?
Test 1: Dispatch 8 agents (gap between current 6 and proposed 12)
Test 2: Dispatch 12 agents (the proposed number)
Test 3: Dispatch 16 agents (all unique agents in use)

Verify for each:
  - Did all agents execute? (Check output)
  - Did all agents appear in results? (Count responses)
  - Did any timeout? (Check timestamps)
  - What was actual execution time? (Measure)
```

---

## Integration Point 2: Token Budget Management

### Current Session Token Flow

**Baseline context (before any work):**
```
- Plugin.json + agent configs: ~2k tokens
- Skill definitions loaded into context: ~15k tokens
- Claude Code system context: ~10k tokens
- User's .CLAUDE.md file: ~8k tokens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Running total: ~35k tokens (65% of budget remaining)
```

### Post-Mortem Execution Token Budget

**Step 1-2: Load and read inputs**
```
- Epic details (beads show <epic-id>): 500 tokens
- Vibe report (.agents/vibe/*.md): 3k tokens
- Recent git commits: 2k tokens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Subtotal: 5.5k tokens
Running total: 40.5k tokens
```

**Step 3: Run vibe (nested Skill call)**
```
- Tool: Skill invocation overhead: 500 tokens
- Skill execution (see vibe analysis): 25k tokens
- Result: Full vibe report: 3k tokens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Subtotal: 28.5k tokens
Running total: 69k tokens
```

**Step 4: Dispatch 6 agents (CURRENT)**
```
Per agent (×6):
  - Agent prompt + epic context: 1.5k tokens
  - Agent execution: 1k tokens
  - Agent response: 1k tokens
  Subtotal per agent: 3.5k

Total (6 agents): 21k tokens
Running total: 90k tokens
```

**Step 4: Dispatch 12 agents (PROPOSED)**
```
Per agent (×12):
  - Agent prompt + epic context: 3k tokens (more context needed)
  - Agent execution: 1k tokens
  - Agent response: 2k tokens (more complex findings)
  Subtotal per agent: 6k

Total (12 agents): 72k tokens
Running total: 141.5k tokens ⚠️ (71% of budget)
```

**Step 5: Synthesis and Report Writing**
```
- Read all 12 agent responses: 24k tokens (scan all findings)
- Merge/de-duplicate: 10k tokens (find conflicts)
- Write report: 5k tokens (structure findings)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Subtotal: 39k tokens
Running total: 180.5k tokens ⚠️⚠️ (90% of budget!)
```

**Step 6: Index knowledge (ao forge)**
```
- Index command + metadata: 2k tokens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Final total: 182.5k tokens (91% of budget)
```

**Remaining budget: 17.5k tokens**

### Post-Mortem Completes, User Requests Next Skill

```
User: "Now run /implement gt-1 to fix the CRITICAL finding"

Next skill execution needs:
  - Tool invocation: 500 tokens
  - Issue context: 2k tokens
  - File exploration: 15k tokens (reading codebase)
  - Actual implementation: 5k tokens
  - Commit + report: 2k tokens
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total needed: 24.5k tokens

Available: 17.5k tokens
Deficit: -7k tokens ❌

Result: Context window exceeded error
```

### Token Explosion Scenario

If user asks for research on the vibe findings:

```
User: "/research why does code have so many CRITICAL issues?"

[Inside research skill]
- Gather context: 3k tokens
- Dispatch Explore agent: 1k tokens
- Explore reads 20 files: 30k tokens (copying file contents)
- 4 quality agents: 12k tokens (each needs code context)
- Synthesis: 5k tokens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Research subtotal: 51k tokens

Available: 17.5k tokens
Deficit: -33.5k tokens ❌❌

Result: Immediate context window exceeded
```

### Mitigation Strategies

**Option 1: Token tracking**
```
At start of post-mortem:
  current_tokens = get_token_usage()
  budget_remaining = 200k - current_tokens

  IF budget_remaining < 100k:
    abort_with_message("Session too full, restart and try again")

During post-mortem:
  FOR each agent in 12_agents:
    IF current_tokens > 150k:
      skip_remaining_agents()
      synthesize_partial_results()
      break
```

**Option 2: Selective dispatch**
```
Instead of 12 agents always:
  available_budget = 200k - current_tokens
  max_agents = available_budget / 6k_per_agent

  dispatch(min(12, max_agents))
```

**Option 3: Agent consolidation**
```
Instead of 12 specialized agents:
  Use 3-4 multi-role agents
  - Agent A: Plan compliance + goal achievement
  - Agent B: Ratchet + flywheel + learnings
  - Agent C: Security + architecture review

  Results: 9k tokens instead of 72k
```

**Option 4: Separate session for synthesis**
```
Post-mortem Step 4: Dispatch 12 agents, save raw responses
Post-mortem Step 5: Tell user "synthesis will happen in new session"
  [User starts new session]
  Synthesis: Load saved responses, merge, write report

  Result: Separate token budgets (no overflow)
```

---

## Integration Point 3: Result Synthesis & Conflict Resolution

### The Synthesis Problem

**What synthesis must do:**

1. **Input:** 12 agent responses with potentially conflicting findings
2. **Process:** Normalize, de-duplicate, prioritize, merge
3. **Output:** Single coherent post-mortem report with findings, grade, recommendations

**Why it's hard with 12 agents:**

Each agent uses different format and severity scale:

```
Agent A (plan-compliance-expert):
  Format: Structured table
  Findings: "5 deviations from plan"
  Severity: Binary (pass/fail)

Agent B (goal-achievement-expert):
  Format: Prose narrative
  Findings: "Goal was 90% achieved, blocked by X"
  Severity: Percentage (0-100%)

Agent C (security-reviewer):
  Format: Bullet list
  Findings: "3 CRITICAL, 2 HIGH, 4 MEDIUM issues"
  Severity: Ordinal (CRITICAL > HIGH > MEDIUM > LOW)

Agent D (technical-learnings-expert):
  Format: Structured learnings with confidence scores
  Findings: "L1: High conf, L2: Medium conf, L3: Low conf"
  Severity: Custom (learnings, not issues)

... [8 more agents, 8 different formats] ...
```

### Conflict Detection Examples

**Conflict #1: Security assessment disagreement**
```
Agent 7 (code-reviewer):
  "No security issues found. Code is safe."

Agent 8 (security-reviewer):
  "XSS vulnerability on line 42. CRITICAL."

Which is correct?
  Option A: Trust security-reviewer (more specialized)
  Option B: They both analyzed same code, different answers
  Option C: Code-reviewer missed it, security-reviewer correct
  Option D: Security-reviewer too strict (false positive)

Synthesis question: How to merge?
  - Take max severity? (Report CRITICAL)
  - Investigate conflict? (Need to read code again, tokens!)
  - Ask user? (Breaks autonomous execution)
  - Discard one? (Which one?)
```

**Conflict #2: Grade disagreement**
```
Agent 1 (plan-compliance-expert):
  "90% plan compliance, excellent"
  Implies: Grade A or B

Agent 2 (goal-achievement-expert):
  "Only 50% of user's actual problem solved"
  Implies: Grade C or D

Both measured different things. How to combine?
  Average: (A + D) / 2 = B or C (correct? unknown)
  Weighted: 60% compliance + 40% goal = ? (weights made up)
  Conflict: Report both and confuse user?
  Both valid: "Followed plan well but missed goal"
```

**Conflict #3: Performance assessment variance**
```
Agent 5 (code-quality-expert):
  "Performance is fine, no bottlenecks found"
  Confidence: Medium (only ran tests, didn't profile)

Agent 9 (architecture-expert):
  "O(n²) algorithm will fail at scale"
  Confidence: High (knew to look for this pattern)

Both correct, different scopes. How to weight confidence?
  Confidence A: 60%, Confidence B: 90%
  Weighted: 0.4×pass + 0.9×fail = ? (90% weight to architecture)
  Result: Final grade weighted heavily by one agent?
```

### Current Synthesis Algorithm (Inferred from Code)

Post-mortem/SKILL.md Step 6 (report writing) assumes:

```
1. Read 6 agent responses (ordered: compliance, goal, ratchet, learnings×2, process)
2. Extract key findings from each agent
3. Write report sections based on agent order
4. Group findings into "What Went Well" and "What Could Be Improved"
5. Combine learnings from both learning experts
6. Pick overall grade based on... (implicit, not documented)
```

**Algorithm for grade:**
- If any CRITICAL issues from any agent: Grade ≤ D
- If 3+ HIGH issues: Grade ≤ C
- If compliance <80%: Grade ≤ B
- Else: Grade A or B

**Implicit assumptions:**
- Each agent finds non-overlapping issues (no conflicts)
- Grade is combination of findings (not formalized)
- Conflicts are resolved by section order (first agent wins)

### Proposed 12-Agent Synthesis Algorithm (MISSING)

For 12 agents, need explicit algorithm:

**Option 1: Weighted Voting**
```
For each finding severity (CRITICAL, HIGH, MEDIUM, LOW):
  Count agents reporting this severity
  Weight by agent confidence (if provided)

  Example:
    Security issue: 3 agents say CRITICAL, 1 says HIGH
    Weight: 3×0.9 + 1×0.5 = 3.2
    Result: Report as CRITICAL (3.2 > threshold)

  Grade: Sum all weighted findings, map to grade scale

  Problem: Weights not provided by agents
  Solution: Hard-code weights (0.9=high conf, 0.5=medium, etc.)
           But which agents are which confidence?
```

**Option 2: Consensus-Based**
```
For each finding:
  If >50% of agents agree: Report it
  Else: Mark as "agent disagreement"

  Example:
    Security: 6 agents say issue, 6 agents say no issue
    Result: Report as "Security assessment conflicted"

  Problem: With 12 agents, can have 7-5 split (not consensus)
  Solution: Require 75% agreement threshold?
           But what severity to report?
```

**Option 3: Veto Power**
```
For each aspect (security, quality, architecture...):
  One expert agent (veto power)
  Other agents provide supporting views

  Example:
    Security-reviewer says CRITICAL: Project BLOCKED
    (Other agents' opinions secondary)

  Problem: Not defined which agent has veto for which aspect
  Solution: Explicit mapping (security-reviewer → security, etc.)
           But what if agent missing or doesn't find issue?
```

**Option 4: Conservative (Max Severity)**
```
For each issue:
  Take the maximum severity reported by any agent

  Example:
    Agent A says "LOW", Agent B says "CRITICAL"
    Result: Report as CRITICAL

  Pros: Conservative, safe
  Cons: Encourages false alarms
         Grade artificially low (too strict)
         User over-fixes things
```

**Option 5: Permissive (Min Severity)**
```
For each issue:
  Take the minimum severity reported by any agent

  Example:
    Agent A says "CRITICAL", Agent B says "LOW"
    Result: Report as LOW (or don't report at all)

  Pros: Optimistic, achieves goals faster
  Cons: Misses real issues
         False negatives
         Bad code merges
```

### None of These Are Documented

**Current code (post-mortem/SKILL.md) says:**
```
### Step 5: Synthesize Findings

After the Explore agent and validation swarm return, write findings to:
`.agents/research/YYYY-MM-DD-<topic-slug>.md`
```

**For post-mortem, there's NO equivalent synthesis algorithm.** It says:

```
### Step 4: Dispatch Post-Mortem Validation Swarm
...
**Wait for all 6 agents to return, then synthesize into unified report.**

### Step 6: Write Post-Mortem Report
**Write to:** `.agents/retros/YYYY-MM-DD-post-mortem-<topic>.md`
```

The word "synthesize" appears but no algorithm is documented. With 6 agents, this was okay (implicit, manual process). With 12 agents, it breaks down.

---

## Why Current Architecture Works (6 Agents)

**Separation of concerns:**
- plan-compliance-expert: Answers "Did we follow the plan?"
- goal-achievement-expert: Answers "Did we solve the problem?"
- ratchet-validator: Answers "Are gates locked?"
- flywheel-feeder: Answers "What learnings were extracted?"
- technical-learnings-expert: Answers "What technical insights?"
- process-learnings-expert: Answers "What process insights?"

**No conflicts because:**
- Each agent is responsible for a different dimension
- Findings are orthogonal (not overlapping)
- No agent contradicts another
- All findings fit naturally into report sections

**Synthesis is easy:**
- Read agent 1's findings → "Plan Compliance" section
- Read agent 2's findings → "Goal Achievement" section
- Read agents 3-6's findings → "Findings" section
- Write report using findings in order

---

## Why Proposed Architecture Breaks (12 Agents)

**Overlap and conflicts:**
- security-reviewer + code-reviewer + security-expert all assess security
- code-reviewer + code-quality-expert + architecture-expert all assess quality
- ux-expert is orthogonal but lonely
- All 12 agents might report same issue with different severity

**Synthesis is hard:**
- Agent A: "Security issue X is HIGH"
- Agent B: "Security issue X is LOW"
- Agent C: "Security issue X doesn't exist"
- Which answer is correct?

**Report sections unclear:**
- Current template doesn't have 12 slots
- Can't fit 12 different agent outputs
- Must either compress (lose detail) or extend (overwhelming report)

---

## Summary: The Three Integration Failures

| Integration Point | Current (6 agents) | Proposed (12 agents) | Failure Type |
|---|---|---|---|
| **Task Dispatch** | Tested, 6 agents work | Untested, unknown limit | Concurrency crash |
| **Token Budget** | ~90k tokens used | ~182k tokens (91% of budget) | Context overflow |
| **Synthesis** | Orthogonal findings, easy merge | Overlapping findings, conflicts | Merge algorithm missing |

All three would need to be solved to make flattening safe.

