---
id: post-mortem-2026-03-08-na-fr0
type: post-mortem
date: 2026-03-08
source: "bead na-fr0"
---

# Post-Mortem: Next-Work Contract Parity (na-fr0)

**Epic:** na-fr0
**Duration:** 28m 37s
**Cycle-Time Trend:** Slightly slower than the small 8-15 minute retros, but still efficient for a contract change that touched runtime, docs, generated Codex artifacts, CI wiring, and queue state.

## Council Verdict: FAIL

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | FAIL | The shipped contract still teaches the legacy flat-row append shape in `skills/post-mortem/SKILL.md` and generated `skills-codex/post-mortem/SKILL.md`. |
| Tech-Debt | WARN | `next-work.jsonl` mutation still uses unlocked full-file rewrites and the parity gate is grep-based rather than semantic. |
| Learnings | WARN | The schema-plus-parity pattern is correct, but autonomous queue work still needs earlier worktree integrity checks and stronger writer-surface validation. |

### Implementation Assessment

The implementation commit on `main` (`9fc46356`) landed the intended contract center of gravity:
- `.agents/rpi/next-work.schema.md` now publishes the v1.3 queue shape.
- `scripts/validate-next-work-contract-parity.sh` and `tests/scripts/test-next-work-contract-parity.sh` added a concrete parity gate.
- `cli/cmd/ao/rpi_loop.go` and its tests now model per-item claim, release, and consume semantics.
- The harvest and phase-data docs were updated to describe the new queue lifecycle.

That is real progress, and the queue item for this work was correctly consumed in `.agents/rpi/next-work.jsonl`.

### Concerns

1. **Contract inconsistency still shipped**: Step ACT.3 in both the source post-mortem skill and the generated Codex post-mortem skill still shows a flat `echo "{\"title\": ...}" >> .agents/rpi/next-work.jsonl` append example instead of the batch-entry v1.3 shape.
2. **Parity gate coverage is incomplete**: `scripts/validate-next-work-contract-parity.sh` checks schema/reference/runtime strings, but it does not validate producer examples in `skills/post-mortem/SKILL.md` or generated `skills-codex/**` artifacts.
3. **Queue mutation remains concurrency-unsafe**: the runtime still performs read/modify/write updates of the whole JSONL file with no lock or compare-and-swap guard.
4. **Execution preflight is still fragile**: this work discovered `na-177` because linked worktrees can inherit canonical `core.worktree`, which is exactly the kind of environment defect autonomous queue consumers should detect before claiming work.

## Learnings

### What Went Well
- The fix established a real canonical contract instead of leaving queue behavior implicit in `rpi_loop.go`.
- The implementation included both runtime changes and regression tests for per-item lifecycle behavior.
- The queue bookkeeping path exercised the new contract for a real consumed item, not just a synthetic test.

### What Was Hard
- The implementation touched multiple producer and consumer surfaces, but the validation only covered a subset of them.
- Commit-to-bead traceability was still weaker than ideal, so evidence gathering depended on file scope and timestamps instead of commit messages.
- Worktree identity drift remained an execution hazard during a task that depended on correct queue mutation.

### Do Differently Next Time
- Treat contract migrations as incomplete until every producer example and generated artifact is validated, not just schema and runtime code.
- Add execution preflight checks for worktree identity before any autonomous queue claim or consume path mutates shared state.
- Prefer semantic parity checks over grep-based string checks when the contract spans runtime, docs, and generated outputs.

### Patterns to Reuse
- Publish the contract in one tracked schema file, then wire a parity script and regression tests in the same wave.
- Use real queue consumption during validation to prove the lifecycle model works outside isolated unit tests.

### Anti-Patterns to Avoid
- Declaring parity complete when the most user-visible producer examples still teach the old format.
- Rewriting shared queue state without synchronization once multiple autonomous consumers exist.

### Footgun Entries

| Footgun | Impact | Prevention |
|---------|--------|-----------|
| Contract docs can stay wrong while the gate stays green | A migration appears complete even though future writers still emit the old queue shape | Validate every producer surface, including `SKILL.md` examples and generated Codex artifacts |
| Linked worktrees can inherit canonical `core.worktree` | Autonomous flows may mutate or inspect the wrong git root before queue bookkeeping starts | Add a worktree identity preflight before claim/consume flows and fail early on mismatches |

## Knowledge Lifecycle

### Backlog Processing (Phase 3)
- Scanned: 1 newly extracted learning for this post-mortem
- Merged: 0 duplicates
- Flagged stale: 0

### Activation (Phase 4)
- Promoted to MEMORY.md: 0
- Constraints compiled: 0
- Next-work items fed: 2

### Retirement (Phase 5)
- Archived: 0 learnings

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | repo | Fix stale flat next-work append examples in post-mortem source and Codex generated docs | P0 | now | S | Plan-compliance judge confirmed both source and generated post-mortem skills still teach flat-row writes |
| 2 | ci-automation | Expand next-work contract parity validation to cover producer examples and generated Codex artifacts | P0 | now | S | Current gate only checks selected schema/reference/runtime strings, so the stale examples shipped undetected |
| 3 | execution | Add worktree identity preflight before autonomous queue claim/consume flows | P1 | next-cycle | M | `na-177` was discovered during na-fr0 because linked worktrees inherited canonical `core.worktree` |
| 4 | repo | Make next-work queue mutation concurrency-safe | P1 | next-cycle | M | Runtime still rewrites the full JSONL file without locking or CAS semantics |

### Recommended Next $rpi
$rpi "Fix stale flat next-work append examples and expand next-work parity validation to cover producer examples and generated Codex artifacts"

## Prior Findings Resolution Tracking

| Metric | Value |
|---|---|
| Backlog entries analyzed | 25 |
| Prior findings total | 142 |
| Resolved findings | 1 |
| Unresolved findings | 141 |
| Resolution rate | 0.7% |

| Source Epic | Findings | Resolved | Unresolved | Resolution Rate |
|---|---:|---:|---:|---:|
| march-8-delivery-chain | 6 | 1 | 5 | 16.67% |
| na-8ar | 8 | 0 | 8 | 0% |
| na-3re | 4 | 0 | 4 | 0% |
| na-de8 | 3 | 0 | 3 | 0% |

## Command-Surface Parity Checklist

| Command File | Run-path Covered by Test? | Evidence | Intentionally Uncovered? | Reason |
|---|---|---|---|---|
| cli/cmd/ao/rpi_loop.go | yes | `TestWorkTypeRank`, `TestMarkItemClaimedAndReleased`, `TestQueueMarkFailed_Basic`, plus queue lifecycle tests in `cli/cmd/ao/rpi_loop_test.go` | no | — |

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | `na-khp` Fix stale flat next-work append examples in post-mortem source and Codex generated docs | bug | high | council-finding | agentops |
| 2 | `na-hc8` Expand next-work contract parity validation to cover producer examples and generated Codex artifacts | improvement | high | council-finding | agentops |
| 3 | `na-177` Add worktree identity preflight before autonomous queue claim/consume flows | process-improvement | medium | retro-learning | * |

## Status

[ ] CLOSED - Work complete, learnings captured
[x] FOLLOW-UP - Issues need addressing (create new beads)
