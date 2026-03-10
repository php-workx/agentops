---
type: pattern
source: athena 2026-03-06
date: 2026-03-06
confidence: 0.3750
maturity: provisional
tags: [athena, nightly, regression, ci, supervisor]
last_decay_at: 2026-03-09T21:48:09-04:00
harmful_count: 3
utility: 0.2006
last_reward: 0.00
reward_count: 3
last_reward_at: 2026-03-09T21:48:09-04:00
---

# Athena Nightly Regression Guard Pattern

## Pattern

When Athena freshness matters, guard it with two reinforcing paths: nightly CI for scheduled remote detection and local supervisor cadence for fast feedback. Both paths must converge on the same artifact and freshness contract so a regression is visible before and during the next nightly run.

## Problem

Athena regressions are easy to hide if the repo relies on only one loop:

- nightly-only guarding delays detection until the next scheduled run
- local-only guarding is too dependent on whoever happens to be supervising work
- `ao mine` and `ao defrag` can look healthy in isolation while the freshness contract for Athena artifacts is already drifting

The failure mode is not just a broken command. It is a stale flywheel: learnings stop being refreshed, stale-count drift goes unnoticed, and the repo loses confidence that Athena is still producing current signal.

## Signals in Code

- [.github/workflows/nightly.yml](/Users/fullerbt/.codex/worktrees/d5e9/nami/.github/workflows/nightly.yml)
  - the `athena` job builds `ao`
  - runs `ao mine` with `continue-on-error: true`
  - runs `ao defrag`
  - enforces `scripts/check-athena-health.sh`
  - uploads `/tmp/athena/` artifacts
- [scripts/check-athena-health.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/check-athena-health.sh)
  - treats `${ATHENA_OUTPUT_DIR:-$AGENTS_DIR}/defrag/latest.json` as the health contract
  - fails when the defrag report is missing, too old, or over the stale-learning budget
  - supports `ATHENA_OUTPUT_DIR` because CI writes Athena artifacts outside the repo tree
- [scripts/ao-rpi-autonomous-cycle.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/ao-rpi-autonomous-cycle.sh)
  - exposes `--athena`, `--athena-interval`, `--athena-since`, and `--athena-defrag`
  - forwards those settings into the supervisor loop instead of treating Athena as separate operator work
- [cli/cmd/ao/rpi_loop.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/rpi_loop.go)
  - `maybeRunAthenaProducerCadence()` throttles local Athena ticks by elapsed time
  - `runAthenaProducerTick()` runs `ao mine --emit-work-items --since <window> --quiet`
  - the same tick can immediately follow with `ao defrag --prune --dedup --oscillation-sweep --quiet`

## Rules

1. Scheduled CI is the durable remote guard. Keep the nightly `athena` job as the authoritative scheduled check that proves Athena still works in clean automation.
2. Local supervisor cadence is the fast feedback path. If `ao rpi loop` is driving autonomous work, Athena producer ticks should run there too so regressions show up before the next daily workflow.
3. The health contract is the artifact, not the command exit alone. `scripts/check-athena-health.sh` reads `defrag/latest.json`; that freshness and stale-count contract is what both paths must satisfy.
4. `continue-on-error` belongs only on the mining step. In nightly CI, `ao mine` can fail without preventing `ao defrag` and the final gate, but the overall Athena job must still fail if the health check does not pass.
5. Environment overrides are part of the contract. `ATHENA_OUTPUT_DIR` is not incidental plumbing; it is how CI and local paths can write artifacts in different places while preserving the same gate semantics.
6. Mine and defrag belong to one loop. Running `runAthenaProducerTick()` without the matching defrag sweep weakens the freshness signal because the health gate is anchored on defrag output, not raw mining activity.
7. Nightly-only visibility is insufficient. If a post-mortem identifies missing local Athena feedback, treat that as a regression in guard coverage, not just an ergonomics issue.

## When to Apply

- Changing the nightly Athena workflow
- Modifying `scripts/check-athena-health.sh`
- Refactoring `ao rpi loop` Athena cadence or supervisor defaults
- Adjusting where Athena artifacts are written in CI or local automation

## Anti-Pattern

Treating nightly CI and local Athena cadence as unrelated conveniences. That splits the feedback loop, makes artifact freshness harder to reason about, and lets regressions hide between scheduled runs.
