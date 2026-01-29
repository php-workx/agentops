# Hierarchical Synthesis Architecture

**Schema Version:** 1
**Date:** 2026-01-26
**Status:** ACTIVE

## Overview

This spec defines the hierarchical agent synthesis architecture for scaling validation
to 50+ concurrent agents. The design eliminates context explosion from nested skill
calls by using flat dispatch with hierarchical aggregation.

## Problem Statement

Current validation approach:
- `/post-mortem` calls `/vibe` which spawns 8 experts
- Each expert is sequential, creating 8x latency
- Nested skill calls cause 2x context consumption
- Cannot scale beyond ~10 effective validators

Target state:
- Support 50+ concurrent agents (22 Claude Code accounts)
- Hierarchical synthesis reduces findings to manageable size
- Single-veto rule ensures quality gates work at scale
- Context budget maintained at 40-60% per wave

## Architecture

### Pod Structure

```
                    ┌─────────────────┐
                    │  FINAL SYNTH    │  (1 agent)
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────┴────┐          ┌────┴────┐          ┌────┴────┐
   │ CLUSTER │          │ CLUSTER │          │ CLUSTER │  (3-5 synthesizers)
   │ SYNTH A │          │ SYNTH B │          │ SYNTH C │
   └────┬────┘          └────┬────┘          └────┬────┘
        │                    │                    │
   ┌────┴────┐          ┌────┴────┐          ┌────┴────┐
   │ POD A   │          │ POD B   │          │ POD C   │  (6-8 analyzers each)
   │ 6-8     │          │ 6-8     │          │ 6-8     │
   │ agents  │          │ agents  │          │ agents  │
   └─────────┘          └─────────┘          └─────────┘
```

### Wave Execution

**Wave 1: Analysis (Parallel)**
- 50 analyzers split into 6-8 pods
- Each pod targets specific aspects:
  - Security pod (auth, injection, crypto)
  - Architecture pod (patterns, coupling, scalability)
  - Quality pod (complexity, coverage, maintainability)
  - UX pod (accessibility, performance, error handling)
  - Data pod (validation, migrations, integrity)
  - Ops pod (logging, monitoring, deployment)
- Agents in each pod run fully parallel
- Output: Raw findings with severity (CRITICAL/HIGH/MEDIUM/LOW)

**Wave 2: Cluster Synthesis (Parallel)**
- One synthesizer per pod (6-8 synthesizers)
- Merge findings from their pod
- Apply single-veto rule: ANY CRITICAL → cluster CRITICAL
- Deduplicate similar findings
- Drop LOW findings if context >60%
- Output: Merged findings per cluster

**Wave 3: Final Synthesis (Single)**
- One final synthesizer
- Aggregate across all clusters
- Apply 70% quorum rule for HIGH findings
- Produce final verdict: CRITICAL/HIGH/MEDIUM/LOW/PASS
- Output: Final report with actionable findings

### Context Budget Allocation

| Level | Budget | Actions at Threshold |
|-------|--------|---------------------|
| Pod analyzer | 40% | Optimal operation |
| Pod analyzer | 60% | Warning, prioritize CRITICAL/HIGH |
| Pod analyzer | 80% | Progressive summarization |
| Cluster synth | 50% | Receive pod summaries only |
| Final synth | 50% | Receive cluster summaries only |

### Decision Rules

**Single-Veto Rule (within pod):**
```
if ANY agent reports CRITICAL:
    pod_severity = CRITICAL
```

**Aggregation Formula (across pods):**
```
final_severity = max(
    highest_severity_with_quorum,
    any_critical_from_any_pod
)

quorum_threshold = 0.70  # 70% agreement needed
```

**Finding Deduplication:**
```
Similar findings (>80% semantic overlap):
    - Keep highest severity
    - Merge context from all sources
    - List all affected files
```

### Streaming Behavior

1. **Early Termination**
   - If 3+ pods report CRITICAL on same issue → immediate CRITICAL
   - No need to wait for remaining analysis

2. **Progressive Reporting**
   - Stream findings as pods complete
   - UI shows partial results immediately
   - Final verdict waits for all pods

3. **Context Preservation**
   - File changes always preserved
   - Failing tests always preserved
   - CRITICAL findings always preserved
   - LOW findings dropped first when constrained

## Integration Points

### /vibe Integration

```
# Current (nested - BAD)
/vibe → spawns 8 sequential experts

# New (flat dispatch - GOOD)
/vibe --hierarchical
    → Wave 1: Parallel pod dispatch (50 agents)
    → Wave 2: Cluster synthesis (6-8 agents)
    → Wave 3: Final synthesis (1 agent)
```

### /post-mortem Integration

```
# Current (nested - BAD)
/post-mortem step 2 → calls /vibe

# New (inline - GOOD)
/post-mortem step 2 → inline validation
    → 8 aspects checked directly
    → Single-veto rule applied
    → Early exit on CRITICAL
```

### /crank Integration

```
# Current (per-issue vibe - BAD)
for each issue:
    /implement issue
    /vibe  # 8 experts per issue = context explosion

# New (batched - GOOD)
for each issue:
    /implement issue
    track_changes()
end

/vibe --batch --hierarchical  # One batched validation
```

## API

### WaveDispatcher

```go
type WaveDispatcher struct {
    PodSize      int           // 6-8 agents per pod
    MaxPods      int           // Total pods
    ContextLimit float64       // Budget threshold (0.6 = 60%)
}

func (d *WaveDispatcher) DispatchWave1(files []string) []PodResult
func (d *WaveDispatcher) DispatchWave2(pods []PodResult) []ClusterResult
func (d *WaveDispatcher) DispatchWave3(clusters []ClusterResult) FinalResult
```

### Consensus

```go
type Consensus struct {
    QuorumThreshold float64    // 0.70
    VetoOnCritical  bool       // true
    StreamResults   bool       // true
}

func (c *Consensus) ApplySingleVeto(findings []Finding) Severity
func (c *Consensus) ApplyQuorum(findings []Finding) Severity
func (c *Consensus) Deduplicate(findings []Finding) []Finding
```

### ConflictResolver

```go
type ConflictResolver struct {
    PodConflicts     map[string][]Finding
    ClusterConflicts map[string][]Finding
}

func (r *ConflictResolver) ResolveWithinPod(findings []Finding) Finding
func (r *ConflictResolver) ResolveAcrossPods(findings []Finding) Finding
```

## File Layout

```
cli/internal/orchestrator/
├── dispatch.go      # WaveDispatcher implementation
├── consensus.go     # Consensus rules
├── conflict.go      # Conflict resolution
├── pod.go           # Pod management
├── types.go         # Shared types
└── orchestrator_test.go
```

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Context overflow in synthesis | Progressive summarization at 80% |
| Pod failure | Retry with smaller pod, escalate on repeat failure |
| Conflicting findings | Single-veto ensures conservative (safe) decisions |
| Latency | Streaming results, early termination |
| Cost | Haiku for analysis, Opus only for final synthesis |

## Validation

### Unit Tests
- Test pod formation with various file counts
- Test single-veto rule
- Test quorum calculation
- Test deduplication

### Integration Tests
- Test 12-agent dispatch (mocked)
- Test 50-agent dispatch (mocked)
- Test context budget enforcement

### End-to-End
- Run on real codebase with >100 files
- Verify findings match sequential validation
- Measure latency improvement

## References

- L1: Nested skills explode context 2x
- L3: Single veto rule (ANY CRITICAL → final CRITICAL)
- L7: Flat dispatch beats nesting 2:1
- L8: RPI + 4 gates + flywheel = complete workflow
