---
id: pre-mortem-2026-03-10-native-redteam-harness
type: pre-mortem
date: 2026-03-10
source: "[[.agents/plans/2026-03-10-native-redteam-harness.md]]"
---

# Pre-Mortem: Repo-Native LLM Redteam Harness

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Missing-Requirements | PASS | The plan is narrow enough because it targets one executable primitive, not a full Promptfoo clone. |
| Feasibility | PASS | A policy-driven repo-surface scanner fits the existing `security-suite` script pattern and can be tested offline. |
| Scope | PASS | Extending `security-suite` avoids unnecessary new-skill churn while still shipping real value. |
| Spec-Completeness | PASS | The acceptance criteria and validation commands are mechanical and repo-appropriate. |

## Shared Findings

- The main failure mode is scope creep into hosted model eval or promptfoo-style
  cloud scanning. The implementation must stay explicit that this slice is
  offline and deterministic.
- The default attack pack should target repo-owned control surfaces rather than
  generic LLM safety claims.
- Skill docs must avoid overselling the capability as a replacement for model
  redteam execution.

## Known Risks Applied

- No active finding-registry entries were loaded for this slice.

## Concerns Raised

- Regex-driven attack packs can become brittle if they encode prose too loosely.
- Updating a canonical skill requires Codex regeneration and parity checks.
- The first pack must be valuable enough to justify the new surface.

## Recommendation

Proceed. Implement a deterministic repo-surface redteam primitive with a
repo-owned attack pack, and document it as an offline contract scanner rather
than model execution.

## Decision Gate

[x] PROCEED - Council passed, ready to implement
[ ] ADDRESS - Fix concerns before implementing
[ ] RETHINK - Fundamental issues, needs redesign
