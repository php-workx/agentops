# agentops Installation

Installation of agentops follows a two-stage pattern:

1. **Base Installation** - Install to home directory
2. **Project Installation** - Install into your project

---

## Stage 1: Base Installation

Install the core system to your home directory:

```bash
curl -sSL https://raw.githubusercontent.com/boshu2/agentops/main/scripts/base-install.sh | bash
```

This creates `~/.agentops/` containing:
- Core kernel (CONSTITUTION, primers, hooks)
- Default profile with standards, workflows, agents
- Installation scripts

Alternative: Clone and install locally
```bash
git clone https://github.com/boshu2/agentops.git ~/.agentops
```

---

## Stage 2: Project Installation

Navigate to your project:

```bash
cd /path/to/your/project
~/.agentops/scripts/project-install.sh
```

Select a profile when prompted:
- `default` - Generic foundation
- `devops` - Infrastructure & operations
- `product-dev` - Feature development
- `sre` - Incident response & monitoring

This creates:
- `agentops/` folder in your project
- `.claude/` directory with commands (if using Claude Code)
- Git hooks for enforcement

---

## What Gets Installed

### Core (Always)
- `.agentops/CONSTITUTION.md` - The Laws
- `.agentops/primers/` - Interactive routers
- Git hooks (pre-commit, commit-msg, post-commit)

### Profile-Specific
- Commands for your chosen profile
- Workflows and standards
- Agents for your domain

---

## Configuration

Configure behavior in `~/.agentops/config.yml`:

```yaml
defaults:
  profile: default                    # Which profile to use
  claude_code_commands: true          # Enable Claude Code integration
  use_claude_code_subagents: true     # Enable subagent delegation
  standards_as_claude_code_skills: true  # Use Claude Code Skills
```

Override at runtime:
```bash
~/.agentops/scripts/project-install.sh --profile devops --claude-code-commands true
```

---

## Verify Installation

Check that agentops is working:

```bash
# Check core kernel
cat agentops/CONSTITUTION.md

# Try a primer
/prime

# Check git hooks
cat .git/hooks/pre-commit
```

---

## Updating

Update the base installation:

```bash
cd ~/.agentops
git pull origin main
```

Or reinstall:
```bash
curl -sSL https://raw.githubusercontent.com/boshu2/agentops/main/scripts/base-install.sh | bash
```

Update a project installation:
```bash
cd /path/to/project
~/.agentops/scripts/project-install.sh  # Re-run to update
```

---

## Uninstalling

Remove from project:
```bash
rm -rf agentops .claude
git config --unset core.hooksPath
```

Remove base installation:
```bash
rm -rf ~/.agentops
```

---

## Troubleshooting

**Git hooks not running?**
```bash
# Check hooks are installed
cat .git/hooks/pre-commit

# Verify git config
git config core.hooksPath
```

**Commands not showing?**
```bash
# Check Claude Code is configured
ls -la .claude/commands/

# Verify settings
cat .claude/settings.json
```

**Profile not found?**
```bash
# Check available profiles
ls ~/.agentops/profiles/

# Use absolute path
~/.agentops/scripts/project-install.sh --profile /full/path/to/profile
```

---

## Support

See README.md for more information.
