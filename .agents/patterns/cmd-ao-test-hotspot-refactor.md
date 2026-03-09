---
type: pattern
source: athena 2026-03-06
date: 2026-03-06
confidence: 0.7500
maturity: established
tags: [testing, go, complexity, cmd-ao]
utility: 0.7804
last_reward: 0.80
reward_count: 15
last_reward_at: 2026-03-09T09:30:26-04:00
last_decay_at: 2026-03-09T09:30:26-04:00
helpful_count: 15
maturity_reason: utility 0.74 >= 0.55, reward_count 6 >= 5, helpful > harmful (6 > 0)
maturity_changed_at: 2026-03-07T15:56:23-05:00
---

# cmd/ao Test Hotspot Refactor Pattern

## Pattern

Treat high-complexity `cmd/ao` tests as maintenance targets, not harmless test debt. When a test exceeds the complexity budget and also carries recent churn, split setup/helpers from scenario assertions, move repeated filesystem or stdout plumbing into shared helpers, and keep one behavioral thread per test function.

## Problem

Athena hotspots show the same shape repeatedly:

- one test function owns many phases or branches
- filesystem setup, working-directory changes, and assertion logic are interleaved
- later changes keep landing in the same large function because it already has the fixtures

That raises review cost and makes future bug-hunt or vibe passes spend time on test structure instead of behavior.

## Hotspot Examples

Recent Athena hotspot examples:

- [`cli/cmd/ao/knowledge_loop_e2e_test.go`](cli/cmd/ao/knowledge_loop_e2e_test.go): `TestKnowledgeLoopE2E`
- [`cli/cmd/ao/cobra_commands_test.go`](cli/cmd/ao/cobra_commands_test.go): `TestCobraFeedbackHelpers`
- [`cli/cmd/ao/workflow_integration_test.go`](cli/cmd/ao/workflow_integration_test.go): `TestWorkflow_NotebookUpdateCycle`
- [`cli/cmd/ao/rpi_loop_supervisor_test.go`](cli/cmd/ao/rpi_loop_supervisor_test.go): `TestRunSupervisorLanding_SyncPush_RebaseFailureAborts`
- [`cli/cmd/ao/rpi_loop_supervisor_test.go`](cli/cmd/ao/rpi_loop_supervisor_test.go): `TestRunSupervisorLanding_SyncPush_FetchFailure_RecoversState`

## Reuse Before Rebuild

Shared helpers already exist in [`cli/cmd/ao/testutil_test.go`](cli/cmd/ao/testutil_test.go):

- `captureJSONStdout` for command-output assertions
- `captureStdout` for stdout + error flows
- `chdirTemp` for temp-dir + cwd setup
- `chdirTo` for scoped working-directory changes
- `setupAgentsDir` for `.agents/` fixture scaffolding

Refactor toward those helpers before adding another bespoke setup block inside a hotspot test.

## Refactor Moves

1. Extract environment setup first.
   Move directory creation, `.agents/` scaffolding, and fixture writes out of the main scenario when they are reused or obscure the assertion path.
2. Keep one behavioral thread per test.
   If a single test walks four or five logical phases, prefer subtests or dedicated helpers so each branch is easier to review.
3. Promote plumbing helpers quickly.
   When two hotspot tests need the same cwd or stdout harness, move it into `testutil_test.go` instead of copying it a third time.
4. Use hotspot + churn together.
   Complexity alone is not enough. Prioritize tests with CC > 25 and recent edits; those are the ones most likely to keep absorbing unrelated behavior.
5. Preserve behavior-focused names.
   After splitting helpers out, keep the top-level tests named for the scenario, not the plumbing.

## Trigger Threshold

Promote a test into hotspot-refactor work when at least two of these are true:

- CC exceeds 25
- Athena or gocyclo flags it as a hotspot
- the file has recent edits
- the test mixes setup, orchestration, and assertions in one function
- a new change would otherwise copy cwd/stdout fixture code again

## When to Apply

- Planning coverage sprints in `cli/cmd/ao`
- Reviewing large test diffs during vibe or bug-hunt
- Choosing follow-up work from Athena hotspot output

## Anti-Pattern

Treating giant tests as "just tests" and leaving the next change to pile more setup branches into the same function because the fixtures are already there.
