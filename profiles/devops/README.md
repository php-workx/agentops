# DevOps Profile

**Specialization:** Infrastructure, Operations, Kubernetes, GitOps

**Use when:** Building, deploying, and managing infrastructure-as-code

**Key domains:** Applications, sites, deployment pipelines, database operations, security policies

---

## Overview

DevOps profile specializes agentops universal patterns for infrastructure and operations work.

**Universal architecture:** Phase-based workflows, context bundles, multi-agent orchestration, intelligent routing
**Domain specialization:** 52 infrastructure-focused agents, operations workflows, Kubernetes patterns

---

## What This Profile Provides

### 52 Specialized Agents
```
Applications (8 agents)
  • applications-create-app
  • applications-create-app-jren
  • applications-debug-sync
  • applications-modify-app
  • ... and 4 more

Infrastructure (15+ agents)
  • services-kyverno-policies (security)
  • services-crossplane-dev (infrastructure-as-code)
  • services-edb-databases (database operations)
  • ... and more

Operations (10+ agents)
  • argocd-debug-sync (deployment troubleshooting)
  • playbooks-* (operational workflows)
  • incidents-response (incident management)
  • monitoring-* (observability)
  • ... and more

Sites/Configuration (8 agents)
  • sites-site-config (add/modify site configuration)
  • sites-harmonize (render config)
  • ... and more

Plus: Documentation, deployment, testing, security agents
```

### Phase-Based Workflows
```
/research "Infrastructure question"
  ↓ (explore approaches, constraints)
/plan research.md
  ↓ (specify file:line changes)
/implement plan.md
  ↓ (deploy manifests)
```

### Parallel Research & Validation
```
/prime-complex-multi "Infrastructure topic"
  • 3 agents research simultaneously
  • 3x speedup (20-30 min → 7-10 min)

/validate-multi
  • YAML syntax + security + workflows in parallel
  • 3x speedup (30s → 10s)
```

### Context Bundles
```
/bundle-save redis-caching-research
  • Compress research findings (5:1-10:1 ratio)
  • Reuse across sessions and teams

/bundle-load redis-caching-research
  • Resume work in fresh context
```

### Intelligent Routing
```
/prime-with-routing "Create Redis application"
  • Auto-classifies task (infrastructure, create, medium)
  • Recommends: applications-create-app-jren (94% fit)
  • Achieves: 90.9% accuracy
```

---

## Typical Workflows

### Create New Application

```bash
/prime-with-routing "Create Redis application"
# Auto-recommends: applications-create-app-jren

# Or explicitly:
/research "How should we structure Redis deployment?"
/bundle-save redis-research

/bundle-load redis-research
/plan redis-research.md
/bundle-save redis-plan

/bundle-load redis-plan
/implement redis-plan.md
git push
```

### Debug Deployment Issue

```bash
/prime-with-routing "ArgoCD app won't sync"
# Auto-recommends: argocd-debug-sync

# Or:
/research "Why is deployment failing?"
/plan debugging-research.md
/implement debugging-plan.md
```

### Configure Site

```bash
/research "What configuration does site need?"
/plan site-config-research.md
/implement site-config-plan.md

# Or use:
/prime-with-routing "Add new site to configuration"
# Auto-recommends: sites-site-config
```

---

## Profile Structure

```
devops/
├── README.md (this file)
├── agents/
│   ├── applications/ (8 agents)
│   ├── infrastructure/ (15+ agents)
│   ├── operations/ (10+ agents)
│   ├── sites/ (8 agents)
│   └── ... (more specializations)
├── commands/
│   ├── research/ (phase 1 guidance)
│   ├── plan/ (phase 2 guidance)
│   ├── implement/ (phase 3 guidance)
│   └── workflows/ (multi-agent patterns)
├── workflows/
│   ├── application-creation/
│   ├── site-configuration/
│   ├── deployment/
│   └── troubleshooting/
└── standards/
    ├── kubernetes/ (K8s patterns)
    ├── helm/ (Helm chart standards)
    ├── kustomize/ (Kustomize patterns)
    └── gitops/ (GitOps best practices)
```

---

## Key Patterns for DevOps

### Pattern: Infrastructure-as-Code

Work follows file:line precision:
```
/plan infrastructure-research.md
  → Specifies exact changes:
    - apps/redis/kustomization.yaml:15
    - infrastructure/namespaces.yaml:5
```

### Pattern: Validation Gates

Every change validated:
```
/implement infrastructure-plan.md
  → Validates after each step:
    - make quick (syntax)
    - make ci-all (workflows)
    - kubectl apply --dry-run (manifests)
```

### Pattern: Rollback Documentation

Every plan includes undo procedure:
```
/plan infrastructure-research.md
  → Includes rollback:
    - git revert [sha]
    - kubectl delete manifests
    - Verify application works
```

### Pattern: Multi-Day Projects

Complex infrastructure changes span multiple days:
```
Day 1: Research architecture
  → /bundle-save infra-research

Day 2: Plan changes
  → /bundle-load infra-research
  → /plan infra-plan.md
  → /bundle-save infra-plan

Day 3: Deploy
  → /bundle-load infra-plan
  → /implement infra-plan.md
  → git push
```

---

## Real Example: Database Migration

```bash
# Phase 1: Research
/research "Migrate Postgres 12 to 13 with zero downtime"

Output: research.md
- Approaches: in-place, pg_dump, logical replication
- Recommendation: logical replication (zero downtime)
- Constraints: wal_level=logical, binary slots

/bundle-save postgres-migration-research

# Phase 2: Plan (next day, fresh context)
/bundle-load postgres-migration-research
/plan postgres-migration-research.md

Output: plan.md
- Step 1: Enable logical replication
- Step 2: Create replication slot
- Step 3: Start logical replication
- Step 4: Verify data (schema + row counts)
- Step 5: Cutover (switch to replica)
- Validation: query timing test
- Rollback: Stop replication, restore from backup

/bundle-save postgres-migration-plan

# Phase 3: Deploy (next day, fresh context)
/bundle-load postgres-migration-plan
/implement postgres-migration-plan.md

Output: Changes + git commit
- Modified: helm/postgres-values.yaml
- Modified: scripts/db-migration.sh
- Validated: All steps pass
- Ready to push

git push
```

---

## Measured Improvements

From GitOps integration of DevOps profile:

| Metric | Before | After | Gain |
|--------|--------|-------|------|
| Research time | 30 min | 10 min | **3x faster** |
| Validation | 30 sec | 10 sec | **3x faster** |
| Multi-day work | ❌ Limited | ✅ Enabled | **New** |
| Team reuse | Manual | Bundles | **Automated** |

---

## When to Use DevOps Profile

**Use this profile when:**
- ✅ Working with Kubernetes/infrastructure
- ✅ Creating or modifying applications
- ✅ Managing site configuration
- ✅ Debugging deployment issues
- ✅ Operating databases, networking, security

**Use other profiles when:**
- Building new products (product-dev profile)
- Responding to incidents (SRE profile)
- Building data pipelines (data-eng profile)

---

## See Also

- **Architecture:** `/agentops/architecture/` (universal patterns)
- **Documentation:** `/agentops/docs/` (how-to guides)
- **Case Study:** GitOps integration (`agentops/docs/CASE_STUDY_GITOPS_INTEGRATION.md`)

---

## Getting Started

1. **Read:** This README (you are here)
2. **Explore:** Agents in `agents/` directory
3. **Try:** `/prime-with-routing "Your infrastructure task"`
4. **Dive deep:** Read specific agent documentation
5. **Apply:** Use phase-based workflow for complex tasks

---

**Profile Status:** ✅ Complete, proven, 52 agents, validated in production

**Last Updated:** 2025-11-05
