---
type: research
date: 2026-03-06
topic: athena-nightly-regression-gap
---

# Research: Athena Nightly-Regression Gap

## Goal

Promote the next Athena-related gap into a canonical pattern by capturing how Athena regressions are supposed to stay visible in both nightly CI and local supervisor loops.

## Why This Is the Next Gap

The prior Athena follow-through cycles already promoted:

- RPI multi-root observability
- cmd/ao test hotspot refactoring
- knowledge-command contract hardening

The next repeated theme in Athena evidence is not another command detail. It is the **guard loop** around Athena freshness:

- nightly CI runs the Athena cycle and enforces a freshness gate
- the autonomous supervisor path can also run Athena producer ticks locally
- old Athena post-mortem guidance explicitly called out the missing local feedback loop as follow-up work

There is still no canonical pattern explaining how those CI and local paths should reinforce each other.

## Source Evidence

### Nightly CI path

From [.github/workflows/nightly.yml](/Users/fullerbt/.codex/worktrees/d5e9/nami/.github/workflows/nightly.yml):

- the `athena` job builds `ao`
- runs `ao mine` with `continue-on-error: true`
- runs `ao defrag`
- enforces `scripts/check-athena-health.sh`
- uploads Athena artifacts for inspection

This is the repo’s remote regression guard.

### Health gate

From [scripts/check-athena-health.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/check-athena-health.sh):

- the gate treats Athena as healthy only when defrag output exists, is recent, and stale learning count stays within budget
- `ATHENA_OUTPUT_DIR` lets CI write to `/tmp` while the gate still reads the right artifacts

This is the mechanical freshness contract.

### Local supervisor path

From [scripts/ao-rpi-autonomous-cycle.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/ao-rpi-autonomous-cycle.sh) and [cli/cmd/ao/rpi_loop.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/rpi_loop.go):

- the canonical supervisor path exposes `--athena`, `--athena-since`, and `--athena-defrag`
- `maybeRunAthenaProducerCadence()` throttles producer ticks
- `runAthenaProducerTick()` runs `ao mine --emit-work-items` and optionally `ao defrag`

This is the local feedback loop that mirrors the nightly concern.

### Athena post-mortem signal

From [2026-03-01-post-mortem-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/2026-03-01-post-mortem-athena-ag-co7.md):

- `continue-on-error: true` on mine in nightly CI was called out as an intentional pattern
- “Add `ao mine` and `ao defrag` to local dev feedback loop” was logged as proactive follow-up because nightly-only visibility is insufficient

## Candidate Pattern

**Athena Nightly Regression Guard Pattern**

Core idea:

1. CI provides the durable scheduled guard.
2. Local supervisor cadence provides fast feedback before the next nightly run.
3. A shared freshness gate ties both paths to the same observable artifact contract.

## Baseline Audit

Verified on 2026-03-06:

- Existing canonical patterns: `find .agents/patterns -maxdepth 1 -type f -name '*.md' | wc -l` = `5`
- Duplicate bead search:
  - `bd search "Athena freshness nightly regression pattern" --json` = `[]`
  - `bd search "mine defrag local dev feedback loop nightly" --json` = `[]`

## Recommendation

Create one new canonical pattern artifact that documents the Athena regression-guard loop spanning nightly CI, the health-gate script, and the local supervisor producer cadence.
