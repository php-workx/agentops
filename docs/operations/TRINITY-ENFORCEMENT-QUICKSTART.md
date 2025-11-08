# Trinity Enforcement - Quick Start Guide

**5-minute guide to prevent AI agents from cluttering your root directories**

---

## 🎯 The Problem You Had

AI agents kept creating markdown files in root instead of docs/ across all 3 Trinity repos.

## ✅ The Solution Now Deployed

Automated validation system that STRICTLY enforces: **Only 8 files in root, everything else in subdirectories.**

---

## 🚀 Quick Start (Do This Now)

### Step 1: Validate Current State

```bash
# Check each repo
cd /Users/fullerbt/workspaces/personal/agentops
make validate-trinity-strict

cd /Users/fullerbt/workspaces/personal/12-factor-agentops
make validate-trinity-strict

cd /Users/fullerbt/workspaces/personal/agentops-showcase
make validate-trinity-strict
```

**Expected:** All will fail showing current violations.

### Step 2: Fix Violations (Copy-Paste These)

**agentops:**
```bash
cd /Users/fullerbt/workspaces/personal/agentops
mkdir -p docs/specification
mv CLAUDE.md docs/development/
mv CONSTITUTION.md docs/architecture/
make validate-trinity-strict
```

**12-factor-agentops:**
```bash
cd /Users/fullerbt/workspaces/personal/12-factor-agentops
mkdir -p docs/{architecture,project,reference,specification}
mv TRINITY.md docs/architecture/
mv MISSION.md docs/architecture/
mv CLAUDE.md docs/development/
mv NAVIGATION.md docs/development/
mv OPENSOURCE_STANDARDS.md docs/operations/
mv ECOSYSTEM_POSITIONING.md docs/project/
mv ANALYSIS_INDEX.md docs/specification/
mv IMPLEMENTATION_SUMMARY.md docs/specification/
mv REPOSITORY_STRUCTURE_ANALYSIS.md docs/specification/
mv V1_RELEASE_NOTES.md docs/specification/
mv EARLY_TESTER_GUIDE.md docs/guides/
make validate-trinity-strict
```

**agentops-showcase:**
```bash
cd /Users/fullerbt/workspaces/personal/agentops-showcase
mkdir -p docs/{project,reference}
mv TRINITY.md docs/architecture/
mv REORGANIZATION-PLAN.md docs/specification/
make validate-trinity-strict
```

### Step 3: Update Cross-References

After moving files, some links will break. Use global search/replace:

```bash
# In each repo
grep -r "TRINITY.md" . --exclude-dir=.git
# Update to: docs/architecture/TRINITY.md

grep -r "MISSION.md" . --exclude-dir=.git
# Update to: docs/architecture/MISSION.md

# Etc for each moved file
```

### Step 4: Integrate Into Workflow

**Before EVERY commit in ANY Trinity repo:**

```bash
make validate-trinity-strict
```

If it fails, fix the errors before committing.

---

## 🤖 For AI Agents

**When starting work in any Trinity repo, show them:**

```markdown
CRITICAL: Read docs/development/AI-RULES.md before creating any files.

Quick rules:
- Only 8 files allowed in root
- ALL docs go in docs/ subdirectories
- Run `make validate-trinity-strict` before every commit

Violate these rules and the commit will fail validation.
```

---

## 📋 The 8 Allowed Root Files

```
✅ README.md              (entry point)
✅ LICENSE                (legal)
✅ CONTRIBUTING.md        (how to contribute)
✅ CODE_OF_CONDUCT.md     (community standards)
✅ SECURITY.md            (security policy)
✅ CHANGELOG.md           (version history)
✅ VERSION                (semantic version)
✅ Makefile               (build/validation)
```

**Everything else → subdirectories**

---

## 📂 Where Things Go

| File Type | Location | Example |
|-----------|----------|---------|
| Architecture doc | docs/architecture/ | TRINITY.md, MISSION.md |
| Development guide | docs/development/ | CLAUDE.md, AI-RULES.md |
| Operations standard | docs/operations/ | This file! |
| Project doc | docs/project/ | roadmap.md, strategy.md |
| Spec/plan | docs/specification/ | plan.md, summary.md |
| Guide | docs/guides/ | setup.md, tutorial.md |
| Reference | docs/reference/ | api-docs.md, commands.md |

---

## 🔧 Key Commands

```bash
# Validate structure (STRICT)
make validate-trinity-strict

# Run all validations
make validate-all

# Show help
make help

# Direct script
./scripts/validate-structure-trinity.sh
```

---

## 📚 Full Documentation

- [TRINITY-REPO-STANDARDS.md](./TRINITY-REPO-STANDARDS.md) - Complete standard
- [TRINITY-ENFORCEMENT-SUMMARY.md](./TRINITY-ENFORCEMENT-SUMMARY.md) - Deployment details
- [AI-RULES.md](../development/AI-RULES.md) - AI agent instructions

---

## ✅ Success Checklist

**Today:**
- [ ] Run validation on all 3 repos
- [ ] Fix all current violations
- [ ] All validations passing

**This Week:**
- [ ] Run `make validate-trinity-strict` before every commit
- [ ] No new violations created
- [ ] AI agents following rules

**This Month:**
- [ ] Zero violations maintained
- [ ] Validation integrated into workflow
- [ ] Standards enforced automatically

---

## 🚨 If You See Violations

**AI agent created a file in root:**

```bash
# Validation will fail
make validate-trinity-strict

# Error will show:
# ❌ VIOLATION: SOME_FILE.md
#    → Must move to docs/ subdirectory

# Fix immediately:
mv SOME_FILE.md docs/appropriate-subdirectory/
make validate-trinity-strict

# Only commit after validation passes
```

---

## 💡 Pro Tips

1. **Add to your workflow:**
   ```bash
   alias validate-trinity='make validate-trinity-strict'
   ```

2. **Before committing large changes:**
   ```bash
   make validate-all
   ```

3. **When onboarding AI agents:**
   - First message: "Read docs/development/AI-RULES.md"
   - Validate after every file batch

4. **Set up pre-commit hook (optional):**
   ```bash
   cat > .git/hooks/pre-commit << 'EOF'
   #!/bin/bash
   make validate-trinity-strict || exit 1
   EOF
   chmod +x .git/hooks/pre-commit
   ```

---

**That's it! You now have enforced standards across all 3 Trinity repos.**

**Questions?** See [TRINITY-ENFORCEMENT-SUMMARY.md](./TRINITY-ENFORCEMENT-SUMMARY.md)

---

**Last Updated:** 2025-11-08
**Status:** ✅ Ready to use
