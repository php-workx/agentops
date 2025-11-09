# Learning System Guide

Extract patterns from workflow executions and continuously improve recommendations.

## Pattern Extraction Process

After every workflow execution, extract reusable patterns.

### What to Record

```yaml
pattern:
  id: <unique-identifier>
  name: <human-readable-name>
  description: <what-this-pattern-solves>
  
  domain: <primary-domain>
  subdomain: <specific-subdomain>
  
  task_keywords:
    - <keyword-1>
    - <keyword-2>
    - <keyword-3>
  
  plugin_sequence:
    - plugin: <plugin-1>
      purpose: <what-it-does>
      avg_time: <minutes>
      success_rate: <percentage>
    - plugin: <plugin-2>
      purpose: <what-it-does>
      avg_time: <minutes>
      success_rate: <percentage>
  
  metrics:
    total_executions: <count>
    successful_executions: <count>
    failed_executions: <count>
    success_rate: <percentage>
    avg_completion_time: <minutes>
  
  known_issues:
    - issue: <description>
      frequency: <count>
      fix: <solution>
  
  environment_requirements:
    - <ENV_VAR>
    - <DEPENDENCY>
  
  tags: [<tag-1>, <tag-2>, <tag-3>]
  
  last_updated: <timestamp>
  created: <timestamp>
```

### Example Pattern

```yaml
pattern:
  id: rest-api-jwt-redis-v1
  name: "REST API with JWT Authentication and Redis Caching"
  description: "FastAPI-based REST API with JWT auth, Redis caching, rate limiting"
  
  domain: web-development
  subdomain: api-development
  
  task_keywords:
    - rest-api
    - api
    - jwt
    - authentication
    - auth
    - caching
    - redis
  
  plugin_sequence:
    - plugin: fastapi-scaffolder
      purpose: Create API structure
      avg_time: 2_min
      success_rate: 0.98
    
    - plugin: jwt-auth-plugin
      purpose: Add JWT authentication
      avg_time: 3_min
      success_rate: 0.89
    
    - plugin: redis-cache-plugin
      purpose: Setup caching layer
      avg_time: 3_min
      success_rate: 0.92
  
  metrics:
    total_executions: 48
    successful_executions: 44
    failed_executions: 4
    success_rate: 0.9167
    avg_completion_time: 11.5_min
  
  known_issues:
    - issue: "Redis connection refused"
      frequency: 3
      fix: "Start Redis server before running workflow"
    
    - issue: "Missing python-jose dependency"
      frequency: 2
      fix: "pip install python-jose"
  
  environment_requirements:
    - SECRET_KEY
    - REDIS_URL
    - DATABASE_URL
  
  tags:
    - api
    - web
    - authentication
    - caching
    - production-ready
  
  last_updated: 2025-11-07T18:15:00Z
  created: 2025-09-12T10:00:00Z
```

## Pattern Storage (CRITICAL)

**ALWAYS save patterns to filesystem after extraction:**

### Storage Structure

```
~/.claude/skills/meta-orchestrator/patterns/
├── discovered/        # 1-4 executions (unproven)
├── validated/         # 5-19 executions, 80%+ success
├── learned/           # 20+ executions, 90%+ success
├── README.md          # Pattern index
└── metrics/
    ├── executions.log      # All executions
    └── success_rates.log   # Success rate history
```

### Storage Workflow

**Step 1: Create directories (if not exist)**
```bash
mkdir -p ~/.claude/skills/meta-orchestrator/patterns/{discovered,validated,learned}
mkdir -p ~/.claude/skills/meta-orchestrator/metrics
```

**Step 2: Save pattern file**
```bash
# Generate filename
PATTERN_ID="rest-api-jwt-redis-v1"
PATTERN_FILE=~/.claude/skills/meta-orchestrator/patterns/discovered/${PATTERN_ID}.yaml

# Write pattern (use file_create tool)
# Content: Full YAML structure from extraction
```

**Step 3: Log execution**
```bash
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "${TIMESTAMP},${PATTERN_ID},${SUCCESS},${DURATION}" >> \
  ~/.claude/skills/meta-orchestrator/metrics/executions.log
```

**Step 4: Update success rate**
```bash
echo "${TIMESTAMP},${PATTERN_ID},${SUCCESS_RATE}" >> \
  ~/.claude/skills/meta-orchestrator/metrics/success_rates.log
```

**Step 5: Update pattern index**
```bash
# Add entry to patterns/README.md if new
# Or update existing entry
```

### Pattern Lifecycle

**Promotion rules:**

```bash
# After 5th successful execution (80%+ success)
if [ $EXECUTIONS -ge 5 ] && [ $SUCCESS_RATE -ge 0.80 ]; then
  mv discovered/${PATTERN_ID}.yaml validated/${PATTERN_ID}.yaml
fi

# After 20th successful execution (90%+ success)
if [ $EXECUTIONS -ge 20 ] && [ $SUCCESS_RATE -ge 0.90 ]; then
  mv validated/${PATTERN_ID}.yaml learned/${PATTERN_ID}.yaml
fi
```

**Demotion rules:**

```bash
# If success rate drops below 60%
if [ $SUCCESS_RATE -lt 0.60 ]; then
  mv learned/${PATTERN_ID}.yaml deprecated/${PATTERN_ID}.yaml
fi
```

**Use automation:** `scripts/pattern_storage.py` handles all lifecycle management

## Pattern Matching Algorithm

### Load All Patterns

```bash
# Priority: learned > validated > discovered
LEARNED=$(find ~/.claude/skills/meta-orchestrator/patterns/learned -name "*.yaml")
VALIDATED=$(find ~/.claude/skills/meta-orchestrator/patterns/validated -name "*.yaml")
DISCOVERED=$(find ~/.claude/skills/meta-orchestrator/patterns/discovered -name "*.yaml")

# Parse YAML into pattern_library
```

### Match Patterns to User Request

```python
def match_patterns(user_request, pattern_library):
    """Find best-matching patterns"""
    
    # 1. Extract keywords from request
    keywords = extract_keywords(user_request)
    # Example: ["build", "api", "authentication", "caching"]
    
    # 2. Find candidates with keyword overlap
    candidates = []
    for pattern in pattern_library:
        overlap = set(keywords) & set(pattern.task_keywords)
        if len(overlap) >= 2:  # At least 2 matching keywords
            score = len(overlap) / len(pattern.task_keywords)
            candidates.append((pattern, score))
    
    # 3. Rank by multiple factors
    ranked = rank_patterns(candidates, weights={
        "keyword_match": 0.4,    # 40% weight
        "success_rate": 0.3,     # 30% weight
        "usage_count": 0.2,      # 20% weight
        "recency": 0.1           # 10% weight
    })
    
    # 4. Return top 3
    return ranked[:3]
```

### Ranking Formula

```python
def calculate_score(pattern, keyword_score, weights):
    """Calculate composite pattern score"""
    
    # Normalize metrics to 0-1 range
    keyword_norm = keyword_score
    success_norm = pattern.success_rate
    usage_norm = min(pattern.total_executions / 100, 1.0)
    recency_norm = calculate_recency_score(pattern.last_updated)
    
    # Weighted sum
    score = (
        keyword_norm * weights["keyword_match"] +
        success_norm * weights["success_rate"] +
        usage_norm * weights["usage_count"] +
        recency_norm * weights["recency"]
    )
    
    return score

def calculate_recency_score(last_updated):
    """More recent = higher score"""
    days_ago = (now - last_updated).days
    if days_ago < 7:
        return 1.0
    elif days_ago < 30:
        return 0.8
    elif days_ago < 90:
        return 0.5
    else:
        return 0.2
```

### Example Matching

```
User: "Build API with authentication and caching"
Keywords: ["build", "api", "authentication", "caching"]

Candidates:
1. rest-api-jwt-redis-v1
   - Keywords: ["api", "authentication", "caching"] (3/4 match = 75%)
   - Success: 0.92
   - Usage: 48 (normalized: 0.48)
   - Recency: 2 days (1.0)
   → Score: 0.75*0.4 + 0.92*0.3 + 0.48*0.2 + 1.0*0.1 = 0.872

2. flask-api-basic-auth-v1
   - Keywords: ["api", "authentication"] (2/4 match = 50%)
   - Success: 0.78
   - Usage: 12 (normalized: 0.12)
   - Recency: 30 days (0.8)
   → Score: 0.50*0.4 + 0.78*0.3 + 0.12*0.2 + 0.8*0.1 = 0.538

Recommendation: Pattern 1 (rest-api-jwt-redis-v1)
Confidence: High (0.872 vs 0.538)
```

## Success Metrics Tracking

### Global Metrics

```yaml
global_metrics:
  total_workflows_executed: 1247
  successful_workflows: 1134
  failed_workflows: 113
  overall_success_rate: 0.909
  
  avg_speedup: 4.2x
  avg_time_saved: 23_minutes_per_workflow
  
  total_patterns: 87
  active_patterns: 72  # Used in last 30 days
  deprecated_patterns: 15
  
  total_plugins_analyzed: 412
  plugins_with_usage_data: 203
  plugins_never_used: 89
```

### Per-Plugin Metrics

```yaml
plugin_metrics:
  - plugin: fastapi-scaffolder
    total_uses: 234
    success_rate: 0.95
    avg_execution_time: 2.3_min
    last_used: 2025-11-07
    common_failures:
      - "Missing Python" (3)
      - "Permission denied" (1)
  
  - plugin: jwt-auth-plugin
    total_uses: 189
    success_rate: 0.89
    avg_execution_time: 3.1_min
    last_used: 2025-11-07
    common_failures:
      - "Missing python-jose" (12)
      - "No SECRET_KEY" (8)
```

## Continuous Improvement

### Learning from Success

After successful workflow:
1. Increment pattern usage count
2. Update average completion time
3. Recalculate success rate
4. Check for pattern promotion (discovered → validated → learned)

### Learning from Failure

After failed workflow:
1. Increment failure count
2. Record failure mode and context
3. Document fix if found
4. Update success rate
5. Check for pattern demotion (if success rate < 60%)

### Pattern Evolution

```
Week 1:
  Patterns: 12
  Avg success: 75%
  Speedup: 2.1x

Month 1:
  Patterns: 45 (+33 new)
  Avg success: 83% (+8%)
  Speedup: 3.4x (+1.3x)
  Improvements:
    - 8 patterns deprecated (low success)
    - Plugin rankings updated (150+ workflows)

Month 3:
  Patterns: 87 (+42 new)
  Avg success: 91% (+8%)
  Speedup: 4.2x (+0.8x)
  Improvements:
    - Pattern matching improved (keyword + context)
    - Error handling enhanced (12 new fixes)
    - 203 plugins with real usage data
```

## Pattern Query Commands

**Find patterns by keyword:**
```bash
grep -r "api.*auth" ~/.claude/skills/meta-orchestrator/patterns/learned/
```

**List top patterns:**
```bash
# Sort by success rate
ls -t ~/.claude/skills/meta-orchestrator/patterns/learned/ | head -10

# Sort by usage
grep "total_executions" patterns/learned/*.yaml | sort -rn | head -10
```

**View pattern details:**
```bash
cat ~/.claude/skills/meta-orchestrator/patterns/learned/rest-api-jwt-redis-v1.yaml
```

**Pattern statistics:**
```bash
# Total patterns
find ~/.claude/skills/meta-orchestrator/patterns -name "*.yaml" | wc -l

# Patterns by lifecycle stage
ls discovered/ | wc -l
ls validated/ | wc -l
ls learned/ | wc -l
```

## Learning Checklist

- [ ] Extract pattern after workflow execution
- [ ] Calculate updated metrics (success rate, avg time)
- [ ] Save pattern to appropriate directory
- [ ] Log execution to metrics files
- [ ] Update pattern index
- [ ] Check for lifecycle transitions
- [ ] Document any new failure modes
- [ ] Update plugin-specific metrics
- [ ] Verify pattern file is valid YAML
- [ ] Confirm pattern is discoverable

## Automation

Use `scripts/pattern_storage.py` to automate:
- Pattern file creation
- Metrics logging
- Lifecycle management
- Index updates
- Validation checks

**Usage:**
```bash
python scripts/pattern_storage.py \
  --workflow-result workflow_result.json \
  --pattern-id rest-api-jwt-redis-v1
```
