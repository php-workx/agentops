---
id: pre-mortem-2026-03-05-testing-documentation
type: pre-mortem
date: 2026-03-05
source: "[[.agents/plans/2026-03-05-testing-documentation-improvements.md]]"
---

# Pre-Mortem: Testing & Documentation Improvements (na-xjw)

## Council Verdict: WARN (auto-fixed)

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Missing-Requirements | WARN | Plan said 5 stale paths; actual count is 11. Fixed in plan. |
| Feasibility | PASS | All referenced files, scripts, and tools verified to exist. BATS available. |
| Scope | PASS | Clean file ownership boundaries. No Go code changes. No overlapping edits in W1. |
| Spec-Completeness | WARN | Issue 10 conformance check mixed hook test into skill runner. Fixed in plan. |

## Findings (3)

### W1: Stale path count understated (WARN - auto-fixed)
Plan said "5 stale paths" but `grep -c` returns 11. Lines 517, 559, 560, 565, 570, 606 were missed.
**Fix applied:** Updated Issue 1 to use global sed and reference all 11 lines.

### W2: Issue 10 conformance check wrong target (WARN - auto-fixed)
Conformance check grepped `tests/skills/run-all.sh` for `test-orphan-hooks`, but that file lives in `tests/hooks/`. Should be wired into validate.yml BATS job instead.
**Fix applied:** Split conformance into 10a (skills) and 10b (hooks/validate.yml).

### W3: Issue 7 script exit code risk (INFO)
Three scripts being wired into ci-local-release.sh should be tested standalone first. If any has a non-zero exit on this repo, it would break the local CI gate.
**Mitigation:** Worker should run each script before wiring.

## Strengths
- Wave decomposition correct (W2 genuinely blocked by W1)
- Zero file overlap across W1 parallel issues
- Conformance checks for every issue (mechanically verifiable)
- Well-scoped boundaries ("Never touch Go source")
- All referenced artifacts verified to exist

## Recommendation

[x] PROCEED - Warnings auto-fixed in plan. Ready for /crank execution.
[ ] ADDRESS
[ ] RETHINK
