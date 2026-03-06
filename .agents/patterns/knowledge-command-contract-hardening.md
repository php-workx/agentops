---
type: pattern
source: athena 2026-03-06
date: 2026-03-06
confidence: high
maturity: provisional
tags: [athena, cli, mine, defrag, contracts]
---

# Knowledge Command Contract Hardening Pattern

## Pattern

When adding or evolving knowledge commands such as `ao mine` and `ao defrag`, treat the command surface as a public contract. Harden output format, data shape, default behavior, permissions, and error semantics together so the command remains predictable for both humans and automation.

## Problem

Athena-specific follow-up fixes clustered around contract drift rather than core algorithm failure:

- JSON mode mixing human summary text with machine output
- public report fields implying shapes the implementation did not actually support
- help text and default behavior drifting apart
- sibling commands writing similar artifacts with inconsistent permissions
- lower-level helpers absorbing errors before the command layer could warn correctly

None of these are dramatic runtime crashes. They are the slower kind of flywheel damage: commands become harder to script, harder to trust, and harder to evolve safely.

## Evidence

### `ao mine`

From [mine.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/mine.go):

- `finalizeMineReport()` is the contract boundary for output behavior.
- `mineGitLog()` is the contract boundary for git-source error propagation.
- `GitFindings.TopCoChangeFiles` is the honest public shape for the co-change output.

### `ao defrag`

From [defrag.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/defrag.go):

- `runDefrag()` owns the default-mode semantics when no explicit operation flags are passed.
- `DefragReport` and `DefragDedupResult` define the public output surface.
- report-writing behavior must line up with sibling knowledge-command conventions.

### Athena council findings

From [20260301T131712Z-vibe-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/20260301T131712Z-vibe-athena-ag-co7.md) and [2026-03-01-post-mortem-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/2026-03-01-post-mortem-athena-ag-co7.md):

- `runMine --json` previously risked double-writing summary text and JSON
- `CoChangeClusters [][]string` implied multiple clusters when the implementation only produced one, later corrected to `TopCoChangeFiles`
- `defrag` permission and `--dry-run` semantics were confusing enough to show up in council review
- `mineGitLog` error behavior mattered because command-level warnings depend on honest propagation

## Rules

1. **JSON mode must emit JSON only.**
   If `GetOutput() == "json"`, suppress human-readable summaries on stdout. Machine consumers should not need `--quiet` as a repair mechanism.

2. **Public data shapes must reflect real invariants.**
   If the implementation produces one top-N file list, expose `TopCoChangeFiles []string`, not a nested structure that implies multiple clusters.

3. **Default behavior must match help text.**
   If a command defaults to all operations when no flags are given, document that directly and keep examples aligned with the actual invocation semantics.

4. **Sibling command outputs should use compatible file conventions.**
   `ao mine` and `ao defrag` both write knowledge artifacts under `.agents/`; permission and naming choices should be consistent unless there is a strong documented reason to diverge.

5. **Errors should propagate to the user-facing warning boundary.**
   Helpers such as `mineGitLog()` should not silently absorb failures that the command layer is supposed to surface as warnings or actionable errors.

6. **Usability confusion is still contract debt.**
   Even when behavior is technically correct, mismatches between docs, defaults, and output semantics accumulate into user-visible breakage over time.

## Checklist

Before shipping a knowledge command or modifying an existing one, check:

- Does JSON mode produce parseable JSON without extra stdout text?
- Does every exported field match the implementation's true invariants?
- Do examples and help text describe the real default path?
- Are output files readable by the intended downstream tools and CI users?
- Can the command layer still warn accurately when a source-specific helper fails?

## When to Apply

- New commands under the `knowledge` group
- Changes to `ao mine`, `ao defrag`, `ao forge`, or similar report-producing commands
- Any refactor that changes output schema, default flags, or file-writing behavior

## Anti-Pattern

Fixing each symptom independently without writing down the shared contract rules. That resolves one command bug at a time but leaves the same drift pattern available for the next knowledge command.
