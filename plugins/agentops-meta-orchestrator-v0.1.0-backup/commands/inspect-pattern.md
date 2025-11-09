---
description: Inspect detailed pattern information
---

# /inspect-pattern - Pattern Deep Dive Command

**Purpose:** View comprehensive details about a specific orchestration pattern

**When to use:**
- Understand how a pattern works before using it
- Learn from successful patterns
- Review failure modes and solutions
- See execution history and metrics

**Token budget:** 5-10k tokens (single pattern query)

**Output:** Complete pattern specification with history

---

## Basic Usage

```bash
/inspect-pattern <pattern_id>
```

**Examples:**

```bash
# Inspect by pattern ID
/inspect-pattern rest-api-jwt-redis-v1

# Inspect with execution history
/inspect-pattern rest-api-jwt-redis-v1 --show-history

# Inspect with plugin details
/inspect-pattern rest-api-jwt-redis-v1 --show-plugins
```

---

## How It Works

### With Neo4j (Primary)

**Load pattern and related data:**
```cypher
// Get pattern node
MATCH (p:Pattern {pattern_id: $pattern_id})
RETURN p

// Get workflow plugins
MATCH (pat:Pattern {pattern_id: $pattern_id})-[u:USES]->(plugin:Plugin)
RETURN plugin, u.step_number, u.required
ORDER BY u.step_number

// Load execution history
MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
RETURN exec
ORDER BY exec.completed_at DESC
LIMIT 10

// Get known issues
MATCH (pat:Pattern {pattern_id: $pattern_id})-[:USES]->(p:Plugin)-[:HAS_ISSUE]->(issue:Issue)
RETURN p.name AS plugin, issue.error_pattern, issue.solution
ORDER BY issue.frequency DESC
```

---

## Output Format

```markdown
# Pattern Inspection: REST API with JWT + Redis

## Overview

**Pattern ID:** rest-api-jwt-redis-v1
**Name:** REST API with JWT Authentication and Redis Caching
**Status:** ⭐ validated (proven reliability)
**Category:** api-development
**Created:** 2025-09-12
**Last Used:** 2025-11-07 (2 hours ago)

## Metrics

- **Success Rate:** 92% (44/48 executions)
- **Avg Duration:** 11.5 minutes
- **Total Uses:** 48 times
- **Trend:** ↗ Improving (last 10: 95% success)

## Workflow Steps

### Step 1: Create API Structure
**Plugin:** fastapi-scaffolder
**Duration:** ~2 min | Success: 98%

### Step 2: Add JWT Authentication
**Plugin:** jwt-auth-plugin
**Duration:** ~3 min | Success: 89%
**Known Issues:**
  - ModuleNotFoundError: python-jose (auto-fixable)

[... continues for all steps ...]

## Execution History

| Date | Status | Duration | Issues |
|------|--------|----------|--------|
| 2025-11-07 18:15 | ✅ Success | 11.2 min | None |
| 2025-11-07 14:30 | ✅ Success | 12.1 min | None |
| 2025-11-06 16:45 | ⚠️ Partial | 14.5 min | Redis (fixed) |

## When to Use This Pattern

**Best for:**
- Building REST APIs with FastAPI
- Need JWT authentication
- Want caching for performance
- Production-ready requirements

**Avoid if:**
- You need OAuth2 (use rest-api-oauth-redis-v1)
- Redis unavailable (use rest-api-jwt-postgres-v1)
```

---

## Related Commands

- **/browse-patterns** - Find patterns
- **/replay-pattern** - Execute this pattern
- **/orchestrate** - Full workflow with this pattern

---

**Version:** 0.1.0
**Last Updated:** November 8, 2025
