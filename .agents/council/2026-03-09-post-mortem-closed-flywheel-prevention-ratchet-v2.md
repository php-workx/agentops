---
id: post-mortem-2026-03-09-ag-8ki
type: post-mortem
date: 2026-03-09
source: "epic ag-8ki"
---

# Post-Mortem: Closed Flywheel Prevention Ratchet v2 (ag-8ki)

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | PASS | The delivered slice reconciled the docs with the implemented runtime and added the missing end-to-end regression for enforcement and citation feedback. |
| Correctness | PASS | The prevention ratchet now proves the mechanical path from registry intake to task-validation blocking instead of only asserting it in docs. |
| Learnings | PASS | Deterministic applicability matters more than more rules; `metadata.issue_type` is what lets compiled findings shift left without guessing. |

## What Went Well

- The closing slice stayed bounded: docs, one end-to-end regression, and source-skill clarifications rather than another contract rewrite.
- Hook coverage now includes the full prevention ratchet path inside the main regression suite instead of leaving it in a one-off test.
- Codex bundle parity was recovered by making the source skills authoritative and regenerating, not by trying to ship a generator-only drift fix.

## What Was Hard

- The recovered worktree started from preserved WIP, so some generated artifacts looked like fresh work even though the real fix was to reconnect them to source changes.
- Local release-style validation mixes product-release policy with dev-branch verification, so same-day cadence checks are noisy for branch work even when implementation validation is green.

## Do Better Next Time

- When a prevention feature adds active enforcement, update the source skills and the generated Codex bundle in the same wave so parity checks never have to infer intent from drift.
- Keep task payload typing mandatory wherever compiled findings may apply; this is the contract that prevents noisy or accidental enforcement.

## Learning Extracted

- Compiled findings only shift left safely when applicability is explicit. In this repo, that means `metadata.issue_type` plus changed-file scope must travel with task creation and completion.

## Next Work

- No new follow-up defect was found inside `ag-8ki`.
- README-level product messaging still understates the closed-loop mechanism and can be improved in a separate docs-focused follow-up if desired.

## Status

[x] CLOSED - Work complete, learnings captured
[ ] FOLLOW-UP - Issues need addressing
