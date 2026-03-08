# Sweep Manifest: na-bnr

Date: 2026-03-08
Epic: `na-bnr`
Scope commits: `0f44ce84`, `747dbd03`, `db00ee73`

## Batch A

Files:
- `docs/newcomer-guide.md`
- `skills-codex-overrides/catalog.json`
- `scripts/validate-codex-override-coverage.sh`
- `tests/skills/test-codex-override-coverage.sh`

Findings:
- none

## Batch B

Files:
- `.github/workflows/validate.yml`
- `scripts/ci-local-release.sh`
- `scripts/pre-push-gate.sh`
- `scripts/validate-codex-backbone-prompts.sh`
- `tests/scripts/pre-push-gate.bats`
- `tests/scripts/test-codex-backbone-prompts.sh`

Findings:
- P2: `.github/workflows/validate.yml` still omits blocking Codex artifact/runtime checks that local validation treats as required: generated-artifact parity, install-bundle parity, and headless runtime validation.
- P3: `tests/scripts/pre-push-gate.bats` does not assert that the new Codex gates fail `scripts/pre-push-gate.sh` when `validate-codex-backbone-prompts.sh` or `validate-codex-override-coverage.sh` returns non-zero.

## Batch C

Files:
- `skills-codex-overrides/status/prompt.md`
- `skills-codex-overrides/recover/prompt.md`
- `skills-codex-overrides/swarm/prompt.md`
- `skills-codex-overrides/codex-team/prompt.md`
- generated `skills-codex/*/prompt.md` for the same skills

Findings:
- none
