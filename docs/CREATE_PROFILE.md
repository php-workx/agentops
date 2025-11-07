# Creating Custom AgentOps Profiles

**Purpose:** Build domain-specific extensions of AgentOps core

**Like Kubernetes CRDs:** Profiles define custom resource types for your domain

---

## What is a Profile?

A profile is a domain-specific extension of the AgentOps core platform.

**Core provides:**
- Universal commands (research, plan, implement, validate, learn)
- Base agent personas (explorer, architect, executor roles)
- Workflow orchestrations (complete-cycle, debug-cycle, etc.)
- Skills framework (automation hooks)

**Profiles provide:**
- Domain-specific agents (your stack, your patterns)
- Domain-specific commands (override core with domain context)
- Domain-specific workflows (orchestrate for your domain)
- Domain-specific skills (validation, automation for your stack)

**Examples:**
- **devops:** Kubernetes, containers, CI/CD pipelines
- **product-dev:** APIs, UIs, databases, frontend frameworks
- **data-eng:** Data pipelines, transformations, quality checks
- **fintech:** Trading systems, compliance, risk management
- **healthcare:** HIPAA compliance, patient data, clinical workflows

---

## Profile Structure

```
profiles/[your-domain]/
├── profile.yaml          # Manifest (like Kubernetes CRD definition)
├── README.md             # Profile documentation
├── agents/               # Domain-specific agents
│   ├── [agent-1].md
│   └── [agent-2].md
├── commands/             # Domain-specific commands (optional overrides)
│   └── [command].md
├── workflows/            # Domain-specific orchestrations
│   └── [workflow].md
└── skills/               # Domain-specific automation
    ├── [script-skill].sh
    └── [ai-skill].md
```

---

## Quick Start

### 1. Copy Example Template

```bash
cp -r profiles/example profiles/my-domain
cd profiles/my-domain
```

### 2. Edit Profile Manifest

Edit `profile.yaml`:

```yaml
apiVersion: agentops.dev/v1
kind: Profile
metadata:
  name: my-domain
  description: Brief description of what this profile does
  version: 1.0.0
  author: Your Name

spec:
  # Always extend core
  extends: core

  # Define your agents
  agents:
    - name: my-domain-explorer
      description: Explore [your domain] patterns
      file: agents/my-domain-explorer.md
      model: sonnet
      tools: [Read, Grep, Glob]

  # Override commands (optional)
  commands:
    - name: research
      file: commands/research.md
      overrides: core/commands/research.md
      reason: Add [domain-specific] research patterns

  # Define workflows
  workflows:
    - name: my-domain-cycle
      description: Complete workflow for [your domain]
      file: workflows/my-domain-cycle.md

tags: [your, domain, tags]
```

### 3. Create Domain Agents

Create `agents/my-domain-explorer.md`:

```markdown
---
name: my-domain-explorer
description: Explore [your domain] codebase and patterns
model: sonnet
tools: Read, Grep, Glob, Bash
---

# [Your Domain] Explorer Agent

**Specialty:** Understanding [your stack] structure

**When to use:**
- New [your tech] project
- Understanding [your framework] patterns
- Mapping [your architecture] dependencies

## Approach

**Step 1: Discover [your domain] structure**
\```bash
# Find [your tech] files
find . -name "*.[your-extension]"

# Check [your framework] version
[your-version-command]
\```

**Step 2: Analyze [your domain] patterns**
[Domain-specific analysis steps]

## Output Format
[Domain-specific output structure]
```

### 4. Test Installation

```bash
# From repository root
./scripts/install.sh --profile my-domain
```

### 5. Validate Profile

```bash
./scripts/validate-profile.sh my-domain
```

### 6. Use Your Profile

```bash
/prime
# Your profile is now active!
```

---

## Profile Manifest Reference

### Required Fields

```yaml
apiVersion: agentops.dev/v1    # Always v1
kind: Profile                  # Always Profile
metadata:
  name: [domain-name]          # Lowercase, hyphens ok
  description: [brief-desc]    # One sentence
  version: [semver]            # e.g., 1.0.0

spec:
  extends: core                # Always extend core
```

### Optional Fields

```yaml
metadata:
  author: [your-name]
  homepage: [github-url]
  license: [license-type]      # Apache-2.0, MIT, etc.

spec:
  agents: [...]                # List of agents
  commands: [...]              # Command overrides
  workflows: [...]             # Workflow definitions
  skills: [...]                # Skills implementations

tags: [list, of, tags]         # For discovery
```

---

## Creating Domain Agents

### Agent Template

```markdown
---
name: [agent-name]
description: [what this agent does]
model: sonnet|opus
tools: [list, of, tools]
---

# [Agent Name]

**Specialty:** [What this agent is good at]

**When to use:**
- [Scenario 1]
- [Scenario 2]

## Core Capabilities

### 1. [Capability Name]
[What it does]

### 2. [Capability Name]
[What it does]

## Approach

**Step 1: [Action]**
\```bash
# Commands for this step
[domain-specific-command]
\```

**Step 2: [Action]**
[Specific approach for your domain]

## Output Format

\```markdown
# [Agent Output Structure]
[What the agent returns]
\```

## Domain Specialization

**This agent is specialized for:**
- [Your tech stack]
- [Your patterns]
- [Your workflows]
```

### Agent Examples by Domain

**DevOps:**
- `kubernetes-debugger` - Debug K8s deployments
- `container-builder` - Build and optimize containers
- `pipeline-architect` - Design CI/CD pipelines

**Product Dev:**
- `api-designer` - Design RESTful APIs
- `ui-component-builder` - Create React/Vue components
- `database-architect` - Design schemas

**Data Eng:**
- `pipeline-builder` - Build data pipelines
- `data-quality-checker` - Validate data quality
- `transformation-designer` - Design ETL logic

---

## Overriding Core Commands

You can override core commands to add domain-specific context:

### When to Override

✅ **Good reasons:**
- Add domain-specific research patterns
- Include domain-specific validation
- Customize output format for your tools

❌ **Bad reasons:**
- Completely replace core logic
- Remove core functionality
- Break compatibility with core

### Override Example

`commands/research.md`:

```markdown
---
overrides: core/commands/research.md
reason: Add Kubernetes-specific research patterns
---

# /research - Kubernetes-Enhanced Research

**Extends:** core/commands/research.md

**Additional capabilities for Kubernetes:**

## Kubernetes-Specific Research

**Step 1: Analyze Kubernetes manifests**
\```bash
# Find all K8s manifests
find . -name "*.yaml" -o -name "*.yml"

# Validate syntax
kubectl apply --dry-run=client -f .
\```

**Step 2: Check cluster state**
\```bash
# Current deployments
kubectl get deployments

# Resource usage
kubectl top nodes
\```

[Rest follows core/commands/research.md patterns]
```

---

## Creating Domain Workflows

Workflows orchestrate agents and commands for complete cycles:

```markdown
---
name: [workflow-name]
description: [what this workflow does]
estimated_time: [time-estimate]
phases: [number-of-phases]
---

# [Workflow Name]

**Purpose:** [What this workflow accomplishes]

**When to use:**
- [Scenario 1]
- [Scenario 2]

## Workflow Phases

\```
Phase 1: [Name] ([time])
   ↓
Phase 2: [Name] ([time])
   ↓
Phase 3: [Name] ([time])
\```

## Phase 1: [Name]

**Goal:** [What this phase achieves]

**Commands:**
\```bash
/[command-name] [args]
\```

**Agents used:**
- [agent-name]: [what they do]

**Output:** [What this phase produces]

[Repeat for each phase]

---

## Example: [Workflow Name] for [Use Case]

[Walk through concrete example]
```

---

## Implementing Skills

### Script-Based Skills

Fast, deterministic automation:

`skills/my-validator.sh`:

```bash
#!/bin/bash
# Skill: my-validator
# Purpose: Validate [domain-specific] files

set -e

# Run validation
[validation-command] "$@"

# Output results as JSON
cat <<EOF
{
  "skill": "my-validator",
  "status": "success",
  "results": {
    "files_checked": $count,
    "errors": $errors
  }
}
EOF
```

### AI-Powered Skills

Reasoning-based capabilities:

`skills/my-analyzer.md`:

```markdown
---
name: my-analyzer
description: Analyze [domain-specific] patterns
model: opus
tools: Read, Grep
token_budget: 15k
---

# [Skill Name]

**Purpose:** [What this skill does]

**When to use:**
- [Scenario 1]
- [Scenario 2]

**Approach:**
[How the skill works]

**Output:**
[What the skill returns]
```

---

## Profile Documentation (README.md)

Your profile's README should include:

```markdown
# [Profile Name]

**Domain:** [Your domain]
**Status:** [Stable|Beta|Alpha]

## What This Is

[Brief description of domain and profile purpose]

## Quick Start

\```bash
# Install
./scripts/install.sh --profile [name]

# Use
/prime
\```

## Agents

- **[agent-1]:** [description]
- **[agent-2]:** [description]

## Workflows

- **[workflow-1]:** [description]

## Skills

- **[skill-1]:** [description]

## Examples

### Example 1: [Use Case]
[Walkthrough]

## Requirements

- [Tool 1] version X.Y+
- [Tool 2] (optional)

## Support

- Issues: [github-issues-url]
- Docs: [docs-url]
```

---

## Testing Your Profile

### 1. Syntax Validation

```bash
# Validate YAML
yamllint profile.yaml

# Validate Markdown
markdownlint *.md agents/*.md workflows/*.md

# Validate scripts
shellcheck skills/*.sh
```

### 2. Structure Validation

```bash
./scripts/validate-profile.sh [your-profile]
```

### 3. Installation Test

```bash
# Test installation
./scripts/install.sh --profile [your-profile]

# Verify files copied
ls ~/.agentops/profiles/[your-profile]/
```

### 4. Functional Test

```bash
# Use profile
/prime
# Should load your profile

# Test agent
[Use your custom agent]

# Test workflow
[Execute your workflow]
```

---

## Sharing Your Profile

### 1. Publish to GitHub

```bash
git add profiles/[your-profile]/
git commit -m "feat(profiles): Add [your-profile] profile"
git push
```

### 2. Submit to Catalog (Future)

```bash
# Will be available when profile catalog launches
agentops profile publish [your-profile]
```

### 3. Document Installation

In your README:

```markdown
## Installation

\```bash
# From AgentOps repository
./scripts/install.sh --profile [your-profile]

# Or from your fork
git clone [your-fork]
cd [your-fork]
./scripts/install.sh --profile [your-profile]
\```
```

---

## Profile Versioning

Follow semantic versioning:

- **1.0.0** - Initial stable release
- **1.1.0** - Add new agents/workflows (backwards compatible)
- **1.0.1** - Bug fixes
- **2.0.0** - Breaking changes (incompatible with v1)

Update `profile.yaml`:

```yaml
metadata:
  version: 1.1.0
  changelog: |
    v1.1.0: Added kubernetes-debugger agent
    v1.0.1: Fixed validation script bug
    v1.0.0: Initial release
```

---

## Best Practices

### Do
- ✅ Extend core, don't replace it
- ✅ Document domain assumptions
- ✅ Provide working examples
- ✅ Test against core updates
- ✅ Use clear, descriptive names

### Don't
- ❌ Break core compatibility
- ❌ Assume tools are installed
- ❌ Skip validation
- ❌ Hardcode values
- ❌ Forget documentation

---

## Getting Help

- **Documentation:** `docs/EXTEND_CORE.md`
- **Example:** `profiles/example/`
- **Validation:** `scripts/validate-profile.sh`
- **Community:** [forum-link]
- **Issues:** [github-issues]

---

## Next Steps

1. Copy example template: `cp -r profiles/example profiles/[your-domain]`
2. Edit profile.yaml: Define your domain
3. Create agents: Add domain-specific agents
4. Test: `./scripts/validate-profile.sh [your-domain]`
5. Install: `./scripts/install.sh --profile [your-domain]`
6. Use: `/prime`
7. Share: Publish to GitHub

**Welcome to the AgentOps profile ecosystem!**
