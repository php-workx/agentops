# Nami Retro Since `v2.20.1`

- Date: 2026-03-08
- Release baseline: `v2.20.1` (`1aa104c903e080ccc9a186d3ae7495e8a5b22245`)
- Retro scope: `v2.20.1..db00ee735888e183b92fa9a445e9f84eb3b2b4c9`
- Range summary: 208 files changed, 6765 insertions, 885 deletions

## CI Snapshot

Current `Validate` run for `db00ee73`:

- URL: <https://github.com/boshu2/agentops/actions/runs/22831698634>
- Status at retro capture: `in_progress`
- Already green at capture time:
  - `contract-compatibility-gate`
  - `smoke-test`
  - `go-build`
  - `bats-tests`
  - `codex-runtime-sections`
  - `doc-release-gate`
  - `cli-docs-parity`
  - `shellcheck`
  - `skill-lint`
  - `json-flag-consistency`
  - `doctor-check`
- Still running at capture time:
  - `cli-integration`
  - `coverage-ratchet`

## What Landed

### 1. Codex-first skills became the dominant maintenance model

This release range materially shifted skill maintenance from converter-parity drift to an explicit Codex-first model:

- `skills/` stayed canonical
- `skills-codex-overrides/` became the place for runtime-specific Codex behavior
- `skills-codex/` became an explicitly generated artifact with stronger parity checks

The biggest change was not just adding overrides, but adding governance around them:

- override catalog contracts
- backbone/operator-contract validation
- generated-manifest enforcement
- stronger pre-push and CI parity checks

### 2. The next-work queue matured from an idea to a contract

The release range also hardened the `/post-mortem` -> `/rpi` -> `/evolve` carry-forward loop:

- per-item lifecycle semantics landed
- schema `v1.3` was published
- queue claim/release/consume semantics were documented and validated
- concurrency safety was added to queue mutation
- stale producer examples and parity blind spots were repaired

This was the highest-leverage runtime hardening in the range because it turned a fuzzy workflow into a tracked, validated contract.

### 3. CI and pre-push validation got materially stricter

Several changes in the range were really about closing false-positive/false-negative gaps in quality gates:

- fixed the `internal/vibecheck` coverage regression
- repaired BATS/pre-push regressions
- made the next-work parity validator portable in CI
- added Codex override coverage enforcement
- tightened local-vs-push parity by forcing generated artifacts to stay in sync

The repo is harder to accidentally “half-fix” now than it was at `v2.20.1`.

### 4. Git/worktree/runtime context handling improved

The release range fixed multiple git-context and worktree edge cases:

- `vibe-check` now sanitizes `GIT_DIR`-style environment leakage
- linked worktree repo discovery was hardened
- shared `core.worktree` repair landed
- `ao rpi parallel` uses runtime-aware worktree roots

These are not flashy product features, but they remove the class of bugs where the repo behaves differently under hooks, linked worktrees, or automation.

### 5. Documentation and tracker truth got closer to runtime truth

The range also spent real effort paying down stale contracts:

- CLI/skills map wording was refreshed
- Codex maintenance model was documented
- post-mortems produced concrete next-work and learning artifacts
- stale March 8 beads issues were finally reconciled against actual repo state

This improved operational trust in the repo. The tracker now lies less often than it did earlier in the cycle.

## What Went Well

- The team kept following through after “first fix” moments. Several important wins only landed because broken CI, stale queue state, and stale tracker state were treated as incomplete work instead of paperwork.
- The Codex-first migration did not stop at prompts; it added contracts, validation, and generated-artifact discipline.
- The next-work queue work became a proper system: schema, runtime semantics, CI checks, producer validation, and concurrency protection.
- The repo caught and fixed real portability issues before they calcified into permanent CI folklore.

## What Did Not Go Well

- Too much work landed in a single day after `v2.20.1`. The range is dense, cross-cutting, and operationally expensive to reason about.
- Generated-artifact discipline still lagged source changes more than once. The repo repeatedly reached a state where source truth was correct but generated Codex artifacts were not.
- Queue state and issue state drifted after fixes shipped. Multiple items had to be cleaned up after the fact.
- Some follow-up issues stayed open long after their acceptance had effectively landed, which made the work look less complete than it was.
- CI was occasionally green or red for the wrong reason because validators assumed tools or state that were not actually guaranteed.

## Highest-Signal Learnings

1. Blocking validators must prefer ubiquitous shell primitives or carry an explicit fallback.
2. Generated Codex artifacts are part of the product surface now, not optional derived output.
3. Queue semantics need both runtime enforcement and producer-surface enforcement; schema-only checks are not enough.
4. Closing the code change without closing the queue and issue state leaves operational debt that looks like unfinished engineering.
5. Worktree and git-environment bugs are worth treating as correctness bugs, not just tooling annoyances.

## Remaining Gaps

The biggest still-open gaps after this range are narrower and clearer than the landed work:

- `na-zmt`: `ao goals measure` still times out and blocks `evolve`
- `na-zez`: deep Claude headless runtime smoke is still not deterministic
- `na-prj`: frontmatter-only learning files still represent fragile CI debt
- `na-001`: the canonical/common git-dir worktree arrangement still has operational debt
- `march-8-delivery-chain` queue still carries unresolved follow-up items for:
  - Codex override coverage promotion into CI beyond the currently landed guardrails
  - deterministic repo-fixture coverage for vibe-check git discovery
  - broader push/pregate reproducibility hardening

## Verdict

This was a productive release-range, but not a clean one.

The good news is that the repo ended the range in a materially stronger state:

- Codex-first skill maintenance is real
- next-work lifecycle semantics are real
- CI/pre-push parity is better
- worktree/git-context behavior is less brittle

The bad news is that the release range still shows a pattern of “land the core fix, then spend follow-up cycles making the contracts tell the truth.” The next improvement should be reducing that lag, not just shipping more fixes.
