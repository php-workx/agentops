# Success Probability Algorithm

**Purpose:** Estimate likelihood that a pattern will succeed for a given task

**Used by:** Research phase (pattern selection), Plan phase (workflow optimization)

**Data sources:** Neo4j execution history, pattern metrics, plugin statistics

---

## Algorithm Overview

The success probability combines multiple weighted factors:

```
P(success) = w1·P_pattern + w2·P_plugins + w3·P_context + w4·P_similarity

Where:
- P_pattern: Historical pattern success rate
- P_plugins: Plugin reliability scores
- P_context: Task-pattern context match
- P_similarity: Similarity to successful past executions
- w1, w2, w3, w4: Weights (sum to 1.0)
```

**Default weights:**
- w1 = 0.40 (pattern history most important)
- w2 = 0.30 (plugin reliability critical)
- w3 = 0.20 (context match matters)
- w4 = 0.10 (similarity helpful but less critical)

---

## Factor 1: Pattern Success Rate (P_pattern)

**Definition:** Historical success rate of the pattern

**Calculation:**

```python
def calculate_pattern_success_rate(pattern_id):
    # Query Neo4j for execution history
    query = """
    MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
    RETURN
      COUNT(exec) AS total,
      SUM(CASE WHEN exec.status = 'success' THEN 1 ELSE 0 END) AS successes
    """

    result = neo4j.run(query, pattern_id=pattern_id)
    total = result['total']
    successes = result['successes']

    if total == 0:
        return 0.5  # Unknown pattern, neutral probability

    # Calculate success rate
    success_rate = successes / total

    # Apply confidence factor (more executions = higher confidence)
    confidence = min(1.0, total / 10)  # Full confidence at 10+ executions

    # Weighted by confidence
    return success_rate * confidence + 0.5 * (1 - confidence)
```

**Example:**

- Pattern with 45 successes / 50 executions = 0.90 base rate
- Confidence = min(1.0, 50/10) = 1.0 (full confidence)
- P_pattern = 0.90 × 1.0 + 0.5 × 0.0 = **0.90**

- Pattern with 4 successes / 5 executions = 0.80 base rate
- Confidence = min(1.0, 5/10) = 0.5 (moderate confidence)
- P_pattern = 0.80 × 0.5 + 0.5 × 0.5 = **0.65** (tempered by low sample size)

---

## Factor 2: Plugin Reliability (P_plugins)

**Definition:** Average success rate of all plugins in the workflow

**Calculation:**

```python
def calculate_plugin_reliability(pattern_id):
    # Query Neo4j for pattern's plugins
    query = """
    MATCH (pat:Pattern {pattern_id: $pattern_id})-[u:USES]->(p:Plugin)
    RETURN p.name AS plugin, p.success_rate AS rate, u.required AS required
    ORDER BY u.step_number
    """

    plugins = neo4j.run(query, pattern_id=pattern_id)

    if not plugins:
        return 0.5  # No plugin data, neutral

    # Calculate weighted average (required plugins weighted higher)
    total_weight = 0
    weighted_sum = 0

    for plugin in plugins:
        weight = 2.0 if plugin['required'] else 1.0
        rate = plugin['rate'] if plugin['rate'] is not None else 0.8  # Default

        weighted_sum += rate * weight
        total_weight += weight

    return weighted_sum / total_weight if total_weight > 0 else 0.5
```

**Example:**

Pattern uses 5 plugins:
1. fastapi-scaffolder (required): 0.98 success rate, weight=2.0
2. jwt-auth-plugin (required): 0.89 success rate, weight=2.0
3. redis-cache-plugin (required): 0.95 success rate, weight=2.0
4. rate-limiter-plugin (optional): 0.91 success rate, weight=1.0
5. api-tester (optional): 0.97 success rate, weight=1.0

```
weighted_sum = (0.98×2.0) + (0.89×2.0) + (0.95×2.0) + (0.91×1.0) + (0.97×1.0)
             = 1.96 + 1.78 + 1.90 + 0.91 + 0.97
             = 7.52

total_weight = 2.0 + 2.0 + 2.0 + 1.0 + 1.0 = 8.0

P_plugins = 7.52 / 8.0 = 0.94
```

---

## Factor 3: Context Match (P_context)

**Definition:** How well the task description matches the pattern's domain

**Calculation:**

```python
def calculate_context_match(task_description, pattern):
    # Extract keywords from task
    task_keywords = extract_keywords(task_description)

    # Extract keywords from pattern (name, description, category)
    pattern_keywords = extract_keywords(
        pattern['name'] + " " + pattern['description'] + " " + pattern['category']
    )

    # Calculate Jaccard similarity
    intersection = len(task_keywords & pattern_keywords)
    union = len(task_keywords | pattern_keywords)

    jaccard = intersection / union if union > 0 else 0.0

    # Bonus for category match
    category_match = 1.0 if pattern['category'] in task_description.lower() else 0.0

    # Combine (Jaccard 80%, category 20%)
    return jaccard * 0.8 + category_match * 0.2
```

**Example:**

Task: "Build REST API with JWT authentication and Redis caching"
Pattern: "REST API with JWT + Redis" (category: api-development)

```
task_keywords = {rest, api, jwt, authentication, redis, caching}
pattern_keywords = {rest, api, jwt, redis, api-development}

intersection = {rest, api, jwt, redis} = 4
union = {rest, api, jwt, authentication, redis, caching, api-development} = 7

jaccard = 4/7 = 0.571

category_match = 1.0 (pattern category "api-development" in task)

P_context = 0.571 × 0.8 + 1.0 × 0.2 = 0.457 + 0.2 = 0.657
```

---

## Factor 4: Similarity to Past Successes (P_similarity)

**Definition:** How similar this task is to previous successful executions

**Calculation:**

```python
def calculate_similarity_score(task_description, pattern_id):
    # Query Neo4j for successful past executions
    query = """
    MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
    WHERE exec.status = 'success'
    RETURN exec.task_description AS task
    ORDER BY exec.completed_at DESC
    LIMIT 10
    """

    past_tasks = neo4j.run(query, pattern_id=pattern_id)

    if not past_tasks:
        return 0.5  # No history, neutral

    # Calculate similarity to each past task
    similarities = []
    for past_task in past_tasks:
        sim = text_similarity(task_description, past_task['task'])
        similarities.append(sim)

    # Return max similarity (best match to any past success)
    return max(similarities) if similarities else 0.5

def text_similarity(text1, text2):
    # Simple cosine similarity on keyword vectors
    keywords1 = extract_keywords(text1)
    keywords2 = extract_keywords(text2)

    intersection = len(keywords1 & keywords2)
    magnitude1 = len(keywords1)
    magnitude2 = len(keywords2)

    if magnitude1 == 0 or magnitude2 == 0:
        return 0.0

    return intersection / (magnitude1 * magnitude2) ** 0.5
```

**Example:**

Current task: "Build payment service API with JWT and Redis"

Past successful tasks:
1. "Build user service API with JWT and Redis" → similarity = 0.85
2. "Create e-commerce API with authentication and caching" → similarity = 0.72
3. "Implement checkout API with JWT tokens" → similarity = 0.68

```
P_similarity = max(0.85, 0.72, 0.68) = 0.85
```

---

## Combined Success Probability

**Final calculation:**

```python
def calculate_success_probability(task, pattern_id):
    # Calculate each factor
    P_pattern = calculate_pattern_success_rate(pattern_id)
    P_plugins = calculate_plugin_reliability(pattern_id)
    P_context = calculate_context_match(task, pattern)
    P_similarity = calculate_similarity_score(task, pattern_id)

    # Apply weights
    w1, w2, w3, w4 = 0.40, 0.30, 0.20, 0.10

    # Compute weighted average
    probability = w1 * P_pattern + w2 * P_plugins + w3 * P_context + w4 * P_similarity

    return probability
```

**Full example:**

Task: "Build payment service API with JWT authentication and Redis caching"
Pattern: rest-api-jwt-redis-v1

```
P_pattern = 0.90 (45/50 successful executions, high confidence)
P_plugins = 0.94 (5 reliable plugins, weighted average)
P_context = 0.66 (good keyword match, category match)
P_similarity = 0.85 (very similar to past successful task)

P(success) = 0.40 × 0.90 + 0.30 × 0.94 + 0.20 × 0.66 + 0.10 × 0.85
           = 0.36 + 0.282 + 0.132 + 0.085
           = 0.859 ≈ 86%

Recommendation: HIGH CONFIDENCE - Pattern well-suited for this task
```

---

## Confidence Thresholds

**Interpretation:**

| Probability | Confidence | Recommendation |
|-------------|------------|----------------|
| ≥ 0.85 | High | ⭐ Strongly recommend pattern |
| 0.70 - 0.84 | Good | ✅ Recommend pattern |
| 0.50 - 0.69 | Moderate | ⚠️ Consider alternatives |
| < 0.50 | Low | ❌ Not recommended |

**Actions by confidence:**

- **High (≥0.85):** Use pattern immediately, expect success
- **Good (0.70-0.84):** Use pattern with normal caution, likely to succeed
- **Moderate (0.50-0.69):** Review pattern details, consider alternatives, proceed with caution
- **Low (<0.50):** Explore other patterns, this may not be a good fit

---

## Pattern Selection Algorithm

**When multiple patterns match:**

```python
def select_best_pattern(task, candidate_patterns):
    # Calculate probability for each candidate
    scores = []
    for pattern in candidate_patterns:
        prob = calculate_success_probability(task, pattern['pattern_id'])
        scores.append((pattern, prob))

    # Sort by probability (descending)
    scores.sort(key=lambda x: x[1], reverse=True)

    # Return top N patterns with confidence levels
    recommendations = []
    for pattern, prob in scores[:5]:
        if prob >= 0.85:
            confidence = "High"
            emoji = "⭐"
        elif prob >= 0.70:
            confidence = "Good"
            emoji = "✅"
        elif prob >= 0.50:
            confidence = "Moderate"
            emoji = "⚠️"
        else:
            confidence = "Low"
            emoji = "❌"

        recommendations.append({
            'pattern': pattern,
            'probability': prob,
            'confidence': confidence,
            'emoji': emoji
        })

    return recommendations
```

**Output example:**

```
Pattern recommendations for: "Build payment service API"

1. ⭐ rest-api-jwt-redis-v1 (86% probability)
   - High confidence
   - 45/50 successful executions
   - All plugins reliable (0.94 avg)

2. ✅ rest-api-oauth-redis-v1 (74% probability)
   - Good confidence
   - 18/23 successful executions
   - Similar task match (0.78)

3. ⚠️ graphql-api-jwt-v1 (62% probability)
   - Moderate confidence
   - 8/12 successful executions
   - Lower context match (different API style)
```

---

## Continuous Improvement

**After each execution, update probabilities:**

```python
def update_after_execution(execution):
    pattern_id = execution['pattern_id']
    status = execution['status']

    # Record execution in Neo4j (updates pattern.executions, pattern.success_rate)
    record_execution_to_neo4j(execution)

    # Recalculate pattern success rate
    new_success_rate = calculate_pattern_success_rate(pattern_id)

    # Update pattern file
    update_pattern_file(pattern_id, success_rate=new_success_rate)

    # If pattern crossed threshold, promote status
    if new_success_rate >= 0.90 and pattern['executions'] >= 10:
        promote_pattern(pattern_id, 'validated' → 'learned')
```

**Result:** Probability algorithm improves as more executions complete

---

## Neo4j Queries for Probability

### Get Pattern Execution History

```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
RETURN
  COUNT(exec) AS total_executions,
  SUM(CASE WHEN exec.status = 'success' THEN 1 ELSE 0 END) AS successes,
  AVG(exec.duration_ms) AS avg_duration
```

### Get Plugin Reliability for Pattern

```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})-[u:USES]->(p:Plugin)
RETURN
  p.name AS plugin,
  p.success_rate AS plugin_success_rate,
  u.required AS is_required,
  u.step_number AS step
ORDER BY u.step_number
```

### Find Similar Successful Executions

```cypher
MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
WHERE exec.status = 'success'
RETURN exec.task_description AS task
ORDER BY exec.completed_at DESC
LIMIT 10
```

---

## Future Enhancements

**Planned improvements:**

1. **Machine Learning Integration**
   - Train model on execution history
   - Learn optimal weights (w1, w2, w3, w4) dynamically
   - Predict failure modes proactively

2. **Context Embeddings**
   - Replace keyword matching with semantic embeddings
   - Better context similarity via vector search
   - Neo4j vector index for fast similarity queries

3. **Known Issues Factor**
   - Add P_issues: likelihood of encountering known issues
   - Weight by issue frequency and auto-fixability
   - Reduce probability if blocking issues detected

4. **User Feedback Loop**
   - Allow users to rate pattern recommendations
   - Adjust weights based on feedback
   - Personalize probabilities per user

---

## Version & Status

**Version:** 0.1.0
**Last Updated:** November 8, 2025
**Status:** Active (basic implementation), ML enhancements planned
