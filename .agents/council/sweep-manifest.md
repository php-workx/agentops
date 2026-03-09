# Sweep Manifest: ag-iqa Post-Mortem

Date: 2026-03-09
Epic: `ag-iqa`
Scope commits: `5e7190b9`, `65927c40`

## Scope

- Source contract/runtime surfaces:
  - `skills/post-mortem/SKILL.md`
  - `skills/post-mortem/references/closure-integrity-audit.md`
  - `skills/post-mortem/references/output-templates.md`
  - `schemas/evidence-only-closure.v1.schema.json`
  - `lib/hook-helpers.sh`
  - `skills/post-mortem/scripts/write-evidence-only-closure.sh`
  - `skills/post-mortem/scripts/closure-integrity-audit.sh`
  - `tests/hooks/lib-hook-helpers.bats`
- Generated/parity and landing fix surfaces:
  - `cli/embedded/lib/hook-helpers.sh`
  - `skills-codex/post-mortem/scripts/closure-integrity-audit.sh`
  - `scripts/check-worktree-disposition.sh`
  - `tests/scripts/test-worktree-disposition.sh`

## Sweep Method

- Three parallel explorers audited the shipped files with an 8-category checklist:
  - resource leaks
  - string safety
  - dead code
  - hardcoded values
  - edge cases
  - concurrency
  - error handling
  - contract mismatches
- Findings below were adjudicated against direct command output from:
  - `bd show ag-iqa*`
  - `bash skills/post-mortem/scripts/closure-integrity-audit.sh --scope auto ag-iqa`
  - `git show --name-only 5e7190b9 65927c40`

## Findings

1. High: `skills/post-mortem/scripts/closure-integrity-audit.sh` parses human `bd` output with regexes instead of `bd --json`, so real `ag-iqa` children produced false `NO EVIDENCE` failures because scoped files were not extracted from actual `bd show` text.
2. High: `skills/post-mortem/scripts/closure-integrity-audit.sh` treats child IDs as raw `git log --grep` regex patterns and also accepts any historical touch to a scoped file, which can create false-positive commit evidence unrelated to the child being audited.
3. High: `skills/post-mortem/references/closure-integrity-audit.md` manual loop examples still use `head -1` inside child enumeration, so the documented audit path only checks the first child of a multi-child epic.
4. High: `skills/post-mortem/references/output-templates.md` still contains stale post-mortem/report templates and an evidence-only closure example that omits schema-required `repo_state.repo_root`.
5. Medium: `lib/hook-helpers.sh` and `cli/embedded/lib/hook-helpers.sh` still have a weak no-`jq` JSON fallback in `write_failure`, and `write_memory_packet` can collide on second-resolution filenames within one process.
6. Medium: `tests/hooks/lib-hook-helpers.bats` only covers happy-path evidence selection, and one test mutates the real repo artifact directory with cleanup only on the success path.
7. Medium: `skills/post-mortem/SKILL.md` step ordering is inconsistent: reporting requires harvested next work before the documented harvest step runs.
8. Low: `skills-codex/post-mortem/scripts/closure-integrity-audit.sh` retains a source-surface usage path in help output, which is a small generated-bundle mismatch.

## Adjudication Notes

- The epic delivered its intended staged/worktree evidence contract and validation surface.
- The strongest follow-up risk is not the new evidence precedence itself, but the audit toolchain around it: parser fragility, stale examples, and missing negative tests can make the closure signal appear stronger or weaker than reality.
- The landing fix in `scripts/check-worktree-disposition.sh` appears sound after the hook-env regression test and push-time validation; no material findings remained on that surface.
