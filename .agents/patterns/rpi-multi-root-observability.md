---
type: pattern
source: athena 2026-03-06
date: 2026-03-06
confidence: 0.1667
maturity: provisional
tags: [rpi, observability, worktree, supervisor, events]
last_reward: 0.05
reward_count: 1
last_reward_at: 2026-03-09T12:53:10-04:00
last_decay_at: 2026-03-09T12:53:10-04:00
harmful_count: 1
utility: 0.3650
---

# RPI Multi-Root Observability Pattern

## Pattern

When an RPI run can execute inside an isolated worktree while being supervised from the original repo root, treat observability artifacts as **multi-root state**. Event logs and phased state must be written to the primary root and mirrored to peer roots so `serve`, `status`, and post-run inspection all see the same run history.

## Problem

`ao rpi serve` and related status flows can observe the same run from two filesystem roots:

- the active worktree where the run is executing
- the supervisor repo root where dashboards, watch mode, or post-run tools look for state

If state or events are written to only one root, the control plane and execution plane drift. The symptom is not a crash; it is partial observability: missing SSE data, stale status, or invisible lifecycle transitions.

## Signals in Code

- [`cli/cmd/ao/rpi_c2_events.go`](cli/cmd/ao/rpi_c2_events.go)
  - `appendRPIC2Event()` writes the primary event, then mirrors it to every root returned by `mirrorRootsForEvent()`.
  - Mirror failures are tolerated for non-primary roots and surfaced with warnings instead of aborting the primary write.
- [`cli/cmd/ao/rpi_phased_state.go`](cli/cmd/ao/rpi_phased_state.go)
  - `savePhasedState()` writes the authoritative state first.
  - `mirrorStateToPeers()` mirrors the serialized state to peer roots.
  - Mirror outcomes emit explicit C2 events: `state.mirrored` and `state.mirror.failed`.

## Regression Signals

The pattern is protected by tests that should move with any future refactor:

- [`cli/cmd/ao/rpi_phased_mirror_test.go`](cli/cmd/ao/rpi_phased_mirror_test.go)
  - `TestStateMirrorWrite`
  - `TestStateMirrorSkipsSameRoot`
  - `TestStateMirrorFailureEvent`
- [`cli/cmd/ao/rpi_phased_setup_test.go`](cli/cmd/ao/rpi_phased_setup_test.go)
  - verifies `worktree.created`
  - verifies `worktree.resumed`
  - verifies `worktree.merged`
  - verifies `worktree.removed`
- [`cli/cmd/ao/rpi_c2_events_test.go`](cli/cmd/ao/rpi_c2_events_test.go)
  - verifies event mirroring between worktree and supervisor roots

## Rules

1. Primary writes are authoritative. Never make mirror success a prerequisite for recording the run locally.
2. Peer writes must mirror both state and events. Mirroring only one of them creates a false sense of observability.
3. Mirror failures must be observable. Emit `state.mirror.failed` or equivalent runtime signal instead of silently swallowing the loss.
4. Lifecycle events belong to the same pattern. `worktree.created` and `worktree.removed` are observability data, not just setup noise.
5. Tests must cover both happy-path mirroring and degraded-mode mirroring. A mirror path that only works when the peer root is writable is insufficient coverage.

## When to Apply

- Adding a new RPI artifact under `.agents/rpi/`
- Changing `ao rpi serve`, `ao rpi status`, SSE streaming, or run registry lookup
- Refactoring worktree/supervisor interactions or event persistence

## Anti-Pattern

Writing the artifact only where the current process happens to run and assuming all readers share that root. In RPI worktree mode, that assumption does not hold.
