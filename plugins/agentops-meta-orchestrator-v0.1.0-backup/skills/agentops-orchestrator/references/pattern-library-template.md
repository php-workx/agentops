# Pattern Library Template

**Purpose:** Template for recording discovered workflow patterns

**Used by:** Learning Phase to record successful plugin orchestrations

**Output:** Reusable workflow patterns for future tasks

---

## Pattern Structure

Each discovered pattern should include:

### 1. Pattern Metadata

```yaml
pattern:
  id: [unique-pattern-id]
  name: "[Human-readable pattern name]"
  version: [x.y.z]
  created: [YYYY-MM-DD]
  last_updated: [YYYY-MM-DD]
  status: [active | deprecated | experimental]
```

**Example:**
```yaml
pattern:
  id: rest-api-jwt-redis-v1
  name: "REST API with JWT Authentication and Redis Caching"
  version: 1.0.0
  created: 2025-09-12
  last_updated: 2025-11-07
  status: active
```

### 2. Pattern Description

```yaml
description:
  short: "[One-sentence summary]"
  full: |
    [Detailed explanation of what this pattern accomplishes]

  use_cases:
    - "[When to use this pattern]"
    - "[What problems it solves]"
```

**Example:**
```yaml
description:
  short: "Build production-ready FastAPI with authentication and caching"
  full: |
    Creates a FastAPI-based REST API with JWT authentication, Redis caching,
    rate limiting, and comprehensive testing. Suitable for production use.
    Includes OpenAPI documentation and deployment configuration.

  use_cases:
    - "Building authenticated REST APIs"
    - "APIs requiring caching for performance"
    - "Production-ready web services with rate limiting"
```

### 3. Domain Classification

```yaml
classification:
  domain: [web-development | devops | data-engineering | security | etc.]
  subdomain: [api-development | containerization | etl | etc.]
  complexity: [simple | moderate | complex]
  maturity: [experimental | tested | production-ready]
```

**Example:**
```yaml
classification:
  domain: web-development
  subdomain: api-development
  complexity: moderate
  maturity: production-ready
```

### 4. Task Keywords (for matching)

```yaml
keywords:
  primary:
    - "[main keyword 1]"
    - "[main keyword 2]"

  secondary:
    - "[related keyword 1]"
    - "[related keyword 2]"

  technologies:
    - "[technology 1]"
    - "[technology 2]"
```

**Example:**
```yaml
keywords:
  primary:
    - "rest-api"
    - "api"
    - "authentication"
    - "caching"

  secondary:
    - "jwt"
    - "redis"
    - "rate-limiting"
    - "fastapi"

  technologies:
    - "fastapi"
    - "redis"
    - "python"
    - "openapi"
```

### 5. Plugin Sequence

```yaml
sequence:
  - step: 1
    plugin: [plugin-name]
    purpose: "[What does this step accomplish?]"
    inputs:
      - name: [input-name]
        source: [user | previous-step | config]
        value: [example-value]
    outputs:
      - name: [output-name]
        used_by: [next-step-number | final-output]
    validation:
      - "[How to verify this step succeeded]"
    avg_time: [duration]
    success_rate: [percentage]

  # Repeat for each step
```

**Example:**
```yaml
sequence:
  - step: 1
    plugin: fastapi-scaffolder
    purpose: "Create API project structure"
    inputs:
      - name: app_name
        source: user
        value: "my-api"
      - name: template
        source: config
        value: "minimal"
    outputs:
      - name: project_path
        used_by: step-2
      - name: files_created
        used_by: final-output
    validation:
      - "Check main.py exists"
      - "Verify Python syntax valid"
    avg_time: "2 min"
    success_rate: 0.98

  - step: 2
    plugin: jwt-auth-plugin
    purpose: "Add JWT authentication"
    inputs:
      - name: project_path
        source: step-1
        value: "./my-api"
      - name: user_model
        source: user
        value: "User"
    outputs:
      - name: auth_routes
        used_by: final-output
      - name: middleware
        used_by: step-3
    validation:
      - "Check /login endpoint exists"
      - "Test token creation works"
    avg_time: "3 min"
    success_rate: 0.89
```

### 6. Success Metrics

```yaml
metrics:
  total_executions: [count]
  successful_executions: [count]
  failed_executions: [count]
  success_rate: [percentage]

  timing:
    avg_completion_time: [duration]
    min_completion_time: [duration]
    max_completion_time: [duration]

  quality:
    avg_test_pass_rate: [percentage]
    avg_validation_success: [percentage]
```

**Example:**
```yaml
metrics:
  total_executions: 48
  successful_executions: 44
  failed_executions: 4
  success_rate: 0.917

  timing:
    avg_completion_time: "11.5 min"
    min_completion_time: "9 min"
    max_completion_time: "15 min"

  quality:
    avg_test_pass_rate: 0.96
    avg_validation_success: 1.0
```

### 7. Known Issues & Fixes

```yaml
known_issues:
  - issue: "[Description of issue]"
    frequency: [count or percentage]
    severity: [low | medium | high]
    root_cause: "[Why does this happen?]"
    fix: "[How to resolve?]"
    prevention: "[How to avoid?]"
```

**Example:**
```yaml
known_issues:
  - issue: "Redis connection refused"
    frequency: 3
    severity: medium
    root_cause: "Redis server not running"
    fix: "Start Redis server before running workflow"
    prevention: "Check Redis status in pre-flight validation"

  - issue: "Missing python-jose dependency"
    frequency: 2
    severity: low
    root_cause: "Dependency not in requirements.txt"
    fix: "pip install python-jose"
    prevention: "Add to requirements.txt in scaffolder step"
```

### 8. Environment Requirements

```yaml
environment:
  variables:
    - name: [ENV_VAR_NAME]
      required: [true | false]
      description: "[What is this for?]"
      example: "[example-value]"

  dependencies:
    - name: [dependency-name]
      version: [version-spec]
      type: [npm | pip | system | service]

  external_services:
    - name: [service-name]
      purpose: "[Why is this needed?]"
      config: "[How to configure?]"
```

**Example:**
```yaml
environment:
  variables:
    - name: SECRET_KEY
      required: true
      description: "JWT signing secret"
      example: "your-secret-key-here"

    - name: REDIS_URL
      required: true
      description: "Redis connection string"
      example: "redis://localhost:6379"

  dependencies:
    - name: fastapi
      version: ">=0.95.0"
      type: pip

    - name: redis
      version: ">=4.0.0"
      type: pip

  external_services:
    - name: redis
      purpose: "Caching layer"
      config: "Install and start: redis-server"
```

### 9. Validation Strategy

```yaml
validation:
  pre_flight:
    - "[Check before starting workflow]"

  per_step:
    - "[Check after each step]"

  final:
    - "[Check after workflow complete]"
```

**Example:**
```yaml
validation:
  pre_flight:
    - "Verify Redis is running"
    - "Check Python version >= 3.9"
    - "Ensure required env vars set"

  per_step:
    - "Validate outputs match expected schema"
    - "Run syntax checks on generated code"
    - "Test imports work"

  final:
    - "Run full test suite (pytest)"
    - "Test API health endpoint"
    - "Verify authentication flow works"
    - "Check OpenAPI docs accessible"
```

### 10. Related Patterns

```yaml
related:
  similar:
    - pattern_id: [pattern-id]
      similarity: [percentage]
      difference: "[How do they differ?]"

  alternatives:
    - pattern_id: [pattern-id]
      use_when: "[When to use this instead?]"

  extends:
    - pattern_id: [pattern-id]
      extension: "[What does this pattern add?]"
```

**Example:**
```yaml
related:
  similar:
    - pattern_id: flask-api-oauth2-v1
      similarity: 0.75
      difference: "Uses Flask instead of FastAPI, OAuth2 instead of JWT"

  alternatives:
    - pattern_id: graphql-api-auth-v1
      use_when: "Need GraphQL instead of REST"

  extends:
    - pattern_id: rest-api-basic-v1
      extension: "Adds authentication and caching to basic API"
```

---

## Common Pattern Archetypes

Patterns typically fall into these categories:

### 1. Sequential Pattern

**Structure:**
```
Step 1 → Step 2 → Step 3 → ... → Step N
```

**Characteristics:**
- Each step depends on previous step
- Linear data flow (output of N feeds input of N+1)
- Cannot parallelize
- Total time = sum of all step times

**Example:**
```
Scaffold → Add Auth → Add Cache → Add Tests → Deploy
```

**When to use:**
- Steps have strict dependencies
- Data transformation pipeline
- Build/deploy workflows

### 2. Parallel Pattern

**Structure:**
```
       ┌→ Step 2a ┐
Step 1 ┼→ Step 2b ┼→ Step 3
       └→ Step 2c ┘
```

**Characteristics:**
- Multiple steps run simultaneously
- Independent data streams
- Can parallelize (3x speedup for 3 parallel steps)
- Total time = max(parallel step times)

**Example:**
```
        ┌→ Security scan  ┐
Init ───┼→ Linting        ┼→ Aggregate results
        └→ Test coverage  ┘
```

**When to use:**
- Steps are independent
- Each step analyzes different aspect
- Research/analysis phases

### 3. Conditional Pattern

**Structure:**
```
Step 1 → Decision → Step 2a (if condition)
                 └→ Step 2b (else)
```

**Characteristics:**
- Branching based on outputs
- Different paths for different contexts
- Dynamic workflow selection

**Example:**
```
Analyze codebase → If Python: Use pytest
                  └ If Node: Use jest
```

**When to use:**
- Workflow varies by context
- Need different tools for different scenarios
- Error recovery with fallbacks

### 4. Feedback Loop Pattern

**Structure:**
```
Step 1 → Step 2 → Validate → If pass: Continue
                           └→ If fail: Retry Step 2 (up to N times)
```

**Characteristics:**
- Self-correcting
- Retries on failure
- Improves with iteration

**Example:**
```
Generate code → Test → If fail: Fix code → Re-test (until pass or max retries)
```

**When to use:**
- Quality gates needed
- Error correction possible
- Iterative improvement workflows

---

## Pattern Template (Complete YAML)

Use this complete template for new patterns:

```yaml
pattern:
  id: example-pattern-v1
  name: "Example Workflow Pattern"
  version: 1.0.0
  created: 2025-11-07
  last_updated: 2025-11-07
  status: active

description:
  short: "One-sentence pattern summary"
  full: |
    Detailed explanation of what this pattern does,
    when to use it, and what it accomplishes.

  use_cases:
    - "Use case 1"
    - "Use case 2"

classification:
  domain: web-development
  subdomain: api-development
  complexity: moderate
  maturity: production-ready

keywords:
  primary:
    - "keyword1"
    - "keyword2"
  secondary:
    - "keyword3"
  technologies:
    - "tech1"

sequence:
  - step: 1
    plugin: plugin-name
    purpose: "What this step does"
    inputs:
      - name: input1
        source: user
        value: "example"
    outputs:
      - name: output1
        used_by: step-2
    validation:
      - "Check output1 exists"
    avg_time: "2 min"
    success_rate: 0.95

metrics:
  total_executions: 10
  successful_executions: 9
  failed_executions: 1
  success_rate: 0.9

  timing:
    avg_completion_time: "10 min"
    min_completion_time: "8 min"
    max_completion_time: "12 min"

known_issues:
  - issue: "Issue description"
    frequency: 1
    severity: low
    fix: "How to fix"

environment:
  variables:
    - name: ENV_VAR
      required: true
      description: "Purpose"
  dependencies:
    - name: dependency
      version: ">=1.0.0"
      type: pip

validation:
  pre_flight:
    - "Pre-check 1"
  per_step:
    - "Step validation"
  final:
    - "Final check"

related:
  similar: []
  alternatives: []
  extends: []

tags:
  - tag1
  - tag2
```

---

## Pattern Lifecycle

### Creation
1. Workflow executes successfully
2. Learning phase extracts pattern
3. Pattern recorded with initial metrics (usage: 1)
4. Status: experimental

### Maturation
1. Pattern used 5+ times successfully
2. Success rate measured
3. Known issues documented
4. Status: tested

### Production
1. Pattern used 20+ times
2. Success rate > 80%
3. Documentation complete
4. Status: production-ready

### Deprecation
1. Success rate drops below 60%
2. Marked as deprecated
3. Alternative pattern suggested
4. Eventually archived

---

**Version:** 0.1.0
**Last Updated:** 2025-11-07
**Status:** Template for pattern recording
