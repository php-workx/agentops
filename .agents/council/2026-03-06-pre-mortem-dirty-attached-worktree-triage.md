---
type: pre-mortem
date: 2026-03-06
goal: triage-dirty-foreign-attached-worktrees
issue: na-1uj.6
verdict: PASS
---

# Pre-Mortem: Dirty Attached Worktree Triage

## Verdict

`PASS`

## Main Risks

1. Discarding real local work by treating all dirty worktrees as disposable.
2. Deleting unique local branches before their tip is preserved on `origin`.
3. Accidentally removing the retained active root worktree at `/Users/fullerbt/gt/agentops/crew/nami`.

## Mitigations

1. Only force-remove worktrees in two verified buckets:
   - merged branches with only shared `.beads/` deletions
   - unique branches whose only dirty state is the same shared `.beads/` deletion pattern, after the branch tip is preserved remotely
2. Do not touch:
   - `codex/fix-nightly-run-20260306`
   - `worktree-agent-a2f55515`
   - `worktree-agent-a44397c8`
   - `worktree-agent-a752f190`
   - `worktree-structured-squishing-kahan`
3. Use branch-by-branch commands rather than globbing destructive operations across all worktrees.

## Go / No-Go

Go. The disposition split is concrete enough to implement safely without user intervention.
