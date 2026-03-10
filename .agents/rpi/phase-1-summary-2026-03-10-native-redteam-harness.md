# RPI Phase 1 Summary: Repo-Native LLM Redteam Harness

- Date: 2026-03-10
- Goal: Build repo-native LLM redteam harness
- Epic: `ag-w2m`
- Complexity: `standard`
- Pre-mortem verdict: `PASS`

## Discovery Outcome

The repo already has deterministic security and binary-assurance workflows, but
it does not have an executable LLM/prompt redteam capability. Promptfoo's
`code-scans` flow is cloud-backed and diff-scoped, so the selected path is to
add a repo-native offline redteam primitive instead of importing promptfoo as a
runtime dependency.

## Selected Slice

Add a policy-driven repo-surface redteam command under `security-suite` that
evaluates attack cases against prompt and skill text using file globs plus
required or forbidden defenses. Keep the first pack focused on prompt
injection, tool misuse, secret exfiltration, and unsafe shell generation.

## Planned Issues

- `ag-w2m.2` implement the redteam primitive and fixture coverage
- `ag-w2m.1` wire skill docs, validation, and Codex parity

## Validation Bundle

- `bash tests/scripts/test-security-suite-redteam.sh`
- `bash skills/security-suite/scripts/validate.sh`
- `bash skills/heal-skill/scripts/heal.sh --strict`
- `bash tests/skills/validate-skill.sh security-suite skills`
- Codex sync/parity/install/headless validation commands from the execution packet
