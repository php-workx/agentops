# Automation Scripts

Automation scripts for meta-orchestration workflow with Neo4j graph database integration.

## Available Scripts

### Neo4j Integration Scripts (NEW)

#### plugin_scanner.py

Scans 400+ plugins from 3 marketplaces and extracts metadata for Neo4j bulk loading.

**Usage:**
```bash
python plugin_scanner.py [--output FILE] [--format json|yaml]
```

**What it does:**
- Scans claude-code-templates (NPM) - ~120 plugins
- Scans wshobson/agents (GitHub) - ~180 plugins
- Scans jeremylongshore/claude-code-plugins-plus (GitHub) - ~120 plugins
- Extracts: name, description, category, tags, marketplace, version, success_rate
- Exports to JSON or YAML format
- Provides scan summary statistics

**Examples:**
```bash
# Scan all marketplaces and export to JSON (default)
python plugin_scanner.py

# Export to YAML
python plugin_scanner.py --format yaml --output plugins.yaml

# Output includes ~60 representative plugins covering all categories
```

**Output:**
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
```

---

#### neo4j_connector.py

Python library providing Neo4j connection and graph operations for plugins and patterns.

**Usage:**
```python
from neo4j_connector import Neo4jConnector

# Connect to Neo4j
with Neo4jConnector() as neo4j:
    # Create plugin
    neo4j.create_plugin(plugin_data)

    # Bulk load plugins
    neo4j.bulk_create_plugins(plugins)

    # Compute similarities
    neo4j.compute_plugin_similarities(min_similarity=0.3)

    # Create pattern
    neo4j.create_pattern(pattern_data)

    # Query patterns
    patterns = neo4j.search_patterns("api auth")
```

**Environment Variables:**
```bash
export NEO4J_URI="bolt://localhost:7687"  # Default
export NEO4J_USER="neo4j"                 # Default
export NEO4J_PASSWORD="your-password"     # REQUIRED
```

**Dependencies:**
```bash
pip install neo4j
```

**Key Methods:**
- `setup_schema()` - Create constraints and indexes
- `create_plugin(data)` - Create single plugin node
- `bulk_create_plugins(plugins)` - Bulk insert plugins
- `compute_plugin_similarities(min_sim)` - Create SIMILAR_TO relationships
- `create_pattern(data)` - Create pattern node
- `link_pattern_to_plugins(id, sequence)` - Create USES relationships
- `create_execution(data)` - Log workflow execution
- `search_patterns(query, limit)` - Find patterns by keywords
- `find_similar_plugins(name, min_sim, limit)` - Find similar plugins
- `get_stats()` - Get database statistics

---

#### migrate_to_neo4j.py

One-time bulk migration script to populate Neo4j with all plugins and existing patterns.

**Usage:**
```bash
# Set Neo4j password
export NEO4J_PASSWORD="your-password"

# Run migration
python migrate_to_neo4j.py [--min-similarity 0.3]
```

**What it does:**
1. **Schema Setup** - Creates constraints, indexes, full-text search
2. **Plugin Scan & Load** - Scans 400+ plugins and bulk inserts to Neo4j
3. **Similarity Computation** - Computes ~40,000 SIMILAR_TO relationships
4. **Pattern Migration** - Loads existing patterns from filesystem
5. **Pattern Linking** - Creates USES relationships to plugins
6. **Statistics** - Shows final database metrics

**Example:**
```bash
# Run full migration
export NEO4J_PASSWORD="your-password"
python migrate_to_neo4j.py

# Output:
======================================================================
NEO4J BULK MIGRATION
======================================================================

======================================================================
STEP 1: Schema Setup
======================================================================
✓ Connected to Neo4j at bolt://localhost:7687
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

Next steps:
1. Verify data: Open Neo4j Browser at http://localhost:7474
2. Run sample queries:
   - MATCH (p:Plugin) RETURN p LIMIT 25
   - MATCH (pat:Pattern) RETURN pat
   - MATCH (p1:Plugin)-[s:SIMILAR_TO]->(p2:Plugin) RETURN p1, s, p2 LIMIT 10
3. Test pattern recommendations
```

**Prerequisites:**
- Neo4j container running (see Neo4j Setup below)
- Python 3.7+
- neo4j-driver (`pip install neo4j`)
- PyYAML (`pip install pyyaml`)

---

### Original Scripts (Updated with Neo4j Support)

### pattern_storage.py

Automates pattern extraction, storage, and lifecycle management. Now supports dual-write to filesystem + Neo4j.

**Usage:**
```bash
# Filesystem only (original behavior)
python pattern_storage.py --workflow-result workflow_result.json

# Filesystem + Neo4j dual-write
export NEO4J_PASSWORD="your-password"
python pattern_storage.py --workflow-result workflow_result.json --enable-neo4j
```

**What it does:**
- Extracts pattern from workflow execution result
- Saves pattern to appropriate lifecycle stage (discovered/validated/learned)
- Logs execution metrics
- Updates success rates
- Updates pattern index
- Handles pattern lifecycle transitions

**Example:**
```bash
# After workflow completes, save the result as JSON
echo '{"task_description": "Build REST API with auth", "success": true, ...}' > result.json

# Run pattern storage
python pattern_storage.py --workflow-result result.json

# Pattern automatically saved to:
# ~/.claude/skills/meta-orchestrator/patterns/discovered/build-rest-api-with-auth-v1.yaml
```

---

### pattern_matcher.py

Matches user requests to existing patterns in the pattern library.

**Usage:**
```bash
python pattern_matcher.py "User request here"
```

**What it does:**
- Extracts keywords from user request
- Searches pattern library for matches
- Ranks patterns by keyword match, success rate, usage, recency
- Displays top matches with details
- Provides confidence scores and recommendations

**Examples:**
```bash
# Find patterns for API development
python pattern_matcher.py "build api with authentication"

# Get top recommendation
python pattern_matcher.py "deploy containers to kubernetes" --recommend

# Show more matches
python pattern_matcher.py "data pipeline" --top-k 5
```

**Output:**
```
✅ Found 3 matching pattern(s):

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Match 1: REST API with JWT Authentication and Redis Caching
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern ID: rest-api-jwt-redis-v1
Match Score: 0.872 (0.0-1.0)
Stage: learned
Domain: web-development

Metrics:
  Success Rate: 91.7%
  Total Executions: 48
  Avg Completion Time: 11.5 minutes

Plugin Sequence (5 steps):
  1. fastapi-scaffolder - Create API structure
  2. jwt-auth-plugin - Add JWT authentication
  3. redis-cache-plugin - Setup caching layer
  4. rate-limiter-plugin - Add rate limiting
  5. api-tester - Validate functionality
```

---

### install_marketplaces.sh

Installs all Claude Code plugin marketplaces.

**Usage:**
```bash
bash install_marketplaces.sh
```

**What it does:**
- Installs NPM registry (claude-code-templates) - ~120 plugins
- Installs GitHub marketplace (wshobson/agents) - ~180 plugins
- Installs Claude Code Marketplace Plus (jeremylongshore/claude-code-plugins-plus) - ~120 plugins
- Checks prerequisites (npm, claude CLI)
- Provides installation summary
- Total: ~420 plugins

**Prerequisites:**
- Node.js and npm installed
- Claude CLI installed (optional, but recommended)

**Example:**
```bash
# Run installation
bash install_marketplaces.sh

# Output:
🚀 Installing Claude Code Plugin Marketplaces...

✓ npm is installed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Installing Marketplace 1/3: NPM Registry
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Installing claude-code-templates from NPM...
✓ NPM Registry installed successfully (~120 plugins)

... (continues for all marketplaces)

✓ Marketplace installation complete!
Total plugins available: 420
```

---

## Script Dependencies

**pattern_storage.py:**
- Python 3.7+
- PyYAML (`pip install pyyaml`)
- Standard library: json, pathlib, datetime, argparse

**pattern_matcher.py:**
- Python 3.7+
- PyYAML (`pip install pyyaml`)
- Standard library: pathlib, datetime, argparse, re

**install_marketplaces.sh:**
- Bash
- npm (Node Package Manager)
- Claude CLI (optional, for GitHub marketplaces)

## Installation

**Make scripts executable:**
```bash
chmod +x pattern_storage.py
chmod +x pattern_matcher.py
chmod +x install_marketplaces.sh
```

**Install Python dependencies:**
```bash
pip install pyyaml
```

## Workflow Integration

**Typical workflow:**

1. **Setup:** Install marketplaces
   ```bash
   bash install_marketplaces.sh
   ```

2. **Execution:** Run meta-orchestration workflow
   - Skill analyzes plugins
   - Generates workflow
   - Executes with validation
   - Saves result to JSON

3. **Learning:** Store pattern
   ```bash
   python pattern_storage.py --workflow-result result.json
   ```

4. **Future use:** Match patterns
   ```bash
   python pattern_matcher.py "similar request"
   ```

## Directory Structure

Scripts expect this directory structure:

```
~/.claude/skills/meta-orchestrator/
├── patterns/
│   ├── discovered/   # 1-4 executions
│   ├── validated/    # 5-19 executions, 80%+ success
│   ├── learned/      # 20+ executions, 90%+ success
│   ├── deprecated/   # <60% success rate
│   └── README.md     # Pattern index
└── metrics/
    ├── executions.log      # All executions
    └── success_rates.log   # Success rate history
```

Scripts will create this structure automatically if it doesn't exist.

## Neo4j Setup

**Step 1: Start Neo4j Container**

Using Podman (recommended):
```bash
# Check if Neo4j container exists
podman ps -a | grep neo4j

# If running, skip to Step 2
# If not running, start existing container
podman start neo4j

# If doesn't exist, create new container
podman run -d \
  --name neo4j \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/your-password \
  neo4j:latest
```

Using Docker:
```bash
docker run -d \
  --name neo4j \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/your-password \
  neo4j:latest
```

**Step 2: Verify Neo4j is Running**
```bash
# Check container status
podman ps | grep neo4j

# Test connection (should return Neo4j Browser page)
curl http://localhost:7474
```

**Step 3: Set Environment Variable**
```bash
# Set password (replace with your password)
export NEO4J_PASSWORD="your-password"

# Add to shell profile for persistence (optional)
echo 'export NEO4J_PASSWORD="your-password"' >> ~/.bashrc
```

**Step 4: Run Initial Migration**
```bash
# Navigate to scripts directory
cd /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts

# Run migration
python migrate_to_neo4j.py
```

**Step 5: Verify Data in Neo4j Browser**
1. Open http://localhost:7474 in browser
2. Login with username `neo4j` and password you set
3. Run queries to verify data:
   ```cypher
   // Count plugins
   MATCH (p:Plugin) RETURN count(p)

   // Count patterns
   MATCH (pat:Pattern) RETURN count(pat)

   // View sample plugins
   MATCH (p:Plugin) RETURN p LIMIT 25

   // View pattern connections
   MATCH (pat:Pattern)-[u:USES]->(p:Plugin) RETURN pat, u, p

   // View plugin similarities
   MATCH (p1:Plugin)-[s:SIMILAR_TO]-(p2:Plugin)
   RETURN p1.name, s.similarity_score, p2.name
   LIMIT 20
   ```

**Common Neo4j Commands:**
```bash
# Stop Neo4j
podman stop neo4j

# Start Neo4j
podman start neo4j

# View Neo4j logs
podman logs neo4j

# Remove Neo4j container (data will be lost)
podman rm -f neo4j
```

## Troubleshooting

**Pattern storage fails:**
```bash
# Check if directory exists
ls -la ~/.claude/skills/meta-orchestrator/patterns/

# Create manually if needed
mkdir -p ~/.claude/skills/meta-orchestrator/patterns/{discovered,validated,learned,deprecated}
mkdir -p ~/.claude/skills/meta-orchestrator/metrics
```

**Pattern matcher finds no patterns:**
```bash
# Check if any patterns exist
find ~/.claude/skills/meta-orchestrator/patterns -name "*.yaml"

# If empty, run some workflows to create patterns first
```

**Marketplace installation fails:**
```bash
# Check npm is installed
npm --version

# Check claude CLI is installed
claude --version

# Install manually if script fails
npm install -g claude-code-templates
```

**Neo4j connection fails:**
```bash
# Check if Neo4j is running
podman ps | grep neo4j

# If not running, start it
podman start neo4j

# Check if Neo4j is accessible
curl http://localhost:7474

# Check environment variable is set
echo $NEO4J_PASSWORD

# View Neo4j logs for errors
podman logs neo4j --tail 50
```

**Neo4j migration fails:**
```bash
# Install Neo4j driver
pip install neo4j

# Verify PyYAML is installed
pip install pyyaml

# Check Python version (requires 3.7+)
python --version

# Run with explicit connection details
python migrate_to_neo4j.py \
  --neo4j-uri bolt://localhost:7687 \
  --neo4j-user neo4j \
  --neo4j-password your-password
```

**Pattern dual-write fails:**
```bash
# Test filesystem-only mode first
python pattern_storage.py --workflow-result result.json

# Then test Neo4j mode
python pattern_storage.py --workflow-result result.json --enable-neo4j

# Check error messages for specific failure point
# Neo4j failures are non-fatal - pattern still saves to filesystem
```

## Contributing

To add new scripts:

1. Create script in `scripts/` directory
2. Make it executable: `chmod +x script_name.py`
3. Add documentation to this README
4. Follow existing script patterns:
   - Use argparse for CLI
   - Provide clear error messages
   - Include usage examples
   - Handle edge cases gracefully

## Support

For issues with scripts:

1. Check prerequisites are installed
2. Verify directory structure exists
3. Review error messages carefully
4. Check script permissions (`chmod +x`)
5. Test with minimal examples first
