---
id: 2026-03-08-next-work-migrations-need-schema-and-locking
type: learning
date: 2026-03-08
utility: 0.2767
maturity: provisional
tags: [rpi, next-work, schema, concurrency, contracts]
last_reward: 0.00
reward_count: 4
last_reward_at: 2026-03-09T21:52:08-04:00
confidence: 0.4121
last_decay_at: 2026-03-15T09:36:20+01:00
helpful_count: 1
harmful_count: 4
---

# Next-Work Migrations Need Schema and Locking in the Same Wave

The March 8 queue changes improved behavior by moving `next-work` toward per-item claim and release semantics, but they also exposed how quickly a queue loses a single source of truth if the code changes faster than the contract. The runtime now rewrites queue entries and tracks per-item state, while the published schema still describes entry-level consumption and append-only writes.

The follow-on lesson is straightforward: for shared queue state, behavior changes are not complete until schema, examples, writer semantics, and concurrency controls all change together. Otherwise the system becomes locally correct but globally ambiguous.
