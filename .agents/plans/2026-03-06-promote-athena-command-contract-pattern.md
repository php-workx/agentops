---
type: plan
date: 2026-03-06
goal: promote-athena-command-contract-pattern
epic: na-auw
---

# Plan: Promote Athena Command-Contract Pattern

## Goal

Promote the next Athena knowledge gap into a canonical pattern by capturing how `ao mine` and `ao defrag` command contracts should be hardened over time.

## Baseline Audit

| Metric | Command | Result |
|---|---|---|
| Existing canonical patterns | `find .agents/patterns -maxdepth 1 -type f -name '*.md' \| wc -l` | `4` |
| Existing learning artifacts | `ls .agents/learnings/*.md \| wc -l` | `6` |
| Duplicate bead search 1 | `bd search "mine defrag command contract hardening" --json` | `[]` |
| Duplicate bead search 2 | `bd search "json double-write CoChangeClusters defrag permissions" --json` | `[]` |

## Files to Modify

| File | Change |
|---|---|
| `.agents/research/2026-03-06-athena-command-contract-gap.md` | **NEW** research artifact grounding the command-contract gap |
| `.agents/patterns/knowledge-command-contract-hardening.md` | **NEW** canonical pattern for hardening `ao mine` / `ao defrag` command contracts |

## Issue Plan

### Wave 1

#### `na-4vl` Write canonical knowledge-command contract hardening pattern

**Files**

- `.agents/patterns/knowledge-command-contract-hardening.md`

**Implementation detail**

- Synthesize the recurring lessons from:
  - [2026-03-01-post-mortem-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/2026-03-01-post-mortem-athena-ag-co7.md)
  - [20260301T131712Z-vibe-athena-ag-co7.md](/Users/fullerbt/.codex/worktrees/d5e9/nami/.agents/council/20260301T131712Z-vibe-athena-ag-co7.md)
  - [mine.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/mine.go)
  - [defrag.go](/Users/fullerbt/.codex/worktrees/d5e9/nami/cli/cmd/ao/defrag.go)
- Cover these contract categories explicitly:
  - JSON output purity
  - honest public data shapes
  - default-mode/help-text alignment
  - permission consistency for sibling command outputs
  - error propagation at the command boundary
- Include concrete examples from `mine` and `defrag` rather than generic CLI advice.

**Acceptance criteria**

- A new pattern file exists and names both `ao mine` and `ao defrag`.
- The pattern includes at least four contract rules pulled from real Athena evidence.
- The pattern explains when to apply the checklist to future knowledge commands.

**Conformance**

```json
{"files_exist":[".agents/patterns/knowledge-command-contract-hardening.md"],"content_check":{"file":".agents/patterns/knowledge-command-contract-hardening.md","pattern":"ao mine|ao defrag|JSON|TopCoChangeFiles|permissions|error propagation"}}
```

## Verification

1. `markdownlint .agents/research/2026-03-06-athena-command-contract-gap.md .agents/patterns/knowledge-command-contract-hardening.md`
2. `rg -n "ao mine|ao defrag|TopCoChangeFiles|JSON|permission|error propagation" .agents/patterns/knowledge-command-contract-hardening.md`
3. `git diff -- .agents/research .agents/patterns`

## Wave Structure

- Wave 1: `na-4vl`
