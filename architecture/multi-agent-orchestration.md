# Pattern: Multi-Agent Orchestration

**Abstract:** Run multiple agents in parallel for 3x speedup without exceeding token budget.

**Speedup:** 30 min → 10 min wall-clock time (3x faster, same token budget)

**Domains validated:** Product development, Infrastructure/DevOps

---

## The Pattern

```
Sequential (Slow):
  Agent 1: Code search    [5-10 min]
  ↓ wait
  Agent 2: Docs search    [5-10 min]
  ↓ wait
  Agent 3: History search [5-10 min]
  Total: 15-30 minutes

Parallel (Fast):
  Agent 1: Code search    ┐
  Agent 2: Docs search    ├─ [Simultaneous]
  Agent 3: History search ┘
  Total: 5-10 minutes

Both use same token budget (each agent gets 15-20k tokens)
Wall-clock speedup: 3x (20-30 min → 7-10 min)
```

---

## Why It Works

**Problem:** Research takes too long (20-30 minutes sequential)

**Solution:** 3 agents research simultaneously, same tokens

**Benefit:**
- 3x faster wall-clock time
- 3 perspectives prevent mistakes
- Same token budget as sequential
- Result: combined research with 3 viewpoints

---

## The 3 Standard Agents

### Agent 1: Code Explorer
- Searches your codebase
- Finds existing patterns
- Locates file references
- Identifies dependencies

### Agent 2: Documentation Researcher
- Reads guides and docs
- Finds best practices
- Understands architecture decisions
- Locates reference implementations

### Agent 3: History Analyst
- Searches git history
- Finds previous attempts
- Identifies lessons learned
- Shows what didn't work

---

## Implementation in Commands

### Parallel Research

```bash
/prime-complex-multi "Your research question"

[All 3 agents start simultaneously]
Agent 1: Code search → findings (5-10k tokens)
Agent 2: Docs search → findings (5-10k tokens)
Agent 3: History search → findings (5-10k tokens)
[Synthesis]
Combined research with 3 perspectives (1-2k tokens)
```

### Parallel Validation

```bash
/validate-multi

[All 3 validators start simultaneously]
Validator 1: YAML syntax → results
Validator 2: Security scan → results
Validator 3: Workflow compliance → results
[Combined report]
Total time: ~10 seconds (vs 30 sequential)
```

---

## Example: Product Research

**Sequential (30 minutes):**
```
Agent: Research "How to add real-time notifications?"
  1. Search code for existing notification patterns
  2. Read notification docs
  3. Check git history for previous attempts
Total: 20-30 minutes
```

**Parallel (10 minutes):**
```
Agent 1: Code Explorer
  Search: "notification", "webhook", "realtime"
  Find: apps/notifications/, WebSocket code, polling examples

Agent 2: Docs Researcher
  Search: README, architecture, "real-time"
  Find: "Notifications architecture", best practices, performance guide

Agent 3: History Analyst
  Search: git log "notification", "realtime", "websocket"
  Find: "Tried polling (failed)", "WebSocket (success, 2024)"

[Synthesis]:
  All 3 recommend: WebSocket with fallback to polling
  Code shows working example
  Docs support this choice
  History shows previous failure (polling too slow)
  Result: 3 perspectives, 10 minutes, 3x speedup
```

---

## Example: Infrastructure Research

**Sequential:**
```
Research: "Kyverno policies for network security"
- Agent researches code patterns
- Agent researches documentation
- Agent researches git history
Total: 20-30 minutes
```

**Parallel:**
```
Agent 1: Code Explorer
  Find: existing-kyverno-policies/, policy examples, validation patterns

Agent 2: Docs Researcher
  Find: kyverno best practices, network policy design guide, examples

Agent 3: History Analyst
  Find: commits adding policies, lessons from policy failures

Result: 10 minutes, 3 perspectives, ready to plan
```

---

## Metrics

| Metric | Sequential | Parallel | Gain |
|--------|-----------|----------|------|
| Wall-clock time | 20-30 min | 7-10 min | **3x faster** |
| Token budget | 50k (Agent 1 + 2 + 3) | 50k (all 3 @ 15-20k each) | **Same** |
| Perspectives | 1 | 3 | **3x better** |
| Mistake prevention | Baseline | 3 viewpoints | **Better** |

---

## When to Use Parallel

**Use parallel when:**
- ✅ Complex research needed (unfamiliar domain)
- ✅ Time pressure exists (quick decision needed)
- ✅ Multiple perspectives valuable (risky decision)
- ✅ Different angles matter (code + docs + history)

**Use sequential when:**
- ❌ Simple questions (don't need 3 agents)
- ❌ Already know answer (just confirming)
- ❌ Single agent sufficient (straightforward problem)

---

## How Agents Specialize by Domain

Same 3 agent types, different specializations:

| Agent | Product | DevOps | SRE |
|-------|---------|--------|-----|
| Explorer | Code patterns | Infrastructure configs | System logs |
| Researcher | Product specs | Best practices | Runbooks |
| Historian | Feature history | Change history | Incident history |

**Pattern is universal; specialization is domain-specific.**

---

## See Also

- `phase-based-workflow.md` - Phase 1 can use parallel agents
- Commands: `/prime-complex-multi`, `/validate-multi`
- Pattern: Used during research phase for 3x speedup
