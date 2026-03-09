---
id: post-mortem-2026-03-08-b50e2eb4
type: post-mortem
date: 2026-03-08
source: "commit b50e2eb4; beads na-001, na-evd, na-9bv.1"
---

# Post-Mortem: Canonical Root, Vibe Fixtures, and Codex Contract Governance

**Epic:** `na-001`, `na-evd`, `na-9bv.1`
**Commit:** `b50e2eb4`
**Cycle-Time Trend:** Fast delivery with strong local validation, but proof depth lagged the implementation in a few places.

## Council Verdict: WARN

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | WARN | `na-9bv.1` landed the right control point, but the fixture suite still does not prove non-backbone operator-contract mismatches. |
| Tech-Debt | WARN | `vibe-check` tests still rely on process-global stdout mutation and manual global restore patterns. |
| Learnings | PASS | Seeded git-history fixtures and catalog-driven Codex policy are the right direction for deterministic validation. |

### Implementation Assessment

This batch delivered three useful outcomes in one pass:

1. `na-evd` replaced ambient-checkout assumptions with seeded temporary git repositories in [`cli/cmd/ao/vibe_check_test.go`](/Users/fullerbt/gt/agentops/crew/nami/cli/cmd/ao/vibe_check_test.go) and [`cli/cmd/ao/testutil_test.go`](/Users/fullerbt/gt/agentops/crew/nami/cli/cmd/ao/testutil_test.go).
2. `na-9bv.1` moved Codex operator-contract governance into [`skills-codex-overrides/catalog.json`](/Users/fullerbt/gt/agentops/crew/nami/skills-codex-overrides/catalog.json) and taught the validator to read policy from data instead of a shell hardcode.
3. `na-001` confirmed the canonical-root/common-git-dir ownership decision was already enforced by current repo behavior, so the work closed as validated state rather than a code diff.

All listed local gates passed before the push of `b50e2eb4`, and the branch was pushed successfully after removing an unrelated attached worktree that tripped the push path.

### Concerns

1. **Non-backbone proof gap remains:** `tests/skills/test-codex-override-coverage.sh` does not yet prove generated/override mismatch handling for a required-contract skill outside the older backbone set.
2. **Test helper globals remain fragile:** stdout capture in [`cli/cmd/ao/testutil_test.go`](/Users/fullerbt/gt/agentops/crew/nami/cli/cmd/ao/testutil_test.go) still swaps `os.Stdout`, which is panic-sensitive and blocks safe parallelization.
3. **Governance is still text-fragment based:** the catalog is authoritative now, but enforcement still depends on matching prompt text markers rather than generated or parsed structure.
4. **`na-001` closure evidence is thinner than the other two items:** it is correct, but it relies on gate/test evidence and bead notes instead of a shipped diff artifact.
5. **Scope expanded slightly:** `na-9bv.1` broadened coverage policy beyond the smallest possible backbone-only slice, which was valuable, but it widened the proof surface.

## Learnings

### What Went Well

- Seeded git-history fixtures are materially better than skip-prone temp-dir stubs for git-aware command tests.
- Treating Codex override policy as machine data in `catalog.json` is the correct control point for long-term governance.
- Negative-path validator tests are a good fit for governance work because they prove drift detection, not just happy-path sync.

### What Was Hard

- Repo-state validation work like `na-001` is harder to prove crisply in a post-mortem than code-bearing issues.
- Push reliability was affected by an unrelated attached worktree, which delayed closure even though the current branch was clean.
- Some test scaffolding debt survived because the batch prioritized deterministic fixtures over global-state cleanup.

### Do Differently Next Time

- Add non-backbone negative fixtures in the same wave as governance broadening so proof coverage expands with policy scope.
- Prefer generated or structural operator-contract enforcement over grep-style prompt fragments.
- When closing evidence-only policy work, emit a dedicated proof artifact so later retrospectives do not rely only on gate output.

### Patterns to Reuse

- Replace ambient repo assumptions with seeded real git history whenever command behavior depends on git discovery.
- Move policy from shell conditionals into a catalog before widening scope.
- Keep generated Codex artifacts in the same validation loop as their source overrides.

### Anti-Patterns to Avoid

- Declaring governance complete when only the legacy backbone slice is proven by fixtures.
- Leaving process-global stdout swapping in shared test helpers once tests start becoming more integration-heavy.

### Footgun Entries

| Footgun | Impact | Prevention |
|---------|--------|------------|
| Git-aware tests that depend on the live checkout create false confidence | Coverage and behavior can look green while the real git-discovery path is untested | Use seeded temp repos and nested fixture paths instead of ambient repo assumptions |
| Push can fail on an unrelated attached worktree | Clean work can look broken late in the delivery path | Run `bash scripts/check-worktree-disposition.sh` before `git push` and clean foreign worktrees early |

## Knowledge Lifecycle

### Backlog Processing (Phase 3)

- Scanned: 56 learning files newer than the current marker window
- Merged: 0 exact duplicates
- Flagged stale: 0
- Note: the scan appears broader than intended because the existing marker window lagged behind recent learning mtimes

### Activation (Phase 4)

- Promoted to `MEMORY.md`: 0
- Constraints compiled: 0
- Next-work items fed: 4
- Reason: project `MEMORY.md` is already 209 lines, above the 200-line guidance in the activation policy

### Retirement (Phase 5)

- Archived: 0 learnings

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | validation | Add generated/override mismatch fixture coverage for non-backbone required-contract skills | P1 | next-cycle | S | Plan-compliance judge found broader governance shipped without broader proof fixtures |
| 2 | codex-sync | Generate or structurally validate operator-contract blocks from catalog data | P1 | next-cycle | M | Tech-debt and learnings judges both flagged verbatim marker matching as brittle |
| 3 | testing | Make stdout capture helpers panic-safe and parallel-safe | P1 | next-cycle | S | `os.Stdout` swapping in shared helpers is order-sensitive and cleanup-fragile |
| 4 | process | Emit a dedicated proof artifact for evidence-only policy closures | P2 | later | S | `na-001` closed correctly, but its proof surface was thinner than code-bearing issues |

### Recommended Next `$rpi`

`$rpi "Add non-backbone operator-contract mismatch fixtures and replace string-fragment Codex operator-contract enforcement with structural proof"`

## Prior Findings Resolution Tracking

| Metric | Value |
|---|---|
| Backlog entries analyzed | 27 |
| Prior findings total | 146 |
| Resolved findings | 5 |
| Unresolved findings | 141 |
| Resolution rate | 3.42% |

| Source Epic | Findings | Resolved | Unresolved | Resolution Rate |
|---|---:|---:|---:|---:|
| march-8-delivery-chain | 6 | 3 | 3 | 50.0% |
| na-fr0 | 2 | 2 | 0 | 100.0% |
| na-bnr | 2 | 0 | 2 | 0.0% |
| na-de8 | 3 | 0 | 3 | 0.0% |

## Command-Surface Parity Checklist

| Command File | Run-path Covered by Test? | Evidence | Intentionally Uncovered? | Reason |
|---|---|---|---|---|
| cli/cmd/ao/vibe_check.go | yes | `TestRunVibeCheck_*`, `TestResolveVibeCheckRepoPath_UsesGitTopLevel` | no | — |
| scripts/validate-codex-override-coverage.sh | yes | `tests/skills/test-codex-override-coverage.sh` | no | — |
| scripts/check-worktree-disposition.sh | yes | `tests/scripts/test-worktree-disposition.sh` | no | — |

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | Add generated/override mismatch fixture coverage for non-backbone required-contract skills | improvement | medium | council-finding | agentops |
| 2 | Generate operator-contract prompt blocks from `catalog.json` during Codex sync | improvement | medium | retro-learning | agentops |
| 3 | Make stdout capture helpers panic-safe and parallel-safe | tech-debt | medium | council-finding | agentops |
| 4 | Emit structured proof artifacts for evidence-only policy closures | process-improvement | low | council-finding | agentops |

## Status

[ ] CLOSED - Work complete with no follow-up
[x] FOLLOW-UP - Additional proof and debt items were harvested
