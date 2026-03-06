---
id: post-mortem-2026-03-05-fix-go-cli-correctness-review-findings
type: post-mortem
date: 2026-03-05
source: "[[.agents/plans/2026-03-05-fix-go-cli-correctness-review-findings.md]]"
---

# Post-Mortem: Fix Go CLI correctness review findings

## Council Verdict: PASS

## What Landed

- Merge cleanliness checks now include untracked files and no longer self-trigger on the merge lock path.
- Storage dedupe and append paths now execute under a file lock that works across independent `FileStorage` instances.
- Resolver fallback now performs literal substring matching rather than glob expansion.
- RPI phased-engine callers now carry an explicit working directory through runtime options instead of mutating process-global cwd.

## Validation Evidence

- Targeted package regression suites passed for `internal/rpi`, `internal/storage`, `internal/resolver`, and `cmd/ao`.
- Full CLI validation passed:
  - `cd cli && go build ./...`
  - `cd cli && go vet ./...`
  - `cd cli && go test ./...`

## Lessons

- Correctness fixes that tighten dirty-state detection need a second look at internal bookkeeping files; otherwise the safeguard can detect its own lock artifact.
- Process-local mutexes are not a meaningful concurrency boundary for CLI tools that are commonly invoked as separate OS processes.
- Tests around cwd-sensitive code on macOS should compare canonicalized paths because `/var` and `/private/var` can refer to the same directory.

## Follow-up

- No additional code follow-up was required to close this epic.
- The local `bd` stale-state warning remains an operational issue in this workspace, not a regression from the code changes above.
