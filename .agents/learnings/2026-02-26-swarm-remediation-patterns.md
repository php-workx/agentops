---
utility: 0.6470
last_reward: 0.80
reward_count: 2
last_reward_at: 2026-02-26T21:45:02-05:00
confidence: 0.2267
last_decay_at: 2026-03-15T09:36:20+01:00
helpful_count: 1
---
# Swarm Remediation Patterns

**Discovered:** 2026-02-26 (Post-Mortem Findings Swarm)
**Confidence:** 0.9
**Tags:** swarm, worktree, parallel, remediation, process

## Pattern

When a post-mortem produces a batch of improvement items, dispatch them as a parallel swarm:

1. Post-mortem produces structured items (next-work.jsonl)
2. Each item becomes one agent task in an isolated worktree
3. Agents execute in parallel — no shared file modifications
4. Single integration commit merges all results
5. Run post-mortem on the swarm itself (recursive improvement)

## Key Constraints

- **Shell hygiene**: Use `/bin/cp -f` not `cp` in agent environments — user aliases may be interactive
- **Scope escape**: When an agent finds the fix exceeds its mandate, it should produce an audit, not force a partial fix (Item 5 model)
- **File overlap**: Pre-scan agent task boundaries to ensure no two agents modify the same file
- **Worktree discipline**: ALL agents must use worktree branches, even for trivial changes — no direct commits to main
- **Canary item**: Include one trivially-scoped item per batch as a dispatch health signal

## Metrics

- 7 parallel agents, 6 produced code, 1 produced audit
- +859/-216 lines across 16 files
- ~10 min wall-clock parallel execution
- 85.7% resolution rate (6/7 items, 1 correctly deferred)
- 3,225 total test functions after integration
