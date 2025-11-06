# AgentOps Base Installation Guide

Quick start guide for installing AgentOps into any project.

## Quick Start

**Simplest installation (interactive):**

```bash
make install
```

This will:
1. Check prerequisites (Git, Claude Code, Python/uv)
2. Prompt for profile selection (default, product-dev, devops)
3. Prompt for installation mode (copy, symlink)
4. Install AgentOps components
5. Validate installation

## Prerequisites

Before installing AgentOps, ensure you have:

- **Git** 2.30+ - Version control
- **Claude Code CLI** - AI agent execution (required, install from https://docs.claude.com)
- **Python** 3.9+ and **uv** - Dependency management (auto-installed if missing)

The installer will check prerequisites and offer to auto-install missing tools where possible.

## Installation Options

### Option 1: Interactive Installation

```bash
make install
```

Prompts you for:
- Profile (default, product-dev, devops)
- Installation mode (copy, symlink)

### Option 2: Non-Interactive with Profile

```bash
make install PROFILE=devops
```

Uses devops profile with default settings (copy mode).

### Option 3: Configuration File

Create `install.config.json`:

```json
{
  "version": "1.0",
  "profile": "devops",
  "profile_mode": "copy"
}
```

Then install:

```bash
make install CONFIG=install.config.json
```

See `examples/` directory for example config files.

## Profiles

### default
- Minimal, universal patterns
- Best for: New projects, general use
- Components: Basic agents, core commands

### product-dev
- Product development workflows
- Best for: Application development, feature work
- Components: App creation, testing, deployment agents

### devops
- Infrastructure and operations workflows
- Best for: Platform engineering, SRE, operations
- Components: CI/CD, Kubernetes, infrastructure agents

## Installation Modes

### copy (Recommended)
- Copies files from agentops repository to your project
- **Pros:** Self-contained, portable, no dependencies
- **Cons:** Must run `make update` to get new features
- **Use when:** You want a standalone installation

### symlink
- Symlinks to agentops repository
- **Pros:** Always up-to-date, edit once apply everywhere
- **Cons:** Requires local agentops repo, breaks if repo moves
- **Use when:** You're developing AgentOps or want live updates

## Post-Installation

After installation completes:

1. **Verify installation:**
   ```bash
   make verify
   ```

2. **Read documentation:**
   ```bash
   cat CLAUDE.md          # Project kernel
   cat .claude/README.md  # Configuration guide
   ```

3. **Try an agent:**
   ```
   /prime-simple-task
   ```

## Updating

Update existing installation:

```bash
make update
```

This preserves your customizations while adding new components.

## Uninstalling

Remove AgentOps installation:

```bash
make uninstall
```

This will:
- Create a backup in `.claude.backup-uninstall-<timestamp>/`
- Remove `.claude/`, `CONSTITUTION.md`, `CLAUDE.md`
- Prompt for confirmation

Force uninstall (no confirmation):

```bash
make uninstall-force
```

## Troubleshooting

If installation fails:

1. **Run diagnostics:**
   ```bash
   make doctor
   ```

2. **Check prerequisites:**
   - Git 2.30+ installed?
   - Claude Code CLI installed?
   - Python 3.9+ available?

3. **Check permissions:**
   - Can you write to current directory?
   - Is `.claude/` writable if it exists?

4. **Manual cleanup if needed:**
   ```bash
   rm -rf .claude
   rm -f CONSTITUTION.md CLAUDE.md
   ```

## Advanced Usage

### Custom AgentOps Location

If agentops repository is not in a standard location:

```bash
make install AGENTOPS_HOME=/path/to/agentops
```

Or:

```bash
export AGENTOPS_HOME=/path/to/agentops
make install
```

### Installing Additional Profiles

Add another profile to existing installation:

```bash
make install-profile PROFILE=product-dev
```

### Using Configuration Files

See `examples/` for configuration file templates:

- `config-minimal.json` - Minimal configuration
- `config-devops.json` - DevOps profile with full settings
- `config-product-dev.json` - Product dev profile with full settings

Copy and customize:

```bash
cp examples/config-devops.json install.config.json
# Edit install.config.json
make install CONFIG=install.config.json
```

## Common Scenarios

### Scenario 1: New Project

```bash
mkdir my-project
cd my-project
git init
make install
# Follow prompts
```

### Scenario 2: Existing Project

```bash
cd my-existing-project
make install
# AgentOps detects existing .claude/ and merges
```

### Scenario 3: Team Installation

```bash
# Create team config
cat > install.config.json << EOF
{
  "version": "1.0",
  "profile": "devops",
  "profile_mode": "copy"
}
EOF

# Commit config
git add install.config.json
git commit -m "Add AgentOps configuration"

# Install
make install CONFIG=install.config.json

# Commit installation
git add .claude/ CONSTITUTION.md CLAUDE.md
git commit -m "Install AgentOps framework"
git push
```

Team members can now:

```bash
git pull
make verify  # Verify installation
```

## Next Steps

After successful installation:

1. **Read the project kernel:**
   ```bash
   cat CLAUDE.md
   ```

2. **Understand the constitution:**
   ```bash
   cat CONSTITUTION.md
   ```

3. **Browse available agents:**
   ```bash
   ls .claude/agents/
   ```

4. **Try a workflow:**
   ```
   /prime-simple-task
   ```

5. **Read documentation:**
   - `.claude/README.md` - Configuration guide
   - `docs/CONFIGURATION.md` - Schema reference
   - `docs/TROUBLESHOOTING.md` - Common issues

## Support

- **Documentation:** See `docs/` directory
- **Examples:** See `examples/` directory
- **Issues:** Run `make doctor` for diagnostics
- **Updates:** Run `make update` to get latest features

---

**Installation complete?** Run `make verify` to confirm all components are working.
