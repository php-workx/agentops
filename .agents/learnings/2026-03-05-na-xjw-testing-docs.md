---
type: retro
source: na-xjw
date: 2026-03-05
confidence: high
maturity: provisional
tags: [docs, testing, ci, crank, swarm]
---

# Retro: Testing & Documentation Improvements (na-xjw)

## What Went Well

- **8-agent Wave 1 with zero conflicts.** All 8 issues had exclusive file ownership. No merge conflicts, no retries. Plan's wave decomposition was correct.
- **Pre-mortem auto-fix pattern.** Pre-mortem found 3 issues, auto-fixed 2 in the plan. Zero implementation surprises from those findings.
- **Agent quality for doc creation.** Agents produced accurate docs (CI-CD.md, TESTING.md) by reading actual source files rather than guessing. CI-CD.md had stale job count only because the agent read partial context.
- **BATS tests immediately useful.** 17 tests covering all 8 hook-helpers.sh functions. Caught real behavior (allowlist blocking, JSON escaping).
- **Conformance checks per issue.** Every issue had a mechanical check (grep -c, file existence, bats run). Made verification instant.

## What Was Hard

- **CI-CD.md job count accuracy.** Agent counted 26 jobs but actual was 29. Vibe caught it. Root cause: agent didn't count ALL job definitions, likely missed late-added jobs at bottom of file.
- **gocyclo hung during vibe.** Scanning entire cli/ tree timed out. Not relevant for this epic (no Go changes) but blocked the vibe flow.
- **Coherence-gate status changed after the epic.** During na-xjw, `validate-learning-coherence.sh` was treated as a blocking risk. Current repo state is different: `bash scripts/validate-learning-coherence.sh .agents/learnings` passes, so this is historical context rather than an active blocker.

## Do Differently Next Time

- **For doc epics, add "verify counts against source" in conformance checks.** Generic "files_exist" isn't enough for docs that claim specific numbers (job counts, function counts). Add `wc`-based or `grep -c`-based count verification.
- **Skip gocyclo for non-Go epics.** Add a language filter in vibe: if no .go files in diff, skip Go complexity entirely.
- **Pre-test scripts before wiring into CI.** Issue 7 followed this pattern correctly. Keep verifying gate behavior against current repo state before treating an earlier failure as still-active debt.

## Patterns to Reuse

- **Conformance-check-per-issue pattern.** Every plan issue gets a mechanical verification command. Makes wave completion verification instant and deterministic. See [Count-Verification Conformance Pattern](../patterns/count-verification-conformance.md) for the numeric-claims variant.
- **Doc-from-source pattern.** Agents reading actual workflow files, script files, and test directories produce more accurate docs than agents working from descriptions alone.
- **Wave 0 dependency setup.** Setting `bd dep add` before checking `bd ready` naturally partitions waves without manual grouping.
- **Language-filtered complexity checks.** For non-Go epics, skip irrelevant complexity scans instead of sweeping the whole tree. See [Vibe Language Filter Pattern](../patterns/vibe-language-filter.md).
- **Promote repeated runtime fixes into canonical patterns quickly.** The follow-through patterns for [RPI Multi-Root Observability](../patterns/rpi-multi-root-observability.md) and [cmd/ao Test Hotspot Refactor](../patterns/cmd-ao-test-hotspot-refactor.md) are the durable homes for the insights Athena surfaced after this retro.

## Anti-Patterns to Avoid

- **Trusting LLM-generated counts.** Agents producing docs will estimate counts unless forced to run `grep -c` or `wc -l`. Always add count-verification conformance checks for numeric claims.
- **Full-tree complexity scan.** Running gocyclo on entire cli/ during vibe wastes time when only docs/scripts changed.
