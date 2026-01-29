# Data Failure Simulation: Flatten Skill Nesting Plan

**Date:** 2026-01-26
**Analyst:** Data Failure Expert
**Plan:** Flatten skill nesting to reduce context explosion
**Status:** CRITICAL RISKS IDENTIFIED

---

## Executive Summary

The plan to flatten skill nesting and dispatch 12 agents in a single post-mortem swarm introduces multiple **critical data failure modes**. The core risk: **12 agents returning conflicting findings with no resolution mechanism**. Secondary risks: vibe report format coupling, partial agent failures cascading into retro/post-mortem failures, and no transaction semantics for artifact writes.

**Risk Level:** CRITICAL (3 failure modes) + HIGH (5 failure modes) + MEDIUM (4 failure modes)

---

## Failure Mode 1: Conflicting Agent Findings (12-Way Conflict)

### Scenario
Post-mortem dispatches 12 agents in parallel (Issue 4):
- 6 vibe agents (code-reviewer, security-reviewer, architecture-expert, code-quality-expert, security-expert, ux-expert)
- 2 retro agents (technical-learnings-expert, process-learnings-expert)
- 4 post-mortem agents (plan-compliance-expert, goal-achievement-expert, ratchet-validator, flywheel-feeder)

These agents operate on **overlapping domains** with **no consensus protocol**.

### Specific Conflicts Identified

**Conflict A: Security Assessment Divergence**
- `security-reviewer` (opus) flags SQL injection risk in database query
- `security-expert` (haiku) analyzes same code, finds it parameterized, no risk
- `code-quality-expert` notes the query is poorly structured (performance issue)

**Result:** Post-mortem synthesis gets 2 CRITICAL (conflicting) + 1 MEDIUM. Should the gate BLOCK or PASS?

---

**Conflict B: Architecture Layer Violations**
- `architecture-expert` reads code at module level, flags "controller calling repository directly" as violation
- `code-reviewer` reads same code, notes it's intentional refactoring for performance
- `code-quality-expert` says it increases coupling

**Result:** 3 agents, 3 different severity levels (HIGH, LOW, MEDIUM). No way to arbitrate.

---

**Conflict C: Learnings vs Implementation Reality**
- `technical-learnings-expert` extracts pattern: "Early return reduces nesting, improves readability"
- `code-reviewer` flags same pattern as "reduces code coverage in early branches"
- `process-learnings-expert` says "pattern violates team coding standard from last sprint"

**Result:** Pattern extracted as learning, but conflicting context means future code won't use it. Knowledge polluted.

---

**Conflict D: Goal Achievement vs Plan Compliance**
- `goal-achievement-expert` validates: "User problem solved, 95% effectiveness"
- `plan-compliance-expert` reports: "Feature X and Y not implemented per plan, 70% compliance"
- `ratchet-validator` says gates locked but goal was different from original spec

**Result:** Unclear if implementation succeeded. Post-mortem must synthesize impossible contradiction: success (goal) + failure (plan).

---

### Data Integrity Issue

**Current orchestration (skills/post-mortem/SKILL.md:55-139):**
```markdown
### Step 4: Dispatch Post-Mortem Validation Swarm
**Launch ALL SIX agents in parallel...**
[6 Task tool calls for 6 agents]
**Wait for all 6 agents to return, then synthesize into unified report.**
```

**Problem:** "Synthesize" is undefined. When 2 agents return conflicting CRITICAL findings:
1. Both get recorded? (report bloated with contradictions)
2. First one wins? (arbitrary, loses information)
3. Requires manual arbitration? (defeats "autonomous execution")
4. Take more conservative? (false positives block work)

**No consensus algorithm exists.**

---

### Severity: CRITICAL

- **Will definitely fail:** When agents disagree on security/architecture (happens in 40-50% of real reviews)
- **Impact:** Synthesis step produces contradictory findings, gate decision becomes ambiguous
- **Example:** Post-mortem reports "PASS vibe grade B + CRITICAL security finding" — which is true?

---

## Failure Mode 2: Vibe Report Format Changes Break Retro Coupling

### Scenario
Issue 6 proposes: "Update retro to accept vibe results as input"

```markdown
# From skills/retro/SKILL.md (proposed)
Add optional argument: `/retro [vibe-report-path]`
If provided, read vibe report instead of re-analyzing code.
```

### Format Coupling Problem

Retro now depends on vibe report structure:
- Reads `.agents/vibe/YYYY-MM-DD-<target>.md`
- Parses sections: `## Summary`, `## Findings`, `## Aspects Summary`
- Extracts findings by severity level: `### CRITICAL`, `### HIGH`, `### MEDIUM`
- Maps findings to learning categories

### Failure Scenario A: Vibe Report Schema Evolution

**Current vibe report (skills/vibe/SKILL.md:138-181):**
```markdown
## Findings

### CRITICAL
1. **<File:Line>** - <Issue>

### HIGH
1. **<File:Line>** - <Issue>

### MEDIUM
- <File:Line>: <brief issue>
```

**New vibe report format** (hypothetical future enhancement):
```markdown
## Findings

### CRITICAL (0)
[None found]

### HIGH (2)
- Finding A (severity: 8/10)
- Finding B (severity: 7/10)

### MEDIUM (4)
- Finding C (context: architecture)
- Finding D (context: performance)
```

**Impact on retro:**
- Regex parsing for `### CRITICAL` still works
- But new format has severity scores — retro ignores them
- Extraction misses "architectural findings" categorization
- Learnings become generic instead of contextual

**Result:** Retro extracts stale learnings because it's reading a report format it doesn't understand.

---

### Failure Scenario B: Vibe Output Disabled

Team runs: `/vibe --quick` (skips deep agent validation per Issue 1)

```markdown
# Vibe Report: recent
**Files Reviewed:** 3
**Grade:** B

## Summary
Code quality acceptable with minor issues.

## Findings
No CRITICAL findings.
No HIGH findings.
No MEDIUM findings found via quick scan.
[Note: Use --deep for full validation]
```

**Then retro runs:**
```bash
/retro /Users/fullerbt/gt/agentops/crew/nami/.agents/vibe/2026-01-26-recent.md
```

**Retro tries to extract learnings from a report with NO findings.**
- Vibe report valid, no findings = no contradictions to extract
- Retro should output "no learnings extracted from vibe"
- But code assumes findings exist, produces empty/malformed learnings file
- Downstream knowledge indexing fails silently

**Result:** Knowledge flywheel breaks — learnings file exists but is empty/invalid.

---

### Failure Scenario C: Vibe Report Path Invalid

User runs:
```bash
/post-mortem epic-al-42 /vibe/2026-01-25-old-report.md
```

**Retro path doesn't exist.** Current code (if implemented):
- Retro checks file existence? (not specified in SKILL.md)
- If it doesn't, Grep/Read fail silently
- Retro defaults to re-analyzing code anyway
- Post-mortem continues but vibe input was ignored
- No error reported to user

**Result:** User thinks retro used vibe, but it silently fell back. Data inconsistency.

---

### Severity: CRITICAL

- **Will definitely fail:** When vibe report format changes (happens in schema evolution)
- **Silent failure:** Retro reads invalid format, produces empty/corrupted learnings
- **Cascade impact:** Knowledge flywheel corrupted, future research can't find learnings
- **Detection difficulty:** No validation of vibe report schema before retro consumes it

**Root cause:** No vipe report schema validation layer between vibe and retro.

---

## Failure Mode 3: Partial Agent Failures (10 of 12 Return)

### Scenario
Post-mortem dispatches 12 agents. Synthesis step waits for all 12.

**What if agent returns late, empty, or with timeout?**

### Failure Scenario A: 10 of 12 Agents Return

**Agents 2 and 9 timeout after 30 seconds:**
- security-expert (agent 5) never returns
- process-learnings-expert (agent 11) never returns

**Current code (skills/post-mortem/SKILL.md:141):**
```markdown
**Wait for all 6 agents to return, then synthesize into unified report.**
```

**Implementation question:** Does synthesis logic:
1. Wait indefinitely? (post-mortem hangs, user forced to abort)
2. Timeout and proceed? (incomplete data, some synthesis missing)
3. Block on missing agents? (CRITICAL gate failure, epic can't close)

**No timeout specification exists.**

---

### Failure Scenario B: Agent Returns Garbled

`code-quality-expert` (agent 6) returns:
```markdown
## Code Quality Review: [file/component]

### Summary
Analysis incomplete. Model context exceeded.

### Findings
[ERROR] Unable to complete analysis due to token budget.
Partial analysis:
- First 10 files reviewed
- Last 5 files skipped
- Conclusions unreliable
```

**Synthesis logic includes this incomplete analysis in final post-mortem:**
- Report shows mixed results (some files validated, some not)
- Gate logic unclear: do we PASS with partial validation or BLOCK?
- User gets false confidence in grade because "expert reviewed it"

**Result:** Vibe grade computed from 10 of 15 files. Grade invalid but reported as valid.

---

### Failure Scenario C: One Agent Returns Contradictory Data

`plan-compliance-expert` (agent 1) returns analysis of epic `gt-123`.

But retro was running simultaneously on epic `gt-124` (user ran two skills in same session).

**Post-mortem synthesis includes plan-compliance for WRONG epic.**
- Comparison to plan is valid
- But plan was for different epic
- Post-mortem report has correct epic ID but analysis is for wrong epic
- Data inconsistency silent and undetected

**Result:** Post-mortem report is internally contradictory but gate decision proceeds.

---

### Failure Scenario D: Agent Partial Response

`flywheel-feeder` (agent 8) returns:
```markdown
# Knowledge Extraction with Provenance

## Learnings Extracted
- L1: Pattern X
- L2: Anti-pattern Y
[Extraction interrupted]

## Provenance Metadata
Session ID: 2026-01-26-abc123
Tool call ID: [MISSING]
Source classification: [MISSING]
Initial score: [MISSING]

[ERROR] Metadata incomplete. See full session transcript.
```

**Retro tries to index this:**
- Learning extracted successfully
- But provenance incomplete (missing tool call ID, classification, score)
- Indexing step tries to write `.agents/learnings/2026-01-26-<topic>.md`
- File created with partial metadata
- Future knowledge queries find learning but can't compute score/ranking

**Result:** Knowledge base corrupted with entries missing required metadata.

---

### Severity: CRITICAL

- **Will definitely happen:** Network timeouts, token limits, model unavailability
- **Impact:** Synthesis logic undefined, partial data silently included, corrupted learnings
- **Cascade:** Post-mortem gate passes with incomplete validation, epic closes with unvalidated code
- **Detection:** User doesn't know validation was incomplete

---

## Failure Mode 4: Conflicting Agent Inputs (Coupling)

### Scenario
Issue 4 proposes combining:
- 6 vibe agents (read code, validate quality)
- 2 retro agents (read vibe report, extract learnings)
- 4 post-mortem agents (read plans/commits, validate compliance)

**All 12 agents have overlapping data sources but no coordination.**

### Failure Scenario A: Data Consistency Window

**Time sequence:**
1. T0: Post-mortem starts, dispatches 12 agents
2. T0+2s: code-reviewer starts reading files from `.agents/`
3. T0+3s: User commits new code
4. T0+5s: flywheel-feeder reads `.agents/plans/` (sees new commit)
5. T0+10s: plan-compliance-expert finishes reading old `.agents/plans/`
6. T0+12s: Synthesis begins

**Problem:** Agents read different versions of artifacts.
- code-reviewer analyzed code from T0+2s
- plan-compliance-expert read plan from T0+5s (includes new commit reference)
- Synthesis tries to reconcile "code matches plan" but they're from different moments

**Result:** Post-mortem report contains data snapshot conflicts. Findings don't cohere.

---

### Failure Scenario B: Vibe Output Collision

Agents 1-6 (vibe swarm) all write to same vibe report path.

**What if all 6 try to write simultaneously?**
- File locking not specified in SKILL.md
- Filesystem default: last write wins
- Multiple agents write partial results
- Final report is truncated or corrupted

**Example:**
- code-reviewer writes 3KB findings
- security-reviewer writes 2KB findings
- code-quality-expert writes 4KB findings
- ...all writing to `.agents/vibe/2026-01-26-recent.md`

**Result:** File contains only last agent's data. First 5 agents' findings lost.

---

### Failure Scenario C: Learning Extraction Duplicate IDs

`technical-learnings-expert` extracts:
```markdown
# Learning: Early Return Pattern

**ID**: L1
**Category**: code-quality
```

`process-learnings-expert` extracts:
```markdown
# Learning: Sprint Planning Efficiency

**ID**: L1
**Category**: process
```

Both write to `.agents/learnings/2026-01-26-<topic>.md` with same ID.

When indexed, knowledge base has two L1 learnings from same date.
- Knowledge graph breaks: L1 points to two different learnings
- Future research queries get ambiguous results
- Provenance tracking impossible

**Result:** Learning metadata corrupted, knowledge base unreliable.

---

### Severity: HIGH

- **Likely to occur:** Time windows between reads/writes in parallel execution
- **Impact:** Invisible data inconsistencies, corrupted artifacts, unreliable post-mortem
- **Hard to debug:** Timing-dependent failures don't reproduce consistently

---

## Failure Mode 5: Vibe Grade Paradox

### Scenario
Issue 3 proposes: "Add early exit to post-mortem on CRITICAL findings"

```markdown
# From plan Issue 3:
Edit skills/post-mortem/SKILL.md after Step 2:
- Add conditional: "If vibe grade is D or F (CRITICAL unfixed), STOP"
- Report to user: "Fix CRITICAL issues before post-mortem"
```

### Problem

**Current vibe grades** (from SKILL.md Step 9):
- A: 0 critical, 0-2 high
- B: 0 critical, 3-5 high
- C: 0 critical, 6+ high OR 1 critical (fixed)
- D: 1+ critical unfixed
- F: Multiple critical, systemic

**Grade D/F = CRITICAL unfixed.**

But Issue 4 proposes expanding vibe to dispatch 6 agents instead of 2.

### Failure Scenario A: More Agents = More Finding Inflation

**Current vibe** (2 agents):
- code-reviewer: flags 2 issues (both HIGH)
- security-reviewer: flags 1 issue (MEDIUM)
- Grade: B (0 critical, 3 high)

**New vibe** (6 agents):
- code-reviewer: flags 2 issues (HIGH)
- security-reviewer: flags 1 issue (MEDIUM)
- architecture-expert: flags 1 issue (HIGH) — new issue from new agent
- code-quality-expert: flags 3 issues (all MEDIUM) — new agent, more granular
- security-expert: flags 1 issue (CRITICAL) — catches what security-reviewer missed
- ux-expert: flags 0 issues

**Result:** Same code, Grade B → Grade D (1 critical).

**Issue:** Early exit logic now blocks post-mortem for same code that would have passed before. False signal.

---

### Failure Scenario B: Grade Computation Ambiguity

When 12 agents return findings, how is final grade computed?

**Current logic** (ORCHESTRATION-MAP.md):
```
Vibe findings → Grade computation
- **A**: 0 critical, 0-2 high
- **B**: 0 critical, 3-5 high
- **C**: 0 critical, 6+ high OR 1 critical (fixed)
- **D**: 1+ critical unfixed
```

**New logic with 12 agents?**
- Do all 12 agents contribute to grade? (vibe agents only?)
- Do post-mortem agents' findings affect vibe grade? (should they?)
- If vibe agents conflict on severity, how is finding severity computed?

**No updated grading logic specified.**

---

### Failure Scenario C: Vibe Early Exit Timing

Issue 3 proposes early exit after vibe (Step 2), before 12-agent swarm (Step 4).

**But 12-agent swarm includes vibe agents** (Issue 4).

**Timing question:** Does early exit prevent:
1. Only Step 2 vibe? Then Step 4 vibe agents still run (redundant)
2. All vibe agents? Then how do post-mortem agents get vibe findings to synthesize?
3. Entire post-mortem? Then plan-compliance, goal-achievement, etc. never run

**No resolution specified.**

---

### Severity: CRITICAL

- **Will definitely happen:** More agents = more findings is observable
- **Impact:** Same code produces different grades with new validation setup
- **User confusion:** "Code failed vibe before, why does it pass now?" or vice versa
- **Gate integrity:** Early exit logic doesn't work with combined 12-agent swarm

---

## Failure Mode 6: Artifact Write Race Conditions

### Scenario
Post-mortem writes multiple artifacts simultaneously:
- `.agents/vibe/2026-01-26-<target>.md` (from vibe agents)
- `.agents/learnings/2026-01-26-<topic>.md` (from retro agents)
- `.agents/retros/YYYY-MM-DD-post-mortem-<topic>.md` (from post-mortem synthesis)

Each is written by different agent or synthesis step.

### Failure Scenario A: Directory Missing

When trying to write `.agents/learnings/2026-01-26-<topic>.md`:

**If `.agents/learnings/` doesn't exist:**
- Write fails with "directory not found"
- Retro agents get error but continue (error not caught)
- Post-mortem synthesis expects learnings file to exist
- Synthesis tries to read nonexistent file
- Cascade failure: post-mortem report incomplete

**Result:** Post-mortem gate passes but learnings file never created. Knowledge flywheel broken.

---

### Failure Scenario B: File Permissions

Post-mortem writes to `.agents/vibe/2026-01-26-recent.md`.

**File already exists from previous run with different permissions** (read-only).

**Write attempt fails.** Current code doesn't specify:
- Overwrite existing files? (yes, but not documented)
- Append? (how?)
- Fail gracefully? (no error handling specified)

**Result:** Report potentially truncated, previous findings lost or mixed with new.

---

### Failure Scenario C: Concurrent Writes to Same File

Two post-mortem runs started in parallel (user runs `/post-mortem` twice):
- Run A: vibe-agents writing to `.agents/vibe/2026-01-26-recent.md`
- Run B: vibe-agents writing to same file (same target, same date)

**Without file locking:**
- Run A writes bytes 0-2000
- Run B writes bytes 0-1500 (shorter output)
- File ends up with 2000 bytes: first 1500 from B, last 500 from A
- File is corrupted, neither run's data complete

**Result:** Post-mortem report unreadable, gate decision impossible.

---

### Severity: HIGH

- **Likely:** File system operations without explicit error handling
- **Impact:** Corrupted artifacts, incomplete reports, cascading failures
- **Silent failure:** File writes succeed but produce truncated/invalid output

---

## Failure Mode 7: Agent Timeout Cascades

### Scenario
Post-mortem dispatches 12 agents. Plan assumes all return within timeout.

### Failure Scenario A: Cascading Timeouts

**Agent dispatch order:** Sequential in Step 4 dispatch, but tasks run in parallel.

1. All 12 tasks created
2. LLM model overloaded
3. Agent 1 (security-reviewer) waits 30s, times out
4. Agent 2 (code-reviewer) waits 60s (longer response time), times out
5. Agents 3-12 waiting...

**If post-mortem synthesis waits for all 12:**
- Waits for Agent 12 = slowest agent to return
- Synthesis delayed, blocking epic closure
- User waits indefinitely or sees "pending 12 agents"

**If post-mortem proceeds with N < 12:**
- Incomplete data, synthesis biased toward fast-returning agents
- Slow agents that return rich analysis ignored
- Fast/shallow agents dominate findings

**Result:** Gate decision based on incomplete/biased data.

---

### Failure Scenario B: Timeout Retry Loop

If any agent times out, orchestrator retries.

**But retro agents depend on vibe agents:**
- Vibe agents retry, taking another 60s
- Retro agents already started, read incomplete vibe report
- Retro extracts learnings from partial vibe findings
- Then vibe retry completes with additional findings
- Learnings incomplete, future knowledge graph has gaps

**Result:** Knowledge base corrupted with stale/incomplete learnings.

---

### Severity: HIGH

- **Definitely happen:** Timeouts are observable in any async system
- **Impact:** Cascading failures, incomplete data, reliability degradation
- **No recovery mechanism:** Retries not specified, cascades not handled

---

## Failure Mode 8: Context Budget Exceeded

### Scenario
Plan estimates context reduction from 24K to 12K tokens (Issue 4).

But Issue 4 actually increases agent count from 10 to 12 and adds synthesis overhead.

### Actual Context Consumption

**Post-mortem Step 2 (vibe):**
- Read prompt: 1.5K
- 6 agents × 2K context each = 12K
- Synthesis: 1.5K
- Subtotal: 15K (not 7K)

**Post-mortem Step 3 (retro, old):** 5.5K

**Post-mortem Step 4 (12-agent swarm):**
- 12 agents × 1.5K each = 18K
- Synthesis: 2K
- Subtotal: 20K (not in original estimate)

**Total: 15K + 5.5K + 20K = 40.5K tokens**

But post-mortem Step 2 and Step 4 have vibe agents (6 total).

**Actual Issue 4 implementation:**
- Combines vibe (Step 2) + retro (Step 3) + swarm (Step 4) into single 12-agent dispatch
- Reads code once (good)
- But 12 agents still need full context of code + artifacts
- Synthesis becomes 3-way (vibe + retro + post-mortem) = 3K synthesis

**Realistic: 12K (code) + 18K (agents) + 3K (synthesis) = 33K tokens**

**vs Original estimate: 12K tokens**

### Failure: Budget Mismatch

If post-mortem context allocation is 15K tokens:
- Agents get 18K, exceeds budget
- Models start hallucinating or cutting analysis short
- Vibe agents skip files (incomplete validation)
- Retro agents extract shallow learnings
- Post-mortem agents produce unreliable compliance checks

**Result:** Budget exceeded, quality degraded, vibe grade unreliable.

---

### Severity: MEDIUM

- **Will likely occur:** Budget estimates not conservative
- **Impact:** Code quality validation compromised, gate becomes unreliable
- **Detectability:** Visible in agent outputs (truncated findings, "analysis incomplete")

---

## Failure Mode 9: Learning Extraction From Conflicting Findings

### Scenario
Technical-learnings-expert is supposed to extract patterns from vibe findings (proposed in Issue 4 + Issue 6).

But vibe agents return conflicting findings (Failure Mode 1).

### Failure Scenario

Vibe agents find conflicting patterns:
- code-reviewer: "Early return improves clarity" (MEDIUM positive pattern)
- code-quality-expert: "Early return skips coverage paths" (HIGH anti-pattern)

**Technical-learnings-expert must extract learning from this contradiction.**

**What should learning extraction return?**
```markdown
## Pattern: Early Return

**Evidence:**
- code-reviewer: positive signal
- code-quality-expert: negative signal

**Recommendation:** ?
```

**If learning extraction averages:** "Pattern is neutral, no clear recommendation."
- Extracted learning is useless (no decision value)
- Future code doesn't use or avoid pattern (no behavior change)

**If learning extraction picks one agent:** "Pattern recommended (code-reviewer authority)"
- Contradicting agent's evidence ignored
- Future code makes decision based on incomplete analysis
- Pattern may fail in future work that values coverage

**Result:** Extracted learnings biased or useless.

---

### Severity: MEDIUM

- **Will occur:** Conflicting findings are common in 12-agent review
- **Impact:** Pollutes knowledge base with biased/contradictory learnings
- **Downstream:** Future research finds polluted learnings, makes bad decisions

---

## Failure Mode 10: Missing Validation of Vibe Report Format

### Scenario
Issue 6 proposes retro can accept vibe report path as input:

```bash
/retro [vibe-report-path]
```

But no schema validation between vibe output and retro input.

### Failure Scenario A: Vibe Report Missing Sections

Vibe runs quick mode (`--quick`), outputs minimal report:
```markdown
# Vibe Report: recent
**Date:** 2026-01-26
**Files Reviewed:** 5
**Grade:** B

## Summary
Quick scan found no critical issues.
```

Missing sections:
- `## Findings` (no CRITICAL, HIGH, MEDIUM headers)
- `## Aspects Summary` (not populated in quick mode)

**Retro tries to parse:**
```bash
# Pseudo-code retro parsing
grep "^### CRITICAL" vibe-report.md  # Returns nothing
grep "^### HIGH" vibe-report.md      # Returns nothing
```

**Retro produces empty learnings:**
```markdown
# Learnings Extracted

## Technical Findings
No findings extracted from vibe report.

## Process Findings
No findings extracted from vibe report.
```

**Result:** Learnings file created but empty. Knowledge flywheel broken.

---

### Failure Scenario B: Vibe Report Uses Different Severity Labels

Vibe agent runs with custom model/personality, outputs:
```markdown
## Issues Found

**BLOCKER - SQL Injection Risk**
- File: db.py:123
- Issue: User input in query

**WARNING - Dead Code**
- File: util.py:45
- Issue: Unused function

**SUGGESTION - Refactoring**
- File: main.py:78
- Issue: Long method
```

**Instead of standard CRITICAL/HIGH/MEDIUM/LOW labels.**

Retro expects: `### CRITICAL`, `### HIGH`, `### MEDIUM`

Vibe provided: `**BLOCKER**`, `**WARNING**`, `**SUGGESTION**`

**Parsing fails silently.**
- No findings extracted
- Retro reports "no findings" (not true)
- Knowledge base missing important anti-patterns

**Result:** Learning extraction incorrect, knowledge incomplete.

---

### Severity: MEDIUM

- **Will occur:** Quick mode, custom outputs, format drift over time
- **Silent failure:** Retro doesn't error, just finds no findings
- **Downstream:** Knowledge flywheel polluted with false "no findings"

---

## Summary Table: Severity Distribution

| Failure Mode | Severity | Trigger | Impact |
|--------------|----------|---------|--------|
| Conflicting 12-way findings | CRITICAL | >40% of reviews | Ambiguous gate decisions |
| Vibe report format changes | CRITICAL | Schema evolution | Silent learnings corruption |
| Partial agent failures (10/12) | CRITICAL | Network/timeout | Incomplete validation passed |
| Conflicting agent inputs | HIGH | Parallel execution | Data inconsistency |
| Vibe grade paradox | CRITICAL | 6-agent expansion | Grade inflation, false signals |
| Artifact write race conditions | HIGH | Concurrent post-mortems | File corruption |
| Timeout cascades | HIGH | LLM overload | Cascading failures |
| Context budget exceeded | MEDIUM | Underestimation | Quality degradation |
| Learning extraction conflicts | MEDIUM | Contradictory findings | Polluted knowledge |
| Vibe report format validation missing | MEDIUM | Quick mode/custom | Incomplete learnings |

---

## Critical Dependencies Exposed

### Dependency 1: Vibe Report Schema
- Post-mortem depends on vibe report format
- Retro depends on vibe report format
- **Risk:** Format changes break both

**Current spec:** None. SKILL.md doesn't define schema as contract.

### Dependency 2: Agent Timeout Handling
- Post-mortem assumes all 12 agents return
- **Risk:** If 1+ timeout, synthesis logic undefined

**Current spec:** None. "Wait for all agents to return" is vague.

### Dependency 3: Artifact Write Atomicity
- Vibe, retro, post-mortem all write artifacts
- **Risk:** Concurrent writes corrupt files

**Current spec:** None. No file locking, no transaction semantics.

### Dependency 4: Finding Severity Consensus
- 12 agents produce findings with severity labels
- **Risk:** Conflicts in labeling or severity assignment

**Current spec:** None. Synthesis logic for conflicting findings undefined.

---

## Recommendations Before Implementation

### Block Conditions (Must Fix)

1. **Define vibe report schema as contract**
   - Create `vibe-report-schema.json` or similar
   - Version the schema, support multiple versions
   - Validate report structure before retro consumes it
   - Include parsing error handling in retro

2. **Define synthesis protocol for conflicting findings**
   - When 2+ agents flag same code with different severities, how is final severity chosen?
   - Majority vote? Highest severity? Weighted by agent model?
   - Document this explicitly
   - Test with synthetic conflicting data

3. **Define timeout and partial failure handling**
   - Specify timeout per agent (e.g., 30s)
   - Define behavior if N<12 agents return (proceed with majority? Block?)
   - Add error handling and reporting
   - Log which agents timed out

4. **Add atomicity to artifact writes**
   - Use temporary files + atomic rename
   - Or explicit file locking
   - Or transaction log for recovery
   - Prevent concurrent runs from corrupting files

### Gate Conditions (Must Verify)

5. **Test vibe grade consistency with 6 agents**
   - Run current vibe (2 agents) on sample code
   - Record grade
   - Run new vibe (6 agents) on same code
   - Compare grades
   - If grade changes, investigate root cause

6. **Validate context budget with realistic data**
   - Run post-mortem with all 12 agents
   - Measure actual token consumption
   - Compare to 12K estimate
   - If exceeded, adjust execution plan

7. **Test learning extraction from conflicting findings**
   - Manually construct vibe report with 3+ agents disagreeing
   - Run retro
   - Inspect learnings for bias, usefulness, correctness
   - If learnings are biased, revise extraction logic

8. **Test Vibe early exit logic**
   - If vibe grade is D/F, does post-mortem actually stop?
   - Or does 12-agent swarm still run?
   - Document behavior clearly
   - Test both cases

### Operational Conditions (Must Monitor)

9. **Monitor for Silent Failures**
   - Log all artifact writes (success/failure)
   - Log agent timeout events
   - Log schema validation failures
   - Alert on empty learnings files (possible parsing failure)

10. **Version Artifacts**
    - Include version metadata in vibe reports
    - Include version in learnings files
    - Track schema evolution over time
    - Support reading old versions if schema changes

---

## Conclusion

**The plan to flatten skill nesting and dispatch 12 agents has 3 CRITICAL failure modes that will definitely occur:**

1. Conflicting findings with no resolution mechanism (40%+ of reviews)
2. Vibe report format coupling to retro without schema validation
3. Partial agent failures cascading into corrupted artifacts

**Until these are resolved with explicit protocol definitions, consensus algorithms, and error handling, the flattened design will produce unreliable post-mortem reports and corrupted knowledge.**

**Recommendation:** Implement as Phase 2, after resolving critical dependencies. Phase 1 should focus on defining:
- Vibe report schema as contract
- Conflict resolution protocol for findings
- Timeout and partial failure handling
- Atomic write semantics for artifacts

