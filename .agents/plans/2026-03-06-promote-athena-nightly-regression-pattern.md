---
type: plan
date: 2026-03-06
goal: promote-athena-nightly-regression-pattern
epic: na-u46
---

# Plan: Promote Athena Nightly-Regression Pattern

## Goal

Promote the next Athena gap into a canonical pattern by documenting how nightly CI and local supervisor cadence work together to catch Athena regressions.

## Baseline Audit

| Metric | Command | Result |
|---|---|---|
| Existing canonical patterns | `find .agents/patterns -maxdepth 1 -type f -name '*.md' \| wc -l` | `5` |
| Duplicate bead search 1 | `bd search "Athena freshness nightly regression pattern" --json` | `[]` |
| Duplicate bead search 2 | `bd search "mine defrag local dev feedback loop nightly" --json` | `[]` |

## Files to Modify

| File | Change |
|---|---|
| `.agents/research/2026-03-06-athena-nightly-regression-gap.md` | **NEW** research artifact grounding the nightly-regression gap |
| `.agents/patterns/athena-nightly-regression-guard.md` | **NEW** canonical pattern for CI + local Athena freshness guarding |

## Issue Plan

### Wave 1

#### `na-8zd` Write canonical Athena nightly-regression guard pattern

**Files**

- `.agents/patterns/athena-nightly-regression-guard.md`

**Implementation detail**

- Synthesize the guard-loop relationship between:
  - [.github/workflows/nightly.yml](/Users/fullerbt/.codex/worktrees/d5e9/nami/.github/workflows/nightly.yml)
  - [scripts/check-athena-health.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/check-athena-health.sh)
  - [scripts/ao-rpi-autonomous-cycle.sh](/Users/fullerbt/.codex/worktrees/d5e9/nami/scripts/ao-rpi-autonomous-cycle.sh)
  - [cli/cmd/ao/rpi_loop.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/rpi_loop.go)
  - Athena post-mortem findings in [2026-03-01-post-mortem-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/2026-03-01-post-mortem-athena-ag-co7.md)
- Cover these rules explicitly:
  - nightly CI is the scheduled remote guard
  - local supervisor cadence is the fast feedback path
  - both must converge on the same freshness artifact contract
  - `continue-on-error` applies to `mine`, not to the overall health gate
  - env overrides such as `ATHENA_OUTPUT_DIR` are part of the guard contract, not incidental plumbing

**Acceptance criteria**

- A new pattern file exists and names nightly CI, `check-athena-health.sh`, and local supervisor Athena cadence.
- The pattern explains why nightly-only guarding is insufficient without a local feedback loop.
- The pattern includes at least four concrete rules tied to the current repo implementation.

**Conformance**

```json
{"files_exist":[".agents/patterns/athena-nightly-regression-guard.md"],"content_check":{"file":".agents/patterns/athena-nightly-regression-guard.md","pattern":"nightly.yml|check-athena-health.sh|ATHENA_OUTPUT_DIR|ao-rpi-autonomous-cycle.sh|runAthenaProducerTick"}}
```

## Verification

1. `markdownlint .agents/research/2026-03-06-athena-nightly-regression-gap.md .agents/patterns/athena-nightly-regression-guard.md .agents/plans/2026-03-06-promote-athena-nightly-regression-pattern.md`
2. `rg -n "nightly.yml|check-athena-health.sh|ATHENA_OUTPUT_DIR|ao-rpi-autonomous-cycle.sh|runAthenaProducerTick" .agents/patterns/athena-nightly-regression-guard.md`
3. `git diff -- .agents/research .agents/patterns .agents/plans`

## Wave Structure

- Wave 1: `na-8zd`
