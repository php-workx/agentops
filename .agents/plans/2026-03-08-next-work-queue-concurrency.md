---
id: plan-2026-03-08-next-work-queue-concurrency
type: plan
date: 2026-03-08
source: "[[.agents/rpi/next-work.jsonl]]"
issue: "na-8g1"
---

# Plan: Make Next-Work Queue Mutation Concurrency-Safe

## Goal

Prevent concurrent autonomous consumers from silently overwriting each other's
`next-work.jsonl` claim, release, failure, or consume updates.

## Why Now

The current queue mutation path rewrites the full file without serialized access
or stale-state checks. That is acceptable for a single consumer, but unsafe once
`/evolve` and `/rpi loop` both claim or finalize work from the same queue.

## Scope

- `cli/cmd/ao/rpi_loop.go`
- `cli/cmd/ao/rpi_loop_test.go`

## Implementation

1. Serialize queue rewrites with the existing CLI `flock` helper so each
   mutation runs as one locked read-modify-write transaction.
2. Add conflict-aware compare-and-swap semantics for item lifecycle updates:
   claims must fail if the item is no longer selectable or is already claimed by
   a different consumer; release/fail/consume should only operate on the current
   owner when ownership is known.
3. Update the loop claim path to surface claim conflicts as non-fatal queue
   contention rather than silent success.
4. Add concurrent regression coverage that exercises two claimers against the
   same item and proves only one claim wins.

## Acceptance

- concurrent claim/release/consume mutations are serialized on disk
- a second claimer cannot silently overwrite an existing claim
- claim conflicts return a deterministic error that callers can distinguish
- focused `cmd/ao` tests cover conflict and multi-consumer behavior

## Validation

```bash
cd cli && go test ./cmd/ao -run 'TestMarkItemClaimedAndReleased|TestMarkItemClaimedConflict|TestMarkItemClaimedConcurrentSingleWinner' -count=1
cd cli && go test ./cmd/ao -run 'TestQueueMarkFailed_Basic|TestMarkItemConsumed_AllItems' -count=1
```
