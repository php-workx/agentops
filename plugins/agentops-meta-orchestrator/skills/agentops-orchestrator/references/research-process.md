# Research Phase Process

Detailed guide for parallel plugin analysis using 3 specialized sub-agents.

## Sub-Agent Architecture

### Sub-Agent 1: Plugin Capability Extractor

**Purpose:** Understand what each plugin does

**Process:**

1. Read plugin metadata (name, description, keywords, author, version)
2. Analyze documentation (README, usage examples, API definitions)
3. Extract capabilities:

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

4. Categorize by domain: web-development, devops, data-engineering, security, testing, database, ai-ml

### Sub-Agent 2: Integration Pattern Analyzer

**Purpose:** Understand how plugins connect and compose

**Process:**

1. **Map input/output compatibility:**
   ```
   Plugin A outputs: { api_endpoint: "string" }
   Plugin B accepts: { target_url: "string" }
   Compatible? Yes → Mapping: api_endpoint → target_url
   ```

2. **Identify common sequences:**
   ```
   Pattern: scaffolder → database-setup → orm-integration → test-generator
   Frequency: 34 occurrences
   Success rate: 0.89
   ```

3. **Detect dependencies:**
   ```
   kubernetes-deployer requires:
   - docker-builder (container images must exist)
   - kubectl-config (cluster access required)
   ```

4. **Analyze data flow:**
   ```
   csv-parser → data-transformer → validator → db-loader
   DataFrame → DataFrame → ValidationResult → Complete
   ```

### Sub-Agent 3: Success Rate Analyzer

**Purpose:** Identify reliable plugins and contexts

**Process:**

1. **Analyze usage patterns:**
   ```
   jwt-auth-plugin:
   - Total: 1,247 invocations
   - Success: 1,110 (89%)
   - Common failures: Missing secret key (45), Invalid token (32)
   ```

2. **Identify context factors:**
   ```
   Success rate varies:
   - With Redis caching: 95%
   - Without caching: 82%
   - Recommendation: Suggest Redis with JWT
   ```

3. **Document known issues:**
   ```
   Known failures:
   1. Missing dependency: pip install python-jose
   2. No SECRET_KEY in environment
   3. FastAPI version < 0.95.0
   ```

4. **Rank by reliability:**
   ```
   Authentication plugins:
   1. jwt-auth-plugin (89%, 1247 uses)
   2. oauth2-integration (85%, 892 uses)
   3. basic-auth-setup (78%, 234 uses)
   ```

## Parallel Execution Flow

```
Time 0:00 - User request: "Build API with auth"

Time 0:01 - Spawn 3 sub-agents:
  [Agent 1] Analyzing capabilities...
  [Agent 2] Mapping integration patterns...
  [Agent 3] Retrieving success rates...

Time 0:03 - Parallel work:
  [Agent 1] Found 23 relevant plugins
  [Agent 2] Identified 7 patterns
  [Agent 3] Analyzed 15 plugin success rates

Time 0:05 - Synthesis complete
```

**Benefits:** 3x faster wall-clock time, fresh context per agent, specialized focus

## Research Output Format

```markdown
## Research Report: API with Authentication

### Relevant Plugins (23 found)

#### Structure/Scaffolding
- fastapi-scaffolder (95% success, web-dev)
- flask-starter (87% success, web-dev)

#### Authentication
- jwt-auth-plugin (89% success, security)
- oauth2-integration (85% success, security)

#### Testing
- api-tester (91% success, testing)

### Recommended Patterns (3 patterns)

#### Pattern 1: FastAPI + JWT + Redis
- Sequence: fastapi-scaffolder → jwt-auth-plugin → redis-cache-plugin → api-tester
- Success rate: 92%
- Avg time: 12 minutes
- Used 47 times

### Recommendation

Use Pattern 1 (FastAPI + JWT + Redis) because:
- Highest success rate (92%)
- Most usage (47 times, proven)
- Modern stack, good balance

### Next Steps

Proceed to Plan Phase with Pattern 1
```

## Plugin Analysis Template

When analyzing individual plugins, use this structure:

```yaml
plugin: <name>
version: <version>
domain: <primary-domain>
subdomains: [<list>]

capabilities:
  - <capability-1>
  - <capability-2>

inputs:
  - name: <param-name>
    type: <data-type>
    required: <boolean>

outputs:
  - name: <output-name>
    type: <data-type>

compatibility:
  consumes_from: [<plugin-list>]
  provides_to: [<plugin-list>]

reliability:
  success_rate: <percentage>
  total_uses: <count>
  last_used: <date>

known_issues:
  - issue: <description>
    fix: <solution>
    frequency: <count>
```

## Domain Categories

**web-development:**
- Frameworks: fastapi, flask, express, django, next.js
- Components: auth, routing, orm, caching, rate-limiting

**devops:**
- Containers: docker, kubernetes, podman
- CI/CD: github-actions, jenkins, gitlab-ci
- Infrastructure: terraform, ansible, cloudformation

**data-engineering:**
- ETL: airflow, dagster, prefect
- Processing: pandas, spark, dbt
- Storage: postgresql, mongodb, redis, s3

**security:**
- Authentication: jwt, oauth2, saml
- Scanning: snyk, sonarqube, trivy
- Secrets: vault, aws-secrets-manager

**testing:**
- Unit: pytest, jest, mocha
- Integration: postman, insomnia, k6
- E2E: playwright, selenium, cypress

**ai-ml:**
- Training: pytorch, tensorflow, scikit-learn
- Deployment: mlflow, kubeflow, sagemaker
- Inference: triton, torchserve, tensorflow-serving

## Quick Reference: Research Checklist

- [ ] Spawn 3 sub-agents with parallel execution
- [ ] Agent 1: Extract capabilities, categorize by domain
- [ ] Agent 2: Map compatibility, identify sequences
- [ ] Agent 3: Analyze success rates, document issues
- [ ] Synthesize findings into research report
- [ ] Identify top 3 recommended patterns
- [ ] Provide clear recommendation with rationale
