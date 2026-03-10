---
id: plan-2026-03-10-native-redteam-harness
type: plan
date: 2026-03-10
source: "user request to enhance repo-native redteam skills instead of using Promptfoo cloud scans"
---

# Plan: Repo-Native LLM Redteam Harness

## Goal

Add a first executable repo-native LLM redteam capability that validates
AgentOps prompt and skill surfaces without depending on Promptfoo Cloud. The
first slice should be deterministic, machine-checkable, and narrow enough to
ship in one RPI cycle.

## Scope

### Wave 1: Deterministic Redteam Primitive

Add a new repo-surface redteam script under `skills/security-suite/scripts/`
that:

- scans a repo root against a JSON attack pack
- evaluates prompt-injection, tool-misuse, secret-exfiltration, and unsafe
  shell attack cases using file-targeted regex requirements
- writes machine-readable JSON plus a Markdown summary
- exits non-zero when fail-severity attack cases are not resisted

Primary files:
- `skills/security-suite/scripts/prompt_redteam.py`
- `skills/security-suite/references/agentops-redteam-pack.json`
- `tests/scripts/test-security-suite-redteam.sh`

### Wave 2: Skill Contract, Validation, and Codex Parity

Update the `security-suite` skill to describe the new redteam primitive, keep
its references and validation script aligned, and regenerate the Codex bundle so
the compiled artifacts match the canonical source skill.

Primary files:
- `skills/security-suite/SKILL.md`
- `skills/security-suite/scripts/validate.sh`
- `skills/using-agentops/SKILL.md`
- `skills/SKILL-TIERS.md`
- generated `skills-codex/**`

## Selected Approach

Implement a deterministic, policy-driven redteam harness for text surfaces
instead of trying to clone Promptfoo's hosted model-scanning behavior. The
attack pack expresses repo-specific adversarial cases as file globs plus
required or forbidden defenses, which keeps the first slice executable and
stable in CI.

## Cross-Cutting Constraints

- Do not imply model execution or hosted scanning. This slice is an offline
  repo-surface redteam harness.
- Keep `skills/security-suite/SKILL.md` as the canonical contract and regenerate
  `skills-codex/` rather than hand-editing generated artifacts.
- Every new reference file under `skills/security-suite/references/` must be
  linked from the skill doc.
- Validation must stay machine-checkable and CI-friendly.
- Do not touch unrelated user changes in the canonical root worktree.

## Dependency Order

1. Add the prompt redteam engine and default attack pack.
2. Add fixture coverage that proves pass and fail behavior.
3. Update the skill contract and validation wiring.
4. Regenerate Codex skill artifacts and run relevant gates.

## Acceptance

- The repo has an executable prompt redteam command under `security-suite`.
- The command can scan a repo root and emit JSON and Markdown findings.
- Fail-severity attack cases produce a non-zero exit.
- The default AgentOps attack pack covers prompt-injection, tool-misuse,
  secret-exfiltration, and unsafe-shell scenarios.
- `security-suite` docs and validation scripts match the implemented command.
- Generated Codex artifacts stay in parity with the updated source skill.

## Validation

```bash
bash tests/scripts/test-security-suite-redteam.sh
bash skills/security-suite/scripts/validate.sh
bash skills/heal-skill/scripts/heal.sh --strict
bash tests/skills/validate-skill.sh security-suite skills
bash scripts/sync-codex-native-skills.sh
bash scripts/validate-codex-override-coverage.sh
bash scripts/validate-codex-skill-parity.sh
bash scripts/validate-codex-generated-artifacts.sh
bash scripts/validate-codex-install-bundle.sh
bash scripts/validate-headless-runtime-skills.sh --runtime codex
```
