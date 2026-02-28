---
utility: 0.7904
last_reward: 0.80
reward_count: 24
last_reward_at: 2026-02-27T23:29:23-05:00
confidence: 0.8276
last_decay_at: 2026-02-27T23:29:23-05:00
helpful_count: 23
maturity: established
maturity_changed_at: 2026-02-26T22:35:47-05:00
maturity_reason: utility 0.73 >= 0.55, reward_count 5 >= 5, helpful > harmful (4 > 0)
---
# Parallel Worktree Test Sprint Pattern

**Discovered:** 2026-02-26 (CLI Test Coverage Sprint)
**Confidence:** 0.9
**Tags:** testing, parallelism, worktree, go, coverage

## Pattern

When closing a large test coverage gap across many files in a Go package:

1. **Research first**: Enumerate all source files, identify gaps via `comm -23` between source and test file lists
2. **Organize into waves**: Group by subsystem (goals, ratchet, metrics, etc.) ensuring no wave modifies shared files
3. **Pre-flight**: Pull from main, `make build`, verify clean state, confirm wave boundaries don't overlap
4. **Spawn parallel agents** in isolated git worktrees (one per wave)
5. **Post-merge gate**: Run full `make build && make test && go vet ./...` on the integrated result
6. **Fix cross-wave issues**: Symbol collisions in same Go package, import additions

## Key Constraints

- Go's flat package model means all `_test.go` files share a namespace — pre-create shared helpers or assign unique prefixes
- Any test that shells out to a compiled binary requires `make build` first
- `os.Chdir` in tests is process-global — prevents `t.Parallel()` and requires defer-restore
- Always use an integration branch when merging 3+ worktrees

## Metrics

- 5 parallel agents, 44 test files, 506 test functions, 12,644 lines
- Coverage: 59% -> 97% (66/112 -> 109/112 command files)
- Total elapsed: ~45 min parallel execution, 1 post-merge fix (go vet)
