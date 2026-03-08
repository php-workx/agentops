---
type: pattern
source: na-xjw post-mortem
date: 2026-03-05
confidence: 0.2777
maturity: provisional
tags: [planning, conformance, docs]
utility: 0.2550
last_reward: 0.00
reward_count: 2
last_reward_at: 2026-03-06T10:08:57-05:00
last_decay_at: 2026-03-08T11:06:31-04:00
harmful_count: 2
---

# Count-Verification Conformance Pattern

When a plan issue produces documentation that claims specific numeric counts (job counts, function counts, file counts), add a mechanical conformance check that verifies the count against the actual source.

## Problem

LLM agents generating docs will estimate counts rather than mechanically verify them. In na-xjw, an agent wrote "26-job CI pipeline" when the actual count was 29.

## Solution

For any plan issue with numeric claims, add a conformance check:

```
| Issue | Check Type | Check |
|-------|-----------|-------|
| 5 | count_check | `grep -c "^  [a-z].*:" .github/workflows/validate.yml` matches CI-CD.md claim |
```

Use `grep -c`, `wc -l`, or `jq length` depending on the source.

## When to Apply

- Doc epics that reference pipeline configurations
- Any issue claiming "N functions", "N jobs", "N files"
- Architecture docs with component counts
