# Post-Mortem: Swarm — Post-Mortem Findings Remediation

**Date:** 2026-02-26
**Epic:** Swarm execution of 7 harvested items from CLI test coverage post-mortem
**Duration:** ~10 minutes parallel execution, ~20 minutes total including merge
**Cycle-Time Trend:** Faster than the test coverage sprint (~45 min parallel). Smaller scope, well-defined items.

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | PASS | All 7 items addressed. 6 produced code, 1 produced audit. Stats: +859/-216 lines, 16 files, all tests pass. |
| Tech-Debt | WARN | Three near-duplicate helper pairs preserved in testutil_test.go (pragmatic but should consolidate). cov3W2CaptureStdout uses fixed 64KB buffer. |
| Learnings | PASS | Strong patterns: table-driven negative tests, channel-based watchdog testing, preflight scripts. |

### Implementation Assessment

All 7 items from the previous post-mortem were addressed:

1. **Makefile build dep (P0)**: `test:` and `test-coverage:` targets now depend on `build`. 2-line change, highest impact.
2. **Shared test helpers (P1)**: 10 helpers extracted into `testutil_test.go` from 8 files. Zero duplicates confirmed.
3. **Negative-path tests (P1)**: 10 test functions with 36 runnable subtests covering missing args, invalid flags, unknown commands, error formatting.
4. **Preflight script (P1)**: 67-line script with 6 checks, portable macOS/Linux.
5. **os.Chdir audit (P2)**: Correctly identified all 160+ sites as requiring production refactor. No forced changes — good scope discipline.
6. **Smoke test strengthening (P1)**: +17 tests now exercising actual RunE paths.
7. **Sleep replacement (P2)**: 5 sleeps replaced with channel-based `select`, 3 left intentionally (<100ms).

### Concerns

- `chdirTemp` and `setupTempWorkdir` in testutil_test.go are functionally identical — consolidate in follow-up
- `cov3W2CaptureStdout` uses fixed 64KB buffer (silently truncates larger outputs)
- `chdirTo` helper doesn't register t.Cleanup — callers must manually restore
- Item 4 committed directly to main, bypassing worktree isolation model
- `cp` alias was interactive — agent environments should use `/bin/cp -f` or sanitized PATH

## Learnings (from retro)

### What Went Well
- Worktree isolation worked — 7 agents, zero merge conflicts, one clean integration commit
- Agent #5 correctly recognized scope limits instead of forcing a bad fix (os.Chdir audit)
- High throughput: 6 of 7 items produced mergeable code in under 10 minutes wall-clock
- Simplest item (Makefile) finished first (~3 min) — serves as dispatch canary
- Test coverage gains were substantive: 29 negative-path tests, 17 strengthened smoke tests
- Selective restraint on sleep replacement (5 of 8, 3 left with justification)

### What Was Hard
- Cobra's global state created friction for negative-path tests (rootCmd flag reset)
- `cp` alias being interactive silently blocked file copy until diagnosed
- Shared helpers refactor (9 files, 10 functions) was riskiest change — longest-running item
- Item 4 committing directly to main broke isolation model

### Do Differently Next Time
- Pre-seed agents with known framework footguns (Cobra global state, os.Chdir scope)
- Enforce shell hygiene: use `/usr/bin/env` paths or sanitized environment in agents
- Gate ALL agents to worktree branches, no exceptions (including trivial items)
- Set complexity ceiling for single-agent tasks (~6 files max)
- Add "scope escape" template for agents that find the task exceeds their mandate

### Patterns to Reuse
- Worktree-per-agent with single integration commit
- "Audit, don't force" for scope-limited tasks
- Selective replacement with documented exceptions
- Fastest-first completion as swarm health canary
- Sizing batches from post-mortem findings (structured pipeline)

### Anti-Patterns to Avoid
- Relying on shell aliases in agent environments
- Allowing any agent to commit directly to main
- Dispatching large refactors without file-list pre-scan for overlap
- Treating "all tests pass" as sufficient (add diff review, symbol check)
- Assuming agents will self-report scope violations (build guardrails)

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | repo | Unify chdirTemp/setupTempWorkdir into single helper | P1 | now | S | Council found these are functionally identical |
| 2 | repo | Replace cov3W2CaptureStdout fixed buffer with io.ReadAll | P1 | now | S | Council found 64KB truncation risk |
| 3 | execution | Pre-seed agent prompts with known framework footguns | P1 | next-cycle | S | Negative-path agent had to discover Cobra flag reset issue |
| 4 | ci-automation | Sanitize agent shell environment (bypass aliases) | P0 | now | S | `cp` alias silently blocked file copy |
| 5 | execution | Add integration merge checklist script (diff review + symbol check) | P1 | next-cycle | M | Manual verification steps should be automated |
| 6 | repo | Refactor production code to accept projectDir parameter (os.Chdir elimination) | P2 | later | L | 160+ os.Chdir sites block t.Parallel(); requires 50+ production function changes |
| 7 | execution | Add scope-escape reporting template for agents | P1 | next-cycle | S | Item 5 invented its own format; should be standardized |

### Recommended Next /rpi
/rpi "unify duplicate test helpers and replace cov3W2CaptureStdout fixed buffer with io.ReadAll"

## Prior Findings Resolution Tracking

| Metric | Value |
|---|---|
| Backlog entries analyzed | 1 |
| Prior findings total | 7 |
| Resolved findings | 6 |
| Unresolved findings | 1 |
| Resolution rate | 85.7% |

| Source Epic | Findings | Resolved | Unresolved | Resolution Rate |
|---|---:|---:|---:|---:|
| rpi-cli-test-coverage | 7 | 6 | 1 | 85.7% |

The unresolved finding is Item 5 (os.Chdir refactor) which was correctly identified as requiring production code changes beyond the scope of test-only work.

## Command-Surface Parity Checklist

| Metric | Value |
|--------|-------|
| Total command files | 112 |
| Files with tests | 109 |
| Files without tests | 3 |
| Coverage % | 97.3% |
| Total test functions | 3,225 |

No parity regression from the swarm work. Three uncovered files (main.go, root.go, rpi.go) remain intentionally uncovered.

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | Unify chdirTemp/setupTempWorkdir into single helper | tech-debt | medium | council-finding | agentops |
| 2 | Replace cov3W2CaptureStdout fixed buffer with io.ReadAll | tech-debt | medium | council-finding | agentops |
| 3 | Pre-seed agent prompts with known framework footguns | process-improvement | medium | retro-pattern | * |
| 4 | Sanitize agent shell environment to bypass aliases | process-improvement | high | retro-learning | * |
| 5 | Add integration merge checklist script | process-improvement | medium | retro-pattern | * |
| 6 | Refactor production code to accept projectDir parameter | tech-debt | low | council-finding | agentops |
| 7 | Add scope-escape reporting template for agents | process-improvement | medium | retro-pattern | * |

## Status

[x] CLOSED - Work complete, learnings captured
