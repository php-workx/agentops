# Codex Follow-Up Plan

- Generated: 2026-03-24T08:34:22-04:00
- Mode: tasklist
- Reason: `bd` is currently degraded in this repo, so follow-up work cannot be reliably minted as beads yet.

## Goal

Finish the work that was intentionally or unavoidably left out of the Codex hookless lifecycle rollout, and harden the Codex-specific maintenance surface so the same regressions are harder to reintroduce.

## Tasklist

### F1. Repair Beads Health

- Type: blocker
- Priority: high
- Outcome:
  - `bd ready --json` works again
  - `bd list --type epic --status open --json` works again
  - the root cause is documented or covered by a repair test/runbook
- Acceptance:
  - no `crystallizes` column error
  - discovery/rpi planning can query tracker state normally

### F2. Add Tracker Degraded-Mode Detection

- Type: improvement
- Priority: high
- Outcome:
  - Codex planning/orchestration commands detect broken tracker health, not just command presence
  - the user sees explicit `tasklist` fallback messaging
- Acceptance:
  - discovery/rpi/status do not silently assume beads mode when queries fail
  - fallback behavior is tested

### F3. Add Generic Codex No-Beads RPI E2E Proof

- Type: improvement
- Priority: high
- Outcome:
  - a real proof path exists for discovery -> execution-packet -> implementation -> standalone validation without beads
- Acceptance:
  - the proof is executable, not grep-only
  - it fails if the packet contract regresses

### F4. Add Closeout-Boundary Skill E2E

- Type: improvement
- Priority: medium
- Outcome:
  - `validation`, `post-mortem`, and `handoff` are proven safe in hookless Codex mode
- Acceptance:
  - repeated `ao codex stop` is exercised in realistic flows
  - closeout ownership does not mutate repo state after push/release boundaries

### F5. Refactor Codex Lifecycle Guards Into One Reusable Primitive

- Type: refactor
- Priority: medium
- Outcome:
  - start/stop guard logic stops being hand-copied across Codex skills
- Options:
  - shared reference snippet
  - dedicated helper script
  - explicit `ao codex ensure-start` / `ao codex ensure-stop`
- Acceptance:
  - one source of truth drives the repeated guard behavior
  - Codex skill drift surface shrinks

### F6. Harden Codex Artifact Maintenance

- Type: refactor
- Priority: medium
- Outcome:
  - override prompt drift, checked-in prompt drift, and generated-hash refresh are handled by one obvious maintenance flow
- Acceptance:
  - contributors do not need to rediscover the right sequence by trial and error
  - validation failures point at the repair workflow directly

### F7. Isolate Headless Codex Validation From Real User State

- Type: improvement
- Priority: medium
- Outcome:
  - headless Codex validation uses temp `CODEX_HOME` or equivalent isolated state
- Acceptance:
  - repo validation does not depend on the current user's real `~/.codex` DB shape
  - warning noise is removed or dramatically reduced

### F8. Capture Durable Codex Lifecycle Learnings

- Type: improvement
- Priority: low
- Outcome:
  - Codex lifecycle/RPI learnings are indexed well enough that `ao lookup` can surface them
- Acceptance:
  - the next discovery run for this topic finds at least one relevant learning/pattern/finding

## Recommended Order

1. F1 Repair Beads Health
2. F2 Add Tracker Degraded-Mode Detection
3. F3 Add Generic Codex No-Beads RPI E2E Proof
4. F4 Add Closeout-Boundary Skill E2E
5. F5 Refactor Codex Lifecycle Guards
6. F6 Harden Codex Artifact Maintenance
7. F7 Isolate Headless Codex Validation
8. F8 Capture Durable Codex Lifecycle Learnings

## Validation Matrix

- `go test ./cmd/ao -run 'TestCodex'`
- `bash scripts/validate-codex-rpi-contract.sh`
- `bash scripts/test-codex-hookless-lifecycle.sh`
- `bash scripts/validate-headless-runtime-skills.sh`
- `scripts/pre-push-gate.sh --fast --scope worktree`

## Next Action

If you want execution to start immediately, the first move should be F1. Everything else is easier once beads health is restored or explicitly degraded in-code.
