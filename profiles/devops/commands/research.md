---
description: Research phase for GitOps/DevOps - emphasize infrastructure patterns
---

# /research - GitOps Research Phase

**Purpose:** Systematic research for GitOps and infrastructure problems.

**DevOps Focus:** Emphasize existing patterns, proven implementations, and GitOps best practices.

**Token budget:** 40-60k tokens (20-30% of context window)

---

## DevOps-Specific Research Areas

### 1. Existing Patterns

**Check catalog first:**
- `jren-cm/examples/` - Proven application patterns
- `kubic-cm/` - Upstream Helm chart patterns
- `docs/reference/` - Team documentation
- Git history - Similar past implementations

### 2. Infrastructure Constraints

**Understand platform:**
- Kubernetes version
- Available CRDs
- Storage classes
- Network policies
- Security policies (Kyverno)

### 3. GitOps Workflow

**How does it work?**
- Argo CD sync behavior
- Kustomize overlays
- Config rendering (harmonize)
- Validation gates

---

## DevOps Research Process

### Step 1: Check Existing Work

```bash
# Search for similar apps
grep -r "similar-app" jren-cm/apps/

# Check examples
ls jren-cm/examples/

# Review git history
git log --oneline --grep="similar-feature"
```

### Step 2: Understand Current State

```bash
# Validate current setup
make quick

# Check what's deployed
kubectl get applications -n argocd

# Review site config
cat ../test-site/sites/config.env
```

### Step 3: Identify Pattern

**Which golden pattern applies?**
- Helm-based app
- Kustomize-only app
- Database app (EDB)
- S3 app (StorageGrid)
- Monitoring app (Prometheus)

### Step 4: Document Findings

```markdown
# Research: [Feature Name]

## Existing Pattern
Found in: jren-cm/examples/[pattern-name]/
Applies to: [our use case]
Modifications needed: [what to adapt]

## Infrastructure Context
- Kubernetes: v1.27
- Storage: [available classes]
- Network: [constraints]
- Security: [Kyverno policies that apply]

## GitOps Workflow
1. Edit config.env
2. Run harmonize
3. Validate YAML
4. Commit and push
5. Argo CD syncs automatically

## Recommendation
Use [pattern-name] with [specific modifications]

Reasoning: [why this approach fits best]
```

---

## DevOps-Specific Deliverables

### Pattern Identification

**Which pattern from catalog?**
- Pattern name
- Source location
- Why it fits
- Adaptations needed

### Infrastructure Impact

**What resources needed?**
- Namespaces
- Storage
- Secrets
- Network policies
- RBAC

### Validation Strategy

**How to verify it works?**
- YAML validation: `make quick`
- Full CI: `make ci-all`
- Dry-run: `kubectl apply --dry-run`
- Argo CD sync test
- Application health check

---

## GitOps Research Checklist

- [ ] Checked examples directory
- [ ] Reviewed similar applications
- [ ] Understood site configuration
- [ ] Identified applicable pattern
- [ ] Documented infrastructure needs
- [ ] Defined validation commands
- [ ] Research bundle saved

---

## Transition to Planning

```bash
# Save research
/bundle-save research-gitops-[topic]

# Start planning session
/bundle-load research-gitops-[topic]
/plan
```

---

## Success Criteria

Research complete when:

- [ ] Existing pattern identified
- [ ] Infrastructure constraints understood
- [ ] GitOps workflow mapped
- [ ] Validation strategy defined
- [ ] Ready for detailed planning

---

**DevOps Note:** Always prefer proven patterns over custom implementations. The examples directory exists to prevent reinventing solutions.

**Next command:** `/plan` to create GitOps-specific implementation specification
