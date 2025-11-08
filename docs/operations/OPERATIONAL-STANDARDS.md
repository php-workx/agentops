# Operational Standards - AgentOps

**Version:** 0.9.0
**Date:** November 8, 2025
**Purpose:** Central index for all operational standards and best practices

---

## 📋 Overview

This document serves as the central index for all operational standards in the agentops project (Orchestration Layer).

**Core Principle:** Documentation-driven development with validation workflows to ensure consistency, quality, and Trinity alignment.

---

## 📚 Documentation Index

### 📖 Repository Standards

**What it covers:**
- File organization conventions
- Required root files (LICENSE, CONTRIBUTING, etc.)
- Documentation structure (docs/, core/, profiles/)
- Markdown formatting standards
- Link validation requirements

**Quick Reference:**
```bash
# Validate repository structure
make validate-structure

# Validate documentation links
make validate-docs

# Run all validations
make validate-all
```

**Required Files (Root):**
- `README.md` - Project overview
- `LICENSE` - MIT License
- `CONTRIBUTING.md` - Contribution guidelines
- `CODE_OF_CONDUCT.md` - Community standards
- `SECURITY.md` - Security policy
- `CHANGELOG.md` - Version history
- `VERSION` - Current version (Trinity-aligned)
- `Makefile` - Build and validation targets

**Directory Structure:**
```
agentops/
├── core/                    # Core components
│   ├── agents/             # Agent specifications
│   ├── commands/           # Command definitions
│   ├── skills/             # Reusable skills
│   └── workflows/          # Workflow patterns
├── docs/                   # Documentation
│   ├── architecture/       # System architecture
│   ├── guides/             # How-to guides
│   ├── operations/         # Operational standards
│   ├── project/            # Project management
│   └── reference/          # Reference documentation
├── profiles/               # User profiles
│   ├── base/              # Base profile
│   ├── devops/            # DevOps profile
│   └── product-dev/       # Product development profile
├── scripts/               # Automation scripts
│   ├── validate.sh        # Main validation
│   ├── validate-structure.sh
│   ├── validate-doc-links.sh
│   └── validate-trinity.sh
└── tests/                 # Test suites
```

---

### 🔱 Trinity Architecture

**Primary Documents:**
- [docs/project/TRINITY.md](../project/TRINITY.md) - Trinity integration
- [MISSION.md](../../MISSION.md) - Unified mission statement
- [VERSION](../../VERSION) - Version alignment

**What they cover:**
- Trinity architecture (Philosophy → Orchestration → Presentation)
- Cross-repository alignment
- Version synchronization
- Documentation standards

**Quick Reference:**
```bash
# Validate Trinity alignment
make trinity-validate

# Show Trinity status
make trinity-status
```

**Trinity Repositories:**
- **12-factor-agentops** (Mind) - WHY we do things
- **agentops** (Engine) - HOW to execute patterns
- **agentops-showcase** (Voice) - WHAT users experience

---

### 🔧 Development Standards

**Core Components:**
- **Agents:** Specialized AI agents (change-executor, spec-architect, etc.)
- **Commands:** User-facing commands (/plan, /implement, /validate, etc.)
- **Workflows:** Multi-agent orchestration patterns
- **Profiles:** Domain-specific configurations

**Quality Gates:**
- Repository structure validation (required)
- Documentation link validation (required)
- Trinity alignment validation (required)
- Markdown formatting consistency (recommended)

**Development Commands:**
```bash
# Validate before committing
make validate-all

# Check repository structure
make validate-structure

# Validate documentation links
make validate-docs

# Check Trinity alignment
make trinity-validate

# Clean build artifacts
make clean
```

---

### 📝 Validation Workflow

**Primary Document:** [VALIDATION-WORKFLOW.md](./VALIDATION-WORKFLOW.md)

**What it covers:**
- Pre-commit validation workflow
- Manual validation procedures
- Common validation issues and fixes
- Integration with Git hooks (optional)

**Validation Levels:**

**Level 1: Structure Validation**
- Required files present
- Directory structure correct
- No stray markdown in root
- Scripts are executable

**Level 2: Documentation Validation**
- All internal links valid
- No broken references
- Cross-references consistent

**Level 3: Trinity Validation**
- VERSION files aligned
- MISSION.md synchronized
- Trinity documentation present
- Git status clean

**Quick Workflow:**
```bash
# Before committing
./scripts/validate.sh

# Or using Make
make validate-all

# If errors, fix and re-run
```

---

## 🎯 Content & Design Standards

### Documentation Philosophy

**Principles:**
- **Clarity:** Write for humans, not machines
- **Completeness:** Document the why, not just the what
- **Consistency:** Follow established patterns
- **Discoverability:** Cross-link related content
- **Maintainability:** Keep documentation close to code

**Markdown Standards:**
- Use ATX-style headers (`# Header`)
- Include table of contents for long documents
- Use code fences with language tags
- Include examples and quick references
- Cross-link related documents

**Content Organization:**
```
docs/
├── architecture/         # System design
├── guides/              # Step-by-step instructions
├── operations/          # Standards and procedures
├── project/             # Project management
└── reference/           # API and command reference
```

### Profile Standards

**What is a Profile?**
A profile is a pre-configured set of:
- Commands (what the user can do)
- Agents (who executes the work)
- Skills (reusable capabilities)
- Workflows (orchestration patterns)

**Profile Structure:**
```
profiles/{name}/
├── README.md           # Profile overview
├── config.yaml         # Configuration
├── commands/           # Custom commands
├── agents/             # Custom agents
└── workflows/          # Custom workflows
```

**Base Profile:**
All profiles extend the base profile, which includes:
- Core commands (/plan, /implement, /validate)
- Core agents (change-executor, spec-architect)
- Core workflows (complete-cycle, quick-fix)

---

## 🚀 Version Control Standards

### Git Workflow

**Branch Strategy:**
- `main`: Stable releases
- `develop`: Integration branch (optional)
- `feature/*`: Feature branches
- `fix/*`: Bug fix branches

**Commit Messages:**
```
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore
Scope: agent, command, workflow, profile, docs
```

**Examples:**
```
feat(command): add /research-multi command for parallel research
fix(agent): improve error handling in change-executor
docs(operations): create operational standards index
chore(scripts): update validation workflow
```

---

## 📊 Version Management

### Current Version

**Maintained in:** `VERSION` file (root)

**Format:** Semantic versioning (MAJOR.MINOR.PATCH)

**Current:** 0.9.0

**Version Alignment:**
- **Philosophy (12-factor-agentops):** Must match
- **Orchestration (agentops):** Must match
- **Presentation (agentops-showcase):** Should match (optional)

**Update Process:**
1. Update `VERSION` file in agentops
2. Update `VERSION` file in 12-factor-agentops
3. Update `VERSION` file in agentops-showcase (optional)
4. Run `make trinity-validate` to verify
5. Update `CHANGELOG.md` in all repos
6. Commit with message: `chore: bump version to X.Y.Z`

---

## 🔍 Troubleshooting

### Validation Failures

**Structure Validation Fails:**
- Check required files exist in root
- Verify directory structure matches standards
- Move stray markdown files to docs/

**Link Validation Fails:**
- Check broken links reported by validator
- Update or remove broken references
- Verify file paths are correct (case-sensitive)

**Trinity Validation Fails:**
- Check VERSION files match across repos
- Verify sibling repositories exist
- Update MISSION.md if content differs

### Common Issues

| Issue | Fix |
|-------|-----|
| Scripts not executable | `chmod +x scripts/*.sh` |
| Missing directories | `mkdir -p docs/operations` |
| Broken internal links | Update paths to match file locations |
| Version mismatch | Update VERSION files in all Trinity repos |

---

## 📖 Learning Resources

### Internal Documentation

**Architecture:**
- [docs/architecture/README.md](../architecture/README.md) - System overview
- [docs/architecture/phase-based-workflow.md](../architecture/phase-based-workflow.md)
- [docs/architecture/multi-agent-orchestration.md](../architecture/multi-agent-orchestration.md)

**Guides:**
- [docs/GET_STARTED.md](../GET_STARTED.md) - Getting started
- [docs/guides/SETUP_INSTRUCTIONS.md](../guides/SETUP_INSTRUCTIONS.md)
- [docs/CREATE_PROFILE.md](../CREATE_PROFILE.md) - Creating profiles

**Reference:**
- [docs/reference/commands/](../reference/commands/) - Command reference
- [docs/reference/agents/](../reference/agents/) - Agent reference

### External Resources

**Trinity Documentation:**
- [12-factor-agentops](https://github.com/boshu2/12-factor-agentops) - Philosophy
- [agentops-showcase](https://github.com/boshu2/agentops-showcase) - Presentation

---

## 🎯 Validation Policy Summary

### Golden Rules

1. **Always Validate Before Committing**
   - Run `make validate-all` before pushing
   - Fix errors, not skip validations
   - Document why validation can't pass (if rare case)

2. **Maintain Documentation**
   - Keep docs/ up to date
   - Cross-link related content
   - Validate all internal links

3. **Follow Trinity Standards**
   - Synchronize VERSION across repos
   - Align MISSION.md content
   - Validate Trinity alignment regularly

4. **Quality Gates**
   - Structure validation: REQUIRED
   - Link validation: REQUIRED
   - Trinity validation: REQUIRED
   - Trinity alignment: RECOMMENDED

### Benefits

✅ **Consistency** - Uniform structure across repository
✅ **Quality** - Catch issues before they reach users
✅ **Discoverability** - Valid links improve navigation
✅ **Alignment** - Trinity repos stay synchronized
✅ **Confidence** - Validated changes are safe to merge

---

## 🔗 Quick Links

### Primary Documents
- [VALIDATION-WORKFLOW.md](./VALIDATION-WORKFLOW.md) - Validation procedures
- [../project/TRINITY.md](../project/TRINITY.md) - Trinity integration
- [../../CONTRIBUTING.md](../../CONTRIBUTING.md) - Contribution guidelines
- [../../README.md](../../README.md) - Project overview

### Validation Scripts
- [../../scripts/validate.sh](../../scripts/validate.sh) - Main validation
- [../../scripts/validate-structure.sh](../../scripts/validate-structure.sh) - Structure check
- [../../scripts/validate-doc-links.sh](../../scripts/validate-doc-links.sh) - Link validation
- [../../scripts/validate-trinity.sh](../../scripts/validate-trinity.sh) - Trinity alignment

### Trinity Repositories
- [12-factor-agentops](../../../12-factor-agentops/) - Philosophy layer
- [agentops-showcase](../../../agentops-showcase/) - Presentation layer

---

## 📝 Change Log

### 2025-11-08
- ✅ Created OPERATIONAL-STANDARDS.md
- ✅ Created VALIDATION-WORKFLOW.md
- ✅ Added validation scripts (validate.sh, validate-structure.sh, validate-doc-links.sh)
- ✅ Updated Makefile with validation targets
- ✅ Established opensource standards enforcement
- ✅ Documented repository structure requirements
- ✅ Created quick reference guides

---

## 🤝 Contributing

When adding new standards:

1. **Update this index** with link and summary
2. **Cross-link** from related documents
3. **Update Makefile** if new validation added
4. **Document validation** if new checks required
5. **Version control** with clear commit messages

**Questions?** See [../../CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines or [VALIDATION-WORKFLOW.md](./VALIDATION-WORKFLOW.md) for validation procedures.

---

*Operational discipline for orchestration, just like for agents.* 🎯

**Standards-Based. Documentation-Driven. Trinity-Aligned.**
