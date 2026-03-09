---
id: 2026-03-08-codex-guardrails-must-be-atomic
type: learning
date: 2026-03-08
utility: 0.6321
maturity: provisional
tags: [codex, skills, generated-artifacts, validation, ci]
last_reward: 0.80
reward_count: 1
last_reward_at: 2026-03-08T19:13:21-04:00
confidence: 0.1646
last_decay_at: 2026-03-09T16:50:32-04:00
helpful_count: 1
harmful_count: 1
---

# Codex Guardrails Must Land as One Atomic Set

The March 8 Codex-first follow-up showed that changing only one layer at a time leaves avoidable drift. The durable unit is not just the source skill or just the generated artifact. It is the full set:

1. canonical source in `skills/`
2. Codex-specific override in `skills-codex-overrides/`
3. regenerated output in `skills-codex/`
4. local validation guard
5. CI enforcement

When one layer lands later, the repo temporarily carries a false sense of closure. `na-cr9` illustrated this directly: the first guard checked override presence, then `dd3dee64` had to tighten it to real prompt parity, and CI still did not enforce that guard.
