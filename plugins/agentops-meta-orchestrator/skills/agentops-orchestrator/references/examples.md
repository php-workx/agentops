# Meta-Orchestration Examples

Comprehensive examples across domains showing typical usage patterns.

## Web Development Examples

### Example 1: REST API with Authentication

**User Request:**
```
"Build a REST API with JWT authentication and Redis caching"
```

**Skill Response:**

**Research Phase (3 minutes):**
- Analyzed 23 plugins for API development
- Identified 7 integration patterns
- Found 3 proven workflows

**Recommended Pattern:** FastAPI + JWT + Redis (92% success, 47 uses)

**Generated Workflow:**
1. fastapi-scaffolder → Create API structure (2 min)
2. jwt-auth-plugin → Add JWT authentication (3 min)
3. redis-cache-plugin → Setup caching layer (3 min)
4. rate-limiter-plugin → Add rate limiting (2 min)
5. api-tester → Validate functionality (2 min)

**Execution Time:** 11 minutes
**Success:** ✓ All steps completed

**Outputs:**
- API running at http://localhost:8000
- Endpoints: POST /register, POST /login, GET /me, GET /health
- Documentation: http://localhost:8000/docs

---

### Example 2: Full-Stack Web App

**User Request:**
```
"Create a full-stack todo app with Next.js frontend and PostgreSQL backend"
```

**Skill Response:**

**Research Phase:**
- Analyzed 31 plugins (frontend + backend + database)
- Pattern: next-js-postgres-prisma (85% success, 23 uses)

**Generated Workflow:**
1. nextjs-app-generator → Create Next.js frontend
2. prisma-schema-generator → Define database schema
3. api-route-generator → Create API routes
4. postgres-setup → Initialize PostgreSQL
5. prisma-migrate → Apply migrations
6. component-generator → Create React components
7. integration-tester → Test full stack

**Execution Time:** 18 minutes
**Success:** ✓

---

## DevOps Examples

### Example 3: Containerize and Deploy

**User Request:**
```
"Containerize my FastAPI app and deploy to Kubernetes"
```

**Skill Response:**

**Research Phase:**
- Analyzed 19 DevOps plugins
- Pattern: docker-k8s-deploy (88% success, 34 uses)

**Generated Workflow:**
1. dockerfile-generator → Create Dockerfile
2. docker-build → Build container image
3. k8s-manifest-generator → Generate K8s manifests
4. k8s-deployer → Deploy to cluster
5. health-checker → Verify deployment

**Execution Time:** 8 minutes
**Success:** ✓

**Outputs:**
- Container: my-app:latest
- Deployed to: default namespace
- Service: http://my-app.cluster.local
- Replicas: 3, all healthy

---

### Example 4: CI/CD Pipeline

**User Request:**
```
"Set up CI/CD pipeline with GitHub Actions, Docker, and AWS ECS"
```

**Skill Response:**

**Research Phase:**
- Analyzed 24 plugins (CI/CD + containers + cloud)
- Pattern: github-docker-ecs (82% success, 16 uses)

**Generated Workflow:**
1. github-workflow-generator → Create .github/workflows/deploy.yml
2. dockerfile-generator → Create Dockerfile
3. ecr-setup → Configure AWS ECR
4. ecs-task-definition → Define ECS task
5. deploy-action-generator → Create deployment action
6. integration-tester → Test full pipeline

**Execution Time:** 15 minutes
**Success:** ✓

---

## Data Engineering Examples

### Example 5: ETL Pipeline

**User Request:**
```
"Build ETL pipeline to extract CSV data, transform, and load into BigQuery"
```

**Skill Response:**

**Research Phase:**
- Analyzed 17 data engineering plugins
- Pattern: csv-transform-bigquery (91% success, 28 uses)

**Generated Workflow:**
1. csv-parser → Parse CSV files
2. data-validator → Validate data quality
3. data-transformer → Apply transformations
4. bigquery-schema-generator → Generate table schema
5. bigquery-loader → Load data to BigQuery
6. data-quality-checker → Verify load success

**Execution Time:** 14 minutes
**Success:** ✓

**Outputs:**
- Rows processed: 1,234,567
- Rows loaded: 1,234,567
- Failed: 0
- BigQuery table: project.dataset.table

---

### Example 6: Real-Time Data Processing

**User Request:**
```
"Set up Kafka consumer to process events and write to PostgreSQL"
```

**Skill Response:**

**Research Phase:**
- Analyzed 14 streaming plugins
- Pattern: kafka-postgres-streaming (87% success, 19 uses)

**Generated Workflow:**
1. kafka-consumer-generator → Create Kafka consumer
2. event-schema-validator → Define event schema
3. event-processor → Transform events
4. postgres-writer → Write to PostgreSQL
5. monitoring-setup → Add metrics/logging
6. stream-tester → Test end-to-end

**Execution Time:** 12 minutes
**Success:** ✓

---

## Security Examples

### Example 7: Security Audit and Fix

**User Request:**
```
"Audit my codebase for security vulnerabilities and apply fixes"
```

**Skill Response:**

**Research Phase:**
- Analyzed 11 security plugins
- Pattern: security-audit-fix (79% success, 12 uses)

**Generated Workflow:**
1. dependency-scanner → Scan dependencies (Snyk)
2. code-scanner → Scan code (Bandit, SonarQube)
3. secret-scanner → Find hardcoded secrets
4. vulnerability-prioritizer → Rank by severity
5. auto-fixer → Apply automated fixes
6. security-tester → Verify fixes
7. report-generator → Generate audit report

**Execution Time:** 10 minutes
**Success:** ✓

**Outputs:**
- Vulnerabilities found: 23
- Critical: 2 (fixed)
- High: 7 (fixed)
- Medium: 14 (documented)
- Low: 0

---

### Example 8: Secrets Management

**User Request:**
```
"Migrate hardcoded secrets to AWS Secrets Manager"
```

**Skill Response:**

**Research Phase:**
- Analyzed 8 secrets management plugins
- Pattern: secrets-migration-aws (94% success, 31 uses)

**Generated Workflow:**
1. secret-detector → Find hardcoded secrets
2. secret-validator → Identify secret types
3. aws-secrets-manager-setup → Configure AWS SM
4. secret-migrator → Migrate secrets to AWS
5. code-updater → Update code to fetch from AWS
6. integration-tester → Test secret retrieval

**Execution Time:** 9 minutes
**Success:** ✓

---

## AI/ML Examples

### Example 9: Model Training Pipeline

**User Request:**
```
"Create MLflow pipeline to train and register PyTorch model"
```

**Skill Response:**

**Research Phase:**
- Analyzed 13 ML plugins
- Pattern: pytorch-mlflow-training (86% success, 21 uses)

**Generated Workflow:**
1. mlflow-setup → Initialize MLflow tracking
2. data-preprocessor → Prepare training data
3. pytorch-trainer → Train model
4. model-evaluator → Evaluate performance
5. model-registrar → Register in MLflow
6. experiment-tracker → Log metrics/artifacts

**Execution Time:** 45 minutes (training time)
**Success:** ✓

---

## Plugin Recommendation Examples

### Example 10: Domain Exploration

**User Request:**
```
"What plugins are available for building microservices?"
```

**Skill Response:**

**Research Phase:**
- Analyzed all 412 plugins
- Filtered by keywords: microservices, service-mesh, distributed

**Relevant Plugins (15 found):**

**Architecture:**
- microservices-scaffolder (93% success)
- service-mesh-setup (87% success)
- api-gateway-config (89% success)

**Communication:**
- grpc-generator (91% success)
- message-queue-setup (88% success)
- event-bus-integration (85% success)

**Observability:**
- distributed-tracing (90% success)
- centralized-logging (92% success)
- metrics-aggregation (89% success)

**Recommended Pattern:** grpc-service-mesh-tracing (86% success, 18 uses)

---

## Workflow Optimization Examples

### Example 11: Optimize Existing Process

**User Request:**
```
"I manually deploy containers to 5 regions. Can this be automated?"
```

**Skill Response:**

**Research Phase:**
- Analyzed deployment automation plugins
- Found pattern: multi-region-deploy (90% success, 26 uses)

**Current Manual Process:**
1. Build container
2. Push to registry
3. SSH to each region
4. Pull and restart containers
5. Verify deployment

**Optimized Workflow:**
1. multi-region-deployer → Deploy to all regions simultaneously
2. health-checker → Verify all deployments
3. rollback-manager → Automatic rollback on failure

**Time Savings:** Manual 30 min → Automated 5 min (6x speedup)

---

## Pattern Discovery Examples

### Example 12: Show Common Patterns

**User Request:**
```
"Show me common patterns for web development"
```

**Skill Response:**

**Top Web Development Patterns:**

1. **REST API with Auth (47 uses, 92% success)**
   - fastapi-scaffolder → jwt-auth-plugin → redis-cache-plugin

2. **Full-Stack App (23 uses, 85% success)**
   - nextjs-generator → postgres-setup → prisma-migrate

3. **GraphQL API (19 uses, 88% success)**
   - apollo-server-setup → graphql-schema-generator → resolver-generator

4. **Static Site (34 uses, 95% success)**
   - gatsby-generator → cms-integration → netlify-deploy

5. **Serverless API (28 uses, 87% success)**
   - lambda-function-generator → api-gateway-setup → dynamodb-integration

---

## Complex Multi-Domain Examples

### Example 13: End-to-End System

**User Request:**
```
"Build complete e-commerce platform: frontend, backend, payment, deployment"
```

**Skill Response:**

**Research Phase (extensive):**
- Analyzed 45 plugins across 4 domains
- Generated custom workflow (no existing pattern)

**Generated Workflow (16 steps):**

**Frontend (5 steps):**
1. nextjs-ecommerce-template
2. product-catalog-component
3. shopping-cart-component
4. checkout-component
5. user-dashboard-component

**Backend (6 steps):**
6. fastapi-scaffolder
7. product-api-generator
8. order-management-api
9. user-auth-api
10. postgres-setup
11. prisma-orm-integration

**Payment (2 steps):**
12. stripe-integration
13. payment-webhook-handler

**Deployment (3 steps):**
14. dockerfile-generator
15. k8s-manifest-generator
16. multi-service-deployer

**Execution Time:** 35 minutes
**Success:** ✓

**New Pattern Created:** ecommerce-complete-stack
- Will be available for future similar requests

---

## Error Recovery Examples

### Example 14: Handling Failures

**User Request:**
```
"Deploy my app to Kubernetes"
```

**Execution:**

```
Step 1: docker-build
  Status: ✓ Success (2 min)

Step 2: k8s-manifest-generator
  Status: ✓ Success (1 min)

Step 3: k8s-deployer
  Status: ✗ Failed
  Error: kubectl not configured

Recovery:
  Level 1 (Retry): ✗ Still fails
  Level 2 (Fallback): No alternative plugin
  Level 3 (Manual): Alert user

Action Required:
  Configure kubectl: kubectl config set-context ...
  Verify: kubectl get nodes

User Fixed: ✓
Retry Step 3: ✓ Success

Overall: ✓ Complete (with manual intervention)
```

**Learning:** Pattern updated with known issue:
- Issue: "kubectl not configured"
- Fix: "Run kubectl config before deployment"
- Frequency: 7 occurrences

---

## Use Case Matrix

| Domain | Example | Plugins Used | Time | Success |
|--------|---------|-------------|------|---------|
| Web Dev | REST API | 5 | 11 min | 92% |
| Web Dev | Full Stack | 7 | 18 min | 85% |
| DevOps | Container Deploy | 5 | 8 min | 88% |
| DevOps | CI/CD Pipeline | 6 | 15 min | 82% |
| Data Eng | ETL Pipeline | 6 | 14 min | 91% |
| Data Eng | Streaming | 6 | 12 min | 87% |
| Security | Audit & Fix | 7 | 10 min | 79% |
| Security | Secrets Mgmt | 6 | 9 min | 94% |
| AI/ML | Training Pipeline | 6 | 45 min | 86% |

## Anti-Patterns (What NOT to Do)

### ❌ Don't: Use for Single Plugin Tasks

**Bad Request:**
```
"Run pytest on my tests"
```

**Why:** This is a single command, no orchestration needed. Just run pytest directly.

### ❌ Don't: Use for Non-Plugin Tasks

**Bad Request:**
```
"Explain how JWT authentication works"
```

**Why:** This is a conceptual question, not a plugin orchestration task.

### ❌ Don't: Over-Specify When Uncertain

**Bad Request:**
```
"Use exactly jwt-auth-plugin version 2.3.1 with fastapi-scaffolder version 1.0.0"
```

**Why:** Let the skill analyze compatibility. Forced versions may conflict.

### ✓ Do: Describe Desired Outcome

**Good Request:**
```
"Build REST API with authentication and caching"
```

**Why:** Clear goal, skill determines best plugin combination.
