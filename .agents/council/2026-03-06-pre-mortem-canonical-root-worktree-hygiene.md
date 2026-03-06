---
type: pre-mortem
date: 2026-03-06
goal: canonical-root-worktree-hygiene
epic: na-7oz
verdict: PASS
---

# Pre-Mortem: Canonical Root Worktree Hygiene

## Verdict

`PASS`

## Main Risks

1. The new gate could be too broad and start blocking normal detached debug worktrees.
2. Re-anchoring `main` could fail if the temporary `main` worktree is dirty.
3. Policy text could drift from the actual enforcement script.

## Mitigations

1. Keep the gate intentionally narrow:
   - enforce canonical root cleanliness and branch attachment
   - enforce only branch-attached foreign worktree disposition
   - do not try to ban every detached worktree in the first version
2. Verify the temporary `main` worktree is clean before removal and switch `crew/nami` back to `main` only after that.
3. Put the exact operational rule in `AGENTS.md` and wire the script into both `pre-push` and `ci-local-release`.

## Go / No-Go

Go. The scope is coherent, the repo already has adjacent cleanup tooling, and the change is small enough to validate end to end in one cycle.
