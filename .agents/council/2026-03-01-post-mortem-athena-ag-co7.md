---
id: post-mortem-2026-03-01-athena-ag-co7
type: post-mortem
date: 2026-03-01
source: "[[.agents/plans/2026-03-01-athena-knowledge-intelligence.md]]"
---

# Post-Mortem: Athena Knowledge Intelligence Engine (ag-co7)

**Epic:** ag-co7 — Athena Active Knowledge Intelligence Engine
**Issues Closed:** 5/5 (ag-co7.1–5)
**Commits:** 3 wave commits (Wave 1: 1135-line feature, Wave 2: gate + GOALS, Wave 3: CI job)
**Files changed:** 15
**Duration:** ~5 hours total session (including prior pre-mortem + planning session)

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Error-Paths | PASS | 2 minor: git error swallowing in mineGitLog; --json double-writes stdout |
| API-Surface | PASS | 2 minor: CoChangeClusters outer array semantics; --dry-run on root cmd |
| Spec-Compliance | PASS | All major spec points met; countAlternations is bidirectional (slightly off-spec semantics) |

### Implementation Assessment

The implementation matches the plan specification on all mandatory requirements:
- `SinceSeconds int64` (not `time.Duration`) per pre-mortem finding #2
- `DefragDedupResult` (not `DedupResult`) to avoid conflict with dedup.go
- `ATHENA_OUTPUT_DIR` env var in gate script per pre-mortem finding #1 (CRITICAL fix)
- Co-change algorithm: files in ≥3 distinct commits, sorted by frequency
- `continue-on-error: true` on mine in nightly CI (mine failure doesn't block defrag)
- All 25 tests pass, build/vet clean

### Concerns

Minor issues worth filing as follow-up:
1. `runMine --json` double-writes to stdout (summary + JSON interleaved, unparseable without `--quiet`)
2. `CoChangeClusters [][]string` outer array always has ≤1 element — misleading shape
3. Defrag file permissions (0o600) inconsistent with mine's 0o644

## Learnings

### What Went Well

- **Pre-mortem ROI was high**: All 5 pre-mortem findings addressed before code. Critical finding #1 (ATHENA_OUTPUT_DIR) would have caused CI to fail every run. Finding caught before any implementation began.
- **Wave isolation worked**: 3 workers (mine, defrag, skill) ran in parallel with zero file conflicts. Workers respected the file manifest constraint perfectly.
- **DedupResult naming conflict resolved pre-emptively**: The plan explicitly named `DefragDedupResult` to avoid the existing `dedup.go:26` type. Workers followed this without issue.
- **heal.sh correctly detected build dep**: Worker-skill's `INVALID_AO_CMD for ao mine` was a legitimate cross-worker dependency (mine binary not yet built). Resolved with `make build`.
- **TestCobraExpectedCmdsMatchRegistration** pattern: This explicit allowlist test is now proven as a reliable regression guard — both `mine` and `defrag` needed to be added, and the test caught it immediately.

### What Was Hard

- **bd port mismatch at session start**: Dolt server on 3307 but bd expected 13936. Needed to scan bd binary strings to find `BEADS_DOLT_SERVER_PORT`. Added ~15 min overhead before any work began.
- **Stale LSP diagnostics**: `DedupResult` redeclaration diagnostics appeared during wave 1 review, but the worker had already fixed it. Caused unnecessary investigation before `go build` confirmed no actual error.
- **Context compaction mid-vibe**: The vibe skill invocation was interrupted by context compaction, requiring full vibe re-execution in a new session context.

### Do Differently Next Time

- **Pre-set `BEADS_DOLT_SERVER_PORT=3307` in shell env**: Add to `~/.zshenv` or project CLAUDE.md so bd works without env prefix every time.
- **Build binary before heal.sh**: After adding a new ao command, always `make build` before running `heal.sh --strict`. Automate: add `go build ./cmd/ao` step to pre-heal checklist.
- **`--json` flag convention**: When adding `--json` to a command, suppress the human-readable summary when JSON output is requested. Consistent with other `ao` commands.

### Patterns to Reuse

- **Mine→Defrag split**: Separating mechanical extraction (Mine) from reasoning (Grow) from cleanup (Defrag) is the right architecture for knowledge management tools. Parallels the existing seed/forge/flywheel pattern.
- **`continue-on-error: true` for optional sources**: Tool sources that require external binaries (gocyclo, git) should gracefully degrade. Mine's per-source warning pattern is a good template.
- **`ATHENA_OUTPUT_DIR` env var override**: CI jobs that write to /tmp/ while gates read from repo-local paths need an env override. Pattern established — use in similar future gate scripts.

### Anti-Patterns to Avoid

- **Storing co-change data as `[][]string` with single-element outer array**: If the outer array can only have 0 or 1 elements, use a flat `[]string` or document the invariant explicitly. Multi-dimensional types imply multiple clusters.
- **Silent git error absorption at the wrong level**: `mineGitLog` returns `nil` error on `cmd.Output()` failure, so the upstream warning branch in `runMine` is dead code for that path. Error handling should be at the same level as the warning emission.

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | repo | Fix `--json` double-write in `runMine` (suppress summary when JSON output) | P1 | next-cycle | S | Vibe finding #2: unparseable JSON output when not using --quiet |
| 2 | repo | Rename `CoChangeClusters [][]string` to `TopCoChangeFiles []string` | P2 | next-cycle | S | Vibe finding #4: misleading outer array implies multiple clusters |
| 3 | execution | Add `make build` to pre-heal-skill checklist in CLAUDE.md | P1 | now | S | heal.sh false-positive for cross-worker command deps |
| 4 | execution | Export `BEADS_DOLT_SERVER_PORT=3307` in shell env | P1 | now | S | bd port mismatch adds 15 min overhead every session |
| 5 | ci-automation | Add `ao mine` and `ao defrag` to `ao goals measure` validation path | P2 | next-cycle | M | athena-freshness gate needs nightly run to pass; local dev has no feedback loop |
| 6 | repo | Normalize defrag file permissions to 0o644 to match mine.go | P2 | next-cycle | S | Inconsistent permissions could block CI user reading reports |

### Recommended Next /rpi
/rpi "fix ao mine --json double-write and CoChangeClusters shape"

## Prior Findings Resolution Tracking

| Metric | Value |
|--------|-------|
| Backlog entries analyzed | 3 unconsumed high-severity items |
| Prior findings total | 3 |
| Resolved findings (this epic) | 0 (unrelated items: merge-worktrees, t.Cleanup, 85% coverage gate) |
| Unresolved findings | 3 |
| Resolution rate | 0% (all are carry-forward from prior epics) |

## Command-Surface Parity Checklist

| Command File | Run-path Covered by Test? | Evidence | Intentionally Uncovered? |
|---|---|---|---|
| `cli/cmd/ao/mine.go` | yes | `TestRunMine_DryRun`, `TestWriteMineReport_CreatesLatest`, `TestMineAgentsDir_OrphanDetection` | — |
| `cli/cmd/ao/defrag.go` | yes | `TestRunDefrag_DryRun`, `TestWriteDefragReport_CreatesLatest`, `TestSweepOscillatingGoals_Oscillating` | — |

## Status

[x] CLOSED — All 5 issues completed, learnings captured, vibe PASS
[ ] FOLLOW-UP — 6 improvement items logged in next-work.jsonl

## Next Work

| # | Title | Type | Severity | Source |
|---|-------|------|----------|--------|
| 1 | Fix ao mine --json stdout double-write | tech-debt | high | council-finding |
| 2 | Rename CoChangeClusters to TopCoChangeFiles | tech-debt | medium | council-finding |
| 3 | Normalize defrag file permissions to 0o644 | tech-debt | low | council-finding |
| 4 | Add make build step to CLAUDE.md pre-heal checklist | process-improvement | medium | retro-learning |
| 5 | Export BEADS_DOLT_SERVER_PORT in shell env | process-improvement | high | retro-learning |
| 6 | Add ao mine/defrag to local dev feedback loop | improvement | medium | retro-pattern |
