---
id: post-mortem-2026-03-10-native-redteam-harness
type: post-mortem
date: 2026-03-10
source: "[[ag-w2m]]"
---

# Post-Mortem: Repo-Native LLM Redteam Harness

## Verdict: PASS

## What Shipped

- `skills/security-suite/scripts/prompt_redteam.py` provides an executable
  repo-surface redteam scanner.
- `skills/security-suite/references/agentops-redteam-pack.json` defines the
  first repo-owned attack pack.
- `tests/scripts/test-security-suite-redteam.sh` proves pass, fail, and
  repo-pack smoke behavior.
- `security-suite` skill docs and validation wiring now expose the new surface,
  and the generated Codex bundle was regenerated in parity.

## What We Learned

- Promptfoo-style hosted scanning is not the right first dependency here.
- A repo-native attack pack is valuable when it encodes the repo's own control
  surfaces and stays honest about what it does not test.
- Shipping the executable primitive first avoided another round of YAGNI
  documentation or corpus import work.

## Next Work

- No immediate follow-up is required for this slice.
- If live model-executed redteam becomes necessary later, build it as a separate
  capability with explicit provider/runtime assumptions.
