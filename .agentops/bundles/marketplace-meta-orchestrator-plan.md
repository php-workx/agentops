---
bundle_id: bundle-marketplace-meta-orchestrator-plan-2025-11-07
created: 2025-11-07T21:58:42Z
type: plan
phase: plan
original_tokens: 52000
compressed_tokens: 1700
compression_ratio: 30.6
tags: [codex, claude, marketplace, meta-orchestrator, plan]
accessed_count: 0
last_accessed: null
approved: false
git_sha: 8025a46524950cc8843011b0f9ab6e1610a17b8d
---

# Implementation Plan: Claude Marketplace + Meta‑Orchestrator Skill

## Summary
Unify AgentOps as a Claude Code plugin marketplace and add the self‑learning Meta‑Orchestrator as an installable plugin. Maintain backward compatibility via symlinks. Ship a minimal, working meta skill with skill definition, commands, pattern/metrics/tests scaffolding, and git‑based learning hooks.

## Key Changes (Compressed)
- Create `.claude-plugin/marketplace.json` with 4 plugins:
  - `agentops-core`, `agentops-devops`, `agentops-product-dev`, `agentops-meta-orchestrator`
- Create plugin directories: `plugins/{agentops-core,agentops-devops,agentops-product-dev,agentops-meta-orchestrator}/.claude-plugin`
- Move `core/{commands,agents,workflows,skills}` into `plugins/agentops-core/` and add symlinks back under `core/`
- Add `plugins/*/.claude-plugin/plugin.json` for all 4 plugins
- Scaffold Meta‑Orchestrator:
  - `skills/orchestrator/SKILL.md` (activation, capabilities, commands)
  - `commands/{orchestrate.md,analyze-plugins.md,show-patterns.md}`
  - `workflows/` (placeholder), `patterns/{discovered,validated,learned,meta}/`, `metrics/`, `tests/`, `docs/`, `scripts/`
  - `scripts/auto-learn-commit.sh` (git learning merge flow)
- Docs:
  - Append install/usage to `README.md` (Meta‑Orchestrator section)
  - Add migration note to `MIGRATION.md`
  - Update `plugins/README.md` listing meta plugin
- Compatibility script: `scripts/ensure-compatibility.sh`

## Validation Strategy
Syntax/Manifests
- `jq '.' .claude-plugin/marketplace.json`
- `jq '.' plugins/*/.claude-plugin/plugin.json`

Marketplace flow (local)
```bash
cd /tmp/test-install
/plugin marketplace add file:///Users/fullerbt/workspaces/personal/agentops
/plugin list | grep agentops-
/plugin install agentops-core
/plugin install agentops-meta-orchestrator
```

Command smoke
```bash
/prime
/analyze-plugins --limit 10
/orchestrate "hello world" --plan-only  # success_probability >= 0.9
```

Acceptance (docs-based)
- [ ] Patterns created under `plugins/agentops-meta-orchestrator/patterns/learned/`
- [ ] Metrics appended (`metrics/success_rates.log`, `metrics/durations.log`)
- [ ] Auto‑learn script completes without errors

Backward compatibility
```bash
ls -la core/commands core/agents core/workflows  # symlinks present
/prime                                          # works
```

## Rollback Procedure
Immediate (<5m)
```bash
rm -rf plugins/ .claude-plugin/
rm core/commands core/agents core/workflows || true
git checkout -- core/
ls -la core/ && /prime
```

Git-based
```bash
git log --oneline -10
git checkout [last-good-sha] -- .
make test || true
```

## Approval
- [ ] Marketplace structure valid
- [ ] Meta‑Orchestrator plugin registered
- [ ] Backward compatibility maintained
- [ ] Docs updated (README, MIGRATION, plugins/README)
- [ ] Tests defined and runnable
- [ ] Rollback verified

Approved by: (pending)
Date: 2025-11-07

## Next Phase
1) `/bundle-load plan-marketplace-meta-orchestrator`
2) `/implement` (execute plan)
3) Validate tests and rollback
4) Announce preview + begin PoC runs (analyze 10 plugins first)
