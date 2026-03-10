# RPI Phase 2 Summary: Repo-Native LLM Redteam Harness

- Date: 2026-03-10
- Epic: `ag-w2m`
- Implementation verdict: `DONE`

## Delivered

- Added `skills/security-suite/scripts/prompt_redteam.py`, an offline
  repo-surface redteam scanner driven by JSON attack packs.
- Added
  `skills/security-suite/references/agentops-redteam-pack.json` with concrete
  AgentOps attack cases for prompt injection, context overexposure, destructive
  git misuse, security gate bypass, and unsafe shell or secret handling.
- Added `tests/scripts/test-security-suite-redteam.sh` with fixture pass/fail
  coverage plus a smoke run against the repo's own attack pack.
- Updated `security-suite` skill docs and validation wiring, plus related skill
  references and generated Codex artifacts.

## Issue Status

- `ag-w2m.2` implementation complete
- `ag-w2m.1` docs/parity work complete

## Files of Interest

- `skills/security-suite/scripts/prompt_redteam.py`
- `skills/security-suite/references/agentops-redteam-pack.json`
- `skills/security-suite/SKILL.md`
- `tests/scripts/test-security-suite-redteam.sh`
- generated `skills-codex/security-suite/**`
