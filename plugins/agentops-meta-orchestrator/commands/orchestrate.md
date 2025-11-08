---
description: Request intelligent plugin orchestration for complex tasks
---

# /orchestrate - Plugin Meta-Orchestration Command

**Purpose:** Automatically analyze 400+ plugins, discover workflow patterns, and execute optimal plugin sequences for complex multi-step tasks.

**When to use:**
- Complex tasks requiring multiple plugins
- Need guidance on which plugins to use
- Want optimal plugin workflow for a goal
- Looking for proven patterns that work

**Token budget:** 40-80k tokens (Research→Plan→Implement→Learn)

**Output:** Task completed using optimal plugin orchestration

**🔒 LEARN PHASE ENFORCEMENT:** This command ALWAYS records the workflow execution to the pattern library. Pattern recording is AUTOMATIC and MANDATORY, not optional. If the workflow completes but patterns aren't updated, the command FAILED.

---

## What This Command Does

The `/orchestrate` command activates the AgentOps Meta-Orchestrator skill, which:

1. **Researches** your task to understand requirements
2. **Analyzes** 400+ plugins across 3 marketplaces to find relevant capabilities
3. **Discovers** proven patterns for similar tasks
4. **Generates** an optimal workflow (plugin sequence)
5. **Executes** the workflow with continuous validation
6. **Learns** from the execution to improve future recommendations

**Think of it as:** An AI that knows how to use 400+ AI tools and automatically chooses the best combination for your task.

---

## Basic Usage

```bash
/orchestrate "[your task description]"
```

**Examples:**

```bash
# Example 1: Web development
/orchestrate "Build a REST API with JWT authentication and Redis caching"

# Example 2: DevOps
/orchestrate "Create CI/CD pipeline with Docker, Kubernetes, and GitHub Actions"

# Example 3: Data engineering
/orchestrate "ETL pipeline to transform CSV data and load into BigQuery"

# Example 4: Security
/orchestrate "Audit codebase for vulnerabilities and apply recommended fixes"
```

---

## How It Works (4 Phases)

### Phase 1: Research (Automatic)

The command spawns 3 sub-agents to analyze plugins in parallel:

```
⚙️ Phase 1: Researching plugins...

[Agent 1] Analyzing plugin capabilities for keywords: [api, auth, caching]
[Agent 2] Mapping integration patterns...
[Agent 3] Checking success rates and known issues...

✓ Research complete (5 minutes)
  - Found 23 relevant plugins
  - Identified 3 proven patterns
  - Analyzed 15 plugin integrations
```

### Phase 2: Plan (Automatic)

The command synthesizes research to generate an optimal workflow:

```
⚙️ Phase 2: Planning workflow...

Selected pattern: "REST API with JWT + Redis" (92% success rate, 48 uses)

Workflow sequence:
  1. fastapi-scaffolder → Create API structure
  2. jwt-auth-plugin → Add JWT authentication
  3. redis-cache-plugin → Setup caching layer
  4. rate-limiter-plugin → Configure rate limiting
  5. api-tester → Validate complete system

Estimated time: 12 minutes
Confidence: High (pattern well-tested)

✓ Plan complete
```

### Phase 3: Implement (Automatic with Progress)

The command executes the workflow with continuous validation:

```
⚙️ Phase 3: Executing workflow...

[Step 1/5] Creating API structure (fastapi-scaffolder)
  Status: Running...
  ✓ Complete (2 min)

[Step 2/5] Adding JWT authentication (jwt-auth-plugin)
  Status: Running...
  ⚠️ Missing dependency: python-jose
  Status: Installing dependency...
  Status: Retrying plugin...
  ✓ Complete (4 min)

[Step 3/5] Setup Redis caching (redis-cache-plugin)
  Status: Running...
  ✓ Complete (3 min)

[Step 4/5] Configure rate limiting (rate-limiter-plugin)
  Status: Running...
  ✓ Complete (2 min)

[Step 5/5] Validate system (api-tester)
  Status: Running tests...
  ✓ All tests passed (1 min)

✓ Workflow complete (12 min total)
```

### Phase 4: Learn (AUTOMATIC - MANDATORY)

**🔒 ENFORCEMENT:** This phase ALWAYS executes. Pattern recording is NOT optional.

The command records the successful execution for future use:

```
⚙️ Phase 4: Recording learnings (AUTOMATIC)...

Pattern updated: "REST API with JWT + Redis"
  - Execution count: 48 → 49
  - Success rate: 0.92 (maintained)
  - Known issue added: "Requires python-jose dependency"

Writing/updating pattern files:
  ✓ patterns/discovered/rest-api-jwt-redis-v1.yaml (updated)

Updating metrics:
  ✓ global_metrics.yaml (total_workflows: +1, success: +1)
  ✓ executions.log (1 entry added)
  ✓ success_rates.log (pattern rate updated)

Checking pattern promotion:
  → Pattern has 49 uses (discovered → validated promotion at 5 uses)
  ✓ Pattern promoted to validated/ (80%+ success, 5+ uses)

✓ Learning complete
  ✓ Pattern recorded/updated in library
  ✓ Metrics updated
  ✓ Pattern available for future similar tasks
```

**What gets created/updated:**
- ✅ Pattern YAML file (created or updated)
- ✅ Updated `patterns/README.md`
- ✅ Updated `metrics/global_metrics.yaml`
- ✅ Updated execution logs
- ✅ Pattern promotion check (discovered → validated → learned)

**If you don't see this confirmation, the Learn phase FAILED and must be re-executed.**

---

## What Gets Created

After `/orchestrate` completes:

### 1. Your Task Output

Whatever you requested (API, pipeline, deployment, etc.) fully working and validated.

### 2. Execution Report

```markdown
# Orchestration Report

Task: "Build REST API with JWT authentication and Redis caching"
Pattern: rest-api-jwt-redis-v1
Status: ✅ Success

## Workflow Executed
1. fastapi-scaffolder (2 min) ✅
2. jwt-auth-plugin (4 min) ✅
3. redis-cache-plugin (3 min) ✅
4. rate-limiter-plugin (2 min) ✅
5. api-tester (1 min) ✅

## Results
- Total time: 12 minutes
- Tests passed: 24/24
- API endpoints: 5
- Documentation: http://localhost:8000/docs

## Issues Encountered
- Missing python-jose dependency (auto-fixed)

## Recommendation
Pattern "REST API with JWT + Redis" performed well.
Confidence for future use: High (92% success rate)
```

### 3. Updated Pattern Library (AUTOMATIC)

Your execution is AUTOMATICALLY added to the pattern library:

**Files Updated:**
- `patterns/discovered/{pattern-id}.yaml` (or validated/learned)
- `patterns/README.md` (pattern counts updated)
- `metrics/global_metrics.yaml` (execution counts, success rates)
- `metrics/executions.log` (workflow logged)
- `metrics/success_rates.log` (pattern success tracked)

**This happens automatically. If these files aren't updated, the Learn phase failed.**

---

## Advanced Usage

### Specify Constraints

```bash
# Prefer specific technology
/orchestrate "Build API with authentication [prefer: fastapi, jwt]"

# Avoid certain tools
/orchestrate "Build API with authentication [avoid: oauth]"

# Time constraints
/orchestrate "Build API with authentication [max-time: 10min]"

# Quality requirements
/orchestrate "Build API with authentication [quality: production-ready]"
```

### Domain-Specific Orchestration

```bash
# Web development focus
/orchestrate "Build full-stack app [domain: web-development]"

# DevOps focus
/orchestrate "Setup infrastructure [domain: devops]"

# Security focus
/orchestrate "Harden application [domain: security]"
```

### Pattern Exploration

```bash
# See available patterns before choosing
/orchestrate --show-patterns "Build API with authentication"

# Output:
#   Found 3 patterns:
#   1. REST API with JWT + Redis (92% success, 48 uses) ⭐ Recommended
#   2. GraphQL API with OAuth2 (85% success, 23 uses)
#   3. gRPC API with mTLS (78% success, 12 uses)
#
# Choose pattern [1/2/3] or proceed with recommendation:
```

### Dry Run (Plan Only)

```bash
# See workflow without executing
/orchestrate --plan-only "Build API with authentication"

# Output: Shows workflow plan, estimated time, plugins to be used
# No execution happens
# Useful for: Previewing before committing, learning plugin sequences
```

---

## Integration with Other Commands

### Research Before Orchestrating

```bash
# First understand what's possible
/research "What plugins are available for API development?"

# Then orchestrate with that knowledge
/orchestrate "Build API with authentication"
```

### Plan-Approve-Implement Workflow

```bash
# Step 1: Generate plan
/orchestrate --plan-only "Build API with authentication"

# Step 2: Review plan (shows plugin sequence)

# Step 3: Approve and execute
/orchestrate --execute "[saved-plan-id]"
```

### Learn from Orchestration

```bash
# After orchestration completes
/learn orchestration-api-auth

# Extract patterns, improvements for future tasks
```

---

## Success Criteria

Orchestration succeeds when:

✅ All plugins in workflow execute successfully
✅ Validation passes at each step
✅ Final output matches task requirements
✅ No unresolved errors
✅ Pattern recorded for future use

**Success indicators you'll see:**
- Green checkmarks (✓) for each step
- "All tests passed" in validation
- Final "✅ Workflow complete"
- **"✅ Learning complete" with pattern files updated** (MANDATORY)

---

## Error Handling

### What Happens If a Plugin Fails?

**Level 1: Auto-retry**
```
[Step 2/5] jwt-auth-plugin
  ✗ Failed: ModuleNotFoundError
  ⚙️ Installing missing dependency...
  ✓ Retry successful
```

**Level 2: Fallback plugin**
```
[Step 2/5] jwt-auth-plugin
  ✗ Failed (3 attempts)
  ⚙️ Trying fallback: oauth2-integration
  ✓ Fallback successful
```

**Level 3: Manual intervention**
```
[Step 3/5] redis-cache-plugin
  ✗ Failed: Cannot connect to Redis

  ⚠️ Manual action required:
    - Start Redis server: redis-server
    - Or install: brew install redis

  Retry after fixing? [y/n]
```

**Level 4: Graceful abort**
```
[Step 3/5] redis-cache-plugin
  ✗ Failed (cannot recover)

  ⚠️ Orchestration aborted

  Completed steps: 2/5
  Partial output available
  To resume: /orchestrate --resume [workflow-id]
```

---

## Performance & Efficiency

### How Fast Is It?

**Typical timing:**
- **Research phase:** 3-5 minutes (parallel sub-agents)
- **Planning phase:** 1-2 minutes (pattern matching)
- **Implementation:** Varies by task (5-30 minutes)
- **Total:** Usually 10-40 minutes for complex tasks

**Speedup vs manual:**
- **3-5x faster** than manually researching and selecting plugins
- **No trial-and-error** (uses proven patterns)
- **Parallel research** (3x faster than sequential)

### Token Budget

**Stays under 40% rule:**
- Research: 15-20k tokens
- Planning: 5-10k tokens
- Implementation: 20-40k tokens
- Learning: 2-5k tokens
- **Total: ~40-75k tokens (20-37.5%)**

**Multi-session for large tasks:**
- Auto-checkpoints if approaching 40%
- Resume in fresh session
- No context collapse

---

## Examples

### Example 1: Web Application

```bash
/orchestrate "Create Next.js app with PostgreSQL backend and deploy to Vercel"
```

**What happens:**
1. Researches Next.js, PostgreSQL, Vercel plugins
2. Finds pattern: "Next.js + Prisma + Vercel deployment"
3. Executes:
   - next-scaffolder (creates app structure)
   - prisma-setup (database schema and ORM)
   - vercel-deploy (deploys to cloud)
4. Validates: App is live and functional
5. Time: ~15 minutes (vs 2+ hours manual)

### Example 2: Data Pipeline

```bash
/orchestrate "ETL pipeline: CSV → transform → validate → BigQuery"
```

**What happens:**
1. Researches ETL, CSV, BigQuery plugins
2. Finds pattern: "CSV ETL to data warehouse"
3. Executes:
   - csv-parser (ingests CSV)
   - data-transformer (applies transformations)
   - validator (checks data quality)
   - bigquery-loader (loads to warehouse)
4. Validates: Data in BigQuery, quality checks passed
5. Time: ~8 minutes (vs 1+ hour manual)

### Example 3: Security Hardening

```bash
/orchestrate "Security audit: scan vulnerabilities, apply fixes, verify"
```

**What happens:**
1. Researches security scanning, fixing plugins
2. Finds pattern: "Security audit + auto-fix"
3. Executes:
   - security-scanner (finds vulnerabilities)
   - sast-analyzer (static analysis)
   - auto-fixer (applies safe fixes)
   - security-verifier (confirms fixes work)
4. Validates: Vulnerabilities reduced, tests still pass
5. Time: ~20 minutes (vs 4+ hours manual)

---

## Troubleshooting

### Issue: "No relevant plugins found"

**Cause:** Task description too vague or niche domain

**Fix:**
```bash
# Be more specific
/orchestrate "Build REST API with FastAPI and JWT"

# Or specify domain
/orchestrate "Build API [domain: web-development]"
```

### Issue: "Pattern match confidence low"

**Cause:** Uncommon task, no proven patterns yet

**Fix:**
```bash
# Use exploratory mode
/orchestrate --explore "Uncommon task description"

# This will still work but may take longer (no shortcuts)
```

### Issue: "Workflow failed mid-execution"

**Cause:** Plugin incompatibility or missing dependencies

**Fix:**
```bash
# Resume from checkpoint
/orchestrate --resume [workflow-id]

# Or start fresh with alternative pattern
/orchestrate --pattern-id alternative-pattern-v1 "Same task"
```

---

## Best Practices

### 1. Be Specific in Task Description

❌ Bad: "Make an API"
✅ Good: "Build REST API with authentication and caching using FastAPI"

### 2. Review Plan Before Large Tasks

```bash
# Preview first
/orchestrate --plan-only "Large complex task"

# Review, then execute
/orchestrate --execute [plan-id]
```

### 3. Let the Skill Choose Plugins

Unless you have specific requirements, trust the pattern library.

❌ Over-specifying: "Use exactly these 5 plugins in this order..."
✅ Trust patterns: "Build API with auth and caching" (skill picks best combo)

### 4. Provide Context for Errors

If workflow fails, tell the skill what changed:

```bash
/orchestrate "Same task [note: Redis now on port 6380]"
```

---

## Related Commands

- **/discover-patterns** - Research patterns without executing
- **/research** - Deep-dive plugin research
- **/plan** - Create custom workflows manually
- **/implement** - Execute pre-approved plans
- **/learn** - Extract patterns from past work

---

## Command Options

```bash
# Basic usage
/orchestrate "[task description]"

# Show available patterns first
/orchestrate --show-patterns "[task]"

# Plan only (no execution)
/orchestrate --plan-only "[task]"

# Execute saved plan
/orchestrate --execute [plan-id]

# Use specific pattern
/orchestrate --pattern-id [pattern-id] "[task]"

# Specify constraints
/orchestrate "[task] [prefer: tech1, tech2] [avoid: tech3]"

# Domain focus
/orchestrate "[task] [domain: web-development]"

# Resume failed workflow
/orchestrate --resume [workflow-id]

# Explore (no patterns, fresh research)
/orchestrate --explore "[task]"
```

---

**Version:** 0.1.0
**Last Updated:** November 7, 2025
**Status:** Active command for meta-orchestrator skill
