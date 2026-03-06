---
id: plan-2026-03-06-rationalize-repo-branch-topology-v2
type: plan
date: 2026-03-06
source: "[[.agents/research/2026-03-06-branch-topology-remediation.md]]"
epic: na-1uj
---

# Plan: Rationalize Repo Branch Topology

## Context

The first remediation plan failed pre-mortem because it described the right cleanup strategy but did not cover the full topology. The current repo has fifteen local survivor branches outside `main`, five remote survivors outside `origin/main`, and twenty-seven foreign attached branches that still occupy worktrees. A branch cleanup plan that omits part of that set will still leave the namespace materially cluttered.

The corrected plan keeps the original sequencing but expands the scope to the whole survivor inventory. It also separates inspection from deletion for attached worktrees so destructive cleanup is preceded by a durable inspection artifact.

## Files to Modify

| File | Change |
|---|---|
| `.git/refs/remotes/origin/*` | Delete or merge the five current remote survivor branches |
| `.git/refs/heads/codex/*` | Resolve local counterparts for remote survivor branches and the current codex-side survivor set |
| `.git/refs/heads/crew/*` | Resolve local crew-side survivor branches outside `main` |
| `.git/refs/heads/fix/*` | Resolve local fix branches with gone upstreams or patch-equivalent remotes |
| `.git/refs/heads/worktree-agent-*` | Resolve unique unattached survivors and prune merged duplicate refs |
| `.git/refs/heads/epic/*` | Inspect and clean attached unique/merged worktree branches |
| `.git/worktrees/*` | Remove foreign worktree registrations after inspection |
| `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/*` | Remove foreign worktree directories that inspection marks safe to delete |
| `.agents/research/2026-03-06-attached-worktree-inspection.md` | **NEW** durable inspection artifact for all foreign attached worktrees |

## Boundaries

**Always:** keep `main` clean and pushed; classify every current survivor ref outside `main`; use `git cherry origin/main <branch>` before treating a remote as unique; inspect worktree dirtiness and record it before any attached-worktree removal.

**Ask First:** if a unique branch contains meaningful work that is not clearly destined for `main`, pause for a keep/push/archive decision instead of deleting it.

**Never:** delete a dirty worktree without inspection; remove `main` or the current implementation worktree; rewrite published history.

## Baseline Audit

| Metric | Command | Result |
|---|---|---|
| Local branches | `git for-each-ref --format='x' refs/heads \| wc -l` | `87` |
| Local survivors outside `main` | `git branch --no-merged main \| wc -l` | `15` |
| Remote survivors outside `origin/main` | `git branch -r --no-merged origin/main \| wc -l` | `5` |
| Local branches with gone upstreams | `git branch -vv \| rg '\[.*: gone\]' \| wc -l` | `4` |
| Foreign attached unique branches | survivor inventory + `worktreepath != ""` | `6` |
| Foreign attached merged branches | `git for-each-ref ...` + `git merge-base --is-ancestor <branch> main` | `21` |
| Total foreign attached branches | previous two rows | `27` |
| Largest duplicate-tip group | duplicate-tip audit command | `31` branches at `3fef2f41` |

## Implementation

### 1. Resolve Patch-Equivalent Remote Survivors and Unattached Local Mirror Counterparts

Scope:

- remote survivors:
  - patch-equivalent and removable:
    - `origin/codex/fix-nightly-run-20260306`
    - `origin/fix/mine-empty-dir-guard`
  - unique and preservable as remote-only survivors unless clearly safe to merge:
    - `origin/claude/fix-security-ci-failure-z7uIe`
    - `origin/codex/update-codex-skills-v220`
    - `origin/crew/nami-rpi-f871358b1e96`
- mirrored unattached local counterparts:
  - `codex/update-codex-skills-v220`
  - `crew/nami-rpi-f871358b1e96`
  - `fix/mine-empty-dir-guard`

Exact command surface:

- `git branch -r --no-merged origin/main`
- `git cherry origin/main origin/<branch>`
- `git log --oneline origin/main..<branch>`
- `git merge --no-ff origin/<branch>`
- `git push origin --delete <branch>`
- `git branch -d <branch>`

### 2. Resolve All Unattached Unique Local Survivors

Scope:

- `fix/mine-error-handling`
- `fix/mine-stable-dedup-ids`
- `fix/mine-thread-window-sanitize-deadcode`
- `worktree-agent-a7e6aff3`
- `worktree-agent-a94fb391`
- `worktree-agent-ac157ccb`

Exact command surface:

- `git branch --no-merged main`
- `git branch -vv`
- `git for-each-ref --format='%(upstream:short)' refs/heads/<branch>`
- `git log --oneline main..<branch>`
- `git branch -d <branch>`
- `git push -u origin <branch>`
- `git merge --no-ff <branch>`

### 3. Prune Merged Unattached Duplicate Branch Clutter

Scope is limited to merged, unattached refs in the duplicate-tip groups:

- `3fef2f41`
- `c8eee28e`
- `82c52030`
- `f2782b2d`
- `e10e1516`
- `ed10f54a`
- `a044f5cf`

Exact command surface:

- `git for-each-ref --format='%(refname:short)|%(objectname:short)|%(worktreepath)' refs/heads`
- `git merge-base --is-ancestor <branch> main`
- `git branch -d <branch>`

### 4. Inspect All Foreign Attached Worktrees

Create `.agents/research/2026-03-06-attached-worktree-inspection.md` covering every attached foreign branch except `main` and `codex/branch-topology-rpi-fix`.

Inspection scope:

- attached unique:
  - `beads-sync`
  - `codex/fix-nightly-run-20260306`
  - `epic/assert-antistars-values-in-goals-init-test-go`
  - `epic/audit-signal-notify-sites-for-goroutine-leak`
  - `epic/remove-findmemoryfile-broad-contains-fallback`
  - `worktree-agent-a6f2ef41`
- attached merged:
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

Exact command surface:

- `git for-each-ref --format='%(refname:short)|%(worktreepath)|%(objectname:short)' refs/heads`
- `git -C <worktree-path> status --short`
- `git -C <worktree-path> branch --show-current`
- `git merge-base --is-ancestor <branch> main`

### 5. Clean Foreign Attached Worktrees and Branch Bindings

After Issues `na-1uj.1`, `na-1uj.2`, `na-1uj.3`, and `na-1uj.4`, remove all foreign attached worktrees that the inspection artifact marks clean and safe to delete. Preserve only:

- `main`
- `codex/branch-topology-rpi-fix`

Exact command surface:

- `git worktree remove <worktree-path>`
- `git branch -d <branch>`
- `git worktree list --porcelain`

## Tests

There are no source-code tests in scope. Validation is command- and artifact-based.

## Conformance Checks

| Issue | Check Type | Check |
|---|---|---|
| `na-1uj.1` | command | `! git branch -r --no-merged origin/main \| grep -E "origin/(codex/fix-nightly-run-20260306\|fix/mine-empty-dir-guard)$" && ! git branch --no-merged main \| grep -E "^(  |\*|\+) (codex/update-codex-skills-v220\|crew/nami-rpi-f871358b1e96\|fix/mine-empty-dir-guard)$"` |
| `na-1uj.2` | command | `! git branch --no-merged main \| grep -E "^(  |\*|\+) (fix/mine-error-handling\|fix/mine-stable-dedup-ids\|fix/mine-thread-window-sanitize-deadcode\|worktree-agent-a7e6aff3\|worktree-agent-a94fb391\|worktree-agent-ac157ccb)$"` |
| `na-1uj.3` | command | `for sha in 3fef2f41 c8eee28e 82c52030 f2782b2d e10e1516 ed10f54a a044f5cf; do ...; done` |
| `na-1uj.4` | files_exist + content_check | `{ "files_exist": [".agents/research/2026-03-06-attached-worktree-inspection.md"], "content_check": { "file": ".agents/research/2026-03-06-attached-worktree-inspection.md", "pattern": "beads-sync|epic/add-ambiguity-detection-to-readsessionbyid|worktree-structured-squishing-kahan|dirty|clean" } }` |
| `na-1uj.5` | command | `git for-each-ref --format='%(refname:short)|%(worktreepath)' refs/heads | awk -F'|' '$2 != \"\" && $1 != \"main\" && $1 != \"codex/branch-topology-rpi-fix\" { exit 1 }'` |

## Verification

1. **Local survivor set**
   ```bash
   git branch --no-merged main
   ```
2. **Remote survivor set**
   ```bash
   git branch -r --no-merged origin/main
   ```
3. **Inspection artifact**
   ```bash
   sed -n '1,220p' .agents/research/2026-03-06-attached-worktree-inspection.md
   ```
4. **Remaining attached branches**
   ```bash
   git for-each-ref --format='%(refname:short)|%(worktreepath)' refs/heads | awk -F'|' '$2 != ""'
   git worktree list --porcelain
   ```
5. **Final repo state**
   ```bash
   git status --branch
   git remote prune origin
   ```

## File-Conflict Matrix

| File | Issues |
|---|---|
| `.git/refs/remotes/origin/*` | `na-1uj.1` |
| `.git/refs/heads/{remote-counterpart locals}` | `na-1uj.1` |
| `.git/refs/heads/{unattached unique locals}` | `na-1uj.2` |
| `.git/refs/heads/{merged duplicate unattached locals}` | `na-1uj.3` |
| `.agents/research/2026-03-06-attached-worktree-inspection.md` | `na-1uj.4` |
| `.git/worktrees/*` | `na-1uj.5` |
| `/Users/fullerbt/gt/agentops/crew/nami/.claude/worktrees/*` | `na-1uj.5` |

## Cross-Wave Shared Files

| File | Wave 1 Issues | Wave 2+ Issues | Mitigation |
|---|---|---|---|
| `.git/refs/heads/codex/fix-nightly-run-20260306` | `na-1uj.1` | `na-1uj.5` | `na-1uj.5` depends on `na-1uj.1`, so attached cleanup only happens after branch disposition |
| `.git/refs/heads/beads-sync` | `na-1uj.4` | `na-1uj.5` | inspect first, then delete/remove using the inspection artifact |
| `.git/refs/heads/epic/assert-antistars-values-in-goals-init-test-go` and other attached unique refs | `na-1uj.4` | `na-1uj.5` | issue `na-1uj.5` is blocked on `na-1uj.4` |

## Issues

### Issue `na-1uj.1`: Resolve patch-equivalent remote survivors and unattached local mirror counterparts

**Dependencies:** None  
**Acceptance:** the patch-equivalent remote survivors are gone, and the unattached local mirror counterpart branches are no longer outside `main`  
**Description:** delete the patch-equivalent remotes, remove unattached local mirror clutter for remote-only survivor branches, and merge a unique remote only when its diff is clearly safe and desired.

### Issue `na-1uj.2`: Resolve all unattached unique local survivors

**Dependencies:** None  
**Acceptance:** the six unattached unique locals outside `main` are merged, pushed, or deleted  
**Description:** remove all unattached unique local survivors from the outstanding survivor set, including the three `fix/mine-*` branches and the three unattached `worktree-agent-*` branches.

### Issue `na-1uj.3`: Prune merged unattached duplicate branch clutter

**Dependencies:** None  
**Acceptance:** the audited duplicate-tip groups no longer have merged unattached refs lingering locally  
**Description:** bulk-delete only merged unattached branches in the verified duplicate-tip SHA groups.

### Issue `na-1uj.4`: Inspect all foreign attached worktrees

**Dependencies:** None  
**Acceptance:** `.agents/research/2026-03-06-attached-worktree-inspection.md` exists and records status for every foreign attached worktree  
**Description:** write a durable inspection artifact covering all six attached unique branches and all twenty-one attached merged branches.

### Issue `na-1uj.5`: Clean foreign attached worktrees and branch bindings

**Dependencies:** `na-1uj.1`, `na-1uj.2`, `na-1uj.3`, `na-1uj.4`  
**Acceptance:** no foreign attached branch remains after inspection-driven cleanup  
**Description:** remove foreign attached worktrees and their branch bindings, leaving only `main` and the current implementation branch attached.

## Execution Order

**Wave 1** (parallel): `na-1uj.1`, `na-1uj.2`, `na-1uj.3`, `na-1uj.4`  
**Wave 2** (after Wave 1): `na-1uj.5`

## Post-Merge Cleanup

- rerun the duplicate-tip audit command
- rerun `git branch --no-merged main`
- rerun `git branch -r --no-merged origin/main`
- confirm only `main` and `codex/branch-topology-rpi-fix` still have `worktreepath`

## Next Steps

- Run `$pre-mortem` on this revised plan
- Then execute the epic with `$crank na-1uj`
