# Extending Core AgentOps

**Purpose:** Add domain-specific capabilities to AgentOps core platform

**Philosophy:** Extend, don't replace. Build on foundation, maintain compatibility.

---

## Extension Points

Core AgentOps provides four extension points for domain customization:

### 1. Custom Agents
Create specialized agent personas for your domain

### 2. Command Overrides
Add domain context to core commands

### 3. Domain Workflows
Compose core patterns into domain-specific orchestrations

### 4. Skills Implementation
Add domain-specific validation and automation

---

## 1. Creating Custom Agents

Agents are specialized personas that handle specific tasks in your domain.

### Agent Template

```markdown
---
name: your-agent-name
description: What this agent does (one sentence)
model: sonnet|opus
tools: [Read, Write, Edit, Bash, Grep, Glob]
---

# Your Agent Name

**Specialty:** What this agent excels at

**When to use:**
- Scenario 1
- Scenario 2
- Scenario 3

## Core Capabilities

### 1. Capability Name
What it does and how

### 2. Capability Name
What it does and how

## Approach

**Step 1: Action**
\```bash
# Domain-specific commands
\```

**Step 2: Action**
\```bash
# More domain-specific work
\```

## Output Format

\```markdown
# Agent Output Structure
What the agent returns
\```
```

### Examples by Domain

**DevOps Domain:**
```markdown
---
name: kubernetes-debugger
description: Debug Kubernetes deployment issues
model: opus
tools: [Bash, Read, Grep]
---

# Kubernetes Debugger

**Specialty:** Diagnosing K8s deployment failures

**When to use:**
- Pods not starting
- Service connectivity issues
- Resource constraints

## Approach

**Step 1: Check pod status**
\```bash
kubectl get pods -A
kubectl describe pod [name]
kubectl logs [pod]
\```

**Step 2: Analyze events**
\```bash
kubectl get events --sort-by='.lastTimestamp'
\```
```

**Product Dev Domain:**
```markdown
---
name: api-designer
description: Design RESTful API endpoints
model: opus
tools: [Read, Write, Edit]
---

# API Designer

**Specialty:** Designing clean API contracts

**When to use:**
- New API endpoints needed
- API refactoring
- OpenAPI spec creation

## Approach

**Step 1: Define resources**
Identify entities and relationships

**Step 2: Design endpoints**
RESTful patterns, HTTP methods

**Step 3: Document contracts**
OpenAPI/Swagger specifications
```

---

## 2. Overriding Core Commands

Override core commands to add domain-specific behavior while maintaining compatibility.

### When to Override

✅ **Good reasons:**
- Add domain-specific research patterns
- Include specialized validation
- Customize output for your tools
- Provide domain examples

❌ **Bad reasons:**
- Completely replace core functionality
- Break compatibility with core
- Remove universally useful features

### Override Pattern

**Core command structure:**
```markdown
core/commands/research.md
├── Universal research patterns
├── Generic exploration steps
└── Standard output format
```

**Your override:**
```markdown
profiles/your-domain/commands/research.md
├── Reference: core/commands/research.md
├── Add: Domain-specific patterns
└── Maintain: Core compatibility
```

### Override Example

```markdown
---
overrides: core/commands/research.md
reason: Add Kubernetes-specific research capabilities
---

# /research - Enhanced for Kubernetes

**Extends:** core/commands/research.md

All core research capabilities available, plus:

## Kubernetes-Specific Research

### Cluster State Analysis
\```bash
# Current deployments
kubectl get deployments -A

# Resource usage
kubectl top nodes
kubectl top pods -A

# Events
kubectl get events --sort-by='.lastTimestamp'
\```

### Manifest Validation
\```bash
# Syntax check
kubectl apply --dry-run=client -f .

# Best practices
kube-score score *.yaml
\```

### Common Issues
- **CrashLoopBackOff:** Check logs, resource limits
- **ImagePullBackOff:** Verify registry, credentials
- **Pending:** Check node resources, taints/tolerations

## Output Includes

All core research outputs plus:
- Cluster health summary
- Resource utilization
- Common misconfigurations
```

---

## 3. Creating Domain Workflows

Workflows orchestrate agents and commands for complete domain-specific cycles.

### Workflow Template

```markdown
---
name: workflow-name
description: What this workflow accomplishes
estimated_time: Duration estimate
phases: Number of phases
---

# Workflow Name

**Purpose:** What problem this solves

**When to use:**
- Use case 1
- Use case 2

## Workflow Phases

\```
Phase 1: Name (time)
   ↓
Phase 2: Name (time)
   ↓
Phase 3: Name (time)
\```

## Phase Details

### Phase 1: Name

**Goal:** What this phase achieves

**Commands:**
\```bash
/command-name args
\```

**Agents used:**
- agent-name: what they do

**Output:** What gets produced

[Repeat for each phase]

## Example Execution

[Concrete walkthrough with real commands]
```

### Workflow Example: DevOps

```markdown
---
name: containerize-application
description: Convert application to containerized deployment
estimated_time: 2-3 hours
phases: 4
---

# Containerize Application Workflow

**Purpose:** Move app from VM to container deployment

**When to use:**
- Migrating legacy apps to Kubernetes
- Dockerizing new services
- Creating CI/CD pipelines

## Phases

\```
Phase 1: Analyze App (30 min)
   ↓
Phase 2: Create Dockerfile (45 min)
   ↓
Phase 3: Build & Test (45 min)
   ↓
Phase 4: Deploy (45 min)
\```

## Phase 1: Analyze Application

**Goal:** Understand app dependencies and runtime

**Commands:**
\```bash
/research "application architecture and dependencies"
\```

**Agents:** application-analyzer

**Output:** Dependency list, runtime requirements

## Phase 2: Create Dockerfile

**Commands:**
\```bash
/plan dockerfile-creation-research.md
\```

**Agents:** dockerfile-builder

**Output:** Optimized Dockerfile, .dockerignore

## Phase 3: Build & Test

**Commands:**
\```bash
/implement dockerfile-plan.md
docker build -t app:test .
docker run --rm app:test
\```

**Output:** Working container image

## Phase 4: Deploy

**Commands:**
\```bash
kubectl apply -f manifests/
/validate
\```

**Output:** Running deployment in Kubernetes
```

---

## 4. Implementing Skills

Skills are reusable capabilities agents invoke during execution.

### Script-Based Skills (Fast, Deterministic)

**When to use:**
- Syntax validation
- File format checks
- Security scanning
- Performance benchmarks

**Template:**
```bash
#!/bin/bash
# Skill: skill-name
# Purpose: What this validates/automates

set -e

# Input validation
if [ $# -eq 0 ]; then
  echo "Usage: $0 <target>"
  exit 1
fi

# Execute validation/automation
result=$(your-tool "$@" 2>&1)
exit_code=$?

# Output as JSON
cat <<EOF
{
  "skill": "skill-name",
  "status": "$([ $exit_code -eq 0 ] && echo success || echo failure)",
  "exit_code": $exit_code,
  "output": $(echo "$result" | jq -Rs .)
}
EOF

exit $exit_code
```

**Example: Kubernetes Validator**
```bash
#!/bin/bash
# Skill: kubernetes-validator
# Purpose: Validate Kubernetes manifests

set -e

# Validate YAML syntax
yamllint "$@" || exit 1

# Validate K8s resources
kubectl apply --dry-run=client -f "$@" || exit 2

# Check best practices
kube-score score "$@" || exit 3

cat <<EOF
{
  "skill": "kubernetes-validator",
  "status": "success",
  "checks": {
    "yaml_syntax": "passed",
    "kubernetes_schema": "passed",
    "best_practices": "passed"
  }
}
EOF
```

### AI-Powered Skills (Reasoning-Based)

**When to use:**
- Code analysis
- Pattern recognition
- Complexity assessment
- Architecture review

**Template:**
```markdown
---
name: skill-name
description: What this skill analyzes
model: sonnet|opus
tools: [Read, Grep, Bash]
token_budget: Estimate (e.g., 15k)
---

# Skill Name

**Purpose:** What problem this solves

**When to use:**
- Scenario 1
- Scenario 2

## Approach

**Step 1:** Analysis method

**Step 2:** Pattern extraction

## Output Format

\```json
{
  "skill": "skill-name",
  "findings": [...],
  "recommendations": [...]
}
\```
```

---

## Best Practices

### Compatibility

✅ **Do:**
- Extend core functionality
- Reference core patterns
- Maintain core interfaces
- Document assumptions

❌ **Don't:**
- Replace core completely
- Break core compatibility
- Remove universal features
- Ignore core standards

### Documentation

✅ **Do:**
- Provide working examples
- Document dependencies
- Include troubleshooting
- Link to core docs

❌ **Don't:**
- Assume knowledge
- Skip error handling
- Forget prerequisites
- Ignore edge cases

### Testing

✅ **Do:**
- Test against core updates
- Validate with real scenarios
- Check error paths
- Document test cases

❌ **Don't:**
- Skip validation
- Test only happy path
- Hardcode test data
- Ignore failures

---

## Integration Patterns

### Pattern 1: Minimal Extension

**Use when:** Domain is similar to core, few customizations needed

```yaml
# profile.yaml
spec:
  extends: core
  agents:
    - name: domain-explorer  # Single specialized agent
      file: agents/domain-explorer.md
```

### Pattern 2: Enhanced Extension

**Use when:** Domain needs moderate customization

```yaml
# profile.yaml
spec:
  extends: core
  agents:
    - name: domain-explorer
    - name: domain-architect
    - name: domain-validator
  commands:
    - name: research
      overrides: core/commands/research.md
```

### Pattern 3: Full Extension

**Use when:** Domain is highly specialized

```yaml
# profile.yaml
spec:
  extends: core
  agents: [5-10 domain-specific agents]
  commands: [2-3 command overrides]
  workflows: [3-5 domain workflows]
  skills: [Multiple domain skills]
```

---

## Versioning & Updates

### Profile Versioning

Follow semantic versioning:
- **Major (2.0.0):** Breaking changes, incompatible with v1
- **Minor (1.1.0):** New features, backwards compatible
- **Patch (1.0.1):** Bug fixes only

### Core Compatibility

Declare core version compatibility:

```yaml
# profile.yaml
metadata:
  name: my-domain
  version: 1.2.0
  core_compatibility: ">=1.0.0 <2.0.0"
```

### Migration Guides

When making breaking changes:

```markdown
# MIGRATION.md

## Migrating from v1 to v2

### Breaking Changes
1. Agent renamed: old-agent → new-agent
2. Command signature changed: /old-cmd → /new-cmd

### Migration Steps
1. Update profile.yaml version
2. Rename agent references
3. Update command calls
4. Test workflows

### Rollback
If issues: git checkout v1.0.0
```

---

## Testing Your Extensions

### Unit Testing

**Test individual components:**

```bash
# Test agent
cat test-input.md | your-agent-script.sh

# Test skill
./skills/your-skill.sh test-file.yaml

# Test command override
# (Manual: Invoke command, verify domain features work)
```

### Integration Testing

**Test complete workflows:**

```bash
# Test profile installation
./scripts/install.sh --profile your-domain

# Test workflow execution
/prime  # Should load your profile
/research "test topic"  # Should use your agents
```

### Regression Testing

**Test against core updates:**

```bash
# Update core
git pull origin main

# Re-test profile
./scripts/validate-profile.sh your-domain
./scripts/install.sh --profile your-domain
# Run full workflow suite
```

---

## Getting Help

- **Guide:** `docs/CREATE_PROFILE.md` - Creating profiles
- **Example:** `profiles/example/` - Template to copy
- **Validation:** `scripts/validate-profile.sh` - Check structure
- **Community:** [forum-link] - Ask questions
- **Issues:** [github-issues] - Report problems

---

## Next Steps

1. **Decide extension level:** Minimal, Enhanced, or Full
2. **Create agents:** Start with 1-2, add more as needed
3. **Override commands:** Only if domain needs customization
4. **Build workflows:** Compose agents into complete cycles
5. **Implement skills:** Add domain-specific automation
6. **Test thoroughly:** Unit, integration, regression
7. **Document well:** README, examples, troubleshooting
8. **Share:** Contribute to profile ecosystem

**Remember:** Good extensions enhance core without breaking it. Start small, grow as needed.
