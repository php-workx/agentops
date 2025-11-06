# AgentOps Troubleshooting Guide

Common issues and solutions for AgentOps installation and usage.

## Quick Diagnostics

**First step for any issue:**

```bash
make doctor
```

This runs comprehensive diagnostics and suggests fixes.

## Common Installation Issues

### Issue: "Git not found" or "Git version too old"

**Symptoms:**
```
✗ Git not found
Error: Installation aborted: prerequisite checks failed
```

**Solution:**

```bash
# macOS
brew install git

# Ubuntu/Debian
sudo apt-get install git

# Fedora/RHEL
sudo dnf install git

# Arch Linux
sudo pacman -S git
```

**Verify:**
```bash
git --version
# Should show >= 2.30.0
```

---

### Issue: "Claude Code CLI not found"

**Symptoms:**
```
✗ Claude Code CLI is not installed
Error: Claude Code is required - cannot continue
```

**Solution:**

Claude Code CLI must be installed manually before AgentOps installation.

1. Visit https://docs.claude.com/en/docs/claude-code/install
2. Follow installation instructions for your platform
3. Verify installation:
   ```bash
   claude --version
   ```

---

### Issue: "Python/uv installation failed"

**Symptoms:**
```
✗ Python 3.9+ not found
✗ uv not found
Installation failed
```

**Solution (Auto-install):**

The installer should offer to auto-install uv and Python. If it fails:

```bash
# Install uv manually
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"

# Install Python via uv
uv python install 3.11

# Verify
uv --version
python3 --version
```

---

### Issue: "No agentops repository found"

**Symptoms:**
```
✗ Could not find agentops repository
Error: Specify location with: --agentops /path/to/agentops
```

**Solution:**

Specify agentops repository location:

```bash
# Option 1: Environment variable
export AGENTOPS_HOME=/path/to/agentops
make install

# Option 2: Command-line flag
make install AGENTOPS_HOME=/path/to/agentops
```

**Where is agentops?**

Common locations:
- `~/workspace/agentops`
- `~/dev/agentops`
- `/opt/agentops`

Find it:
```bash
find ~ -name "agentops" -type d 2>/dev/null | grep profiles
```

---

### Issue: "Permission denied" during installation

**Symptoms:**
```
✗ Failed to create directory: .claude
Permission denied
```

**Solution:**

```bash
# Check current directory permissions
ls -ld .

# Make sure you own the directory
ls -la | grep "^d"

# If not, change ownership (careful!)
sudo chown -R $USER:$USER .

# Or install in a directory you own
cd ~/my-projects/my-project
make install
```

---

## Common Validation Issues

### Issue: "YAML/JSON validation failed"

**Symptoms:**
```
✗ .claude/settings.json has syntax errors
Validation failed
```

**Solution:**

```bash
# Validate JSON manually
jq empty .claude/settings.json

# If syntax error, common issues:
# - Trailing comma
# - Missing quotes
# - Single quotes instead of double quotes

# Fix or regenerate
rm .claude/settings.json
make install  # Reinstall
```

---

### Issue: "Missing files after installation"

**Symptoms:**
```
✗ Missing file: .claude/settings.json
✗ Missing directory: .claude/agents
```

**Solution:**

```bash
# Check what exists
ls -la .claude/

# Reinstall (safe, preserves customizations)
make install

# Or verify installation
make verify
```

---

### Issue: "Git hooks not executable"

**Symptoms:**
```
⚠ pre-commit (installed but not executable)
```

**Solution:**

```bash
# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit
chmod +x .git/hooks/commit-msg

# Verify
ls -la .git/hooks/
```

---

## Common Update Issues

### Issue: "Update failed - backup error"

**Symptoms:**
```
✗ Failed to backup existing installation
Error: Cannot proceed without backup
```

**Solution:**

```bash
# Manually backup
cp -r .claude .claude.backup-manual

# Then update
make update

# If still fails, check disk space
df -h .
```

---

### Issue: "Customizations lost after update"

**Symptoms:**
- Custom agents disappeared
- Settings reset to defaults

**Solution:**

AgentOps should preserve customizations. If lost:

```bash
# Restore from automatic backup
ls -d .claude.backup-* | tail -1  # Find latest backup

# Restore custom files
cp .claude.backup-<timestamp>/agents/my-custom-agent.md .claude/agents/

# Or restore completely
rm -rf .claude
cp -r .claude.backup-<timestamp>/.claude .
```

**Prevention:** Always commit custom changes to git before updating.

---

## Platform-Specific Issues

### macOS Issues

#### Issue: "Homebrew not found"

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### Issue: "Command Line Tools required"

```bash
# Install Xcode Command Line Tools
xcode-select --install
```

---

### Linux Issues

#### Issue: "Package manager not found"

If automatic package manager detection fails:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git make

# Fedora/RHEL
sudo dnf install git make

# Arch
sudo pacman -S git make
```

---

### WSL Issues

#### Issue: "Installation slow in /mnt/c/"

**Problem:** WSL filesystem translation is slow.

**Solution:** Install in WSL filesystem, not Windows mount:

```bash
# Bad (slow)
cd /mnt/c/Users/username/projects
make install

# Good (fast)
cd ~/projects
make install
```

#### Issue: "Git not configured in WSL"

```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Configuration Issues

### Issue: "Invalid configuration file"

**Symptoms:**
```
Error: Invalid JSON in configuration file
```

**Solution:**

```bash
# Validate JSON
jq empty install.config.json

# Common errors:
# - Trailing comma: {"key": "value",}  ← Remove trailing comma
# - Missing quotes: {key: "value"}    ← Add quotes: {"key": "value"}
# - Single quotes: {'key': 'value'}   ← Use double quotes

# Format correctly
jq '.' install.config.json > install.config.formatted.json
mv install.config.formatted.json install.config.json
```

---

### Issue: "Profile not found in configuration"

**Symptoms:**
```
Error: profile must be one of: default, product-dev, devops, custom
```

**Solution:**

Check profile name in `install.config.json`:

```json
{
  "version": "1.0",
  "profile": "devops"  ← Must be: default, product-dev, or devops
}
```

---

## Agent Execution Issues

### Issue: "Agent not found"

**Symptoms:**
```
Error: Agent 'my-agent' not found in .claude/agents/
```

**Solution:**

```bash
# List available agents
ls .claude/agents/

# Check agent name matches file name
# File: .claude/agents/my-agent.md → Agent name: my-agent

# Reinstall agents
make install-profile PROFILE=<your-profile>
```

---

### Issue: "Agent execution failed"

**Symptoms:**
```
Error: Agent execution failed
```

**Solution:**

```bash
# Check Claude Code integration
make verify

# Check agent file syntax
cat .claude/agents/problematic-agent.md

# Validate YAML frontmatter (if present)
# Should be between --- markers
```

---

## Uninstall Issues

### Issue: "Uninstall removes too much"

**Prevention:** Uninstall only removes AgentOps components:
- `.claude/`
- `CONSTITUTION.md`
- `CLAUDE.md`
- Git hooks (if installed by AgentOps)

**Your code and git history are NOT removed.**

**Verification before uninstall:**

```bash
# See what will be removed
make uninstall
# Shows list, prompts for confirmation

# Create manual backup first
tar czf agentops-backup.tar.gz .claude CONSTITUTION.md CLAUDE.md
```

---

### Issue: "Cannot uninstall - permission denied"

**Solution:**

```bash
# Check permissions
ls -la .claude

# If owned by root (shouldn't happen)
sudo chown -R $USER:$USER .claude

# Then uninstall
make uninstall
```

---

## Recovery Procedures

### Complete Reinstallation

If all else fails:

```bash
# 1. Backup custom files
cp -r .claude/agents/my-custom-*.md ~/backups/

# 2. Remove AgentOps
make uninstall-force

# 3. Clean reinstall
make install

# 4. Restore custom files
cp ~/backups/my-custom-*.md .claude/agents/

# 5. Verify
make verify
```

---

### Restore from Backup

Automatic backups are created in `.claude.backup-*` directories:

```bash
# List backups
ls -d .claude.backup-*

# Restore latest backup
LATEST=$(ls -d .claude.backup-* | tail -1)
rm -rf .claude
cp -r $LATEST/.claude .

# Or restore specific backup
cp -r .claude.backup-20250105-143022/.claude .
```

---

## Getting Help

### Run Diagnostics

```bash
make doctor
```

Provides:
- Prerequisite versions
- File structure validation
- Configuration check
- Environment information
- Suggested fixes

### Check Logs

Installation output shows detailed progress:

```bash
# Reinstall with full output
make install 2>&1 | tee install.log

# Review log
cat install.log
```

### Manual Validation

```bash
# Check file structure
ls -la .claude/
ls -la .claude/agents/
ls -la .claude/commands/
ls -la .claude/skills/

# Check settings
jq '.' .claude/settings.json

# Check manifest
jq '.' .claude/installed_components.json

# Check prerequisites
git --version
python3 --version
uv --version
claude --version
```

---

## Known Issues

### None Currently Reported

This is the initial release. Issues will be added as they're discovered.

---

## Still Having Issues?

1. **Run `make doctor`** - Comprehensive diagnostics
2. **Check documentation** - `docs/INSTALL.md`, `docs/CONFIGURATION.md`
3. **Review examples** - `examples/config-*.json`
4. **Manual cleanup** - Remove `.claude/` and reinstall
5. **Check prerequisites** - Verify Git, Claude Code, Python/uv installed

---

**Remember:** Installation is idempotent and safe. You can always run `make install` again to fix issues.
