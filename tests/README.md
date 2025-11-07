# AgentOps Test Suite

Comprehensive validation tests for the AgentOps v1.0.0 installer.

---

## Quick Start

```bash
# Run all tests
./tests/test-installer.sh

# Expected output: ✅ All tests passed!
```

---

## What Gets Tested

### 1. Shell Script Syntax (7 scripts)
- `scripts/install.sh`
- `scripts/project-install.sh`
- `scripts/tutorial.sh`
- `scripts/validate-installation.sh`
- `scripts/lib/common-functions.sh`
- `scripts/lib/validation.sh`
- `scripts/lib/logging.sh`

**Validation:** `bash -n <script>`

---

### 2. Profile Manifests (4 profiles)
- `profiles/product-dev/profile.yaml`
- `profiles/infrastructure-ops/profile.yaml`
- `profiles/devops/profile.yaml`
- `profiles/life/profile.yaml`

**With yq (recommended):**
- YAML syntax validation
- apiVersion = "agentops.io/v1"
- kind = "Profile"
- metadata.name matches directory
- agent_count is numeric

**Without yq (fallback):**
- Field presence checks with grep

---

### 3. Library Functions (20+ functions)
- Common functions (print_color, die, success, warn, info, get_active_profile, etc.)
- Validation functions (validate_core_installation, validate_profile, validate_12factor_compliance)
- Logging functions (log_json, log_info, log_error, log_event)

**Validation:** Function existence checks

---

### 4. Commands
- Base commands in `core/commands/` (research.md, plan.md)
- Profile overrides in `profiles/*/commands/` (devops/research.md)

**Validation:** File existence and non-empty

---

### 5. Documentation (7 files)
- `INSTALL.md`
- `CHANGELOG.md`
- `README.md`
- `CLAUDE.md`
- `CONSTITUTION.md`
- `docs/FAQ.md`
- `docs/TROUBLESHOOTING.md`

**Validation:** File existence, non-empty, CHANGELOG has v1.0.0

---

### 6. GitHub Actions Workflow

**With yq (recommended):**
- `.github/workflows/installer-validation.yml` YAML syntax
- Workflow name present
- Triggers defined (on: section)
- PR to main trigger exists
- Jobs defined and counted

**Without yq:** Skipped gracefully

---

### 7. Installer Help
- `scripts/install.sh --help`
- `scripts/project-install.sh --help`
- `scripts/validate-installation.sh --help`

**Validation:** Commands execute without error

---

## Prerequisites

### Required
- Bash 4.0+
- Git

### Optional (for enhanced validation)
- **yq** - YAML validator and parser
  ```bash
  # macOS
  brew install yq

  # Linux
  wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
  chmod +x /usr/local/bin/yq
  ```

**Note:** Tests work without yq but use grep fallback (less thorough)

---

## Output Format

### Pass/Fail Indicators
- ✓ Green checkmark = Test passed
- ✗ Red X = Test failed
- ⚠ Yellow warning = Non-critical (like yq not available)

### Test Summary
```
==============================
Test Summary
==============================

Tests run:    42
Tests passed: 42
Tests failed: 0

✅ All tests passed!
```

---

## Exit Codes

- **0** - All tests passed
- **1** - One or more tests failed

**Use in CI:**
```bash
./tests/test-installer.sh
if [ $? -eq 0 ]; then
  echo "Tests passed, proceeding..."
else
  echo "Tests failed, blocking merge"
  exit 1
fi
```

---

## CI Integration

Tests run automatically in GitHub Actions:

**Workflow:** `.github/workflows/installer-validation.yml`

**Triggers:**
- Pull requests to `main`
- Pushes to `main`
- Manual dispatch

**Jobs:**
- Syntax validation
- Profile validation (with yq)
- Installer dry-run (matrix: 4 profiles)
- Library validation
- Command validation
- Documentation validation
- Integration test

---

## Local Development

### Run Tests Before Commit
```bash
# Quick validation
./tests/test-installer.sh

# Or use make (if Makefile exists)
make test
```

### Debug Failed Tests
```bash
# Run with verbose output
bash -x ./tests/test-installer.sh

# Test specific component manually
bash -n scripts/install.sh
yq eval '.' profiles/devops/profile.yaml
```

---

## Adding New Tests

### Template
```bash
#######################################
# Test: Your Component
#######################################
test_your_component() {
    echo ""
    echo -e "${BLUE}Testing: Your Component${RESET}"
    echo "=============================="

    # Your test logic here
    if [[ condition ]]; then
        print_result "pass" "Test description"
    else
        print_result "fail" "Test description"
    fi
}
```

### Add to main()
```bash
main() {
    # ...
    test_your_component  # Add here
    # ...
}
```

---

## Troubleshooting

### "yq: command not found"
**Not a problem!** Tests use grep fallback automatically.

**To install yq:**
```bash
# macOS
brew install yq

# Linux
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
```

---

### Tests Fail Locally but Pass in CI
- Check bash version: `bash --version` (need 4.0+)
- Check working directory: Run from repo root
- Check file permissions: `chmod +x scripts/*.sh`

---

### Tests Pass Locally but Fail in CI
- CI uses fresh environment
- Check for hardcoded paths
- Ensure all dependencies available

---

## Test Coverage

**Current Coverage:**
- ✅ Shell syntax (7 scripts)
- ✅ Profile manifests (4 profiles, 5 checks each)
- ✅ Library functions (20+ functions)
- ✅ Commands (base + overrides)
- ✅ Documentation (7 files)
- ✅ GitHub Actions workflow
- ✅ Installer help (3 scripts)

**Total:** ~70+ individual test assertions

---

## Performance

**Typical run time:**
- With yq: ~3-5 seconds
- Without yq: ~2-3 seconds

**CI run time:**
- Full validation suite: ~2-3 minutes (parallel jobs)

---

## Related Documentation

- **Installation:** [INSTALL.md](../INSTALL.md)
- **Troubleshooting:** [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md)
- **FAQ:** [docs/FAQ.md](../docs/FAQ.md)
- **Changelog:** [CHANGELOG.md](../CHANGELOG.md)

---

**Last Updated:** v1.0.0 (2025-11-07)
