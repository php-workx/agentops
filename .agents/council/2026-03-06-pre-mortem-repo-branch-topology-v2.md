---
id: pre-mortem-2026-03-06-repo-branch-topology-v2
type: pre-mortem
date: 2026-03-06
source: "[[.agents/plans/2026-03-06-rationalize-repo-branch-topology-v2.md]]"
---

# Pre-Mortem: Repo Branch Topology v2

## Council Verdict: PASS

| Judge | Verdict | Key Finding |
|---|---|---|
| Missing-Requirements | PASS | The revised plan now covers the full local survivor set and both the unique and merged attached-worktree sets. |
| Feasibility | PASS | The cleanup remains operationally simple: git ref classification, non-destructive inspection, then removal. |
| Scope | PASS | Splitting inspection from attached-worktree cleanup eliminates the under-scoping from the first plan and creates a clean two-wave execution model. |
| Spec-Completeness | PASS | The new inspection artifact closes the previous verification gap around worktree dirtiness checks. |

## Shared Findings

- The plan now classifies all fifteen current local survivors outside `main`.
- Remote cleanup is symmetrical with local counterpart cleanup.
- Attached-worktree cleanup is now driven by a durable inspection artifact instead of undocumented operator judgment.

## Concerns Raised

- Low operational risk remains around dirty or ambiguous foreign worktrees. The plan handles this correctly by requiring inspection before deletion and by allowing a stop for keep/push/archive decisions.

## Recommendation

Proceed. Execute Wave 1 serially or with extreme care because all tasks mutate the same repository metadata, even though the issue graph allows parallelism conceptually.

## Decision Gate

- [x] PROCEED - Council passed, ready to implement
- [ ] ADDRESS - Fix concerns before implementing
- [ ] RETHINK - Fundamental issues, needs redesign
