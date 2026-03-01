---
type: pattern
source: post-mortem
date: 2026-03-01
confidence: high
epic: ag-co7
---

# Athena Architecture Patterns

## Mine-Defrag Split

Separating **mechanical extraction** (Mine) from **reasoning** (Grow) from **cleanup** (Defrag)
is the right architecture for knowledge management tools. Each phase is independently
runnable and testable. Mine + Defrag are CI-safe (no LLM). Grow is session-time (LLM).

## CI Gate with Env Override

Gates that run locally but also need to work in CI (where outputs go to /tmp/) require
an environment variable override pattern:

```bash
DEFRAG_LATEST="${ATHENA_OUTPUT_DIR:-$AGENTS_DIR}/defrag/latest.json"
```

CI sets `ATHENA_OUTPUT_DIR=/tmp/athena`; local runs use `.agents/` default.
Pre-mortem detected missing this pattern (CRITICAL finding) before any code was written.

## Source Graceful Degradation

Tools that depend on external binaries (gocyclo, git) should gracefully degrade
per-source with `continue-on-error` semantics. Mine's pattern:

```go
case "git":
    findings, err := mineGitLog(cwd, window)
    if err != nil {
        if !quiet { fmt.Fprintf(stderr, "warning: git source: %v\n", err) }
        continue
    }
    report.Git = findings
```

## --json Double-Write Anti-Pattern

When `--json` flag is requested, suppress human-readable summary output.
Not doing so produces mixed output (summary text + JSON) that is unparseable.

```go
// WRONG: prints summary then JSON to same writer
if !quiet { printSummary(out, report) }
if GetOutput() == "json" { json.NewEncoder(out).Encode(report) }

// RIGHT: suppress summary when JSON output
if !quiet && GetOutput() != "json" { printSummary(out, report) }
if GetOutput() == "json" { json.NewEncoder(out).Encode(report) }
```

## heal.sh Cross-Worker Build Dep

When multiple workers add new CLI commands in parallel, `heal.sh --strict`
will flag `INVALID_AO_CMD` for any command whose binary wasn't rebuilt yet.
Always run `make build` before `heal.sh --strict` after any new command additions.
