---
id: learning-2026-03-08-next-work-queue-locking-owner-checks
type: learning
date: 2026-03-08
source: "post-mortem na-8g1"
---

# Next-Work Queue Writers Need Locking and Owner Checks

When multiple autonomous consumers mutate `next-work.jsonl`, a file lock by
itself is not enough. The writer must also reject stale claim ownership during
claim, release, fail, and consume transitions, or a later consumer can still
finalize the wrong item after winning the lock.
