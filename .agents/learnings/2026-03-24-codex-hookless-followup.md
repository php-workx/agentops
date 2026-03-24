---
id: learning-2026-03-24-codex-hookless-followup
type: learning
date: 2026-03-24
category: process
confidence: high
maturity: provisional
utility: 0.5000
---

# Learning: Codex Skills Need `ensure-start` and `ensure-stop`, Not State Parsing

## What We Learned

Codex hookless lifecycle automation becomes fragile when each skill re-implements
its own `.agents/ao/codex/state.json` parsing. The durable fix is a CLI-owned
primitive: entry skills call `ao codex ensure-start`, closeout-owner skills call
`ao codex ensure-stop --auto-extract`, and the CLI owns thread-level dedupe.

## Why It Matters

This shrinks the Codex drift surface. Future lifecycle fixes can land in one CLI
path instead of being copied into many prompt variants and skill bodies.

## Source

Codex hookless lifecycle follow-up hardening after validation regressions around
duplicate closeout and inconsistent startup behavior.

---

# Learning: Beads Version Skew Can Masquerade as a Repo Bug

## What We Learned

When the shared beads DB schema is newer than the installed `bd` binary,
tracker probes can fail with SQL errors such as `column "crystallizes" could not
be found in any table in scope`. The first repair step is environment health:
check `bd version`, inspect `bd migrate --inspect --json`, and upgrade `beads`
before assuming repo-local tracker corruption.

## Why It Matters

Codex phased RPI now degrades honestly to tasklist mode when tracker probes
fail, but that fallback is continuity protection, not a replacement for fixing
the tracker toolchain.

## Source

Live repo failure during Codex follow-up execution, repaired by upgrading Homebrew
`beads` from 0.59.0 to 0.62.0 to match the DB metadata version.

---

# Learning: No-Beads RPI Needs an Executable Proof, Not Just Contract Text

## What We Learned

The no-beads Codex RPI path is easy to overstate in documentation. A durable
regression test needs to run `ao rpi phased` with a deterministic fake runtime,
force tracker degradation, and verify `execution-packet.json`, `phased-state.json`,
and `ao rpi status --json` all report `tracker_mode=tasklist`.

## Why It Matters

Without an executable proof, the repo can keep passing string-level validators
while the real discovery -> execution-packet -> validation path regresses.

## Source

Codex follow-up work after validation found that the original smoke test covered
hookless lifecycle commands but not the early-stopping no-beads RPI path.
