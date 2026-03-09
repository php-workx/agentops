---
type: learning
source: retro-quick
date: 2026-03-08
---

# Learning: Pre-Push Checks Should Surface Worktree Blockers Early

**Category**: process
**Confidence**: medium

## What We Learned

`git push` can fail because of an unrelated attached worktree even when the current branch is clean. Running `bash scripts/check-worktree-disposition.sh` before push moves that failure earlier, makes the problem obvious, and avoids debugging the wrong branch state.

## Source

Quick capture via `$retro --quick`
