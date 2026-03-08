---
id: post-mortem-2026-03-08-na-8g1
type: post-mortem
date: 2026-03-08
source: "bead na-8g1"
---

# Post-Mortem: Next-Work Queue Concurrency (na-8g1)

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | PASS | The implementation matched the focused plan: locked transactions, conflict semantics, and concurrent tests. |
| Correctness | PASS | Multi-consumer claims no longer silently overwrite each other, and stale owners cannot finalize another worker's item. |
| Learnings | PASS | The queue fix stayed bounded and converted a known post-mortem warning into enforced runtime behavior. |

## What Went Well

- The stale multi-item follow-up backlog was narrowed to one live defect before
  implementation started.
- The repo already had a `flock` helper, so the fix reused existing platform
  behavior instead of inventing a new lock path.
- Validation covered both mutation primitives and loop orchestration behavior.

## What Was Hard

- Shared checkout state still contains stale pre-push validation processes,
  which makes full push-gate confirmation less reliable than the targeted tests.
- The queue contract spans code, queue state, and RPI artifacts, so closing the
  work cleanly required consuming the harvested item as well as shipping code.

## Do Better Next Time

- Add a small shared queue-mutation helper earlier when new autonomous writers
  are introduced instead of waiting for a post-mortem finding.
- Treat stuck validation processes as an environment smell worth cleaning
  before starting a new push cycle.

## Learning Extracted

- Shared queue writers need both serialized disk mutation and owner-aware
  lifecycle checks. Either one alone leaves a silent corruption path open.

## Next Work

- No new follow-up defects were found inside the bounded `na-8g1` scope.

## Status

[x] CLOSED - Work complete, learnings captured
[ ] FOLLOW-UP - Issues need addressing
