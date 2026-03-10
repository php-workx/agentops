---
id: 2026-03-09-compiled-findings-need-explicit-applicability
type: learning
date: 2026-03-09
tags: [findings, task-validation, shift-left, metadata]
source: post-mortem ag-8ki
---

# Compiled Findings Need Explicit Applicability

## What We Learned

Compiled findings only shift left safely when the runtime can decide applicability without guessing. In this repo that means task payloads must preserve `metadata.issue_type` alongside changed-file scope, because active constraints target a bounded subset of work rather than every task indiscriminately.

## Why It Matters

Without explicit applicability, the prevention ratchet collapses back into advisory review. The system can still remember prior failures, but it cannot enforce the mechanical subset confidently during task validation.

## Reuse

- Require `metadata.issue_type` in worker task creation and completion paths.
- Keep compiler applicability scoped to issue types and file globs.
- Treat missing applicability metadata as a blocker when active constraints depend on it.
