# Pre-Mortem: Flatten Skill Nesting to Reduce Context Explosion

**Date:** 2026-01-26
**Spec:** Flatten skill nesting - reduce 6 agents to 2 in vibe, consolidate 12 agents in post-mortem one-shot
**Simulation Type:** Integration failure expert analysis

---

## Summary

This plan aims to reduce context explosion by:
1. **Vibe**: Dispatch 2 agents instead of current 6 (security-reviewer + code-reviewer only)
2. **Post-Mortem**: Launch 12 agents in ONE parallel swarm instead of nested Skill calls
3. **Crank**: Batch vibe validation at end instead of after each issue

The three major integration points are:
- Skill tool dispatching Task tool for agent calls
- Agent registration in plugin.json (20 agents available)
- Synthesis of multi-agent results into cohesive reports

This analysis simulates what breaks when the plan is implemented.

---

## Integration Points Analyzed

### POINT 1: Task Tool Concurrency Limits
**Current state:** Research (4 agents), Pre-mortem (4 agents), Post-mortem (6 agents) launched sequentially
**Proposed state:** Post-mortem launches 12 agents in ONE message

**Risk vector:** Parallel dispatch hitting undocumented concurrency limits in Claude Code's Task tool

### POINT 2: Agent Registration Gaps
**Current state:** plugin.json loads agents/ directory dynamically
**Proposed state:** All 20 agents must be available and registered

**Risk vector:** Missing agent definitions, naming mismatches, incomplete registration

### POINT 3: Result Synthesis
**Current state:** 2-4 agents at a time = manageable token budgets
**Proposed state:** 12 agents returning data simultaneously = massive context burden

**Risk vector:** Token explosion, conflicting findings, synthesis paralysis

---

## CRITICAL Findings (Will Definitely Fail)

### CRITICAL-1: Task Tool Concurrency Limit Not Documented
**Severity:** CRITICAL
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
- POST-MORTEM attempts to launch 12 Task tool calls in one message
- Haiku model has ~200k token budget for this session
- 12 parallel agent prompts = 12 × 1500 tokens = 18k tokens input
- Without documented limits, Task tool either:
  - Silently drops agents 7-12 (partial execution, bad data)
  - Queues them sequentially (defeats the purpose)
  - Returns timeout error (workflow breaks)

**Evidence:**
- plugin.json shows 20 agents available, no concurrency cap documented
- post-mortem/SKILL.md Step 4 says "Launch ALL SIX agents in parallel" - this is current state with 6 agents
- Current implementation uses nested Skill calls (sequential) to avoid this exact problem

**Code location:**
```
skills/post-mortem/SKILL.md:56-139 (Step 4 dispatch)
.claude-plugin/plugin.json:24-25 (agent loading)
```

**Failure mode:**
```
[Step 4 begins] Launch 12 agents...
[Agent 1-8] Dispatched ✓
[Agent 9-12] Task tool drops silently OR queues (unknown behavior)
[Step 4 waits] Timeout after 2 minutes
[Workflow stuck] Synthesis step has partial data, wrong findings
```

**Why it will fail:** No concurrency limit documented, untested at 12x scale. Current sequential approach exists for a reason.

---

### CRITICAL-2: 12-Agent Dispatch Requires >200k Context Window
**Severity:** CRITICAL
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
1. Post-mortem collects epic details, vibe results, retro results = ~5k tokens
2. Dispatch 12 agents with copy of this context = 12 × 5k = 60k tokens
3. Synthesis step combines 12 agent responses = 12 × 2k = 24k tokens
4. Total context usage: ~89k tokens (manageable)

BUT: If any agent needs to understand code:
- Copy full code snippets × 12 agents = context explosion
- Example: 50 files × 12 agents = 600 file reads in single message
- Token budget explodes to >200k

**Evidence:**
- vibe/SKILL.md shows agents need file context to validate
- post-mortem agents reference .agents/vibe/*.md, recent git commits
- Haiku has ~200k budget, session already has other context

**Failure mode:**
```
[Synthesis step] Begin with 150k tokens already used
[Loading 12 agent responses] +30k tokens
[Adding code context] +50k tokens (for some agents)
[Total] 230k tokens - EXCEEDS BUDGET
=> Context window exceeded error
=> Synthesis impossible
=> Report incomplete
```

**Why it will fail:** Token explosion is multiplicative, not additive. 12 agents × context sharing = exponential growth.

---

### CRITICAL-3: Agent Results Synthesis Creates Logical Conflicts
**Severity:** CRITICAL
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
12 agents returning simultaneously with DIFFERENT findings on same code:

1. **Code-Quality-Expert**: "5 HIGH issues found"
2. **Code-Reviewer**: "2 HIGH issues found"
3. **Security-Reviewer**: "3 CRITICAL security issues found"
4. **Architecture-Expert**: "No architecture issues"
5. **Edge-Case-Hunter**: "12 edge cases found"
6. ... etc

**Conflicts:**
- Which finding is correct? Different agents, different criteria
- Code smell: Agent A says "dead code", Agent B says "valid future hook"
- Security: Agent A says "XSS risk", Agent B says "input validated earlier"

**Synthesis paralysis:**
- How do you merge "5 HIGH" + "2 HIGH" + "3 CRITICAL" + "0 issues"?
- Average? Max? Consensus?
- Current post-mortem assumes 6 specific agents return compatible findings

**Evidence:**
- post-mortem/SKILL.md:62-129 shows each agent does DIFFERENT validation
- Current workflow uses agents with complementary (not overlapping) purposes
- No synthesis algorithm documented for conflicting findings

**Code location:**
```
skills/post-mortem/SKILL.md:141
"Wait for all 6 agents to return, then synthesize into unified report."
^^ No algorithm for merging conflicting data
```

**Failure mode:**
```
[Agent A returns] "5 HIGH issues"
[Agent B returns] "0 issues"
[Agent C returns] "2 CRITICAL issues"
[Synthesis attempt]
  IF take max severity: Grade = F (too strict)
  IF take minimum severity: Grade = A (too lenient)
  IF weighted average: Grade = ? (undefined weights)
=> Report either wrong or impossible to write
=> User gets false confidence (low grade) or false alarm (high grade)
```

**Why it will fail:** No defined merge strategy for conflicting agent findings. Current sequential approach prevents conflicts by running agents at different lifecycle stages.

---

## HIGH Findings (Likely to Cause Problems)

### HIGH-1: Vibe Dispatch from Post-Mortem Loses Context
**Severity:** HIGH
**Affected:** Issue 1 (vibe reduces from 6 to 2 agents)

**What will happen:**
Current post-mortem calls `/vibe` as a Skill (Step 2):
```
Tool: Skill
Parameters:
  skill: "agentops:vibe"
  args: "recent"
```

This runs vibe FULL (with all validation aspects).

Proposed change: vibe only dispatches 2 agents (security-reviewer + code-reviewer)
- Other 6 validation aspects (semantic, quality, architecture, complexity, performance, slop) SKIPPED
- Post-mortem assumes full vibe report exists
- Post-mortem Step 3 reads ".agents/vibe/*.md" findings

**Problem:**
- Vibe writes report but with INCOMPLETE findings
- Post-mortem reads incomplete findings
- Post-mortem synthesis uses bad data
- Grade might be artificially high (missed issues in non-dispatched aspects)

**Evidence:**
- vibe/SKILL.md:72-85 shows 8 aspects to validate
- Reducing to 2 agents = skipping 6/8 aspects
- post-mortem/SKILL.md:163-170 assumes full vibe results

**Failure mode:**
```
[Vibe runs with 2 agents only]
  Aspect: Semantic => SKIPPED (no agent)
  Aspect: Security => Agent dispatched ✓
  Aspect: Quality => SKIPPED (no agent)
  Aspect: Architecture => SKIPPED (no agent)
  ...
[Post-mortem reads vibe report]
[Grade: B (looks good)]
BUT: Skipped 6 aspects means real grade might be D
```

**Why it will cause problems:** Garbage in, garbage out. Incomplete validation → incomplete post-mortem → false confidence.

---

### HIGH-2: Crank Batching Vibe at End Delays Bug Detection
**Severity:** HIGH
**Affected:** Issue 5 (crank batches vibe at end instead of per-issue)

**What will happen:**
Current crank (Step 4-6): Implement → Vibe (after each) → Close → Next issue
Proposed: Implement all → Vibe once at end

**Problem:**
1. Implement Issue 1 ✓ (bugs introduced, but not caught)
2. Implement Issue 2 ✓ (introduces NEW bugs PLUS accumulates Issue 1 bugs)
3. Implement Issue 3 ✓ (adds 3 layers of potential bugs)
4. Implement Issue 4 ✓ (now 4 issues' worth of code to debug)
5. Run vibe ONCE at end (for 4+ issues of merged code)

When vibe detects bug in Issue 1:
- 3 more issues have built on top of it
- Regression risk: Fixing Issue 1 breaks Issues 2, 3, 4
- Blame assignment: Which issue caused the bug? (now unclear)
- Rollback: Can't roll back Issue 1 without rolling back 2, 3, 4

**Evidence:**
- crank/SKILL.md:62-76 (Step 5 current: validate after each)
- crank/SKILL.md:91-100 (Step 8 proposed: validate at end)
- git archaeology becomes harder: blame -L won't point to root cause

**Failure mode:**
```
Issues: [gt-1, gt-2, gt-3, gt-4]
[Implement gt-1] Introduces bug in config parser
[Implement gt-2] Uses config (now broken)
[Implement gt-3] Depends on gt-2's output
[Implement gt-4] Adds DB layer
[Vibe runs]
  Finding: "Config parser broken"
  Context: 4 issues, 300 lines of code
  Root cause: gt-1 line 15
  BUT: gt-2, gt-3, gt-4 depend on gt-1's output
  Fix: Revert gt-1
  Result: All 4 fail
  Status: Epic broken, can't proceed
```

**Why it will cause problems:** Batching validation creates technical debt compound interest. Early bugs cascade. Harder to locate root cause with 4 issues' worth of noise.

---

### HIGH-3: Plugin Registration Not Updated for Dispatch Changes
**Severity:** HIGH
**Affected:** All three issues (if agents not registered)

**What will happen:**
Current plugin.json:
```json
{
  "agents": "./agents/",
  "skills": "./skills/"
}
```

This dynamically loads agents from `agents/` directory.

When post-mortem attempts to dispatch 12 agents:
- If agent file missing → agent not registered → Task tool dispatch fails
- If agent file present but not in agents/ directory → same failure

Current agents directory has 20 files:
- coverage-expert.md ✓
- depth-expert.md ✓
- gap-identifier.md ✓
- assumption-challenger.md ✓
- integration-failure-expert.md ✓
- ops-failure-expert.md ✓
- data-failure-expert.md ✓
- edge-case-hunter.md ✓
- plan-compliance-expert.md ✓
- goal-achievement-expert.md ✓
- ratchet-validator.md ✓
- flywheel-feeder.md ✓
- technical-learnings-expert.md ✓
- process-learnings-expert.md ✓
- security-reviewer.md ✓
- code-reviewer.md ✓
- code-quality-expert.md ✓
- security-expert.md ✓
- architecture-expert.md ✓
- ux-expert.md ✓

**Missing agents (new ones referenced in this plan):**
- None currently identified as "missing"

**But Risk:** If any agent file is:
1. Deleted by accident during refactor
2. Not deployed to user's copy of agentops
3. Disabled in plugin.json for performance

Then: Dispatch fails silently or noisily.

**Evidence:**
```bash
# Current count
agents/: 20 files found

# Tasks requires agent to be registered
skills/post-mortem/SKILL.md references these agents (all must exist):
  - plan-compliance-expert ✓
  - goal-achievement-expert ✓
  - ratchet-validator ✓
  - flywheel-feeder ✓
  - technical-learnings-expert ✓
  - process-learnings-expert ✓
```

**Failure mode:**
```
[Post-mortem Step 4 begins]
Task: dispatch agentops:plan-compliance-expert
Task tool: Lookup "plan-compliance-expert" in plugin.json agents/
Result: Found ✓
Task: dispatch agentops:goal-achievement-expert
Task tool: Lookup "goal-achievement-expert" in plugin.json agents/
Result: Found ✓
... [agents 1-10 found] ...
Task: dispatch agentops:some-new-expert
Task tool: Lookup "some-new-expert" in plugin.json agents/
Result: NOT FOUND ✗
=> Task tool error: "Agent not registered"
=> Post-mortem workflow BREAKS
=> Synthesis impossible
```

**Why it will cause problems:** Registration is the single point of failure for entire dispatch strategy. One missing agent = whole workflow broken.

---

### HIGH-4: Synthesis Algorithm Not Defined for 12-Agent Results
**Severity:** HIGH
**Affected:** Issue 4 (post-mortem 12-agent synthesis)

**What will happen:**
post-mortem/SKILL.md:141 says:
```
Wait for all 6 agents to return, then synthesize into unified report.
```

But doesn't say HOW. Current implementation (implied by code flow):
1. Read 6 agent results
2. Write post-mortem report combining findings
3. Algorithm: Manual/heuristic (best judgment)

With 12 agents:
- 12 different perspectives on same code
- 12 different finding formats (some use tables, some use paragraphs)
- 12 different severity scales (some use 0-10, some use critical/high/medium/low)
- 12 different confidence levels (some high confidence, some low)

Synthesis must now:
1. Normalize severity across 12 agents
2. Detect and resolve conflicts
3. Weight findings by confidence
4. Identify overlaps (avoid duplication)
5. Prioritize recommendations
6. Write final report

**No algorithm documented for any of these steps.**

**Evidence:**
- post-mortem/SKILL.md Step 4-5 shows agent dispatch
- post-mortem/SKILL.md Step 6 shows report template
- NO synthesis algorithm between Step 5 and Step 6

**Failure mode:**
```
[Step 5 complete] 12 agents returned findings
[Step 6 begin] Write post-mortem report

Question: How do I combine these?
  Agent A: "5 HIGH issues"
  Agent B: "0 issues"
  Agent C: "2 CRITICAL + 3 HIGH"
  Agent D: "10 MEDIUM issues"
  ...
  Agent L: "CRITICAL security hole"

Options for synthesis:
  1. List all findings (report 30+ items = overwhelming)
  2. De-duplicate (but which agent is right?)
  3. Weight by confidence (weights not provided by agents)
  4. Consensus (no mechanism defined)
  5. Majority vote (12 agents, odd number, still conflicts)

Result: Report is either:
  - Too long and unactionable (option 1)
  - Wrong due to incorrect de-duplication (option 2)
  - Unweighted and meaningless (option 3)
  - Impossible to compute (options 4-5)

User receives: Confused, conflicting, or useless report
```

**Why it will cause problems:** Without defined synthesis algorithm, the 12-agent data is unusable. More agents = more noise without methodology to filter it.

---

## MEDIUM Findings (Could Cause Issues)

### MEDIUM-1: Token Budget Overflow Breaks Synthesis Step
**Severity:** MEDIUM
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
Each Task tool call consumes tokens:
- Input tokens: Agent prompt + context
- Output tokens: Agent response

Current session state (estimate):
- Previous commands: ~20k tokens
- User context: ~10k tokens
- Skill definitions already loaded: ~15k tokens
- Running total: ~45k tokens

Post-mortem Step 4 (12 agents):
- Input: 12 × (epic context + files) = 12 × 3k = 36k tokens
- Output: 12 × (agent response) = 12 × 1500 = 18k tokens
- Subtotal: 54k tokens
- Running total: 99k tokens

Post-mortem Step 6 (synthesis + write report):
- Synthesis: Read 12 agent responses = 18k tokens
- Merge findings: +5k tokens
- Write report: +3k tokens
- Subtotal: 26k tokens
- Running total: 125k tokens

Future work after post-mortem:
- Next skill call: +30k tokens
- Running total: 155k tokens (approaching budget)

**Failure mode:**
```
[Post-mortem Step 6 synthesis]
Read agent response #1: +1500 tokens
Read agent response #2: +1500 tokens
...
Read agent response #12: +1500 tokens
Running total: 125k tokens
[Begin merge findings]
Load all 12 findings into context: +20k tokens (to understand overlaps)
Running total: 145k tokens
[Write report]
As I write, tokens grow: 155k tokens
[Next skill call user requests]
Error: Context window nearly full
=> Next skill call fails or severely limited
=> User must restart session
```

**Why it could cause issues:** Token budget is shared session resource. 12-agent dispatch alone uses 54k tokens, leaving limited budget for synthesis and future work. If session continues, compound token explosion occurs.

---

### MEDIUM-2: Vibe Agent Dispatches Don't Account for Aspect Weights
**Severity:** MEDIUM
**Affected:** Issue 1 (vibe reduces from 6 to 2 agents)

**What will happen:**
Current vibe validates 8 aspects (Step 5):
1. Semantic (code clarity)
2. Security
3. Quality (code smell)
4. Architecture (layer violations)
5. Complexity (nesting, function length)
6. Performance (N+1 queries)
7. Slop (AI hallucinations)
8. Accessibility (N/A for backend)

Proposed: Only 2 agents (security-reviewer + code-reviewer)

Mapping:
- security-reviewer covers: Security aspect
- code-reviewer covers: Quality, Architecture, Slop aspects
- MISSING: Semantic, Complexity, Performance, Accessibility

**Problem:**
Different aspects have different importance:
- Security: CRITICAL (blocks deployment)
- Architecture: HIGH (affects maintainability)
- Complexity: HIGH (affects bugs)
- Performance: MEDIUM (affects users)
- Quality: MEDIUM (affects debt)
- Semantic: MEDIUM (affects clarity)
- Slop: LOW (affects trust in code)
- Accessibility: LOW (not always required)

With only 2 agents, the aspect weighting becomes unbalanced:
- Security gets full agent attention (good)
- Quality gets full agent attention (good)
- Everything else SKIPPED

Example: Code with no security issues but terrible architecture:
- Current vibe: Grade D (4/8 aspects pass)
- Proposed vibe: Grade A (2/2 agents pass)
- Reality: Code is unmaintainable
- User builds on broken architecture

**Evidence:**
- vibe/SKILL.md:72-85 (all 8 aspects)
- vibe/SKILL.md:87-105 (agent dispatch only covers 2)

**Failure mode:**
```
Code submitted:
- Security: ✓ (no vulnerabilities)
- Quality: ✓ (decent style)
- Architecture: ✗ (circular dependencies)
- Complexity: ✗ (50-line function with 8 params)
- Performance: ✗ (O(n²) algorithm)
- Semantic: ✗ (misleading names)
- Slop: ✗ (hallucinated error handling)

Current vibe (6 agents or manual check):
  Detects all 5 ✗ issues
  Grade: D or C
  Gate: BLOCK (unless fixed)

Proposed vibe (2 agents):
  Detects 0 ✗ issues (both are pass)
  Grade: A
  Gate: PASS

User merges bad code with bad architecture
  => Maintainability nightmare
  => Future bugs hidden by architecture
```

**Why it could cause issues:** Selective validation creates false positives. Users gain false confidence in code quality.

---

### MEDIUM-3: Crank Early-Exit Loses Compound Validation
**Severity:** MEDIUM
**Affected:** Issue 5 (crank batches vibe at end)

**What will happen:**
Current crank loop:
```
FOR each issue IN ready_issues:
  implement(issue)
  vibe()                    <-- Gate here
  IF vibe.critical:
    fix(critical_issues)
    vibe()                  <-- Re-validate
  ELSE:
    close(issue)
```

If vibe finds CRITICAL after issue N, crank can:
1. Fix it immediately (small scope)
2. Skip to next issue (manual fix later)

Proposed crank (batch vibe at end):
```
FOR each issue IN ready_issues:
  implement(issue)          <-- No validation

close_all_issues()
vibe()                      <-- Gate here (4+ issues' code)
IF vibe.critical:
  ??? (How to fix 4+ issues at once?)
```

**Problem:**
When vibe runs at end with code from 4+ issues:
- Cannot isolate which issue caused the bug
- Cannot fix in isolation (breaking change risk)
- Must either:
  1. Revert multiple issues (lose progress)
  2. Apply risky cross-issue fix (introduces new bugs)
  3. Mark CRITICAL as tech debt (breaks gate promise)

**Example scenario:**
```
Issues to implement: [gt-1, gt-2, gt-3, gt-4]
[Implement gt-1] Database query builder, 50 lines
[Implement gt-2] Add caching layer, 30 lines
[Implement gt-3] Add API endpoint, 40 lines
[Implement gt-4] Add UI integration, 60 lines
[vibe runs]
Finding: "CRITICAL: SQL injection in query builder"
Location: Line 25 of gt-1 code
Problem: gt-2, gt-3, gt-4 all depend on gt-1
Fix attempt:
  - Change line 25 in gt-1
  - Test: gt-2's cache now hits wrong data
  - Test: gt-3's API returns wrong schema
  - Test: gt-4's UI crashes
Result: Fixing CRITICAL in isolation breaks 3 other issues
```

**Why it could cause issues:** Batched validation increases blast radius of fixes. Regression risk grows exponentially (4 issues = 4×3 = 12 possible interactions to verify).

---

## MEDIUM-4: Agent Model Parameter Inconsistency
**Severity:** MEDIUM
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
post-mortem/SKILL.md:64 specifies:
```
Tool: Task
Parameters:
  subagent_type: "agentops:plan-compliance-expert"
  model: "haiku"
```

Each agent specifies model: "haiku" (4.5 variant, limited context window).

With 12 agents dispatched simultaneously:
- 12 × haiku model context windows = 12 separate 100k windows
- But they're all in ONE Claude Code session
- Session context is shared, not multiplied

**Problem:**
Haiku model is smaller and less capable than other models. Using it for complex synthesis tasks:
- Plan-compliance: Needs to read entire plan (often 10k+ tokens) - Haiku struggles
- Goal-achievement: Needs to assess user intent - Haiku does better here
- Technical-learnings: Needs deep code understanding - Haiku struggles
- Flywheel-feeder: Needs to structure for knowledge indexing - Haiku does okay

With 12 haikus doing simultaneous complex work:
- Quality variance across agents
- Some agents over-confident with limited context
- Some agents miss important details
- Results less consistent than mixed model approach

**Evidence:**
- post-mortem/SKILL.md:64-138 (all agents use "haiku")
- No model selection rationale documented
- Haiku is 4.5, not opus - lower token limit for reasoning

**Failure mode:**
```
[12 haiku agents dispatched]
Agent A (plan-compliance): Reads 8k-token plan, good analysis
Agent B (goal-achievement): Reads 5k-token goal, good analysis
Agent C (technical-learnings): Reads 15k-token codebase, struggles (low confidence)
Agent D (ops-failure-expert): Reads deployment spec, good analysis
Agent E (data-failure-expert): Reads schema, struggles (truncated output)
...
Result: Inconsistent findings, some agents under-perform due to context limits
```

**Why it could cause issues:** Model selection affects quality. All-haiku approach trades cost for accuracy. If synthesis depends on deep analysis, haiku is insufficient.

---

## LOW Findings (Minor Concerns)

### LOW-1: Agent Name Mismatches in Dispatch Calls
**Severity:** LOW
**Affected:** All three issues

**What will happen:**
Skills reference agents by name in Task dispatch:
- `subagent_type: "agentops:security-reviewer"`
- `subagent_type: "agentops:code-reviewer"`
- etc.

But agent files use hyphens (hyphenated names):
- `security-reviewer.md` (correct)
- `code-reviewer.md` (correct)

Current agent files (20 total):
```
integration-failure-expert.md ✓
goal-achievement-expert.md ✓
ratchet-validator.md ✓
flywheel-feeder.md ✓
technical-learnings-expert.md ✓
process-learnings-expert.md ✓
security-reviewer.md ✓
code-reviewer.md ✓
code-quality-expert.md ✓
security-expert.md ✓
architecture-expert.md ✓
ux-expert.md ✓
coverage-expert.md ✓
depth-expert.md ✓
gap-identifier.md ✓
assumption-challenger.md ✓
edge-case-hunter.md ✓
data-failure-expert.md ✓
ops-failure-expert.md ✓
plan-compliance-expert.md ✓
```

All names match the dispatch calls (hyphens). No mismatch detected.

**But low risk:** If someone refactors and:
- Renames `security-reviewer.md` to `securityreviewer.md`
- Doesn't update dispatch calls
- Task tool can't find agent
- Dispatch fails

**Evidence:**
- Careful naming convention in place
- But no validation that dispatch names match file names
- No synchronization check

**Failure mode:**
```
[Refactor: rename files]
Before: security-reviewer.md, code-reviewer.md
After: securityreviewer.md, codereviewercmd
[Task dispatch]
  subagent_type: "agentops:security-reviewer"
[Task tool lookup]
  agents/security-reviewer.md => NOT FOUND (now securityreviewer.md)
=> Dispatch fails
```

**Why it's low concern:** Current naming is correct. Only an issue if refactoring happens without coordination.

---

### LOW-2: Post-Mortem Report Template Assumes 6 Agent Format
**Severity:** LOW
**Affected:** Issue 4 (post-mortem 12-agent dispatch)

**What will happen:**
post-mortem/SKILL.md:149-189 shows report template with sections:
- Summary
- Vibe Results
- What Went Well
- What Could Be Improved
- Learnings Extracted
- Follow-up Issues
- Recommendations

Template assumes findings come from 6 specific agents:
- plan-compliance-expert
- goal-achievement-expert
- ratchet-validator
- flywheel-feeder
- technical-learnings-expert
- process-learnings-expert

With 12 agents, template doesn't have sections for:
- security findings
- architecture analysis
- performance findings
- etc.

Report writer must either:
1. Extend template (more sections = longer report)
2. Squash findings (lose detail)
3. Create new template (breaks downstream consumers)

**Evidence:**
- post-mortem/SKILL.md:152-189 (report template)
- Only 6-agent-shaped data structure

**Failure mode:**
```
[Synthesis complete: 12 agents' findings]
[Write report using template]
## What Went Well
  (Only has fields for compliance, goal, ratchet, flywheel, learnings)
  Where do security findings go?
  Where do architecture findings go?

Option 1: Add 6 more sections
  => Report doubles in length
  => User overwhelmed

Option 2: Merge into "Learnings Extracted"
  => Security/arch findings buried
  => Missed by readers

Option 3: Create new template
  => Inconsistent with current reports
  => Harder to trend over time
```

**Why it's low concern:** Template can be extended. More of a documentation/UX issue than a blocker.

---

## Summary Table: Failure Analysis

| ID | Severity | Category | Issue | Impact | Mitigation |
|---|----------|----------|-------|--------|-----------|
| CRITICAL-1 | CRITICAL | Concurrency | Task tool limit unknown | 12 agents may not dispatch | Document/test limit before flattening |
| CRITICAL-2 | CRITICAL | Tokens | Context explosion on code sharing | Synthesis fails | Implement token budgeting per agent |
| CRITICAL-3 | CRITICAL | Logic | Conflicting findings from 12 agents | Grade wrong/useless | Define synthesis algorithm FIRST |
| HIGH-1 | HIGH | Scope | Vibe skips 6/8 aspects | False positive grades | Ensure aspect coverage maintained |
| HIGH-2 | HIGH | Timing | Crank vibe at end not per-issue | Bugs compound, regression risk | Keep per-issue validation |
| HIGH-3 | HIGH | Registration | Agent not in plugin.json | Dispatch fails | Audit registration before deployment |
| HIGH-4 | HIGH | Design | No synthesis algorithm | Unusable 12-agent data | Design algorithm (weighted voting/conflict resolution) |
| MEDIUM-1 | MEDIUM | Tokens | Budget overflow in synthesis | Session exhausted | Track cumulative token use |
| MEDIUM-2 | MEDIUM | Validation | Aspect weight imbalance | Under-validates some aspects | Weight vibe aspects explicitly |
| MEDIUM-3 | MEDIUM | Scope | Batch vibe increases regression risk | Harder to isolate bugs | Keep issue-level gating |
| MEDIUM-4 | MEDIUM | Quality | All haiku models | Inconsistent quality | Use opus for complex analyses |
| LOW-1 | LOW | Config | Name mismatch risk | Single dispatch fails | Add validation check to plugin loading |
| LOW-2 | LOW | Template | Report template too small | Report confusing | Update template for 12 agents |

---

## Verdict

**Status:** NEEDS WORK - Address critical issues first

### Blockers (Cannot Proceed)

1. **Define Task tool concurrency limits** before attempting 12-agent dispatch
2. **Document synthesis algorithm** for merging conflicting findings
3. **Test 12-agent scenario** in staging environment to measure token usage

### Must-Fix Before Deployment

1. Ensure all 20 agents are registered and available
2. Keep per-issue vibe validation in crank (don't batch at end)
3. Maintain aspect weight distribution in vibe

### Recommendations for Resequencing

1. **Phase 1:** Keep current architecture (nested Skill calls)
2. **Phase 2:** Add synthesis algorithm research
3. **Phase 3:** Test 2-agent vibe with proper aspect mapping
4. **Phase 4:** Test 6-agent post-mortem at scale
5. **Phase 5:** Only after phases 1-4 pass: Attempt 12-agent flattening

### Risk Mitigation Strategy

If proceeding despite findings:

1. **Concurrency:** Add explicit Task tool call batching (5 agents per call max)
2. **Tokens:** Add session token tracker, abort if >150k consumed
3. **Synthesis:** Start with weighted voting (agent confidence scores)
4. **Validation:** Run both old (nested) and new (flat) paths in parallel for 1 epic
5. **Rollback:** Keep nested Skill call code available for immediate revert

---

## Integration Test Plan

To validate the flattened approach would work:

### Test 1: 12-Agent Dispatch Under Load
```
Epic: Medium scope (5-10 issues)
Run: post-mortem with 12-agent flattening
Measure:
  - Do all 12 agents dispatch successfully?
  - What is actual token consumption?
  - How long does synthesis take?
  - Is output useful or conflicting?
```

### Test 2: Synthesis Algorithm Validation
```
Run: 12 agents on real code
Collect: 12 agent responses with potentially conflicting findings
Test: Each proposed synthesis algorithm
  - Weighted voting
  - Consensus (majority)
  - Conservative (max severity)
  - Permissive (min severity)
Evaluate: Which algorithm produces useful, defensible reports?
```

### Test 3: Regression Risk Measurement
```
Epic: 4-issue crank task
Version A: Current (vibe after each issue)
Version B: Proposed (vibe at end)
Measure:
  - Time to detect bugs in each version
  - Number of issues affected by each bug
  - Effort to fix bugs in each version
Conclusion: Does batching actually increase risk?
```

---

## Conclusion

The plan to flatten skill nesting addresses a real problem (context explosion) but introduces three CRITICAL integration risks that will likely cause failures:

1. **Undocumented concurrency limits** will silently drop or timeout agents
2. **Context explosion** in synthesis will exceed token budgets
3. **Conflicting findings** from 12 agents cannot be merged without defined algorithm

Additionally, four HIGH-severity issues could undermine the approach:
- Incomplete vibe validation (skipped aspects)
- Batching vibe in crank increases regression risk
- Agent registration not verified before deployment
- No synthesis algorithm documented

**Recommendation:** DO NOT PROCEED with the flattening plan until:
1. Task tool concurrency limits are documented and tested
2. Synthesis algorithm is designed and validated
3. 12-agent scenario is tested in staging with real epics

**Alternative:** Phase the approach - improve nested Skill call efficiency before flattening.

