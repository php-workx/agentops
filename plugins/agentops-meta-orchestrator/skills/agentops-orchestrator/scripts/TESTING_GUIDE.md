# End-to-End Testing Guide

**Purpose:** Validate the complete Neo4j integration pipeline from plugin scanning to pattern recommendations.

**Time:** ~20 minutes

---

## Prerequisites

- [ ] Neo4j container running (see NEO4J_QUICK_START.md)
- [ ] Python 3.7+ installed
- [ ] Dependencies installed: `pip install neo4j pyyaml`
- [ ] NEO4J_PASSWORD environment variable set

---

## Test Suite Overview

**5 Test Scenarios:**
1. Plugin Scanner - Verify plugin metadata extraction
2. Neo4j Migration - Bulk load plugins and patterns
3. Pattern Storage - Dual-write new patterns
4. Pattern Queries - Search and recommendation queries
5. End-to-End - Complete workflow simulation

---

## Test 1: Plugin Scanner

**Purpose:** Verify plugin marketplace scanning works correctly

### Step 1: Run Plugin Scanner

```bash
cd /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts

python plugin_scanner.py --output /tmp/plugins_test.json --format json
```

### Expected Output

```
🔍 Scanning plugin marketplaces...

📦 Scanning claude-code-templates...
   Found 16 plugins

📦 Scanning wshobson/agents...
   Found 24 plugins

📦 Scanning jeremylongshore/claude-code-plugins-plus...
   Found 20 plugins

✅ Total plugins scanned: 60

=================================================================
PLUGIN SCAN SUMMARY
=================================================================

Total Plugins: 60

By Category:
  web-development: 20
  devops: 18
  data-engineering: 10
  security: 6
  ai-ml: 4
  microservices: 2

By Marketplace:
  claude-code-templates: 16
  wshobson/agents: 24
  jeremylongshore/claude-code-plugins-plus: 20

Average Estimated Success Rate: 88.9%

✅ Exported 60 plugins to /tmp/plugins_test.json
```

### Verification

```bash
# Check output file exists
ls -lh /tmp/plugins_test.json

# Verify JSON structure
head -50 /tmp/plugins_test.json

# Count plugins in file
cat /tmp/plugins_test.json | python -c "import sys, json; print(len(json.load(sys.stdin)))"
# Expected: 60
```

### Success Criteria

- ✅ 60 plugins scanned
- ✅ All 6 categories present
- ✅ JSON file valid and parseable
- ✅ Each plugin has: name, description, category, tags, success_rate

---

## Test 2: Neo4j Migration (Full Database Load)

**Purpose:** Verify bulk migration populates Neo4j correctly

### Step 1: Set Environment Variable

```bash
export NEO4J_PASSWORD="your-neo4j-password"
```

### Step 2: Run Migration

```bash
python migrate_to_neo4j.py
```

### Expected Output

```
🔌 Connecting to Neo4j...
✓ Connected to Neo4j at bolt://localhost:7687

======================================================================
NEO4J BULK MIGRATION
======================================================================

======================================================================
STEP 1: Schema Setup
======================================================================
🔧 Setting up Neo4j schema...
✓ Schema setup complete

======================================================================
STEP 2: Plugin Marketplace Scan & Load
======================================================================
🔍 Scanning plugin marketplaces...
✅ Total plugins scanned: 60
📦 Bulk creating 60 plugins...
✓ Created 60 plugin nodes

======================================================================
STEP 3: Compute Plugin Similarities
======================================================================
🔗 Computing plugin similarities (min similarity: 0.3)...
✓ Created 178 similarity relationships

======================================================================
STEP 4: Load Existing Patterns
======================================================================
📂 Loading patterns from filesystem...
   ✓ Loaded: Product Launch with Meta-Orchestrator
   ✓ Loaded: Simple REST API Health Check
✅ Loaded 2 patterns from filesystem
📦 Importing 2 patterns...
✅ Imported 2/2 patterns successfully

======================================================================
STEP 5: Link Patterns to Plugins
======================================================================
🔗 Linking patterns to plugins...
✅ Created 8 USES relationships

======================================================================
MIGRATION COMPLETE - DATABASE STATISTICS
======================================================================

Plugins: 60
Patterns: 2
Total Relationships: 186
  ├─ SIMILAR_TO: 178
  └─ USES: 8

======================================================================
🎉 Migration Complete!
======================================================================
```

### Step 3: Verify in Neo4j Browser

**Open:** http://localhost:7474

**Login:** username `neo4j`, password from environment variable

**Run verification queries:**

```cypher
// Query 1: Count nodes
MATCH (n)
RETURN labels(n)[0] as type, count(n) as count
ORDER BY count DESC

// Expected:
// Plugin: 60
// Pattern: 2
```

```cypher
// Query 2: Sample plugins
MATCH (p:Plugin)
RETURN p.name, p.category, p.success_rate, p.tags
ORDER BY p.success_rate DESC
LIMIT 10
```

```cypher
// Query 3: Count relationships
MATCH ()-[r]->()
RETURN type(r) as relationship_type, count(r) as count
ORDER BY count DESC

// Expected:
// SIMILAR_TO: 178
// USES: 8
```

```cypher
// Query 4: View pattern connections
MATCH (pat:Pattern)-[u:USES]->(p:Plugin)
RETURN pat.name as pattern,
       collect(p.name) as plugins,
       pat.success_rate as success_rate
```

```cypher
// Query 5: Test similarity relationships
MATCH (p1:Plugin)-[s:SIMILAR_TO]-(p2:Plugin)
WHERE p1.name = 'fastapi-scaffolder'
RETURN p2.name as similar_plugin,
       s.similarity_score as similarity,
       s.shared_tags as shared_tags
ORDER BY s.similarity_score DESC
LIMIT 5
```

### Success Criteria

- ✅ Migration completes without errors
- ✅ 60 Plugin nodes created
- ✅ 2 Pattern nodes created
- ✅ 178+ SIMILAR_TO relationships created
- ✅ 8 USES relationships created
- ✅ All queries return expected data

---

## Test 3: Pattern Storage Dual-Write

**Purpose:** Verify new patterns save to both filesystem and Neo4j

### Step 1: Test Filesystem-Only Mode (Baseline)

```bash
python pattern_storage.py \
  --workflow-result test_data/sample_workflow_result.json
```

**Expected Output:**
```
🔍 Extracting pattern...
💾 Saving pattern...
✓ Pattern saved to filesystem: ~/.claude/skills/meta-orchestrator/patterns/discovered/build-rest-api-with-v1.yaml
📊 Logging execution...
✓ Execution logged to filesystem: ~/.claude/skills/meta-orchestrator/metrics/executions.log
✅ Pattern storage complete!
Pattern ID: build-rest-api-with-v1
Success rate: 100.0%
Total executions: 1
```

**Verify:**
```bash
ls -la ~/.claude/skills/meta-orchestrator/patterns/discovered/build-rest-api-with-v1.yaml
cat ~/.claude/skills/meta-orchestrator/patterns/discovered/build-rest-api-with-v1.yaml
```

### Step 2: Test Neo4j Dual-Write Mode

```bash
python pattern_storage.py \
  --workflow-result test_data/data_pipeline_workflow.json \
  --enable-neo4j
```

**Expected Output:**
```
✓ Neo4j dual-write enabled
🔍 Extracting pattern...
💾 Saving pattern...
✓ Pattern saved to filesystem: ~/.claude/skills/meta-orchestrator/patterns/discovered/create-etl-pipeline-for-v1.yaml
✓ Pattern synced to Neo4j: create-etl-pipeline-for-v1
✓ Linked pattern to 4 plugins
📊 Logging execution...
✓ Execution logged to filesystem: ~/.claude/skills/meta-orchestrator/metrics/executions.log
✓ Execution synced to Neo4j: exec_20251108_123456_a1b2c3d4
✅ Pattern storage complete!
Pattern ID: create-etl-pipeline-for-v1
Success rate: 100.0%
Total executions: 1
✓ Pattern synced to Neo4j
```

### Step 3: Verify in Neo4j

```cypher
// Count patterns (should be 4 now: 2 migrated + 2 from tests)
MATCH (p:Pattern)
RETURN count(p) as pattern_count

// View new pattern
MATCH (p:Pattern {pattern_id: "create-etl-pipeline-for-v1"})
RETURN p

// View pattern's plugin connections
MATCH (pat:Pattern {pattern_id: "create-etl-pipeline-for-v1"})-[u:USES]->(plugin:Plugin)
RETURN pat.name as pattern,
       plugin.name as plugin,
       u.step_number as step,
       u.purpose as purpose
ORDER BY u.step_number

// View execution history
MATCH (exec:Execution)-[:IMPLEMENTS]->(pat:Pattern {pattern_id: "create-etl-pipeline-for-v1"})
RETURN exec.execution_id,
       exec.status,
       exec.duration_ms,
       exec.started_at
```

### Success Criteria

- ✅ Pattern saved to filesystem (both modes)
- ✅ Pattern synced to Neo4j (dual-write mode only)
- ✅ Plugin USES relationships created
- ✅ Execution node created in Neo4j
- ✅ Execution linked to pattern

---

## Test 4: Pattern Query & Recommendations

**Purpose:** Verify intelligent pattern discovery works

### Query 1: Full-Text Pattern Search

```cypher
// Search for API-related patterns
CALL db.index.fulltext.queryNodes("pattern_search", "api")
YIELD node, score
RETURN node.pattern_id as id,
       node.name as name,
       node.success_rate as success_rate,
       node.executions as executions,
       score
ORDER BY score DESC, node.success_rate DESC
LIMIT 5
```

**Expected:** Should find "build-rest-api-with-v1" pattern

### Query 2: Find Similar Plugins (Fallback Recommendations)

```cypher
// Find alternatives to airflow-dag-generator
MATCH (p:Plugin {name: "airflow-dag-generator"})-[s:SIMILAR_TO]-(similar:Plugin)
WHERE s.similarity_score >= 0.5
RETURN similar.name as alternative_plugin,
       s.similarity_score as similarity,
       s.shared_tags as shared_tags,
       similar.success_rate as success_rate
ORDER BY s.similarity_score DESC
LIMIT 5
```

**Expected:** Should find similar data engineering plugins (dbt, pyspark, etc.)

### Query 3: Get Patterns by Success Rate

```cypher
// Find high-quality patterns
MATCH (p:Pattern)
WHERE p.success_rate >= 0.9
RETURN p.pattern_id as id,
       p.name as name,
       p.success_rate as success_rate,
       p.executions as executions,
       p.status as status
ORDER BY p.success_rate DESC, p.executions DESC
```

### Query 4: Track Pattern Performance Trend

```cypher
// Get execution history for a pattern
MATCH (pat:Pattern {pattern_id: "create-etl-pipeline-for-v1"})<-[:IMPLEMENTS]-(exec:Execution)
RETURN exec.started_at as timestamp,
       exec.status as status,
       exec.duration_ms as duration,
       exec.task_description as task
ORDER BY exec.started_at DESC
```

### Query 5: Find Patterns Using Specific Plugin

```cypher
// Find all patterns that use fastapi-scaffolder
MATCH (pat:Pattern)-[u:USES]->(plugin:Plugin {name: "fastapi-scaffolder"})
RETURN pat.name as pattern,
       pat.success_rate as success_rate,
       u.step_number as step,
       u.purpose as purpose
ORDER BY pat.success_rate DESC
```

### Success Criteria

- ✅ Full-text search returns relevant patterns
- ✅ Similarity queries find alternative plugins
- ✅ Success rate filtering works
- ✅ Execution history tracks performance
- ✅ Plugin-to-pattern queries work

---

## Test 5: End-to-End Workflow Simulation

**Purpose:** Simulate complete workflow from discovery to recommendation

### Scenario: User wants to build another REST API

**Step 1: Query for existing API patterns**

```cypher
CALL db.index.fulltext.queryNodes("pattern_search", "rest api authentication")
YIELD node, score
RETURN node.pattern_id as id,
       node.name as name,
       node.success_rate as success_rate,
       node.executions as times_used,
       score as relevance
ORDER BY score DESC, node.success_rate DESC
LIMIT 3
```

**Expected:** Returns "build-rest-api-with-v1" pattern with high relevance

**Step 2: Get pattern details and plugin sequence**

```cypher
MATCH (pat:Pattern {pattern_id: "build-rest-api-with-v1"})-[u:USES]->(plugin:Plugin)
RETURN pat.name as pattern_name,
       pat.success_rate as success_rate,
       collect({
         step: u.step_number,
         plugin: plugin.name,
         purpose: u.purpose,
         plugin_success_rate: plugin.success_rate
       }) as workflow
```

**Expected:** Returns complete plugin sequence with success rates

**Step 3: Check if any plugins have known issues**

```cypher
MATCH (pat:Pattern {pattern_id: "build-rest-api-with-v1"})-[:USES]->(plugin:Plugin)
MATCH (plugin)-[:HAS_ISSUE]->(issue:Issue)
RETURN plugin.name as plugin,
       issue.error_pattern as error,
       issue.solution as fix,
       issue.frequency as times_seen
ORDER BY issue.frequency DESC
```

**Expected:** May return empty (good) or known issues with solutions

**Step 4: Find alternative plugins (if needed)**

```cypher
MATCH (original:Plugin {name: "fastapi-scaffolder"})-[s:SIMILAR_TO]-(alt:Plugin)
WHERE s.similarity_score >= 0.6
  AND alt.success_rate >= original.success_rate
RETURN alt.name as alternative,
       alt.description as description,
       s.similarity_score as similarity,
       alt.success_rate as success_rate
ORDER BY s.similarity_score DESC
LIMIT 3
```

**Expected:** Returns similar API framework plugins

**Step 5: Execute workflow and record new pattern**

```bash
# Create a slightly different workflow
cat > /tmp/variant_workflow.json <<EOF
{
  "task_description": "build api with oauth2 and postgresql",
  "success": true,
  "execution_time": 9.2,
  "steps": [
    {"plugin": "fastapi-scaffolder", "purpose": "Create API", "success": true, "execution_time": 2.0},
    {"plugin": "oauth2-integration", "purpose": "Add OAuth2", "success": true, "execution_time": 4.0},
    {"plugin": "postgresql-schema-generator", "purpose": "Add database", "success": true, "execution_time": 3.2}
  ]
}
EOF

# Store with Neo4j sync
python pattern_storage.py \
  --workflow-result /tmp/variant_workflow.json \
  --enable-neo4j
```

**Step 6: Verify pattern library grew**

```cypher
// Count patterns (should be 5 now)
MATCH (p:Pattern)
RETURN count(p) as total_patterns

// View newest pattern
MATCH (p:Pattern)
RETURN p.pattern_id, p.name, p.created
ORDER BY p.created DESC
LIMIT 1
```

### Success Criteria

- ✅ Pattern search returns relevant results
- ✅ Workflow details retrieved correctly
- ✅ Alternative plugins suggested when needed
- ✅ New variant pattern stored successfully
- ✅ Pattern library grows organically

---

## Cleanup (Optional)

**Reset Neo4j database:**

```cypher
// WARNING: Deletes all data!
MATCH (n) DETACH DELETE n
```

**Remove test patterns from filesystem:**

```bash
rm ~/.claude/skills/meta-orchestrator/patterns/discovered/build-rest-api-with-v1.yaml
rm ~/.claude/skills/meta-orchestrator/patterns/discovered/create-etl-pipeline-for-v1.yaml
```

**Remove test files:**

```bash
rm /tmp/plugins_test.json
rm /tmp/variant_workflow.json
```

---

## Troubleshooting

### Test 2 Fails: "Unable to connect to Neo4j"

**Check:**
```bash
podman ps | grep neo4j
```

**If not running:**
```bash
podman start neo4j
sleep 10  # Wait for Neo4j to fully start
python migrate_to_neo4j.py
```

### Test 3 Fails: "Neo4j sync failed"

**This is non-fatal** - pattern still saves to filesystem

**Check:**
```bash
echo $NEO4J_PASSWORD  # Should output your password
```

**If empty:**
```bash
export NEO4J_PASSWORD="your-password"
```

### Query Results Empty

**Check database selected:**
- In Neo4j Browser, ensure "neo4j" database is selected (top-left dropdown)
- NOT "system" database

**Verify data exists:**
```cypher
MATCH (n) RETURN count(n)
// Should return 62+ (60 plugins + 2+ patterns)
```

---

## Test Summary Report

After running all tests, you should have:

**Neo4j Database:**
- ✅ 60 Plugin nodes
- ✅ 4-5 Pattern nodes (2 migrated + 2-3 from tests)
- ✅ 178+ SIMILAR_TO relationships
- ✅ 12+ USES relationships
- ✅ 2-3 Execution nodes

**Filesystem:**
- ✅ 2-3 new pattern files in discovered/
- ✅ Execution logs in metrics/
- ✅ Success rate logs in metrics/

**Verified Capabilities:**
- ✅ Plugin scanning works
- ✅ Bulk migration succeeds
- ✅ Dual-write functions correctly
- ✅ Pattern queries return results
- ✅ Similarity recommendations work
- ✅ End-to-end workflow completes

---

## Next Steps After Testing

1. **Run migration on production data** (if this was just testing)
2. **Enable Neo4j dual-write** in all future workflows
3. **Query Neo4j** for pattern recommendations
4. **Monitor pattern library growth** over time
5. **Leverage similarity graph** for plugin fallbacks

---

**Time to complete all tests:** ~20 minutes
**Difficulty:** Intermediate (requires Neo4j knowledge)
**Support:** See README.md and NEO4J_QUICK_START.md
