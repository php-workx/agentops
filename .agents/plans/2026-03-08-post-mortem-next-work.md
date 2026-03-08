---
id: plan-2026-03-08-post-mortem-next-work
type: plan
date: 2026-03-08
source: "[[.agents/retros/2026-03-08-march-8-delivery-chain.md]]"
---

# Plan: Next Work After March 8 Post-Mortem

## Recommended Order

1. Repair the current CI blockers
2. Reconcile the `next-work` contract
3. Make queue mutation concurrency-safe
4. Promote Codex override coverage to CI
5. Finish push/pregate reproducibility

## 1. Repair the Current CI Blockers

### Why

`dd3dee64` is on `main`, but GitHub Actions run `22825014214` ended in failure. The work is shipped but not cleanly closed.

### Scope

- `tests/scripts/pre-push-gate.bats`
- `scripts/pre-push-gate.sh`
- `cli/internal/vibecheck/timeline.go`
- `cli/cmd/ao/vibe_check_test.go`
- any targeted `internal/vibecheck` tests needed to restore the coverage floor

### Acceptance

- `bats tests/scripts/pre-push-gate.bats --filter "passes when no Go changes"` passes
- `go test ./internal/vibecheck -cover` returns `100.0%` again or the baseline is intentionally updated with rationale
- a rerun of CI no longer fails on `bats-tests` or `coverage-ratchet`

## 2. Reconcile the `next-work` Contract

### Why

The runtime moved to per-item claim/release semantics, but `.agents/rpi/next-work.schema.md`, `skills/post-mortem/references/harvest-next-work.md`, and related examples are no longer fully aligned.

### Scope

- `.agents/rpi/next-work.schema.md`
- `skills/post-mortem/references/harvest-next-work.md`
- `skills/rpi/references/phase-data-contracts.md`
- `skills-codex/post-mortem/references/harvest-next-work.md`
- `skills-codex/rpi/references/phase-data-contracts.md`
- `cli/cmd/ao/rpi_loop.go`
- a new parity/contract validation script if needed

### Acceptance

- one canonical schema/version matches the implemented queue lifecycle
- append-only vs rewrite semantics are explicit
- empty-item entry rules are consistent across schema, docs, and code
- validation fails on future contract drift

## 3. Make Queue Mutation Concurrency-Safe

### Why

The current queue writer rewrites the full JSONL file without locking or CAS semantics. That is fragile once `/evolve` and `/rpi loop` both claim work.

### Scope

- `cli/cmd/ao/rpi_loop.go`
- any shared queue helpers
- new race-oriented tests around claim/release behavior

### Acceptance

- concurrent claim/release cannot silently lose updates
- at least one multi-consumer test exercises two claimers against the same queue state

## 4. Promote Codex Override Coverage to CI

### Why

The local pre-push path now checks override prompt parity, but CI does not. That leaves a gap for contributors who bypass local hooks or use different workflows.

### Scope

- `.github/workflows/validate.yml`
- `scripts/ci-local-release.sh`
- `scripts/validate-codex-override-coverage.sh`
- related docs if CI policy wording changes

### Acceptance

- override coverage runs in CI
- the check covers both required override inventory and generated prompt parity
- failures point to the exact source override and generated target

## 5. Finish Push/Pregate Reproducibility

### Why

This remained open after the March 8 push and is still the highest leverage workflow hardening item outside the immediate CI blockers.

### Scope

- `scripts/validate-go-fast.sh`
- `scripts/check-cmdao-coverage-floor.sh`
- `scripts/check-worktree-disposition.sh`
- `cli/internal/vibecheck/timeline.go`
- `cli/cmd/ao/vibe_check_test.go`

### Acceptance

- local pre-push behavior matches real push behavior closely enough that failures converge on the same root cause
- diagnostics distinguish validation-induced dirtiness from real uncommitted work
- git-environment-sensitive tests are deterministic
