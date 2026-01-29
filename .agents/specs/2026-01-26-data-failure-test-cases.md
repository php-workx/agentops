# Data Failure Test Cases: Flatten Skill Nesting Plan

**Date:** 2026-01-26
**Purpose:** Concrete test scenarios to verify fixes before implementation

---

## Test Case 1: Conflicting Security Findings (CRITICAL-001)

**Objective:** Verify conflict resolution protocol works with 2+ agents disagreeing on severity

**Setup:**
```bash
# Create sample Python code with potential security issue
cat > /tmp/test_security.py << 'EOF'
import sqlite3
user_input = input("Enter search term: ")
query = f"SELECT * FROM users WHERE name = '{user_input}'"
result = db.execute(query)
EOF
```

**Test Execution:**

1. Run vibe with 6 agents:
   ```bash
   /vibe /tmp/test_security.py --deep
   ```

2. Capture findings:
   - security-reviewer finding (should flag SQL injection)
   - security-expert finding (should flag SQL injection)
   - code-quality-expert finding (should flag string formatting)
   - architecture-expert finding (should flag direct DB call)

3. Check for conflicts:
   - Do any agents assign different severity levels?
   - Do any agents give opposite recommendations?

4. Verify synthesis:
   - Read post-mortem report
   - Check if report shows contradiction
   - Check if gate decision is ambiguous

**Expected Result (PASS):**
- All agents agree on SQL injection severity (CRITICAL)
- Synthesis shows consensus
- Gate decision clear (BLOCK)

**Expected Result (FAIL - Confirms Risk):**
- Agents disagree on severity (one flags CRITICAL, one flags HIGH)
- Synthesis shows contradiction
- Gate decision ambiguous: "Grade B with CRITICAL finding"

**Gate Decision:** If FAIL, CRITICAL-001 risk confirmed. Must implement consensus algorithm.

---

## Test Case 2: Vibe Report Format Parsing (CRITICAL-002)

**Objective:** Verify retro can safely parse vibe reports with format variations

**Test Setup:**

### Scenario A: Standard Format
```bash
# Generate standard vibe report
/vibe recent > /tmp/vibe-standard.md
```

**Test:**
```bash
/retro /tmp/vibe-standard.md
```

**Expected:** Learnings extracted successfully

---

### Scenario B: Quick Mode (Missing Sections)
```bash
# Generate quick vibe report (missing findings)
/vibe recent --quick > /tmp/vibe-quick.md
```

Content looks like:
```markdown
# Vibe Report: recent
**Grade:** B
## Summary
Quick scan found no critical issues.
```

**Test:**
```bash
/retro /tmp/vibe-quick.md
```

**Expected (PASS):** Retro detects quick format, reports "no findings, learning extraction skipped" or similar

**Expected (FAIL - Confirms Risk):** Retro creates empty learnings file without error

---

### Scenario C: Schema Evolution (Future Format)
```bash
# Simulate future vibe format with severity scores
cat > /tmp/vibe-future.md << 'EOF'
# Vibe Report: sample

## Findings

### CRITICAL (1)
1. **SQL Injection** (severity: 9.5/10)
   - File: db.py:45
   - Risk: User input in query
   - Confidence: 95%

### HIGH (2)
...
EOF
```

**Test:**
```bash
/retro /tmp/vibe-future.md
```

**Expected (PASS):** Retro parses successfully, extracts findings, ignores unknown fields

**Expected (FAIL - Confirms Risk):** Retro fails to parse or creates malformed learnings

---

## Test Case 3: Partial Agent Failures (CRITICAL-003)

**Objective:** Verify post-mortem handles missing/incomplete agent responses

**Test Setup:**

### Scenario A: Agent Timeout Simulation

Create mock agent that times out:
```bash
# Temporarily rename one agent tool to simulate "unavailable"
mv /agents/code-quality-expert.md /agents/code-quality-expert.md.bak
```

**Test:**
```bash
/post-mortem recent
```

**Expected (PASS):** Post-mortem reports "code-quality-expert timed out, synthesis with 11/12 agents, grade provisional"

**Expected (FAIL - Confirms Risk):** Post-mortem hangs indefinitely or proceeds silently with incomplete data

**Cleanup:**
```bash
mv /agents/code-quality-expert.md.bak /agents/code-quality-expert.md
```

---

### Scenario B: Agent Returns Incomplete

Manually create incomplete agent response:
```bash
cat > /tmp/incomplete-agent.txt << 'EOF'
## Code Review

### Findings
[ERROR] Analysis interrupted - token budget exceeded

Only first 5 files analyzed.
Remaining 12 files not reviewed.

Conclusion unreliable.
EOF
```

**Test:**
Integrate response into post-mortem synthesis, verify handling

**Expected (PASS):** Post-mortem note "code-reviewer incomplete, grade confidence reduced"

**Expected (FAIL - Confirms Risk):** Report shows "full review completed" but analysis incomplete

---

## Test Case 4: Vibe Grade Consistency (HIGH-001)

**Objective:** Verify grade doesn't change with agent expansion

**Setup:**
Select 10 representative code samples covering:
- Security issues
- Performance issues
- Code quality issues
- Architecture issues
- UX issues

**Test Execution:**

1. Run old vibe (2 agents):
   ```bash
   # Simulate by calling only security-reviewer + code-reviewer
   /vibe <sample> --agents security-reviewer,code-reviewer
   Record grade
   ```

2. Run new vibe (6 agents):
   ```bash
   /vibe <sample> --agents all
   Record grade
   ```

3. Compare grades:
   | Sample | Old Grade | New Grade | Change |
   |--------|-----------|-----------|--------|
   | sample1 | B | B | No |
   | sample2 | A | B | Yes |
   | sample3 | B | D | Yes |
   | ... | | | |

**Expected Result (PASS):**
- 90%+ of samples have same grade
- Grade differences explained (e.g., new agent finds genuine issues)

**Expected Result (FAIL - Confirms Risk):**
- 30%+ grade changes without corresponding new issues
- Same code grades A and D on different runs
- Conclusion: Grade inflation with new agents

**Gate Decision:** If >30% grade variance, must revise grading algorithm.

---

## Test Case 5: Concurrent Write Collision (HIGH-002)

**Objective:** Verify artifact writes don't corrupt files

**Test Setup:**
```bash
# Start two post-mortems simultaneously on same target
(sleep 0 && /post-mortem recent) &
(sleep 0.5 && /post-mortem recent) &
wait
```

**Verification:**
```bash
# Check if both artifacts written correctly
ls -l .agents/vibe/2026-01-26-recent.md
# Should see one file

# Verify file is valid markdown
python3 -c "import sys; import json; [print(line) for line in open('.agents/vibe/2026-01-26-recent.md')]"
# Should parse without errors

# Verify both runs' findings are present
grep -c "CRITICAL" .agents/vibe/2026-01-26-recent.md
# Should see all findings, not truncated
```

**Expected (PASS):**
- One vibe report file exists
- File contains complete findings from both runs merged

**Expected (FAIL - Confirms Risk):**
- File truncated (missing findings)
- File corrupted (invalid markdown)
- File contains only last run's data (first run lost)

---

## Test Case 6: Context Budget Measurement (MEDIUM-001)

**Objective:** Verify actual token consumption matches estimate

**Setup:**
Create large code sample:
```bash
# Generate synthetic code (3 files, 1K lines each)
for i in 1 2 3; do
  python3 -c "
for j in range(400):
    print(f'def func_{j}():\n    return {j}\n')
" > /tmp/sample_$i.py
done
```

**Test Execution:**

1. Measure context before post-mortem:
   ```bash
   # Approximate token count
   wc -c /tmp/sample_*.py  # Byte count, roughly 4 bytes = 1 token
   ```

2. Run post-mortem with instrumentation:
   ```bash
   # If possible, log token usage per agent
   /post-mortem /tmp/sample_1.py --debug-tokens
   ```

3. Analyze output:
   - Vibe agents tokens: should be ~12K
   - Retro agents tokens: should be ~5K
   - Post-mortem agents tokens: should be ~10K
   - Synthesis tokens: should be ~3K
   - Total: ~30K

**Expected (PASS):**
- Actual usage within 10% of estimate

**Expected (FAIL - Confirms Risk):**
- Actual usage >30% over estimate
- Agents truncate findings: see "...analysis truncated..." messages
- Learnings shallow: only 2-3 learnings extracted vs 5+

---

## Test Case 7: Learning Extraction With Contradictions (MEDIUM-002)

**Objective:** Verify learnings don't pollute knowledge base

**Setup:**
Create vibe report with contradictory findings:
```bash
cat > /tmp/vibe-contradiction.md << 'EOF'
# Vibe Report: test

## Findings

### HIGH
1. **Early Return Pattern** (code-quality-expert)
   - File: main.py:45
   - Issue: Early return skips code coverage
   - Recommendation: Avoid early returns, use single exit point

2. **Early Return Pattern** (code-reviewer)
   - File: main.py:45
   - Issue: Improves clarity and reduces nesting
   - Recommendation: Use early returns for cleaner code
EOF
```

**Test:**
```bash
/retro /tmp/vibe-contradiction.md
```

**Inspect learnings:**
```bash
cat .agents/learnings/2026-01-26-*.md | grep -A 10 "Early Return"
```

**Expected (PASS):**
- Learning includes both perspectives
- Recommendation notes contradiction
- Guidance is: "Use early returns when clarity is priority, avoid when coverage is critical"

**Expected (FAIL - Confirms Risk):**
- Learning averages both: "Early return is neutral"
- Or picks one arbitrarily: ignores contradicting evidence
- Learnings becomes useless or biased

---

## Test Case 8: Artifact Write Failure Recovery (MEDIUM-004)

**Objective:** Verify system recovers from partial writes

**Setup:**
```bash
# Make learnings directory read-only
chmod 444 .agents/learnings

# Try post-mortem
/post-mortem recent
```

**Expected (PASS):**
- Error message: "Cannot write to .agents/learnings/, check permissions"
- Post-mortem fails gracefully
- Existing artifacts not corrupted

**Expected (FAIL - Confirms Risk):**
- Post-mortem succeeds despite permission error
- Learnings file missing or truncated
- No error reported to user

**Cleanup:**
```bash
chmod 755 .agents/learnings
```

---

## Test Case 9: Conflicting Agent Inputs During Parallel Run (HIGH-004)

**Objective:** Verify post-mortem handles data consistency issues

**Setup:**
```bash
# While post-mortem is running, modify code
# Start post-mortem
/post-mortem recent &
POST_MORTEM_PID=$!

# Wait 3 seconds for agents to start reading
sleep 3

# Commit new code
echo "# New change" >> sample_file.py
git add sample_file.py
git commit -m "Update during post-mortem"

# Wait for post-mortem to finish
wait $POST_MORTEM_PID
```

**Verification:**
```bash
# Check if post-mortem report is consistent
grep "File.*sample_file.py" .agents/vibe/*.md
# Is the file analysis for old or new version?

grep "File.*sample_file.py" .agents/retros/*.md
# Do learnings match vibe findings?
```

**Expected (PASS):**
- Report indicates snapshot time: "Analysis as of T0"
- All agents used same version of code
- Findings coherent

**Expected (FAIL - Confirms Risk):**
- Some agents analyzed old code, some new
- Report shows code review from commit A, plan from commit B
- Findings don't align, contradictions

---

## Test Case 10: Empty Learnings From Quick Mode (MEDIUM-003)

**Objective:** Verify retro doesn't silently fail on quick vibe

**Test:**
```bash
# Run quick vibe
/vibe recent --quick
# Generates report with no findings

# Then run retro
/retro /Users/fullerbt/gt/agentops/crew/nami/.agents/vibe/2026-01-26-recent.md

# Check learnings
ls -l .agents/learnings/2026-01-26-*
# Was file created?

cat .agents/learnings/2026-01-26-* 2>/dev/null
# Is file empty? Corrupted? Or properly indicates "no learnings"?
```

**Expected (PASS):**
- Learnings file indicates: "No findings from quick vibe, learning extraction skipped"
- Clear message to user
- No silent failure

**Expected (FAIL - Confirms Risk):**
- Learnings file created but empty
- No message to user
- Knowledge flywheel assumes learnings exist but finds nothing

---

## Test Case 11: Duplicate Learning IDs From Two Agents (HIGH-005)

**Objective:** Verify learning ID coordination

**Setup:**
Manually run technical-learnings-expert and process-learnings-expert on same work

**Inspection:**
```bash
# Check learnings for duplicate IDs
grep "^\\*\\*ID\\*\\*:" .agents/learnings/*.md | sort | uniq -d
```

**Expected (PASS):**
- No duplicate IDs found

**Expected (FAIL - Confirms Risk):**
- Multiple learnings with same ID
- Knowledge graph corrupted

---

## Test Case 12: Agent Model Consistency (Vibe Opus vs Haiku)

**Objective:** Verify agent severity assignments are consistent

**Setup:**
Create ambiguous code sample (could be HIGH or MEDIUM depending on perspective)

**Test:**
```bash
# Run vibe, capture all agent findings
/vibe sample.py --deep

# Compare findings from Opus agents vs Haiku agents
```

**Expected (PASS):**
- Opus agents and Haiku agents agree on severity within 1 level
- E.g., both flag same issue as HIGH, or one HIGH one MEDIUM (acceptable)

**Expected (FAIL - Confirms Risk):**
- Opus flags issue as CRITICAL, Haiku flags as MEDIUM
- Synthesis can't reconcile findings
- Gate decision ambiguous

---

## Master Test Plan

| Test Case | Risk | Priority | Effort | Duration |
|-----------|------|----------|--------|----------|
| TC1: Conflicts | CRITICAL-001 | P0 | High | 2h |
| TC2: Report Format | CRITICAL-002 | P0 | Medium | 1h |
| TC3: Partial Failure | CRITICAL-003 | P0 | High | 2h |
| TC4: Grade Consistency | HIGH-001 | P0 | High | 3h |
| TC5: Write Collision | HIGH-002 | P1 | Medium | 1h |
| TC6: Context Budget | MEDIUM-001 | P0 | Medium | 1.5h |
| TC7: Contradictions | MEDIUM-002 | P1 | Low | 1h |
| TC8: Write Failure | MEDIUM-004 | P1 | Low | 0.5h |
| TC9: Data Consistency | HIGH-004 | P1 | High | 2h |
| TC10: Empty Learnings | MEDIUM-003 | P1 | Low | 0.5h |
| TC11: Duplicate IDs | HIGH-005 | P1 | Low | 0.5h |
| TC12: Model Consistency | (general) | P2 | Low | 1h |

**Total Effort:** ~16 hours
**Recommended:** Run P0 tests (TC1, 2, 3, 4, 6) before implementation (~9 hours)

---

## Success Criteria

### Pre-Implementation Gate (Must Pass All)

1. **TC1 (Conflicts):** Consensus algorithm defined and tested
2. **TC2 (Report Format):** Schema validation implemented
3. **TC3 (Partial Failure):** Timeout and error handling specified
4. **TC4 (Grade Consistency):** <20% grade variance on sample set
5. **TC6 (Context Budget):** Actual usage within estimate ±10%

### Post-Implementation Gate (Must Pass All)

6. **TC5 (Write Collision):** Concurrent writes produce valid merged artifacts
7. **TC9 (Data Consistency):** Reports indicate snapshot time, findings coherent
8. **TC10 (Empty Learnings):** Quick mode handled gracefully, no silent failures
9. **TC11 (Duplicate IDs):** No duplicate learning IDs in output

### Ongoing Monitoring

10. Monitor for timeout events, log frequency
11. Monitor artifact write failures, log and alert
12. Monitor learning extraction quality, sample learnings for usefulness

