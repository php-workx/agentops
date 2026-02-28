---
type: pattern
source: post-mortem evolve-cycle-6
date: 2026-02-28
confidence: high
tags: [golang, testing, coverage]
---

# Block-Cluster Targeting for Go Coverage Sprints

## Pattern

When pushing Go test coverage past an 80% floor, identify the top 3-5 uncovered basic blocks by statement count using `go tool cover -func`, then write one test per cluster. This is 5-10x more efficient than iterating on random uncovered functions.

## Steps

1. Run `go test ./... -coverprofile=out.cov && go tool cover -func=out.cov | grep -v "100.0%"` to find uncovered blocks.
2. Parse the coverage profile (`<file>:<startline>.<col>,<endline>.<col> <stmts> 0`) to identify block clusters.
3. Read the source at the identified line ranges to understand the trigger condition.
4. Write a single test that exercises the trigger condition with `os.Chdir(tmp)` isolation.

## Test Infrastructure Pattern (Go)

- **Global var save/restore**: `orig := global; defer func() { global = orig }()()`
- **Chdir isolation**: `os.Chdir(tmp)` + defer restore; storage creates relative `.agents/ao/` in tmp automatically
- **Package access**: Test files in `package main` can access all unexported globals directly

## Evidence

Used across cov6-cov21 (16 test files, 5,238 lines) to lift cmd/ao from ~78% to 85.1%. Key targeted clusters:
- `contradict.go`: Contradiction detection branch (5 stmts) — required Jaccard=0.93 + negation asymmetry
- `vibe_check.go`: parseDuration error paths (2 stmts) — `fmt.Sscanf("xd", "%dd", &days)` fails
- `batch_forge.go`: Non-dry-run pipeline (14 stmts) — required cwd isolation + valid JSONL content
