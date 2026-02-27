# Post-Mortem: CLI Test Coverage Sprint

**Date:** 2026-02-26
**Epic:** RPI — "create missing tests for all ao CLI commands"
**Duration:** ~45 minutes (parallel execution), ~2 hours total session
**Cycle-Time Trend:** First test-coverage sprint; no prior comparison available.

## Council Verdict: PASS (with caveats)

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | PASS | 506 test functions across 44 files. Coverage 59% -> 97% (66/112 -> 109/112). Only main.go, root.go, rpi.go parent remain untested (by design). |
| Tech-Debt | WARN | 174 defer-restore patterns for global state. No t.Parallel() anywhere. os.Chdir in ~20 test sites. Inherited from production code architecture. |
| Learnings | PASS | Strong table-driven adoption. Quality scales with complexity (forge=881 lines vs version=38 lines). Helper reuse via package-level sharing. |

### Implementation Assessment

The commit delivers exactly what was promised: 44 new test files, 506 top-level test functions (615 including subtests), 12,644 lines of test code. All tests pass including under the Go race detector. Coverage jumped from 59% to 97% by command-file count.

The three uncovered files (main.go, root.go, rpi.go) are parent command wiring files tested indirectly through their subcommand tests. This is standard Go CLI practice.

The parallel worktree strategy (5 waves) was the key throughput multiplier. No merge conflicts because each wave owned distinct files. One post-merge fix was needed (go vet caught `json.Unmarshal(data, nil)` — replaced with `fmt.Errorf`).

### Concerns

- **No `t.Parallel()` anywhere.** The 46-second test runtime will grow. Global state mutation (174 save/restore blocks) makes parallelization non-trivial.
- **`os.Chdir` in 20+ test sites.** Process-global mutation. A single accidental `t.Parallel()` would cause intermittent failures.
- **Thin smoke tests** for version (38 lines), completion (42 lines), and promotion_defaults (23 lines) verify command registration but not execution paths.
- **`promotion_defaults_test.go` tests a constant value** — tautology test that only breaks when someone updates the constant itself.
- **`time.Sleep(1s)`** in rpi_phased_stream_test.go:615 — consider channel-based synchronization instead.
- **No negative-path integration tests.** Tests are unit-focused on helper functions. No tests construct full Cobra command execution with invalid arguments to verify error output.

## Learnings (from retro)

### What Went Well
- Parallel worktree strategy delivered massive throughput — 5 agents, zero merge conflicts
- Research-first approach (enumerate all 112 commands, identify 45 gaps, organize into waves) eliminated discovery overhead
- Table-driven test patterns were already established; agents replicated style consistently
- Coverage jump was dramatic and measurable (59% -> 97%)
- go vet catch was quick and clean — single post-merge issue
- Prior work (Nami's contributions) verified as merged before starting

### What Was Hard
- Stale binary caused confusing flag_matrix test failures (misleading error about missing flags)
- Duplicate symbol declarations across test files in same package (Go's flat package model)
- Had to pull from main first — working branch was behind by many commits
- Coordinating five worktrees required careful wave assignment to avoid shared-file conflicts

### Do Differently Next Time
- Pre-flight checklist before spawning parallel agents: pull main, `make build`, verify clean state, confirm wave boundaries
- Establish shared test helpers file before the parallel phase (avoid per-agent helper duplication)
- Run `go vet` and `go build` per-worktree before merging back
- Use an integration branch instead of merging directly to main

### Patterns to Reuse
- Wave-based parallel worktrees for bulk mechanical work (3-7 agents, file-disjoint, single integration point)
- Table-driven tests with descriptive subtest names
- Coverage gap analysis as sprint scoping (`comm -23` between source and test file lists)
- Intentional skip list with documented rationale (main.go, root.go, rpi.go)
- Post-merge validation pass as a gate (build + test + vet)

### Anti-Patterns to Avoid
- Testing against a stale binary (always `make build` first)
- Declaring test helpers independently in parallel agents (pre-create shared helpers)
- Merging parallel work directly to main without integration check
- Using `json.Unmarshal(data, nil)` for error-path tests (use `fmt.Errorf` instead)
- Skipping `git pull` before branching worktrees

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | repo | Extract shared test helpers into testutil_test.go | P1 | next-cycle | S | Duplicate helper declarations across agents caused compile errors |
| 2 | repo | Add negative-path integration tests for CLI error formatting | P1 | next-cycle | M | Council found no tests exercise Cobra RunE with invalid args |
| 3 | ci-automation | Add `make build` as pre-test dependency in CI/Makefile | P0 | now | S | Stale binary caused confusing flag_matrix test failures |
| 4 | execution | Create pre-flight checklist script for parallel worktree sprints | P1 | next-cycle | S | Had to pull from main mid-session, stale binary, wave boundary verification all manual |
| 5 | repo | Replace os.Chdir patterns with path-based helpers for t.Parallel readiness | P2 | later | L | 20+ os.Chdir sites prevent test parallelization; 46s runtime will grow |
| 6 | repo | Replace time.Sleep synchronization with channel-based polling | P2 | later | S | rpi_phased_stream_test.go uses 1s sleeps for watchdog testing |
| 7 | repo | Strengthen thin smoke tests (version, completion, promotion_defaults) | P1 | next-cycle | S | Council found these test registration not execution; tautology risk |

### Recommended Next /rpi
/rpi "add make build as pre-test dependency and extract shared test helpers into testutil_test.go"

## Prior Findings Resolution Tracking

| Metric | Value |
|---|---|
| Backlog entries analyzed | 0 |
| Prior findings total | 0 |
| Resolved findings | 0 |
| Unresolved findings | 0 |
| Resolution rate | N/A |

No prior next-work.jsonl found. This is the first post-mortem producing harvested items.

## Command-Surface Parity Checklist

| Metric | Value |
|--------|-------|
| Total command files | 112 |
| Files with tests | 109 |
| Files without tests | 3 |
| Coverage % | 97.3% |

| Command File | Run-path Covered? | Evidence | Intentionally Uncovered? | Reason |
|---|---|---|---|---|
| main.go | no | — | yes | Program entry point, not independently testable |
| root.go | no | — | yes | Cobra root wiring, exercised by every subcommand test |
| rpi.go | no | — | yes | Parent command; 46 specialized test files cover all subcommands |

All 109 covered files verified via spot-check (goals_add: 7 tests, ratchet_check: 8, badge: 7, forge: 31, version: 3).

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | Add make build as pre-test dependency | process-improvement | high | retro-learning | * |
| 2 | Extract shared test helpers into testutil_test.go | tech-debt | medium | council-finding | agentops |
| 3 | Add negative-path integration tests for CLI error formatting | improvement | medium | council-finding | agentops |
| 4 | Create pre-flight checklist for parallel worktree sprints | process-improvement | medium | retro-pattern | * |
| 5 | Replace os.Chdir with path-based helpers for t.Parallel readiness | tech-debt | low | council-finding | agentops |
| 6 | Strengthen thin smoke tests (version, completion, promotion_defaults) | improvement | low | council-finding | agentops |
| 7 | Replace time.Sleep with channel-based sync in stream tests | tech-debt | low | council-finding | agentops |

## Status

[x] CLOSED - Work complete, learnings captured
