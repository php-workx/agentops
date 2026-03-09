---
id: 2026-03-08-next-work-parity-must-cover-producers
type: learning
date: 2026-03-08
utility: 0.8308
maturity: candidate
tags: [post-mortem, next-work, contracts, codex, validation]
last_decay_at: 2026-03-09T09:30:26-04:00
helpful_count: 3
last_reward: 0.80
reward_count: 3
last_reward_at: 2026-03-09T09:30:26-04:00
confidence: 0.3750
maturity_changed_at: 2026-03-09T09:30:26-04:00
maturity_reason: utility 0.83 >= 0.55 and reward_count 3 >= 3
---

# Next-Work Parity Must Validate Producer Examples and Generated Artifacts

The `na-fr0` contract fix correctly introduced a canonical schema, runtime lifecycle updates, and a parity script, but it still shipped stale flat-row append examples in `skills/post-mortem/SKILL.md` and `skills-codex/post-mortem/SKILL.md`. A contract gate that only checks selected reference strings can report success while the system still teaches writers the wrong shape.

For shared queue migrations, the contract is only consistent when every producer surface is validated: schema, runtime, harvested docs, user-facing examples, and generated artifacts. If any producer keeps the legacy form, the repo still has two active contracts.
