# Codex Follow-Up Discovery

- Timestamp: 2026-03-24T08:34:22-04:00
- Goal: Plan the remaining follow-up work after the Codex hookless lifecycle and RPI validation fixes.
- Scope: unresolved blockers, executable-proof gaps, and maintenance refactors suggested by the recent rollout.

## Evidence

1. Live tracker health is degraded:
   - `bd ready --json` fails with `column "crystallizes" could not be found in any table in scope`.
   - Because the tracker is unavailable, this discovery run cannot mint or inspect beads reliably.
2. Codex lifecycle closeout is now idempotent at the CLI layer:
   - `cli/cmd/ao/codex.go` returns `already_closed` for duplicate `ao codex stop` calls on the same thread.
   - `cli/cmd/ao/codex_test.go` covers that regression directly.
3. Codex skill contracts are stronger, but the generic no-beads runtime story is still mostly contract-led:
   - `skills-codex/rpi/SKILL.md` now routes no-beads work through `.agents/rpi/execution-packet.json`.
   - `skills-codex/crank/SKILL.md` documents execution-packet mode.
   - `scripts/validate-codex-rpi-contract.sh` enforces that contract text.
4. The repo already has one real execution-packet producer/consumer proof path, but it is not the Codex no-beads skill path:
   - `cli/cmd/ao/rpi_execution_packet.go` writes execution packets for phased runs.
   - `cli/cmd/ao/rpi_phased_program_test.go` proves execution-packet use for the autodev/phased engine path.
5. Durable knowledge on this topic is still weak:
   - `ao lookup --query "codex hookless lifecycle rpi validation" --limit 5 --json` returned no learnings, patterns, or findings.
   - `ao search "codex hookless lifecycle rpi validation" --json` returned no local results.
6. Existing queue evidence already points at adjacent work:
   - `.agents/rpi/next-work.jsonl` contains `Add executable repo-native execution-packet proof path`.
   - `.agents/rpi/next-work.jsonl` also contains `Plan Codex generated-bundle sync whenever skills/ behavior changes`.
7. Current validation still depends on real user Codex state in at least one place:
   - `bash scripts/validate-headless-runtime-skills.sh` passed, but emitted warnings from `/Users/fullerbt/.codex/logs_1.sqlite`.

## Ranked Packet

1. `tracker-health-blocker`
   - Source: live command failure
   - Why first: without a healthy tracker, normal planning/execution and closeout are partially blind.
2. `generic-codex-no-beads-proof`
   - Source: recent validation findings plus current contract validator
   - Why second: the recent fix made the contract honest, but not fully executable end to end.
3. `closeout-boundary-e2e`
   - Source: repeated regressions around skill-owned closeout
   - Why third: the CLI guard is fixed, but realistic skill-boundary coverage is still thinner than it should be.
4. `lifecycle-guard-dedup`
   - Source: repeated start/stop snippets across Codex skills
   - Why fourth: maintenance cost and drift risk remain high.
5. `codex-artifact-maintenance-hardening`
   - Source: prompt drift and generated-hash refresh work required during the fix
   - Why fifth: the current maintenance flow is workable but still brittle.
6. `headless-codex-isolation`
   - Source: warnings from real `~/.codex`
   - Why sixth: deterministic validation is harder when local state bleeds into tests.
7. `durable-knowledge-indexing`
   - Source: empty `ao lookup`/`ao search` on this topic
   - Why seventh: future planning should not have to rediscover the same rollout lessons.

## Recommended Workstreams

### Workstream A: Restore Planning/Tracking Health

1. Repair the `bd`/schema failure in this repo so `bd ready --json` and basic issue queries work again.
2. Add tracker-health preflight to Codex planning/orchestration entrypoints so a broken `bd` degrades honestly to tasklist mode instead of failing late.

### Workstream B: Add Executable Codex No-Beads Proof

3. Add a real no-beads Codex RPI proof path that exercises discovery packet creation, packet-backed implementation, and standalone validation.
4. Add closeout-owner e2e coverage for `validation`, `post-mortem`, and `handoff` in hookless Codex mode, including repeated `ao codex stop`.

### Workstream C: Reduce Codex Maintenance Drift

5. Extract shared lifecycle-guard behavior into a reusable helper, shared reference, or dedicated `ao codex ensure-*` command so skills stop hand-encoding the same start/stop logic.
6. Harden Codex prompt/generated-artifact maintenance so override drift and hash-refresh work are handled by one obvious workflow.
7. Isolate headless Codex validation from real user state with a temp `CODEX_HOME`.
8. Promote the new Codex lifecycle/RPI learnings into durable indexed artifacts so `ao lookup` can surface them later.

## Suggested Sequencing

1. Fix tracker health first.
2. Add degraded-mode tracker detection second.
3. Build the generic no-beads executable proof path third.
4. Add closeout-boundary e2e coverage immediately after, while the flow is fresh.
5. Then do the lifecycle-guard and artifact-maintenance refactors.
6. Finish by isolating headless validation and writing durable learnings.

## Test Levels

- L0: CLI unit tests for `ao codex stop`, tracker detection, and execution-packet helpers.
- L1: shell validator tests for `validate-codex-rpi-contract.sh` and related guard scripts.
- L2: temp-home repo-local smoke for `ao codex start/stop/status`, search/lookup/citation, and packet-driven validation flows.
- L3: full subsystem e2e for generic no-beads RPI lifecycle across discovery -> implementation -> validation.

## Pre-Mortem

Verdict: WARN

Primary risks:

1. The tracker failure may require out-of-band schema or environment repair, not just repo code changes.
2. Generic no-beads `crank` behavior may still be partly documentation-only, which could expand scope from test work into runtime implementation.
3. A helper abstraction for Codex lifecycle guards could drift from canonical skill contracts unless it stays grounded in the shared source of truth.
