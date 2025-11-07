# Getting Started with AgentOps

**Welcome to AgentOps** - Universal operating system for AI agents

---

## What You've Installed

**AgentOps Core:** Universal orchestration foundation
- 12 commands (research, plan, implement, validate, learn + variants)
- 9 base agents (reusable personas)
- 6 workflows (orchestration patterns)
- Skills framework (automation hooks)

**Think of it like Kubernetes:**
- You have the control plane (core orchestration)
- Now you need workloads (domain profiles)

---

## Two Paths Forward

### Path 1: Use Existing Profile (Quickest)

Install a community profile for your domain:

```bash
# DevOps (Kubernetes, containers, CI/CD)
./scripts/install.sh --profile devops

# Product Development (APIs, UIs, databases)
./scripts/install.sh --profile product-dev

# Data Engineering (pipelines, transformations, quality)
./scripts/install.sh --profile data-eng
```

**Then start using:**
```bash
/prime              # Interactive router loads your profile
/research "topic"   # Profile-specific research
/plan research.md   # Profile-specific planning
/implement plan.md  # Execute with validation
```

### Path 2: Create Custom Profile (Most Flexible)

Build a profile for your specific domain:

```bash
# 1. Read creation guide
cat docs/CREATE_PROFILE.md

# 2. Copy example template
cp -r profiles/example profiles/my-domain

# 3. Edit profile manifest
vim profiles/my-domain/profile.yaml

# 4. Create domain agents
vim profiles/my-domain/agents/my-agent.md

# 5. Install your profile
./scripts/install.sh --profile my-domain

# 6. Start using
/prime
```

---

## Core Commands (Available Now)

**Already available (no profile needed):**

### Context Loading
- `/prime` - Interactive context router
- `/prime-simple` - Quick orientation
- `/prime-complex` - Multi-phase orientation

### Research Phase
- `/research [topic]` - Deep exploration
- `/research-multi [topic]` - 3x parallel research

### Planning Phase
- `/plan [research]` - Detailed specification

### Implementation Phase
- `/implement [plan]` - Execution with validation

### Validation Phase
- `/validate` - Quality assurance
- `/validate-multi` - 3x parallel validation

### Learning Phase
- `/learn [topic]` - Pattern extraction

### Bundle Management
- `/bundle-save [name]` - Context compression
- `/bundle-load [name]` - Context restoration

**Profiles extend these with domain-specific behavior.**

---

## Example: Complete Workflow

### Without Profile (Core Only)

```bash
# 1. Research
/prime-complex
/research "implement caching layer"
# Output: research findings

# 2. Plan
/plan caching-research.md
# Output: detailed implementation spec

# 3. Implement
/implement caching-plan.md
# Output: working implementation

# 4. Validate
/validate
# Output: quality report

# 5. Learn
/learn caching-implementation
# Output: reusable pattern
```

### With Profile (Domain-Enhanced)

```bash
# Same workflow, but:
# - Profile adds domain-specific agents
# - Commands include domain patterns
# - Workflows understand your stack
# - Skills validate your tech

/prime  # Auto-loads your profile
/research "implement Kubernetes caching"
# → Uses kubernetes-specific research patterns
# → Checks cluster state
# → Finds similar K8s implementations
```

---

## Installation Paths

### Core Only (Platform)

```bash
# Install just the orchestration platform
./scripts/install.sh

# Result:
~/.agentops/core/
├── CONSTITUTION.md
├── commands/
├── agents/
├── workflows/
└── skills/
```

**Use when:**
- Learning AgentOps concepts
- Creating custom profile
- Working with universal patterns

### Core + Community Profile

```bash
# Install platform + domain package
./scripts/install.sh --profile devops

# Result:
~/.agentops/
├── core/          # Universal orchestration
└── profiles/
    └── devops/    # Domain-specific extensions
```

**Use when:**
- Profile exists for your domain
- Want domain-specific agents
- Need proven patterns

### Core + Custom Profile

```bash
# 1. Create profile
cp -r profiles/example profiles/my-domain
# Edit profile.yaml, agents, etc.

# 2. Install
./scripts/install.sh --profile my-domain

# Result:
~/.agentops/
├── core/
└── profiles/
    └── my-domain/  # Your custom extensions
```

**Use when:**
- Domain not covered by community
- Need organization-specific patterns
- Want to share internally

---

## Understanding Profiles

**Profiles = Kubernetes CRDs for AgentOps**

```yaml
# profiles/devops/profile.yaml

apiVersion: agentops.dev/v1
kind: Profile
metadata:
  name: devops
  description: DevOps workflows (K8s, containers, CI/CD)

spec:
  extends: core  # Always extends core

  agents:
    - kubernetes-debugger
    - container-builder
    - pipeline-architect

  workflows:
    - containerize-application
    - setup-ci-cd
    - deploy-to-kubernetes
```

**What profiles provide:**
- Domain-specific agents (your tech stack)
- Command overrides (domain context)
- Workflows (orchestrated patterns)
- Skills (validation + automation)

---

## Next Steps by Use Case

### "I want to try AgentOps quickly"

```bash
# Install with community profile
./scripts/install.sh --profile devops

# Try it
/prime
# Follow interactive prompts
```

**Time:** 5 minutes
**Learn:** How AgentOps works

### "I want to create custom agents for my stack"

```bash
# Read guides
cat docs/CREATE_PROFILE.md
cat docs/EXTEND_CORE.md

# Copy template
cp -r profiles/example profiles/my-stack

# Customize
vim profiles/my-stack/profile.yaml
```

**Time:** 1-2 hours
**Learn:** How to extend AgentOps

### "I want to understand AgentOps deeply"

```bash
# Read architecture
cat core/CONSTITUTION.md
ls core/commands/
ls core/agents/
ls core/workflows/

# Study examples
cat profiles/example/README.md
```

**Time:** 30 minutes
**Learn:** Core concepts and patterns

---

## Common Questions

### Q: Do I need a profile?

**A:** No, core works standalone. Profiles add domain-specific enhancements.

- **Core only:** Universal patterns work everywhere
- **With profile:** Domain-optimized agents and workflows

### Q: Can I use multiple profiles?

**A:** Not simultaneously. One profile per installation. But you can:

```bash
# Switch profiles
./scripts/install.sh --profile product-dev

# Or create combined profile
cp -r profiles/devops profiles/my-combined
# Add product-dev agents to my-combined
./scripts/install.sh --profile my-combined
```

### Q: How do profiles stay up-to-date with core?

**A:** Profiles declare core compatibility:

```yaml
metadata:
  core_compatibility: ">=1.0.0 <2.0.0"
```

Update core:
```bash
git pull origin main
# Profiles remain compatible within version range
```

### Q: Can I contribute my profile?

**A:** Yes! Publish to GitHub and submit to catalog:

```bash
git add profiles/my-domain/
git commit -m "feat(profiles): Add my-domain profile"
git push

# Submit PR or link in discussions
```

---

## Troubleshooting

### Installation fails

```bash
# Check prerequisites
which git
which bash

# Verify repository
git status

# Try manual installation
cp -r core ~/.agentops/core
```

### Profile not loading

```bash
# Check installation
ls ~/.agentops/profiles/[name]/

# Validate profile
./scripts/validate-profile.sh [name]

# Reinstall
./scripts/install.sh --profile [name]
```

### Commands not working

```bash
# Verify core installation
ls ~/.agentops/core/commands/

# Check PATH
echo $PATH | grep agentops

# Reload shell
source ~/.bashrc  # or ~/.zshrc
```

---

## Learning Resources

### Documentation
- **CREATE_PROFILE.md** - Build custom profiles
- **EXTEND_CORE.md** - Extend core capabilities
- **Core commands** - `core/commands/*.md`
- **Example profile** - `profiles/example/`

### Examples
- **DevOps profile** - `profiles/devops/`
- **Product Dev profile** - `profiles/product-dev/`
- **Workflows** - `core/workflows/*.md`

### Community
- **Forum:** [link]
- **GitHub Issues:** [link]
- **Discussions:** [link]

---

## Support

### Getting Help
- **Docs:** Read `docs/` guides
- **Examples:** Study `profiles/example/`
- **Validation:** Run `scripts/validate-profile.sh`
- **Community:** Ask in [forum]
- **Issues:** Report at [github]

### Contributing
- **Profiles:** Create and share
- **Documentation:** Improve guides
- **Core:** Enhance platform
- **Examples:** Add use cases

---

## Philosophy

**AgentOps is a platform, not a product.**

Like Kubernetes:
- **Core** = Control plane (stable orchestration)
- **Profiles** = CRDs (domain-specific resources)
- **Community** = Ecosystem (shared patterns)

**You extend core for your domain. Community benefits from your work.**

**Key insight:**
- Core provides universal patterns
- Profiles add domain expertise
- Together = powerful, flexible AI agent operations

---

## Quick Reference

### Installation

```bash
# Core only
./scripts/install.sh

# Core + profile
./scripts/install.sh --profile [name]

# Validate
./scripts/validate-profile.sh [name]
```

### Usage

```bash
# Start
/prime

# Research → Plan → Implement → Validate → Learn
/research [topic]
/plan research.md
/implement plan.md
/validate
/learn [topic]
```

### Profile Development

```bash
# Create
cp -r profiles/example profiles/[name]

# Edit
vim profiles/[name]/profile.yaml

# Test
./scripts/validate-profile.sh [name]
./scripts/install.sh --profile [name]
```

---

**Ready to start?**

1. **Quick try:** `./scripts/install.sh --profile devops` + `/prime`
2. **Custom profile:** Read `docs/CREATE_PROFILE.md`
3. **Deep dive:** Explore `core/` and `profiles/example/`

**Welcome to the AgentOps ecosystem!**
