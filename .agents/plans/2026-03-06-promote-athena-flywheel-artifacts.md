---
type: plan
date: 2026-03-06
goal: promote-athena-flywheel-artifacts
epic: na-9w6
---

# Plan: Promote Athena Flywheel Artifacts

## Goal

Convert Athena's March 6 knowledge-gap findings into canonical pattern artifacts and refresh the stale na-xjw learning so the flywheel promotes repeated fixes into reusable guidance.

## Baseline Audit

Verified mechanically before decomposition:

| Metric | Command | Result |
|---|---|---|
| Existing pattern artifacts | `find .agents/patterns -maxdepth 1 -type f -name '*.md' \| wc -l` | `2` |
| Existing learning artifacts | `ls .agents/learnings/*.md \| wc -l` | `6` |
| Athena hotspot entries | `python3` read of `.agents/mine/latest.json` | `10` |
| Athena co-change files | `python3` read of `.agents/mine/latest.json` | `34` |
| Current stale-learning claim lines | `rg -n "validate-learning-coherence\\.sh skipped|frontmatter-only file|Skip gocyclo for non-Go epics|count-verification" .agents/learnings/2026-03-05-na-xjw-testing-docs.md` | `4` matched lines |

## Files to Modify

| File | Change |
|---|---|
| `.agents/research/2026-03-06-athena-flywheel-followthrough.md` | **NEW** discovery artifact grounding the promotion work |
| `.agents/patterns/rpi-multi-root-observability.md` | **NEW** canonical pattern for supervisor/worktree event and state mirroring |
| `.agents/patterns/cmd-ao-test-hotspot-refactor.md` | **NEW** canonical pattern for taming high-complexity cmd/ao tests |
| `.agents/learnings/2026-03-05-na-xjw-testing-docs.md` | Refresh stale guidance, keep valid guidance, and point to canonical patterns |

## Issue Plan

### Wave 1

#### `na-9w6.1` Write canonical RPI multi-root observability pattern

**Files**

- `.agents/patterns/rpi-multi-root-observability.md`

**Implementation detail**

- Capture the invariant around mirrored state and event writes using:
  - `appendRPIC2Event()` and `mirrorRootsForEvent()` in [`cli/cmd/ao/rpi_c2_events.go`](cli/cmd/ao/rpi_c2_events.go)
  - `savePhasedState()` and `mirrorStateToPeers()` in [`cli/cmd/ao/rpi_phased_state.go`](cli/cmd/ao/rpi_phased_state.go)
- Cite the tests that prove the behavior:
  - `TestStateMirrorWrite`
  - `TestStateMirrorFailureEvent`
  - worktree lifecycle checks in [`cli/cmd/ao/rpi_phased_setup_test.go`](cli/cmd/ao/rpi_phased_setup_test.go)
- Include failure mode guidance: primary writes must be authoritative, mirror writes must degrade gracefully, and failures must remain observable through C2 events rather than silently disappearing.

**Acceptance criteria**

- A new pattern file exists with problem, invariant, implementation signals, test signals, and when-to-apply sections.
- The pattern explicitly names both event mirroring and state mirroring.

**Conformance**

```json
{"files_exist":[".agents/patterns/rpi-multi-root-observability.md"],"content_check":{"file":".agents/patterns/rpi-multi-root-observability.md","pattern":"mirrorRootsForEvent|state.mirrored|state.mirror.failed|worktree.created"}}
```

#### `na-9w6.3` Write canonical cmd/ao test hotspot refactor pattern

**Files**

- `.agents/patterns/cmd-ao-test-hotspot-refactor.md`

**Implementation detail**

- Use Athena hotspot examples from:
  - [`cli/cmd/ao/knowledge_loop_e2e_test.go`](cli/cmd/ao/knowledge_loop_e2e_test.go)
  - [`cli/cmd/ao/workflow_integration_test.go`](cli/cmd/ao/workflow_integration_test.go)
  - [`cli/cmd/ao/rpi_loop_supervisor_test.go`](cli/cmd/ao/rpi_loop_supervisor_test.go)
  - [`cli/cmd/ao/cobra_commands_test.go`](cli/cmd/ao/cobra_commands_test.go)
- Tie mitigation guidance to existing helper infrastructure in [`cli/cmd/ao/testutil_test.go`](cli/cmd/ao/testutil_test.go):
  - `captureJSONStdout`
  - `chdirTemp`
  - `chdirTo`
  - `setupAgentsDir`
- Define triggers for promotion: recent edits + CC > 25 + mixed setup/assertion phases in one test function.

**Acceptance criteria**

- A new pattern file exists with hotspot symptoms, refactor moves, helper reuse guidance, and prioritization rules.
- The pattern includes at least three concrete hotspot test names and at least two reusable helpers.

**Conformance**

```json
{"files_exist":[".agents/patterns/cmd-ao-test-hotspot-refactor.md"],"content_check":{"file":".agents/patterns/cmd-ao-test-hotspot-refactor.md","pattern":"TestKnowledgeLoopE2E|TestWorkflow_NotebookUpdateCycle|TestRunSupervisorLanding_SyncPush_RebaseFailureAborts|captureJSONStdout|chdirTo"}}
```

### Wave 2

#### `na-9w6.2` Refresh stale na-xjw learning with current repo state

**Files**

- `.agents/learnings/2026-03-05-na-xjw-testing-docs.md`

**Implementation detail**

- Remove or rewrite the obsolete statement that `validate-learning-coherence.sh` is blocked by a frontmatter-only learning.
- Keep the still-valid guidance on:
  - count verification for numeric doc claims
  - language-filtered complexity analysis
  - pre-testing scripts before wiring them into CI
- Add explicit references to the promoted patterns:
  - `.agents/patterns/count-verification-conformance.md`
  - `.agents/patterns/vibe-language-filter.md`
  - the two new canonical pattern files from Wave 1

**Acceptance criteria**

- The learning no longer claims the coherence script is blocked.
- The learning still preserves its valid operational guidance.
- The learning points at canonical patterns instead of duplicating promoted content.

**Conformance**

```json
{"content_check":{"file":".agents/learnings/2026-03-05-na-xjw-testing-docs.md","pattern":"count-verification|language filter|rpi-multi-root-observability|cmd-ao-test-hotspot-refactor"},"command":"! rg -q \"validate-learning-coherence\\.sh skipped|frontmatter-only file\" .agents/learnings/2026-03-05-na-xjw-testing-docs.md"}
```

## Verification

1. `bash scripts/validate-learning-coherence.sh .agents/learnings`
2. `rg -n "mirrorRootsForEvent|state.mirrored|state.mirror.failed|TestKnowledgeLoopE2E|captureJSONStdout" .agents/patterns .agents/learnings/2026-03-05-na-xjw-testing-docs.md`
3. `git diff -- .agents/patterns .agents/learnings .agents/research`

## Wave Structure

- Wave 1: `na-9w6.1`, `na-9w6.3`
- Wave 2: `na-9w6.2`

Wave 2 depends on Wave 1 because the refreshed learning should reference the canonical patterns rather than invent new standalone wording.
