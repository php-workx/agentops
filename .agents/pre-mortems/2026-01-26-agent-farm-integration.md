# Pre-Mortem: AgentOps + Agent Farm Mayor/Crew Integration

**Date:** 2026-01-26
**Spec:** /Users/fullerbt/.claude/plans/hidden-puzzling-hartmanis.md

## Summary

Building a Mayor/Crew pattern where:
- Mayor (Claude session) does /research → /plan → /pre-mortem
- `/farm` skill spawns Agent Farm (N agents in tmux)
- Witness (separate tmux session) monitors agents
- MCP Agent Mail for inter-agent messaging
- ao CLI commands for orchestration

**Pre-mortem simulated 10 iterations. Found 26 failure scenarios.**

## Simulation Findings

### CRITICAL (Must Fix Before Implementation)

| # | Issue | Why It Will Fail | Recommended Fix |
|---|-------|------------------|-----------------|
| 1 | **TOCTOU Race on Issue Claim** | Two agents call `br ready` simultaneously, both claim same issue, duplicate work or merge conflicts | Implement optimistic locking: `bd update --expect-version N` or atomic `bd claim` command |
| 2 | **Circular Dependency Infinite Loop** | If issues have circular deps (A→B→C→A), farm hangs forever polling empty `br ready` | Add cycle detection in FIND phase, exit with error listing cycle |
| 3 | **No Ready Issues - Farm Hangs** | If all issues blocked, FIND/IGNITE/REAP loop continues indefinitely consuming tokens | Exit condition: if ready=0 and blocked>0, error out |
| 4 | **Witness Crash = Silent Failure** | Witness crashes (OOM), no heartbeat monitoring, Mayor never gets "FARM COMPLETE" | Add witness PID health check every 30s in /farm |
| 5 | **API Rate Limit Cascade** | 5 agents spawn in 15s = 10-15 API calls simultaneously, rate limit triggers, all fail | Serial spawn with backoff: 1 agent, wait 30s, then remaining serially |
| 6 | **MCP Agent Mail Server Dies** | MCP server on :8765 crashes, agents can't send messages, witness can't summarize | Health endpoint `/health`, witness monitors, auto-restart via supervisor |
| 7 | **Beads JSONL Corruption** | Concurrent `bd update` from multiple agents can interleave writes, corrupt JSONL | Use `flock()` for cross-process file locking on .beads/ |
| 8 | **Token Budget Exhaustion** | Agent runs out of context mid-implementation, produces truncated code, validation passes | Per-agent token budget (8k), auto-return at 80% |
| 9 | **Git Push Fails = Orphaned State** | Agent closes issue locally, push fails, beads says CLOSED but remote sees OPEN | Verify push success before marking issue closed |

### HIGH (Should Fix)

| # | Issue | Risk | Mitigation |
|---|-------|------|------------|
| 1 | **More Agents Than Issues** | 5 agents spawn for 3 issues, agents 4-5 race to claim already-claimed issues | IGNITE phase caps spawned agents to min(requested, ready_count) |
| 2 | **Agent Crash Orphans Polecat** | Agent OOM, tmux pane dead, issue still `in_progress`, disk resources held | Auto-cleanup: if agent dead >5min, requeue issue, nuke polecat |
| 3 | **settings.json Corruption** | 10 agents backup/restore settings.json within 2s window, race corrupts file | Extend lock hold time for entire session, or use WAL |
| 4 | **Mayor Session Disconnect** | Human closes terminal, polecats orphaned, issues stuck `in_progress` | Add `/farm --resume <epic>` to reconcile from beads state |
| 5 | **Git Merge Conflict Blocks Farm** | Two agents modify same file, merge conflict, issue can't close | Detect merge failure, flag for human review, don't block farm |
| 6 | **No Graceful Shutdown** | Ctrl+C kills farm but leaves MCP server and witness running | Track child PIDs, SIGTERM all on exit |
| 7 | **Pool File Concurrent Access** | Multiple agents call `ao pool stage` simultaneously, one write lost | Add file locking to pool.go with flock() |
| 8 | **Beads Issue Stuck In Progress** | Agent crashes after claiming issue, no auto-release | Heartbeat with issue ID, auto-release if stale >5min |
| 9 | **Farm Completes But Witness Misses** | 60s poll interval, all issues close at t=0, witness polls at t=30, Mayor exits at t=5 | Mayor waits for witness signal OR 120s timeout |
| 10 | **Orchestrator Wave Timeout** | Pod analysis hangs (network issue), no timeout, synthesis pipeline blocked | Add 120s timeout per pod, write empty findings on timeout |

### MEDIUM (Consider)

| # | Issue | Note |
|---|-------|------|
| 1 | **Issues Added Mid-Run** | New issue created while farm running, may be ignored or cause capacity overflow |
| 2 | **Poll Interval Timing Skew** | Network latency causes REAP to miss brief states |
| 3 | **Retry Queue Overflow** | 15+ issues fail, individual escalation takes 15+ minutes |
| 4 | **No Disk Space Monitoring** | Heartbeats + backups accumulate, disk fills, git commits fail |
| 5 | **MCP Port Hardcoded 8765** | Can't run multiple farms on same machine |
| 6 | **Stale Witness Sessions** | Multiple runs create orphaned witness sessions |
| 7 | **Witness Polling Thundering Herd** | All agents write heartbeats when witness reads, 10s stalls |
| 8 | **No Cost Tracking** | 10 agents × API calls, no visibility into per-agent spend |
| 9 | **No Beads Pagination** | 500+ issues in epic, `br ready` returns 10MB JSON |
| 10 | **Task Pool Desynced from Beads** | Issue closed but task not promoted, knowledge flywheel gaps |

## Ambiguities Found

1. **Witness Model**: Should witness use Haiku (cheap, continuous) or Opus (smart summaries)?
2. **Farm Completion Signal**: Who decides "farm complete" - Mayor (all issues closed) or Witness (final poll)?
3. **Claim Atomicity**: Does beads `bd update` support optimistic locking or atomic claim?
4. **Agent Identity**: How do agents register with MCP Agent Mail? Hardcoded or dynamic?
5. **Retry Limit**: How many times can an issue fail before permanent escalation?
6. **Context Budget**: What's the per-agent token limit? How is it enforced?

## Spec Enhancement Recommendations

### 1. Add Pre-Flight Validation Phase
Before spawning farm:
- Validate beads JSON syntax
- Detect circular dependencies
- Check ready issue count >= 1
- Verify MCP server health
- Confirm disk space >5GB

### 2. Add Atomicity to Issue Claims
Either:
- Beads `bd claim <id> --agent <name>` that fails if already claimed
- Or optimistic locking: `bd update --expect-version N`

### 3. Add Witness Health Monitoring
- Witness PID tracked in `.witness.pid`
- Mayor checks every 30s: `kill -0 $PID`
- On death, escalate error

### 4. Add Farm Resume Capability
- `/farm --resume <epic>` reconciles from beads + tmux state
- Discovers orphaned polecats
- Requeues stuck issues

### 5. Add Graceful Shutdown Protocol
```bash
# On SIGINT:
# 1. SIGTERM to witness PID
# 2. SIGTERM to MCP server PID
# 3. Kill tmux session
# 4. Wait 10s, SIGKILL stragglers
# 5. Clean up port bindings
```

### 6. Add Circuit Breaker
If >50% agents fail within 60s:
- Stop spawning remaining agents
- Escalate to Mayor
- Wait for manual intervention

### 7. Specify Token Budget
- Per-agent limit: 8,000 tokens
- Warning at 80%: summarize and return
- Hard limit at 95%: force return with incomplete marker

## Architecture Diagram with Failure Points

```
┌─────────────────────────────────────────────────────────────────────┐
│  MAYOR SESSION                                                       │
│  ┌─────────┐     ┌─────────┐     ┌─────────────┐     ┌──────────┐  │
│  │/research│ ──▶ │ /plan   │ ──▶ │/pre-mortem  │ ──▶ │  /farm   │  │
│  └─────────┘     └─────────┘     └─────────────┘     └────┬─────┘  │
│                                                           │         │
│                                        ┌──────────────────┘         │
│                                        ▼                            │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  AGENT FARM (tmux)                                            │  │
│  │  ┌────────┬────────┬────────┐                                 │  │
│  │  │Agent 1 │Agent 2 │Agent 3 │  ◀─[F3: Race to claim]          │  │
│  │  │ ◀─[F1] │ ◀─[F8] │        │                                 │  │
│  │  └───┬────┴───┬────┴───┬────┘                                 │  │
│  │      │        │        │                                      │  │
│  │      ▼        ▼        ▼                                      │  │
│  │  ┌────────────────────────┐                                   │  │
│  │  │ .beads/issues.jsonl    │ ◀─[F7: Concurrent write corrupt]  │  │
│  │  └────────────────────────┘                                   │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                         │                                           │
│                         ▼                                           │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  WITNESS (separate tmux)         ◀─[F4: Crash undetected]     │  │
│  │  Poll: 60s interval              ◀─[F9: Misses completion]    │  │
│  │  Summarize: 5m interval                                       │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                         │                                           │
│                         ▼ (Agent Mail)                              │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  MCP AGENT MAIL (:8765)          ◀─[F6: Server dies]          │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘

Legend:
F1 = API Rate Limit Cascade
F3 = TOCTOU Race on Issue Claim
F4 = Witness Crash Silent
F6 = MCP Server Dies
F7 = Beads JSONL Corruption
F8 = Token Budget Exhaustion
F9 = Farm Completion Race
```

## Implementation Priority

### Must Fix Before v1.0 (Blockers)

1. **Atomic Issue Claims** - Prevents duplicate work
2. **Circular Dependency Detection** - Prevents infinite loops
3. **Witness Health Check** - Ensures completion signal
4. **Pre-Flight Validation** - Fails fast on bad state
5. **Graceful Shutdown** - Cleans up resources

### Should Fix Before Scale (>3 agents)

6. **API Rate Limit Backoff** - Enables multi-agent spawning
7. **MCP Health Monitoring** - Ensures messaging reliability
8. **Beads File Locking** - Prevents data corruption
9. **Farm Resume** - Recovers from disconnects
10. **Circuit Breaker** - Prevents cascade failures

### Nice to Have

11. Token budget tracking
12. Cost visibility per agent
13. Batch escalation
14. Dynamic epic locking

## Verdict

**[ ] READY** - Proceed to implementation
**[X] NEEDS WORK** - Address critical/high issues first

### Critical Issues: 9
### High Issues: 10
### Medium Issues: 10

**Recommendation:** The current plan has architectural gaps that will cause failures in production. Before implementing:

1. Design atomic issue claiming mechanism
2. Add cycle detection to beads or FIRE loop
3. Define witness health monitoring protocol
4. Specify graceful shutdown procedure
5. Add pre-flight validation checklist

These 5 items should be added to the plan before approval. Estimated additional design work: 2-4 hours.
