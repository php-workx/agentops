---
type: post-mortem
date: 2026-03-06
issue: na-1uj.6
verdict: PASS
---

# Post-Mortem: `na-1uj.6`

## Outcome

Disposition-based triage succeeded. The repo no longer treats every dirty attached worktree as equally blocked.

## What Worked

- separating inspection from disposition prevented blind cleanup
- distinguishing shared `.beads/` dirtiness from distinct local edits unlocked safe removal of most foreign attachments
- preserving unique branch tips on `origin` before local deletion avoided losing unique commits

## Results

- removed `22` disposable attached worktrees
- preserved `5` active worktrees intentionally
- reduced local branches from `44` to `21`
- reduced worktrees from `31` to `9`

## Learning

When worktree cleanup is blocked by universal dirtiness, the next step is not “inspect harder.” The next step is to classify dirtiness into disposable shared state versus retained active work.

## Follow-Up

No immediate follow-up issue was required from this cycle. The remaining attached worktrees are intentional preserves, not unresolved topology clutter.
