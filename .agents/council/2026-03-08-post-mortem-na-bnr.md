---
id: post-mortem-2026-03-08-na-bnr
type: post-mortem
date: 2026-03-08
source: "bead na-bnr"
---

# Post-Mortem: Codex-Native Skill Hardening (na-bnr)

**Epic:** na-bnr
**Duration:** 18m 58s
**Cycle-Time Trend:** Fast for a three-wave prompt and validator hardening pass. Most time went into enforcement and retrospective verification, not implementation.

## Council Verdict: WARN

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | WARN | All three waves landed, but CI still enforces a weaker Codex contract than local gates. |
| Tech-Debt | WARN | `Validate` does not run the same blocking Codex artifact/runtime checks as the local release path. |
| Learnings | WARN | The operator-contract pattern is strong, but Codex guardrails still need atomic promotion across local, CI, and failure-path tests. |

## Checkpoint Policy

| Check | Status | Detail |
|-------|--------|--------|
| Chain loaded | WARN | `.agents/ao/chain.jsonl` exists, but it is a mixed historical ledger rather than a scoped `na-bnr` chain |
| Prior phases locked | WARN | No scoped `research/plan/pre-mortem/implement/crank/vibe` chain entries for `na-bnr` |
| No FAIL verdicts | PASS | No blocking prior FAIL verdicts found in the chain ledger |
| Artifacts exist | PASS | Plan, pre-mortem, phase-2 summary, and sweep artifacts exist on disk |
| Idempotency | PASS | No prior harvested `na-bnr` entry existed in `.agents/rpi/next-work.jsonl` |

## Closure Integrity

| Check | Result | Details |
|-------|--------|---------|
| Git Evidence | PASS | All three closed children have scoped-file evidence in the delivered commits |
| Phantom Beads | PASS | Child titles and descriptions are specific and implementation-scoped |
| Orphaned Children | PASS | `bd children na-bnr` matches the closed child set |
| Multi-Wave Regression | PASS | Sweep and final gate run did not reveal regressions across the three wave commits |
| Stretch Goals | PASS | No stretch-only child was bulk-closed without work |

## Implementation Assessment

The implementation delivered the planned three-wave shape:
- wave 1 introduced machine-readable operator contracts in `skills-codex-overrides/catalog.json` and enforced them in `scripts/validate-codex-override-coverage.sh`
- wave 2 added generated-prompt behavior validation in `scripts/validate-codex-backbone-prompts.sh`, wired it into local validation, and covered it in BATS and script tests
- wave 3 tightened the compact operator prompts for `status`, `recover`, `swarm`, and `codex-team`, then regenerated the matching `skills-codex/` artifacts

Mechanical verification passed:
- metadata verification found no missing planned files or broken scoped links
- all scoped files for `na-bnr.1`, `na-bnr.2`, and `na-bnr.3` were touched by the delivered commits
- `scripts/pre-push-gate.sh --scope upstream` passed on the final implementation stack

## Concerns

1. **CI scope drift remains**: `.github/workflows/validate.yml` runs Codex runtime sections, skill parity, and backbone prompts, but it still does not enforce generated-artifact parity, install-bundle parity, or headless runtime validation. Local gates are therefore stronger than CI.
2. **Failure-path wiring is under-tested**: `tests/scripts/pre-push-gate.bats` proves the new Codex gates are stubbed and counted, but it does not assert that those gates actually fail the pre-push script when they return non-zero.
3. **Job naming is now stale**: the `codex-runtime-sections` CI job guards more than runtime sections, which increases maintenance risk because the job name no longer describes the full enforced surface.

## Learnings

### What Went Well
- The operator-contract pattern turned Codex prompt requirements into machine-checkable policy instead of editorial preference.
- The backbone generated-prompt validator closed a real gap between source parity and behavior parity.
- The compact operator prompts are now materially clearer for Codex without drifting from the canonical source skill model.

### What Was Hard
- Keeping override source, generated `skills-codex/` output, and gate wiring aligned remained easy to get wrong until the full sync-and-validate chain was rerun.
- The plan said “local validation and CI,” but that phrase hid a real difference between local and CI enforcement depth.

### Do Differently Next Time
- Promote Codex guardrails atomically: local gate, CI gate, generated artifacts, and negative-path tests in the same wave.
- Treat pre-push BATS failure-path coverage as part of new gate adoption, not as optional polish after the validator lands.

### Patterns to Reuse
- Express prompt expectations in `skills-codex-overrides/catalog.json`, then validate both override source and generated output against that contract.
- Separate backbone skill behavior checks from generic parity checks so failures point to the right Codex surface quickly.

### Anti-Patterns to Avoid
- Declaring a Codex gate “in CI” when only one slice of the local blocking contract has actually been promoted.
- Relying on happy-path BATS coverage for gate wiring that is supposed to block bad pushes.

## Knowledge Lifecycle

### Backlog Processing (Phase 3)
- Scanned: 2 actionable findings from the sweep and council
- Merged: 0 duplicates
- Flagged stale: 0

### Activation (Phase 4)
- Promoted to MEMORY.md: 0
- Constraints compiled: 0
- Next-work items fed: 2

### Retirement (Phase 5)
- Archived: 0 learnings

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | ci | Promote generated-artifact parity, install-bundle parity, and headless runtime validation into `Validate` | P1 | now | M | CI currently trails local blocking Codex gates |
| 2 | testing | Add negative-path BATS coverage for Codex backbone/override gate failures in `pre-push-gate.sh` | P2 | now | S | The current BATS suite checks counting and stubs, not failure behavior |
| 3 | ci-docs | Rename or split `codex-runtime-sections` so the job name matches the enforced contract surface | P3 | later | S | The job now covers multiple Codex validation surfaces beyond runtime sections |

### Recommended Next $rpi
$rpi "Promote blocking Codex artifact checks into CI and add failure-path tests for Codex pre-push gates"

## Prior Findings Resolution Tracking

| Metric | Value |
|---|---|
| Backlog entries analyzed | 25 |
| Prior findings total | 2 |
| Resolved findings | 0 |
| Unresolved findings | 2 |
| Resolution rate | 0% |

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | `na-tn6` Promote blocking Codex artifact checks into CI | task | high | council-finding | agentops |
| 2 | `na-5zj` Add failure-path tests for Codex pre-push gates | task | medium | council-finding | agentops |

## Status

[ ] CLOSED - Work complete, learnings captured
[x] FOLLOW-UP - Issues need addressing (create new beads)
