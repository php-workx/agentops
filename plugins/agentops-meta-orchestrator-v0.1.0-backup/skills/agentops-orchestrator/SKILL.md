---
name: plugin-meta-orchestration
description: |
  Analyzes 400+ Claude Code plugins to learn orchestration patterns and generate
  optimal workflows. Activates when users request complex multi-step tasks or
  ask about plugin recommendations. Uses sub-agents to research capabilities,
  synthesizes patterns, and executes learned workflows.
version: 0.1.0
author: AgentOps Team
license: Apache-2.0
tags: [meta-orchestration, agent-skills, workflow-learning, plugin-analysis]
---

# Plugin Meta-Orchestration Agent Skill

## Overview

This Agent Skill implements **meta-orchestration** - the ability for an AI agent to learn how to orchestrate other AI tools (Claude Code plugins) by analyzing their capabilities and discovering successful workflow patterns.

**The Core Problem:** With 400+ Claude Code plugins available across multiple marketplaces, users face:
- **Discovery paralysis** - Too many options, unclear which to use
- **Integration complexity** - Plugins need to work together, but dependencies aren't obvious
- **Pattern reinvention** - Similar tasks solved repeatedly instead of reusing proven workflows
- **Suboptimal results** - Random plugin selection instead of evidence-based orchestration

**This Skill's Solution:** Act as an intelligent orchestration layer that:
1. **Learns plugin capabilities** by analyzing marketplace metadata and documentation
2. **Discovers patterns** about which plugins work well together and why
3. **Generates workflows** optimized for specific task requirements
4. **Improves continuously** by recording successful orchestrations and updating recommendations

**Think of it as:** An AI that learns to use AI tools by studying how they compose and integrate.

### Philosophical Foundation

This skill embodies the AgentOps principle of **"Agents improving agents"**:

- **Research-first:** Understand all available tools before choosing
- **Evidence-based:** Patterns emerge from successful orchestrations, not assumptions
- **Continuous learning:** Every workflow execution teaches the skill how to improve
- **Institutional memory:** Discovered patterns benefit all future users

**Key Insight:** The same cognitive load principles that prevent human burnout (40% rule) also prevent AI context collapse. Multi-agent orchestration enables both to work faster by specializing.

### Success Metrics

After using this skill, expect:

- **3-5x speedup** in complex multi-plugin tasks (vs manual selection)
- **90%+ success rate** for generated workflows (validated patterns only)
- **Growing pattern library** (more patterns = better recommendations over time)
- **Reduced cognitive load** (skill handles plugin research and integration)

### What Makes This Different

**Traditional approach:**
```
User → Manual plugin search → Trial and error → Maybe success
```

**Meta-orchestration approach:**
```
User describes task → Skill researches 400+ plugins in parallel →
Generates evidence-based workflow → Executes with validation →
Records learnings for future reuse
```

**Result:** Faster, more reliable, continuously improving.

---

## How It Works

The skill operates in **four phases** following AgentOps methodology:

### Phase 1: Research (Parallel Plugin Analysis)

When activated by a user request, the skill spawns **multiple sub-agents** to simultaneously analyze:

**Sub-Agent 1: Capability Extraction**
- Scans plugin metadata (name, description, keywords)
- Identifies: What does this plugin do? (inputs, outputs, transformations)
- Categorizes: Which domain? (web-dev, devops, data-eng, security, etc.)

**Sub-Agent 2: Integration Pattern Recognition**
- Analyzes: How does this plugin connect to others? (data formats, dependencies)
- Maps: Input/output compatibility (which outputs feed which inputs)
- Identifies: Common sequences (plugins often used together)

**Sub-Agent 3: Success Rate Analysis**
- Reviews: Historical usage patterns (if available)
- Measures: Success rate for this plugin in similar contexts
- Flags: Known failure modes and how to avoid them

**Why parallel?** 3x wall-clock speedup (research 400 plugins in minutes, not hours)

**Output:** Comprehensive capability map of all relevant plugins

### Neo4j Integration: Intelligent Plugin Discovery

**The Research phase uses Neo4j to enhance plugin discovery:**

**Step 1: Query plugin capabilities**
```cypher
// Find plugins matching task category
MATCH (p:Plugin)
WHERE p.category IN $categories
  AND p.success_rate >= $min_success_threshold
RETURN p.name, p.description, p.success_rate, p.total_uses
ORDER BY p.success_rate DESC, p.total_uses DESC
LIMIT 50
```

**Step 2: Load known issues**
```cypher
// Check for known failure modes
MATCH (p:Plugin {name: $plugin_name})-[:HAS_ISSUE]->(issue:Issue)
RETURN issue.error_pattern, issue.solution, issue.frequency
ORDER BY issue.frequency DESC
```

**Step 3: Identify alternatives**
```cypher
// Find similar plugins (fallback options)
MATCH (p:Plugin {name: $plugin_name})-[s:SIMILAR_TO]->(similar:Plugin)
WHERE s.similarity_score >= 0.7
RETURN similar.name, s.similarity_score, similar.success_rate
ORDER BY s.similarity_score DESC, similar.success_rate DESC
LIMIT 5
```

**Benefits:**
- **Intelligent selection:** Choose plugins with proven track records
- **Failure prevention:** Pre-check known issues before execution
- **Automatic fallbacks:** Alternative plugins ready if primary fails

**Graceful degradation:** If Neo4j unavailable, falls back to file-based marketplace search.

### Phase 2: Plan (Pattern Synthesis & Workflow Generation)

The skill synthesizes research findings to generate an optimal workflow:

**Step 1: Task Decomposition**
```
User request: "Build REST API with auth and caching"

Decompose into:
1. API structure creation
2. Authentication layer integration
3. Caching middleware setup
4. Rate limiting configuration
5. Testing and validation
```

**Step 2: Plugin Matching**
```
For each subtask, find plugins that:
- Solve the specific requirement (capability match)
- Integrate with previous steps (compatibility)
- Have high success rates (evidence-based)

Example:
Subtask 1 (API structure) → 'fastapi-scaffolder' (95% success)
Subtask 2 (Auth) → 'jwt-auth-plugin' (89% success)
Subtask 3 (Cache) → 'redis-cache-plugin' (92% success)
```

**Step 3: Workflow Sequencing**
```
Order plugins based on:
- Dependencies (what needs to exist first)
- Data flow (outputs feeding inputs)
- Validation points (where to check quality)

Generated sequence:
1. fastapi-scaffolder (creates structure)
2. jwt-auth-plugin (adds auth layer)
3. redis-cache-plugin (adds caching)
4. rate-limiter-plugin (adds throttling)
5. api-tester (validates everything works)
```

**Step 4: Validation Strategy**
```
For each step, define:
- What success looks like (acceptance criteria)
- How to verify (tests, checks)
- What to do if it fails (retry, fallback, alert)
```

**Output:** Detailed workflow plan with plugin sequence, validation checkpoints, error handling

### Phase 3: Implement (Workflow Execution & Validation)

The skill executes the generated workflow with continuous validation:

**Execution Loop:**
```
For each plugin in workflow sequence:
  1. Invoke plugin with required inputs
  2. Capture outputs
  3. Validate outputs against acceptance criteria
  4. If validation passes:
     - Pass outputs to next plugin as inputs
     - Record successful execution
  5. If validation fails:
     - Log failure details
     - Attempt retry (if applicable)
     - Try fallback plugin (if available)
     - Alert user if unrecoverable
```

**Example Execution:**
```
Step 1: Invoke 'fastapi-scaffolder'
  Input: { app_name: "my-api", features: ["auth", "cache"] }
  Output: { structure_created: true, files: [...] }
  Validation: Check files exist, syntax valid ✓

Step 2: Invoke 'jwt-auth-plugin'
  Input: { app_path: "./my-api", auth_type: "JWT" }
  Output: { auth_configured: true, routes: [...] }
  Validation: Auth endpoints exist, JWT validation works ✓

Step 3: Invoke 'redis-cache-plugin'
  Input: { app_path: "./my-api", cache_backend: "redis" }
  Output: { cache_enabled: true, config: {...} }
  Validation: Redis connection works, caching active ✓

... continue for all steps
```

**Error Handling:**
```
If plugin fails:
1. Check if it's a known failure mode
   - Yes: Apply known fix (e.g., install missing dependency)
   - No: Log for pattern learning

2. Attempt retry (up to 3 times with backoff)

3. If still failing:
   - Try alternative plugin (if pattern library suggests one)
   - Fall back to manual intervention
   - Record failure for future learning
```

**Output:** Task completed using optimal plugin orchestration, with validation results

### Phase 4: Learn (Continuous Improvement)

After every workflow execution, the skill extracts patterns for future reuse:

**Pattern Extraction:**
```
For successful workflow:
1. Record plugin sequence
   - Which plugins were used
   - In what order
   - With what parameters

2. Measure success metrics
   - Time to complete
   - Success rate of each step
   - Overall workflow success

3. Identify reusable pattern
   - What type of task does this solve?
   - What are the key characteristics?
   - When should this pattern be suggested?

4. Update pattern library
   - Add new pattern if novel
   - Increment success count if existing
   - Update success rate metrics
```

**Example Pattern Record:**
```yaml
pattern_id: rest-api-with-auth-and-cache
description: Build REST API with JWT authentication and Redis caching
domain: web-development
plugins:
  - fastapi-scaffolder (structure)
  - jwt-auth-plugin (authentication)
  - redis-cache-plugin (caching)
  - rate-limiter-plugin (throttling)
  - api-tester (validation)
success_rate: 0.92
avg_completion_time: 12_minutes
usage_count: 47
last_updated: 2025-11-07
tags: [api, authentication, caching, fastapi]
```

**Pattern Matching for Future Tasks:**
```
When user requests: "Build API with auth and caching"

Skill checks pattern library:
1. Find patterns matching keywords: [api, auth, caching]
2. Rank by success rate and usage count
3. Suggest top-ranked pattern
4. User can accept or request alternatives
```

**Learning from Failures:**
```
If workflow fails:
1. Record what went wrong
   - Which plugin failed
   - What was the error
   - What was attempted

2. Identify root cause
   - Missing dependency?
   - Incompatible versions?
   - Configuration error?

3. Update pattern library
   - Add failure mode to known issues
   - Document fix if found
   - Lower success rate if pattern unreliable
```

**Output:** Updated pattern library with improved recommendations for future tasks

---

## When to Use This Skill

This skill automatically activates when:

### Trigger 1: Complex Multi-Step Tasks

User requests involving multiple steps or tools:

```
✓ "Build a web app with Next.js, PostgreSQL, and deploy to Vercel"
✓ "Create ETL pipeline to transform CSV and load into BigQuery"
✓ "Set up CI/CD pipeline with Docker, Kubernetes, and GitHub Actions"
✓ "Audit codebase for security issues and apply fixes"
```

**Why activate:** These tasks require orchestrating multiple plugins in sequence

### Trigger 2: Plugin Recommendation Requests

User explicitly asks about plugins:

```
✓ "What plugins should I use to build a REST API?"
✓ "How do I combine Docker and Kubernetes plugins?"
✓ "Which plugins work well for data transformation?"
✓ "Are there plugins for API security?"
```

**Why activate:** User needs guidance on plugin selection and integration

### Trigger 3: Workflow Optimization Requests

User wants to improve existing workflows:

```
✓ "Is there a faster way to deploy containers?"
✓ "Can I automate this multi-step process?"
✓ "What's the best plugin combination for ETL?"
✓ "How can I reduce time spent on API testing?"
```

**Why activate:** Skill can suggest optimized plugin orchestrations

### Trigger 4: Pattern Discovery Requests

User wants to explore available capabilities:

```
✓ "Show me patterns for container orchestration"
✓ "What workflows exist for web development?"
✓ "Discover patterns for data engineering"
✓ "What are common plugin combinations?"
```

**Why activate:** User is exploring what's possible, skill can showcase patterns

### When NOT to Activate

**Don't activate for:**
- Single plugin usage (user knows which tool to use)
- Simple tasks (no orchestration needed)
- Non-plugin requests (questions about code, debugging, etc.)
- Already using another specialized skill

**Example non-triggers:**
```
✗ "Run the tests" (single command, no orchestration)
✗ "What does this code do?" (code analysis, not plugin usage)
✗ "Fix this bug" (debugging, not plugin orchestration)
✗ "Explain JWT" (conceptual question, not task)
```

---

## Research Phase Process (Detailed)

### Sub-Agent Architecture

The skill spawns three specialized sub-agents that work in parallel:

#### Sub-Agent 1: Plugin Capability Extractor

**Purpose:** Understand what each plugin does

**Process:**
1. **Read plugin metadata**
   - Name, description, keywords
   - Author, version, license
   - Repository URL

2. **Analyze plugin documentation**
   - README content
   - Usage examples
   - API/interface definition

3. **Extract capabilities**
   ```json
   {
     "plugin_name": "fastapi-scaffolder",
     "capabilities": [
       "Create FastAPI project structure",
       "Generate CRUD endpoints",
       "Setup OpenAPI documentation"
     ],
     "inputs": ["app_name", "features", "database"],
     "outputs": ["project_directory", "file_list"],
     "domain": "web-development",
     "keywords": ["api", "fastapi", "scaffold", "crud"]
   }
   ```

4. **Categorize by domain**
   - web-development
   - devops
   - data-engineering
   - security
   - testing
   - database
   - ai-ml
   - (etc.)

**Output:** Capability map for all 400+ plugins

#### Sub-Agent 2: Integration Pattern Analyzer

**Purpose:** Understand how plugins connect and compose

**Process:**
1. **Map input/output compatibility**
   ```
   Plugin A outputs: { api_endpoint: "string" }
   Plugin B accepts: { target_url: "string" }

   Compatible? Yes (both use string URLs)
   Mapping: api_endpoint → target_url
   ```

2. **Identify common sequences**
   ```
   Pattern discovered:
   scaffolder → database-setup → orm-integration → test-generator

   Frequency: 34 occurrences
   Success rate: 0.89
   Domain: web-development
   ```

3. **Detect dependencies**
   ```
   Plugin: kubernetes-deployer
   Requires:
     - docker-builder (container images must exist)
     - kubectl-config (cluster access required)

   Dependency chain:
   docker-builder → kubernetes-deployer → kubectl-config
   ```

4. **Analyze data flow**
   ```
   csv-parser → data-transformer → validator → db-loader

   Data types:
   csv-parser: outputs DataFrame
   data-transformer: accepts DataFrame, outputs DataFrame
   validator: accepts DataFrame, outputs ValidationResult
   db-loader: accepts DataFrame + ValidationResult
   ```

**Output:** Integration graph showing plugin relationships

#### Sub-Agent 3: Success Rate Analyzer

**Purpose:** Identify which plugins are reliable and when

**Process:**
1. **Analyze usage patterns** (if telemetry available)
   ```
   Plugin: jwt-auth-plugin
   Total invocations: 1,247
   Successful: 1,110
   Failed: 137
   Success rate: 89%

   Common failures:
   - Missing secret key (45 occurrences)
   - Invalid token format (32 occurrences)
   - Expired tokens (28 occurrences)
   ```

2. **Identify context factors**
   ```
   Success rate varies by context:

   With Redis caching: 95% success
   Without caching: 82% success

   Recommendation: Suggest Redis when using JWT auth
   ```

3. **Document known issues**
   ```
   Known failure modes:
   1. Missing dependency: python-jose not installed
      Fix: pip install python-jose

   2. Configuration error: No SECRET_KEY in environment
      Fix: Export SECRET_KEY before running

   3. Version incompatibility: Requires FastAPI >= 0.95.0
      Fix: Update FastAPI to compatible version
   ```

4. **Rank plugins by reliability**
   ```
   For domain: web-development/authentication

   Ranked by success rate:
   1. jwt-auth-plugin (89%, 1247 uses)
   2. oauth2-integration (85%, 892 uses)
   3. basic-auth-setup (78%, 234 uses)
   ```

**Output:** Reliability scores and failure mode documentation

### Parallel Research Execution

All three sub-agents run simultaneously:

```
Time 0:00 - User requests: "Build API with auth"

Time 0:01 - Spawn 3 sub-agents:
  [Agent 1] Analyzing capabilities for 'api' and 'auth' keywords...
  [Agent 2] Mapping integration patterns for 'api' and 'auth' plugins...
  [Agent 3] Retrieving success rates for 'api' and 'auth' workflows...

Time 0:03 - Sub-agents working in parallel:
  [Agent 1] Found 23 relevant plugins
  [Agent 2] Identified 7 common integration patterns
  [Agent 3] Analyzed success rates for 15 plugins

Time 0:05 - All sub-agents complete, synthesizing results...

Total research time: 5 minutes (vs 15+ minutes sequential)
```

**Why parallel matters:**
- **3x faster wall-clock time** (same token budget, faster results)
- **Fresh context per sub-agent** (no degradation from overloaded context)
- **Specialized focus** (each agent optimized for specific analysis type)

### Research Output Format

After parallel research, the skill produces a comprehensive research report:

```markdown
## Research Report: API with Authentication

### Relevant Plugins (23 found)

#### Structure/Scaffolding
- fastapi-scaffolder (95% success, web-dev)
- flask-starter (87% success, web-dev)
- express-generator (82% success, web-dev)

#### Authentication
- jwt-auth-plugin (89% success, security)
- oauth2-integration (85% success, security)
- basic-auth-setup (78% success, security)

#### Testing
- api-tester (91% success, testing)
- postman-generator (84% success, testing)

### Recommended Patterns (3 patterns)

#### Pattern 1: FastAPI + JWT + Redis
- Sequence: fastapi-scaffolder → jwt-auth-plugin → redis-cache-plugin → api-tester
- Success rate: 92%
- Avg time: 12 minutes
- Used 47 times

#### Pattern 2: Flask + OAuth2
- Sequence: flask-starter → oauth2-integration → api-tester
- Success rate: 85%
- Avg time: 15 minutes
- Used 23 times

#### Pattern 3: Express + Basic Auth
- Sequence: express-generator → basic-auth-setup → api-tester
- Success rate: 78%
- Avg time: 10 minutes
- Used 12 times

### Recommendation

Use **Pattern 1 (FastAPI + JWT + Redis)** because:
- Highest success rate (92%)
- Most usage (47 times, proven in production)
- Modern stack (FastAPI is fast, JWT is standard, Redis is reliable)
- Good balance of speed (12 min) and quality (92% success)

### Next Steps

Proceed to **Plan Phase** to generate detailed workflow for Pattern 1
```

This research report feeds into the Planning Phase for workflow generation.

---

## Planning Phase Process (Detailed)

After research identifies relevant plugins and patterns, the planning phase generates a detailed execution workflow.

### Step 1: Task Decomposition

Break user's high-level request into concrete subtasks:

**Example:**
```
User request: "Build REST API with JWT auth and Redis caching"

Decomposition:
1. Create API project structure
2. Define data models and routes
3. Integrate JWT authentication
4. Add Redis caching layer
5. Configure rate limiting
6. Generate API documentation
7. Create tests
8. Validate complete system
```

**Decomposition principles:**
- Each subtask should be atomic (one clear responsibility)
- Subtasks should be ordered by dependencies (structure before auth, etc.)
- Each subtask maps to ≥1 plugin capability

### Step 2: Plugin-to-Subtask Mapping

Match each subtask to the best plugin:

```
Subtask 1: Create API structure
  Candidates:
    - fastapi-scaffolder (95% success, 234 uses)
    - flask-starter (87% success, 123 uses)

  Selected: fastapi-scaffolder
  Reason: Higher success rate, more usage, aligns with research recommendation

Subtask 2: Define models and routes
  Candidates:
    - pydantic-model-generator (89% success)
    - sqlalchemy-setup (92% success)

  Selected: Both (Pydantic for validation, SQLAlchemy for persistence)
  Reason: Complementary capabilities

Subtask 3: Integrate JWT auth
  Candidates:
    - jwt-auth-plugin (89% success, 1247 uses)
    - oauth2-integration (85% success, 892 uses)

  Selected: jwt-auth-plugin
  Reason: Matches user's explicit requirement ("JWT auth")

... (continue for all subtasks)
```

### Step 3: Workflow Sequencing

Order plugin invocations based on dependencies:

**Dependency graph:**
```
fastapi-scaffolder
       ↓
pydantic-model-generator + sqlalchemy-setup
       ↓
jwt-auth-plugin
       ↓
redis-cache-plugin
       ↓
rate-limiter-plugin
       ↓
api-docs-generator
       ↓
test-generator
       ↓
api-tester (validation)
```

**Rationale for sequence:**
1. Structure must exist before adding features
2. Models must be defined before auth can use them
3. Auth must work before caching (cache authenticated responses)
4. Caching must work before rate limiting (rate limit after cache check)
5. All features must work before generating docs
6. Tests created last (test all integrated features)
7. Validation verifies everything works together

### Step 4: Input/Output Data Flow

Define what data flows between plugins:

```
Step 1: fastapi-scaffolder
  Input: { app_name: "my-api", template: "minimal" }
  Output: {
    project_path: "./my-api",
    files_created: ["main.py", "config.py", "requirements.txt"],
    entry_point: "main.py"
  }

Step 2: pydantic-model-generator
  Input: {
    project_path: "./my-api",  # From Step 1
    models: ["User", "Product", "Order"]
  }
  Output: {
    models_file: "./my-api/models.py",
    schemas_defined: ["User", "Product", "Order"]
  }

Step 3: jwt-auth-plugin
  Input: {
    project_path: "./my-api",  # From Step 1
    user_model: "User"          # From Step 2
  }
  Output: {
    auth_routes: ["POST /login", "POST /register", "GET /me"],
    middleware_added: "JWTMiddleware",
    config_required: ["SECRET_KEY", "ALGORITHM"]
  }

... (continue for all steps)
```

**Data flow validation:**
- Ensure every plugin's inputs are satisfied by previous outputs
- Flag missing dependencies early (avoid runtime failures)
- Document configuration requirements (env vars, secrets, etc.)

### Step 5: Validation Checkpoints

Define how to verify each step succeeds:

```
Step 1: fastapi-scaffolder
  Validation:
    - Check files exist: main.py, config.py, requirements.txt
    - Verify Python syntax: python -m py_compile main.py
    - Test imports: python -c "import main"

  Success criteria:
    ✓ All expected files created
    ✓ No syntax errors
    ✓ Main module importable

Step 2: pydantic-model-generator
  Validation:
    - Check models.py exists
    - Verify Pydantic schemas valid: python -c "from models import User"
    - Test serialization: user = User(name="test"); user.dict()

  Success criteria:
    ✓ Models file created
    ✓ Schemas importable
    ✓ Serialization works

Step 3: jwt-auth-plugin
  Validation:
    - Check auth routes defined: grep "POST /login" main.py
    - Verify JWT creation: curl POST /register (should return token)
    - Test token validation: curl GET /me -H "Authorization: Bearer <token>"

  Success criteria:
    ✓ Auth endpoints exist
    ✓ Token creation works
    ✓ Token validation works

... (continue for all steps)
```

### Step 6: Error Handling Strategy

Plan how to handle failures:

```
For each step:

1. Retry strategy
   - Transient errors: Retry up to 3 times with exponential backoff
   - Persistent errors: Move to fallback or manual intervention

2. Fallback options
   - If plugin A fails, try plugin B (alternative)
   - If no alternatives, alert user

3. Rollback procedure
   - If critical step fails, undo previous steps
   - Restore to known-good state

Example:
Step 3 (jwt-auth-plugin) fails with "Module not found: python-jose"
  → Retry 1: Install dependency (pip install python-jose), retry plugin
  → If still fails: Try fallback plugin (oauth2-integration)
  → If fallback fails: Alert user with error details
```

### Planning Phase Output

The planning phase produces a detailed workflow specification:

```yaml
workflow_id: rest-api-jwt-redis-workflow
created: 2025-11-07T18:00:00Z
task_description: "Build REST API with JWT auth and Redis caching"
estimated_time: 12_minutes
estimated_success_rate: 0.92

steps:
  - step: 1
    plugin: fastapi-scaffolder
    purpose: Create API project structure
    inputs:
      app_name: "my-api"
      template: "minimal"
    outputs:
      project_path: "./my-api"
      files_created: ["main.py", "config.py", "requirements.txt"]
    validation:
      - check_files_exist: ["main.py", "config.py"]
      - verify_syntax: "python -m py_compile main.py"
    retry_strategy: "3_attempts_with_backoff"
    fallback: "flask-starter"

  - step: 2
    plugin: jwt-auth-plugin
    purpose: Add JWT authentication
    inputs:
      project_path: "./my-api"  # From step 1
      user_model: "User"
    outputs:
      auth_routes: ["POST /login", "POST /register"]
      middleware: "JWTMiddleware"
    validation:
      - check_routes_exist: ["POST /login"]
      - test_token_creation: "curl POST /register"
    retry_strategy: "3_attempts_with_backoff"
    fallback: "oauth2-integration"

  # ... (continue for all 8 steps)

environment_requirements:
  - SECRET_KEY: "Generated JWT secret key"
  - REDIS_URL: "redis://localhost:6379"
  - DATABASE_URL: "postgresql://localhost/mydb"

dependencies:
  - python-jose>=3.3.0
  - redis>=4.0.0
  - sqlalchemy>=2.0.0

final_validation:
  - run_tests: "pytest tests/"
  - test_api_health: "curl GET /health"
  - verify_auth_flow: "Complete login → access protected route"

rollback_procedure:
  - "git reset --hard HEAD"  # If using version control
  - "rm -rf ./my-api"         # Or delete project directory
```

This workflow specification is passed to the Implementation Phase for execution.

---

## Implementation Phase Process (Detailed)

The implementation phase executes the workflow generated during planning, with continuous validation and error handling.

### Execution Engine

**Core execution loop:**

```python
def execute_workflow(workflow_spec):
    """Execute workflow with validation and error handling"""

    for step in workflow_spec.steps:
        print(f"⚙️ Executing Step {step.number}: {step.purpose}")

        # Invoke plugin
        result = invoke_plugin(
            plugin_name=step.plugin,
            inputs=step.inputs
        )

        # Validate outputs
        validation_passed = validate_outputs(
            result=result,
            validation_criteria=step.validation
        )

        if validation_passed:
            print(f"✓ Step {step.number} complete")
            # Store outputs for next step
            context[step.plugin] = result.outputs
        else:
            print(f"✗ Step {step.number} failed validation")
            # Try error recovery
            recovered = handle_failure(step, result)
            if not recovered:
                raise WorkflowExecutionError(f"Step {step.number} failed")

    # Final validation
    print("🔍 Running final validation...")
    final_result = run_final_validation(workflow_spec.final_validation)

    if final_result.success:
        print("✅ Workflow complete!")
        return WorkflowResult(success=True, outputs=context)
    else:
        print("❌ Final validation failed")
        return WorkflowResult(success=False, errors=final_result.errors)
```

### Plugin Invocation

**How plugins are invoked:**

```
Step 1: Invoke fastapi-scaffolder

1. Prepare inputs
   inputs = {
     "app_name": "my-api",
     "template": "minimal"
   }

2. Call plugin
   result = run_plugin("fastapi-scaffolder", inputs)

3. Capture outputs
   outputs = {
     "project_path": "./my-api",
     "files_created": ["main.py", "config.py", "requirements.txt"],
     "success": true
   }

4. Store in context for next steps
   context["scaffolder"] = outputs
```

### Validation Execution

**Continuous validation after each step:**

```
Step 1 validation:

Check 1: Files exist
  Command: ls -la ./my-api/main.py ./my-api/config.py
  Result: ✓ Both files exist

Check 2: Syntax valid
  Command: python -m py_compile ./my-api/main.py
  Result: ✓ No syntax errors

Check 3: Module importable
  Command: python -c "import sys; sys.path.insert(0, './my-api'); import main"
  Result: ✓ Import successful

Overall: ✓ Step 1 validation passed
```

### Error Recovery

**Multi-level error handling:**

**Level 1: Retry with backoff**
```
Attempt 1: Invoke jwt-auth-plugin
  Result: ModuleNotFoundError: python-jose

Retry strategy: Exponential backoff
  Wait: 2 seconds

Attempt 2: Install dependency + retry
  Command: pip install python-jose
  Result: Successfully installed
  Retry plugin: jwt-auth-plugin
  Result: ✓ Success
```

**Level 2: Fallback to alternative plugin**
```
Attempt 1: Invoke jwt-auth-plugin
  Result: Incompatible with FastAPI 0.110.0

Retry 1-3: All failed

Fallback: Try oauth2-integration
  Inputs: Same as jwt-auth-plugin (converted)
  Result: ✓ Success (using OAuth2 instead of JWT)

Note: User wanted JWT, but OAuth2 works. Alert user to change.
```

**Level 3: Manual intervention**
```
Attempt 1: Invoke redis-cache-plugin
  Result: Cannot connect to Redis (connection refused)

Retry 1-3: All failed

Fallback: No alternative caching plugin

Manual intervention required:
  1. Alert user: "Redis connection failed. Please start Redis server."
  2. Provide instructions: "Run: redis-server"
  3. Wait for user confirmation
  4. Retry redis-cache-plugin
```

### Progress Tracking

**Real-time feedback during execution:**

```
🔧 Executing workflow: REST API with JWT auth and Redis caching
   Estimated time: 12 minutes
   Steps: 8

⚙️ Step 1/8: Create API structure (fastapi-scaffolder)
   Status: Running...
   [████████████████░░░░] 80%
   Status: ✓ Complete (2 min)

⚙️ Step 2/8: Add JWT authentication (jwt-auth-plugin)
   Status: Running...
   [████████████████████] 100%
   Status: ✓ Complete (3 min)

⚙️ Step 3/8: Setup Redis caching (redis-cache-plugin)
   Status: Running...
   [████████░░░░░░░░░░░░] 40%
   Status: ⚠️ Waiting for Redis connection...
   Status: ✓ Complete (4 min, with retry)

... (continue for all steps)

🔍 Final Validation
   Running tests...
   [████████████████████] 100%
   Status: ✓ All tests passed

✅ Workflow complete!
   Total time: 11 minutes
   Success rate: 100% (8/8 steps)
```

### Output Collection

**Collect and structure workflow results:**

```json
{
  "workflow_id": "rest-api-jwt-redis-workflow",
  "status": "success",
  "execution_time": "11_minutes",
  "steps_completed": 8,
  "steps_failed": 0,
  "outputs": {
    "project_path": "./my-api",
    "api_endpoints": [
      "POST /register",
      "POST /login",
      "GET /me",
      "GET /health"
    ],
    "features": [
      "JWT authentication",
      "Redis caching",
      "Rate limiting",
      "API documentation"
    ],
    "test_results": {
      "total": 24,
      "passed": 24,
      "failed": 0
    },
    "documentation_url": "http://localhost:8000/docs"
  },
  "learnings": {
    "pattern_used": "fastapi-jwt-redis",
    "modifications": [],
    "success": true
  }
}
```

This output feeds into the Learning Phase for pattern extraction.

---

## Learning Phase Process (Detailed)

After each workflow execution, the skill extracts patterns and updates its knowledge base.

### Pattern Extraction

**What gets recorded:**

```yaml
# New pattern or update to existing pattern
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

    # ... (all plugins in sequence)

  metrics:
    total_executions: 48  # Incremented from 47
    successful_executions: 44  # Incremented
    failed_executions: 4
    success_rate: 0.9167  # Recalculated
    avg_completion_time: 11.5_min  # Updated average

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

### Pattern Storage: Dual-Write Strategy (File + Neo4j)

**🔒 CRITICAL:** After extracting a pattern, ALWAYS save to BOTH file system AND Neo4j

**Step 1: Save to file system (reliable primary)**
```bash
# Create pattern file
PATTERN_FILE=~/.claude/skills/agentops-orchestrator/patterns/discovered/${PATTERN_ID}.yaml
# Write YAML content
```

**Step 2: Save to Neo4j (intelligent secondary)**
```cypher
// Create or update pattern node
MERGE (p:Pattern {pattern_id: $pattern_id})
SET p.name = $name,
    p.description = $description,
    p.category = $category,
    p.success_rate = $success_rate,
    p.executions = $executions,
    p.status = $status,
    p.workflow_steps = $workflow_steps,
    p.last_used = datetime()

// Link to plugins used
UNWIND $plugins AS plugin_data
MATCH (plugin:Plugin {name: plugin_data.name})
MERGE (p)-[:USES {
  step_number: plugin_data.step,
  required: plugin_data.required
}]->(plugin)
```

**Step 3: Record execution**
```cypher
// Track this execution
CREATE (e:Execution {
  execution_id: $exec_id,
  task_description: $task,
  status: $status,
  duration_ms: $duration,
  started_at: datetime($started),
  completed_at: datetime($completed)
})

// Link execution to pattern and plugins
MATCH (pat:Pattern {pattern_id: $pattern_id})
CREATE (e)-[:IMPLEMENTS]->(pat)

UNWIND $plugins_used AS plugin_name
MATCH (p:Plugin {name: plugin_name})
CREATE (p)-[:EXECUTED_IN {
  step: plugin_name.step,
  duration_ms: plugin_name.duration,
  status: 'success'
}]->(e)
```

**Step 4: Update metrics**
```cypher
// Recalculate pattern success rate
MATCH (pat:Pattern {pattern_id: $pattern_id})<-[:IMPLEMENTS]-(exec:Execution)
WITH pat,
     COUNT(exec) AS total,
     SUM(CASE WHEN exec.status = 'success' THEN 1 ELSE 0 END) AS successes
SET pat.executions = total,
    pat.success_rate = toFloat(successes) / total
```

**Step 5: Check pattern promotion**
```cypher
// Auto-promote based on metrics
MATCH (p:Pattern)
WHERE p.executions >= 20 AND p.success_rate >= 0.90
SET p.status = 'learned'

MATCH (p:Pattern)
WHERE p.executions >= 5 AND p.success_rate >= 0.80 AND p.status = 'discovered'
SET p.status = 'validated'
```

**Fallback behavior:** If Neo4j save fails, pattern still saved to file (primary storage). Next execution will retry Neo4j sync.

**What gets created:**
- ✅ Pattern YAML file in `patterns/discovered/` (or validated/learned)
- ✅ Pattern node in Neo4j with relationships
- ✅ Execution node tracking this run
- ✅ Updated metrics in both file logs and graph database
- ✅ Automatic pattern promotion (discovered → validated → learned)
   Line: 2025-11-07T18:30:00Z,rest-api-jwt-redis-v1,0.9167

5. Update pattern README:
   File: ~/.claude/skills/agentops-orchestrator/patterns/README.md
   Add: Pattern summary with usage count and success rate

Result: Pattern is now persisted and available for future orchestrations
```

**Pattern Lifecycle Directories:**

- **discovered/** - New patterns (1-4 executions, unproven)
- **validated/** - Proven patterns (5-19 executions, 80%+ success)
- **learned/** - Production patterns (20+ executions, 90%+ success)

**Move patterns between directories as they mature:**
```bash
# After 5th successful execution
mv discovered/pattern.yaml validated/pattern.yaml

# After 20th successful execution with 90%+ success rate
mv validated/pattern.yaml learned/pattern.yaml
```

### Pattern Matching Algorithm

**How patterns are matched to future tasks:**

**Step 1: Load all available patterns from file system**
```bash
# Read all pattern files from the three directories
LEARNED_PATTERNS=$(find ~/.claude/skills/agentops-orchestrator/patterns/learned -name "*.yaml")
VALIDATED_PATTERNS=$(find ~/.claude/skills/agentops-orchestrator/patterns/validated -name "*.yaml")
DISCOVERED_PATTERNS=$(find ~/.claude/skills/agentops-orchestrator/patterns/discovered -name "*.yaml")

# Parse YAML files into pattern_library list
# Prioritize: learned > validated > discovered
```

**Step 2: Match patterns to user request**
```python
def match_patterns(user_request, pattern_library):
    """Find best-matching patterns for user's task"""

    # 1. Extract keywords from user request
    keywords = extract_keywords(user_request)
    # Example: ["build", "api", "authentication", "caching"]

    # 2. Find patterns with matching keywords
    candidates = []
    for pattern in pattern_library:
        overlap = set(keywords) & set(pattern.task_keywords)
        if len(overlap) >= 2:  # At least 2 matching keywords
            score = len(overlap) / len(pattern.task_keywords)
            candidates.append((pattern, score))

    # 3. Rank by multiple factors
    ranked = rank_patterns(candidates, factors={
        "keyword_match": 0.4,    # 40% weight
        "success_rate": 0.3,     # 30% weight
        "usage_count": 0.2,      # 20% weight
        "recency": 0.1           # 10% weight
    })

    # 4. Return top 3 patterns
    return ranked[:3]
```

**Example matching:**

```
User request: "Build API with authentication and caching"

Keywords extracted: ["build", "api", "authentication", "caching"]

Pattern candidates:
1. rest-api-jwt-redis-v1
   - Matching keywords: ["api", "authentication", "caching"] (3/4 = 75%)
   - Success rate: 0.92 (excellent)
   - Usage count: 48 (well-tested)
   - Recency: 2 days ago
   → Score: 0.89

2. flask-api-basic-auth-v1
   - Matching keywords: ["api", "authentication"] (2/4 = 50%)
   - Success rate: 0.78 (good)
   - Usage count: 12 (less tested)
   - Recency: 30 days ago
   → Score: 0.61

3. graphql-api-auth-v1
   - Matching keywords: ["api", "authentication"] (2/4 = 50%)
   - Success rate: 0.85 (very good)
   - Usage count: 8 (minimal testing)
   - Recency: 60 days ago
   → Score: 0.58

Recommendation: Use pattern 1 (rest-api-jwt-redis-v1)
Confidence: High (score 0.89, significantly better than alternatives)
```

### Success Metrics Tracking

**What gets measured:**

```yaml
global_metrics:
  total_workflows_executed: 1247
  successful_workflows: 1134
  failed_workflows: 113
  overall_success_rate: 0.909

  avg_speedup: 4.2x  # vs manual plugin selection
  avg_time_saved: 23_minutes_per_workflow

  total_patterns: 87
  active_patterns: 72  # Used in last 30 days
  deprecated_patterns: 15  # Success rate < 60%

  total_plugins_analyzed: 412
  plugins_with_usage_data: 203
  plugins_never_used: 89

  top_domains:
    - web-development: 423 workflows
    - devops: 312 workflows
    - data-engineering: 198 workflows
    - security: 145 workflows
    - testing: 89 workflows

plugin_metrics:
  - plugin: fastapi-scaffolder
    total_uses: 234
    success_rate: 0.95
    avg_execution_time: 2.3_min
    last_used: 2025-11-07

  - plugin: jwt-auth-plugin
    total_uses: 189
    success_rate: 0.89
    avg_execution_time: 3.1_min
    last_used: 2025-11-07

  # ... (all 412 plugins)
```

### Continuous Improvement

**How the skill gets better over time:**

**Week 1:**
```
Patterns: 12
Avg success rate: 75%
Avg speedup: 2.1x
```

**Month 1:**
```
Patterns: 45
Avg success rate: 83%
Avg speedup: 3.4x

Improvements:
- 33 new patterns discovered
- 8 patterns deprecated (low success rate)
- Plugin rankings updated based on 150+ workflows
```

**Month 3:**
```
Patterns: 87
Avg success rate: 91%
Avg speedup: 4.2x

Improvements:
- 42 new patterns discovered
- Pattern matching algorithm improved (keyword + success + recency)
- Error handling enhanced (12 new known issues documented)
- 203 plugins now have real usage data (vs guesses)
```

**Result:** The more the skill is used, the better it gets at recommending optimal workflows.

---

## Integration

This skill integrates with the broader AgentOps ecosystem:

### Integration with Other AgentOps Commands

**Research Phase** (`/research`)
```bash
# Use meta-orchestrator to research plugin capabilities
/research "What plugins are available for API development?"

# Skill activates, provides comprehensive plugin analysis
```

**Planning Phase** (`/plan`)
```bash
# Load research from meta-orchestrator
/plan meta-orchestrator-api-research

# Generate workflow specification using discovered patterns
```

**Implementation Phase** (`/implement`)
```bash
# Execute workflow generated by meta-orchestrator
/implement meta-orchestrator-api-plan

# Skill orchestrates plugin sequence with validation
```

**Learning Phase** (`/learn`)
```bash
# Extract patterns after workflow execution
/learn meta-orchestrator-api-workflow

# Update pattern library with new learnings
```

### Integration with Other Agent Skills

**Skill composition:**
```
Meta-orchestrator can invoke other skills:
- /skill code-analyzer (to understand existing code before adding features)
- /skill test-generator (to create tests for orchestrated workflow)
- /skill documentation-writer (to document generated API)

Other skills can invoke meta-orchestrator:
- /skill devops-automation (use meta-orchestrator to find best CI/CD plugins)
- /skill security-auditor (use meta-orchestrator to find vulnerability scanners)
```

**Example:**
```
User: "Audit my API for security issues and deploy to production"

Skill orchestration:
1. Meta-orchestrator finds security plugins
2. Invokes /skill security-auditor with plugin list
3. Security auditor analyzes code, finds issues
4. Meta-orchestrator finds fix plugins
5. Applies fixes automatically
6. Meta-orchestrator finds deployment plugins
7. Invokes /skill devops-automation to deploy

Result: Security audit → fixes → deployment, all orchestrated
```

### Integration with Workflow Operators

**The meta-orchestrator works with AgentOps workflow operators:**

**Workflow Operator (validates workflow execution)**
```
Meta-orchestrator generates workflow →
Workflow Operator validates each step →
Ensures outputs match expected schema →
Rejects invalid results, provides feedback
```

**Context Operator (prevents context collapse)**
```
Meta-orchestrator uses multi-agent research →
Context Operator monitors token usage →
If exceeding 40%, triggers checkpoint →
Resume in fresh session with context bundle
```

**Memory Operator (maintains pattern library)**
```
Meta-orchestrator records new patterns →
Memory Operator organizes pattern library →
Deduplicates similar patterns →
Archives outdated patterns →
Ensures pattern library stays navigable
```

**Result:** Reliable, self-improving meta-orchestration system

---

## Reference Materials

This skill includes templates and references in the `references/` directory:

### plugin-analyzer-template.md

Template for sub-agents analyzing individual plugins. Includes:
- Capability extraction checklist
- Input/output identification guide
- Integration pattern recognition
- Dependency detection process

See: `skills/agentops-orchestrator/references/plugin-analyzer-template.md`

### pattern-library-template.md

Template for recording discovered workflow patterns. Includes:
- Pattern structure (name, sequence, metrics)
- Common archetypes (sequential, parallel, conditional, feedback)
- Success criteria definition
- Failure mode documentation

See: `skills/agentops-orchestrator/references/pattern-library-template.md`

### marketplace-sources.md

List of all plugin marketplaces analyzed by this skill. Includes:
- Marketplace URLs and installation instructions
- Plugin counts and categories
- Update frequency and maintenance status

See: `skills/agentops-orchestrator/references/marketplace-sources.md`

---

## Scripts

Automation scripts are provided in `scripts/` directory:

### install-marketplaces.sh

Automated installation of all 3 plugin marketplaces:
- claude-code-templates (NPM)
- wshobson/agents (Claude Code marketplace)
- jeremylongshore/claude-code-plugins-plus (Claude Code marketplace)

See: `skills/agentops-orchestrator/scripts/install-marketplaces.sh`

---

## Version History

### 0.1.0 (2025-11-07) - Initial Release

**Features:**
- Multi-agent parallel research of 400+ plugins
- Pattern-based workflow generation
- Continuous validation during execution
- Learning from successful and failed workflows
- Pattern library with 0 initial patterns (grows with usage)

**Known Limitations:**
- No pattern sharing across users yet
- Pattern matching is keyword-based (not semantic)
- No visualization of workflows (text-only)
- Limited error recovery (retry + fallback only)

**Future Improvements:**
- Semantic pattern matching (understand intent, not just keywords)
- Community pattern sharing (shared pattern library)
- Workflow visualization (diagrams showing plugin sequences)
- Advanced error recovery (self-healing workflows)
- ML-based success prediction (predict workflow success before execution)

---

**Skill Status:** Alpha - Ready for testing and feedback

**License:** Apache-2.0 (code) + CC BY-SA 4.0 (documentation)

**Support:** https://github.com/agentops/agentops/issues
