---
description: Research and discover plugin workflow patterns without executing them
---

# /discover-patterns - Pattern Discovery Command

**Purpose:** Research plugins and discover workflow patterns for a domain or task type without actually executing workflows.

**When to use:**
- Explore what's possible in a domain
- Learn which plugins work well together
- Build knowledge before starting work
- Understand available patterns

**Token budget:** 15-25k tokens (Research + Analysis only, no implementation)

**Output:** Pattern catalog for the specified domain/task

---

## What This Command Does

The `/discover-patterns` command runs **only** the Research and Planning phases of orchestration:

1. **Researches** plugins related to your domain/keywords
2. **Analyzes** how plugins integrate and compose
3. **Discovers** patterns (common plugin sequences)
4. **Records** patterns in the pattern library
5. **Does NOT execute** any workflows

**Think of it as:** Learning what tool combinations exist before you need to use them.

---

## Basic Usage

```bash
/discover-patterns "[domain or keywords]"
```

**Examples:**

```bash
# Example 1: Domain exploration
/discover-patterns "container orchestration"

# Example 2: Technology stack
/discover-patterns "react typescript testing"

# Example 3: Task category
/discover-patterns "API security"

# Example 4: Broad domain
/discover-patterns "data engineering"
```

---

## How It Works (Research + Analysis Only)

### Phase 1: Plugin Research

```
⚙️ Phase 1: Researching plugins for "container orchestration"

[Agent 1] Analyzing capabilities...
  - docker-builder
  - kubernetes-deployer
  - docker-compose-generator
  - helm-chart-creator
  - container-scanner
  (15 plugins found)

[Agent 2] Mapping integrations...
  - docker-builder → kubernetes-deployer (image dependencies)
  - helm-chart-creator → kubernetes-deployer (deployment configs)
  (12 integration patterns found)

[Agent 3] Checking success rates...
  - docker-builder: 95% success rate
  - kubernetes-deployer: 87% success rate
  (historical data analyzed)

✓ Research complete (4 minutes)
```

### Phase 2: Pattern Discovery

```
⚙️ Phase 2: Discovering patterns...

Analyzing 15 plugins for common sequences...

Pattern 1: "Local → Staging → Production"
  Sequence: docker-builder → docker-compose → kubernetes-deployer
  Frequency: 34 occurrences
  Success rate: 89%
  Use case: Progressive deployment pipeline

Pattern 2: "Secure Container Workflow"
  Sequence: docker-builder → container-scanner → sign-image → registry-push
  Frequency: 23 occurrences
  Success rate: 92%
  Use case: Security-first container deployment

Pattern 3: "Helm-Based Deployment"
  Sequence: helm-chart-creator → values-generator → helm-deploy
  Frequency: 45 occurrences
  Success rate: 88%
  Use case: Kubernetes app deployment with Helm

✓ Discovery complete (3 minutes)
  - 3 patterns discovered
  - All patterns saved to library
```

### Output: Pattern Catalog

```markdown
# Pattern Catalog: Container Orchestration

## Discovered Patterns

### Pattern 1: Local → Staging → Production
**ID:** container-progressive-deployment-v1
**Success Rate:** 89%
**Uses:** 34
**Sequence:**
1. docker-builder (build images)
2. docker-compose (local testing)
3. kubernetes-deployer (staging deploy)
4. kubernetes-deployer (production deploy)

**When to use:** Progressive deployment with testing gates
**Estimated time:** ~15 minutes

---

### Pattern 2: Secure Container Workflow
**ID:** secure-container-workflow-v1
**Success Rate:** 92%
**Uses:** 23
**Sequence:**
1. docker-builder (build images)
2. container-scanner (security scan)
3. sign-image (cryptographic signing)
4. registry-push (upload to registry)

**When to use:** Security-first container deployment
**Estimated time:** ~10 minutes

---

### Pattern 3: Helm-Based Deployment
**ID:** helm-kubernetes-deployment-v1
**Success Rate:** 88%
**Uses:** 45
**Sequence:**
1. helm-chart-creator (generate chart)
2. values-generator (create values.yaml)
3. helm-deploy (deploy to K8s)

**When to use:** Kubernetes app deployment with Helm
**Estimated time:** ~8 minutes

---

## Plugin Inventory (15 total)

**Build & Package:**
- docker-builder (95% success)
- docker-compose-generator (90% success)
- helm-chart-creator (92% success)

**Deploy:**
- kubernetes-deployer (87% success)
- helm-deploy (88% success)

**Security:**
- container-scanner (94% success)
- sign-image (91% success)

**Registry:**
- registry-push (96% success)
- registry-manager (89% success)

... (6 more plugins)

---

## Next Steps

To use these patterns:

```bash
# Option 1: Orchestrate using discovered pattern
/orchestrate "Deploy container to Kubernetes" [pattern: helm-kubernetes-deployment-v1]

# Option 2: Let orchestrator choose best pattern
/orchestrate "Deploy container with security scanning"
(Will automatically select Pattern 2: Secure Container Workflow)

# Option 3: Create custom plan based on patterns
/plan container-deployment
(Reference patterns above for plugin sequence)
```
```

---

## What Gets Created

After `/discover-patterns` completes:

### 1. Pattern Catalog (Markdown)

Saved to: `.agents/patterns/[domain]-patterns.md`

Contains:
- All discovered patterns
- Plugin inventory
- Integration graph
- Recommendations

### 2. Updated Pattern Library

Patterns added to meta-orchestrator's pattern library:
- Available for future `/orchestrate` commands
- Searchable by keywords
- Ranked by success rate

### 3. Plugin Capability Map

Internal knowledge base updated with:
- Which plugins work in this domain
- How plugins integrate
- Success rates and known issues

---

## Advanced Usage

### Narrow by Technology

```bash
# Specific tech stack
/discover-patterns "API development fastapi python"

# Avoid certain tools
/discover-patterns "API development [avoid: graphql]"
```

### Depth Control

```bash
# Quick overview (top patterns only)
/discover-patterns --quick "container orchestration"

# Deep analysis (all possible patterns)
/discover-patterns --deep "container orchestration"

# Default: Balanced (proven patterns + some experimental)
/discover-patterns "container orchestration"
```

### Domain Filtering

```bash
# Limit to specific domain
/discover-patterns "authentication [domain: web-development]"

# Cross-domain (default)
/discover-patterns "authentication"
```

### Pattern Comparison

```bash
# Compare patterns across domains
/discover-patterns --compare "REST vs GraphQL API development"

# Output shows:
#   - Pattern overlap
#   - Unique plugins per approach
#   - Success rate comparison
#   - Time comparison
```

---

## Use Cases

### Use Case 1: Learning a New Domain

**Scenario:** You're new to Kubernetes and want to understand deployment workflows.

```bash
/discover-patterns "kubernetes deployment"
```

**Result:**
- See all Kubernetes-related plugins
- Understand common deployment patterns
- Learn which tools work together
- Get success rates to avoid pitfalls

**Value:** Learn proven approaches before starting work (avoid trial-and-error)

### Use Case 2: Choosing Between Technologies

**Scenario:** Should you use Docker Compose or Kubernetes?

```bash
/discover-patterns --compare "Docker Compose vs Kubernetes deployment"
```

**Result:**
- See patterns for each approach
- Compare success rates
- Understand complexity differences
- Make informed decision

**Value:** Data-driven technology choices

### Use Case 3: Building Domain Expertise

**Scenario:** You want to become proficient in data engineering workflows.

```bash
# Explore broad domain
/discover-patterns "data engineering"

# Then narrow down
/discover-patterns "ETL pipelines"
/discover-patterns "data quality validation"
/discover-patterns "data warehouse loading"
```

**Result:**
- Comprehensive pattern library for data engineering
- Understand sub-domains and their patterns
- Build mental model of tool ecosystem

**Value:** Structured learning path

### Use Case 4: Updating Knowledge

**Scenario:** New plugins have been added to marketplaces. What new patterns exist?

```bash
# Re-discover to find new patterns
/discover-patterns --refresh "API development"
```

**Result:**
- Analyze new plugins since last discovery
- Find new integration patterns
- Update success rates with recent data
- Deprecate old patterns if better ones exist

**Value:** Stay current with ecosystem evolution

---

## Integration with Other Commands

### Discover → Orchestrate

```bash
# Step 1: Learn what's possible
/discover-patterns "API security"

# Step 2: Use discovered pattern
/orchestrate "Secure my API" [pattern: api-security-hardening-v1]
```

### Discover → Plan → Implement

```bash
# Step 1: Discover patterns
/discover-patterns "container deployment"

# Step 2: Create custom plan (informed by patterns)
/plan container-deployment-custom

# Step 3: Implement
/implement container-deployment-custom
```

### Research → Discover → Orchestrate

```bash
# Step 1: Deep research on specific plugins
/research "What does kubernetes-deployer do?"

# Step 2: Discover how it fits into patterns
/discover-patterns "kubernetes deployment"

# Step 3: Use in orchestration
/orchestrate "Deploy my app to Kubernetes"
```

---

## Output Format

### Pattern Catalog Structure

```yaml
patterns:
  - id: pattern-id-v1
    name: "Pattern Name"
    domain: [domain]
    keywords: [keyword1, keyword2, ...]

    sequence:
      - step: 1
        plugin: plugin-name
        purpose: "What this step does"

    metrics:
      success_rate: 0.89
      usage_count: 34
      avg_time: "15 minutes"

    known_issues:
      - issue: "Description"
        fix: "Solution"

    when_to_use: "Use case description"

plugins:
  - name: plugin-name
    capabilities: [...]
    success_rate: 0.95
    domain: [domain]

integrations:
  - from: plugin-a
    to: plugin-b
    type: [data-flow | dependency | optional]
    compatibility: [high | medium | low]
```

---

## Performance

### How Fast Is It?

**Typical timing:**
- Research phase: 3-5 minutes (parallel sub-agents)
- Pattern analysis: 2-3 minutes (synthesis)
- **Total: 5-8 minutes**

**Faster than `/orchestrate` because:**
- No implementation phase (just research + analysis)
- No validation (no code execution)
- Can analyze multiple domains simultaneously

### Token Budget

**Stays well under 40%:**
- Research: 15-20k tokens
- Analysis: 3-5k tokens
- **Total: ~18-25k tokens (9-12.5%)**

**Very efficient:** Can discover patterns for 3-4 domains in one session

---

## Examples

### Example 1: Explore Web Development

```bash
/discover-patterns "modern web development"
```

**Output:**
```
Patterns discovered: 8

1. "Full-Stack Next.js App" (92% success, 67 uses)
   - next-scaffolder → prisma-setup → vercel-deploy

2. "React + FastAPI" (88% success, 45 uses)
   - create-react-app → fastapi-scaffolder → docker-compose

3. "JAMstack Deployment" (95% success, 89 uses)
   - gatsby-builder → netlify-deploy

... (5 more patterns)

Plugins analyzed: 34
Time: 6 minutes
```

### Example 2: Compare Approaches

```bash
/discover-patterns --compare "REST API vs GraphQL API"
```

**Output:**
```
Comparison: REST vs GraphQL

REST API Patterns (4 found):
- Average success rate: 89%
- Average time: 12 minutes
- Most popular: FastAPI + JWT + Redis (92% success)

GraphQL API Patterns (3 found):
- Average success rate: 85%
- Average time: 15 minutes
- Most popular: Apollo + Prisma (87% success)

Shared plugins: 40% (both use auth, cache, test tools)
Unique REST plugins: 60%
Unique GraphQL plugins: 60%

Recommendation: REST (higher success rate, faster, more patterns)
```

### Example 3: Domain Deep Dive

```bash
/discover-patterns --deep "security"
```

**Output:**
```
Deep analysis: Security domain

Patterns discovered: 12

Authentication:
- JWT auth workflow (89% success, 124 uses)
- OAuth2 integration (85% success, 78 uses)
- SSO setup (82% success, 34 uses)

Vulnerability Scanning:
- SAST + DAST + SCA (92% success, 56 uses)
- Container security (94% success, 67 uses)

Compliance:
- SOC2 audit prep (78% success, 12 uses)
- GDPR compliance (81% success, 23 uses)

Plugins analyzed: 45
Time: 9 minutes (deep mode)
```

---

## Troubleshooting

### Issue: "No patterns found"

**Cause:** Domain too niche or new

**Fix:**
```bash
# Broaden search
/discover-patterns "web development" (instead of "obscure-framework")

# Or use exploratory mode
/discover-patterns --explore "new domain"
(Will still find plugins even without existing patterns)
```

### Issue: "Too many patterns (overwhelming)"

**Cause:** Domain too broad

**Fix:**
```bash
# Narrow down
/discover-patterns "API development" → "REST API authentication"

# Or use quick mode
/discover-patterns --quick "API development"
(Shows only top 3 patterns)
```

### Issue: "Patterns seem outdated"

**Cause:** Pattern library not refreshed recently

**Fix:**
```bash
# Force refresh
/discover-patterns --refresh "domain"

# This re-analyzes plugins and updates success rates
```

---

## Best Practices

### 1. Discover Before Building

Always discover patterns before starting complex work:

```bash
# Good workflow:
/discover-patterns "kubernetes deployment"  # Learn first
/orchestrate "Deploy my app to K8s"         # Then execute

# Versus jumping in blind:
/orchestrate "Deploy to K8s"  # Might work, but you don't understand why
```

### 2. Use Comparison for Decisions

When choosing between approaches:

```bash
/discover-patterns --compare "Docker Compose vs Kubernetes"

# Make informed decision based on:
# - Success rates
# - Complexity (number of plugins)
# - Time required
# - Your specific needs
```

### 3. Keep Patterns Current

Periodically refresh knowledge:

```bash
# Every month or when new plugins added:
/discover-patterns --refresh "your primary domain"
```

### 4. Build Domain Libraries

Create comprehensive pattern libraries for your domains:

```bash
# Your primary work areas:
/discover-patterns "web development"
/discover-patterns "devops"
/discover-patterns "data engineering"

# Now orchestrator has strong knowledge for your work
```

---

## Related Commands

- **/orchestrate** - Use discovered patterns in actual workflows
- **/research** - Deep-dive research on specific plugins
- **/plan** - Create custom workflows based on patterns
- **/learn** - Extract patterns from completed work

---

## Command Options

```bash
# Basic usage
/discover-patterns "[domain or keywords]"

# Quick mode (top 3 patterns only)
/discover-patterns --quick "[domain]"

# Deep mode (all patterns, even experimental)
/discover-patterns --deep "[domain]"

# Compare approaches
/discover-patterns --compare "[approach1] vs [approach2]"

# Refresh existing patterns
/discover-patterns --refresh "[domain]"

# Exploratory (no existing patterns required)
/discover-patterns --explore "[new domain]"

# Domain filter
/discover-patterns "[keywords] [domain: specific-domain]"

# Technology preference
/discover-patterns "[keywords] [prefer: tech1, tech2]"
```

---

**Version:** 0.1.0
**Last Updated:** November 7, 2025
**Status:** Active command for meta-orchestrator skill
