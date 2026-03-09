---
id: learning-2026-03-08-catalog-governance-needs-structural-proof
type: learning
date: 2026-03-08
source_epic: b50e2eb4
confidence: high
category: process
scope: repo-specific
---

# Catalog-Driven Governance Needs Structural Proof

## Key Learnings

1. **`catalog.json` is the right authority for Codex operator-contract policy.** Moving the requirement set into data made validator scope explicit and removed a hardcoded shell list from the trust boundary.

2. **Data-driven policy is not enough if enforcement still matches verbatim prompt fragments.** The governance center moved to the catalog, but drift detection remains brittle until sync generates the required blocks or the validator parses structure instead of text snippets.

3. **Broader policy needs broader negative fixtures in the same wave.** Expanding beyond the backbone set without a non-backbone mismatch fixture leaves a proof gap even when the runtime behavior is directionally correct.

## Anti-Patterns

- Declaring policy generalization complete while tests still only prove the historical backbone slice.
- Treating prompt marker text as a stable contract when the real contract is semantic.
