---
type: research
date: 2026-03-06
topic: dirty-attached-worktree-dispositions
issue: na-1uj.6
source: "[[.agents/research/2026-03-06-attached-worktree-inspection.md]]"
---

# Research: Dirty Attached Worktree Dispositions

## Executive Summary

The inspection report was enough to stop blanket cleanup, but it was not yet a disposition plan. The attached foreign set now breaks into three actionable classes:

1. remove now: merged worktrees whose only dirtiness is the shared `.beads/` deletion pattern
2. preserve commit, then remove: unique branches whose only dirtiness is that same `.beads/` deletion pattern
3. retain as active: worktrees with distinct local edits or root-worktree semantics

That means the cleanup can restart safely if it stops treating all dirty worktrees the same.

## Verified State

Current foreign attached set:

- `27` foreign attached worktrees
- `21` merged to `main`
- `6` unique relative to `main`

Distinct local-edit worktrees:

- `codex/fix-nightly-run-20260306`
- `worktree-agent-a2f55515`
- `worktree-agent-a44397c8`
- `worktree-agent-a752f190`
- `worktree-structured-squishing-kahan`

Shared `.beads/`-only dirty worktrees:

- merged:
  - `epic/add-ambiguity-detection-to-readsessionbyid`
  - `epic/add-duplicate-marker-detection-to-parsemanagedbl`
  - `epic/add-handler-tests-for-batch-forge-and-batch-prom`
  - `epic/add-memrl-feedback-loop-health-check-to-ci`
  - `epic/add-merge-flag-to-ao-dedup`
  - `epic/add-migratev1tov2-and-killallchildren-package-le`
  - `epic/add-preflight-existence-checks-for-checkpoint-po`
  - `epic/add-template-existence-lint-test-for-validtempla`
  - `epic/clean-dead-code-in-measure-test-go`
  - `epic/establish-prior-findings-resolution-tracking-acr`
  - `epic/extend-ao-dedup-to-scan-agents-patterns`
  - `epic/extract-syncmemory-testable-function-from-runmem`
  - `epic/fix-ci-local-release-sh-invocation-inconsistency`
  - `epic/fix-truncatetext-in-inject-go-to-use-rune-safe-t`
  - `epic/move-memory-sync-inside-forge-success-gate`
  - `epic/reduce-updatemarkdownfrontmatter-complexity`
  - `epic/require-command-surface-parity-completion-checkl`
- unique:
  - `epic/assert-antistars-values-in-goals-init-test-go`
  - `epic/audit-signal-notify-sites-for-goroutine-leak`
  - `epic/remove-findmemoryfile-broad-contains-fallback`
  - `worktree-agent-a6f2ef41`

Special-case attached worktree:

- `beads-sync`
  - unique branch
  - upstream exists: `origin/beads-sync`
  - dirty state is only `D .beads/metadata.json`
  - safe disposition: remove worktree and local branch, keep remote branch as preserved tip

## Proposed Dispositions

### Remove now

These branches are merged to `main` and only dirty because of the shared `.beads/` deletions:

- `epic/add-ambiguity-detection-to-readsessionbyid`
- `epic/add-duplicate-marker-detection-to-parsemanagedbl`
- `epic/add-handler-tests-for-batch-forge-and-batch-prom`
- `epic/add-memrl-feedback-loop-health-check-to-ci`
- `epic/add-merge-flag-to-ao-dedup`
- `epic/add-migratev1tov2-and-killallchildren-package-le`
- `epic/add-preflight-existence-checks-for-checkpoint-po`
- `epic/add-template-existence-lint-test-for-validtempla`
- `epic/clean-dead-code-in-measure-test-go`
- `epic/establish-prior-findings-resolution-tracking-acr`
- `epic/extend-ao-dedup-to-scan-agents-patterns`
- `epic/extract-syncmemory-testable-function-from-runmem`
- `epic/fix-ci-local-release-sh-invocation-inconsistency`
- `epic/fix-truncatetext-in-inject-go-to-use-rune-safe-t`
- `epic/move-memory-sync-inside-forge-success-gate`
- `epic/reduce-updatemarkdownfrontmatter-complexity`
- `epic/require-command-surface-parity-completion-checkl`

### Preserve commit, then remove

These branches are unique but their current dirty state does not add anything beyond shared `.beads/` deletions. Preserve the branch tip, then remove the attached worktree:

- `beads-sync`
- `epic/assert-antistars-values-in-goals-init-test-go`
- `epic/audit-signal-notify-sites-for-goroutine-leak`
- `epic/remove-findmemoryfile-broad-contains-fallback`
- `worktree-agent-a6f2ef41`

Preservation rule:

- if upstream already exists, remote is the preserved tip
- if upstream does not exist, push the branch to `origin` before deleting the local branch

### Retain as active

These worktrees contain distinct local edits or are clearly a root worktree:

- `codex/fix-nightly-run-20260306`
- `worktree-agent-a2f55515`
- `worktree-agent-a44397c8`
- `worktree-agent-a752f190`
- `worktree-structured-squishing-kahan`

Those worktrees should remain attached after this cycle. Their disposition is “preserve active,” not “cleanup clutter.”

## Recommendation

Execute the triage issue by:

1. marking `na-1uj.6` in progress
2. removing the `17` merged `.beads/`-only worktrees and deleting those merged local branches
3. pushing the `4` unique no-upstream branches, then removing those `4` worktrees and deleting the local branches
4. removing `beads-sync` while keeping `origin/beads-sync`
5. documenting the `5` retained active worktrees and closing `na-1uj.6`

After that, `na-1uj.5` should no longer stay blocked on “all foreign attached worktrees must disappear.” It should be closed or superseded because the remaining foreign attached worktrees are intentionally retained.
