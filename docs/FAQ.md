# AgentOps Installer FAQ

**Frequently Asked Questions about installing and using AgentOps v1.0.0**

---

## General Questions

### What is AgentOps?

AgentOps is a universal operating system for AI agents that provides proven patterns for reliable, scalable agent operations. It includes 4 profiles (87 total agents) across different domains: product development, infrastructure operations, complete GitOps, and personal development.

**Key benefits:**
- 40x speedup in product development
- 3x speedup in infrastructure operations
- 95% success rate across 204 sessions
- Multi-profile support without conflicts

---

### What's new in v1.0.0?

v1.0.0 is the first production-ready release with:

- **Multi-profile installer** - Install all 4 profiles simultaneously
- **4-layer resolution chain** - No conflicts between profiles
- **3-tier validation** - Ensures installation quality
- **Interactive tutorial** - 5-minute guided experience
- **CLI tool** - `agentops` command for profile management
- **Complete documentation** - INSTALL.md, CHANGELOG.md, troubleshooting

See [CHANGELOG.md](../CHANGELOG.md) for full details.

---

### Do I need to uninstall the old version first?

**No.** The v1.0.0 installer automatically:
- Creates backups of existing installations
- Migrates your configuration
- Preserves your profiles

Simply run:
```bash
cd agentops/
./scripts/install.sh --upgrade
```

---

## Installation Questions

### How long does installation take?

- **Home installation:** ~2 minutes
- **Project installation:** <30 seconds
- **Tutorial:** 5 minutes (optional but recommended)

**Total:** ~7-8 minutes including tutorial

---

### What are the system requirements?

**Required:**
- Bash 4.0+ (`bash --version`)
- Git (`git --version`)
- Unix tools: `grep`, `sed`, `find`
- ~100MB disk space

**Supported platforms:**
- ✅ macOS (Intel & Apple Silicon)
- ✅ Linux (Ubuntu, Debian, RHEL, CentOS)
- ✅ WSL2 (Windows Subsystem for Linux)
- ❌ Windows (native) - not supported

---

### Can I install just one profile?

**Yes!** You can install specific profiles:

```bash
./scripts/install.sh --profile devops
```

Or install all and switch between them:

```bash
./scripts/install.sh --all
agentops use-profile product-dev  # Switch as needed
```

**Recommendation:** Install all profiles. The resolution chain prevents conflicts.

---

### Where does AgentOps install?

**Home installation:**
```
~/.agentops/          # All AgentOps files
~/.agentops/bin/      # CLI tool
~/.agentops/profiles/ # Installed profiles
```

**Project installation:**
```
.agentops/                  # Project config
.claude/commands/           # Claude Code commands (if detected)
.claude/agents/             # Profile agents
.git/hooks/                 # Git hooks
```

---

### Can I install AgentOps in multiple projects?

**Yes!** Install once to `~/.agentops/`, then install in each project:

```bash
# Install to home (once)
cd agentops/
./scripts/install.sh

# Install in project 1
cd /path/to/project1
~/.agentops/scripts/project-install.sh devops

# Install in project 2
cd /path/to/project2
~/.agentops/scripts/project-install.sh product-dev
```

Each project can use a different profile.

---

## Profile Questions

### Which profile should I use?

**Choose based on your work:**

| Profile | Use When | Agents | Best For |
|---------|----------|--------|----------|
| **product-dev** | Building applications | 10 | Product development, app creation |
| **infrastructure-ops** | Operating systems | 18 | SRE, monitoring, incident response |
| **devops** | Managing infrastructure | 52 | GitOps, Kubernetes, CI/CD |
| **life** | Personal growth | 7 | Career planning, skill tracking |

**Not sure?** Start with `product-dev` (simplest) or install all (no downside).

---

### Can I use multiple profiles simultaneously?

**Yes!** The 4-layer resolution chain prevents conflicts:

1. **Explicit:** `--profile devops` (highest priority)
2. **Environment:** `AGENTOPS_PROFILE=infrastructure-ops`
3. **Project:** `.agentops/config.yml`
4. **User:** `~/.agentops/.profile`

**Example:**
```bash
# User default: product-dev
agentops current-profile  # → product-dev

# Override for this command
AGENTOPS_PROFILE=devops agentops current-profile  # → devops

# User default unchanged
agentops current-profile  # → product-dev
```

---

### How do I switch profiles?

**Method 1: Change user default**
```bash
agentops use-profile devops
```

**Method 2: Use environment variable**
```bash
export AGENTOPS_PROFILE=infrastructure-ops
```

**Method 3: Set project-specific profile**
```bash
# Edit .agentops/config.yml in your project
profile: devops
```

---

### What's the difference between base commands and profile commands?

**Base commands** (`core/commands/`):
- Generic, work for all profiles
- Example: `/research`, `/plan`

**Profile commands** (`profiles/*/commands/`):
- Profile-specific overrides
- Example: `devops/research.md` emphasizes GitOps patterns

**Resolution:**
- Profile command exists? Use it.
- Otherwise? Fall back to base command.

**Result:** You always get the best command for your active profile.

---

## Claude Code Questions

### Do I need Claude Code to use AgentOps?

**No.** AgentOps works in two modes:

**With Claude Code:**
- Commands available via `/research`, `/plan`, etc.
- Agents integrated in `.claude/agents/`
- Full IDE integration

**Without Claude Code:**
- Use CLI: `agentops current-profile`
- Use scripts directly: `~/.agentops/scripts/`
- Full functionality, just different interface

---

### How does AgentOps detect Claude Code projects?

Auto-detection checks for:
- `.claude/` directory exists
- `claude.md` file exists
- `CLAUDE.md` file exists

If any found, Claude Code integration is installed automatically.

**Force Claude Code mode:**
```bash
~/.agentops/scripts/project-install.sh --claude-code devops
```

**Skip Claude Code mode:**
```bash
~/.agentops/scripts/project-install.sh --no-claude devops
```

---

### Where do commands come from?

**Layered command installation:**

1. **Base commands** copied from `~/.agentops/commands/`
2. **Profile commands** override from `~/.agentops/profiles/<profile>/commands/`

**Result:** `.claude/commands/` contains base + profile-specific commands

**Example:**
```
.claude/commands/
├── research.md        ← from devops/commands/research.md (override)
├── plan.md            ← from core/commands/plan.md (base)
└── implement.md       ← from core/commands/implement.md (base)
```

---

## Validation Questions

### What is 3-tier validation?

**Tier 1: Core Files**
- Checks: Directory structure, essential scripts
- Time: ~2 seconds
- Errors: Installation broken, need reinstall

**Tier 2: Profiles**
- Checks: Profile manifests, agent counts
- Time: ~5 seconds
- Errors: Profile incomplete, need reinstall profile

**Tier 3: 12-Factor Compliance**
- Checks: All 12 factors
- Time: ~3 seconds
- Errors: Usually warnings, not blockers

**Run all:**
```bash
agentops validate
```

---

### How often should I validate?

**After:**
- Initial installation
- Profile installation/reinstallation
- Upgrade
- Troubleshooting issues

**Not needed:**
- Every time you use AgentOps
- After switching profiles
- During normal use

**Quick check:**
```bash
agentops validate
# Should see: ✅ All validation tiers PASSED
```

---

### What if validation fails?

**Tier 1 fails:** Installation broken
```bash
./scripts/install.sh --upgrade
```

**Tier 2 fails:** Profile incomplete
```bash
./scripts/install.sh --profile <profile-name>
agentops validate --profile <profile-name>
```

**Tier 3 fails (partial):** Usually safe to ignore
- Non-critical compliance issues
- Installation still usable

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed fixes.

---

## Tutorial Questions

### Should I run the tutorial?

**Yes, recommended!** The tutorial:
- Takes only 5 minutes
- Teaches multi-profile usage interactively
- Creates test project for practice
- Demonstrates profile switching

**Run it:**
```bash
~/.agentops/scripts/tutorial.sh
```

**Skip if:**
- You're already familiar with multi-profile systems
- You've read the documentation thoroughly
- You're in a rush (but come back later!)

---

### Can I run the tutorial multiple times?

**Yes!** The tutorial:
- Creates test project in `~/.agentops/tutorial/`
- Can be run repeatedly
- Each run creates fresh test project

**Clean up test projects:**
```bash
rm -rf ~/.agentops/tutorial/
```

---

## Usage Questions

### How do I use AgentOps in my project?

**Quick start:**

```bash
# 1. Install to home
cd agentops/
./scripts/install.sh

# 2. Install in project
cd /path/to/your/project
~/.agentops/scripts/project-install.sh

# 3. Use commands (if Claude Code)
/research
/plan
/implement

# 4. Or use CLI
agentops current-profile
agentops validate
```

---

### Can I customize profiles?

**Yes, two ways:**

**Method 1: Project-level overrides**
```bash
# Edit .agentops/config.yml in your project
profile: devops
settings:
  custom_setting: value
```

**Method 2: Create custom profile**
- Copy existing profile: `cp -r profiles/devops profiles/my-profile`
- Customize agents, commands
- Install: `./scripts/install.sh --profile my-profile`

**Note:** Custom profiles not officially supported in v1.0.0 (coming in v1.1.0)

---

### How do I update AgentOps?

**Update installer:**
```bash
cd agentops/
git pull origin main
./scripts/install.sh --upgrade
```

**Update project:**
```bash
cd /path/to/project
~/.agentops/scripts/project-install.sh --force
```

**Backups created automatically before upgrade.**

---

## Troubleshooting Questions

### Installation hangs or fails, what do I do?

**Quick fixes:**

1. **Check prerequisites:**
   ```bash
   bash --version  # Need 4.0+
   git --version   # Need git
   ```

2. **Check disk space:**
   ```bash
   df -h ~/.agentops  # Need 100MB
   ```

3. **Try non-interactive install:**
   ```bash
   ./scripts/install.sh --profile devops
   ```

4. **Check logs:**
   ```bash
   # Run with verbose output
   bash -x scripts/install.sh --profile devops
   ```

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for comprehensive solutions.

---

### "Command not found: agentops" - how do I fix?

**Quick fix:**
```bash
export PATH="${HOME}/.agentops/bin:$PATH"
```

**Permanent fix:**
```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export PATH="${HOME}/.agentops/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Verify:**
```bash
which agentops
agentops version
```

---

### How do I completely uninstall AgentOps?

**With backup:**
```bash
./scripts/install.sh --uninstall
# Creates backup in ~/.agentops/backups/ before removing
```

**Without backup (complete removal):**
```bash
rm -rf ~/.agentops
```

**Remove from project:**
```bash
rm -rf .agentops .claude .git/hooks
```

---

## Advanced Questions

### Can I install AgentOps system-wide?

**Not recommended.** AgentOps is designed for per-user installation:
- Profiles are user-specific
- Configuration is personal
- No need for system-wide install

**If you really need it:**
```bash
# Install to /opt/ (requires sudo)
sudo mkdir -p /opt/agentops
sudo cp -r ~/.agentops/* /opt/agentops/
# Add to system PATH
```

---

### Can I use AgentOps in CI/CD?

**Yes!** AgentOps is CI/CD friendly:

```yaml
# Example: GitHub Actions
- name: Install AgentOps
  run: |
    git clone https://github.com/yourusername/agentops.git
    cd agentops
    ./scripts/install.sh --profile devops

- name: Use AgentOps
  run: |
    export PATH="$HOME/.agentops/bin:$PATH"
    agentops validate
```

**Note:** Use `--profile` flag for non-interactive installation.

---

### How do I contribute to AgentOps?

**See:** [CONTRIBUTING.md](../CONTRIBUTING.md) (coming soon)

**Quick overview:**
1. Fork the repository
2. Create a feature branch
3. Make changes (follow existing patterns)
4. Add tests
5. Submit pull request

**Areas to contribute:**
- New profiles
- Additional commands
- Bug fixes
- Documentation improvements

---

### Where can I get help?

**Documentation:**
- **Installation:** [INSTALL.md](../INSTALL.md)
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Changelog:** [CHANGELOG.md](../CHANGELOG.md)
- **Main README:** [README.md](../README.md)

**Support:**
- **GitHub Issues:** https://github.com/boshu2/agentops/issues
- **Tutorial:** `~/.agentops/scripts/tutorial.sh`
- **CLI Help:** `agentops help`

---

## Quick Reference

### Most Asked Questions

| Question | Answer |
|----------|--------|
| How long does installation take? | ~2 minutes |
| Can I install multiple profiles? | Yes, recommended |
| Do I need Claude Code? | No, but it enhances experience |
| How do I switch profiles? | `agentops use-profile <name>` |
| How do I validate? | `agentops validate` |
| How do I update? | `./scripts/install.sh --upgrade` |
| How do I uninstall? | `./scripts/install.sh --uninstall` |

### Essential Commands

```bash
# Installation
./scripts/install.sh                        # Interactive
./scripts/install.sh --profile devops       # Specific profile
./scripts/install.sh --all                  # All profiles

# CLI
agentops current-profile                    # Show active
agentops use-profile <name>                 # Switch
agentops list-profiles                      # List
agentops validate                           # Validate
agentops help                               # Help

# Project
~/.agentops/scripts/project-install.sh      # Install
~/.agentops/scripts/tutorial.sh             # Tutorial
```

---

**Last Updated:** v1.0.0 (2025-11-07)

**Have a question not answered here?** [Open an issue](https://github.com/boshu2/agentops/issues)
