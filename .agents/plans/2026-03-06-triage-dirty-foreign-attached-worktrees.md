---
id: plan-2026-03-06-triage-dirty-foreign-attached-worktrees
type: plan
date: 2026-03-06
source: "[[.agents/research/2026-03-06-dirty-attached-worktree-dispositions.md]]"
issue: na-1uj.6
---

# Plan: Triage Dirty Foreign Attached Worktrees

## Context

The previous branch-topology cleanup stopped correctly when it discovered that every foreign attached worktree was dirty. The fix is not “remove them all carefully.” The fix is to split dirtiness into disposable shared state versus retained local work.

This plan implements `na-1uj.6` directly. It does not create a new cleanup epic because the work is already bounded by the inspection artifact and a small number of disposition classes.

## Disposition Rules

1. Merged branch plus only shared `.beads/` deletions:
   remove worktree with force, then delete the merged local branch.
2. Unique branch plus only shared `.beads/` deletions:
   preserve branch tip on `origin`, remove worktree with force, then delete the local branch.
3. Distinct local edits or active root worktree:
   retain attached worktree and record its disposition in the issue notes and research artifact.

## Work in Scope

### Remove merged `.beads/`-only worktrees

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

### Preserve unique tips, then remove attached worktrees

- `beads-sync`
- `epic/assert-antistars-values-in-goals-init-test-go`
- `epic/audit-signal-notify-sites-for-goroutine-leak`
- `epic/remove-findmemoryfile-broad-contains-fallback`
- `worktree-agent-a6f2ef41`

### Retain as active

- `codex/fix-nightly-run-20260306`
- `worktree-agent-a2f55515`
- `worktree-agent-a44397c8`
- `worktree-agent-a752f190`
- `worktree-structured-squishing-kahan`

## Command Surface

- `git worktree list --porcelain`
- `git for-each-ref --format='%(refname:short)|%(worktreepath)|%(upstream:short)' refs/heads`
- `git -C <worktree-path> status --short`
- `git push -u origin <branch>`
- `git worktree remove --force <worktree-path>`
- `git branch -d <branch>`
- `git branch -D <branch>`

## Verification

1. Removed disposable worktrees are no longer attached:

```bash
git for-each-ref --format='%(refname:short)|%(worktreepath)' refs/heads | \
  rg '^(beads-sync|epic/add-ambiguity-detection-to-readsessionbyid|epic/add-duplicate-marker-detection-to-parsemanagedbl|epic/add-handler-tests-for-batch-forge-and-batch-prom|epic/add-memrl-feedback-loop-health-check-to-ci|epic/add-merge-flag-to-ao-dedup|epic/add-migratev1tov2-and-killallchildren-package-le|epic/add-preflight-existence-checks-for-checkpoint-po|epic/add-template-existence-lint-test-for-validtempla|epic/assert-antistars-values-in-goals-init-test-go|epic/audit-signal-notify-sites-for-goroutine-leak|epic/clean-dead-code-in-measure-test-go|epic/establish-prior-findings-resolution-tracking-acr|epic/extend-ao-dedup-to-scan-agents-patterns|epic/extract-syncmemory-testable-function-from-runmem|epic/fix-ci-local-release-sh-invocation-inconsistency|epic/fix-truncatetext-in-inject-go-to-use-rune-safe-t|epic/move-memory-sync-inside-forge-success-gate|epic/reduce-updatemarkdownfrontmatter-complexity|epic/remove-findmemoryfile-broad-contains-fallback|epic/require-command-surface-parity-completion-checkl|worktree-agent-a6f2ef41)\\|/'
```

2. Preserved active worktrees remain attached:

```bash
git for-each-ref --format='%(refname:short)|%(worktreepath)' refs/heads | \
  rg '^(codex/fix-nightly-run-20260306|worktree-agent-a2f55515|worktree-agent-a44397c8|worktree-agent-a752f190|worktree-structured-squishing-kahan)\\|/'
```

3. Research artifact exists and records retained active set:

```bash
rg -n 'Retain as active|codex/fix-nightly-run-20260306|worktree-agent-a44397c8' \
  .agents/research/2026-03-06-dirty-attached-worktree-dispositions.md
```
