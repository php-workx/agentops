---
id: pre-mortem-2026-03-08-next-work-queue-concurrency
type: pre-mortem
date: 2026-03-08
source: "[[.agents/plans/2026-03-08-next-work-queue-concurrency.md]]"
issue: "na-8g1"
---

# Pre-Mortem: Next-Work Queue Concurrency

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Missing-Requirements | PASS | Scope is tight and names the exact mutation surfaces that need protection. |
| Feasibility | PASS | The CLI already has `flock` helpers, so the fix fits existing patterns. |
| Scope | PASS | This is one correctness bug, not a broad queue redesign. |
| Spec-Completeness | PASS | Acceptance and validation both require conflict semantics plus concurrent tests. |

## Shared Findings

- The older post-mortem follow-up plan is stale for implementation because
  multiple items are already closed.
- The harvested queue-concurrency item is the highest-value remaining live fix.
- A file lock alone is insufficient; the mutation API also needs stale-state or
  owner-aware checks to prevent silent claim theft.

## Concerns Raised

- Owner-aware release/finalize behavior must not break legacy flat-row entries.
- Concurrent tests need deterministic assertions so they do not become flaky.

## Recommendation

Proceed with the focused `na-8g1` implementation plan. Keep the change inside
`cli/cmd/ao/rpi_loop.go` and its tests, reuse the existing `flock` helper, and
ship only when concurrent-claim coverage proves a single-winner outcome.

## Decision Gate

[x] PROCEED - Council passed, ready to implement
[ ] ADDRESS - Fix concerns before implementing
[ ] RETHINK - Fundamental issues, needs redesign
