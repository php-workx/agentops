---
type: research
date: 2026-03-06
topic: athena-command-contract-gap
---

# Research: Athena Command-Contract Gap

## Goal

Promote the next uncaptured Athena theme into a canonical pattern by extracting the recurring contract-hardening lessons from `ao mine` and `ao defrag`.

## Why This Is the Next Gap

The previous Athena follow-through already promoted:

- RPI multi-root observability
- cmd/ao test hotspot refactoring

The remaining repeated theme in Athena-specific evidence is command-contract hardening for knowledge commands:

- `fix(cli): harden historical AO/RPI mining contracts` appears in `.agents/mine/latest.json`
- Athena council findings repeatedly pointed at output purity, data-shape honesty, permission consistency, and command-boundary error handling
- there is still no canonical pattern in `.agents/patterns/` for this class of problem

## Source Evidence

### Athena post-mortem

From [2026-03-01-post-mortem-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/2026-03-01-post-mortem-athena-ag-co7.md):

- `--json` flag convention: suppress human-readable summary when JSON is requested
- avoid misleading data shapes such as a single-cluster `[][]string`
- normalize defrag permissions to match mine output conventions
- keep error handling at the same layer where warnings are emitted

### Athena vibe findings

From [20260301T131712Z-vibe-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/20260301T131712Z-vibe-athena-ag-co7.md):

- `runMine --json` previously mixed summary text with JSON
- `CoChangeClusters` shape implied multiple clusters when only one existed
- `defrag` permission and `--dry-run` semantics created user-facing contract confusion
- `mineGitLog` error propagation was fragile enough to warrant explicit review

## Live Code Anchors

- [mine.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/mine.go)
  - `finalizeMineReport()`
  - `mineGitLog()`
  - `GitFindings.TopCoChangeFiles`
- [defrag.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/defrag.go)
  - `runDefrag()`
  - `writeDefragReport()` behavior and default-mode handling

## Candidate Pattern

**Knowledge Command Contract Hardening Pattern**

Core rules:

1. JSON mode must emit JSON only.
2. Public data shapes must reflect the real invariants.
3. Default-mode behavior must match help text and docs.
4. File-permission choices should be consistent across sibling commands unless there is a strong reason otherwise.
5. Errors should propagate to the layer that owns user-visible warning semantics.

## Baseline Audit

Verified 2026-03-06:

- Existing canonical patterns: `find .agents/patterns -maxdepth 1 -type f -name '*.md' | wc -l` = `4`
- Existing learning artifacts: `ls .agents/learnings/*.md | wc -l` = `6`
- Duplicate bead search for this topic:
  - `bd search "mine defrag command contract hardening" --json` = `[]`
  - `bd search "json double-write CoChangeClusters defrag permissions" --json` = `[]`

## Recommendation

Create one new canonical pattern artifact that turns the scattered Athena findings for `ao mine` and `ao defrag` into a reusable command-contract checklist for future knowledge commands.
