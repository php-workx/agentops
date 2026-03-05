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
- **validate-learning-coherence.sh skipped.** Pre-existing frontmatter-only file (`2026-02-26-worktree-refactoring-pattern.md`) causes exit 1. Can't wire into CI until fixed.

## Do Differently Next Time

- **For doc epics, add "verify counts against source" in conformance checks.** Generic "files_exist" isn't enough for docs that claim specific numbers (job counts, function counts). Add `wc`-based or `grep -c`-based count verification.
- **Skip gocyclo for non-Go epics.** Add a language filter in vibe: if no .go files in diff, skip Go complexity entirely.
- **Pre-test scripts before wiring into CI.** Issue 7 followed this (pre-mortem W3 said to). validate-learning-coherence.sh correctly skipped. This should be standard practice.

## Patterns to Reuse

- **Conformance-check-per-issue pattern.** Every plan issue gets a mechanical verification command. Makes wave completion verification instant and deterministic.
- **Doc-from-source pattern.** Agents reading actual workflow files, script files, and test directories produce more accurate docs than agents working from descriptions alone.
- **Wave 0 dependency setup.** Setting `bd dep add` before checking `bd ready` naturally partitions waves without manual grouping.

## Anti-Patterns to Avoid

- **Trusting LLM-generated counts.** Agents producing docs will estimate counts unless forced to run `grep -c` or `wc -l`. Always add count-verification conformance checks for numeric claims.
- **Full-tree complexity scan.** Running gocyclo on entire cli/ during vibe wastes time when only docs/scripts changed.
