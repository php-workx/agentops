---
description: Re-execute a proven pattern with custom inputs
---

# /replay-pattern - Pattern Replay Command

**Purpose:** Execute a known pattern directly, skipping Research and Planning phases

**When to use:**
- You know exactly which pattern you need
- Want faster execution (skip discovery)
- Pattern has proven track record
- Task matches pattern perfectly

**Token budget:** 10-30k tokens (skips Research/Plan phases)

**Output:** Executed workflow using proven pattern

---

## Basic Usage

```bash
/replay-pattern <pattern_id> "[task description]"
```

**Examples:**

```bash
# Execute known pattern directly
/replay-pattern rest-api-jwt-redis-v1 "Build API for my e-commerce site"

# Replay with custom parameters
/replay-pattern rest-api-jwt-redis-v1 "Build API" --port 8080 --db-host redis.local

# Dry run (show what would execute)
/replay-pattern rest-api-jwt-redis-v1 "Build API" --dry-run
```

---

## How It Works

### Step 1: Load Pattern from Neo4j

**Query pattern definition:**
```cypher
// Get pattern workflow
MATCH (pat:Pattern {pattern_id: $pattern_id})
RETURN pat.workflow_steps, pat.success_rate, pat.executions

// Get plugin sequence
MATCH (pat:Pattern {pattern_id: $pattern_id})-[u:USES]->(plugin:Plugin)
RETURN plugin.name, u.step_number, u.required
ORDER BY u.step_number

// Load known issues for pre-flight checks
MATCH (pat:Pattern {pattern_id: $pattern_id})-[:USES]->(p:Plugin)-[:HAS_ISSUE]->(issue:Issue)
RETURN p.name AS plugin, issue.error_pattern, issue.solution
ORDER BY issue.frequency DESC
```

### Step 2: Validate Pattern Applicability

**Check if pattern matches task:**
- Pattern category matches task domain
- Success rate meets threshold (≥80%)
- All required plugins available
- No blocking known issues

### Step 3: Execute Workflow

**Run plugin sequence directly:**
1. **Skip Research** (pattern already known)
2. **Skip Planning** (workflow pre-defined)
3. **Execute Implementation** (run plugin sequence)
4. **Record Learning** (update pattern metrics)

---

## Output Format

```markdown
# Pattern Replay: REST API with JWT + Redis

## Pattern Info
- **Pattern ID:** rest-api-jwt-redis-v1
- **Success Rate:** 92% (44/48 executions)
- **Last Used:** 2 hours ago
- **Avg Duration:** 11.5 minutes

## Pre-Flight Checks
✓ All 5 plugins available
✓ No blocking issues
⚠ Known issue: python-jose dependency (auto-fixable)

## Executing Workflow...

[Step 1/5] Creating API structure (fastapi-scaffolder)
  Status: Running...
  ✓ Complete (2 min)

[Step 2/5] Adding JWT authentication (jwt-auth-plugin)
  Status: Running...
  ⚠ Missing dependency: python-jose
  Status: Installing dependency...
  ✓ Complete (4 min)

[Step 3/5] Setup Redis caching (redis-cache-plugin)
  Status: Running...
  ✓ Complete (3 min)

[Step 4/5] Configure rate limiting (rate-limiter-plugin)
  Status: Running...
  ✓ Complete (2 min)

[Step 5/5] Validate system (api-tester)
  Status: Running tests...
  ✓ All tests passed (1 min)

✓ Workflow complete (12 min total)

## Results
- API running at http://localhost:8000
- Documentation: http://localhost:8000/docs
- Tests passed: 24/24
- Endpoints created: 5

## Learning (AUTOMATIC)
✓ Pattern execution recorded in Neo4j
✓ Success rate updated: 0.92 (45/49)
✓ Metrics updated in file system
```

---

## Command Options

```bash
# Basic replay
/replay-pattern <pattern_id> "[task]"

# Custom parameters
/replay-pattern <pattern_id> "[task]" --param1 value1 --param2 value2

# Dry run (preview only)
/replay-pattern <pattern_id> "[task]" --dry-run

# Override specific plugins
/replay-pattern <pattern_id> "[task]" --plugin-override "step2:alternative-plugin"

# Skip optional plugins
/replay-pattern <pattern_id> "[task]" --skip-optional

# Force execution (ignore warnings)
/replay-pattern <pattern_id> "[task]" --force

# Show pattern info only
/replay-pattern <pattern_id> --info
```

---

## When to Use Replay vs. Orchestrate

### Use /replay-pattern When:
✅ You know exactly which pattern you need
✅ Task matches pattern 100%
✅ Pattern has high success rate (≥80%)
✅ Want fastest execution (skip discovery)
✅ Pattern proven for this task type

### Use /orchestrate When:
✅ Unsure which pattern to use
✅ Task is novel or uncommon
✅ Want to discover best approach
✅ Multiple patterns might work
✅ Need research and planning

**Example:**

```bash
# Known pattern for familiar task
/replay-pattern rest-api-jwt-redis-v1 "Build user service API"
# ⏱️ Executes in 12 minutes (skips Research/Plan)

# Unknown approach for new task
/orchestrate "Build real-time chat API with WebSockets and presence"
# ⏱️ Takes 25 minutes (Research/Plan/Implement/Learn)
# → Discovers new pattern: websocket-api-presence-v1
```

---

## Advantages of Replay

**Time savings:**
- **Skip Research:** No plugin discovery needed (saves 5-7 minutes)
- **Skip Planning:** Workflow pre-defined (saves 2-3 minutes)
- **Direct execution:** Start implementation immediately

**Reliability:**
- **Proven patterns:** Only replay high-success patterns (≥80%)
- **Known issues:** Pre-flight checks warn about common failures
- **Optimized workflow:** Plugin sequence already validated

**Predictability:**
- **Estimated duration:** Based on historical executions
- **Expected issues:** Known from previous runs
- **Clear success criteria:** Tests and validation pre-defined

---

## Error Handling

### Issue: Pattern Not Found

```
❌ Pattern not found: rest-api-jwt-redis-v2

Available similar patterns:
1. rest-api-jwt-redis-v1 (92% success, 48 uses) ⭐
2. rest-api-oauth-redis-v1 (85% success, 23 uses)

Use one of these? [1/2] or search: /browse-patterns
```

### Issue: Low Success Rate

```
⚠️ Pattern success rate below threshold

Pattern: experimental-graphql-v1
Success Rate: 65% (13/20 executions)
Recommendation: Use /orchestrate instead for better results

Proceed anyway? [y/n]
```

### Issue: Plugin Unavailable

```
❌ Required plugin unavailable: jwt-auth-plugin

Pattern requires:
1. fastapi-scaffolder ✓
2. jwt-auth-plugin ✗ (not installed)
3. redis-cache-plugin ✓

Install missing plugin? [y/n]
Or use fallback pattern: /browse-patterns --similar rest-api-jwt-redis-v1
```

### Issue: Known Blocking Issue

```
⚠️ Known blocking issue detected

Plugin: redis-cache-plugin
Issue: Redis connection fails on macOS (frequency: 12)
Solution: Start Redis server first

Pre-flight check failed. Fix and retry? [y/n]
Or use alternative: rest-api-jwt-postgres-v1 (no Redis)
```

---

## Neo4j Queries Used

**Load pattern:**
```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})
RETURN pat
```

**Get workflow steps:**
```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})-[u:USES]->(plugin:Plugin)
RETURN plugin, u.step_number, u.required
ORDER BY u.step_number
```

**Load known issues:**
```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})-[:USES]->(p:Plugin)-[:HAS_ISSUE]->(issue:Issue)
RETURN p.name AS plugin, issue.error_pattern, issue.solution, issue.frequency
ORDER BY issue.frequency DESC
```

**Record execution:**
```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})
CREATE (exec:Execution {
  execution_id: randomUUID(),
  task_description: $task,
  status: $status,
  duration_ms: $duration,
  started_at: datetime(),
  completed_at: datetime()
})
CREATE (exec)-[:IMPLEMENTS]->(pat)

FOREACH (plugin_exec IN $plugin_executions |
  MERGE (p:Plugin {name: plugin_exec.name})
  CREATE (p)-[:EXECUTED_IN {
    step: plugin_exec.step,
    duration_ms: plugin_exec.duration,
    status: plugin_exec.status
  }]->(exec)
)

// Update pattern metrics
SET pat.executions = pat.executions + 1,
    pat.last_used = datetime()
```

---

## Fallback Without Neo4j

If Neo4j unavailable, falls back to file-based pattern loading:

```bash
# Load pattern from file
cat patterns/validated/rest-api-jwt-redis-v1.yaml

# Parse workflow steps
grep "workflow:" -A 10 patterns/validated/rest-api-jwt-redis-v1.yaml

# Execute plugin sequence
# (same implementation phase, just slower pattern lookup)
```

**Performance difference:**
- **With Neo4j:** Pattern load ~50ms (graph query)
- **Without Neo4j:** Pattern load ~200ms (file scan + parse)

---

## Related Commands

- **/browse-patterns** - Find patterns to replay
- **/inspect-pattern** - Understand pattern before replaying
- **/orchestrate** - Full workflow with discovery

---

## Examples

### Example 1: Fast API Creation

```bash
# You've used this pattern 10 times before
/replay-pattern rest-api-jwt-redis-v1 "Build payment service API"

# Execution:
# ⏱️ 0s: Load pattern from Neo4j
# ⏱️ 10s: Pre-flight checks (all pass)
# ⏱️ 12m: Execute 5-plugin workflow
# ⏱️ 12m: Record learning
#
# Total: 12 minutes (vs 25 minutes with /orchestrate)
```

### Example 2: With Custom Parameters

```bash
# Replay but customize Redis host
/replay-pattern rest-api-jwt-redis-v1 \
  "Build API" \
  --redis-host redis.production.local \
  --port 8080

# Pattern uses custom parameters for plugin config
```

### Example 3: Dry Run First

```bash
# Preview what would execute
/replay-pattern rest-api-jwt-redis-v1 "Build API" --dry-run

# Output:
# Pattern: REST API with JWT + Redis
# Workflow:
#   1. fastapi-scaffolder (~2 min)
#   2. jwt-auth-plugin (~4 min)
#   3. redis-cache-plugin (~3 min)
#   4. rate-limiter-plugin (~2 min)
#   5. api-tester (~1 min)
# Estimated: 12 minutes
# Known issues: 1 (auto-fixable)
#
# Execute? [y/n]
```

---

**Version:** 0.1.0
**Last Updated:** November 8, 2025
