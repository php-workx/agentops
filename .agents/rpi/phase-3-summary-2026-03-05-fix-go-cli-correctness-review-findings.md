Validation completed cleanly for epic `na-06i`.

Repo-wide CLI gates passed:
- `cd cli && go build ./...`
- `cd cli && go vet ./...`
- `cd cli && go test ./...`

Outcome:
- The original merge cleanliness defect now blocks both staged and untracked dirt before merge resolution.
- Storage index/provenance writes now have a cross-process lock boundary instead of only process-local mutex protection.
- Resolver fallback now treats IDs literally, so glob metacharacters no longer break or misroute matches.
- Programmatic phased-engine entry points no longer mutate global cwd.

Residual risk:
- No new product-code defects were found in validation. The only remaining caveat from this session is the local `bd` stale-state warning, which required `--allow-stale` for issue management and should be handled separately if it recurs.
