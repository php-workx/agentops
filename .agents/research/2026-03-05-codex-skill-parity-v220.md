---
id: research-2026-03-05-codex-skill-parity-v220
type: research
date: 2026-03-05
---

# Research: v2.20 skill delta and Codex parity

**Backend:** codex-sub-agents + inline
**Scope:** `skills/**` changes between `v2.19.0` and `v2.20.0`, current `skills-codex/**` parity, and Codex-specific validation impact

## Summary

`v2.20.0` introduced a substantial shared-skill delta: two new skills (`athena`, `push`), a major `post-mortem` expansion with `retro` scope reduction, a rewritten `quickstart`, and multiple orchestration/reference updates across planning, crank, council, swarm, standards, and RPI flows. The checked-in `skills-codex/` tree was stale against those source changes and required a full re-sync via `scripts/sync-codex-native-skills.sh`.

After syncing, Codex runtime lint initially failed because the generated `shared` skill now intentionally includes `references/claude-cli-verified-commands.md`, but the residual-marker allowlist did not yet permit that filename. Adding a narrow allowlist entry fixed the runtime-section gate. A broader slash-command install test still fails, but the same failure reproduces from the clean `v2.20.0` tag and appears pre-existing.

## Key Files

| File | Purpose |
|------|---------|
| `skills/athena/SKILL.md` | New shared skill added in `v2.20.0` |
| `skills/push/SKILL.md` | New shared skill added in `v2.20.0` |
| `skills/post-mortem/SKILL.md` | Major workflow expansion and backlog-processing split from `retro` |
| `skills/retro/SKILL.md` | Reduced to quick-capture scope |
| `skills/quickstart/SKILL.md` | Large onboarding rewrite |
| `scripts/sync-codex-native-skills.sh` | Canonical Codex parity sync entrypoint |
| `skills-codex/**` | Generated Codex-native skill artifacts |
| `scripts/lint/codex-residual-allowlist.txt` | Residual mixed-runtime marker policy for Codex runtime lint |

## Findings

1. Shared-skill delta from `v2.19.0` to `v2.20.0` is substantial, not a minor patch. `git diff --stat v2.19.0..v2.20.0 -- skills` shows 69 changed files with 3192 insertions and 1296 deletions, including two new skills and several new reference/script files.

2. New skills landed only in the shared tree and needed Codex generation:
   - `skills/athena/SKILL.md`
   - `skills/push/SKILL.md`

3. The biggest functional skill shifts were:
   - `post-mortem`: major expansion, new activation/backlog/closure references, new preflight script
   - `retro`: reduced to a narrow quick-capture path
   - `quickstart`: large rewrite and updated skill catalog/troubleshooting references
   - `plan`, `crank`, `implement`, `swarm`, `rpi`, `vibe`, `council`: orchestration and reference updates
   - `standards`: expanded common/go/skill-structure guidance

4. The Codex tree was not missing; it was stale. A dry-run sync against a temp output showed drift in 40+ Codex skill files plus new missing generated assets like:
   - `skills-codex/athena/**`
   - `skills-codex/push/**`
   - `skills-codex/post-mortem/references/closure-integrity-audit.md`
   - `skills-codex/post-mortem/references/harvest-next-work.md`
   - `skills-codex/crank/references/uat-integration-wave.md`
   - `skills-codex/shared/references/claude-cli-verified-commands.md`

5. `scripts/sync-codex-native-skills.sh` is the correct update path. It rebuilds `skills-codex/` from `skills/` using the converter in modular mode, applies `skills-codex-overrides/` prompt overlays, validates skill parity, and writes the generated tree.

6. Codex-specific prompt overrides are intentionally limited to a small set of prompt files under `skills-codex-overrides/`:
   - `beads`, `codex-team`, `council`, `crank`, `openai-docs`, `quickstart`, `research`, `retro`, `swarm`
   Those remained intact after the sync because the sync script reapplies them after generation.

7. Codex runtime validation failure after sync was caused by policy drift, not conversion breakage. `scripts/validate-codex-runtime-sections.sh` flagged three lines in `skills-codex/shared/SKILL.md` referencing `claude-cli-verified-commands.md`; adding `\bclaude-cli-verified-commands\.md\b` to `scripts/lint/codex-residual-allowlist.txt` resolved the gate.

8. `bash scripts/lint-codex-native.sh` passes after the sync and allowlist update.

9. `bash scripts/test-codex-native-install.sh` still fails on slash-command references in `skills-codex/**`, but this is pre-existing in `v2.20.0`. Reproducing the same regex against an extracted `v2.20.0` archive shows existing hits across copied references, READMEs, and validator scripts. This appears to be a broader converter/test-contract mismatch rather than a regression introduced by this parity sync.

## Validation

- `bash scripts/sync-codex-native-skills.sh`
- `bash scripts/validate-codex-runtime-sections.sh`
- `bash scripts/lint-codex-native.sh`
- `bash scripts/test-codex-native-install.sh` -> still fails, but failure reproduces from `v2.20.0`
