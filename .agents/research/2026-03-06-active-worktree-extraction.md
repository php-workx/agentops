---
type: research
date: 2026-03-06
topic: active-worktree-extraction
issue: na-lkp
---

# Research: Active Worktree Extraction

## Outcome

All five retained active worktrees were drained of useful state.

Four removable linked worktrees were preserved to remote branches and removed outright. The fifth path at `/Users/fullerbt/gt/agentops/crew/nami` was also preserved, but it is the repository's primary worktree and common `.git` anchor, so it was detached instead of deleted.

## Preserved Remote Branches

| Original worktree | Preserved remote branch | Disposition |
|---|---|---|
| `codex/fix-nightly-run-20260306` root worktree | `origin/codex/preserve-nightly-learning-metrics` | committed, pushed, local branch deleted, root worktree detached |
| `worktree-agent-a2f55515` | `origin/codex/preserve-a2f55515-fuzz-tests` | committed, pushed, local worktree removed |
| `worktree-agent-a44397c8` | `origin/codex/preserve-a44397c8-coverage-tests` | committed, pushed, local worktree removed |
| `worktree-agent-a752f190` | `origin/codex/preserve-a752f190-golden-tests` | committed, pushed, local worktree removed |
| `worktree-structured-squishing-kahan` | `origin/codex/preserve-kahan-knowledge-metrics` | committed, pushed, local worktree removed |

## Final Topology

Remaining branch-attached worktrees:

- `main`
- `codex/branch-topology-rpi-fix`

Remaining detached worktrees:

- `/Users/fullerbt/gt/agentops/crew/nami`
- `/Users/fullerbt/.codex/worktrees/7f32/nami`
- `/Users/fullerbt/.codex/worktrees/9923/nami`

## Constraint

`/Users/fullerbt/gt/agentops/crew/nami` cannot be removed with `git worktree remove` because it owns the repository's common `.git` directory. In the current worktree:

```bash
git rev-parse --git-common-dir
```

returns:

```text
/Users/fullerbt/gt/agentops/crew/nami/.git
```

That means deleting that directory would delete the common Git metadata for all linked worktrees. Removing it safely requires a separate Git-dir migration or repository re-anchoring step.
