---
id: 2026-03-08-next-work-parity-must-cover-producers
type: learning
date: 2026-03-08
utility: 0.8192
maturity: established
tags: [post-mortem, next-work, contracts, codex, validation]
last_decay_at: 2026-03-09T16:50:58-04:00
helpful_count: 5
last_reward: 0.80
reward_count: 5
last_reward_at: 2026-03-09T16:50:58-04:00
confidence: 0.5000
maturity_changed_at: 2026-03-09T16:50:58-04:00
maturity_reason: utility 0.82 >= 0.55, reward_count 5 >= 5, helpful > harmful (5 > 0)
harmful_count: 0
---

# Next-Work Parity Must Validate Producer Examples and Generated Artifacts

The `na-fr0` contract fix correctly introduced a canonical schema, runtime lifecycle updates, and a parity script, but it still shipped stale flat-row append examples in `skills/post-mortem/SKILL.md` and `skills-codex/post-mortem/SKILL.md`. A contract gate that only checks selected reference strings can report success while the system still teaches writers the wrong shape.

For shared queue migrations, the contract is only consistent when every producer surface is validated: schema, runtime, harvested docs, user-facing examples, and generated artifacts. If any producer keeps the legacy form, the repo still has two active contracts.
