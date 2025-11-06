# AgentOps Configuration Reference

Complete reference for install.config.json schema and options.

## Configuration File Schema

The `install.config.json` file uses the following schema:

```json
{
  "$schema": "https://agentops.dev/schemas/install-config.json",
  "version": "1.0",
  "model": "opus",
  "profile": "devops",
  "profile_mode": "copy",
  "project_name": "my-project",
  "project_description": "My project description",
  "permissions": {
    "git": true,
    "docker": true,
    "kubernetes": false,
    "python": true,
    "npm": false,
    "bash": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "commit_msg": true
  },
  "settings": {
    "output_style": "technical",
    "auto_load_context": true,
    "enforce_40_percent_rule": true
  }
}
```

## Field Reference

### version (string, required)

Schema version for future compatibility.

- **Current:** `"1.0"`
- **Required:** Yes
- **Example:** `"version": "1.0"`

### model (string, optional)

Claude model to use for agent execution.

- **Options:** `"opus"`, `"sonnet"`
- **Default:** `"opus"`
- **Example:** `"model": "opus"`
- **Recommendation:** Use `opus` for best quality, `sonnet` for faster execution

### profile (string, required)

Profile to install.

- **Options:** `"default"`, `"product-dev"`, `"devops"`, `"custom"`
- **Default:** `"default"`
- **Example:** `"profile": "devops"`

**Profile Descriptions:**

- **default:** Minimal, universal patterns for any project
- **product-dev:** Product development workflows (app creation, testing)
- **devops:** Infrastructure/operations workflows (CI/CD, Kubernetes)
- **custom:** Browse and select custom profile

### profile_mode (string, optional)

Installation mode for profile.

- **Options:** `"copy"`, `"symlink"`, `"download"`
- **Default:** `"copy"`
- **Example:** `"profile_mode": "copy"`

**Mode Descriptions:**

- **copy:** Copy files to project (recommended, self-contained)
- **symlink:** Symlink to agentops repo (live updates, requires repo)
- **download:** Download from GitHub (independent, requires network)

### project_name (string, optional)

Human-readable project name.

- **Default:** Current directory name
- **Example:** `"project_name": "my-awesome-app"`
- **Usage:** Used in `CLAUDE.md` kernel file

### project_description (string, optional)

Brief project description.

- **Default:** None
- **Example:** `"project_description": "Infrastructure automation with Kubernetes"`
- **Usage:** Used in `CLAUDE.md` kernel file

### permissions (object, optional)

Tool permissions to enable.

- **Type:** Object with boolean values
- **Default:** All `false` except `git: true`

**Available Permissions:**

- `git` - Git operations
- `docker` - Docker container operations
- `kubernetes` - Kubernetes cluster operations
- `python` - Python execution
- `npm` - Node.js/npm operations
- `bash` - Bash script execution
- `make` - Makefile operations

**Example:**

```json
"permissions": {
  "git": true,
  "docker": true,
  "kubernetes": true,
  "python": true,
  "bash": true
}
```

### hooks (object, optional)

Git hooks to install.

- **Type:** Object with boolean values
- **Default:** All `true` if in git repository

**Available Hooks:**

- `pre_commit` - Pre-commit hook (validation before commit)
- `post_commit` - Post-commit hook (post-processing after commit)
- `commit_msg` - Commit message hook (enforce commit format)

**Example:**

```json
"hooks": {
  "pre_commit": true,
  "post_commit": true,
  "commit_msg": true
}
```

### settings (object, optional)

Additional AgentOps settings.

- **Type:** Object with various settings
- **Default:** Framework defaults

**Available Settings:**

- `output_style` - Output formatting style (`"technical"`, `"friendly"`)
- `auto_load_context` - Automatically load project context (`true`, `false`)
- `enforce_40_percent_rule` - Enforce 40% context rule (`true`, `false`)

**Example:**

```json
"settings": {
  "output_style": "technical",
  "auto_load_context": true,
  "enforce_40_percent_rule": true
}
```

## Example Configurations

### Minimal Configuration

Simplest valid configuration:

```json
{
  "version": "1.0",
  "profile": "default"
}
```

### DevOps Configuration

Full configuration for DevOps workflows:

```json
{
  "version": "1.0",
  "model": "opus",
  "profile": "devops",
  "profile_mode": "copy",
  "project_name": "my-infrastructure",
  "permissions": {
    "git": true,
    "docker": true,
    "kubernetes": true,
    "bash": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true
  }
}
```

### Product Development Configuration

Full configuration for product development:

```json
{
  "version": "1.0",
  "model": "opus",
  "profile": "product-dev",
  "profile_mode": "copy",
  "project_name": "my-app",
  "permissions": {
    "git": true,
    "python": true,
    "npm": true,
    "bash": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "commit_msg": true
  },
  "settings": {
    "output_style": "technical",
    "auto_load_context": true,
    "enforce_40_percent_rule": true
  }
}
```

## Partial Configurations

You can provide partial configurations. Missing values will be prompted interactively.

**Example:** Profile only, prompt for mode

```json
{
  "version": "1.0",
  "profile": "devops"
}
```

The installer will prompt:

```
Select installation mode (1-2) [1]:
  1) copy     - Copy files (independent, recommended)
  2) symlink  - Symlink to agentops repo (live updates)
```

## Validation

The installer validates configuration files before use:

1. **JSON syntax:** Must be valid JSON
2. **Schema version:** Must be `"1.0"`
3. **Required fields:** `version` and `profile` must be present
4. **Valid values:** Profile must be valid, mode must be valid, permissions must be boolean

**Validation errors:**

```bash
# Invalid JSON
Error: Invalid JSON in configuration file

# Missing required field
Error: Configuration missing required field: profile

# Invalid value
Error: profile must be one of: default, product-dev, devops, custom
```

## Using Configuration Files

### Create from Example

```bash
# Copy example
cp examples/config-devops.json install.config.json

# Edit to your needs
vim install.config.json

# Install with config
make install CONFIG=install.config.json
```

### Validate Configuration

The installer validates automatically, but you can also validate manually:

```bash
# Validate JSON syntax
jq empty install.config.json

# View formatted configuration
jq '.' install.config.json
```

## Environment Variables

Configuration can also be set via environment variables (lower priority than config file):

```bash
export PROFILE=devops
export INSTALL_MODE=copy
export AGENTOPS_HOME=/path/to/agentops

make install
```

**Priority order (highest to lowest):**

1. Command-line flags: `make install PROFILE=devops`
2. Configuration file: `make install CONFIG=install.config.json`
3. Environment variables: `export PROFILE=devops`
4. Interactive prompts: User input
5. Defaults: Built-in defaults

## Profile-Specific Settings

Each profile may have its own default settings in `profiles/<name>/settings.json`. These are merged with your configuration:

**Merge order:**

1. Profile defaults (`profiles/devops/settings.json`)
2. User configuration (`install.config.json`)
3. Existing installation (`.claude/settings.json`)

**User settings always take precedence.**

## Advanced Configuration

### Custom Profile Location

Specify custom profile directory:

```bash
export AGENTOPS_HOME=/path/to/custom/agentops
make install
```

### Multiple Profiles

Install multiple profiles (additive):

```bash
# Install devops profile
make install PROFILE=devops

# Add product-dev profile
make install-profile PROFILE=product-dev
```

Components from both profiles will be available.

## Troubleshooting Configuration

### "Configuration file not found"

```bash
# Check file exists
ls -la install.config.json

# Use absolute path
make install CONFIG=/full/path/to/install.config.json
```

### "Invalid JSON in configuration file"

```bash
# Validate JSON
jq empty install.config.json

# Common issues:
# - Missing comma
# - Trailing comma
# - Unquoted keys
# - Single quotes instead of double quotes
```

### "Profile not found"

```bash
# Check available profiles
ls agentops/profiles/

# Verify AGENTOPS_HOME
echo $AGENTOPS_HOME

# Set if not set
export AGENTOPS_HOME=/path/to/agentops
```

## Schema Evolution

Future versions may add new fields. Old configurations will continue to work:

**Version 1.0** (current):
- Basic installation options
- Profile selection
- Permission management

**Future versions:**
- Additional settings
- New profiles
- Advanced customization

**Backward compatibility guaranteed:** Version 1.0 configurations will always work.

---

**Next:** See `docs/INSTALL.md` for installation guide or `docs/TROUBLESHOOTING.md` for common issues.
