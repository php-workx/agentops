---
id: post-mortem-2026-03-15-v2.26.0-bf-standards
type: post-mortem
date: 2026-03-15
source: "v2.26.0 release — BF6-BF9 test pyramid + codex audit"
---

# Post-Mortem: v2.26.0 — BF6-BF9 Test Pyramid Standards

**Scope:** v2.25.1..v2.26.0 (10 commits, 146 files, +1718/-1080 lines)
**Duration:** ~45 minutes (standards authoring + codex sync + release + validation)
**Cycle-Time:** Fast for scope — standards-only release with no Go logic changes

## Council Verdict: WARN

| Judge | Verdict | Key Finding |
|-------|---------|-------------|
| Plan-Compliance | PASS | All 4 BF levels delivered with language-specific patterns in Go + Python. No plan existed (ad-hoc), so compliance is against the user's taxonomy input. |
| Tech-Debt | WARN | 3 issues found: stale BF heading (fixed mid-release), empty docs/CHANGELOG (fixed mid-release), marketplace version 3 releases behind (fixed mid-release). All caught by code review agent, not by CI. |
| Learnings | PASS | Process learnings captured below. The flywheel-as-release pattern (standards → codex → embedded → release) executed smoothly. |

### Implementation Assessment

**Delivered:** BF6 (Regression), BF7 (Performance/Benchmark), BF8 (Backward Compatibility), BF9 (Security In-Test) — each with:
- Taxonomy entry in test-pyramid.md (description, tools, evidence columns)
- Language-specific Go patterns (benchmark, testdata/compat/, TestBug_ naming, path traversal)
- Language-specific Python patterns (Hypothesis, pytest-benchmark, fixture glob, secrets redaction)
- Decision tree routing questions
- RPI phase mapping (which phase mandates which BF level)
- Coverage assessment template rows

**Three-copy parity maintained:** source (`skills/`), codex (`skills-codex/`), embedded (`cli/embedded/`).

### Concerns

1. **No pre-mortem was run.** This was an ad-hoc implementation from user input, not RPI-driven. For standards changes that affect all downstream consumers, a pre-mortem would have caught the heading staleness and version drift before release.
2. **docs/CHANGELOG.md sync is fragile.** The pre-commit hook synced the version header but not the entry body. Required manual fix post-release.
3. **Marketplace version was 3 releases behind** (2.23.0 → 2.26.0). No CI check catches this drift.
4. **BF6-BF9 "Bugs Found" column uses N/A** for new levels since they're guards, not discovery tools. This is correct but may confuse readers who expect numeric evidence like BF1-BF5.

## Learnings

### What Went Well
- **User taxonomy as spec** — The user's detailed test type matrix served as an effective specification. No ambiguity about what to implement.
- **Three-file parity workflow** — Editing source → codex → embedded in sequence is now muscle memory. Pre-commit hooks catch embedded sync misses.
- **Code review agent caught 2 real bugs** — The heading staleness (BF1-BF5 → BF1-BF9) and docs/CHANGELOG empty entry would have shipped unnoticed without the review agent.
- **Retag script works** — `retag-release.sh` cleanly moved the tag to include post-release fixes. No manual git surgery needed.

### What Was Hard
- **Pre-push gate takes ~3 minutes** — Three retags meant ~9 minutes of pre-push gate waiting. For hotfix releases, this friction is significant.
- **docs/CHANGELOG.md sync** — The pre-commit hook's sync logic is header-only, not content-aware. Had to manually copy the entry.

### Do Differently Next Time
- **Run version bump check in release skill** — The release skill's pre-flight should check `.claude-plugin/plugin.json` and `marketplace.json` versions match the release version.
- **Run /pre-mortem even for "simple" standards changes** — Standards changes have blast radius across all consumers. A 2-minute inline pre-mortem would have caught the heading and version issues.

### Anti-Patterns to Avoid
- **Releasing without checking marketplace versions** — Plugin versions fell 3 releases behind silently.
- **Trusting pre-commit hooks for full sync** — The CHANGELOG sync hook only copies headers, not content.

### Footgun Entries

| Footgun | Impact | Prevention |
|---------|--------|-----------|
| docs/CHANGELOG.md pre-commit sync is header-only | Release ships with empty changelog entry in docs/ | Check docs/CHANGELOG.md content matches root after release commit |
| marketplace.json version not checked by release skill | Plugin version drifts silently across releases | Add marketplace version check to release pre-flight |
| Section heading not updated when adding table rows | BF1-BF5 heading with BF1-BF9 table content | When adding rows to a table, grep for the section heading and update the range |

## Knowledge Lifecycle

### Backlog Processing (Phase 3)
- Scanned: 0 new learnings (pre-existing backlog not processed — focused on release extraction)

### Activation (Phase 4)
- Promoted to MEMORY.md: 0 (no score-6+ learnings — these are process learnings, not high-impact patterns)

### Retirement (Phase 5)
- Archived: 0

## Proactive Improvement Agenda

| # | Area | Improvement | Priority | Horizon | Effort | Evidence |
|---|------|-------------|----------|---------|--------|----------|
| 1 | ci-automation | Add marketplace/plugin version parity check to release pre-flight | P0 | now | S | marketplace.json was 3 releases behind, no CI caught it |
| 2 | ci-automation | Fix docs/CHANGELOG.md pre-commit hook to sync entry content, not just headers | P1 | next-cycle | M | Required manual fix post-release; fragile for every release |
| 3 | execution | Add heading-update reminder to test-pyramid editing workflow | P2 | later | S | Stale BF1-BF5 heading shipped; caught by code review agent |
| 4 | repo | Add BF6-BF9 evidence data once applied to a real project | P2 | later | S | "Bugs Found" column is N/A for new levels — need real evidence |

## Next Work

| # | Title | Type | Severity | Source | Target Repo |
|---|-------|------|----------|--------|-------------|
| 1 | Add marketplace/plugin version check to release pre-flight | process-improvement | high | retro-learning | agentops |
| 2 | Fix docs/CHANGELOG.md pre-commit sync to include entry content | tech-debt | medium | council-finding | agentops |
| 3 | Collect BF6-BF9 evidence from first real-project application | improvement | low | retro-pattern | * |

### Recommended Next /rpi
```
/rpi "Add marketplace/plugin version parity check to release pre-flight"
```

## Status

[x] CLOSED - Work complete, learnings captured
