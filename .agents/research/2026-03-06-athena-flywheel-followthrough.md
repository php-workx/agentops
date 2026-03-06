---
type: research
date: 2026-03-06
topic: athena-flywheel-followthrough
---

# Research: Athena Flywheel Follow-Through

## Goal

Promote Athena's March 6 findings into durable knowledge artifacts that future sessions can retrieve and apply without rereading the Athena report.

## Key Findings

### 1. The observability gap is real and already encoded in runtime behavior

Recent Athena mine output showed repeated `ao rpi serve` fixes around cross-root observability. The current implementation now mirrors both state and event writes across artifact roots:

- `appendRPIC2Event()` writes the primary event and mirrors to every root returned by `mirrorRootsForEvent()` in [`cli/cmd/ao/rpi_c2_events.go`](cli/cmd/ao/rpi_c2_events.go).
- `savePhasedState()` writes state to the primary root, then `mirrorStateToPeers()` mirrors state to peer roots and emits `state.mirrored` / `state.mirror.failed` events in [`cli/cmd/ao/rpi_phased_state.go`](cli/cmd/ao/rpi_phased_state.go).

The behavior is protected by tests that verify:

- mirrored state writes succeed in worktree + supervisor roots
- mirror failures emit explicit C2 events
- worktree lifecycle events (`worktree.created`, `worktree.resumed`, `worktree.merged`, `worktree.removed`) remain observable from the right root

Primary evidence files:

- [`cli/cmd/ao/rpi_c2_events.go`](cli/cmd/ao/rpi_c2_events.go)
- [`cli/cmd/ao/rpi_phased_state.go`](cli/cmd/ao/rpi_phased_state.go)
- [`cli/cmd/ao/rpi_phased_mirror_test.go`](cli/cmd/ao/rpi_phased_mirror_test.go)
- [`cli/cmd/ao/rpi_phased_setup_test.go`](cli/cmd/ao/rpi_phased_setup_test.go)

### 2. Test hotspot guidance exists in code, but not yet as a pattern

Athena's hotspot list is not just "large tests exist"; it points at recurring structure:

- high-CC tests are usually long scenario tests with many phases
- helper reuse already exists in [`cli/cmd/ao/testutil_test.go`](cli/cmd/ao/testutil_test.go)
- many tests still rely on direct `os.Chdir()` use or multi-phase single-function flows

Representative hotspots and support files:

- [`cli/cmd/ao/knowledge_loop_e2e_test.go`](cli/cmd/ao/knowledge_loop_e2e_test.go)
- [`cli/cmd/ao/workflow_integration_test.go`](cli/cmd/ao/workflow_integration_test.go)
- [`cli/cmd/ao/rpi_loop_supervisor_test.go`](cli/cmd/ao/rpi_loop_supervisor_test.go)
- [`cli/cmd/ao/cobra_commands_test.go`](cli/cmd/ao/cobra_commands_test.go)
- [`cli/cmd/ao/testutil_test.go`](cli/cmd/ao/testutil_test.go)

### 3. One recent learning is partially stale

[` .agents/learnings/2026-03-05-na-xjw-testing-docs.md`](.agents/learnings/2026-03-05-na-xjw-testing-docs.md) still contains one outdated claim: it says `validate-learning-coherence.sh` is blocked by a frontmatter-only learning. Current repo state no longer matches that:

- `bash scripts/validate-learning-coherence.sh .agents/learnings` passes
- [`scripts/ci-local-release.sh`](scripts/ci-local-release.sh) already runs the coherence step

The learning still contains valid guidance on count verification and language-filtered complexity checks. It should be refreshed, not deleted.

## Baseline Audit

Verified on 2026-03-06:

- Existing canonical pattern artifacts: `find .agents/patterns -maxdepth 1 -type f -name '*.md' | wc -l` = `2`
- Existing learning artifacts: `ls .agents/learnings/*.md | wc -l` = `6`
- Athena hotspot entries available for synthesis: `python3` JSON read of `.agents/mine/latest.json` = `10`
- Athena co-change files available for synthesis: `python3` JSON read of `.agents/mine/latest.json` = `34`
- Outdated lines in stale learning: `rg -n "validate-learning-coherence\\.sh skipped|frontmatter-only file|Skip gocyclo for non-Go epics|count-verification" .agents/learnings/2026-03-05-na-xjw-testing-docs.md` = `3` key guidance lines + `1` stale coherence line

## Recommended Promotion Targets

1. A new canonical pattern for RPI multi-root observability.
2. A new canonical pattern for cmd/ao test hotspot refactoring.
3. A refreshed na-xjw learning that points to those canonical patterns and removes the outdated coherence-gate note.
