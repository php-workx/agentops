---
id: plan-2026-03-08-codex-native-skill-hardening
type: plan
date: 2026-03-08
source: "interactive follow-up after 2026-03-08 Codex-first rollout"
---

# Plan: Codex-Native Skill Hardening

## Goal

Deepen the Codex-first skill model without overlapping the already-landed
override rollout. Focus on enforceable operator contracts, generated-prompt
behavior checks for the backbone chain, and tighter Codex-native execution
prompts for compact operator skills.

## Scope

### Wave 1: Machine-Readable Operator Contract

Add machine-readable Codex operator expectations to the override catalog and
teach the coverage validator to enforce them for the highest-leverage backbone
skills.

Primary files:
- `skills-codex-overrides/catalog.json`
- `scripts/validate-codex-override-coverage.sh`
- `tests/skills/test-codex-override-coverage.sh`
- `docs/newcomer-guide.md`

### Wave 2: Backbone Generated-Prompt Behavior Checks

Add generated-artifact checks for the backbone Codex execution chain so changes
to `plan`, `rpi`, `vibe`, `post-mortem`, and `push` are validated at the prompt
behavior layer, not just override parity.

Primary files:
- `scripts/validate-codex-backbone-prompts.sh`
- `tests/scripts/test-codex-backbone-prompts.sh`
- `tests/scripts/test-codex-generated-artifacts.sh`
- `.github/workflows/validate.yml`

### Wave 3: Compact Operator Prompt Tightening

Tighten the Codex-native prompts for `status`, `recover`, `swarm`, and
`codex-team`, then regenerate `skills-codex/` so the compiled artifacts reflect
the more operational Codex UX.

Primary files:
- `skills-codex-overrides/status/prompt.md`
- `skills-codex-overrides/recover/prompt.md`
- `skills-codex-overrides/swarm/prompt.md`
- `skills-codex-overrides/codex-team/prompt.md`
- generated `skills-codex/**`

## Cross-Cutting Constraints

- `skills/<name>/SKILL.md` remains the canonical behavior contract.
- `skills-codex-overrides/` is the only source layer for Codex-native wording.
- Never hand-edit `skills-codex/` as source; regenerate it.
- Keep new checks machine-verifiable and CI-friendly.
- Preserve the current Codex maintenance model documented in `AGENTS.md` and
  `docs/newcomer-guide.md`.

## Dependency Order

1. Wave 1 establishes the operator contract vocabulary and validator.
2. Wave 2 adds backbone generated-prompt checks on top of that contract.
3. Wave 3 tightens compact operator prompts and validates them through the new
   contract and generated-artifact checks.

## Acceptance

- The override catalog can express Codex-native operator expectations in a
  machine-readable form.
- The override coverage validator fails when backbone prompts drift from those
  expectations.
- CI validates generated Codex prompt behavior for `plan`, `rpi`, `vibe`,
  `post-mortem`, and `push`.
- `status`, `recover`, `swarm`, and `codex-team` become more concise,
  operational, and Codex-specific without drifting from source skills.

## Validation

```bash
bash tests/skills/test-codex-override-coverage.sh
bash scripts/validate-codex-override-coverage.sh
bash tests/scripts/test-codex-backbone-prompts.sh
bash scripts/validate-codex-backbone-prompts.sh
bash scripts/sync-codex-native-skills.sh
bash scripts/validate-codex-skill-parity.sh
bash scripts/validate-codex-generated-artifacts.sh
bash scripts/validate-codex-install-bundle.sh
bash scripts/validate-headless-runtime-skills.sh
scripts/pre-push-gate.sh --scope upstream
```
