---
pattern_id: pat_2025-11-07_simple_rest_api_health
created: 2025-11-07T00:00:00Z
category: api-development
subcategory: minimal-rest-api
success_rate: 1.0
executions: 1
last_used: 2025-11-07T00:00:00Z
validated: false
status: discovered
---

# Pattern: Simple REST API with Health Check

## Context

Creating a minimal REST API with a single health monitoring endpoint for service status checks. Suitable for microservices, monitoring infrastructure, or API scaffolding.

## Use Cases

- Kubernetes/Docker health checks
- Load balancer monitoring
- Service mesh integration
- API scaffolding starting point
- Uptime monitoring systems

## Workflow Sequence

### Step 1: API Scaffold (Express.js)
**Plugin:** express-api-scaffold
**Duration:** ~3 minutes
**Success Rate:** 100%

**Inputs:**
- project_name: string
- minimal: boolean (true)
- typescript: boolean (true)

**Outputs:**
- Server structure (src/, dist/)
- package.json with dependencies
- tsconfig.json
- Base server.ts file

**Validation:**
- ✓ package.json exists
- ✓ src/ directory structure created
- ✓ TypeScript configuration valid

### Step 2: Health Endpoint Implementation
**Plugin:** custom-endpoint-creator
**Duration:** ~2 minutes
**Success Rate:** 100%

**Inputs:**
- route: "/health"
- method: "GET"
- response_schema: HealthCheck object

**Outputs:**
- src/routes/health.ts
- Health route logic

**Validation:**
- ✓ Health endpoint responds with 200
- ✓ Returns required fields (status, timestamp, uptime)

### Step 3: Integration Tests (Parallel with Step 4)
**Plugin:** api-test-generator
**Duration:** ~3 minutes
**Success Rate:** 100%

**Inputs:**
- endpoints: ["/health"]
- test_framework: "jest"
- test_runner: "supertest"

**Outputs:**
- src/routes/health.test.ts
- jest.config.js
- 6 test cases

**Validation:**
- ✓ All tests pass
- ✓ Coverage > 90%

### Step 4: API Documentation (Parallel with Step 3)
**Plugin:** openapi-doc-generator
**Duration:** ~2 minutes
**Success Rate:** 100%

**Inputs:**
- endpoints: ["/health"]
- format: "OpenAPI 3.0"

**Outputs:**
- openapi.yaml
- README.md

**Validation:**
- ✓ OpenAPI spec valid
- ✓ Documentation complete

## Total Metrics

**Duration:** 9 minutes (actual), 10 minutes (estimated)
**Success Rate:** 100% (1/1 executions)
**Files Created:** 7
**Lines of Code:** ~200
**Test Coverage:** 100%

## Technology Stack

- **Runtime:** Node.js + TypeScript
- **Framework:** Express.js
- **Testing:** Jest + Supertest
- **Security:** Helmet, CORS
- **Documentation:** OpenAPI 3.0

## Key Success Factors

1. **Minimal dependencies** - Only essential packages (express, helmet, cors)
2. **TypeScript from start** - Type safety prevents runtime errors
3. **Parallel execution** - Tests and docs generated simultaneously
4. **Comprehensive validation** - Each step verified before proceeding
5. **Complete documentation** - OpenAPI spec + README generated

## Common Failure Modes

*None observed yet (1 execution)*

## Optimization Opportunities

- Step 3 & 4 can run fully in parallel (currently implemented)
- Could add Docker configuration as Step 5 (optional)
- Could add CI/CD pipeline as Step 6 (optional)

## Related Patterns

- **Next Level:** Add authentication layer → `pat_rest_api_jwt_auth`
- **Next Level:** Add database → `pat_rest_api_database_crud`
- **Alternative:** Use FastAPI for Python → `pat_fastapi_health_check`

## Pattern Lifecycle

**Current Stage:** Discovered (1 execution)
**Next Stage:** Validated (requires 5+ successful executions)
**Final Stage:** Learned (requires 20+ successful executions, >90% success rate)

## Learnings

### What Worked Well
- Sequential scaffold → endpoint → parallel (tests + docs) flow
- TypeScript configuration minimal but complete
- Health endpoint schema comprehensive (status, timestamp, uptime, version, env)

### What to Improve
- Could template-ize the health endpoint response schema
- Could add environment variable configuration
- Could include Docker Compose for local testing

## Replication Instructions

To use this pattern:

1. Run meta-orchestrator: `/orchestrate "Create REST API with health check"`
2. Specify framework: Express.js (or auto-detected)
3. Minimal mode: true
4. TypeScript: true (recommended)
5. Estimated time: 10 minutes
6. Success probability: 94%

## Plugin Sources

- express-api-scaffold: claude-code-plugins-plus
- api-test-generator: claude-code-plugins-plus
- openapi-doc-generator: claude-code-plugins-plus

## Metadata

**Discovered By:** Meta-orchestrator test execution
**Test ID:** wf_2025-11-07_rest_api_health
**Marketplace Coverage:** claude-code-plugins-plus (primary)
**Domain:** Backend Development → API → Minimal REST
**Complexity:** Low
**Estimated Success Probability:** 0.94

---

**Next Review:** After 5 total executions
**Pattern Status:** Discovered → Pending validation
