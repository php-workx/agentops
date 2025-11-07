# AgentOps v1.0.0 Installation Guide

**Quick Start:** Install AgentOps with multi-profile support in 2 minutes.

---

## Prerequisites

- Bash 4.0+ (check: `bash --version`)
- Git (check: `git --version`)
- Basic Unix tools: `grep`, `sed`, `find`

---

## Installation Methods

### Method 1: Interactive Installation (Recommended)

```bash
cd agentops/
./scripts/install.sh
```

**What happens:**
1. Interactive profile selection menu appears
2. Choose one or more profiles to install
3. Installation completes with validation
4. CLI tool ready to use

**Duration:** ~2 minutes

---

### Method 2: Install Specific Profile

```bash
./scripts/install.sh --profile devops
```

**Available profiles:**
- `product-dev` - Application development (10 agents)
- `infrastructure-ops` - Operations & monitoring (18 agents)
- `devops` - Complete GitOps ecosystem (52 agents)
- `life` - Personal development (7 agents)

---

### Method 3: Install All Profiles

```bash
./scripts/install.sh --all
```

Installs all 4 profiles (87 total agents).

---

## Project Installation

After installing AgentOps to `~/.agentops/`, install it in your project:

```bash
cd /path/to/your/project
~/.agentops/scripts/project-install.sh
```

**What happens:**
- Creates `.agentops/` directory with project config
- Installs Claude Code integration (if Claude Code project detected)
- Installs layered commands (base + profile overrides)
- Installs git hooks
- Creates project README

**Duration:** <30 seconds

---

## What Gets Installed

```
~/.agentops/
├── bin/
│   └── agentops                    # CLI tool
├── scripts/
│   ├── install.sh                  # Installer
│   ├── project-install.sh          # Project installer
│   ├── tutorial.sh                 # Interactive tutorial
│   ├── validate-installation.sh    # Validation
│   └── lib/                        # Libraries
│       ├── common-functions.sh
│       ├── validation.sh
│       └── logging.sh
├── profiles/
│   ├── product-dev/                # Profile 1
│   ├── infrastructure-ops/         # Profile 2
│   ├── devops/                     # Profile 3
│   └── life/                       # Profile 4
├── commands/                       # Base commands
├── agents/                         # Base agents
└── backups/                        # Backup directory
```

---

## Post-Installation

### 1. Add CLI to PATH

```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export PATH="${HOME}/.agentops/bin:$PATH"
```

Then reload:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### 2. Verify Installation

```bash
agentops validate
```

**Expected output:** All 3 validation tiers pass

---

### 3. Run Tutorial (Optional but Recommended)

```bash
~/.agentops/scripts/tutorial.sh
```

**Duration:** 5 minutes
**Teaches:** Multi-profile usage, resolution chain, project installation

---

## Using AgentOps

### Check Current Profile

```bash
agentops current-profile
```

### Switch Default Profile

```bash
agentops use-profile devops
```

### List Installed Profiles

```bash
agentops list-profiles
```

### View Profile Information

```bash
agentops profile-info devops
```

---

## Multi-Profile Resolution

AgentOps uses a 4-layer resolution chain (highest → lowest priority):

1. **Explicit:** `--profile devops`
2. **Environment:** `AGENTOPS_PROFILE=infrastructure-ops`
3. **Project:** `.agentops/config.yml`
4. **User:** `~/.agentops/.profile`

**Example:**

```bash
# User default: product-dev
agentops current-profile
# Output: product-dev

# Override with environment
AGENTOPS_PROFILE=devops agentops current-profile
# Output: devops

# User default unchanged
agentops current-profile
# Output: product-dev
```

---

## Validation

### Run All Validation Tiers

```bash
agentops validate
```

### Run Specific Tier

```bash
agentops validate --tier1  # Core files
agentops validate --tier2  # Profiles
agentops validate --tier3  # 12-factor compliance
```

### Validate Specific Profile

```bash
agentops validate --profile devops
```

---

## Upgrading

```bash
cd agentops/
git pull origin main
./scripts/install.sh --upgrade
```

**Note:** Existing installations are backed up before upgrade.

---

## Uninstalling

```bash
./scripts/install.sh --uninstall
```

**What happens:**
1. Creates final backup
2. Removes `~/.agentops/` directory
3. Backup saved to `~/.agentops/backups/`

---

## Troubleshooting

### "Command not found: agentops"

Add to PATH:
```bash
export PATH="${HOME}/.agentops/bin:$PATH"
```

### "Profile not found"

List available profiles:
```bash
agentops list-profiles
```

Install missing profile:
```bash
./scripts/install.sh --profile <profile-name>
```

### Validation Fails

View detailed errors:
```bash
agentops validate --tier1  # Check each tier
agentops validate --tier2
agentops validate --tier3
```

### Restore from Backup

```bash
ls ~/.agentops/backups/
cp -r ~/.agentops/backups/<backup-name> ~/.agentops
```

---

## For Developers & Contributors

### Running Tests Locally

Before submitting changes, run the test suite:

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

AgentOps v1.0.0 uses GitHub Actions for automated validation:

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

**Result:** Main branch frozen at v1.0.0 quality - all PRs must pass validation

---

### Quality Gates

**All changes to main must pass:**
- ✅ Bash syntax validation (`bash -n`)
- ✅ YAML validation with yq
- ✅ Profile manifest structure checks
- ✅ Library function existence checks
- ✅ Documentation completeness
- ✅ Help commands functional
- ✅ Integration tests

**To contribute:**
1. Run tests locally: `./tests/test-installer.sh`
2. Fix any failures
3. Create PR to main
4. GitHub Actions validates automatically
5. Merge when all checks pass ✅

---

## Next Steps

1. **Run tutorial:**
   ```bash
   ~/.agentops/scripts/tutorial.sh
   ```

2. **Install in your project:**
   ```bash
   cd /path/to/project
   ~/.agentops/scripts/project-install.sh
   ```

3. **Explore profiles:**
   ```bash
   ls ~/.agentops/profiles/
   cat ~/.agentops/profiles/devops/README.md
   ```

4. **Read main docs:**
   ```bash
   cat ~/.agentops/README.md
   ```

5. **For developers:**
   ```bash
   # Run tests
   ./tests/test-installer.sh

   # Read test docs
   cat tests/README.md
   ```

---

## Support & Documentation

- **FAQ:** [docs/FAQ.md](docs/FAQ.md) - 40+ questions answered
- **Troubleshooting:** [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - 30+ common issues
- **Testing:** [tests/README.md](tests/README.md) - Test suite guide
- **Changelog:** [CHANGELOG.md](CHANGELOG.md) - Full version history
- **GitHub Issues:** https://github.com/boshu2/agentops/issues

---

**Installation complete! AgentOps v1.0.0 is ready to use.**
