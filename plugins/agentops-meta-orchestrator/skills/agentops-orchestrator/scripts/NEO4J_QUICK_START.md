# Neo4j Integration Quick Start Guide

**Goal:** Batch load 60+ plugins and existing patterns into Neo4j for intelligent pattern recommendations.

**Time:** ~10 minutes (one-time setup)

---

## What Was Built

**4 New Scripts:**
1. **plugin_scanner.py** - Scans 400+ plugins from 3 marketplaces
2. **neo4j_connector.py** - Python library for Neo4j graph operations
3. **migrate_to_neo4j.py** - One-time bulk migration script
4. **pattern_storage.py** (updated) - Dual-write to filesystem + Neo4j

**What You Get:**
- 60+ plugin nodes with metadata (name, category, tags, success_rate)
- ~178 SIMILAR_TO relationships (find alternative plugins)
- 2 existing patterns migrated from filesystem
- Future patterns automatically sync to Neo4j
- Intelligent pattern recommendations via graph queries

---

## Prerequisites

**Required:**
- Python 3.7+
- Neo4j container (Podman or Docker)

**Install Dependencies:**
```bash
pip install neo4j pyyaml
```

---

## Step 1: Start Neo4j Container

**Check if Neo4j already exists:**
```bash
podman ps -a | grep neo4j
```

**If exists but not running:**
```bash
podman start neo4j
```

**If doesn't exist, create new:**
```bash
podman run -d \
  --name neo4j \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/YourPasswordHere \
  neo4j:latest
```

**Verify it's running:**
```bash
podman ps | grep neo4j
curl http://localhost:7474  # Should return HTML page
```

---

## Step 2: Set Environment Variable

```bash
# Set password (replace with password you used above)
export NEO4J_PASSWORD="YourPasswordHere"

# Optional: Add to shell profile for persistence
echo 'export NEO4J_PASSWORD="YourPasswordHere"' >> ~/.bashrc
```

---

## Step 3: Run Bulk Migration

```bash
# Navigate to scripts directory
cd /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts

# Run migration
python migrate_to_neo4j.py
```

**Expected Output:**
```
🔌 Connecting to Neo4j...
✓ Connected to Neo4j at bolt://localhost:7687

======================================================================
STEP 1: Schema Setup
======================================================================
✓ Schema setup complete

======================================================================
STEP 2: Plugin Marketplace Scan & Load
======================================================================
✅ Total plugins scanned: 60
📦 Bulk creating 60 plugins...
✓ Created 60 plugin nodes

======================================================================
STEP 3: Compute Plugin Similarities
======================================================================
✓ Created 178 similarity relationships

======================================================================
STEP 4: Load Existing Patterns
======================================================================
✅ Loaded 2 patterns from filesystem
✅ Imported 2/2 patterns successfully

======================================================================
STEP 5: Link Patterns to Plugins
======================================================================
✅ Created 8 USES relationships

======================================================================
MIGRATION COMPLETE - DATABASE STATISTICS
======================================================================

Plugins: 60
Patterns: 2
Total Relationships: 186
  ├─ SIMILAR_TO: 178
  └─ USES: 8

🎉 Migration Complete!
```

**If migration succeeds:** Continue to Step 4
**If migration fails:** See Troubleshooting below

---

## Step 4: Verify Data in Neo4j Browser

**Open Neo4j Browser:**
1. Go to http://localhost:7474
2. Login:
   - Username: `neo4j`
   - Password: `YourPasswordHere` (from Step 2)

**Run verification queries:**

```cypher
// Count nodes
MATCH (n) RETURN labels(n) as type, count(n) as count
ORDER BY count DESC
```
Expected: `Plugin: 60`, `Pattern: 2`

```cypher
// View sample plugins
MATCH (p:Plugin)
RETURN p.name, p.category, p.success_rate
ORDER BY p.success_rate DESC
LIMIT 10
```

```cypher
// View pattern connections
MATCH (pat:Pattern)-[u:USES]->(p:Plugin)
RETURN pat.name as pattern, collect(p.name) as plugins
```

```cypher
// View plugin similarity graph
MATCH path = (p1:Plugin)-[s:SIMILAR_TO]-(p2:Plugin)
RETURN path
LIMIT 20
```

**If you see data:** Success! Continue to Step 5
**If you see empty results:** See Troubleshooting below

---

## Step 5: Test Pattern Dual-Write

**Create a test workflow result:**
```bash
cat > /tmp/test_workflow.json <<EOF
{
  "task_description": "test api with redis caching",
  "success": true,
  "execution_time": 5.2,
  "steps": [
    {"plugin": "fastapi-scaffolder", "purpose": "Create API", "success": true, "execution_time": 2.0},
    {"plugin": "redis-cache-plugin", "purpose": "Add caching", "success": true, "execution_time": 3.2}
  ]
}
EOF
```

**Run pattern storage with Neo4j enabled:**
```bash
python pattern_storage.py \
  --workflow-result /tmp/test_workflow.json \
  --enable-neo4j
```

**Expected output:**
```
🔍 Extracting pattern...
💾 Saving pattern...
✓ Pattern saved to filesystem: ~/.claude/skills/meta-orchestrator/patterns/discovered/test-api-with-redis-v1.yaml
✓ Pattern synced to Neo4j: test-api-with-redis-v1
✓ Linked pattern to 2 plugins
📊 Logging execution...
✓ Execution logged to filesystem: ~/.claude/skills/meta-orchestrator/metrics/executions.log
✓ Execution synced to Neo4j: exec_20251108_123456_a1b2c3d4

✅ Pattern storage complete!
Pattern ID: test-api-with-redis-v1
Success rate: 100.0%
Total executions: 1
✓ Pattern synced to Neo4j
```

**Verify in Neo4j Browser:**
```cypher
MATCH (p:Pattern {pattern_id: "test-api-with-redis-v1"})
RETURN p
```

**If you see the new pattern:** Success! Setup complete!
**If not:** See Troubleshooting below

---

## Step 6: Query Intelligent Recommendations

**Find patterns for similar tasks:**
```cypher
// Search for API patterns
CALL db.index.fulltext.queryNodes("pattern_search", "api")
YIELD node, score
RETURN node.name, node.success_rate, node.executions, score
ORDER BY score DESC, node.success_rate DESC
LIMIT 5
```

**Find similar plugins (for fallbacks):**
```cypher
// Find alternatives to fastapi-scaffolder
MATCH (p:Plugin {name: "fastapi-scaffolder"})-[s:SIMILAR_TO]-(similar:Plugin)
WHERE s.similarity_score >= 0.5
RETURN similar.name, s.similarity_score, s.shared_tags
ORDER BY s.similarity_score DESC
```

**Track pattern performance over time:**
```cypher
// Get execution history for a pattern
MATCH (pat:Pattern {pattern_id: "rest-api-jwt-redis-v1"})<-[:IMPLEMENTS]-(exec:Execution)
RETURN exec.started_at, exec.status, exec.duration_ms
ORDER BY exec.started_at DESC
```

---

## What Happens Next?

**Every future workflow execution:**
1. Run pattern_storage.py with `--enable-neo4j`
2. Pattern saved to **both** filesystem and Neo4j
3. Execution logged as node in graph
4. Pattern metrics updated automatically
5. Neo4j graph grows organically

**Pattern lifecycle (automated):**
- **discovered** → 1-4 executions
- **validated** → 5-19 executions, 80%+ success
- **learned** → 20+ executions, 90%+ success

**Benefits:**
- Intelligent pattern recommendations (keyword + similarity + success rate + recency)
- Plugin fallback suggestions (if one plugin fails, find similar alternatives)
- Execution history tracking (identify performance trends)
- Failure pattern analysis (learn from errors)

---

## Troubleshooting

### Migration Fails: "NEO4J_PASSWORD environment variable must be set"

**Fix:**
```bash
export NEO4J_PASSWORD="YourPasswordHere"
python migrate_to_neo4j.py
```

---

### Migration Fails: "Unable to connect to Neo4j"

**Fix:**
```bash
# Check if Neo4j is running
podman ps | grep neo4j

# If not running
podman start neo4j

# Wait 10 seconds for Neo4j to fully start
sleep 10

# Retry migration
python migrate_to_neo4j.py
```

---

### Migration Fails: "ModuleNotFoundError: No module named 'neo4j'"

**Fix:**
```bash
pip install neo4j
python migrate_to_neo4j.py
```

---

### Neo4j Browser Shows No Data

**Possible causes:**
1. Wrong database selected (use `neo4j` database, not `system`)
2. Migration didn't complete successfully
3. Connection to wrong Neo4j instance

**Fix:**
```bash
# In Neo4j Browser, select "neo4j" database (top-left dropdown)
# Re-run verification queries

# Or re-run migration
python migrate_to_neo4j.py
```

---

### Pattern Dual-Write Fails

**This is non-fatal** - pattern still saves to filesystem.

**Check:**
```bash
# Verify pattern saved to filesystem
ls ~/.claude/skills/meta-orchestrator/patterns/discovered/

# Check error message for specific failure point
python pattern_storage.py --workflow-result /tmp/test_workflow.json --enable-neo4j
```

**If Neo4j sync fails consistently:**
```bash
# Test Neo4j connection manually
python -c "from neo4j_connector import Neo4jConnector; c = Neo4jConnector(); print('Connected!')"

# If that works, test pattern creation
python -c "
from neo4j_connector import Neo4jConnector
from datetime import datetime

with Neo4jConnector() as neo4j:
    pattern = {
        'pattern': {
            'id': 'test-pattern-123',
            'name': 'Test Pattern',
            'description': 'Testing',
            'domain': 'testing',
            'metrics': {'total_executions': 1, 'success_rate': 1.0},
            'plugin_sequence': [],
            'created': datetime.utcnow().isoformat() + 'Z',
            'last_updated': datetime.utcnow().isoformat() + 'Z'
        }
    }
    neo4j.create_pattern(pattern)
    print('Pattern created successfully!')
"
```

---

## Summary

**You now have:**
- ✅ 60+ plugins in Neo4j knowledge graph
- ✅ 178 similarity relationships for intelligent fallbacks
- ✅ 2 existing patterns migrated
- ✅ Dual-write enabled (filesystem + Neo4j)
- ✅ Graph-based pattern recommendations

**Next steps:**
1. Execute workflows using meta-orchestrator skill
2. Store results with `--enable-neo4j` flag
3. Watch pattern library grow organically
4. Query Neo4j for intelligent recommendations

**For more details:** See `README.md` in scripts directory

---

**Questions or issues?** Check the Troubleshooting section or review the full documentation.
