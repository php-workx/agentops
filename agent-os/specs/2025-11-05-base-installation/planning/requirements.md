# Base Installation System - Requirements

**Feature:** Universal base installation using Makefile + script backend
**Date:** 2025-11-05
**Status:** Planning
**Target:** Dec 1, 2025 Launch (Full scope, iterate post-launch)

---

## Overview

The AgentOps Base Installation System provides a universal, cross-platform installation mechanism that brings the AgentOps framework into any project—existing or new—via a simple Makefile interface backed by intelligent Bash scripting. The system is designed to be idempotent, safe, and intelligent about merging with existing configurations while preserving user customizations.

The installation system supports multiple personas (individual developers and team leads), multiple project states (existing git repos, new projects, any programming language), and multiple profile flavors (default, product-dev, devops, custom). It handles prerequisite checking and auto-installation, interactive configuration combined with config file support, and comprehensive post-install validation.

This system must work seamlessly within the agentops repository itself (dogfooding), serve as a reference implementation for other projects, and scale from single developers to entire teams. The design is inspired by proven patterns like the harmonize script in release-engineering: idempotent, safe to run multiple times, descriptive without being verbose.

---

## User Stories

### Individual Developer

**Story 1: Install into Existing Project**
- As an individual developer, I want to install AgentOps into my existing project so that I can use AI agent workflows
- **Acceptance:** Run `make install` in my project, get working .claude/ setup, CONSTITUTION.md, and CLAUDE.md kernel

**Story 2: Customize Installation**
- As an individual developer, I want to customize the installation (model, profile, permissions) so that it fits my personal workflow
- **Acceptance:** Interactive prompts during install OR pre-fill install.config.json, installation respects my choices

**Story 3: Verify Installation**
- As an individual developer, I want to verify my installation worked so that I know I can start using agents
- **Acceptance:** Run `make verify` post-install, all checks pass, sample agent runs successfully

**Story 4: Install into New Project**
- As an individual developer, I want to install AgentOps into a new project (not yet git initialized) so that I start with agent workflows from day one
- **Acceptance:** Run `make install` in empty directory, git initialized if needed, AgentOps installed

### Team Lead

**Story 5: Install for Team**
- As a team lead, I want to install AgentOps for my team so that we have consistent AI workflows across all team members
- **Acceptance:** Run `make install` with team config, .claude/ committed to repo, team inherits settings

**Story 6: Choose Profile During Install**
- As a team lead, I want to choose profiles during installation so that the team gets domain-specific workflows (devops, product-dev)
- **Acceptance:** Interactive profile selection OR `make install-profile PROFILE=devops`, correct profile installed

**Story 7: Update Existing Installation**
- As a team lead, I want to update an existing AgentOps installation so that we get new features without losing customizations
- **Acceptance:** Run `make update`, new features added, existing customizations preserved, no conflicts

**Story 8: Diagnose Issues**
- As a team lead, I want to diagnose installation or configuration issues so that I can help team members troubleshoot
- **Acceptance:** Run `make doctor`, comprehensive health check, actionable diagnostics, suggested fixes

---

## Functional Requirements

### FR1: Component Installation

**Requirement:** Install all necessary AgentOps components into target project

**Components:**
1. `.claude/` directory structure:
   - `settings.json` - Base settings (model, permissions, hooks, output style)
   - `agents/` - Agent definitions (copied from profile or symlinked)
   - `commands/` - Slash commands (copied from profile or symlinked)
   - `skills/` - Reusable skills (copied from profile or symlinked)
   - `README.md` - Local configuration guide

2. `CONSTITUTION.md` at project root:
   - Five Laws of an Agent
   - Three Rules
   - Constitutional foundation for all agent work

3. `CLAUDE.md` kernel file at project root:
   - Project-specific kernel
   - Bootstrap guide
   - JIT loading instructions
   - Quick commands reference

4. `scripts/` directory (optional, profile-dependent):
   - Validation scripts
   - Testing utilities
   - Helper tools

5. Git hooks/templates:
   - Pre-commit hook (optional, configurable)
   - Post-commit hook (optional, configurable)
   - Commit message template (semantic commit format)

**Acceptance:**
- All components created in correct locations
- File permissions set appropriately (executable for scripts/hooks)
- Directory structure matches profile specification

### FR2: Merge Strategy

**Requirement:** Intelligently merge with existing `.claude/` directories, preserving user customizations

**Scenarios:**

**Scenario A: No existing .claude/**
- Create new `.claude/` directory
- Install all components fresh
- Use profile defaults

**Scenario B: Existing .claude/ with settings.json**
- Read existing `settings.json`
- Merge new settings (add missing keys, preserve existing values)
- Warn if conflicts detected (e.g., different model specified)
- Create backup: `.claude/settings.json.backup.{timestamp}`

**Scenario C: Existing .claude/ with custom agents/commands/skills**
- Preserve all existing custom files
- Add new profile agents/commands/skills alongside
- Create manifest: `.claude/installed_components.json` (track what was installed)
- Never overwrite user files (detect by naming convention or manifest)

**Scenario D: Existing CONSTITUTION.md or CLAUDE.md**
- Warn user: "Existing kernel files detected"
- Offer options: overwrite, skip, merge (append new sections)
- Default: skip (preserve existing)
- Create backups if overwriting

**Merge Rules:**
1. **settings.json:** Deep merge (preserve user keys, add new keys)
2. **agents/commands/skills:** Additive only (never overwrite existing)
3. **CONSTITUTION.md/CLAUDE.md:** User choice (overwrite/skip/merge)
4. **scripts/hooks:** Conditional (install if missing, skip if exists)

**Acceptance:**
- Existing user customizations preserved
- New components added successfully
- Backups created for any overwritten files
- Clear user warnings for conflicts
- Idempotent (safe to run twice)

### FR3: Project Support

**Requirement:** Support installation into multiple project types and states

**Project Types:**

**Type 1: Existing Git Repository**
- Detect: `.git/` directory exists
- Behavior: Install directly, assume git configured
- Validation: Check git status, warn if uncommitted changes

**Type 2: New Project (Not Yet Git Initialized)**
- Detect: No `.git/` directory
- Behavior: Offer to `git init` (optional, prompt user)
- If yes: Initialize git, configure user.name/user.email if missing
- If no: Install anyway (some files may not work without git)

**Type 3: Any Programming Language**
- Detect: Language via file extensions (.py, .js, .go, .rs, etc.)
- Behavior: Language-agnostic installation (AgentOps works universally)
- Adapt: Profile may include language-specific examples

**Type 4: Single Repo with Flavor Per Task**
- Detect: User specifies profile during install
- Behavior: Install base + selected profile (e.g., devops, product-dev)
- Support: Multiple flavors via different profiles

**Acceptance:**
- Works in existing git repos (tested with 3+ projects)
- Works in new projects (with or without git init)
- Works across programming languages (tested Python, JavaScript, Go)
- Profile selection determines flavor/focus

### FR4: Prerequisite Management

**Requirement:** Check for required dependencies, auto-install if missing or possible

**Required Prerequisites:**

**Prerequisite 1: Git**
- Minimum version: 2.30+ (for modern features)
- Check: `git --version`
- Auto-install: Platform-dependent (Homebrew/apt/pacman)
- Failure: Abort with instructions if cannot auto-install

**Prerequisite 2: Claude Code CLI**
- Required: Must be pre-installed
- Check: `claude --version` or equivalent
- Auto-install: NOT SUPPORTED (user must install first)
- Failure: Abort with link to installation docs

**Prerequisite 3: Python via uv**
- Minimum version: Python 3.9+ (stable)
- Tool: uv for dependency management
- Check: `uv --version`, `python --version`
- Auto-install: Yes (install uv if missing, let uv handle Python)

**Prerequisite 4: Bash Shell**
- Minimum version: Bash 4.0+
- Check: `bash --version`
- Auto-install: Not needed (standard on all platforms)
- Failure: Warn if using sh/dash (recommend bash)

**Prerequisite 5: Make**
- Tool: GNU Make or compatible
- Check: `make --version`
- Auto-install: Platform-dependent (usually pre-installed)
- Failure: Warn if missing (provide manual install instructions)

**Optional Prerequisites:**
- Docker (for container-based workflows, profile-dependent)
- Kubernetes tools (kubectl, helm, profile-dependent)
- Language-specific tools (npm, cargo, go, profile-dependent)

**Auto-Install Strategy:**
1. Detect platform (macOS/Linux/Windows)
2. Use platform package manager (brew/apt/pacman)
3. Prompt user before installing (never silent install)
4. Show progress during installation
5. Verify installation succeeded before continuing

**Acceptance:**
- All required prerequisites checked before install begins
- Missing prerequisites auto-installed (if possible) with user consent
- Clear error messages with manual instructions if auto-install fails
- Installation aborts gracefully if critical prerequisites missing

### FR5: Makefile Interface

**Requirement:** Provide simple, consistent Makefile targets for all installation operations

**Target: make install**

**Purpose:** Install AgentOps into current project (interactive mode)

**Behavior:**
1. Check prerequisites (FR4)
2. Detect existing installation (FR2)
3. Prompt for configuration (FR6)
4. Install components (FR1)
5. Run validation (FR8)
6. Display success message with next steps

**Options:**
- `PROFILE=<name>` - Skip profile selection, use specified profile
- `CONFIG=<path>` - Use config file instead of interactive prompts

**Example:**
```bash
make install                           # Interactive
make install PROFILE=devops            # Non-interactive with profile
make install CONFIG=install.config.json  # Non-interactive with config
```

**Target: make install-profile PROFILE=<name>**

**Purpose:** Install specific profile (non-interactive)

**Behavior:**
1. Skip interactive prompts
2. Use specified profile (devops, product-dev, default)
3. Use default settings for model/permissions
4. Install components
5. Run validation

**Example:**
```bash
make install-profile PROFILE=devops
make install-profile PROFILE=product-dev
```

**Target: make uninstall**

**Purpose:** Remove AgentOps installation

**Behavior:**
1. Warn user (show what will be removed)
2. Prompt for confirmation (default: no)
3. Remove `.claude/` directory
4. Remove `CONSTITUTION.md` and `CLAUDE.md` (if installed by us)
5. Remove git hooks (if installed by us)
6. Keep backups (for 7 days in `.claude.backup/`)

**Options:**
- `FORCE=1` - Skip confirmation prompt

**Example:**
```bash
make uninstall              # Interactive with confirmation
make uninstall FORCE=1      # Non-interactive
```

**Target: make verify**

**Purpose:** Verify installation is working correctly

**Behavior:**
1. Check all components exist (FR1)
2. Validate YAML/JSON syntax (settings.json, agents/*.yml)
3. Test Claude Code can load settings (`claude config validate` or equivalent)
4. Run sample agent (hello-world or equivalent)
5. Report status (pass/fail per check)

**Exit code:** 0 if all checks pass, 1 if any fail

**Example:**
```bash
make verify
```

**Target: make update**

**Purpose:** Update existing installation with latest AgentOps components

**Behavior:**
1. Detect current installation
2. Fetch latest profile/components (from agentops repo or remote)
3. Merge new components (FR2, preserve customizations)
4. Run migration scripts (if version upgrade requires changes)
5. Run validation (FR8)

**Options:**
- `VERSION=<tag>` - Update to specific version

**Example:**
```bash
make update                  # Update to latest
make update VERSION=v1.2.0   # Update to specific version
```

**Target: make doctor**

**Purpose:** Diagnose installation and configuration issues

**Behavior:**
1. Check prerequisites (versions, availability)
2. Check file structure (missing/extra files)
3. Validate configuration (settings.json, CLAUDE.md)
4. Test Claude Code integration
5. Check git hooks (if installed)
6. Report issues with suggested fixes

**Output Format:**
```
✓ Git version 2.40.0 (OK)
✗ Claude Code not found (Install from https://...)
⚠ settings.json missing 'model' key (Run make install to fix)
✓ CONSTITUTION.md present (OK)
```

**Example:**
```bash
make doctor
```

**General Target Behavior:**
- Idempotent: Safe to run multiple times
- Descriptive output: Show progress, not verbose logs
- Clear errors: Actionable messages, not stack traces
- Exit codes: 0 = success, 1 = failure

**Acceptance:**
- All targets work as specified
- Clear help text (`make help` shows all targets)
- Consistent interface across targets
- Descriptive output guides user

### FR6: Configuration System

**Requirement:** Support both interactive prompts and configuration file for installation customization

**Configuration Method 1: Interactive Prompts**

**When:** User runs `make install` without CONFIG parameter

**Prompts:**

**Prompt 1: Model Selection**
- Question: "Which Claude model do you want to use?"
- Options: opus (default), sonnet
- Default: opus
- Store in: settings.json → model

**Prompt 2: Profile Selection**
- Question: "Which profile do you want to install?"
- Options: default, product-dev, devops, custom (browse)
- Default: default
- Store in: Determines which agents/commands/skills to install

**Prompt 3: Project Name/Metadata**
- Question: "What is your project name?"
- Default: Current directory name
- Store in: CLAUDE.md → project metadata

**Prompt 4: Permissions**
- Question: "Enable Git permissions?" (Y/n)
- Question: "Enable Docker permissions?" (y/N)
- Question: "Enable Kubernetes permissions?" (y/N)
- Default: Git=yes, Docker=no, Kubernetes=no
- Store in: settings.json → permissions

**Prompt 5: Git Hooks**
- Question: "Install git hooks (commit templates, validation)?" (Y/n)
- Default: yes
- Store in: .git/hooks/ (if enabled)

**Configuration Method 2: Config File**

**When:** User runs `make install CONFIG=install.config.json`

**File Location:** `install.config.json` (in project root or specified path)

**Schema:**
```json
{
  "model": "opus",
  "profile": "devops",
  "project_name": "my-project",
  "permissions": {
    "git": true,
    "docker": true,
    "kubernetes": false,
    "python": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true
  },
  "profile_mode": "copy"
}
```

**Validation:**
- Schema validation before using
- Clear errors if invalid JSON or unknown keys
- Optional fields use defaults

**Hybrid Mode:**

**Behavior:** Prompt for missing values if config file incomplete

**Example:**
```bash
# Config file has model + profile, missing permissions
make install CONFIG=partial.config.json
# Prompts only for permissions, uses config for rest
```

**Customizable Settings:**

1. **Model:** opus, sonnet (default: opus)
2. **Profile:** default, product-dev, devops, custom
3. **Project Name:** String (default: directory name)
4. **Permissions:** Git, Docker, Kubernetes, Python, npm, etc.
5. **Git Hooks:** pre-commit, post-commit, commit-msg
6. **Profile Mode:** copy, symlink, download

**Acceptance:**
- Interactive prompts work (tested with all options)
- Config file works (tested with full and partial configs)
- Hybrid mode works (config + prompts for missing)
- Settings stored correctly in settings.json and CLAUDE.md

### FR7: Profile System

**Requirement:** Support multiple installation modes for profiles, allow user to choose during install

**Profile Sources:**

**Source 1: Copy from agentops/profiles/**
- When: User wants standalone installation (no dependency on agentops repo)
- Behavior: Copy all files from `agentops/profiles/<profile>/` to `.claude/`
- Pros: Self-contained, project portable, no external dependencies
- Cons: No automatic updates, must run `make update` manually

**Source 2: Symlink to agentops repo**
- When: User is developing AgentOps or wants live updates
- Behavior: Symlink `.claude/agents/` → `agentops/profiles/<profile>/agents/`
- Pros: Always up-to-date, edit once apply everywhere
- Cons: Requires agentops repo cloned locally, breaks if repo moved

**Source 3: Download from remote**
- When: User wants latest public release, no local agentops repo
- Behavior: Download profile from GitHub/registry via curl/wget
- Pros: No local repo needed, gets latest public version
- Cons: Requires internet, may be outdated if offline

**Profile Selection:**

**Interactive Mode:**
```
Which profile do you want to install?
1) default      - Generic foundation (minimal agents)
2) product-dev  - Product development workflows (app creation, testing)
3) devops       - Infrastructure/DevOps workflows (CI/CD, deployment)
4) custom       - Browse available profiles and choose

[1-4]: 2

How do you want to install the profile?
1) copy      - Standalone (no dependency on agentops repo)
2) symlink   - Live updates (requires local agentops repo)
3) download  - Latest release (download from GitHub)

[1-3]: 1
```

**Non-Interactive Mode:**
```bash
make install PROFILE=devops MODE=copy
make install-profile PROFILE=product-dev MODE=symlink
```

**Profile Structure:**

Each profile contains:
```
profiles/<profile-name>/
├── agents/          - Agent definitions
├── commands/        - Slash commands
├── skills/          - Reusable skills
├── settings.json    - Default settings for profile
└── README.md        - Profile documentation
```

**Profile Installation Logic:**

**Step 1:** Determine profile source (copy/symlink/download)

**Step 2:** Install profile components
- Copy mode: `cp -r agentops/profiles/<profile>/* .claude/`
- Symlink mode: `ln -s $(pwd)/agentops/profiles/<profile>/agents .claude/agents`
- Download mode: `curl -L <url> | tar xz -C .claude/`

**Step 3:** Merge profile settings.json with user customizations (FR2)

**Step 4:** Update `.claude/installed_components.json` manifest
```json
{
  "profile": "devops",
  "mode": "copy",
  "installed_at": "2025-11-05T10:30:00Z",
  "version": "1.0.0"
}
```

**Acceptance:**
- All three modes work (copy, symlink, download)
- Interactive profile selection works
- Non-interactive mode works (PROFILE + MODE parameters)
- Profile components installed correctly
- Manifest tracks installation details

### FR8: Validation

**Requirement:** Comprehensive post-install validation to ensure installation succeeded and is usable

**Validation Checks:**

**Check 1: File Existence**
- Purpose: Verify all components installed
- Test:
  - `.claude/settings.json` exists
  - `.claude/agents/` exists
  - `.claude/commands/` exists
  - `.claude/skills/` exists
  - `CONSTITUTION.md` exists
  - `CLAUDE.md` exists
- Pass: All files exist
- Fail: List missing files

**Check 2: YAML/JSON Syntax**
- Purpose: Verify configuration files are valid
- Test:
  - `settings.json` is valid JSON
  - Agent definitions are valid YAML
  - Config files parse correctly
- Pass: All files parse without errors
- Fail: Show syntax errors with line numbers

**Check 3: Claude Code Integration**
- Purpose: Verify Claude Code can load settings
- Test:
  - Run `claude config validate` (or equivalent)
  - Check exit code
- Pass: Claude Code loads settings successfully
- Fail: Show Claude Code error messages

**Check 4: Sample Agent Test**
- Purpose: Verify agents can run
- Test:
  - Run simple agent (hello-world or equivalent)
  - Check output
- Pass: Agent runs and produces expected output
- Fail: Show agent error messages

**Check 5: Git Hook Installation (if enabled)**
- Purpose: Verify hooks installed correctly
- Test:
  - `.git/hooks/pre-commit` exists and executable
  - `.git/hooks/commit-msg` exists and executable
  - Hooks contain expected content
- Pass: Hooks installed and executable
- Fail: List missing/incorrect hooks

**Check 6: Prerequisite Versions**
- Purpose: Verify prerequisites meet minimum versions
- Test:
  - Git >= 2.30
  - Python >= 3.9
  - Claude Code installed
- Pass: All prerequisites meet requirements
- Fail: List version mismatches

**Validation Output:**

**Format:**
```
Running AgentOps installation validation...

✓ File existence
  ✓ .claude/settings.json
  ✓ .claude/agents/
  ✓ CONSTITUTION.md
  ✓ CLAUDE.md

✓ YAML/JSON syntax
  ✓ settings.json valid
  ✓ 12 agent definitions valid

✓ Claude Code integration
  ✓ Settings loaded successfully

✓ Sample agent test
  ✓ hello-world agent ran successfully

✓ Git hooks (optional)
  ✓ pre-commit hook installed
  ✓ commit-msg hook installed

✓ Prerequisites
  ✓ Git 2.40.0
  ✓ Python 3.11.0
  ✓ Claude Code 1.2.0

All checks passed! AgentOps installation successful.

Next steps:
  1. Read CLAUDE.md to understand your project setup
  2. Run: claude agent list
  3. Try: /prime-simple-task
```

**make test-agent Target:**

**Purpose:** Smoke test to quickly verify agent system works

**Usage:**
```bash
make test-agent AGENT=hello-world
```

**Behavior:**
1. Load specified agent
2. Run agent with test input
3. Verify output matches expected
4. Report pass/fail

**Acceptance:**
- `make verify` runs all checks and reports status
- Clear pass/fail per check with visual indicators (✓/✗)
- `make test-agent` provides quick smoke test
- Validation catches common issues (missing files, syntax errors, version mismatches)

---

## Technical Requirements

### TR1: Script Backend

**Language:** Bash (universal, simpler than Python for shell operations)

**Rationale:**
- Universal: Available on all platforms (macOS, Linux, Windows WSL)
- Simpler: Direct filesystem operations, process management
- Self-contained: No Python interpreter needed for core install
- Shell-native: Natural fit for Makefile backend

**Platform Detection:**

**Script:** `scripts/base-install.sh`

**Detection Logic:**
```bash
detect_platform() {
  case "$(uname -s)" in
    Darwin*)  PLATFORM="macos" ;;
    Linux*)   PLATFORM="linux" ;;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="windows" ;;
    *) PLATFORM="unknown" ;;
  esac
}
```

**Platform-Specific Behavior:**

**macOS:**
- Package manager: Homebrew (`brew install`)
- Python: Prefer Homebrew Python
- Git: Usually pre-installed, use Xcode tools if missing

**Linux:**
- Package manager: Auto-detect (apt, yum, pacman, zypper)
- Python: Use system Python + uv
- Git: Install via package manager if missing

**Windows WSL:**
- Package manager: apt (Ubuntu) or pacman (Arch)
- Python: Use WSL Python + uv
- Git: Usually pre-installed in WSL

**Idempotent Design:**

**Principle:** Safe to run multiple times, no side effects

**Implementation:**
- Check before create (if file exists, skip or merge)
- Use timestamps for backups (no overwrite of backups)
- Track state in manifest (`.claude/installed_components.json`)
- Detect previous installations (check manifest, merge intelligently)

**Output Style:**

**Descriptive (not verbose, not quiet):**
```bash
Installing AgentOps...
✓ Checking prerequisites
  ✓ Git 2.40.0 found
  ✓ Claude Code 1.2.0 found
  Installing uv...
  ✓ uv installed

✓ Installing components
  ✓ Created .claude/settings.json
  ✓ Installed 12 agents from devops profile
  ✓ Created CONSTITUTION.md
  ✓ Created CLAUDE.md

✓ Running validation
  ✓ All checks passed

Installation complete! Next steps:
  1. Read CLAUDE.md
  2. Run: claude agent list
```

**Error Handling:**
- Clear error messages (no stack traces)
- Actionable suggestions (how to fix)
- Graceful degradation (continue if non-critical error)
- Rollback on critical failure (remove partial install)

**Acceptance:**
- Single script works on macOS, Linux, Windows WSL
- Platform detection automatic
- Idempotent (tested by running twice)
- Descriptive output guides user
- Errors are clear and actionable

### TR2: Python Dependency Management

**Tool:** uv (modern Python package and project manager)

**Rationale:**
- Fast: Written in Rust, significantly faster than pip
- Modern: Handles Python versions + dependencies
- Simple: One tool for everything Python-related
- Cross-platform: Works on macOS, Linux, Windows

**Python Version Selection:**

**Target:** Python 3.11 (stable, widely available)

**Fallback:** Python 3.9+ (minimum supported)

**Version Management:**
```bash
# Check if uv is installed
if ! command -v uv &> /dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Use uv to ensure Python 3.11
uv python install 3.11
uv venv --python 3.11
```

**Dependency Installation:**

**If AgentOps profile requires Python packages:**
```bash
# Create virtual environment
uv venv .venv

# Install dependencies
uv pip install -r requirements.txt
```

**Auto-Install Logic:**

**Step 1:** Check if uv installed
```bash
if ! command -v uv &> /dev/null; then
  # Prompt user
  echo "uv is required for Python dependency management."
  read -p "Install uv now? [Y/n] " response
  if [[ "$response" =~ ^[Yy]?$ ]]; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    echo "Skipping Python setup. Some features may not work."
    exit 0
  fi
fi
```

**Step 2:** Verify Python version
```bash
python_version=$(uv python list | grep "3.11" || echo "")
if [ -z "$python_version" ]; then
  echo "Installing Python 3.11 via uv..."
  uv python install 3.11
fi
```

**Acceptance:**
- uv installed automatically (with user consent)
- Python 3.11 available (installed via uv if missing)
- Dependencies installed via uv (if requirements.txt present)
- Virtual environment created (isolated from system Python)

### TR3: Makefile Targets

**Makefile:** `Makefile` (in project root)

**Design Principles:**
- Simple interface (hide script complexity)
- Consistent behavior (all targets follow same patterns)
- Help text (self-documenting)
- Platform-agnostic (works on all systems with make)

**Target: make install**

**Purpose:** Install AgentOps interactively

**Implementation:**
```makefile
install:
	@echo "Installing AgentOps..."
	@bash scripts/base-install.sh --interactive

install-with-config:
	@bash scripts/base-install.sh --config $(CONFIG)
```

**Parameters:**
- `PROFILE=<name>` → `--profile <name>`
- `CONFIG=<path>` → `--config <path>`
- `MODE=<copy|symlink|download>` → `--mode <mode>`

**Target: make install-profile**

**Purpose:** Install specific profile non-interactively

**Implementation:**
```makefile
install-profile:
	@if [ -z "$(PROFILE)" ]; then \
		echo "Error: PROFILE parameter required"; \
		echo "Usage: make install-profile PROFILE=devops"; \
		exit 1; \
	fi
	@bash scripts/base-install.sh --profile $(PROFILE) --non-interactive
```

**Required:** `PROFILE` parameter

**Target: make uninstall**

**Purpose:** Remove AgentOps installation

**Implementation:**
```makefile
uninstall:
	@echo "Warning: This will remove AgentOps installation."
	@bash scripts/base-install.sh --uninstall

uninstall-force:
	@bash scripts/base-install.sh --uninstall --force
```

**Options:**
- `FORCE=1` → `--force` (skip confirmation)

**Target: make verify**

**Purpose:** Validate installation

**Implementation:**
```makefile
verify:
	@echo "Validating AgentOps installation..."
	@bash scripts/base-install.sh --verify
```

**Exit code:** 0 if pass, 1 if fail

**Target: make update**

**Purpose:** Update existing installation

**Implementation:**
```makefile
update:
	@echo "Updating AgentOps..."
	@bash scripts/base-install.sh --update

update-version:
	@bash scripts/base-install.sh --update --version $(VERSION)
```

**Options:**
- `VERSION=<tag>` → `--version <tag>`

**Target: make doctor**

**Purpose:** Diagnose installation issues

**Implementation:**
```makefile
doctor:
	@echo "Running AgentOps diagnostics..."
	@bash scripts/base-install.sh --doctor
```

**Output:** Health check report with suggested fixes

**Target: make help**

**Purpose:** Show all available targets

**Implementation:**
```makefile
help:
	@echo "AgentOps Installation Targets:"
	@echo ""
	@echo "  make install                    Install AgentOps (interactive)"
	@echo "  make install PROFILE=<name>     Install with specific profile"
	@echo "  make install-profile PROFILE=<name>  Install profile non-interactively"
	@echo "  make uninstall                  Remove AgentOps installation"
	@echo "  make verify                     Validate installation"
	@echo "  make update                     Update existing installation"
	@echo "  make doctor                     Diagnose installation issues"
	@echo "  make help                       Show this help message"
```

**Acceptance:**
- All targets work as specified
- `make help` shows clear documentation
- Parameters passed correctly to script
- Error messages actionable
- Exit codes consistent (0=success, 1=failure)

### TR4: Profile Management

**Modes:** Copy, Symlink, Download

**Mode 1: Copy (Default)**

**When:** User wants standalone installation

**Behavior:**
```bash
copy_profile() {
  local profile=$1
  local source="agentops/profiles/$profile"
  local target=".claude"

  echo "Copying profile: $profile"
  cp -r "$source/agents" "$target/agents"
  cp -r "$source/commands" "$target/commands"
  cp -r "$source/skills" "$target/skills"
  cp "$source/settings.json" "$target/settings.json.profile"

  # Merge with existing settings
  merge_settings "$target/settings.json.profile" "$target/settings.json"
}
```

**Pros:**
- Self-contained
- No external dependencies
- Project portable

**Cons:**
- No automatic updates
- Must run `make update` manually

**Mode 2: Symlink (Development)**

**When:** User is developing AgentOps or wants live updates

**Behavior:**
```bash
symlink_profile() {
  local profile=$1
  local source="$(pwd)/agentops/profiles/$profile"
  local target=".claude"

  echo "Symlinking profile: $profile"
  ln -sf "$source/agents" "$target/agents"
  ln -sf "$source/commands" "$target/commands"
  ln -sf "$source/skills" "$target/skills"

  # Settings are still copied (user customizations)
  cp "$source/settings.json" "$target/settings.json.profile"
  merge_settings "$target/settings.json.profile" "$target/settings.json"
}
```

**Pros:**
- Always up-to-date
- Edit once, apply everywhere
- Development-friendly

**Cons:**
- Requires local agentops repo
- Breaks if repo moved
- Not portable

**Mode 3: Download (Public Release)**

**When:** User wants latest public release, no local repo

**Behavior:**
```bash
download_profile() {
  local profile=$1
  local version=${VERSION:-latest}
  local url="https://github.com/user/agentops/releases/download/$version/profile-$profile.tar.gz"
  local target=".claude"

  echo "Downloading profile: $profile (version: $version)"
  curl -L "$url" | tar xz -C "$target"

  # Merge with existing settings
  merge_settings "$target/settings.json.profile" "$target/settings.json"
}
```

**Pros:**
- No local repo needed
- Gets latest public version
- Simple for end users

**Cons:**
- Requires internet
- May be outdated if offline
- No local development

**Profile Detection:**

**Auto-detect available profiles:**
```bash
list_profiles() {
  if [ -d "agentops/profiles" ]; then
    # Local repo available
    ls -1 agentops/profiles/
  else
    # Download profile list from remote
    curl -s "https://api.github.com/repos/user/agentops/contents/profiles" | \
      jq -r '.[].name'
  fi
}
```

**Manifest Tracking:**

**File:** `.claude/installed_components.json`

**Schema:**
```json
{
  "profile": "devops",
  "mode": "copy",
  "installed_at": "2025-11-05T10:30:00Z",
  "version": "1.0.0",
  "source": "/path/to/agentops/profiles/devops",
  "components": {
    "agents": 12,
    "commands": 8,
    "skills": 5
  }
}
```

**Purpose:**
- Track what was installed
- Support updates (know what to update)
- Support uninstall (know what to remove)
- Debugging (show installation details in `make doctor`)

**Acceptance:**
- All three modes work (tested copy, symlink, download)
- Profile detection automatic (local or remote)
- Manifest tracks installation details
- Mode can be changed via `make update MODE=<mode>`

### TR5: Idempotent Design

**Principle:** Safe to run multiple times without side effects, intelligent merging

**Inspiration:** Harmonize script in release-engineering

**Design Patterns:**

**Pattern 1: Check Before Create**
```bash
install_file() {
  local source=$1
  local target=$2

  if [ -f "$target" ]; then
    echo "⚠ $target already exists (skipping)"
    return 0
  fi

  cp "$source" "$target"
  echo "✓ Created $target"
}
```

**Pattern 2: Merge Existing Configurations**
```bash
merge_settings() {
  local profile_settings=$1
  local user_settings=$2

  if [ ! -f "$user_settings" ]; then
    # No existing settings, just copy
    cp "$profile_settings" "$user_settings"
    return 0
  fi

  # Merge: user settings take precedence
  jq -s '.[0] * .[1]' "$profile_settings" "$user_settings" > "$user_settings.tmp"
  mv "$user_settings.tmp" "$user_settings"
  echo "✓ Merged settings (preserved user customizations)"
}
```

**Pattern 3: Timestamped Backups**
```bash
backup_file() {
  local file=$1
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local backup="${file}.backup.${timestamp}"

  if [ -f "$file" ]; then
    cp "$file" "$backup"
    echo "✓ Backup created: $backup"
  fi
}
```

**Pattern 4: State Detection**
```bash
detect_installation() {
  if [ -f ".claude/installed_components.json" ]; then
    echo "Existing installation detected"
    EXISTING_INSTALL=true
    EXISTING_PROFILE=$(jq -r '.profile' .claude/installed_components.json)
    EXISTING_MODE=$(jq -r '.mode' .claude/installed_components.json)
  else
    echo "No existing installation"
    EXISTING_INSTALL=false
  fi
}
```

**Pattern 5: Additive-Only (Never Overwrite User Files)**
```bash
install_agents() {
  local profile_agents="agentops/profiles/$PROFILE/agents"
  local target_agents=".claude/agents"

  for agent in "$profile_agents"/*.md; do
    local basename=$(basename "$agent")
    local target="$target_agents/$basename"

    if [ -f "$target" ]; then
      # User customization, skip
      echo "⚠ $basename already exists (skipping, preserving user version)"
    else
      cp "$agent" "$target"
      echo "✓ Installed agent: $basename"
    fi
  done
}
```

**Dogfooding: Works in agentops repo itself**

**Scenario:** Developer runs `make install` inside `agentops/` repo

**Behavior:**
1. Detect: We are inside agentops repo
2. Use: Local profiles (no download needed)
3. Install: Into agentops/.claude/ (alongside existing .claude/ if present)
4. Mode: Symlink recommended (edit profiles, see changes immediately)
5. Result: Developer can use AgentOps while developing AgentOps

**Implementation:**
```bash
detect_agentops_repo() {
  if [ -d "profiles" ] && [ -f "CONSTITUTION.md" ]; then
    echo "✓ Running inside agentops repository"
    INSIDE_AGENTOPS=true
    AGENTOPS_PATH="."
  else
    INSIDE_AGENTOPS=false
    AGENTOPS_PATH=$(find_agentops_repo)
  fi
}
```

**Acceptance:**
- Safe to run multiple times (tested 3+ runs)
- Existing user files preserved (never overwritten)
- Settings merged intelligently (user values take precedence)
- Backups created with timestamps (no overwrites)
- Works in agentops repo (dogfooding tested)
- Manifest tracks state (supports updates)

---

## Platform Support

### macOS

**Versions:** macOS 12 (Monterey) and later

**Package Manager:** Homebrew (auto-install if missing)

**Prerequisites:**
- Xcode Command Line Tools (for git, make)
- Homebrew (for package installation)

**Auto-Install:**
```bash
# Check if Homebrew installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install prerequisites
brew install git make
```

**Python:**
- Use Homebrew Python: `brew install python@3.11`
- Or use uv: `uv python install 3.11`

**Specifics:**
- Default shell: zsh (Bash available)
- Git usually pre-installed (via Xcode tools)
- Case-insensitive filesystem (handle carefully)

**Acceptance:**
- Tested on macOS 12, 13, 14
- Homebrew auto-install works
- All features work (copy, symlink, download modes)

### Linux

**Distributions:** Ubuntu 20.04+, Fedora 36+, Arch Linux

**Package Managers:** Auto-detect (apt, dnf, pacman, zypper)

**Prerequisites:**
- Git (usually pre-installed)
- Make (usually pre-installed)
- Python 3.9+ (system Python or via uv)

**Auto-Install:**
```bash
detect_package_manager() {
  if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt-get"
    INSTALL_CMD="sudo apt-get install -y"
  elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
  elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
  elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install -y"
  else
    echo "Error: No supported package manager found"
    exit 1
  fi
}

# Install prerequisites
$INSTALL_CMD git make
```

**Python:**
- Use system Python + uv: `uv python install 3.11`
- Or distro package: `$INSTALL_CMD python3.11`

**Specifics:**
- Default shell: bash
- Git usually pre-installed
- Case-sensitive filesystem
- May need sudo for system package installation

**Acceptance:**
- Tested on Ubuntu 22.04, Fedora 38, Arch Linux
- Package manager auto-detection works
- All features work (copy, symlink, download modes)

### Windows WSL

**Versions:** WSL 2 (Ubuntu, Arch, or other distros)

**Prerequisites:**
- WSL 2 installed and configured
- Git (usually pre-installed in WSL)
- Make (install via package manager)

**Auto-Install:**
```bash
# Use WSL distro package manager (usually apt)
sudo apt-get update
sudo apt-get install -y git make
```

**Python:**
- Use WSL Python: `uv python install 3.11`
- Or distro package: `sudo apt-get install python3.11`

**Specifics:**
- Runs Linux environment on Windows
- Access Windows filesystem: `/mnt/c/...`
- Default shell: bash
- Performance similar to native Linux

**Path Considerations:**
- Install in WSL filesystem (better performance)
- Avoid installing in `/mnt/c/` (slow due to filesystem translation)

**Acceptance:**
- Tested on WSL 2 (Ubuntu 22.04)
- All Linux features work
- Performance acceptable (install in WSL filesystem)

### Platform Detection

**Script Logic:**
```bash
detect_platform() {
  case "$(uname -s)" in
    Darwin*)
      PLATFORM="macos"
      PKG_MANAGER="brew"
      ;;
    Linux*)
      PLATFORM="linux"
      detect_package_manager  # apt, dnf, pacman, zypper
      ;;
    MINGW*|MSYS*|CYGWIN*)
      PLATFORM="windows"
      echo "Native Windows not supported. Please use WSL 2."
      exit 1
      ;;
    *)
      PLATFORM="unknown"
      echo "Unsupported platform: $(uname -s)"
      exit 1
      ;;
  esac
}
```

**Acceptance:**
- Platform detected automatically
- Correct package manager used per platform
- Clear error if unsupported platform
- Works on all three platforms (macOS, Linux, Windows WSL)

---

## Configuration File Schema

### install.config.json

**Purpose:** Non-interactive installation configuration

**Location:** Project root or specified path

**Schema:**
```json
{
  "$schema": "https://agentops.dev/schemas/install-config.json",
  "version": "1.0",
  "model": "opus",
  "profile": "devops",
  "profile_mode": "copy",
  "project_name": "my-project",
  "project_description": "My awesome project using AgentOps",
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

**Field Definitions:**

**version** (string, required)
- Schema version (for future compatibility)
- Current: "1.0"

**model** (string, required)
- Claude model to use
- Options: "opus", "sonnet"
- Default: "opus"

**profile** (string, required)
- Profile to install
- Options: "default", "product-dev", "devops", "custom"
- Default: "default"

**profile_mode** (string, optional)
- Installation mode for profile
- Options: "copy", "symlink", "download"
- Default: "copy"

**project_name** (string, optional)
- Human-readable project name
- Default: Current directory name

**project_description** (string, optional)
- Brief project description
- Used in CLAUDE.md kernel

**permissions** (object, optional)
- Tool permissions to enable
- Keys: git, docker, kubernetes, python, npm, bash, etc.
- Values: boolean (true = enabled, false = disabled)
- Default: git=true, others=false

**hooks** (object, optional)
- Git hooks to install
- Keys: pre_commit, post_commit, commit_msg
- Values: boolean (true = install, false = skip)
- Default: all true

**settings** (object, optional)
- Additional AgentOps settings
- Keys: output_style, auto_load_context, enforce_40_percent_rule
- Values: varies by setting

**Validation:**

**Schema Validation:**
```bash
validate_config() {
  local config_file=$1

  # Check JSON syntax
  if ! jq empty "$config_file" 2>/dev/null; then
    echo "Error: Invalid JSON in $config_file"
    return 1
  fi

  # Check required fields
  local model=$(jq -r '.model' "$config_file")
  if [ "$model" != "opus" ] && [ "$model" != "sonnet" ]; then
    echo "Error: model must be 'opus' or 'sonnet'"
    return 1
  fi

  # More validation...
  return 0
}
```

**Partial Config Support:**

**Example:** `partial.config.json`
```json
{
  "version": "1.0",
  "model": "opus",
  "profile": "devops"
}
```

**Behavior:** Prompt for missing values (permissions, hooks, etc.)

**Acceptance:**
- Schema well-documented (JSON schema + examples)
- Validation catches errors before install
- Partial configs supported (prompt for missing)
- Clear error messages for invalid values

---

## Success Criteria

### Installation Success

**Criteria:**

✅ **All files created in correct locations**
- `.claude/settings.json` exists and valid
- `.claude/agents/`, `commands/`, `skills/` exist
- `CONSTITUTION.md` and `CLAUDE.md` exist at project root
- Scripts and hooks installed (if enabled)

✅ **YAML/JSON syntax valid**
- `settings.json` parses correctly
- Agent YAML definitions parse correctly
- No syntax errors in any config files

✅ **Claude Code can load settings.json**
- Run `claude config validate` (or equivalent)
- Settings loaded without errors
- Agent definitions recognized

✅ **Sample agent runs successfully**
- Run hello-world or equivalent smoke test
- Agent produces expected output
- No errors during agent execution

✅ **No errors during install**
- All installation steps complete
- No uncaught errors or warnings
- Exit code 0

✅ **Idempotent (can run twice safely)**
- Run `make install` twice
- Second run detects existing installation
- No duplicate files or conflicts
- User customizations preserved

**Verification:**
```bash
# Run full verification
make verify

# Expected output: All checks pass
```

### Post-Install Success

**Criteria:**

✅ **make verify passes all checks**
- File existence checks pass
- YAML/JSON syntax checks pass
- Claude Code integration check passes
- Sample agent test passes
- Exit code 0

✅ **make test-agent AGENT=hello-world works**
- Agent loads successfully
- Agent runs without errors
- Output matches expected result

✅ **User can immediately start using agents**
- Read CLAUDE.md (clear instructions)
- Run `claude agent list` (agents visible)
- Try `/prime-simple-task` (workflow starts)
- No additional setup required

**Verification:**
```bash
# Post-install validation
make verify
make test-agent AGENT=hello-world

# Try using agents
claude agent list
```

### Platform Success

**Criteria:**

✅ **Works on macOS (tested on 2+ versions)**
- Tested: macOS 12 (Monterey), macOS 14 (Sonoma)
- All features work (install, verify, update)
- Homebrew auto-install works
- No platform-specific errors

✅ **Works on Linux (Ubuntu, Fedora, Arch)**
- Tested: Ubuntu 22.04, Fedora 38, Arch Linux
- Package manager auto-detection works
- All features work (install, verify, update)
- No distro-specific errors

✅ **Works on Windows WSL 2**
- Tested: WSL 2 with Ubuntu 22.04
- All Linux features work
- Performance acceptable (installed in WSL filesystem)
- No WSL-specific errors

**Verification:**
- CI/CD pipeline tests all platforms
- Manual testing on each platform
- Community testing (beta testers report success)

---

## Out of Scope (Post-Launch Iteration)

**Feature:** Web-based installation UI
- **Why deferred:** Command-line interface sufficient for Dec 1 launch
- **When:** Post-launch (Q1 2026) if community requests

**Feature:** Auto-update checking (notify on new versions)
- **Why deferred:** Manual `make update` sufficient initially
- **When:** Post-launch (Q1 2026) once stable release cadence established

**Feature:** Uninstall preserving user customizations
- **Why deferred:** v1.0 uninstall just removes everything (with backup)
- **When:** Post-launch (Q2 2026) if users request selective uninstall

**Feature:** Migration from other AI frameworks
- **Why deferred:** Focus on new installations first
- **When:** Post-launch (Q2 2026) if community adoption grows

**Feature:** Team collaboration features (shared profiles)
- **Why deferred:** Individual installation sufficient for launch
- **When:** Post-launch (Q3 2026) once team adoption proven

**Feature:** IDE integration (VS Code, JetBrains)
- **Why deferred:** Claude Code CLI sufficient for launch
- **When:** Post-launch (Q3 2026) if IDE users request

**Feature:** Windows native support (non-WSL)
- **Why deferred:** WSL 2 coverage sufficient for launch
- **When:** Post-launch (Q4 2026) if Windows-native demand exists

**Principle:** Ship full scope by Dec 1, iterate based on user feedback post-launch

---

## Dependencies

### Required Dependencies

**Git**
- **Purpose:** Version control, git hooks, commit templates
- **Minimum Version:** 2.30+ (for modern features)
- **Check:** `git --version`
- **Auto-Install:** Yes (via platform package manager)
- **Failure:** Abort installation (critical dependency)

**Claude Code CLI**
- **Purpose:** AI agent execution, settings validation
- **Minimum Version:** TBD (check latest stable)
- **Check:** `claude --version` or equivalent
- **Auto-Install:** No (user must install first)
- **Failure:** Abort installation with link to docs

**Python via uv**
- **Purpose:** Python dependency management (if profile requires)
- **Minimum Version:** Python 3.9+ (prefer 3.11)
- **Tool:** uv (Python package and project manager)
- **Check:** `uv --version`, `python --version`
- **Auto-Install:** Yes (install uv, let uv handle Python)
- **Failure:** Warn if cannot install (some features may not work)

**Bash**
- **Purpose:** Script execution
- **Minimum Version:** Bash 4.0+
- **Check:** `bash --version`
- **Auto-Install:** Not needed (standard on all platforms)
- **Failure:** Warn if using sh/dash (recommend bash)

**Make**
- **Purpose:** Makefile execution (primary interface)
- **Tool:** GNU Make or compatible
- **Check:** `make --version`
- **Auto-Install:** Platform-dependent (usually pre-installed)
- **Failure:** Warn with manual install instructions

### Optional Dependencies

**Docker**
- **Purpose:** Container-based workflows (devops profile)
- **Required:** Only if profile enables Docker permissions
- **Check:** `docker --version`
- **Auto-Install:** No (user must install manually)
- **Failure:** Warn if missing (profile features may not work)

**Kubernetes tools**
- **Purpose:** K8s workflows (devops profile)
- **Tools:** kubectl, helm
- **Required:** Only if profile enables K8s permissions
- **Check:** `kubectl version`, `helm version`
- **Auto-Install:** No (user must install manually)
- **Failure:** Warn if missing (profile features may not work)

**Language-specific tools**
- **Purpose:** Language-specific workflows
- **Examples:** npm (Node.js), cargo (Rust), go (Go)
- **Required:** Only if profile enables language permissions
- **Check:** Tool-specific version commands
- **Auto-Install:** No (user must install manually)
- **Failure:** Warn if missing (profile features may not work)

### Dependency Checking

**Check Script:**
```bash
check_prerequisites() {
  local errors=0

  # Required: Git
  if ! check_git; then
    echo "✗ Git not found"
    errors=$((errors + 1))
  fi

  # Required: Claude Code
  if ! check_claude_code; then
    echo "✗ Claude Code not found"
    errors=$((errors + 1))
  fi

  # Required: Python/uv
  if ! check_python; then
    echo "⚠ Python/uv not found (will auto-install)"
  fi

  # Optional: Docker (profile-dependent)
  if [ "$ENABLE_DOCKER" = true ]; then
    if ! check_docker; then
      echo "⚠ Docker not found (required for devops profile)"
    fi
  fi

  return $errors
}
```

**Acceptance:**
- All required dependencies checked before install
- Missing required dependencies abort installation
- Missing optional dependencies warn but continue
- Auto-install works for Git, Python/uv
- Clear instructions if auto-install fails

---

## Timeline

**Dec 1, 2025:** Full scope implementation (Public launch)

**Deliverables:**
- ✅ Makefile interface (all targets working)
- ✅ Bash script backend (cross-platform)
- ✅ Profile system (copy, symlink, download modes)
- ✅ Interactive + config file installation
- ✅ Comprehensive validation (make verify)
- ✅ Platform support (macOS, Linux, Windows WSL)
- ✅ Documentation (installation guide, troubleshooting)
- ✅ Testing (manual + CI/CD on all platforms)

**Post-Dec 1:** Iterate based on user feedback

**Q1 2026:**
- Gather user feedback (GitHub issues, community discussions)
- Fix bugs reported by early adopters
- Improve documentation (FAQ, common issues)
- Consider web-based UI (if requested)

**Q2 2026:**
- Add out-of-scope features (auto-update, selective uninstall)
- Improve platform support (Windows native if demanded)
- Team collaboration features (shared profiles)

**Q3 2026:**
- IDE integration (VS Code, JetBrains)
- Migration tools (from other AI frameworks)
- Advanced customization options

**Principle:** Ship full scope by Dec 1, iterate and improve based on real-world usage

---

## Notes

**Design Inspiration:**
- Harmonize script in release-engineering (idempotent, safe, descriptive)
- Modern CLI tools (Homebrew, Rust cargo, uv)
- DevOps best practices (Infrastructure as Code, declarative config)

**Dogfooding:**
- Must work in agentops repo itself (developers use while developing)
- Test by running `make install` in agentops/ (should just work)
- Symlink mode recommended for development (live updates)

**Persona Differences:**

**Individual Developer:**
- Quick install, minimal prompts
- Default profile often sufficient
- Copy mode (standalone, portable)
- Focus: Get started fast

**Team Lead:**
- More configuration, team-wide settings
- Specific profile selection (devops, product-dev)
- Config file approach (standardize across team)
- Focus: Consistency across team

**Hybrid Approach:**
- Interactive prompts for missing values
- Config file for pre-filled values
- Best of both worlds

**Output Philosophy:**
- Descriptive: Show what's happening
- Not verbose: Don't overwhelm with details
- Not quiet: User should see progress
- Actionable errors: Tell user how to fix issues

**Testing Strategy:**
- Manual testing on all platforms (macOS, Linux, WSL)
- CI/CD pipeline (run on all platforms automatically)
- Community beta testing (early adopters try before launch)
- Dogfooding (developers use daily)

**Success Metric:**
- User runs `make install`, gets working AgentOps setup in < 2 minutes
- User can immediately start using agents (no additional setup)
- Zero configuration errors for 95%+ of users
- Works on all three platforms (macOS, Linux, WSL) without issues

---

*Requirements complete. Ready for technical specification phase.*
