---
utility: 0.5030
last_reward: 0.80
reward_count: 1
last_reward_at: 2026-03-04T18:24:26-05:00
confidence: 0.4664
last_decay_at: 2026-03-09T16:50:32-04:00
---

# Worktree Refactoring Pattern

When refactoring code across multiple files in parallel agents, use git worktrees to isolate each agent's changes. This prevents merge conflicts and build breaks from concurrent edits to shared files.

## Key Points

- Create one worktree per agent or per epic
- Workers operate in isolated branches, merged back by the lead
- Worktree isolation prevents the #1 swarm failure mode: file conflicts between parallel workers
