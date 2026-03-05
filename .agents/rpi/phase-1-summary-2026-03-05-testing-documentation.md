# Phase 1 Summary: Testing & Documentation Improvements (na-xjw)

**Epic:** na-xjw
**Goal:** Fix testing/documentation gaps found by 7-agent audit
**Pre-mortem verdict:** WARN (auto-fixed)
**Issue count:** 10 (8 in W1, 2 in W2)

## Wave Decomposition
- **W1 (parallel):** Issues 1-6, 8, 10 — no file overlap, all independent
- **W2 (serial after W1):** Issues 7, 9 — depend on docs created in W1

## Key Decisions
- Global sed for stale paths (11 refs, not 5)
- test-orphan-hooks → validate.yml BATS job (not run-all.sh)
- Remove phantom e2e-install-test.sh block (don't stub)
- Conformance split: 10a (skills) + 10b (hooks)
