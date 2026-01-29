# Pre-Mortem: Competitor Adoption Implementation

**Date:** 2026-01-26
**Spec:** `/Users/fullerbt/.claude/plans/hidden-puzzling-hartmanis.md`

## Summary

Implementing 6 enhancements from competitor research: 4 skill improvements + 2 new hooks. The plan modifies plugin cache files which carries version persistence risk. Key failure modes center around **undefined hook event types**, **state management gaps**, and **edge case handling**.

## Simulation Findings

### CRITICAL (Must Fix Before Implementation)

#### 1. UserPromptSubmit Hook Event Type Not Verified
**Source:** Integration Failure Expert

The plan adds a `keyword-detector.sh` hook on `UserPromptSubmit` event, but there's no verification this event type is supported by Claude Code's hook system. Current hooks.json only shows `SessionStart` and `SessionEnd` events.

- **Why it will fail:** Silent registration failure; keyword detection never fires
- **Recommended fix:**
  1. Verify supported hook events before implementing
  2. Check Claude Code documentation or test with minimal hook
  3. If `UserPromptSubmit` unsupported, use `PreToolUse` as alternative

#### 2. Bug-Hunt "3+ Failed Fixes" Rule Undefined
**Source:** Edge Case Hunter

The plan says "3+ fixes failed → stop and question architecture" but doesn't define what counts as a "failure":
- Root cause not found?
- Fix design rejected?
- Tests still failing?
- Timeout during exploration?

- **Why it will fail:** Ambiguous counter increments on any error; premature investigation termination
- **Recommended fix:**
  ```
  Define failure types explicitly:
  - root_cause_not_found: Counts toward 3-limit
  - execution_timeout: Resets counter (don't count)
  - fix_failed_tests: Counts toward 3-limit
  - design_rejected: Counts toward 3-limit
  ```

#### 3. Crank Infinite Loop Without Global Iteration Limit
**Source:** Edge Case Hunter

The plan adds todo-continuation with iteration limit of 50, but this is per-task. Epic-level circular dependencies (A blocks B, B blocks C, C blocks A) can cause infinite loop since Step 6 retries 3 times but has no global cap.

- **Why it will fail:** Agent consumes unbounded tokens/time on circular blockers
- **Recommended fix:**
  ```
  Add to /crank:
  MAX_EPIC_ITERATIONS = 50 (global, not per-task)
  Track iteration_count across all Step 6 loops
  Hard stop + escalation if exceeded
  ```

#### 4. Verification Gate Blocks Already In-Progress Work
**Source:** Edge Case Hunter

If user calls `/implement gt-123` while issue already in_progress (from previous interrupted session), verification gate may reject with no resume path.

- **Why it will fail:** Cannot resume interrupted work; manual beads reset required
- **Recommended fix:**
  ```
  In verification gate:
  - If status=in_progress AND claimed_by=self: allow resume
  - If status=in_progress AND claimed_by=other: reject with context
  - Store checkpoint in issue metadata for safe resume
  ```

### HIGH (Should Fix)

#### 5. AGENTS.md Missing/Malformed Crashes Session Start
**Source:** Both Experts

The plan adds `cat AGENTS.md` to session-start.sh without existence check. Projects without AGENTS.md will fail or produce undefined behavior.

- **Risk:** Session start fails silently; user loses context injection
- **Mitigation:**
  ```bash
  if [[ -f "AGENTS.md" ]]; then
    cat AGENTS.md
  else
    # Log warning, continue without AGENTS.md
  fi
  ```

#### 6. PostToolUse Timing Race Condition
**Source:** Integration Failure Expert

Comment-checker hook fires on PostToolUse, but may execute before filesystem reflects tool changes. Hook reads stale file content.

- **Risk:** False negatives on comment density; validation unreliable
- **Mitigation:** Add file timestamp check; verify file mtime > session start

#### 7. Keyword Detector Triggers on Conversational References
**Source:** Edge Case Hunter

User writes "I researched this before; we should implement now" → hook detects "researched" + "implement" → tries to invoke both skills without arguments.

- **Risk:** Spurious skill invocations break conversation flow
- **Mitigation:** Require `/` prefix or sentence-start pattern, not substring match

#### 8. Concurrent Hook Writes Corrupt .agents/ao/ State
**Source:** Edge Case Hunter

If keyword-detector and comment-checker run simultaneously, both may write to `.agents/ao/` files without coordination → corruption.

- **Risk:** Knowledge base corruption; maturity calculations fail
- **Mitigation:** Add file locking (flock) with 60s timeout; atomic writes via temp+rename

#### 9. ao CLI Version Not Validated
**Source:** Integration Failure Expert

Hooks invoke `ao extract`, `ao inject`, etc. but `ao` may not be installed or may be incompatible version. Errors suppressed by `2>/dev/null || true`.

- **Risk:** Knowledge flywheel silently stops working
- **Mitigation:** Add `ao --version` check in session-start.sh; explicit error handling

### MEDIUM (Consider)

#### 10. Comment Density on 0-Line or All-Comment Files
Division by zero or undefined behavior when file has no code lines.
**Fix:** Handle edge cases: flag as "special" not error

#### 11. JSON Escaping Fails on Unicode/Emoji
Custom escape function may corrupt multi-byte UTF-8.
**Fix:** Use `jq -Rs` instead of character-by-character escaping

#### 12. Rationalization Table Schema Undefined
No validation of required columns; inconsistent formats across projects.
**Fix:** Define mandatory columns: File | Old | New | Rationale | Safety

#### 13. Plugin Cache Files May Be Overwritten
Modifying `~/.claude/plugins/cache/agentops-marketplace/agentops/1.0.8/` directly means plugin update will overwrite changes.
**Fix:** Consider fork or local plugin override mechanism

#### 14. TODO Marker Doesn't Distinguish DONE vs PAUSED
`<promise>DONE</promise>` doesn't capture timestamp or reason; can't distinguish completed from intentionally paused.
**Fix:** Rich markers: `<promise status="DONE" at="2026-01-26T14:23Z" reason="completed"/>`

## Ambiguities Found

1. **Hook event types:** What hook events does Claude Code actually support? Need to verify UserPromptSubmit and PostToolUse exist.

2. **Failure definition for bug-hunt:** What constitutes a "failed fix" for the 3-attempt rule?

3. **Plugin persistence:** Will changes to cached plugin files survive plugin updates?

4. **Keyword matching strategy:** Substring vs word-boundary vs explicit prefix?

5. **todo-continuation storage:** Where do todos persist? File? Beads metadata? Memory?

## Spec Enhancement Recommendations

### Add to ag-cai.1 (Enhance /implement)
1. Add: Checkpoint storage for resume capability
2. Clarify: What constitutes verification evidence

### Add to ag-cai.2 (keyword-detector)
1. Add: Hook event type validation step
2. Clarify: Word-boundary matching requirement
3. Add: File locking for concurrent writes

### Add to ag-cai.3 (AGENTS.md support)
1. Add: Existence check before read
2. Add: Unicode-safe JSON escaping (use jq)

### Add to ag-cai.4 (comment-checker)
1. Add: File type filtering (skip binaries)
2. Add: Edge case handling (0-line, all-comment)
3. Add: File locking for concurrent writes

### Add to ag-cai.5 (bug-hunt 4-phase)
1. Add: Explicit failure type definitions
2. Clarify: Which failures count toward 3-attempt limit

### Add to ag-cai.6 (crank todo-continuation)
1. Add: Global iteration limit (50)
2. Add: Rich status markers with timestamps
3. Clarify: Todo storage location

## Risk Summary

| Severity | Count | Action |
|----------|-------|--------|
| CRITICAL | 4 | Must fix in spec before implementation |
| HIGH | 5 | Should fix during implementation |
| MEDIUM | 5 | Worth addressing if time permits |

## Verdict

**[ ] READY** - Proceed to implementation
**[x] NEEDS WORK** - Address 4 critical issues first

The critical issues involve:
1. Undefined hook event types (integration risk)
2. Undefined failure semantics (behavioral ambiguity)
3. Missing safeguards (infinite loops, deadlocks)

**Recommendation:** Update the plan to address critical issues before creating beads and executing.
