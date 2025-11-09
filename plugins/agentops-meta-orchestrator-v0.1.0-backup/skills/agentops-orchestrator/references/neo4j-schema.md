# Neo4j Schema for Meta-Orchestrator

## Overview

The meta-orchestrator uses Neo4j to store plugin capabilities, discovered patterns, execution history, and learned relationships. This enables intelligent recommendations, similarity scoring, and failure learning.

## Node Types

### Plugin
**Purpose:** Represents a Claude Code plugin from any marketplace

**Properties:**
- `name` (String, unique, required) - Plugin identifier
- `description` (String) - What the plugin does
- `category` (String, indexed) - Domain (web-dev, devops, data-eng, security)
- `marketplace` (String) - Source marketplace
- `version` (String) - Plugin version
- `success_rate` (Float, indexed) - Historical success rate (0.0-1.0)
- `total_uses` (Integer) - Times plugin executed
- `last_used` (DateTime) - Last execution timestamp
- `tags` (Array<String>) - Keywords for search

**Example:**
```cypher
CREATE (:Plugin {
  name: "jwt-auth-plugin",
  description: "Add JWT authentication to FastAPI apps",
  category: "security",
  marketplace: "claude-code-templates",
  version: "1.2.0",
  success_rate: 0.89,
  total_uses: 1247,
  last_used: datetime("2025-11-07T18:00:00Z"),
  tags: ["jwt", "auth", "security", "fastapi"]
})
```

### Pattern
**Purpose:** Represents a discovered orchestration pattern

**Properties:**
- `pattern_id` (String, unique, required) - Unique identifier
- `name` (String, required) - Human-readable name
- `description` (String) - What problem this solves
- `category` (String, indexed) - Task category
- `success_rate` (Float, indexed) - Pattern success rate (0.0-1.0)
- `executions` (Integer) - Times pattern executed
- `status` (String, indexed) - discovered|validated|learned
- `workflow_steps` (JSON) - Serialized step-by-step workflow
- `created_at` (DateTime) - Discovery date
- `last_used` (DateTime) - Last execution

**Example:**
```cypher
CREATE (:Pattern {
  pattern_id: "rest-api-jwt-redis-v1",
  name: "REST API with JWT + Redis",
  description: "FastAPI REST API with JWT auth and Redis caching",
  category: "api-development",
  success_rate: 0.92,
  executions: 48,
  status: "validated",
  workflow_steps: '["fastapi-scaffolder", "jwt-auth-plugin", "redis-cache-plugin"]',
  created_at: datetime("2025-09-12T10:00:00Z"),
  last_used: datetime("2025-11-07T18:00:00Z")
})
```

### Execution
**Purpose:** Tracks individual workflow executions

**Properties:**
- `execution_id` (String, unique, required) - Execution UUID
- `task_description` (String) - User's original request
- `status` (String) - success|failed|partial
- `duration_ms` (Integer) - Total execution time
- `started_at` (DateTime)
- `completed_at` (DateTime)
- `error_message` (String) - If failed

### Issue
**Purpose:** Known failure modes and solutions

**Properties:**
- `issue_id` (String, unique) - Issue identifier
- `plugin_name` (String) - Affected plugin
- `error_pattern` (String) - Error message regex
- `solution` (String) - How to fix
- `frequency` (Integer) - Times encountered
- `last_seen` (DateTime)

**Example:**
```cypher
CREATE (:Issue {
  issue_id: "jwt-missing-dependency",
  plugin_name: "jwt-auth-plugin",
  error_pattern: "ModuleNotFoundError.*python-jose",
  solution: "pip install python-jose",
  frequency: 45,
  last_seen: datetime("2025-11-07T18:00:00Z")
})
```

## Relationship Types

### USES
**From:** Pattern → Plugin
**Purpose:** Pattern includes this plugin in workflow

**Properties:**
- `step_number` (Integer) - Position in sequence (1-based)
- `required` (Boolean) - Is this plugin essential?

**Example:**
```cypher
MATCH (pat:Pattern {pattern_id: "rest-api-jwt-redis-v1"})
MATCH (plugin:Plugin {name: "jwt-auth-plugin"})
CREATE (pat)-[:USES {step_number: 2, required: true}]->(plugin)
```

### SIMILAR_TO
**From:** Plugin → Plugin
**Purpose:** Plugins with similar capabilities

**Properties:**
- `similarity_score` (Float) - Jaccard similarity (0.0-1.0)
- `shared_tags` (Array<String>) - Common tags
- `computed_at` (DateTime)

**Example:**
```cypher
MATCH (p1:Plugin {name: "jwt-auth-plugin"})
MATCH (p2:Plugin {name: "oauth2-integration"})
CREATE (p1)-[:SIMILAR_TO {
  similarity_score: 0.82,
  shared_tags: ["auth", "security"],
  computed_at: datetime()
}]->(p2)
```

### EXECUTED_IN
**From:** Plugin → Execution
**Purpose:** Track plugin usage in executions

**Properties:**
- `step` (Integer) - Step number in workflow
- `duration_ms` (Integer) - Time to execute
- `status` (String) - success|failed

### IMPLEMENTS
**From:** Execution → Pattern
**Purpose:** Execution used this pattern

### HAS_ISSUE
**From:** Plugin → Issue
**Purpose:** Plugin has known failure mode

### RESOLVED_BY
**From:** Issue → Plugin
**Purpose:** Alternative plugin that works around issue

## Indexes & Constraints

### Uniqueness Constraints
```cypher
CREATE CONSTRAINT plugin_name_unique
FOR (p:Plugin) REQUIRE p.name IS UNIQUE;

CREATE CONSTRAINT pattern_id_unique
FOR (p:Pattern) REQUIRE p.pattern_id IS UNIQUE;

CREATE CONSTRAINT execution_id_unique
FOR (e:Execution) REQUIRE e.execution_id IS UNIQUE;
```

### Property Indexes
```cypher
CREATE INDEX plugin_category FOR (p:Plugin) ON (p.category);
CREATE INDEX plugin_success_rate FOR (p:Plugin) ON (p.success_rate);

CREATE INDEX pattern_category FOR (p:Pattern) ON (p.category);
CREATE INDEX pattern_success_rate FOR (p:Pattern) ON (p.success_rate);
CREATE INDEX pattern_status FOR (p:Pattern) ON (p.status);
```

### Full-Text Search
```cypher
CREATE FULLTEXT INDEX plugin_search
FOR (p:Plugin) ON EACH [p.name, p.description, p.tags];

CREATE FULLTEXT INDEX pattern_search
FOR (p:Pattern) ON EACH [p.name, p.description];
```

## Common Queries

### 1. Find plugins by capability
```cypher
MATCH (p:Plugin)
WHERE p.category = $category
  AND p.success_rate >= $min_success
RETURN p
ORDER BY p.success_rate DESC, p.total_uses DESC
LIMIT $limit
```

### 2. Get best pattern for task
```cypher
// Full-text search for relevant patterns
CALL db.index.fulltext.queryNodes("pattern_search", $query)
YIELD node, score
WHERE node.success_rate >= 0.8
RETURN node, score
ORDER BY score DESC, node.executions DESC
LIMIT 5
```

### 3. Find similar plugins (fallback)
```cypher
MATCH (p:Plugin {name: $plugin_name})-[s:SIMILAR_TO]->(similar:Plugin)
WHERE similar.success_rate >= $min_success
  AND s.similarity_score >= $min_similarity
RETURN similar, s.similarity_score
ORDER BY s.similarity_score DESC, similar.success_rate DESC
LIMIT 5
```

### 4. Get known issues for plugin
```cypher
MATCH (p:Plugin {name: $plugin_name})-[:HAS_ISSUE]->(issue:Issue)
RETURN issue.error_pattern, issue.solution, issue.frequency
ORDER BY issue.frequency DESC
```

### 5. Find alternative plugin for issue
```cypher
MATCH (issue:Issue {issue_id: $issue_id})-[:RESOLVED_BY]->(alt:Plugin)
WHERE alt.success_rate >= 0.8
RETURN alt
ORDER BY alt.success_rate DESC
LIMIT 3
```

### 6. Track pattern performance
```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
WHERE exec.completed_at >= datetime($since)
RETURN
  pat.pattern_id,
  COUNT(exec) AS total_executions,
  SUM(CASE WHEN exec.status = 'success' THEN 1 ELSE 0 END) AS successes,
  AVG(exec.duration_ms) AS avg_duration_ms
```

## Data Population Strategy

### Phase 1: Initial Seed
1. Scan all 3 plugin marketplaces
2. Create Plugin nodes with metadata
3. Extract tags and categorize

### Phase 2: Relationship Building
1. Compute similarity scores (Jaccard similarity on tags)
2. Create SIMILAR_TO relationships
3. Seed initial patterns from file-based library

### Phase 3: Continuous Learning
1. On every execution, create Execution node
2. Link to Pattern and Plugins via relationships
3. Update success_rate and executions counters
4. Detect new issues, create Issue nodes

## Schema Evolution

**Version:** 1.0.0
**Migration strategy:** Add new properties/relationships without breaking existing queries
**Backwards compatibility:** All queries should handle missing properties gracefully

---

**See also:**
- `SKILL.md` - How schema is used in workflow
- `commands/craft-prompt.md` - Example queries
- `commands/browse-patterns.md` - Pattern discovery queries
