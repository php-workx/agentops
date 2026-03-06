---
type: research
date: 2026-03-06
topic: branch-topology-remediation
---

# Research: Branch Topology Remediation

## Executive Summary

The first branch-topology plan failed pre-mortem because it only covered a representative subset of the real survivor set. The fix is not to change the overall sequencing. The fix is to make the scope exhaustive:

1. include every current local branch still outside `main`
2. separate attached-worktree inspection from destructive cleanup
3. make remote cleanup symmetrical with local counterpart cleanup

The branch cleanup remains feasible, but the implementation plan has to reflect the full topology that exists today.

## Key Findings

### Current local survivor set outside `main`

Verified with:

```bash
git branch --no-merged main
```

Current local survivors:

- `beads-sync`
- `codex/fix-nightly-run-20260306`
- `codex/update-codex-skills-v220`
- `crew/nami-rpi-f871358b1e96`
- `epic/assert-antistars-values-in-goals-init-test-go`
- `epic/audit-signal-notify-sites-for-goroutine-leak`
- `epic/remove-findmemoryfile-broad-contains-fallback`
- `fix/mine-empty-dir-guard`
- `fix/mine-error-handling`
- `fix/mine-stable-dedup-ids`
- `fix/mine-thread-window-sanitize-deadcode`
- `worktree-agent-a6f2ef41`
- `worktree-agent-a7e6aff3`
- `worktree-agent-a94fb391`
- `worktree-agent-ac157ccb`

That is the full survivor set the remediation plan must classify.

### Remote survivors still outside `origin/main`

Verified with:

```bash
git branch -r --no-merged origin/main
```

Current remote survivors:

- `origin/claude/fix-security-ci-failure-z7uIe`
- `origin/codex/fix-nightly-run-20260306`
- `origin/codex/update-codex-skills-v220`
- `origin/crew/nami-rpi-f871358b1e96`
- `origin/fix/mine-empty-dir-guard`

Patch-equivalent to `main` according to `git cherry origin/main <branch>`:

- `origin/codex/fix-nightly-run-20260306`
- `origin/fix/mine-empty-dir-guard`

Still unique relative to `main`:

- `origin/codex/update-codex-skills-v220`
- `origin/claude/fix-security-ci-failure-z7uIe`
- `origin/crew/nami-rpi-f871358b1e96`

### Attached foreign worktrees split into merged and unique sets

Verified with:

```bash
git for-each-ref --format='%(refname:short)|%(worktreepath)|%(objectname:short)' refs/heads
git merge-base --is-ancestor <branch> main
```

Attached unique foreign branches:

- `beads-sync`
- `codex/fix-nightly-run-20260306`
- `epic/assert-antistars-values-in-goals-init-test-go`
- `epic/audit-signal-notify-sites-for-goroutine-leak`
- `epic/remove-findmemoryfile-broad-contains-fallback`
- `worktree-agent-a6f2ef41`

Attached merged foreign branches:

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
- `worktree-agent-a2f55515`
- `worktree-agent-a44397c8`
- `worktree-agent-a752f190`
- `worktree-structured-squishing-kahan`

The previous plan only covered six attached branches. The real cleanup scope is twenty-seven foreign attached branches: six unique and twenty-one already merged.

### Durable inspection artifact is required

The pre-mortem concern was correct: “inspect before delete” is not enough if the plan does not require evidence. The remediation plan needs a non-destructive inspection issue that writes a report before any attached worktree removal issue runs.

## Recommendations

1. Resolve remote survivors and their mirrored local counterparts together.
2. Resolve every unattached local survivor outside `main`, not just the `fix/mine-*` branches.
3. Keep merged unattached duplicate pruning as a separate parallel track.
4. Add one issue to inspect all foreign attached worktrees and write a durable report.
5. Add a final issue to remove foreign attached worktrees only after survivor resolution and inspection are complete.
