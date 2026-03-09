---
id: 2026-03-08-codex-gates-need-local-ci-failure-path-parity
type: learning
date: 2026-03-08
utility: 0.8420
maturity: provisional
tags: [codex, validation, ci, tests, post-mortem]
last_reward: 0.80
reward_count: 1
last_reward_at: 2026-03-08T19:13:21-04:00
confidence: 0.1646
last_decay_at: 2026-03-09T16:50:32-04:00
helpful_count: 1
---

# Codex Gate Adoption Needs Local, CI, and Failure-Path Parity

`na-bnr` improved the Codex contract and prompt-validation model, but the post-mortem found that the enforcement stack still landed unevenly. Local validation and pre-push now run generated-artifact parity, install-bundle parity, headless runtime validation, backbone prompt checks, and override coverage, while CI only runs a subset and BATS only proves happy-path wiring.

For Codex-first validation work, the durable unit is not just “new script plus one CI step.” It is:

1. the validator itself
2. local blocking gate wiring
3. CI enforcement of the same blocking surface
4. negative-path tests proving the gate fails when the validator fails

If one of those layers lags, the repo reports a stronger Codex contract than it actually enforces.
