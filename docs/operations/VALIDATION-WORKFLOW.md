# Validation Workflow

**Quick Reference** for automated validation before commits and pushes

---

## 🎯 What Happens When You Commit

```
git add . && git commit -m "message"
         ↓
┌────────────────────────────────────────┐
│ 🔍 Manual Validation (Optional)       │
│ Run: make validate-all                │
└────────────────────────────────────────┘
         ↓
┌────────────────────────────────────────┐
│ 📝 Commit Created                      │
│ Changes staged and committed           │
└────────────────────────────────────────┘
         ↓
    Ready to push
```

---

## ✅ Normal Usage (Recommended)

```bash
# Make changes
git add .

# Validate before committing (recommended)
make validate-all

# Commit changes
git commit -m "feat: add feature"

# Push
git push origin branch
```

---

## 🔍 Validation Levels

### Level 1: Structure Validation

**Command:** `make validate-structure`

**Checks:**
- ✅ Required root files exist (LICENSE, CONTRIBUTING, etc.)
- ✅ Directory structure correct (docs/, core/, profiles/)
- ✅ No stray markdown files in root
- ✅ Validation scripts are executable
- ✅ Core and profile directories present

**Time:** ~1-2 seconds

### Level 2: Documentation Validation

**Command:** `make validate-docs`

**Checks:**
- ✅ All internal markdown links valid
- ✅ No broken references to files
- ✅ Cross-references consistent
- ✅ Paths case-sensitive correct

**Time:** ~2-5 seconds (depends on doc count)

### Level 3: Trinity Validation

**Command:** `make trinity-validate`

**Checks:**
- ✅ VERSION files aligned across Trinity repos
- ✅ MISSION.md synchronized
- ✅ Trinity documentation files present
- ✅ Git status clean for Trinity files
- ✅ Sibling repositories exist

**Time:** ~1-3 seconds

### All Validations

**Command:** `make validate-all`

**Runs:**
1. Structure validation
2. Documentation validation
3. Trinity validation

**Time:** ~5-10 seconds total

---

## 🔧 Manual Validation

### Quick Validation

```bash
# Validate everything before committing
make validate-all
```

### Specific Validations

```bash
# Check only structure
make validate-structure

# Check only documentation links
make validate-docs

# Check only Trinity alignment
make trinity-validate
```

### Using Scripts Directly

```bash
# Main validation script
./scripts/validate.sh

# Individual checks
./scripts/validate-structure.sh
./scripts/validate-doc-links.sh
./scripts/validate-trinity.sh
```

---

## 🚨 If Validation Fails

### Check What Failed

```bash
# Run validation with full output
make validate-all

# Or run individual checks
./scripts/validate-structure.sh
./scripts/validate-doc-links.sh
./scripts/validate-trinity.sh
```

### Common Issues

| Error | Fix |
|-------|-----|
| Missing required file | Create the required file (e.g., LICENSE, CONTRIBUTING.md) |
| Stray markdown in root | Move file to docs/ directory |
| Broken documentation link | Update link path or fix referenced file |
| VERSION mismatch | Update VERSION file to match Trinity repos |
| Script not executable | Run `chmod +x scripts/*.sh` |
| Missing directory | Create required directory structure |

---

## 📁 Files Involved

```
agentops/
├── Makefile                          # Validation targets
├── VERSION                           # Version alignment
├── scripts/
│   ├── validate.sh                   # Main validation (all checks)
│   ├── validate-structure.sh         # Structure validation
│   ├── validate-doc-links.sh         # Link validation
│   └── validate-trinity.sh           # Trinity alignment
└── docs/
    └── operations/
        ├── OPERATIONAL-STANDARDS.md  # Standards index
        └── VALIDATION-WORKFLOW.md    # This file
```

---

## 🎛️ Configuration

### Makefile Targets

**Location:** `Makefile` (root)

**Validation Targets:**
```makefile
validate-structure    # Check repository structure
validate-docs         # Check documentation links
validate-all          # Run all validations
trinity-validate      # Check Trinity alignment
trinity-status        # Show Trinity status
```

### Validation Scripts

**Location:** `scripts/` directory

**Scripts:**
- `validate.sh` - Main validation (orchestrates all checks)
- `validate-structure.sh` - Repository structure checks
- `validate-doc-links.sh` - Documentation link validation
- `validate-trinity.sh` - Trinity alignment validation

**Requirements:**
- Bash 4.0+
- Git (for Trinity validation)
- Standard Unix tools (find, grep, etc.)

---

## 📊 Performance Impact

| Validation | Time | When to Run |
|------------|------|-------------|
| Structure | ~1-2s | Before every commit |
| Documentation | ~2-5s | Before every commit |
| Trinity | ~1-3s | Before push to main |
| All | ~5-10s | Before every commit (recommended) |

**Trade-off:** Catch issues locally vs. discover in review

---

## 🔍 Troubleshooting

### Validation Script Not Found

```bash
# Check if scripts exist
ls -la scripts/

# Make scripts executable
chmod +x scripts/*.sh
```

### Permission Denied

```bash
# Make all scripts executable
chmod +x scripts/*.sh

# Or individually
chmod +x scripts/validate.sh
```

### False Positives

**Structure Validation:**
- Some warnings are informational (e.g., missing optional files)
- Only errors block the validation

**Link Validation:**
- External links (http/https) are skipped
- Anchor-only links (#section) are skipped
- Ensure paths are relative to the markdown file location

**Trinity Validation:**
- Requires sibling repositories to exist
- Can pass with warnings if sibling repos are missing

---

## ✨ Best Practices

### ✅ DO

- Run `make validate-all` before committing
- Fix validation errors immediately
- Keep documentation links up to date
- Synchronize VERSION across Trinity repos
- Test validation scripts after modifying them

### ❌ DON'T

- Commit with validation errors
- Skip validation for "quick fixes"
- Ignore broken documentation links
- Let Trinity repos diverge
- Modify validation scripts without testing

---

## 🎯 Integration Options

### Git Hooks (Optional)

You can create a pre-commit hook to run validation automatically:

**Setup:**
```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running validation..."
make validate-all
EOF

# Make executable
chmod +x .git/hooks/pre-commit
```

**Disable:**
```bash
# Skip hook for one commit
git commit --no-verify -m "message"

# Remove hook
rm .git/hooks/pre-commit
```

### CI/CD Integration (Future)

Validation can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate repository
        run: make validate-all
```

---

## 📚 Related Documentation

### Standards
- [OPERATIONAL-STANDARDS.md](./OPERATIONAL-STANDARDS.md) - Operational standards index
- [../../CONTRIBUTING.md](../../CONTRIBUTING.md) - Contribution guidelines
- [../../README.md](../../README.md) - Project overview

### Trinity
- [../project/TRINITY.md](../project/TRINITY.md) - Trinity integration
- [../../MISSION.md](../../MISSION.md) - Mission statement
- [../../VERSION](../../VERSION) - Current version

### Scripts
- [../../scripts/validate.sh](../../scripts/validate.sh) - Main validation
- [../../scripts/validate-structure.sh](../../scripts/validate-structure.sh)
- [../../scripts/validate-doc-links.sh](../../scripts/validate-doc-links.sh)
- [../../scripts/validate-trinity.sh](../../scripts/validate-trinity.sh)

---

## 📝 Validation Checklist

### Before Every Commit

- [ ] Run `make validate-all`
- [ ] Fix any errors reported
- [ ] Verify all checks pass
- [ ] Commit changes

### Before Pushing to Main

- [ ] Validate repository structure
- [ ] Validate documentation links
- [ ] Validate Trinity alignment
- [ ] Ensure VERSION is synchronized
- [ ] Update CHANGELOG.md if needed

### When Adding New Files

- [ ] Place files in correct directories
- [ ] Update cross-references
- [ ] Add to relevant index/README
- [ ] Validate links from new files
- [ ] Run full validation

### When Updating Documentation

- [ ] Check all internal links
- [ ] Update cross-references
- [ ] Run link validation
- [ ] Verify formatting consistency
- [ ] Test any code examples

---

**Status:** ✅ Validation workflow active and tested
**Last Updated:** 2025-11-08

---

*Validation ensures quality. Quality ensures trust.* 🎯

**Validate Early. Validate Often. Validate Always.**
