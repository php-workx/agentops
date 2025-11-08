# Trinity Repository Standards

**Version:** 1.0.0
**Date:** 2025-11-08
**Scope:** All 3 Trinity repos (12-factor-agentops, agentops, agentops-showcase)

---

## 🎯 Purpose

This document defines **STRICT** repository organization standards enforced across all Trinity repositories to prevent documentation sprawl and maintain professional structure.

**Problem:** AI agents frequently create markdown files in root directory instead of docs/

**Solution:** Automated validation + clear rules + enforcement in all 3 repos

---

## 📜 The Golden Rules

### Rule #1: Root Directory Is Sacred

**ONLY these files allowed in root:**

```
repository/
├── README.md              # Entry point (REQUIRED)
├── LICENSE                # Legal (REQUIRED)
├── CONTRIBUTING.md        # How to contribute (REQUIRED)
├── CODE_OF_CONDUCT.md     # Community standards (REQUIRED)
├── SECURITY.md            # Security policy (REQUIRED)
├── CHANGELOG.md           # Version history (REQUIRED)
├── VERSION                # Semantic version (REQUIRED)
├── Makefile               # Build/validation targets (REQUIRED)
├── CLAUDE.md              # AI agent instructions (REQUIRED)
├── CONSTITUTION.md        # Core principles (OPTIONAL - agentops only)
├── .gitignore             # Git ignores
└── package.json           # If applicable (showcase only)
```

**Note:** CLAUDE.md must be in root so AI agents see it immediately.

### Rule #2: ALL Documentation Goes in docs/

**ALL of these go in docs/ subdirectories:**
- ❌ TRINITY.md → ✅ docs/architecture/TRINITY.md
- ❌ MISSION.md → ✅ docs/architecture/MISSION.md
- ✅ CLAUDE.md → ✅ ROOT (so AI agents see it immediately)
- ✅ CONSTITUTION.md → ✅ ROOT (agentops only - optional)
- ❌ IMPLEMENTATION_SUMMARY.md → ✅ docs/specification/IMPLEMENTATION-SUMMARY.md
- ❌ REORGANIZATION-PLAN.md → ✅ docs/specification/REORGANIZATION-PLAN.md
- ❌ Any other .md file → ✅ docs/{category}/{filename}.md

**Exception:** CLAUDE.md stays in root across all Trinity repos.

### Rule #3: Validation Before Commit

**REQUIRED workflow:**
```bash
# Before EVERY commit
make validate-all

# Fix any errors
# Then commit
git commit -m "message"
```

---

## 📂 Standard Directory Structure

All Trinity repos follow this structure:

```
repository-name/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── CHANGELOG.md
├── VERSION
├── Makefile
├── .gitignore
│
├── docs/                           # ALL documentation
│   ├── README.md                   # Docs index
│   ├── architecture/               # System design, Trinity, Mission
│   ├── development/                # Setup, contributing (AI agent rules)
│   ├── guides/                     # How-to guides
│   ├── operations/                 # Standards, workflows
│   ├── reference/                  # API docs, command reference
│   ├── project/                    # Project management
│   └── specification/              # Specs, plans, summaries
│
├── scripts/                        # Automation
│   ├── validate.sh
│   ├── validate-structure.sh
│   ├── validate-doc-links.sh
│   └── validate-trinity.sh
│
└── [repo-specific dirs]
    └── (core/, profiles/, src/, etc.)
```

---

## 🔍 Repository-Specific Structures

### 12-factor-agentops (Philosophy Layer)

**Purpose:** WHY we do things

**Specific structure:**
```
12-factor-agentops/
├── [standard root files]
├── docs/
├── scripts/
├── foundations/           # Core concepts
├── patterns/             # Design patterns
├── product/              # Product strategy
└── specs/                # Specifications
```

### agentops (Orchestration Layer)

**Purpose:** HOW to execute patterns

**Specific structure:**
```
agentops/
├── [standard root files]
├── docs/
├── scripts/
├── core/                 # Core components
│   ├── agents/
│   ├── commands/
│   ├── skills/
│   └── workflows/
├── profiles/             # User profiles
├── plugins/              # Plugin system
└── tests/
```

### agentops-showcase (Presentation Layer)

**Purpose:** WHAT users experience

**Specific structure:**
```
agentops-showcase/
├── [standard root files]
├── docs/
├── scripts/
├── src/                  # Next.js app
│   ├── app/
│   └── components/
├── content/              # Content management
└── public/
```

---

## 🚨 Common Violations & Fixes

| ❌ Violation | ✅ Correct Placement | Reason |
|-------------|---------------------|--------|
| TRINITY.md | docs/architecture/TRINITY.md | Not a root entry point |
| MISSION.md | docs/architecture/MISSION.md | Not a root entry point |
| CLAUDE.md | docs/development/CLAUDE.md | Development guide, not entry point |
| CONSTITUTION.md | docs/architecture/CONSTITUTION.md | Architecture doc, not entry point |
| Any-Plan.md | docs/specification/{name}.md | Specification, not entry point |
| Any-Summary.md | docs/specification/{name}.md | Specification, not entry point |
| Any-Strategy.md | docs/project/{name}.md | Project doc, not entry point |

**Key insight:** Only documents that are critical entry points for NEW users belong in root.

---

## 🛡️ Enforcement Mechanisms

### 1. Validation Scripts (Automated)

**Location:** `scripts/validate-structure.sh` in each repo

**What it checks:**
- ✅ All required root files present
- ✅ No unauthorized markdown files in root
- ✅ Required directories exist
- ✅ Scripts are executable

**Usage:**
```bash
# From any Trinity repo
make validate-structure
```

### 2. Makefile Targets (Easy Access)

**Available in all repos:**
```bash
make validate-structure   # Check structure
make validate-docs        # Check doc links
make validate-all         # Run all validations
make trinity-validate     # Check Trinity alignment
```

### 3. Pre-Commit Hooks (Optional)

**Setup:**
```bash
# In any Trinity repo
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
make validate-all || exit 1
EOF
chmod +x .git/hooks/pre-commit
```

### 4. AI Agent Instructions

**File:** `docs/development/CLAUDE.md` in each repo

**Must contain:**
- Link to this standard
- Explicit rules about file placement
- Validation command before every tool call batch

---

## 🤖 AI Agent Protocol

**For AI agents working in Trinity repos:**

### Before Creating ANY File

1. **Check file type:**
   - Is it one of the 8 allowed root files? → Root
   - Is it markdown? → docs/
   - Is it a script? → scripts/
   - Is it code? → Repo-specific directory

2. **Determine docs/ subdirectory:**
   - Architecture/system design → docs/architecture/
   - Development/setup → docs/development/
   - How-to guide → docs/guides/
   - Standards/operations → docs/operations/
   - API/command reference → docs/reference/
   - Project management → docs/project/
   - Specs/plans → docs/specification/

3. **Validate before commit:**
   ```bash
   make validate-all
   ```

### Never Ever

- ❌ Create markdown in root (except the 8 allowed)
- ❌ Skip validation before committing
- ❌ Create new "exception" rules
- ❌ Move files without updating cross-references

### Always Always

- ✅ Place docs in docs/ subdirectories
- ✅ Run `make validate-all` before committing
- ✅ Update links when moving files
- ✅ Follow the standard, no shortcuts

---

## 📊 Validation Checklist

### Daily (Before Every Commit)

- [ ] Run `make validate-all`
- [ ] Fix any structure errors
- [ ] Fix any broken doc links
- [ ] Verify Trinity alignment (if changed VERSION/MISSION)
- [ ] Commit only after passing validation

### Weekly (Maintenance)

- [ ] Audit root directory for stray files
- [ ] Check docs/ organization
- [ ] Verify all 3 Trinity repos aligned
- [ ] Update this standard if new patterns emerge

### Monthly (Health Check)

- [ ] Review all markdown files in all repos
- [ ] Check for documentation sprawl
- [ ] Verify validation scripts work correctly
- [ ] Ensure AI agents following rules

---

## 🔧 Implementation Guide

### Step 1: Deploy to All Repos

For each of 12-factor-agentops, agentops, agentops-showcase:

```bash
cd /path/to/repo

# Copy validation scripts
cp -r /path/to/agentops/scripts/validate*.sh scripts/

# Make executable
chmod +x scripts/*.sh

# Add Makefile targets (if missing)
cat >> Makefile << 'EOF'
.PHONY: validate-structure validate-docs validate-all
validate-structure:
	@./scripts/validate-structure.sh
validate-docs:
	@./scripts/validate-doc-links.sh
validate-all:
	@./scripts/validate.sh
EOF

# Test validation
make validate-all
```

### Step 2: Move Violating Files

**12-factor-agentops:**
```bash
cd 12-factor-agentops
mkdir -p docs/{architecture,development,specification}

# Move files
mv TRINITY.md docs/architecture/
mv MISSION.md docs/architecture/
mv CLAUDE.md docs/development/
mv IMPLEMENTATION_SUMMARY.md docs/specification/
mv OPENSOURCE_STANDARDS.md docs/operations/
mv REPOSITORY_STRUCTURE_ANALYSIS.md docs/specification/
mv ECOSYSTEM_POSITIONING.md docs/project/
mv ANALYSIS_INDEX.md docs/specification/
mv NAVIGATION.md docs/development/

# Update cross-references (search and replace)
# Validate
make validate-all
```

**agentops:**
```bash
cd agentops
mkdir -p docs/architecture

# Move files
mv CLAUDE.md docs/development/
mv CONSTITUTION.md docs/architecture/

# Validate
make validate-all
```

**agentops-showcase:**
```bash
cd agentops-showcase
mkdir -p docs/architecture docs/specification

# Move files (already done based on file search)
# Just validate
make validate-all
```

### Step 3: Update AI Agent Instructions

In each repo's `docs/development/CLAUDE.md`, add:

```markdown
## 🚨 CRITICAL: File Placement Rules

**READ THIS BEFORE CREATING ANY FILE**

See: [Trinity Repository Standards](../../docs/operations/TRINITY-REPO-STANDARDS.md)

### Quick Rules

1. **Only 8 files allowed in root:**
   - README.md, LICENSE, CONTRIBUTING.md, CODE_OF_CONDUCT.md,
     SECURITY.md, CHANGELOG.md, VERSION, Makefile

2. **ALL other markdown goes in docs/**

3. **Validate before EVERY commit:**
   ```bash
   make validate-all
   ```

4. **No exceptions. Not even for "important" docs.**

### Common Mistakes to AVOID

❌ Creating TRINITY.md in root → ✅ Use docs/architecture/TRINITY.md
❌ Creating MISSION.md in root → ✅ Use docs/architecture/MISSION.md
❌ Creating any-plan.md in root → ✅ Use docs/specification/any-plan.md
❌ Skipping validation → ✅ Always run `make validate-all`
```

### Step 4: Test Enforcement

```bash
# In each repo
cd /path/to/repo

# Test 1: Create violation
echo "# Test" > TEST_VIOLATION.md
make validate-structure
# Should FAIL with error about TEST_VIOLATION.md

# Test 2: Clean up
rm TEST_VIOLATION.md
make validate-structure
# Should PASS

# Test 3: Full validation
make validate-all
# Should PASS all checks
```

---

## 📈 Success Metrics

### Week 1

- [ ] All 3 repos have validation scripts
- [ ] All Makefiles have validation targets
- [ ] All stray markdown moved to docs/
- [ ] All validations passing

### Month 1

- [ ] Zero new violations in any repo
- [ ] AI agents consistently following rules
- [ ] Pre-commit hooks adopted (optional)
- [ ] Documentation well-organized

### Quarter 1

- [ ] Validation automated in CI/CD (future)
- [ ] Zero manual enforcement needed
- [ ] Template for new Trinity-aligned repos
- [ ] Standard adopted by other projects

---

## 🔗 Related Documentation

### This Repo (agentops)
- [OPERATIONAL-STANDARDS.md](./OPERATIONAL-STANDARDS.md) - General standards
- [VALIDATION-WORKFLOW.md](./VALIDATION-WORKFLOW.md) - Validation procedures

### Trinity Integration
- [../project/TRINITY.md](../project/TRINITY.md) - Trinity architecture
- [../../MISSION.md](../../MISSION.md) - Trinity mission (WILL MOVE to docs/)

### Validation Scripts
- [../../scripts/validate.sh](../../scripts/validate.sh) - Main validation
- [../../scripts/validate-structure.sh](../../scripts/validate-structure.sh) - Structure check

---

## ❓ FAQ

**Q: Why so strict about root directory?**
A: Professional open source projects have clean root directories. It signals quality and makes repos easier to navigate.

**Q: What if I have an "important" document?**
A: Importance doesn't determine placement. Entry point status does. TRINITY.md is important but not an entry point → docs/architecture/

**Q: Can I create exceptions?**
A: No. Exceptions lead to chaos. Follow the standard or propose changes via PR.

**Q: What about legacy files in root?**
A: Move them. Update cross-references. Validate. Document moves in CHANGELOG.md.

**Q: How do I enforce this for AI agents?**
A: This standard + validation scripts + clear instructions in CLAUDE.md + validation before every commit.

**Q: What if validation fails?**
A: Fix the errors. Don't skip validation. Don't work around it. Fix it.

---

## 📝 Change Log

### 2025-11-08
- ✅ Created TRINITY-REPO-STANDARDS.md
- ✅ Defined 8 allowed root files (no exceptions)
- ✅ Established docs/ subdirectory structure
- ✅ Created validation checklist
- ✅ Documented enforcement mechanisms
- ✅ Provided implementation guide

---

## 🤝 Contributing

**To update this standard:**

1. Propose changes via PR
2. Discuss in PR comments
3. Require approval from all Trinity repo maintainers
4. Update standard
5. Deploy changes to all 3 repos
6. Update CHANGELOG.md in all repos

**Standard evolution:**
- Version 1.x.x = Minor clarifications
- Version 2.x.x = Structural changes

---

**Standards are not suggestions. They are contracts.** 🎯

**Enforce Early. Enforce Often. Enforce Always.**
