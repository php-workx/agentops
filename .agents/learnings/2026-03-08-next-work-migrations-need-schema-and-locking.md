---
id: 2026-03-08-next-work-migrations-need-schema-and-locking
type: learning
date: 2026-03-08
utility: 0.9
maturity: provisional
tags: [rpi, next-work, schema, concurrency, contracts]
---

# Next-Work Migrations Need Schema and Locking in the Same Wave

The March 8 queue changes improved behavior by moving `next-work` toward per-item claim and release semantics, but they also exposed how quickly a queue loses a single source of truth if the code changes faster than the contract. The runtime now rewrites queue entries and tracks per-item state, while the published schema still describes entry-level consumption and append-only writes.

The follow-on lesson is straightforward: for shared queue state, behavior changes are not complete until schema, examples, writer semantics, and concurrency controls all change together. Otherwise the system becomes locally correct but globally ambiguous.
