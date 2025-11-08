# Metrics Infrastructure

**Purpose:** Track meta-orchestrator performance for learning and optimization

**Dual-Write Strategy:** Metrics written to both CSV files (primary) and Neo4j (secondary)

---

## Metrics Files

### durations.log

**Format:** CSV with columns:
```
timestamp,workflow_id,phase,step,plugin,duration_seconds,success
```

**Purpose:** Track execution timing for each workflow phase and plugin step

**Example:**
```csv
timestamp,workflow_id,phase,step,plugin,duration_seconds,success
2025-11-07T00:00:00Z,wf_2025-11-07_rest_api_health,research,1,plugin-discovery,120,true
2025-11-07T00:00:00Z,wf_2025-11-07_rest_api_health,implement,1,express-api-scaffold,180,true
```

**Usage:**
- Calculate average phase durations
- Identify slow plugins
- Optimize workflow timing
- Pattern duration estimation

---

### success_rates.log

**Format:** CSV with columns:
```
timestamp,pattern_id,pattern_name,success,duration_seconds,plugins_used,files_created,notes
```

**Purpose:** Track overall pattern success rate and metadata

**Example:**
```csv
timestamp,pattern_id,pattern_name,success,duration_seconds,plugins_used,files_created,notes
2025-11-07T00:00:00Z,pat_2025-11-07_simple_rest_api_health,simple-rest-api-health-check,true,540,4,7,"First execution. All steps completed successfully."
```

**Usage:**
- Calculate pattern success rates
- Identify high-performing patterns
- Pattern promotion (discovered → validated → learned)
- Confidence scoring

---

### plugin_usage.log

**Format:** CSV with columns:
```
timestamp,plugin_name,execution_count,total_duration_seconds,success_count,failure_count,avg_duration_seconds,last_used
```

**Purpose:** Track individual plugin usage statistics

**Example:**
```csv
timestamp,plugin_name,execution_count,total_duration_seconds,success_count,failure_count,avg_duration_seconds,last_used
2025-11-07T00:00:00Z,jwt-auth-plugin,1247,334800,1109,138,268.5,2025-11-07T18:00:00Z
2025-11-07T00:00:00Z,fastapi-scaffolder,856,171200,839,17,200.0,2025-11-07T17:30:00Z
```

**Usage:**
- Calculate plugin reliability (success/failure ratio)
- Identify popular plugins
- Detect problematic plugins (high failure rate)
- Estimate plugin execution time

---

## Metrics Aggregation

### Pattern Success Rate Calculation

```python
# From success_rates.log
successes = len([row for row in log if row['success'] == 'true'])
total = len(log)
success_rate = successes / total

# Update pattern file
pattern['success_rate'] = success_rate
pattern['executions'] = total
```

### Plugin Reliability Score

```python
# From plugin_usage.log
success_count = row['success_count']
failure_count = row['failure_count']
total = success_count + failure_count
reliability = success_count / total if total > 0 else 0.0

# Update Neo4j
UPDATE Plugin SET success_rate = reliability WHERE name = plugin_name
```

### Phase Duration Estimation

```python
# From durations.log
phase_durations = [row['duration_seconds'] for row in log if row['phase'] == 'implement']
avg_duration = sum(phase_durations) / len(phase_durations)
```

---

## Neo4j Integration

### Write Execution Metrics to Neo4j

```cypher
// Create Execution node
CREATE (exec:Execution {
  execution_id: $execution_id,
  task_description: $task,
  status: $status,
  duration_ms: $duration_ms,
  started_at: datetime($started_at),
  completed_at: datetime($completed_at)
})

// Link to Pattern
MATCH (pat:Pattern {pattern_id: $pattern_id})
CREATE (exec)-[:IMPLEMENTS]->(pat)

// Track plugin executions
FOREACH (plugin_exec IN $plugin_executions |
  MERGE (p:Plugin {name: plugin_exec.name})
  CREATE (p)-[:EXECUTED_IN {
    step: plugin_exec.step,
    duration_ms: plugin_exec.duration_ms,
    status: plugin_exec.status
  }]->(exec)
)

// Update pattern metrics
SET pat.executions = pat.executions + 1,
    pat.last_used = datetime()
```

### Update Plugin Metrics in Neo4j

```cypher
// Update plugin statistics
MATCH (p:Plugin {name: $plugin_name})
SET p.total_uses = p.total_uses + 1,
    p.last_used = datetime()

// Recalculate success rate from executions
MATCH (p:Plugin {name: $plugin_name})-[e:EXECUTED_IN]->(:Execution)
WITH p,
     COUNT(e) AS total_execs,
     SUM(CASE WHEN e.status = 'success' THEN 1 ELSE 0 END) AS successes
SET p.success_rate = toFloat(successes) / total_execs
```

---

## Data Retention

**CSV Files:**
- Keep all records (append-only logs)
- Archive yearly (move to `metrics/archive/2025/`)
- Never delete (institutional memory)

**Neo4j:**
- Keep last 1000 executions per pattern
- Archive older executions (export to CSV, remove from graph)
- Maintain aggregated metrics (success_rate, total_uses, etc.)

---

## Metric Queries

### Top Performing Patterns

```python
# From success_rates.log
patterns_by_success = sorted(
    success_rates,
    key=lambda x: (x['success'] == 'true', -float(x['duration_seconds']))
)
top_10 = patterns_by_success[:10]
```

### Most Used Plugins

```python
# From plugin_usage.log
plugins_by_usage = sorted(
    plugin_usage,
    key=lambda x: int(x['execution_count']),
    reverse=True
)
top_plugins = plugins_by_usage[:20]
```

### Average Phase Durations

```python
# From durations.log
phase_stats = {}
for row in durations:
    phase = row['phase']
    duration = float(row['duration_seconds'])

    if phase not in phase_stats:
        phase_stats[phase] = []

    phase_stats[phase].append(duration)

for phase, durations in phase_stats.items():
    avg = sum(durations) / len(durations)
    print(f"{phase}: {avg:.1f}s average")
```

---

## Metrics Dashboard (Future)

**Planned visualizations:**

1. **Pattern Success Trends**
   - Line chart: success rate over time per pattern
   - Shows if patterns degrade or improve

2. **Plugin Reliability Heatmap**
   - Grid: plugins × time periods
   - Color: green (high success) → red (high failure)

3. **Execution Duration Distribution**
   - Histogram: workflow completion times
   - Identify outliers and optimization targets

4. **Popular Plugin Pairs**
   - Network graph: plugins frequently used together
   - Helps discover integration patterns

---

## Version & Status

**Version:** 0.1.0
**Last Updated:** November 8, 2025
**Status:** Active (CSV files), Neo4j integration planned
