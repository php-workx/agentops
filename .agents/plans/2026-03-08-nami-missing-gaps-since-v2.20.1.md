# Missing Gaps After `v2.20.1`

- Date: 2026-03-08
- Scope reviewed: `v2.20.1..db00ee735888e183b92fa9a445e9f84eb3b2b4c9`

## Immediate Gaps

### 1. `evolve` is still blocked by goal measurement instability

- Issue: `na-zmt`
- Why it matters: this is the last remaining P0 in the visible queue
- Symptom: `ao goals measure` hangs, leaves a zero-byte `fitness-latest.json`, and breaks the documented fitness-selection path
- Recommendation: make this the next top-priority RPI target

### 2. Deep headless Claude validation is still non-deterministic

- Issue: `na-zez`
- Why it matters: local and push validation still depend on a smoke path that can degrade on runtime behavior rather than product correctness
- Recommendation: treat this as gate hardening, not optional polish

### 3. Learning-coherence debt still exists even though the current gate passed

- Issue: `na-prj`
- Why it matters: frontmatter-only historical learning files are still a fragile edge in local validation and repo hygiene
- Recommendation: either normalize those files or explicitly legalize the empty-file pattern

## Secondary Gaps

### 4. Worktree/common-git-dir ownership is still operationally awkward

- Issue: `na-001`
- Why it matters: the canonical root still carries structural Git ownership debt
- Recommendation: handle this as operational maintenance, not mixed into product work

### 5. Some March 8 hardening follow-ups still deserve explicit execution

Open queue items still point at:

- broader push/pre-push reproducibility hardening
- deterministic vibe-check git-fixture coverage
- additional Codex override governance

These are not emergencies, but they are the highest-value follow-ons if the goal is to reduce future thrash.

## Suggested Order

1. `na-zmt`
2. `na-zez`
3. queue a small cleanup for `na-prj`
4. decide whether `na-67x` is already obsolete or needs a final repo-wide stale-doc sweep
5. schedule the remaining March 8 hardening items as one bounded gate-hardening wave
