---
type: research
date: 2026-03-06
topic: attached-worktree-inspection
---

# Research: Attached Worktree Inspection

## Executive Summary

Every foreign attached worktree in the current topology is dirty. None is currently safe for blind removal.

The attached set contains:

- `6` unique branches outside `main`
- `21` merged branches already reachable from `main`
- `27` dirty worktrees total

Most of the merged Claude worktrees share the same `.beads/` deletion footprint, but several attached worktrees contain distinct code, test, or knowledge edits. That means the cleanup issue cannot be completed safely with a blanket `git worktree remove` pass.

## Method

Verified with:

```bash
git for-each-ref --format='%(refname:short)|%(worktreepath)|%(objectname:short)' refs/heads
git merge-base --is-ancestor <branch> main
git -C <worktree-path> status --short
```

## Inventory

| Branch | Worktree | SHA | Merge Status | Dirtiness | Changed Paths |
|---|---|---|---|---|---:|
| `beads-sync` | `/Users/fullerbt/gt/agentops/crew/nami/.git/beads-worktrees/beads-sync` | `b8909c08` | `unique` | `dirty` | 1 |
| `codex/fix-nightly-run-20260306` | `/Users/fullerbt/gt/agentops/crew/nami` | `41819476` | `unique` | `dirty` | 3 |
| `epic/add-ambiguity-detection-to-readsessionbyid` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-ambiguity-detection-to-readsessionbyid` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-duplicate-marker-detection-to-parsemanagedbl` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-duplicate-marker-detection-to-parsemanagedbl` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-handler-tests-for-batch-forge-and-batch-prom` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-handler-tests-for-batch-forge-and-batch-prom` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-memrl-feedback-loop-health-check-to-ci` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-memrl-feedback-loop-health-check-to-ci` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-merge-flag-to-ao-dedup` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-merge-flag-to-ao-dedup` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-migratev1tov2-and-killallchildren-package-le` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-migratev1tov2-and-killallchildren-package-le` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-preflight-existence-checks-for-checkpoint-po` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-preflight-existence-checks-for-checkpoint-po` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/add-template-existence-lint-test-for-validtempla` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-template-existence-lint-test-for-validtempla` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/assert-antistars-values-in-goals-init-test-go` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/assert-antistars-values-in-goals-init-test-go` | `efd58d56` | `unique` | `dirty` | 3 |
| `epic/audit-signal-notify-sites-for-goroutine-leak` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/audit-signal-notify-sites-for-goroutine-leak` | `d5209189` | `unique` | `dirty` | 3 |
| `epic/clean-dead-code-in-measure-test-go` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/clean-dead-code-in-measure-test-go` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/establish-prior-findings-resolution-tracking-acr` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/establish-prior-findings-resolution-tracking-acr` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/extend-ao-dedup-to-scan-agents-patterns` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/extend-ao-dedup-to-scan-agents-patterns` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/extract-syncmemory-testable-function-from-runmem` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/extract-syncmemory-testable-function-from-runmem` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/fix-ci-local-release-sh-invocation-inconsistency` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/fix-ci-local-release-sh-invocation-inconsistency` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/fix-truncatetext-in-inject-go-to-use-rune-safe-t` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/fix-truncatetext-in-inject-go-to-use-rune-safe-t` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/move-memory-sync-inside-forge-success-gate` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/move-memory-sync-inside-forge-success-gate` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/reduce-updatemarkdownfrontmatter-complexity` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/reduce-updatemarkdownfrontmatter-complexity` | `3fef2f41` | `merged` | `dirty` | 3 |
| `epic/remove-findmemoryfile-broad-contains-fallback` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/remove-findmemoryfile-broad-contains-fallback` | `ccd3173e` | `unique` | `dirty` | 3 |
| `epic/require-command-surface-parity-completion-checkl` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/require-command-surface-parity-completion-checkl` | `3fef2f41` | `merged` | `dirty` | 3 |
| `worktree-agent-a2f55515` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/agent-a2f55515` | `ed10f54a` | `merged` | `dirty` | 3 |
| `worktree-agent-a44397c8` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/agent-a44397c8` | `ed10f54a` | `merged` | `dirty` | 7 |
| `worktree-agent-a6f2ef41` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/add-ambiguity-detection-to-readsessionbyid/.claude/worktrees/agent-a6f2ef41` | `7c6ed2c4` | `unique` | `dirty` | 3 |
| `worktree-agent-a752f190` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/agent-a752f190` | `ed10f54a` | `merged` | `dirty` | 6 |
| `worktree-structured-squishing-kahan` | `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/structured-squishing-kahan` | `41eceabf` | `merged` | `dirty` | 6 |

## Dirtiness Patterns

### Shared `.beads/` deletions across most attached Claude worktrees

These branches all show the same deletion set:

- `D .beads/.gitignore`
- `D .beads/README.md`
- `D .beads/config.yaml`

That shared pattern appears on:

- `epic/add-ambiguity-detection-to-readsessionbyid`
- `epic/add-duplicate-marker-detection-to-parsemanagedbl`
- `epic/add-handler-tests-for-batch-forge-and-batch-prom`
- `epic/add-memrl-feedback-loop-health-check-to-ci`
- `epic/add-merge-flag-to-ao-dedup`
- `epic/add-migratev1tov2-and-killallchildren-package-le`
- `epic/add-preflight-existence-checks-for-checkpoint-po`
- `epic/add-template-existence-lint-test-for-validtempla`
- `epic/assert-antistars-values-in-goals-init-test-go`
- `epic/audit-signal-notify-sites-for-goroutine-leak`
- `epic/clean-dead-code-in-measure-test-go`
- `epic/establish-prior-findings-resolution-tracking-acr`
- `epic/extend-ao-dedup-to-scan-agents-patterns`
- `epic/extract-syncmemory-testable-function-from-runmem`
- `epic/fix-ci-local-release-sh-invocation-inconsistency`
- `epic/fix-truncatetext-in-inject-go-to-use-rune-safe-t`
- `epic/move-memory-sync-inside-forge-success-gate`
- `epic/reduce-updatemarkdownfrontmatter-complexity`
- `epic/remove-findmemoryfile-broad-contains-fallback`
- `epic/require-command-surface-parity-completion-checkl`
- `worktree-agent-a6f2ef41`

Even though that pattern looks systematic rather than intentional branch work, it still means those worktrees are not clean.

### Distinct dirty states that block blanket removal

`beads-sync`:

```text
D .beads/metadata.json
```

`codex/fix-nightly-run-20260306`:

```text
M .agents/learnings/2026-02-26-parallel-worktree-test-sprint.md
 M .agents/learnings/2026-02-26-swarm-remediation-patterns.md
 M .agents/learnings/2026-02-26-worktree-refactoring-pattern.md
```

`worktree-agent-a2f55515`:

```text
?? cli/cmd/ao/fuzz_context_test.go
?? cli/cmd/ao/fuzz_jsonl_test.go
?? cli/internal/ratchet/fuzz_test.go
```

`worktree-agent-a44397c8`:

```text
M cli/cmd/ao/cov13_gate_coverage_test.go
 M cli/cmd/ao/cov5_final_coverage_test.go
 M cli/cmd/ao/cov7_more_coverage_test.go
 M cli/cmd/ao/maturity_deep_coverage_test.go
 M cli/cmd/ao/session_close_coverage_test.go
 M cli/cmd/ao/vibe_check_coverage_test.go
?? scripts/audit-assertion-density.sh
```

`worktree-agent-a752f190`:

```text
M cli/go.mod
 M cli/go.sum
?? cli/cmd/ao/error_snapshot_test.go
?? cli/cmd/ao/golden_output_test.go
?? cli/cmd/ao/testdata/errors/
?? cli/cmd/ao/testdata/golden/
```

`worktree-structured-squishing-kahan`:

```text
M .agents/learnings/2026-02-26-parallel-worktree-test-sprint.md
 M .agents/learnings/2026-02-26-swarm-remediation-patterns.md
 M .agents/learnings/2026-02-26-worktree-refactoring-pattern.md
 M .agents/learnings/2026-03-05-na-xjw-testing-docs.md
 M .agents/patterns/count-verification-conformance.md
 M .agents/patterns/vibe-language-filter.md
```

## Conclusions

1. `na-1uj.4` is complete: the full foreign attached set has been inspected and recorded.
2. `na-1uj.5` is not currently safe to execute as written because its intended end state assumes removable attached worktrees.
3. The next safe move is selective triage, not blanket cleanup:
   - either clean or preserve each dirty worktree intentionally
   - then remove only worktrees that are confirmed clean or intentionally discarded
