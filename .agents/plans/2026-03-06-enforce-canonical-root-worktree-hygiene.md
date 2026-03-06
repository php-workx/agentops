---
id: plan-2026-03-06-enforce-canonical-root-worktree-hygiene
type: plan
date: 2026-03-06
source: "[[.agents/research/2026-03-06-canonical-root-worktree-hygiene.md]]"
epic: na-7oz
---

# Plan: Enforce Canonical Root Worktree Hygiene

## Context

The repo needs one clear operating model: `crew/nami` is the permanent anchor, and all disposable agent work happens elsewhere. The fix must be small enough to ship immediately and strong enough to prevent a repeat of the recent worktree recovery effort.

The implementation will combine:

1. a documented workflow policy in `AGENTS.md`
2. a worktree disposition gate script
3. wiring in `pre-push` and `ci-local-release`
4. a one-time re-anchor of `main` back to `crew/nami`

## Files to Modify

| File | Change |
|---|---|
| `AGENTS.md` | Add canonical-root policy and session-close worktree disposition rule; update local checklist |
| `scripts/check-worktree-disposition.sh` | **NEW** gate that validates canonical-root and attached-worktree topology |
| `tests/scripts/test-worktree-disposition.sh` | **NEW** coverage for the gate script |
| `scripts/pre-push-gate.sh` | Call the worktree disposition gate |
| `tests/scripts/pre-push-gate.bats` | Update expectations for the new gate |
| `scripts/ci-local-release.sh` | Add the worktree disposition gate to the local release flow |

## Implementation

### 1. Document the workflow contract

Add a short section to `AGENTS.md` that defines:

- canonical root = `crew/nami`
- canonical root should normally host `main`
- agents do not do temporary work in canonical root
- foreign worktrees must end as `merged`, `preserved`, `exported`, or `deleted`

Also update the “Landing the Plane” checklist so cleanup explicitly includes worktree disposition validation.

### 2. Add a worktree disposition gate

Create `scripts/check-worktree-disposition.sh` that:

- resolves all worktrees via `git worktree list --porcelain`
- identifies the primary/canonical worktree as the one whose `git-dir` equals `git-common-dir`
- fails if the canonical worktree is detached
- fails if the canonical worktree is not on `main`
- fails if the canonical worktree is dirty
- fails if any other branch-attached worktree exists besides the current branch in the current worktree

The script should support a small env override for extra allowed attached branches when needed for special flows.

### 3. Wire the gate into existing workflows

- call the script from `scripts/pre-push-gate.sh`
- call the script from `scripts/ci-local-release.sh`
- add/update tests accordingly

### 4. Re-anchor the repo

- remove the temporary linked worktree currently holding `main`
- switch `crew/nami` back to `main`
- verify the new gate passes in the live repo

## Verification

1. Canonical root is on `main` and clean:

```bash
git -C /Users/fullerbt/gt/agentops/crew/nami status --short --branch
```

2. Gate passes from the active task worktree:

```bash
bash scripts/check-worktree-disposition.sh
```

3. Only canonical `main` and the current task branch are branch-attached:

```bash
git for-each-ref --format='%(refname:short)|%(worktreepath)' refs/heads | \
  awk -F'|' '$2 != ""'
```

4. Tests pass:

```bash
tests/scripts/test-worktree-disposition.sh
bats tests/scripts/pre-push-gate.bats
```
