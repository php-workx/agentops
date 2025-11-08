---
description: Browse and search the pattern library
---

# /browse-patterns - Pattern Discovery Command

**Purpose:** Search and filter orchestration patterns using intelligent graph queries

**When to use:**
- Explore available patterns before orchestrating
- Find patterns by category, success rate, or keywords
- Discover what workflows exist for your domain
- Learn from proven patterns

**Token budget:** 5-10k tokens (lightweight query)

**Output:** List of matching patterns with metrics

---

## Basic Usage

```bash
/browse-patterns [optional: search query or filters]
```

**Examples:**

```bash
# List all patterns
/browse-patterns

# Search by keywords
/browse-patterns "REST API authentication"

# Filter by category
/browse-patterns --category api-development

# Filter by success rate
/browse-patterns --min-success 0.9

# Filter by status
/browse-patterns --status learned

# Combine filters
/browse-patterns --category api-development --min-success 0.85 --status validated
```

---

## How It Works

### With Neo4j (Primary)

**Query graph database for patterns:**
```cypher
// Full-text search for keywords
CALL db.index.fulltext.queryNodes("pattern_search", $query)
YIELD node, score
WHERE node.category = $category
  AND node.success_rate >= $min_success
  AND node.status = $status
RETURN node, score
ORDER BY score DESC, node.executions DESC
LIMIT $limit
```

### Without Neo4j (Fallback)

If Neo4j unavailable, falls back to file-based search:

```bash
# Scan pattern directories
find patterns/ -name "*.yaml" -o -name "*.md"

# Parse YAML frontmatter and filter
grep "category:" | grep "api-development"
```

---

## Command Options

```bash
# Basic search
/browse-patterns "keywords"

# Category filter
/browse-patterns --category <category>
# Options: api-development, web-development, devops, security, data-engineering

# Success rate filter
/browse-patterns --min-success <0.0-1.0>

# Status filter
/browse-patterns --status <status>
# Options: discovered, validated, learned

# Limit results
/browse-patterns --limit <number>

# Sort options
/browse-patterns --sort success_rate
/browse-patterns --sort executions
/browse-patterns --sort recent
```

---

## Output Format

```
Pattern Library: 87 total patterns

Results: 3 patterns

1. ⭐ REST API with JWT + Redis [validated]
   Success: 92% | Uses: 48 | Avg: 11.5min | Pattern ID: rest-api-jwt-redis-v1

2. GraphQL API with OAuth2 [validated]
   Success: 85% | Uses: 23 | Avg: 15min | Pattern ID: graphql-oauth-v1

3. ⭐ REST API with Basic Auth [learned]
   Success: 94% | Uses: 67 | Avg: 8min | Pattern ID: rest-api-basic-v2

⭐ = Highly recommended (learned status or >90% success)
```

---

## Related Commands

- **/inspect-pattern** - Deep dive into specific pattern
- **/orchestrate** - Execute a pattern
- **/replay-pattern** - Re-execute known pattern

---

**Version:** 0.1.0
**Last Updated:** November 8, 2025
