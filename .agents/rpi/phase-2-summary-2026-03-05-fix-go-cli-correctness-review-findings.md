Wave 1 implementation completed all four correctness fixes from epic `na-06i`.

Implemented changes:
- `cli/internal/rpi/worktree.go` now uses `git status --porcelain --untracked-files=all` for cleanliness checks, adds untracked-file regression coverage, and moves the merge lock under `.git/agentops/merge.lock` so the lock itself does not dirty the repo.
- `cli/internal/storage/file.go` now performs index dedupe and JSONL append operations under a package-local file lock, with new Unix and Windows lock helpers in `cli/internal/storage/filelock_*.go`.
- `cli/internal/resolver/resolver.go` now uses literal substring probing instead of glob expansion, with metacharacter regression tests.
- `cli/cmd/ao/rpi_phased.go` and related callers now pass `WorkingDir` explicitly instead of mutating process cwd, with targeted cmd/ao coverage for cwd stability and serve/supervisor option wiring.

Targeted validation passed:
- `cd cli && go test ./internal/rpi ./internal/storage ./internal/resolver ./cmd/ao -run 'Test(MergeWorktree|AcquireMergeLock|FileStorage_(WriteIndex|WriteProvenance|HasIndexEntry)|FileResolver|NoWorktreeRunIDGeneration|RunPhasedEngine_AutoCleanupStale_DryRunDoesNotMutate|RunPhasedEngine_DoesNotMutateProcessCWD|BuildServeEngineOptions|SupervisorCov_BuildCycleEngineOptions)' -count=1`

Implementation note:
- The local beads database still reports a stale-state warning after earlier manual export, so issue transitions were executed with `--allow-stale`. That did not affect code validation, but it remains an operational caveat outside this epic's code scope.
