# Pre-Mortem Analysis: ag-kiy (Fix AgentOps Skill Architecture)

**Date:** 2026-01-25
**Epic:** ag-kiy
**Iterations:** 10

## Simulation Summary

| Iterations | Critical | Important | Nice-to-Have |
|------------|----------|-----------|--------------|
| 10         | 3        | 4         | 2            |

## Critical Findings (Must Fix Before Implementation)

### C1: ao CLI incomplete - `ao --version` fails

**Iteration:** 2
**Impact:** Blocks understanding of CLI state
**Evidence:** `ao --version` returns error, but `ao help` works
**Status:** VERIFIED - ao CLI exists and has extract/inject commands

**Resolution:** NOT A BLOCKER - CLI works, just version command broken

### C2: vibe/scripts/prescan.sh doesn't exist

**Iteration:** 4
**Impact:** ag-kiy.1 says "modify prescan.sh" but it doesn't exist
**Evidence:** `ls skills/vibe/scripts/` returns "No scripts directory"

**Resolution:** SCOPE CHANGE - ag-kiy.1 must CREATE prescan.sh, not modify

### C3: No end-to-end test defined

**Iteration:** 10
**Impact:** No way to verify flywheel works after changes
**Evidence:** No test task in epic

**Resolution:** ADD TASK - ag-kiy.8: Create flywheel smoke test

## Important Findings (Should Fix)

### I1: Directory creation missing from tasks

**Iteration:** 3
**Impact:** Scripts will fail on fresh repos
**Affected Tasks:** ag-kiy.1, ag-kiy.2, ag-kiy.3

**Resolution:** Add `mkdir -p` to each task's implementation

### I2: Circular dependency in ag-kiy.4

**Iteration:** 6
**Impact:** Fixing one side without the other leaves gate broken
**Evidence:** Crank searches `.agents/pre-mortems/`, pre-mortem writes `.agents/specs/`

**Resolution:** Fix BOTH paths atomically in ag-kiy.4

### I3: Research matching is fuzzy (ag-kiy.5)

**Iteration:** 7
**Impact:** Glob matching won't find "auth-research.md" for goal "fix authentication"
**Evidence:** String matching on natural language fails

**Resolution:** Use Smart Connections semantic search instead of glob

### I4: Skill vs CLI confusion (ag-kiy.2, ag-kiy.3)

**Iteration:** 1
**Impact:** Tasks say "create skill" but hooks already call CLI commands
**Evidence:** hooks.json runs `ao extract` and `ao inject` as CLI

**Resolution:** Clarify - skills DOCUMENT the CLI, they don't replace it

## Nice-to-Have (v1.1)

### N1: Token budget selection algorithm (ag-kiy.3)

**Iteration:** 5
**Impact:** 1000 tokens fits only 2-3 learnings, no ranking
**Resolution:** Define recency + relevance scoring for selection

### N2: Valid tier values undefined (ag-kiy.6)

**Iteration:** 9
**Impact:** Adding tier fields without knowing valid values
**Resolution:** Document valid tier values: solo, library, meta, framework

## Task Amendments

### ag-kiy.1: SCOPE CHANGE

**Original:** Modify prescan.sh to persist findings
**Amended:** CREATE prescan.sh that outputs to `.agents/assessments/`

Add to description:
- vibe/scripts/ directory doesn't exist - create it
- Create prescan.sh from scratch
- Implement basic pattern detection (hardcoded secrets, TODO/FIXME, complexity)
- Output to `.agents/assessments/{date}-vibe-{target}.md`

### ag-kiy.4: SCOPE CHANGE

**Original:** Fix crank pre-mortem gate path
**Amended:** Unify pre-mortem output path and crank search path

Add to description:
- Decide canonical path: `.agents/specs/` (current pre-mortem output)
- Update crank to search `.agents/specs/*-v2.md` OR `*-analysis.md`
- Verify pre-mortem SKILL.md matches chosen path

### ag-kiy.5: SCOPE CHANGE

**Original:** Search `.agents/research/*<goal>*.md`
**Amended:** Use Smart Connections for semantic research discovery

Add to description:
- Use `mcp__smart-connections-work__lookup` with goal as query
- Filter results to `.agents/research/` paths
- Fall back to glob if Smart Connections unavailable

### NEW: ag-kiy.8 - Flywheel smoke test

**Priority:** P1
**Description:**
Create end-to-end test:
1. Write a test learning to `.agents/learnings/`
2. Run `ao inject` and verify learning appears in output
3. Run `ao extract` on mock pending session
4. Verify test passes before marking epic complete

## Execution Order (Revised)

```
1. ag-kiy.6 (tier fields) - Quick win, no dependencies
2. ag-kiy.7 (dependency cleanup) - Quick win
3. ag-kiy.1 (vibe persistence) - Creates infrastructure
4. ag-kiy.4 (crank gate path) - Unblock pre-mortem → crank flow
5. ag-kiy.5 (plan research) - Uses Smart Connections
6. ag-kiy.2 (extract skill) - Document existing CLI
7. ag-kiy.3 (inject skill) - Document existing CLI
8. ag-kiy.8 (smoke test) - Verify everything works
```

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| ao CLI has undocumented bugs | Medium | High | Test each command manually first |
| Smart Connections not indexed | Low | Medium | Fall back to glob |
| prescan.sh scope creep | High | Medium | Limit to 3 patterns only |
| Context overflow during inject | Medium | Low | Hard limit 1000 tokens |

## Recommendation

**PROCEED with amendments.** Critical blockers resolved:
- ao CLI works (version command broken but commands work)
- vibe prescan scope clarified (create, don't modify)
- E2E test added

Create ag-kiy.8 before executing epic.
