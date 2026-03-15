---
utility: 0.1447
last_reward: 0.25
reward_count: 8
last_reward_at: 2026-03-15T09:40:18+01:00
confidence: 0.6154
last_decay_at: 2026-03-15T09:40:18+01:00
harmful_count: 5
maturity: anti-pattern
maturity_changed_at: 2026-03-09T21:52:08-04:00
maturity_reason: utility 0.16 <= 0.20 and harmful_count 3 >= 3
---
# Learnings

Extracted lessons from sessions, post-mortems, and retrospectives.

## Naming Convention
- `YYYY-MM-DD-*.md` (date-prefixed)
- Each file has YAML frontmatter: `utility`, `maturity`, `tags`

## Search
- `ao lookup --query "topic"` — ranked retrieval by relevance + freshness
- `ao lookup <id>` — fetch specific learning by ID
- `Grep` in `.agents/learnings/` as fallback
