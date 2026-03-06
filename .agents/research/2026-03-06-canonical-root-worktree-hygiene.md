---
type: research
date: 2026-03-06
topic: canonical-root-worktree-hygiene
epic: na-7oz
---

# Research: Canonical Root Worktree Hygiene

## Executive Summary

The repo already has `ao rpi cleanup` and `ao worktree gc`, but those tools only manage specific stale-run classes. They do not enforce the day-to-day human rule that would have prevented the recent branch/worktree sprawl:

1. `crew/nami` is the canonical repo root
2. `crew/nami` should normally host `main`
3. temporary work must happen in linked worktrees, not in `crew/nami`
4. foreign worktrees must end each session with an explicit disposition

That makes this primarily a workflow-governance problem. The repo needs a machine-checkable gate that enforces the canonical-root model, and the documented session-close workflow needs to name that rule explicitly.

## Current State

Existing worktree-related tooling:

- `ao rpi cleanup` cleans stale RPI runs from the run registry
- `ao worktree gc` cleans stale sibling RPI worktrees and orphaned tmux sessions
- `scripts/ci-local-release.sh` runs many repo-health checks, but none for foreign attached worktree disposition
- `scripts/pre-push-gate.sh` performs lightweight build/test checks, but nothing about canonical-root topology

Current policy gap in `AGENTS.md`:

- session completion requires push, cleanup, and prune
- there is no required disposition for attached worktrees
- there is no rule that `crew/nami` must stay on `main` and clean

## Observed Failure Mode

The recent cleanup incident happened because the repo allowed all of these states at once:

- the canonical root drifted off `main`
- a temporary linked worktree held `main`
- foreign worktrees remained attached without a disposition
- useful state lived inside worktrees instead of being promoted to durable branches or merged

None of those conditions are currently blocked by repo policy or release gates.

## Recommended Fix

### 1. Policy

Document this model in `AGENTS.md`:

- `crew/nami` is the canonical root worktree
- `crew/nami` must be clean and normally attached to `main`
- agents must not use `crew/nami` as scratch space
- every foreign worktree must end the session as `merged`, `preserved`, `exported`, or `deleted`

### 2. Enforcement

Add a repo script that fails when:

- the canonical root worktree is detached or not on `main`
- the canonical root worktree is dirty
- any branch-attached worktree exists besides:
  - `main` at the canonical root
  - the current task branch in the current worktree

This is intentionally narrower than a full stale-worktree sweeper. It enforces the operating model without duplicating `ao worktree gc`.

### 3. Re-anchor

Reassign `main` back to `crew/nami` and remove the temporary linked worktree that currently holds `main`.

## Scope Boundary

This fix should not attempt to redesign `ao worktree gc` or the full RPI cleanup contract. The immediate goal is to make the canonical-root workflow explicit and enforced so unfinished agent work cannot accumulate silently.
