# Contributing to AgentOps

Thank you for contributing to AgentOps! This guide covers everything you need to know.

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/boshu2/agentops.git
cd agentops

# 2. Run tests
./tests/test-installer.sh

# 3. Make changes
# ... edit files ...

# 4. Test again
./tests/test-installer.sh

# 5. Commit with semantic message
git commit -m "feat(installer): your change description"

# 6. Push and create PR
git push origin your-branch
```

---

## Development Setup

### Prerequisites

**Required:**
- Bash 4.0+ (`bash --version`)
- Git (`git --version`)

**Optional but recommended:**
- **yq** - YAML validator/parser (for enhanced testing)
  ```bash
  # macOS
  brew install yq

  # Linux
  wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
  chmod +x /usr/local/bin/yq
  ```

---

## Testing

### Run Tests Locally

Before submitting changes:

```bash
# Run all tests
./tests/test-installer.sh

# Expected output: ✅ All tests passed!
```

**What gets tested:**
- Shell script syntax (7 scripts)
- Profile manifests with yq (4 profiles)
- Library functions (20+ functions)
- Commands (base + overrides)
- Documentation completeness
- GitHub Actions workflow validation
- Installer help commands

**See:** [tests/README.md](tests/README.md) for complete testing documentation

---

### CI/CD Pipeline

AgentOps uses GitHub Actions for automated validation.

**Workflow:** `.github/workflows/installer-validation.yml`

**Triggers automatically on:**
- Pull requests to `main`
- Pushes to `main`
- Manual workflow dispatch

**7 Validation Jobs:**
1. Shell script syntax validation
2. Profile manifest validation (with yq)
3. Installer dry-run (matrix: all 4 profiles)
4. Library function validation
5. Command file validation
6. Documentation validation
7. Integration test (mock installation)

**Result:** Main branch is frozen at v1.0.0 quality - all PRs must pass validation

---

## Contribution Workflow

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make Changes

Edit files following existing patterns.

### 3. Test Locally

```bash
./tests/test-installer.sh
```

Fix any failures before committing.

### 4. Commit with Semantic Message

```bash
git commit -m "type(scope): description"
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `test` - Adding tests
- `refactor` - Code restructuring
- `chore` - Maintenance

**Examples:**
```bash
git commit -m "feat(installer): add profile switching command"
git commit -m "fix(validation): handle missing profile manifest"
git commit -m "docs(faq): add multi-profile usage questions"
```

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

### 6. CI Validation

GitHub Actions will automatically:
- Run all 7 validation jobs
- Report results on your PR
- Block merge if any validation fails

### 7. Address Feedback

If CI fails or reviewers request changes:

```bash
# Make changes
git add .
git commit -m "fix: address review feedback"
git push origin feature/your-feature-name
```

### 8. Merge

Once all checks pass ✅ and approved, your PR will be merged to `main`.

---

## Quality Gates

**All PRs to main must pass:**

- ✅ **Bash syntax** - `bash -n` validation
- ✅ **YAML validation** - yq syntax checks
- ✅ **Profile structure** - Manifest validation
- ✅ **Library functions** - Existence checks
- ✅ **Documentation** - Completeness checks
- ✅ **Help commands** - Functional tests
- ✅ **Integration** - Mock installation

**If any check fails, PR is blocked until fixed.**

---

## Areas to Contribute

### 1. New Profiles

Add domain-specific profiles:

```bash
# 1. Copy existing profile as template
cp -r profiles/product-dev profiles/your-profile

# 2. Create profile manifest
cat > profiles/your-profile/profile.yaml <<EOF
apiVersion: agentops.io/v1
kind: Profile
metadata:
  name: your-profile
  version: v1.0.0
  description: Your profile description
spec:
  agent_count: X
  agents:
    - name: agent-name
      description: What it does
EOF

# 3. Add agents in profiles/your-profile/agents/
# 4. Add commands in profiles/your-profile/commands/
# 5. Test
./tests/test-installer.sh
```

### 2. New Commands

Add base commands or profile overrides:

```bash
# Base command (all profiles)
cat > core/commands/your-command.md <<EOF
---
description: Brief description
---

# /your-command - Command Name

Your command documentation...
EOF

# Profile-specific override
cat > profiles/devops/commands/your-command.md <<EOF
---
description: DevOps-specific version
---

# /your-command - DevOps Version

Profile-specific documentation...
EOF
```

### 3. Bug Fixes

Found a bug? Fix it:

```bash
# 1. Write a test that reproduces the bug
# 2. Fix the bug
# 3. Verify test passes
./tests/test-installer.sh
```

### 4. Documentation

Improve docs:
- **FAQ** - Add questions to `docs/FAQ.md`
- **Troubleshooting** - Add issues to `docs/TROUBLESHOOTING.md`
- **Install guide** - Update `INSTALL.md`
- **Changelog** - Update `CHANGELOG.md`

### 5. Test Coverage

Add tests to `tests/test-installer.sh`:

```bash
test_your_feature() {
    echo ""
    echo -e "${BLUE}Testing: Your Feature${RESET}"
    echo "=============================="

    if [[ condition ]]; then
        print_result "pass" "Test description"
    else
        print_result "fail" "Test description"
    fi
}
```

---

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Document functions with comments
- Use `local` for function variables
- Quote variables: `"$variable"`
- Follow existing patterns

**Example:**
```bash
#!/usr/bin/env bash
set -euo pipefail

#######################################
# Function description
# Arguments:
#   $1: First argument description
# Returns:
#   0 on success, 1 on failure
#######################################
my_function() {
    local arg="$1"

    if [[ -z "$arg" ]]; then
        return 1
    fi

    echo "Processing: $arg"
    return 0
}
```

### YAML Files

- Use 2-space indentation
- Follow Kubernetes-style structure
- Validate with yq before committing

**Profile manifest template:**
```yaml
apiVersion: agentops.io/v1
kind: Profile
metadata:
  name: profile-name
  version: v1.0.0
  description: Brief description
spec:
  agent_count: X
  agents:
    - name: agent-name
      description: What it does
```

### Markdown

- Use ATX headers (`#`, `##`, `###`)
- Include code blocks with language tags
- Keep lines under 80 characters where reasonable
- Use reference-style links for repeated URLs

---

## Commit Message Format

```
type(scope): short description

Longer description if needed.

Context: Why was this change needed?
Solution: What was implemented?
Learning: What insights were gained?
Impact: What value does this deliver?
```

**Example:**
```
feat(installer): add profile validation command

Context: Users needed way to validate profile installation without
running full validation suite.

Solution: Added `agentops validate --profile <name>` command that
runs Tier 2 validation for specific profile.

Learning: Profile-specific validation helps debug installation issues
faster than full validation suite.

Impact: Users can validate individual profiles in <5 seconds vs
30 seconds for full suite. Faster troubleshooting workflow.
```

---

## Release Process

Releases are managed by maintainers:

1. Update `CHANGELOG.md` with new version
2. Tag release: `git tag v1.x.x`
3. Push tag: `git push origin v1.x.x`
4. GitHub Actions creates release

**Versioning:** [Semantic Versioning](https://semver.org/)
- **MAJOR** (1.x.x) - Breaking changes
- **MINOR** (x.1.x) - New features (backward compatible)
- **PATCH** (x.x.1) - Bug fixes (backward compatible)

---

## Getting Help

**Questions about contributing?**
- Open an issue: https://github.com/boshu2/agentops/issues
- Check FAQ: [docs/FAQ.md](docs/FAQ.md)
- Read test docs: [tests/README.md](tests/README.md)

**Found a bug?**
- Check existing issues first
- If new, open an issue with reproduction steps
- Better yet, submit a PR with a fix!

---

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Celebrate contributions of all sizes

---

## License

By contributing, you agree that your contributions will be licensed under:
- **Code:** Apache License 2.0
- **Documentation:** CC BY-SA 4.0

---

**Thank you for contributing to AgentOps! 🚀**
