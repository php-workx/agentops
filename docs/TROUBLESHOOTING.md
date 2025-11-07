# AgentOps Installer Troubleshooting Guide

**Quick reference for solving common installation issues.**

---

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Profile Issues](#profile-issues)
3. [CLI Issues](#cli-issues)
4. [Project Installation Issues](#project-installation-issues)
5. [Validation Issues](#validation-issues)
6. [Runtime Issues](#runtime-issues)
7. [Recovery & Rollback](#recovery--rollback)

---

## Installation Issues

### Issue: "Command not found: bash" or Bash Version Too Old

**Symptoms:**
```
bash: command not found
# OR
bash: version 3.2.57 is too old
```

**Cause:** Missing or outdated Bash installation

**Solution:**

**macOS:**
```bash
# Install Bash 4+ via Homebrew
brew install bash

# Verify version
/usr/local/bin/bash --version
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install bash

# RHEL/CentOS
sudo yum install bash
```

---

### Issue: "Permission denied" When Running Installer

**Symptoms:**
```
bash: ./scripts/install.sh: Permission denied
```

**Cause:** Scripts not executable

**Solution:**
```bash
# Make scripts executable
chmod +x scripts/*.sh
chmod +x scripts/lib/*.sh

# Then retry
./scripts/install.sh
```

---

### Issue: Installation Hangs During Profile Selection

**Symptoms:**
- Interactive menu appears but doesn't respond
- No input accepted

**Cause:** Terminal not in interactive mode

**Solution:**

**Option 1: Use non-interactive mode**
```bash
./scripts/install.sh --profile devops
```

**Option 2: Fix terminal**
```bash
# Ensure you're in an interactive shell
bash -i
./scripts/install.sh
```

---

### Issue: "No space left on device"

**Symptoms:**
```
cp: cannot create directory: No space left on device
```

**Cause:** Insufficient disk space

**Solution:**
```bash
# Check available space
df -h ~/.agentops

# Need at least 100MB
# Clean up space if needed
rm -rf ~/.agentops/backups/*  # Remove old backups

# Retry installation
./scripts/install.sh
```

---

## Profile Issues

### Issue: "Profile not found"

**Symptoms:**
```
❌ Profile 'myprofile' not found
```

**Cause:** Typo in profile name or profile not installed

**Solution:**
```bash
# List available profiles
agentops list-profiles

# Install correct profile
./scripts/install.sh --profile devops
```

**Available profiles:**
- `product-dev`
- `infrastructure-ops`
- `devops`
- `life`

---

### Issue: Wrong Profile Active

**Symptoms:**
```
# Expected devops, but getting product-dev
agentops current-profile
# Output: product-dev
```

**Cause:** Resolution chain priority

**Solution:**

**Understanding resolution order:**
1. **Explicit flag** (highest priority)
2. **Environment variable** (`AGENTOPS_PROFILE`)
3. **Project config** (`.agentops/config.yml`)
4. **User default** (`~/.agentops/.profile`)

**Fix:**

**Option 1: Change user default**
```bash
agentops use-profile devops
```

**Option 2: Use environment variable**
```bash
export AGENTOPS_PROFILE=devops
```

**Option 3: Check project config**
```bash
# In your project
cat .agentops/config.yml
# Edit if needed
```

---

### Issue: Multiple Profiles Conflict

**Symptoms:**
- Commands from wrong profile execute
- Agents from different profiles mixed

**Cause:** Profile resolution misconfiguration

**Solution:**
```bash
# Debug resolution chain
echo "Explicit: --profile flag"
echo "Env: $AGENTOPS_PROFILE"
echo "Project: $(cat .agentops/config.yml 2>/dev/null | grep profile:)"
echo "User: $(cat ~/.agentops/.profile 2>/dev/null)"

# Clear conflicting settings
unset AGENTOPS_PROFILE  # Clear environment
agentops use-profile devops  # Set user default
```

---

### Issue: Agent Count Mismatch

**Symptoms:**
```
⚠️  Agent count mismatch in devops: declared=52, actual=50
```

**Cause:** Profile manifest out of sync with actual agents

**Solution:**
```bash
# Reinstall profile
./scripts/install.sh --profile devops --force

# Verify
agentops validate --profile devops
```

---

## CLI Issues

### Issue: "Command not found: agentops"

**Symptoms:**
```
bash: agentops: command not found
```

**Cause:** AgentOps bin not in PATH

**Solution:**

**Temporary fix:**
```bash
# Use full path
~/.agentops/bin/agentops current-profile
```

**Permanent fix:**
```bash
# Add to PATH in ~/.bashrc or ~/.zshrc
echo 'export PATH="${HOME}/.agentops/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify
which agentops
agentops version
```

---

### Issue: CLI Commands Don't Work

**Symptoms:**
```
agentops current-profile
# No output or error
```

**Cause:** Library functions not sourced

**Solution:**
```bash
# Check installation
ls ~/.agentops/bin/agentops
ls ~/.agentops/scripts/lib/

# Reinstall if missing
cd agentops/
./scripts/install.sh --upgrade
```

---

## Project Installation Issues

### Issue: "AgentOps not installed" Error

**Symptoms:**
```
❌ Base installation not found at ~/.agentops
```

**Cause:** AgentOps not installed to home directory first

**Solution:**
```bash
# Install to home directory first
cd agentops/
./scripts/install.sh

# Then install in project
cd /path/to/project
~/.agentops/scripts/project-install.sh
```

---

### Issue: Claude Code Commands Not Appearing

**Symptoms:**
- `/research` command not found
- No commands in `.claude/commands/`

**Cause:** Claude Code not detected or commands not installed

**Solution:**

**Option 1: Force Claude Code installation**
```bash
~/.agentops/scripts/project-install.sh --claude-code devops
```

**Option 2: Manual installation**
```bash
mkdir -p .claude/commands
cp ~/.agentops/commands/* .claude/commands/
cp ~/.agentops/profiles/devops/commands/* .claude/commands/
```

**Option 3: Verify Claude Code detection**
```bash
# Must have one of:
ls -la .claude/  # Claude directory
ls -la CLAUDE.md  # Claude config
ls -la claude.md  # Claude config
```

---

### Issue: Git Hooks Not Working

**Symptoms:**
- Pre-commit hook doesn't run
- No validation on commit

**Cause:** Hooks not installed or not executable

**Solution:**
```bash
# Check hooks
ls -la .git/hooks/

# Reinstall
~/.agentops/scripts/project-install.sh --force devops

# Make executable
chmod +x .git/hooks/*

# Test
git commit --dry-run
```

---

## Validation Issues

### Issue: Validation Tier 1 Fails - Core Files

**Symptoms:**
```
⚠️  Tier 1: Core validation FAILED (3 errors)
❌ Required directory not found: ~/.agentops/scripts
```

**Cause:** Incomplete installation

**Solution:**
```bash
# Backup existing
cp -r ~/.agentops ~/.agentops.backup

# Clean install
rm -rf ~/.agentops
cd agentops/
./scripts/install.sh

# Verify
agentops validate --tier1
```

---

### Issue: Validation Tier 2 Fails - Profiles

**Symptoms:**
```
⚠️  Tier 2: Profile validation FAILED
❌ Profile manifest not found: devops
```

**Cause:** Profile not installed or corrupted

**Solution:**
```bash
# Reinstall profile
./scripts/install.sh --profile devops

# Verify
agentops validate --tier2 --profile devops
```

---

### Issue: Validation Tier 3 Fails - 12-Factor

**Symptoms:**
```
⚠️  Tier 3: 12-Factor compliance PARTIAL (2 violations)
```

**Cause:** Non-critical compliance issues

**Solution:**
```bash
# View details
agentops validate --tier3

# Most Tier 3 failures are warnings, not blockers
# Installation still usable

# To fix completely, reinstall
./scripts/install.sh --all
```

---

## Runtime Issues

### Issue: Tutorial Fails to Start

**Symptoms:**
```
ERROR: Cannot find common-functions.sh library
```

**Cause:** Libraries not in expected location

**Solution:**
```bash
# Check library location
ls ~/.agentops/scripts/lib/

# Run tutorial with full path
~/.agentops/scripts/tutorial.sh

# If still fails, reinstall
./scripts/install.sh --upgrade
```

---

### Issue: Commands Resolve to Wrong Profile

**Symptoms:**
- Using `/research` but getting product-dev version instead of devops

**Cause:** Resolution chain priority

**Solution:**
```bash
# Debug resolution
agentops current-profile

# Override with environment
AGENTOPS_PROFILE=devops

# Or set project config
cat > .agentops/config.yml <<EOF
profile: devops
version: v1.0.0
EOF
```

---

## Recovery & Rollback

### Issue: Installation Corrupted

**Symptoms:**
- Multiple validation failures
- CLI doesn't work
- Profiles missing

**Solution:**

**Option 1: Restore from backup**
```bash
# List backups
ls ~/.agentops/backups/

# Restore latest
cp -r ~/.agentops/backups/backup_20251107_* ~/.agentops
```

**Option 2: Clean reinstall**
```bash
# Backup first
cp -r ~/.agentops ~/.agentops.manual-backup

# Clean install
rm -rf ~/.agentops
cd agentops/
./scripts/install.sh --all
```

---

### Issue: Need to Uninstall Completely

**Symptoms:**
- Want to remove AgentOps entirely
- Start fresh

**Solution:**
```bash
# Uninstall with backup
./scripts/install.sh --uninstall

# This will:
# 1. Create final backup in ~/.agentops/backups/
# 2. Remove ~/.agentops/
# 3. Preserve backup for recovery

# To remove backups too:
rm -rf ~/.agentops/backups/
```

---

### Issue: Rollback to Previous Version

**Symptoms:**
- New version has issues
- Want previous version

**Solution:**
```bash
# Via backup
ls ~/.agentops/backups/
cp -r ~/.agentops/backups/backup_before_upgrade_* ~/.agentops

# Via git
cd agentops/
git log --oneline
git checkout <previous-version-commit>
./scripts/install.sh
```

---

## Getting More Help

### Collect Diagnostic Information

```bash
# System info
uname -a
bash --version

# Installation info
ls -la ~/.agentops/
agentops validate
agentops list-profiles
agentops current-profile

# Profile info
cat ~/.agentops/.profile
echo $AGENTOPS_PROFILE
cat .agentops/config.yml 2>/dev/null
```

### Check Logs

```bash
# Installation logs (if logging enabled)
ls ~/.agentops/logs/

# Git history
cd agentops/
git log --oneline -10
```

### Support Channels

- **GitHub Issues:** https://github.com/boshu2/agentops/issues
- **Documentation:** `~/.agentops/README.md`
- **Installation Guide:** `INSTALL.md`
- **Changelog:** `CHANGELOG.md`

---

## Quick Reference

### Most Common Issues

| Issue | Quick Fix |
|-------|-----------|
| "Command not found: agentops" | `export PATH="$HOME/.agentops/bin:$PATH"` |
| "Profile not found" | `agentops list-profiles` then reinstall |
| Wrong profile active | `agentops use-profile <name>` |
| Validation fails | `./scripts/install.sh --upgrade` |
| Tutorial fails | `~/.agentops/scripts/tutorial.sh` |
| Commands missing | `~/.agentops/scripts/project-install.sh --force` |

### Validation Commands

```bash
# Full validation
agentops validate

# Individual tiers
agentops validate --tier1  # Core files
agentops validate --tier2  # Profiles
agentops validate --tier3  # 12-factor

# Profile-specific
agentops validate --profile devops
```

### Recovery Commands

```bash
# List backups
ls ~/.agentops/backups/

# Restore backup
cp -r ~/.agentops/backups/<backup> ~/.agentops

# Reinstall
./scripts/install.sh --upgrade

# Clean install
rm -rf ~/.agentops && ./scripts/install.sh
```

---

**Last Updated:** v1.0.0 (2025-11-07)
