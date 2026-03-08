---
id: retro-2026-03-08-march-8-delivery-chain
type: retro
date: 2026-03-08
source_epic: march-8-delivery-chain
---

# Retro: March 8 Delivery Chain

**Scope:** commits `a358435f` through `dd3dee64` on `main`, covering `na-2uh`, `na-cwt`, `na-zoc`, and `na-cr9`.

## Summary

The March 8 chain landed the audit fixes, moved Codex-first maintenance from convention to contract, and added an explicit override-parity guard. The code/docs outcomes were good, but the delivery chain exposed three follow-on gaps: the `next-work` contract drifted during the per-item migration, CI still diverges from local Codex guard enforcement, and the final shipped commit failed CI on a narrow test/coverage regression rather than on the new Codex work itself.

## Checkpoint Summary

| Check | Result | Detail |
|-------|--------|--------|
| Git status before retro | WARN | Worktree contains unrelated in-flight changes outside this retro (`scripts/validate-codex-override-coverage.sh` deleted, `tests/skills/test-codex-override-coverage.sh` untracked) |
| Chain loaded | PASS | `.agents/ao/chain.jsonl` exists |
| Prior phases locked | WARN | `implement`/`vibe` are locked for `na-2uh`; no matching fresh pre-mortem/post-mortem lock exists for the full March 8 delivery chain |
| FAIL verdicts in prior gates | PASS | No blocking prior council FAIL artifact found for this chain |
| Artifacts exist | PASS | No missing files detected in the changed-file set for `a358435f^..dd3dee64` |
| Idempotency | PASS | No prior `next-work.jsonl` entry for `march-8-delivery-chain` |

## What Went Well

- `na-2uh` stayed tightly scoped and mechanically validated. The implementation and phase summaries remained specific about files, tests, and acceptance criteria.
- The Codex-first work established a clean maintenance model: `skills/` as canonical contract, `skills-codex-overrides/` as Codex-specific tailoring, and `skills-codex/` as generated output.
- The team added enforcement, not just docs. `na-cr9` moved the override model into an executable guard and then immediately tightened that guard to compare generated prompts against override sources.
- Prior carry-forward debt is still trending in the right direction: `.agents/rpi/next-work.jsonl` now shows `121/136` items resolved (`88.97%`), with only three source batches still unconsumed.

## What Was Hard

- Commit-to-bead traceability is weak. The March 8 commits do not reference `na-*` IDs, so closure integrity depends on file inference and timing instead of explicit git evidence.
- The per-item `next-work` migration changed runtime behavior faster than it updated the schema contract and post-mortem harvest docs.
- Some validation improvements stayed local-only. The Codex override coverage guard is in the local pre-push path, but not yet enforced by CI.

## What Did Not Go Well

- The final shipped commit `dd3dee64` did not finish green in CI. GitHub Actions run `22825014214` failed on March 8, 2026 in two places:
  - `coverage-ratchet`: `internal/vibecheck` dropped from `100.0%` to `99.2%`
  - `bats-tests`: `not ok 223 pre-push-gate.sh passes when no Go changes`
- `na-cwt` improved queue behavior, but the canonical schema in `.agents/rpi/next-work.schema.md` still describes entry-level consumption and append-only writes, while the runtime now does per-item claim/release and file rewrites.
- The new queue mutation path is still vulnerable to concurrent writers because it rewrites the full JSONL file without locking or compare-and-swap semantics.
- The `vibe-check` test hardening improved coverage around `GIT_DIR`, but one path now skips on missing git context instead of always forcing deterministic repo fixtures.

## Prior Findings Resolution Tracking

| Metric | Value |
|--------|-------|
| Total entries | `24` |
| Total items | `136` |
| Resolved items | `121` |
| Unresolved items | `15` |
| Resolution rate | `88.97%` |

Unresolved source batches:

- `na-8ar`: `8`
- `na-3re`: `4`
- `na-de8`: `3`

## Learnings Extracted

- L1: Codex-first changes need an atomic closure checklist: source skill, override, generated artifact, validation guard, and CI enforcement should land together.
- L2: Queue-contract migrations must update schema/docs/examples and writer semantics in the same wave, or the repo loses a single source of truth immediately.

See:

- `.agents/learnings/2026-03-08-codex-guardrails-must-be-atomic.md`
- `.agents/learnings/2026-03-08-next-work-migrations-need-schema-and-locking.md`

## Recommended Next Work

1. Fix the immediate CI blockers from run `22825014214`: the failing BATS case in `tests/scripts/pre-push-gate.bats` and the `internal/vibecheck` coverage drop around `gitDiscoveryEnv` in `cli/internal/vibecheck/timeline.go`.
2. Publish a canonical `next-work` schema update and parity check that matches the per-item queue lifecycle now implemented in `cli/cmd/ao/rpi_loop.go`.
3. Make `next-work.jsonl` mutation concurrency-safe before more autonomous consumers depend on it.
4. Promote Codex override coverage into CI and broaden it past prompt-file equality.
5. Finish the broader push/pregate reproducibility work already scoped in `.agents/plans/2026-03-08-next-work-after-push.md`.
