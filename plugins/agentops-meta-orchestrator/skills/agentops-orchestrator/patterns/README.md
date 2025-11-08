# Pattern Library

## Overview

This directory contains **learned orchestration patterns** discovered through successful multi-plugin workflow executions. Patterns represent proven sequences of plugins that solve specific tasks with high reliability.

## Directory Structure

### discovered/
**New patterns identified during executions**
- 0-5 successful executions
- No established success rate yet
- Require validation through repeated use
- Example: `2025-11-07-simple-rest-api-health-check.md`

### validated/
**Patterns with proven track record**
- 5-20 successful executions
- Success rate: 80-95%
- Recommended for production use
- Example: `full-stack-app-pattern.md`

### learned/
**Highly reliable, production-ready patterns**
- 20+ successful executions
- Success rate: >90%
- Highest confidence level
- Example: `security-audit-parallel.md`

## Pattern Lifecycle

```
Research → discovered/ → validated/ → learned/
           (found)        (proven)      (mastered)
           1-5 runs      5-20 runs     20+ runs
           Testing       Reliable      Production
```

## Pattern Promotion Rules

Patterns automatically promote based on metrics:

```python
if executions >= 20 and success_rate >= 0.90:
    move_to("learned/")
elif executions >= 5 and success_rate >= 0.80:
    move_to("validated/")
elif executions >= 1:
    stays_in("discovered/")
```

## Pattern Format

Each pattern file includes:

1. **Metadata** (YAML frontmatter)
   - pattern_id, created date, category
   - success_rate, executions, last_used
   - validated status

2. **Context**
   - What problem does this solve?
   - When should you use it?

3. **Workflow Sequence**
   - Step-by-step plugin execution
   - Inputs, outputs, validation
   - Duration and success metrics

4. **Technology Stack**
   - Languages, frameworks, tools

5. **Success Factors**
   - What makes this pattern work?

6. **Failure Modes**
   - Common errors and solutions

7. **Learnings**
   - What worked well
   - What to improve

## Using Patterns

### Discover Relevant Patterns

```bash
# Search by category
/discover-patterns --category api-development

# Search by success rate
/discover-patterns --success-rate ">0.9"

# Search by keywords
/discover-patterns "REST API authentication"
```

### Apply a Pattern

```bash
# Let orchestrator choose best pattern
/orchestrate "Create REST API with health check"

# Use specific pattern
/orchestrate --pattern-id pat_2025-11-07_simple_rest_api_health "Create API"
```

### Manual Pattern Application

```bash
# Review pattern file
cat patterns/validated/full-stack-app-pattern.md

# Follow step-by-step instructions
# Execute each plugin manually if needed
```

## Pattern Statistics

**Current Library Status:**
- **Discovered:** 1 pattern
- **Validated:** 0 patterns
- **Learned:** 0 patterns
- **Total:** 1 pattern

**Coverage:**
- API Development: 1
- Full-Stack Development: 0
- DevOps: 0
- Security: 0
- Data Engineering: 0

## Contributing Patterns

Patterns are automatically discovered and recorded by the meta-orchestrator during workflow executions. To contribute:

1. Execute workflows via `/orchestrate`
2. Meta-orchestrator records successful patterns
3. Patterns promote automatically based on metrics
4. Community benefits from shared learnings

## Pattern Validation

Each pattern undergoes continuous validation:

- **Execution tracking** - Success/failure recorded
- **Metric analysis** - Duration, reliability measured
- **Failure investigation** - Errors analyzed and documented
- **Improvement cycle** - Patterns refined based on data

## Related Documentation

- [Marketplace Sources](../references/marketplace-sources.md) - Plugin discovery
- [Pattern Template](../references/pattern-library-template.md) - Pattern format
- [Meta-Orchestrator Skill](../SKILL.md) - How patterns are learned

---

**Version:** 0.1.0
**Last Updated:** November 7, 2025
**Status:** Active pattern library
**Next Review:** After 10 patterns discovered
