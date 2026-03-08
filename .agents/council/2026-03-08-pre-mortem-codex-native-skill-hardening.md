---
id: pre-mortem-2026-03-08-codex-native-skill-hardening
type: pre-mortem
date: 2026-03-08
source: "[[.agents/plans/2026-03-08-codex-native-skill-hardening.md]]"
issue: "na-bnr"
---

# Pre-Mortem: Codex-Native Skill Hardening

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Missing-Requirements | PASS | The work is bounded to existing override infrastructure instead of reopening the full Codex rollout. |
| Feasibility | PASS | The repo already has a catalog, override validator, generated-artifact checks, and prompt overrides to extend. |
| Scope | PASS | The three waves are sequential and narrow: contract, behavior checks, then prompt tightening. |
| Spec-Completeness | PASS | Acceptance criteria name the exact files, validations, and generated-artifact boundaries for each wave. |

## Shared Findings

- This is the right size for a single crank epic: all three waves stay inside
  the Codex override/validation surface.
- The safest dependency order is contract first, generated-prompt checks
  second, prompt tightening third.
- The main failure mode is accidental overlap with the canonical `skills/`
  contract; the plan already constrains edits to overrides, validators, docs,
  and generated artifacts.

## Concerns Raised

- Wave 2 must validate generated prompt artifacts, not just override sources, or
  it will duplicate existing parity checks.
- Wave 3 should keep prompt changes compact and operational so it improves the
  Codex UX instead of adding more prose.

## Recommendation

Proceed with `na-bnr` as planned. Keep the three waves sequential, ensure Wave 2
validates generated `skills-codex/` prompts explicitly, and regenerate the full
Codex bundle after prompt changes land.

## Decision Gate

[x] PROCEED - Council passed, ready to implement
[ ] ADDRESS - Fix concerns before implementing
[ ] RETHINK - Fundamental issues, needs redesign
