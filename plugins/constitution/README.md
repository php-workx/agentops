# Constitution Plugin

**The foundational rules that govern all agent operations.**

## The Four Pillars

AgentOps is built on four foundational pillars:

1. **DevOps + SRE** - Apply the same practices you use for containers to agents
2. **Learning Science** - Research→Plan→Implement based on cognitive science
3. **Context Engineering** - Stay under 40% token budget, JIT load context
4. **Knowledge OS** - Git as institutional memory, commits as knowledge writes

**Key insight:** Agents ARE microservices. Apply the SAME controls.

## Installation

```bash
/plugin marketplace add boshu2/agentops
/plugin install constitution@agentops
```

## Skills

| Skill | Purpose |
|-------|---------|
| `laws-of-an-agent` | The Nine Laws every agent must follow |
| `context-engineering` | The 40% Rule and JIT loading |
| `git-discipline` | Semantic commits and Knowledge OS |

## Agent

| Agent | Purpose |
|-------|---------|
| `guardian` | Enforce constitutional rules |

---

## The Nine Laws of an Agent

| Law | Principle | Summary |
|-----|-----------|---------|
| **1** | Learn and Improve | Extract patterns, identify improvements |
| **2** | Document for Future | Context commits, progress files, bundles |
| **3** | Git Discipline | Commit often, clean workspace, no hook loops |
| **4** | TDD with Tracers | Tests first for L1-L2 (high-risk) tasks |
| **5** | Guide with Workflows | Suggest options, let user choose |
| **6** | Classify Vibe Level | Ask "what level?" (0-5) before work |
| **7** | Measure and Calibrate | vibe-check before/after, break spirals |
| **8** | Session Protocol | One feature, review before end, update progress |
| **9** | Protect Feature Definitions | Never modify, only mark \`passes\` |

See [laws-of-an-agent.md](./skills/laws-of-an-agent.md) for full details.

---

## The 40% Rule

**Problem:** 200k token limit. Loading everything = context collapse.

**Solution:** Stay under 40% of token budget (80k of 200k).

```
Token Usage Zones:
🟢 <35% (70k)   - GREEN: Continue working
⚡ 35-40% (70-80k) - YELLOW: Prepare to bundle
⚠️ 40-60% (80-120k) - RED: Bundle NOW
🔴 >60% (120k+) - CRITICAL: Context degraded
```

**Pattern:** Gather → Glean → Summarize

---

## Vibe Levels

| Level | Trust | Verify | Use For |
|-------|-------|--------|---------|
| 5 | 95% | Final only | Format, lint |
| 4 | 80% | Spot check | Boilerplate |
| 3 | 60% | Key outputs | CRUD, tests |
| 2 | 40% | Every change | Features |
| 1 | 20% | Every line | Architecture |
| 0 | 0% | N/A | Novel research |

---

## Git as Knowledge OS

### Commits = Memory Writes

Every commit captures:
- What changed (the diff)
- Why it changed (commit message)
- When it changed (timestamp)
- Who changed it (author)

### Semantic Commits

Format: `<type>(<scope>): <subject>`

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code restructure |
| `test` | Add/update tests |
| `chore` | Maintenance |

---

## Dependencies

None - this is the foundational plugin.

## Links

- [12-Factor AgentOps Framework](https://github.com/boshu2/12-factor-agentops)
- [Vibe Coding Book](https://itrevolution.com/product/vibe-coding-book/) - Gene Kim & Steve Yegge
