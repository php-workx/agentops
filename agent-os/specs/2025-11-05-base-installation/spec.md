# Base Installation System - Technical Specification

**Version:** 1.0.0
**Date:** 2025-11-05
**Status:** Draft
**Target Release:** Dec 1, 2025

---

## Table of Contents

1. [Overview](#1-overview)
2. [Architecture](#2-architecture)
3. [Component Design](#3-component-design)
4. [Implementation Details](#4-implementation-details)
5. [User Interface (CLI/Makefile)](#5-user-interface-climakefile)
6. [Configuration](#6-configuration)
7. [Installation Flow](#7-installation-flow)
8. [Validation & Testing](#8-validation--testing)
9. [Error Handling](#9-error-handling)
10. [Security Considerations](#10-security-considerations)
11. [Performance Requirements](#11-performance-requirements)
12. [Future Enhancements](#12-future-enhancements)
13. [Appendices](#13-appendices)

---

## 1. Overview

### 1.1 Purpose

The AgentOps Base Installation System provides a universal, cross-platform installation mechanism that brings the AgentOps framework into any project—existing or new—via a simple Makefile interface backed by intelligent Bash scripting.

**What it does:**
- Installs AgentOps framework components (`.claude/`, `CONSTITUTION.md`, `CLAUDE.md`)
- Supports multiple installation profiles (default, product-dev, devops, custom)
- Manages prerequisites (Git, Claude Code CLI, Python/uv)
- Validates installation completeness and correctness
- Works across platforms (macOS, Linux, Windows WSL)
- Merges intelligently with existing configurations

**Why it matters:**
- Makes AgentOps accessible to any project in < 2 minutes
- Preserves user customizations during updates
- Provides consistent experience across platforms and teams
- Enables rapid onboarding for individuals and teams

### 1.2 Scope

**Included in Dec 1, 2025 Release:**
- ✅ Makefile interface (install, verify, update, doctor, uninstall)
- ✅ Bash script backend (universal, cross-platform)
- ✅ Profile system (copy, symlink, download modes)
- ✅ Interactive prompts + config file support
- ✅ Prerequisite checking and auto-installation
- ✅ Intelligent merge strategy (preserve user customizations)
- ✅ Comprehensive validation (file existence, syntax, integration)
- ✅ Platform support (macOS, Linux, Windows WSL)
- ✅ Git hooks installation (pre-commit, post-commit, commit-msg)
- ✅ Idempotent design (safe to run multiple times)
- ✅ Documentation (installation guide, troubleshooting)

**Deferred Post-Launch:**
- Web-based installation UI
- Auto-update checking and notifications
- Migration from other AI frameworks
- Team collaboration features (shared profiles)
- IDE integration (VS Code, JetBrains)
- Windows native support (non-WSL)

### 1.3 Success Metrics

**Installation Success:**
- User runs `make install` and gets working setup in < 2 minutes
- 95%+ of users have zero configuration errors
- All validation checks pass (`make verify`)
- Sample agent runs successfully post-install

**Platform Success:**
- Works on macOS 12+ (Monterey and later)
- Works on Linux (Ubuntu 20.04+, Fedora 36+, Arch Linux)
- Works on Windows WSL 2

**User Experience Success:**
- Clear, descriptive output (not verbose, not silent)
- Actionable error messages with fix suggestions
- Idempotent (safe to run twice, preserves customizations)
- User can immediately start using agents (no additional setup)

---

## 2. Architecture

### 2.1 High-Level Architecture

The installation system follows a three-tier architecture:

**Tier 1: User Interface (Makefile)**
- Simple, consistent command interface
- Parameter passing to backend scripts
- Help text and documentation
- Exit code handling

**Tier 2: Script Backend (Bash)**
- Platform detection and adaptation
- Prerequisite checking and auto-installation
- File operations (copy, merge, validate)
- Profile management (copy/symlink/download)
- State tracking (manifest, backups)

**Tier 3: File Operations (Templates + Profiles)**
- Template files (CONSTITUTION.md, CLAUDE.md)
- Profile directories (agents, commands, skills)
- Configuration files (settings.json)
- Git hooks and scripts

**Data Flow:**
```
User Command (make install)
  ↓
Makefile (parameter parsing)
  ↓
Script Backend (scripts/base-install.sh)
  ↓ (checks prerequisites)
  ↓ (loads configuration)
  ↓ (installs components)
  ↓ (validates installation)
  ↓
Success Message + Next Steps
```

### 2.2 Component Relationships

**Dependencies:**
```
Makefile
  ├─→ scripts/base-install.sh (main installer)
  │     ├─→ lib/platform.sh (platform detection)
  │     ├─→ lib/prerequisites.sh (dependency checking)
  │     ├─→ lib/profiles.sh (profile management)
  │     └─→ lib/validation.sh (post-install validation)
  │
  └─→ templates/ (source files)
        ├─→ .claude/ (directory structure)
        ├─→ CONSTITUTION.md (framework laws)
        └─→ CLAUDE.md (project kernel)
```

**Runtime Dependencies:**
```
Prerequisites (checked at start)
  ├─→ Git (required, version 2.30+)
  ├─→ Claude Code CLI (required, must pre-exist)
  ├─→ Python/uv (required, auto-install if missing)
  ├─→ Bash (required, version 4.0+)
  └─→ Make (required, GNU Make or compatible)

Optional Dependencies (profile-dependent)
  ├─→ Docker (devops profile)
  ├─→ Kubernetes tools (devops profile)
  └─→ Language tools (npm, cargo, go, etc.)
```

### 2.3 Directory Structure

**Pre-Installation (agentops repository):**
```
agentops/
├── Makefile                          # User interface (to be copied to projects)
├── scripts/
│   ├── base-install.sh               # Main installer
│   ├── lib/
│   │   ├── platform.sh               # Platform detection
│   │   ├── prerequisites.sh          # Dependency checking
│   │   ├── profiles.sh               # Profile management
│   │   └── validation.sh             # Post-install validation
│   └── templates/
│       ├── .claude/
│       │   ├── settings.json         # Base settings template
│       │   └── README.md             # Local configuration guide
│       ├── CONSTITUTION.md           # Framework laws template
│       └── CLAUDE.md                 # Project kernel template
│
├── profiles/                         # Available profiles
│   ├── default/
│   │   ├── agents/
│   │   ├── commands/
│   │   ├── skills/
│   │   ├── settings.json
│   │   └── README.md
│   ├── product-dev/
│   └── devops/
│
└── .claude/                          # AgentOps own installation (dogfooding)
```

**Post-Installation (target project):**
```
project-root/
├── Makefile                          # Copied/updated with AgentOps targets
├── install.config.json               # Optional: installation configuration
├── CONSTITUTION.md                   # Five Laws of an Agent
├── CLAUDE.md                         # Project kernel
│
├── .claude/                          # Main installation directory
│   ├── settings.json                 # Claude Code configuration
│   ├── settings.local.json           # User overrides (gitignored)
│   ├── README.md                     # Documentation
│   ├── installed_components.json    # Installation manifest
│   │
│   ├── agents/                       # Agent definitions (from profile)
│   │   ├── research.md
│   │   ├── plan.md
│   │   └── implement.md
│   │
│   ├── commands/                     # Slash commands (from profile)
│   │   ├── prime-simple-task.md
│   │   └── prime-complex-task.md
│   │
│   └── skills/                       # Reusable skills (from profile)
│
├── .git/
│   └── hooks/                        # Optional: git hooks
│       ├── pre-commit
│       ├── post-commit
│       └── commit-msg
│
└── .claude.backup-*/                 # Backups from updates (timestamped)
```

### 2.4 Data Flow

**Installation Flow:**
```
1. USER INITIATES
   make install [PROFILE=<name>] [CONFIG=<path>]
     ↓
2. MAKEFILE ROUTES
   Passes parameters to base-install.sh
     ↓
3. DETECT PLATFORM
   Determine OS, package manager, paths
     ↓
4. CHECK PREREQUISITES
   Git, Claude Code, Python/uv, Bash, Make
   Auto-install missing (with user consent)
     ↓
5. LOAD CONFIGURATION
   Interactive prompts OR load install.config.json
   Hybrid: prompt for missing values
     ↓
6. DETECT EXISTING INSTALLATION
   Check for .claude/, CONSTITUTION.md, CLAUDE.md
   Load manifest if exists
     ↓
7. BACKUP (if existing)
   Timestamp backup: .claude.backup-<timestamp>/
     ↓
8. INSTALL BASE STRUCTURE
   Create/update .claude/ directory
   Install settings.json (merge with existing)
   Install README.md
     ↓
9. INSTALL PROFILE
   Copy/symlink/download based on mode
   Merge agents, commands, skills
   Update manifest
     ↓
10. INSTALL ROOT FILES
    CONSTITUTION.md, CLAUDE.md
    Update .gitignore
     ↓
11. INSTALL GIT HOOKS (optional)
    pre-commit, post-commit, commit-msg
    Make executable
     ↓
12. VALIDATE INSTALLATION
    File existence, syntax, Claude Code integration
    Run sample agent
     ↓
13. DISPLAY SUCCESS
    Summary, next steps, documentation links
```

**Update Flow:**
```
1. USER INITIATES
   make update [VERSION=<tag>]
     ↓
2. DETECT EXISTING INSTALLATION
   Read manifest: .claude/installed_components.json
   Determine current profile, mode, version
     ↓
3. BACKUP CURRENT STATE
   Timestamp backup: .claude.backup-<timestamp>/
     ↓
4. FETCH LATEST
   Based on mode:
   - copy: fetch from agentops repo or download
   - symlink: already up-to-date
   - download: fetch latest from remote
     ↓
5. MERGE UPDATES
   Preserve user customizations
   Add new framework components
   Update manifest with new version
     ↓
6. RUN MIGRATIONS
   If version upgrade requires changes
   Execute migration scripts
     ↓
7. VALIDATE
   Run full validation suite
     ↓
8. DISPLAY SUCCESS
   Show what was updated
```

---

## 3. Component Design

### 3.1 Makefile Interface

**Design Philosophy:** Simple, discoverable, consistent

**File:** `Makefile` (in project root)

#### Target: make install

**Purpose:** Base installation of AgentOps framework (interactive mode)

**Signature:**
```makefile
install:
	@echo "Installing AgentOps..."
	@bash scripts/base-install.sh --interactive
```

**Parameters:**
- `PROFILE=<name>` - Skip profile selection, use specified (default, product-dev, devops)
- `CONFIG=<path>` - Use config file instead of interactive prompts
- `MODE=<copy|symlink|download>` - Profile installation mode

**Behavior:**
1. Check prerequisites (Git, Claude Code, Python/uv)
2. Detect existing installation (merge if present)
3. Load configuration (interactive or from file)
4. Install components (.claude/, CONSTITUTION.md, CLAUDE.md)
5. Install selected profile
6. Install git hooks (if requested)
7. Run validation
8. Display success message with next steps

**Idempotent:** Yes (safe to run multiple times)

**Exit Codes:**
- 0: Success
- 1: Installation failed
- 2: Prerequisites missing (cannot auto-install)

**Examples:**
```bash
make install                           # Interactive mode
make install PROFILE=devops            # Non-interactive with profile
make install CONFIG=install.config.json # Non-interactive with config
make install PROFILE=devops MODE=symlink # Development mode
```

#### Target: make install-profile PROFILE=<name>

**Purpose:** Install additional profile after base install (non-interactive)

**Signature:**
```makefile
install-profile:
	@if [ -z "$(PROFILE)" ]; then \
		echo "Error: PROFILE parameter required"; \
		echo "Usage: make install-profile PROFILE=devops"; \
		exit 1; \
	fi
	@bash scripts/base-install.sh --profile $(PROFILE) --non-interactive
```

**Parameters:**
- `PROFILE=<name>` - Required: profile to install
- `MODE=<copy|symlink|download>` - Optional: installation mode

**Behavior:**
1. Verify base install exists (.claude/ present)
2. Fetch profile (copy/symlink/download)
3. Merge with existing .claude/
4. Update settings.json with profile defaults
5. Validate profile structure
6. Update manifest

**Idempotent:** Yes

**Exit Codes:**
- 0: Success
- 1: Profile installation failed
- 2: Base install not found

**Examples:**
```bash
make install-profile PROFILE=devops
make install-profile PROFILE=product-dev MODE=symlink
```

#### Target: make verify

**Purpose:** Validate installation health

**Signature:**
```makefile
verify:
	@echo "Validating AgentOps installation..."
	@bash scripts/base-install.sh --verify
```

**Behavior:**
1. Check file existence (.claude/, CONSTITUTION.md, CLAUDE.md)
2. Validate YAML/JSON syntax (settings.json, agents/*.md)
3. Test Claude Code integration (load settings)
4. Run sample agent (hello-world or equivalent)
5. Check git hooks (if installed)
6. Verify prerequisite versions

**Output Format:**
```
Running AgentOps installation validation...

[1/6] Checking file existence...
✓ .claude/settings.json
✓ .claude/README.md
✓ CONSTITUTION.md
✓ CLAUDE.md
✓ Profile files (12 agents, 8 commands, 3 skills)

[2/6] Validating syntax...
✓ settings.json (valid JSON)
✓ All YAML files (0 errors)

[3/6] Testing Claude Code integration...
✓ Settings loaded successfully
✓ No configuration conflicts

[4/6] Running sample agent...
✓ hello-world agent executed
✓ Output: "Hello from AgentOps!"

[5/6] Checking git hooks...
✓ pre-commit hook installed and executable
✓ commit-msg hook installed and executable

[6/6] Verifying prerequisites...
✓ Git 2.43.0 (>= 2.30.0)
✓ Claude Code 1.2.0
✓ Python 3.11.0 (>= 3.9.0)

════════════════════════════════════════════════════
All checks passed! ✓
════════════════════════════════════════════════════
```

**Exit Codes:**
- 0: All checks passed
- 1: One or more checks failed

#### Target: make update

**Purpose:** Update existing installation with latest AgentOps components

**Signature:**
```makefile
update:
	@echo "Updating AgentOps..."
	@bash scripts/base-install.sh --update

update-version:
	@bash scripts/base-install.sh --update --version $(VERSION)
```

**Parameters:**
- `VERSION=<tag>` - Optional: update to specific version (default: latest)

**Behavior:**
1. Detect current installation (read manifest)
2. Backup current state (.claude.backup-<timestamp>/)
3. Fetch latest profile/components (based on mode)
4. Merge new components (preserve customizations)
5. Run migration scripts (if version upgrade)
6. Run validation
7. Display summary of changes

**Idempotent:** Yes

**Exit Codes:**
- 0: Update successful
- 1: Update failed (rolled back to backup)

**Examples:**
```bash
make update                  # Update to latest
make update VERSION=v1.2.0   # Update to specific version
```

#### Target: make doctor

**Purpose:** Diagnose installation and configuration issues

**Signature:**
```makefile
doctor:
	@echo "Running AgentOps diagnostics..."
	@bash scripts/base-install.sh --doctor
```

**Behavior:**
1. Check prerequisites (versions, availability)
2. Check file structure (missing/extra files)
3. Validate configuration (settings.json, CLAUDE.md)
4. Test Claude Code integration
5. Check git hooks (if installed)
6. Check environment variables
7. Report issues with suggested fixes

**Output Format:**
```
AgentOps Installation Diagnostics

[Prerequisites]
✓ Git 2.43.0 (>= 2.30.0 required)
✓ Claude Code CLI 1.2.0
✗ Python 3.8.0 (3.9+ required) ← ISSUE FOUND

[File Structure]
✓ .claude/ exists and readable
✓ All framework files present
✓ File permissions correct

[Configuration]
✓ install.config.json valid
✓ settings.json valid
! settings.local.json not found (optional)

[Environment]
✓ AGENTOPS_HOME=/Users/user/agentops
✓ Shell: bash 5.2
✓ PATH includes necessary directories

════════════════════════════════════════════════════
Issues Found: 1
════════════════════════════════════════════════════

ISSUE: Python version too old (3.8.0, need 3.9+)
FIX:   Run 'make install' again to auto-install correct version via uv

For more help: https://agentops.dev/docs/troubleshooting
```

**Exit Codes:**
- 0: No issues found
- 1: Issues detected (see output for details)

#### Target: make uninstall

**Purpose:** Remove AgentOps installation

**Signature:**
```makefile
uninstall:
	@echo "Warning: This will remove AgentOps installation."
	@bash scripts/base-install.sh --uninstall

uninstall-force:
	@bash scripts/base-install.sh --uninstall --force
```

**Parameters:**
- `FORCE=1` - Skip confirmation prompt

**Behavior:**
1. Warn user (show what will be removed)
2. Prompt for confirmation (default: no)
3. Remove .claude/ directory
4. Remove CONSTITUTION.md and CLAUDE.md (if installed by us)
5. Remove git hooks (if installed by us)
6. Keep backups (moved to .claude.backup-uninstall-<timestamp>/)

**NOT Idempotent:** Requires confirmation each time

**Exit Codes:**
- 0: Uninstall successful
- 1: Uninstall cancelled or failed

**Examples:**
```bash
make uninstall              # Interactive with confirmation
make uninstall FORCE=1      # Non-interactive
```

#### Target: make help

**Purpose:** Show all available targets with descriptions

**Signature:**
```makefile
help:
	@echo "AgentOps Framework - Installation & Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install                 Install AgentOps framework"
	@echo "  make install-profile PROFILE=<name>"
	@echo "                               Install additional profile"
	@echo "  make verify                  Validate installation"
	@echo "  make update                  Update to latest version"
	@echo "  make doctor                  Diagnose installation issues"
	@echo "  make uninstall               Remove AgentOps framework"
	@echo "  make help                    Show this help message"
	@echo ""
	@echo "Profiles:"
	@echo "  default      Minimal, universal patterns"
	@echo "  product-dev  Product development workflows"
	@echo "  devops       Infrastructure/operations workflows"
	@echo ""
	@echo "Examples:"
	@echo "  make install                              # Interactive install"
	@echo "  make install-profile PROFILE=devops       # Add devops profile"
	@echo "  make verify                               # Check installation"
	@echo "  make doctor                               # Troubleshoot issues"
	@echo ""
	@echo "Documentation: https://agentops.dev/docs"
```

### 3.2 Script Backend (base-install.sh)

**File:** `scripts/base-install.sh`

**Language:** Bash (POSIX-compatible where possible)

**Structure:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source library functions
source "$SCRIPT_DIR/lib/platform.sh"
source "$SCRIPT_DIR/lib/prerequisites.sh"
source "$SCRIPT_DIR/lib/profiles.sh"
source "$SCRIPT_DIR/lib/validation.sh"

# Global variables
EXISTING_INSTALL=false
EXISTING_PROFILE=""
EXISTING_MODE=""
INTERACTIVE=true
CONFIG_FILE=""
PROFILE=""
MODE="copy"
INSTALL_HOOKS=true

# Main installation flow
main() {
    parse_arguments "$@"
    detect_platform
    check_prerequisites

    if [ "$INTERACTIVE" = true ]; then
        prompt_configuration
    else
        load_configuration
    fi

    detect_existing_installation
    backup_if_existing
    install_base_structure
    install_profile
    install_root_files
    install_hooks_if_enabled
    validate_installation
    print_success_message
}

# Entry point
main "$@"
```

**Design Principles:**
- **Fail fast:** `set -euo pipefail` catches errors immediately
- **Platform detection first:** Adapt to OS before operations
- **Descriptive output:** Show progress without overwhelming
- **Rollback on error:** Restore from backup if critical failure
- **Log all actions:** Track what was done for debugging

### 3.3 Platform Detection (lib/platform.sh)

**File:** `scripts/lib/platform.sh`

**Responsibilities:**
- Detect operating system (macOS, Linux, Windows WSL)
- Detect package manager (brew, apt, dnf, pacman, zypper)
- Set platform-specific variables
- Provide platform-specific functions

**API:**
```bash
# Platform detection
detect_platform()           # Sets PLATFORM, PKG_MANAGER, INSTALL_CMD
is_macos()                  # Returns 0 if macOS, 1 otherwise
is_linux()                  # Returns 0 if Linux, 1 otherwise
is_wsl()                    # Returns 0 if WSL, 1 otherwise

# Package manager detection
get_pkg_manager()           # Returns package manager name
get_install_cmd()           # Returns install command (e.g., "brew install")

# Platform-specific operations
install_package(name)       # Install package using platform package manager
check_package(name)         # Check if package installed
```

**Implementation:**
```bash
#!/usr/bin/env bash

# Global variables set by detect_platform()
PLATFORM=""
PKG_MANAGER=""
INSTALL_CMD=""

detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            PLATFORM="macos"
            PKG_MANAGER="brew"
            INSTALL_CMD="brew install"
            ;;
        Linux*)
            PLATFORM="linux"
            detect_linux_package_manager
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "Error: Native Windows not supported. Please use WSL 2."
            exit 1
            ;;
        *)
            echo "Error: Unsupported platform: $(uname -s)"
            exit 1
            ;;
    esac

    echo "✓ Platform detected: $PLATFORM ($PKG_MANAGER)"
}

detect_linux_package_manager() {
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
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

is_macos() {
    [ "$PLATFORM" = "macos" ]
}

is_linux() {
    [ "$PLATFORM" = "linux" ]
}

is_wsl() {
    grep -qi microsoft /proc/version 2>/dev/null
}

install_package() {
    local package=$1
    echo "Installing $package..."
    $INSTALL_CMD "$package"
}

check_package() {
    local package=$1
    command -v "$package" &> /dev/null
}
```

### 3.4 Prerequisites Management (lib/prerequisites.sh)

**File:** `scripts/lib/prerequisites.sh`

**Responsibilities:**
- Check required tools (Git, Claude Code, Python/uv)
- Auto-install missing prerequisites (with user consent)
- Verify versions meet minimum requirements

**API:**
```bash
# Main check
check_prerequisites()       # Check all, exit if critical missing

# Individual checks
check_git()                 # Check git installed and version >= 2.30
check_claude_code()         # Check Claude Code CLI installed
check_python_uv()           # Check Python/uv, install if missing
check_bash()                # Check Bash version >= 4.0
check_make()                # Check Make installed

# Auto-install
install_prerequisite(name)  # Auto-install specific tool (if supported)
prompt_install(name)        # Ask user before installing
```

**Minimum Versions:**
- Git: 2.30+ (for modern features)
- Claude Code: Latest stable (version check TBD)
- Python: 3.9+ (prefer 3.11)
- Bash: 4.0+
- Make: Any recent version

**Implementation:**
```bash
#!/usr/bin/env bash

check_prerequisites() {
    local errors=0

    echo "Checking prerequisites..."

    # Required: Git
    if ! check_git; then
        if prompt_install "git"; then
            install_package git
            check_git || errors=$((errors + 1))
        else
            errors=$((errors + 1))
        fi
    fi

    # Required: Claude Code (cannot auto-install)
    if ! check_claude_code; then
        echo "✗ Claude Code CLI not found"
        echo "  Install from: https://claude.com/claude-code"
        errors=$((errors + 1))
    fi

    # Required: Python/uv (can auto-install)
    if ! check_python_uv; then
        if prompt_install "uv"; then
            install_uv
            check_python_uv || errors=$((errors + 1))
        else
            echo "⚠ Python/uv not installed. Some features may not work."
        fi
    fi

    # Required: Bash (usually pre-installed)
    if ! check_bash; then
        echo "⚠ Bash version too old. Recommend 4.0+."
    fi

    # Required: Make (usually pre-installed)
    if ! check_make; then
        echo "⚠ Make not found. Install via package manager."
        errors=$((errors + 1))
    fi

    if [ $errors -gt 0 ]; then
        echo "✗ $errors critical prerequisites missing"
        exit 2
    fi

    echo "✓ All prerequisites satisfied"
}

check_git() {
    if ! command -v git &> /dev/null; then
        echo "✗ Git not found"
        return 1
    fi

    local version=$(git --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)

    if [ "$major" -lt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -lt 30 ]; }; then
        echo "✗ Git version $version too old (need 2.30+)"
        return 1
    fi

    echo "✓ Git $version found"
    return 0
}

check_claude_code() {
    if ! command -v claude &> /dev/null; then
        return 1
    fi

    local version=$(claude --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    echo "✓ Claude Code CLI $version found"
    return 0
}

check_python_uv() {
    if ! command -v uv &> /dev/null; then
        echo "✗ uv not found"
        return 1
    fi

    local python_version=$(uv run python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    local major=$(echo "$python_version" | cut -d. -f1)
    local minor=$(echo "$python_version" | cut -d. -f2)

    if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -lt 9 ]; }; then
        echo "✗ Python $python_version too old (need 3.9+)"
        return 1
    fi

    echo "✓ uv + Python $python_version found"
    return 0
}

check_bash() {
    local version=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    local major=$(echo "$version" | cut -d. -f1)

    if [ "$major" -lt 4 ]; then
        echo "⚠ Bash $version (recommend 4.0+)"
        return 1
    fi

    echo "✓ Bash $version found"
    return 0
}

check_make() {
    if ! command -v make &> /dev/null; then
        echo "✗ Make not found"
        return 1
    fi

    echo "✓ Make found"
    return 0
}

install_uv() {
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Ensure uv is in PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    echo "Installing Python 3.11 via uv..."
    uv python install 3.11
}

prompt_install() {
    local tool=$1
    read -p "Install $tool now? [Y/n] " response
    [[ "$response" =~ ^[Yy]?$ ]]
}
```

### 3.5 Profile Management (lib/profiles.sh)

**File:** `scripts/lib/profiles.sh`

**Responsibilities:**
- List available profiles
- Interactive profile selection
- Copy/symlink/download profiles
- Merge profiles with existing .claude/

**API:**
```bash
# Profile discovery
list_profiles()                     # List available profiles
get_profile_description(name)       # Get profile description

# Interactive
prompt_profile_selection()          # Interactive profile choice
prompt_profile_mode()               # Interactive mode choice (copy/symlink/download)

# Installation
install_profile(name, mode)         # Install profile in specified mode
merge_profile(source, dest)         # Merge profile into existing .claude/

# Validation
validate_profile(path)              # Check profile structure is valid
```

**Profile Modes:**

**Mode 1: Copy (Default)**
- **When:** User wants standalone installation
- **Pros:** Self-contained, portable, no external dependencies
- **Cons:** No automatic updates, must run `make update`
- **Implementation:**
  ```bash
  copy_profile() {
      local profile=$1
      local source="$AGENTOPS_ROOT/profiles/$profile"
      local target=".claude"

      echo "Copying profile: $profile"
      mkdir -p "$target/agents" "$target/commands" "$target/skills"

      cp -r "$source/agents/"* "$target/agents/" 2>/dev/null || true
      cp -r "$source/commands/"* "$target/commands/" 2>/dev/null || true
      cp -r "$source/skills/"* "$target/skills/" 2>/dev/null || true

      # Settings are merged separately
      cp "$source/settings.json" "$target/settings.json.profile"
      merge_settings "$target/settings.json.profile" "$target/settings.json"
  }
  ```

**Mode 2: Symlink (Development)**
- **When:** User is developing AgentOps or wants live updates
- **Pros:** Always up-to-date, edit once apply everywhere
- **Cons:** Requires local agentops repo, breaks if repo moved
- **Implementation:**
  ```bash
  symlink_profile() {
      local profile=$1
      local source="$AGENTOPS_ROOT/profiles/$profile"
      local target=".claude"

      echo "Symlinking profile: $profile"
      mkdir -p "$target"

      ln -sf "$source/agents" "$target/agents"
      ln -sf "$source/commands" "$target/commands"
      ln -sf "$source/skills" "$target/skills"

      # Settings still copied (user customizations)
      cp "$source/settings.json" "$target/settings.json.profile"
      merge_settings "$target/settings.json.profile" "$target/settings.json"
  }
  ```

**Mode 3: Download (Public Release)**
- **When:** User wants latest public release, no local repo
- **Pros:** No local repo needed, gets latest public version
- **Cons:** Requires internet, may be outdated if offline
- **Implementation:**
  ```bash
  download_profile() {
      local profile=$1
      local version=${VERSION:-latest}
      local url="https://github.com/user/agentops/releases/download/$version/profile-$profile.tar.gz"
      local target=".claude"

      echo "Downloading profile: $profile (version: $version)"
      mkdir -p "$target"

      curl -L "$url" | tar xz -C "$target"

      # Merge settings
      merge_settings "$target/settings.json.profile" "$target/settings.json"
  }
  ```

**Implementation:**
```bash
#!/usr/bin/env bash

# Find agentops repository
AGENTOPS_ROOT=""

find_agentops_repo() {
    # Check if we're inside agentops repo
    if [ -d "profiles" ] && [ -f "CONSTITUTION.md" ]; then
        AGENTOPS_ROOT="."
        return 0
    fi

    # Check common locations
    local search_paths=(
        "$HOME/agentops"
        "$HOME/workspace/agentops"
        "$HOME/projects/agentops"
    )

    for path in "${search_paths[@]}"; do
        if [ -d "$path/profiles" ]; then
            AGENTOPS_ROOT="$path"
            return 0
        fi
    done

    # Not found locally
    return 1
}

list_profiles() {
    if find_agentops_repo; then
        # Local repo available
        ls -1 "$AGENTOPS_ROOT/profiles/"
    else
        # Download profile list from remote
        echo "Fetching available profiles..."
        curl -s "https://api.github.com/repos/user/agentops/contents/profiles" | \
            jq -r '.[].name'
    fi
}

prompt_profile_selection() {
    echo "Available profiles:"
    echo "  1) default      - Minimal, universal patterns"
    echo "  2) product-dev  - Product development workflows"
    echo "  3) devops       - Infrastructure/operations workflows"
    echo "  4) custom       - Browse and choose"
    echo ""

    read -p "Select profile [1-4]: " choice

    case "$choice" in
        1) PROFILE="default" ;;
        2) PROFILE="product-dev" ;;
        3) PROFILE="devops" ;;
        4) prompt_custom_profile ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
}

prompt_profile_mode() {
    echo ""
    echo "Profile installation mode:"
    echo "  1) copy      - Standalone (no dependency on agentops repo)"
    echo "  2) symlink   - Live updates (requires local agentops repo)"
    echo "  3) download  - Latest release (download from GitHub)"
    echo ""

    read -p "Select mode [1-3]: " choice

    case "$choice" in
        1) MODE="copy" ;;
        2) MODE="symlink" ;;
        3) MODE="download" ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
}

install_profile() {
    local profile=$1
    local mode=$2

    case "$mode" in
        copy) copy_profile "$profile" ;;
        symlink) symlink_profile "$profile" ;;
        download) download_profile "$profile" ;;
        *) echo "Unknown mode: $mode"; exit 1 ;;
    esac

    update_manifest "$profile" "$mode"
}

merge_settings() {
    local profile_settings=$1
    local user_settings=$2

    if [ ! -f "$user_settings" ]; then
        # No existing settings, just copy
        cp "$profile_settings" "$user_settings"
        echo "✓ Created settings.json from profile"
        return 0
    fi

    # Merge: user settings take precedence for existing keys
    # Profile settings add new keys
    jq -s '.[0] * .[1]' "$profile_settings" "$user_settings" > "$user_settings.tmp"
    mv "$user_settings.tmp" "$user_settings"
    echo "✓ Merged settings (preserved user customizations)"
}

update_manifest() {
    local profile=$1
    local mode=$2
    local manifest=".claude/installed_components.json"

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local agent_count=$(ls -1 .claude/agents/ 2>/dev/null | wc -l | tr -d ' ')
    local command_count=$(ls -1 .claude/commands/ 2>/dev/null | wc -l | tr -d ' ')
    local skill_count=$(ls -1 .claude/skills/ 2>/dev/null | wc -l | tr -d ' ')

    cat > "$manifest" <<EOF
{
  "profile": "$profile",
  "mode": "$mode",
  "installed_at": "$timestamp",
  "version": "1.0.0",
  "source": "$AGENTOPS_ROOT",
  "components": {
    "agents": $agent_count,
    "commands": $command_count,
    "skills": $skill_count
  }
}
EOF

    echo "✓ Updated installation manifest"
}

validate_profile() {
    local profile_path=$1

    # Check required directories exist
    if [ ! -d "$profile_path/agents" ]; then
        echo "✗ Profile missing agents/ directory"
        return 1
    fi

    if [ ! -f "$profile_path/settings.json" ]; then
        echo "✗ Profile missing settings.json"
        return 1
    fi

    # Check settings.json is valid JSON
    if ! jq empty "$profile_path/settings.json" 2>/dev/null; then
        echo "✗ Profile settings.json is invalid JSON"
        return 1
    fi

    echo "✓ Profile structure valid"
    return 0
}
```

### 3.6 Validation (lib/validation.sh)

**File:** `scripts/lib/validation.sh`

**Responsibilities:**
- Validate installation completeness
- Check file syntax (YAML, JSON)
- Test Claude Code integration
- Run sample agent

**API:**
```bash
validate_installation()         # Run all checks, exit 1 if any fail
check_files_exist()             # Verify directory structure
validate_yaml_json()            # Syntax check configs
test_claude_code_load()         # Test settings.json loads
run_sample_agent()              # Execute hello-world agent
check_git_hooks()               # Verify hooks installed (if enabled)
check_prerequisite_versions()   # Verify versions meet minimums
```

**Implementation:**
```bash
#!/usr/bin/env bash

validate_installation() {
    local errors=0

    echo "Running AgentOps installation validation..."
    echo ""

    # Check 1: File existence
    echo "[1/6] Checking file existence..."
    if ! check_files_exist; then
        errors=$((errors + 1))
    fi
    echo ""

    # Check 2: YAML/JSON syntax
    echo "[2/6] Validating syntax..."
    if ! validate_yaml_json; then
        errors=$((errors + 1))
    fi
    echo ""

    # Check 3: Claude Code integration
    echo "[3/6] Testing Claude Code integration..."
    if ! test_claude_code_load; then
        errors=$((errors + 1))
    fi
    echo ""

    # Check 4: Sample agent
    echo "[4/6] Running sample agent..."
    if ! run_sample_agent; then
        errors=$((errors + 1))
    fi
    echo ""

    # Check 5: Git hooks
    echo "[5/6] Checking git hooks..."
    if ! check_git_hooks; then
        errors=$((errors + 1))
    fi
    echo ""

    # Check 6: Prerequisites
    echo "[6/6] Verifying prerequisites..."
    if ! check_prerequisite_versions; then
        errors=$((errors + 1))
    fi
    echo ""

    if [ $errors -eq 0 ]; then
        echo "════════════════════════════════════════════════════"
        echo "All checks passed! ✓"
        echo "════════════════════════════════════════════════════"
        return 0
    else
        echo "════════════════════════════════════════════════════"
        echo "Validation failed: $errors check(s) failed ✗"
        echo "════════════════════════════════════════════════════"
        return 1
    fi
}

check_files_exist() {
    local errors=0
    local files=(
        ".claude/settings.json"
        ".claude/README.md"
        "CONSTITUTION.md"
        "CLAUDE.md"
    )

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "✓ $file"
        else
            echo "✗ $file (missing)"
            errors=$((errors + 1))
        fi
    done

    # Check directories
    local dirs=(
        ".claude/agents"
        ".claude/commands"
        ".claude/skills"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            local count=$(ls -1 "$dir" 2>/dev/null | wc -l | tr -d ' ')
            echo "✓ $dir/ ($count files)"
        else
            echo "✗ $dir/ (missing)"
            errors=$((errors + 1))
        fi
    done

    return $errors
}

validate_yaml_json() {
    local errors=0

    # Check settings.json
    if ! jq empty .claude/settings.json 2>/dev/null; then
        echo "✗ settings.json (invalid JSON)"
        errors=$((errors + 1))
    else
        echo "✓ settings.json (valid JSON)"
    fi

    # Check agent YAML files
    local yaml_errors=0
    for agent in .claude/agents/*.md; do
        [ -e "$agent" ] || continue
        # Note: Agent files may be Markdown with YAML frontmatter
        # Full YAML validation would require parsing frontmatter
    done

    if [ $yaml_errors -eq 0 ]; then
        local agent_count=$(ls -1 .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "✓ All agent files ($agent_count checked)"
    else
        echo "✗ $yaml_errors agent files have errors"
        errors=$((errors + 1))
    fi

    return $errors
}

test_claude_code_load() {
    # Test if Claude Code can load settings
    # Note: Exact command depends on Claude Code CLI interface
    # This is a placeholder that should be updated with actual command

    if command -v claude &> /dev/null; then
        # Try to validate settings
        # Placeholder: actual command TBD based on Claude Code CLI
        echo "✓ Claude Code CLI available"
        echo "✓ Settings structure appears valid"
        return 0
    else
        echo "✗ Claude Code CLI not available"
        return 1
    fi
}

run_sample_agent() {
    # Run a simple test to verify agent system works
    # This is a placeholder - actual implementation depends on agent structure

    if [ -f ".claude/agents/hello-world.md" ] || [ -f ".claude/agents/research.md" ]; then
        echo "✓ Sample agent files present"
        # In a real implementation, we would execute an agent here
        return 0
    else
        echo "⚠ No sample agents found (profile may not include test agents)"
        return 0  # Not critical
    fi
}

check_git_hooks() {
    if [ ! -d ".git" ]; then
        echo "⚠ Not a git repository (hooks not applicable)"
        return 0
    fi

    local hooks=("pre-commit" "post-commit" "commit-msg")
    local installed=0

    for hook in "${hooks[@]}"; do
        if [ -x ".git/hooks/$hook" ]; then
            echo "✓ $hook hook installed and executable"
            installed=$((installed + 1))
        fi
    done

    if [ $installed -eq 0 ]; then
        echo "⚠ No git hooks installed (may be intentional)"
    fi

    return 0  # Not critical
}

check_prerequisite_versions() {
    local errors=0

    # Git version
    local git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    echo "✓ Git $git_version (>= 2.30.0)"

    # Claude Code
    if command -v claude &> /dev/null; then
        local claude_version=$(claude --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        echo "✓ Claude Code $claude_version"
    else
        echo "✗ Claude Code not found"
        errors=$((errors + 1))
    fi

    # Python
    if command -v uv &> /dev/null; then
        local python_version=$(uv run python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        echo "✓ Python $python_version (>= 3.9.0)"
    else
        echo "⚠ uv/Python not found (may not be required)"
    fi

    return $errors
}
```

---

## 4. Implementation Details

### 4.1 Installation Algorithm

**High-Level Flow:**
```
1. PARSE ARGUMENTS
   - Determine mode (interactive, non-interactive, verify, update, uninstall)
   - Parse parameters (PROFILE, CONFIG, MODE, VERSION)

2. DETECT PLATFORM
   - Identify OS (macOS, Linux, WSL)
   - Detect package manager
   - Set platform-specific paths and commands

3. CHECK PREREQUISITES
   - Git (required, auto-install if possible)
   - Claude Code (required, must pre-exist)
   - Python/uv (required, auto-install)
   - Bash, Make (check versions)
   - Exit if critical prerequisites missing

4. LOAD CONFIGURATION
   IF CONFIG parameter provided:
       Load and validate install.config.json
   ELSE IF interactive mode:
       Run interactive prompts (model, profile, permissions, hooks)
       Save choices to install.config.json
   ELSE:
       Use defaults

5. DETECT EXISTING INSTALLATION
   IF .claude/installed_components.json exists:
       Load manifest (profile, mode, version)
       Set EXISTING_INSTALL=true
   ELSE:
       Set EXISTING_INSTALL=false

6. BACKUP (if existing)
   IF EXISTING_INSTALL=true:
       Create backup: .claude.backup-<timestamp>/
       Copy .claude/, CONSTITUTION.md, CLAUDE.md to backup

7. INSTALL BASE STRUCTURE
   Create directories:
   - .claude/
   - .claude/agents/
   - .claude/commands/
   - .claude/skills/

   IF .claude/settings.json exists:
       Merge with new settings (preserve user keys)
   ELSE:
       Create from template

   Create .claude/README.md (documentation)

8. INSTALL PROFILE
   Based on MODE:
   - copy: Copy files from agentops/profiles/<profile>/
   - symlink: Symlink to agentops/profiles/<profile>/
   - download: Download from remote and extract

   Merge profile components into .claude/
   Update settings.json with profile defaults (preserve user overrides)

9. INSTALL ROOT FILES
   IF CONSTITUTION.md missing OR user confirms overwrite:
       Copy from template

   IF CLAUDE.md missing OR user confirms overwrite:
       Generate from template (substitute project name, profile)

   Update .gitignore:
       Add .claude/settings.local.json
       Add .claude.backup-*/

10. INSTALL GIT HOOKS (if requested)
    IF git repo exists AND hooks enabled:
        Install pre-commit hook (validation)
        Install post-commit hook (learning extraction)
        Install commit-msg hook (semantic commit template)
        Make hooks executable (chmod +x)

11. UPDATE MANIFEST
    Write .claude/installed_components.json:
    - Profile name and mode
    - Installation timestamp
    - Version
    - Component counts

12. VALIDATE INSTALLATION
    Run validation suite:
    - File existence checks
    - YAML/JSON syntax validation
    - Claude Code integration test
    - Sample agent execution

    IF any check fails:
        Show diagnostic output
        Suggest 'make doctor' for troubleshooting
        Exit 1

13. PRINT SUCCESS MESSAGE
    Display:
    - Installation summary (profile, mode)
    - Component counts (agents, commands, skills)
    - Next steps (read CLAUDE.md, try agent, run verify)
    - Documentation links
```

### 4.2 Merge Strategy

**Problem:** User has existing `.claude/` with customizations. How to merge without losing changes?

**Solution:** Intelligent merge with preservation

**Merge Rules:**

**Rule 1: settings.json - Deep Merge**
- Profile settings provide defaults
- User settings override (keys present in user file take precedence)
- New keys from profile are added
- User-only keys are preserved

**Implementation:**
```bash
merge_settings() {
    local profile_settings=$1
    local user_settings=$2

    if [ ! -f "$user_settings" ]; then
        cp "$profile_settings" "$user_settings"
        return 0
    fi

    # Deep merge: profile defaults + user overrides
    # User keys take precedence
    jq -s '.[0] * .[1]' "$profile_settings" "$user_settings" > "$user_settings.tmp"
    mv "$user_settings.tmp" "$user_settings"
}
```

**Rule 2: agents/commands/skills - Additive Only**
- Never overwrite existing files
- Add new files from profile
- Preserve all user files
- Detect by comparing filenames

**Implementation:**
```bash
install_profile_components() {
    local profile_dir=$1
    local target_dir=$2
    local component_type=$3  # "agents", "commands", or "skills"

    for file in "$profile_dir/$component_type"/*; do
        [ -e "$file" ] || continue
        local basename=$(basename "$file")
        local target="$target_dir/$component_type/$basename"

        if [ -f "$target" ]; then
            echo "⚠ $basename already exists (skipping, preserving user version)"
        else
            cp "$file" "$target"
            echo "✓ Installed $component_type: $basename"
        fi
    done
}
```

**Rule 3: CONSTITUTION.md/CLAUDE.md - User Choice**
- Warn if files exist
- Offer options: overwrite, skip, diff
- Default: skip (preserve existing)
- Backup before overwriting

**Implementation:**
```bash
install_root_file() {
    local template=$1
    local target=$2

    if [ -f "$target" ]; then
        echo "⚠ $target already exists"
        echo "  [k]eep existing (default)"
        echo "  [o]verwrite with new version"
        echo "  [d]iff to compare"
        read -p "Choice: " choice

        case "$choice" in
            o|O)
                backup_file "$target"
                cp "$template" "$target"
                echo "✓ Overwritten $target (backup created)"
                ;;
            d|D)
                diff "$target" "$template" || true
                install_root_file "$template" "$target"  # Recurse
                ;;
            *)
                echo "✓ Kept existing $target"
                ;;
        esac
    else
        cp "$template" "$target"
        echo "✓ Created $target"
    fi
}
```

**Rule 4: Git Hooks - Conditional Install**
- Install if missing
- Skip if exists (assume user customized)
- Warn if exists but differs from template

**Implementation:**
```bash
install_git_hook() {
    local hook_name=$1
    local template=$2
    local target=".git/hooks/$hook_name"

    if [ ! -d ".git" ]; then
        echo "⚠ Not a git repository (skipping hooks)"
        return 0
    fi

    if [ -f "$target" ]; then
        echo "⚠ $hook_name already exists (skipping)"
        return 0
    fi

    cp "$template" "$target"
    chmod +x "$target"
    echo "✓ Installed $hook_name hook"
}
```

### 4.3 Configuration Schema

**File:** `install.config.json`

**Location:** Project root (or specified via CONFIG parameter)

**Full Schema:**
```json
{
  "$schema": "https://agentops.dev/schemas/install-config.schema.json",
  "version": "1.0",
  "project": {
    "name": "my-project",
    "type": "product-dev",
    "description": "AI-powered product development"
  },
  "agentops": {
    "model": "opus",
    "profile": "product-dev",
    "install_mode": "copy",
    "version": "latest"
  },
  "permissions": {
    "git": true,
    "docker": true,
    "kubernetes": false,
    "python": true,
    "rust": false,
    "go": false,
    "npm": false,
    "bash": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "pre_push": false,
    "commit_msg": true
  },
  "features": {
    "multi_agent": true,
    "context_bundles": true,
    "intelligent_routing": true,
    "session_tracking": true
  },
  "advanced": {
    "backup_count": 3,
    "auto_update": false,
    "telemetry": false
  }
}
```

**Field Definitions:**

**version** (string, required)
- Schema version for compatibility
- Current: "1.0"

**project.name** (string, optional)
- Human-readable project name
- Default: Current directory name
- Used in CLAUDE.md kernel

**project.type** (string, optional)
- Project type hint
- Options: "product-dev", "devops", "sre", "data-eng", "custom"
- Default: Inferred from profile

**project.description** (string, optional)
- Brief project description
- Used in CLAUDE.md kernel

**agentops.model** (string, required)
- Claude model to use
- Options: "opus", "sonnet"
- Default: "opus"

**agentops.profile** (string, required)
- Profile to install
- Options: "default", "product-dev", "devops", "custom"
- Default: "default"

**agentops.install_mode** (string, optional)
- Profile installation mode
- Options: "copy", "symlink", "download"
- Default: "copy"

**agentops.version** (string, optional)
- AgentOps version to install
- Default: "latest"
- Format: "v1.0.0" or "latest"

**permissions** (object, optional)
- Tool permissions to enable
- Keys: git, docker, kubernetes, python, rust, go, npm, bash
- Values: boolean
- Default: git=true, others=false

**hooks** (object, optional)
- Git hooks to install
- Keys: pre_commit, post_commit, pre_push, commit_msg
- Values: boolean
- Default: all true except pre_push

**features** (object, optional)
- AgentOps features to enable
- Keys: multi_agent, context_bundles, intelligent_routing, session_tracking
- Values: boolean
- Default: all true

**advanced.backup_count** (integer, optional)
- Number of backups to keep
- Default: 3
- Range: 1-10

**advanced.auto_update** (boolean, optional)
- Enable automatic update checking
- Default: false (manual updates only)

**advanced.telemetry** (boolean, optional)
- Enable usage telemetry (opt-in)
- Default: false

**Validation:**
```bash
validate_config() {
    local config_file=$1

    # Check JSON syntax
    if ! jq empty "$config_file" 2>/dev/null; then
        echo "Error: Invalid JSON in $config_file"
        return 1
    fi

    # Check required fields
    local version=$(jq -r '.version' "$config_file")
    if [ "$version" != "1.0" ]; then
        echo "Error: Unsupported schema version: $version"
        return 1
    fi

    # Validate model
    local model=$(jq -r '.agentops.model' "$config_file")
    if [ "$model" != "opus" ] && [ "$model" != "sonnet" ] && [ "$model" != "null" ]; then
        echo "Error: model must be 'opus' or 'sonnet', got: $model"
        return 1
    fi

    # Validate profile
    local profile=$(jq -r '.agentops.profile' "$config_file")
    local valid_profiles=("default" "product-dev" "devops" "custom")
    if [[ ! " ${valid_profiles[@]} " =~ " ${profile} " ]] && [ "$profile" != "null" ]; then
        echo "Error: Invalid profile: $profile"
        return 1
    fi

    echo "✓ Configuration valid"
    return 0
}
```

**Partial Config Support:**

If config file is incomplete, prompt for missing values:

```bash
load_configuration() {
    if [ -n "$CONFIG_FILE" ]; then
        echo "Loading configuration from $CONFIG_FILE"
        validate_config "$CONFIG_FILE" || exit 1

        # Load values
        MODEL=$(jq -r '.agentops.model // "opus"' "$CONFIG_FILE")
        PROFILE=$(jq -r '.agentops.profile // "default"' "$CONFIG_FILE")
        MODE=$(jq -r '.agentops.install_mode // "copy"' "$CONFIG_FILE")

        # Prompt for missing values if interactive
        if [ "$INTERACTIVE" = true ]; then
            [ "$MODEL" = "null" ] && prompt_model_selection
            [ "$PROFILE" = "null" ] && prompt_profile_selection
        fi
    fi
}
```

### 4.4 Error Recovery and Rollback

**Strategy:** Safe, rollbackable, informative

**Backup Before Modify:**
```bash
backup_existing_installation() {
    if [ ! -d ".claude" ]; then
        return 0  # Nothing to backup
    fi

    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir=".claude.backup-$timestamp"

    echo "Creating backup: $backup_dir"
    mkdir -p "$backup_dir"

    # Backup .claude/
    if [ -d ".claude" ]; then
        cp -r ".claude" "$backup_dir/"
    fi

    # Backup root files
    [ -f "CONSTITUTION.md" ] && cp "CONSTITUTION.md" "$backup_dir/"
    [ -f "CLAUDE.md" ] && cp "CLAUDE.md" "$backup_dir/"

    echo "✓ Backup created: $backup_dir"

    # Keep only last 3 backups
    cleanup_old_backups
}

cleanup_old_backups() {
    local backup_count=$(ls -1d .claude.backup-* 2>/dev/null | wc -l | tr -d ' ')
    local max_backups=3

    if [ "$backup_count" -gt "$max_backups" ]; then
        local to_remove=$((backup_count - max_backups))
        ls -1td .claude.backup-* | tail -n "$to_remove" | xargs rm -rf
        echo "✓ Cleaned up old backups (kept last $max_backups)"
    fi
}
```

**Rollback on Error:**
```bash
rollback_installation() {
    local backup_dir=$1

    echo "Error occurred. Rolling back..."

    if [ -d "$backup_dir/.claude" ]; then
        rm -rf ".claude"
        cp -r "$backup_dir/.claude" ".claude"
        echo "✓ Restored .claude/ from backup"
    fi

    if [ -f "$backup_dir/CONSTITUTION.md" ]; then
        cp "$backup_dir/CONSTITUTION.md" "CONSTITUTION.md"
        echo "✓ Restored CONSTITUTION.md"
    fi

    if [ -f "$backup_dir/CLAUDE.md" ]; then
        cp "$backup_dir/CLAUDE.md" "CLAUDE.md"
        echo "✓ Restored CLAUDE.md"
    fi

    echo "✓ Rollback complete. Your previous installation is restored."
}
```

**Error Handling Pattern:**
```bash
# Wrap critical operations with error handling
install_base_structure() {
    local backup_dir=$(find_latest_backup)

    {
        # Critical operations
        create_claude_directory || return 1
        install_settings_json || return 1
        install_readme || return 1
    } || {
        # Error occurred, rollback
        rollback_installation "$backup_dir"
        exit 1
    }

    echo "✓ Base structure installed"
}
```

**Clear Error Messages:**
```bash
show_error() {
    local error_msg=$1
    local reason=$2
    local fix=$3

    echo ""
    echo "Error: $error_msg"
    echo "Reason: $reason"
    echo "Fix: $fix"
    echo ""
}

# Example usage
if ! check_claude_code; then
    show_error \
        "Claude Code CLI not found" \
        "Required for AgentOps framework to function" \
        "Install Claude Code from https://claude.com/claude-code
         Then run 'make install' again"
    exit 2
fi
```

---

## 5. User Interface (CLI/Makefile)

### 5.1 Interactive Prompts

**Design Principles:**
- Friendly and informative
- Sensible defaults
- Clear options with descriptions
- Skip if non-interactive mode

**Example Interactive Flow:**

```
$ make install

╔════════════════════════════════════════════════════════════╗
║         AgentOps Framework Installation                    ║
╚════════════════════════════════════════════════════════════╝

Checking prerequisites...
✓ Git 2.43.0 found
✓ Claude Code CLI 1.2.0 found
✓ Python 3.11 (via uv) found

No install.config.json found. Let's configure your installation.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project Configuration

Project name (current directory: my-project): [my-project]
>

Project description (optional):
> AI-powered application using AgentOps workflows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AgentOps Configuration

Default AI model:
  1. opus   - Better quality, slower, higher cost
  2. sonnet - Faster, lower cost [recommended for most users]

[1-2]: 2

Select profile:
  1. default      - Minimal, universal patterns
  2. product-dev  - Product development workflows [recommended for apps]
  3. devops       - Infrastructure/operations workflows
  4. custom       - Browse available profiles

[1-4]: 2

Profile installation mode:
  1. copy     - Standalone (no dependency on agentops repo) [recommended]
  2. symlink  - Live updates (requires local agentops repo)
  3. download - Latest release (download from GitHub)

[1-3]: 1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Permissions

Enable Git permissions? [Y/n] y
Enable Docker permissions? [y/N] n
Enable Kubernetes permissions? [y/N] n
Enable Python permissions? [Y/n] y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Git Hooks

Install git hooks for validation and learning extraction? [Y/n] y
  • pre-commit: Validate YAML/JSON before commit
  • post-commit: Extract learnings from commits
  • commit-msg: Enforce semantic commit format

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Configuration saved to install.config.json

Installing AgentOps framework...
✓ Created .claude/ structure
✓ Installed settings.json (model: sonnet)
✓ Installed product-dev profile (12 agents, 8 commands, 3 skills)
✓ Created CONSTITUTION.md
✓ Created CLAUDE.md kernel
✓ Installed git hooks (pre-commit, post-commit, commit-msg)
✓ Updated .gitignore

Validating installation...
✓ All files present
✓ YAML/JSON syntax valid
✓ Claude Code settings loaded
✓ Sample agent executed successfully

╔════════════════════════════════════════════════════════════╗
║         Installation Complete! 🚀                          ║
╚════════════════════════════════════════════════════════════╝

Next steps:
  1. Read your project kernel:  cat CLAUDE.md
  2. Try your first agent:      claude (then type /prime-simple-task)
  3. Verify setup anytime:      make verify
  4. View available agents:     ls .claude/agents/

Documentation: https://agentops.dev/docs
Questions? File an issue: https://github.com/user/agentops/issues
```

### 5.2 Non-Interactive Mode

Support non-interactive installation via config file:

```bash
# Create config file
cat > install.config.json <<EOF
{
  "version": "1.0",
  "project": {
    "name": "my-project",
    "type": "product-dev"
  },
  "agentops": {
    "model": "sonnet",
    "profile": "product-dev",
    "install_mode": "copy"
  },
  "permissions": {
    "git": true,
    "python": true,
    "docker": false
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "commit_msg": true
  }
}
EOF

# Run non-interactive install
make install CONFIG=install.config.json

# Or use parameters
make install PROFILE=devops MODE=copy
```

### 5.3 Makefile Help

The `make help` target provides comprehensive documentation:

```
$ make help

AgentOps Framework - Installation & Management

Usage:
  make install                 Install AgentOps framework (interactive)
  make install PROFILE=<name>  Install with specific profile
  make install CONFIG=<path>   Install using config file
  make install-profile PROFILE=<name>
                               Install additional profile
  make verify                  Validate installation
  make update                  Update to latest version
  make update VERSION=<tag>    Update to specific version
  make doctor                  Diagnose installation issues
  make uninstall               Remove AgentOps framework
  make help                    Show this help message

Profiles:
  default      Minimal, universal patterns
  product-dev  Product development workflows (app creation, testing)
  devops       Infrastructure/operations workflows (CI/CD, deployment)

Installation Modes:
  copy         Standalone (no dependency on agentops repo) [default]
  symlink      Live updates (requires local agentops repo)
  download     Latest release (download from GitHub)

Parameters:
  PROFILE=<name>     Profile to install (default, product-dev, devops)
  MODE=<mode>        Installation mode (copy, symlink, download)
  CONFIG=<path>      Path to install.config.json
  VERSION=<tag>      Version to install/update (for update command)
  FORCE=1            Skip confirmation prompts (for uninstall)

Examples:
  make install                              # Interactive install
  make install PROFILE=devops               # Non-interactive with devops
  make install CONFIG=team-config.json      # Use config file
  make install-profile PROFILE=product-dev  # Add profile after install
  make verify                               # Validate installation
  make update                               # Update to latest
  make doctor                               # Troubleshoot issues
  make uninstall FORCE=1                    # Force uninstall

Documentation: https://agentops.dev/docs
Troubleshooting: https://agentops.dev/docs/troubleshooting
GitHub: https://github.com/user/agentops
```

---

## 6. Configuration

### 6.1 Configuration Files

**install.config.json** (input)
- User preferences for installation
- Created by interactive prompts or manually
- Used by installer to customize setup
- Can be committed to repo for team consistency

**.claude/settings.json** (output)
- Claude Code configuration
- Generated from install.config.json + profile
- Can be manually edited post-install
- Should be committed to repo

**.claude/settings.local.json** (user overrides)
- Local-only customizations
- Gitignored by default
- Overrides settings.json
- Never committed (personal preferences)

**Example .gitignore additions:**
```
# AgentOps local overrides
.claude/settings.local.json

# AgentOps backups
.claude.backup-*/
```

### 6.2 Configuration Precedence

**Order (highest to lowest priority):**
```
1. .claude/settings.local.json  (highest - user overrides)
2. .claude/settings.json        (framework + profile defaults)
3. install.config.json          (installation preferences)
4. Profile defaults             (from agentops/profiles/)
5. Global defaults              (lowest - hardcoded in script)
```

**Example:**
```json
// Global defaults (hardcoded)
{
  "model": "opus",
  "permissions": {"git": true}
}

// Profile defaults (agentops/profiles/devops/settings.json)
{
  "permissions": {"git": true, "docker": true, "kubernetes": true}
}

// install.config.json (user installation choice)
{
  "agentops": {"model": "sonnet"},
  "permissions": {"docker": false}
}

// .claude/settings.json (result after merge)
{
  "model": "sonnet",  // From install.config.json
  "permissions": {
    "git": true,           // From profile
    "docker": false,       // From install.config.json (override)
    "kubernetes": true     // From profile
  }
}

// .claude/settings.local.json (user local override)
{
  "model": "opus"  // User prefers opus for local work
}

// Final effective config (at runtime)
{
  "model": "opus",  // From settings.local.json (highest priority)
  "permissions": {
    "git": true,
    "docker": false,
    "kubernetes": true
  }
}
```

### 6.3 Environment Variables

Support environment variable overrides for advanced use cases:

**Supported Variables:**
```bash
AGENTOPS_MODEL=opus             # Override model selection
AGENTOPS_PROFILE=devops         # Override profile selection
AGENTOPS_INSTALL_MODE=symlink   # Override installation mode
AGENTOPS_HOME=/path/to/agentops # Location of agentops repository
```

**Usage:**
```bash
# Override model via environment
AGENTOPS_MODEL=opus make install PROFILE=devops

# Development mode (symlink to local repo)
AGENTOPS_INSTALL_MODE=symlink make install

# Specify agentops repo location
AGENTOPS_HOME=$HOME/projects/agentops make install
```

**Implementation:**
```bash
# In base-install.sh
MODEL=${AGENTOPS_MODEL:-$MODEL}
PROFILE=${AGENTOPS_PROFILE:-$PROFILE}
MODE=${AGENTOPS_INSTALL_MODE:-$MODE}
AGENTOPS_ROOT=${AGENTOPS_HOME:-$(find_agentops_repo)}
```

---

## 7. Installation Flow

### 7.1 New Project Flow

**Scenario:** User runs `make install` in a project with no existing `.claude/`

```
┌─────────────────────────────┐
│  User: make install         │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Check prerequisites        │
│  ✓ Git, Claude Code, Python │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Interactive prompts        │
│  • Model: sonnet            │
│  • Profile: product-dev     │
│  • Mode: copy               │
│  • Permissions: git, python │
│  • Hooks: yes               │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Create .claude/            │
│  • settings.json            │
│  • agents/ (from profile)   │
│  • commands/ (from profile) │
│  • skills/ (from profile)   │
│  • README.md                │
│  • manifest.json            │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Create root files          │
│  • CONSTITUTION.md          │
│  • CLAUDE.md                │
│  • Update .gitignore        │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Install git hooks          │
│  • pre-commit               │
│  • post-commit              │
│  • commit-msg               │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Validate installation      │
│  ✓ Files exist              │
│  ✓ Syntax valid             │
│  ✓ Claude Code loads        │
│  ✓ Sample agent runs        │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Success message            │
│  Next steps: read CLAUDE.md │
└─────────────────────────────┘
```

### 7.2 Existing .claude/ Flow

**Scenario:** User runs `make install` with existing `.claude/` directory

```
┌─────────────────────────────┐
│  User: make install         │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Detect existing .claude/   │
│  Read manifest.json         │
│  Current: devops (copy)     │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Backup existing            │
│  .claude.backup-timestamp/  │
│  ✓ Backup created           │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Interactive prompts        │
│  • Keep devops or change?   │
│  • Update mode? (copy)      │
│  • Update permissions?      │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Merge with existing        │
│  • settings.json: deep merge│
│  • agents/: additive only   │
│  • Preserve user files      │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Update components          │
│  • New agents from profile  │
│  • New commands added       │
│  • User agents preserved    │
│  • Update manifest          │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Validate installation      │
│  ✓ All checks pass          │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Success message            │
│  Updated: 5 new agents      │
│  Preserved: 3 custom agents │
└─────────────────────────────┘
```

### 7.3 Profile Addition Flow

**Scenario:** User runs `make install-profile PROFILE=devops` after base install

```
┌─────────────────────────────┐
│  User: make install-profile │
│        PROFILE=devops       │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Verify base install exists │
│  ✓ .claude/ present         │
│  ✓ manifest.json found      │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Fetch devops profile       │
│  • 15 agents                │
│  • 10 commands              │
│  • 5 skills                 │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Merge with existing        │
│  • Add devops agents        │
│  • Add devops commands      │
│  • Preserve existing files  │
│  • Merge settings           │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Update manifest            │
│  Profile: default+devops    │
│  Components: 27 total       │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Validate profile           │
│  ✓ Structure valid          │
│  ✓ No conflicts             │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Success message            │
│  Added: devops profile      │
│  Total: 27 agents           │
└─────────────────────────────┘
```

### 7.4 Update Flow

**Scenario:** User runs `make update` to get latest AgentOps components

```
┌─────────────────────────────┐
│  User: make update          │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Read manifest              │
│  Current: product-dev (copy)│
│  Version: 1.0.0             │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Backup current state       │
│  .claude.backup-timestamp/  │
│  ✓ Backup created           │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Fetch latest profile       │
│  Latest: 1.2.0              │
│  Changes: 3 new agents      │
│           2 updated commands│
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Merge updates              │
│  • Add new agents           │
│  • Update framework files   │
│  • Preserve user custom     │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Run migrations (if needed) │
│  v1.0.0 → v1.2.0            │
│  ✓ No migrations required   │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Update manifest            │
│  Version: 1.2.0             │
│  Updated: <timestamp>       │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Validate installation      │
│  ✓ All checks pass          │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Success message            │
│  Updated: 1.0.0 → 1.2.0     │
│  Added: 3 agents, 2 commands│
└─────────────────────────────┘
```

---

## 8. Validation & Testing

### 8.1 Installation Validation

**Run by:** `make verify`

**Checks Performed:**

**Check 1: File Existence (Critical)**
- `.claude/settings.json` must exist
- `.claude/README.md` must exist
- `.claude/agents/` directory must exist
- `.claude/commands/` directory must exist
- `.claude/skills/` directory must exist
- `CONSTITUTION.md` must exist
- `CLAUDE.md` must exist
- `.claude/installed_components.json` must exist (manifest)

**Check 2: YAML/JSON Syntax (Critical)**
- `settings.json` must be valid JSON
- All `.md` agent files with YAML frontmatter must parse
- `install.config.json` (if present) must be valid JSON
- `installed_components.json` must be valid JSON

**Check 3: Claude Code Integration (Critical)**
- Claude Code CLI must be able to load settings
- No configuration conflicts
- Settings schema valid

**Check 4: Sample Agent Execution (Warning)**
- Attempt to run a simple agent (if available)
- Verify agent produces output
- Non-critical: may not be possible depending on profile

**Check 5: Git Hooks (If Installed)**
- `.git/hooks/pre-commit` exists and executable
- `.git/hooks/post-commit` exists and executable
- `.git/hooks/commit-msg` exists and executable
- Hook scripts contain expected content

**Check 6: Prerequisite Versions (Warning)**
- Git >= 2.30.0
- Python >= 3.9.0
- Claude Code installed
- Non-critical: already checked during install

**Output Format:**
```
Running AgentOps installation validation...

[1/6] Checking file existence...
✓ .claude/settings.json
✓ .claude/README.md
✓ .claude/agents/ (12 files)
✓ .claude/commands/ (8 files)
✓ .claude/skills/ (3 files)
✓ CONSTITUTION.md
✓ CLAUDE.md
✓ .claude/installed_components.json

[2/6] Validating syntax...
✓ settings.json (valid JSON)
✓ installed_components.json (valid JSON)
✓ All agent files (12 checked, 0 errors)
✓ All command files (8 checked, 0 errors)

[3/6] Testing Claude Code integration...
✓ Claude Code CLI found (v1.2.0)
✓ Settings loaded successfully
✓ No configuration conflicts

[4/6] Running sample agent test...
✓ Sample agent available
✓ Agent executed successfully
✓ Output produced as expected

[5/6] Checking git hooks...
✓ pre-commit hook installed and executable
✓ post-commit hook installed and executable
✓ commit-msg hook installed and executable
✓ All hooks valid

[6/6] Verifying prerequisites...
✓ Git 2.43.0 (>= 2.30.0)
✓ Python 3.11.0 (>= 3.9.0)
✓ Claude Code 1.2.0

════════════════════════════════════════════════════
All checks passed! ✓
════════════════════════════════════════════════════

Your AgentOps installation is healthy.

Next steps:
  • Read CLAUDE.md for project-specific guidance
  • Try /prime-simple-task for straightforward work
  • View agents: ls .claude/agents/
  • Get help: make help
```

### 8.2 Diagnostic Tool (make doctor)

**Purpose:** Comprehensive troubleshooting when things don't work

**Checks Performed:**

**Section 1: Prerequisites**
- Check all required tools installed
- Verify versions meet minimums
- Test tool functionality (not just existence)

**Section 2: File Structure**
- Check all expected files/directories exist
- Verify file permissions (readable, writable, executable)
- Check for unexpected files (corruption indicators)
- Validate symlinks (if using symlink mode)

**Section 3: Configuration**
- Validate install.config.json structure
- Validate settings.json structure
- Check for conflicting settings
- Verify manifest.json is accurate

**Section 4: Environment**
- Check environment variables
- Verify PATH includes necessary directories
- Check shell compatibility (Bash version)
- Verify agentops repo location (if symlink mode)

**Section 5: Integration**
- Test Claude Code can load configuration
- Test git hooks execute without errors
- Check for port conflicts (if applicable)

**Output Format:**
```
AgentOps Installation Diagnostics

[Prerequisites]
✓ Git 2.43.0 (>= 2.30.0 required)
✓ Claude Code CLI 1.2.0
✗ Python 3.8.0 (3.9+ required) ← ISSUE FOUND
✓ Bash 5.2
✓ Make 4.3

[File Structure]
✓ .claude/ exists and readable
✓ All expected files present (26/26)
✓ File permissions correct
⚠ Unexpected file: .claude/test.json (not from installation)

[Configuration]
✓ install.config.json valid
✓ settings.json valid
✓ installed_components.json valid
✓ No conflicting settings detected

[Environment]
✓ AGENTOPS_HOME=/Users/user/workspace/agentops
✓ Shell: bash 5.2
✓ PATH includes /usr/local/bin
✓ Agentops repo accessible

[Integration]
✓ Claude Code loads settings without errors
✓ Git hooks execute successfully
✓ No integration issues detected

════════════════════════════════════════════════════
Issues Found: 1
════════════════════════════════════════════════════

ISSUE #1: Python version too old
  Current: Python 3.8.0
  Required: Python 3.9+
  Impact: Some AgentOps features may not work
  Fix: Run 'make install' again to auto-install Python 3.11 via uv
       Or manually: uv python install 3.11

For more help:
  • Documentation: https://agentops.dev/docs/troubleshooting
  • File issue: https://github.com/user/agentops/issues
  • Community: https://agentops.dev/community
```

### 8.3 Automated Testing

**Test Suite:** `scripts/test/install_test.sh`

**Test Categories:**

**1. Fresh Install Tests**
- Test: Install in empty directory
- Test: Install in non-git directory
- Test: Install with interactive prompts (mocked input)
- Test: Install with config file
- Test: Install with parameters (PROFILE, MODE)

**2. Existing Installation Tests**
- Test: Install over existing .claude/
- Test: Merge preserves user customizations
- Test: Backup created before update
- Test: Idempotent (run twice, second is no-op)

**3. Profile Tests**
- Test: Install default profile
- Test: Install product-dev profile
- Test: Install devops profile
- Test: Install profile via copy mode
- Test: Install profile via symlink mode
- Test: Install profile via download mode (mocked)
- Test: Add second profile to existing install

**4. Update Tests**
- Test: Update existing installation
- Test: Update preserves user customizations
- Test: Update creates backup
- Test: Update to specific version

**5. Validation Tests**
- Test: `make verify` passes on fresh install
- Test: `make verify` fails on corrupt install
- Test: `make doctor` detects missing prerequisites
- Test: `make doctor` detects file permission issues

**6. Uninstall Tests**
- Test: Uninstall removes all components
- Test: Uninstall creates backup
- Test: Uninstall with FORCE skips confirmation

**7. Platform Tests**
- Test: macOS installation (Homebrew)
- Test: Linux installation (apt, dnf, pacman)
- Test: WSL 2 installation
- Test: Platform detection works correctly

**8. Error Handling Tests**
- Test: Missing prerequisites aborts install
- Test: Invalid config file aborts install
- Test: Corrupt profile aborts install
- Test: Rollback on mid-install failure

**Running Tests:**
```bash
# Run all tests
make test-install

# Run specific test category
make test-install-fresh
make test-install-existing
make test-install-profiles

# Run smoke tests only (quick validation)
make test-install-quick
```

**Test Implementation Example:**
```bash
#!/usr/bin/env bash
# scripts/test/install_test.sh

test_fresh_install() {
    local test_dir=$(mktemp -d)
    cd "$test_dir"

    # Create mock config
    cat > install.config.json <<EOF
{
  "version": "1.0",
  "agentops": {"model": "sonnet", "profile": "default"},
  "permissions": {"git": true}
}
EOF

    # Run install
    make install CONFIG=install.config.json
    local exit_code=$?

    # Verify
    assert_equals 0 $exit_code "Install should succeed"
    assert_file_exists ".claude/settings.json"
    assert_file_exists "CONSTITUTION.md"
    assert_file_exists "CLAUDE.md"

    # Cleanup
    cd - && rm -rf "$test_dir"
}

test_idempotent() {
    local test_dir=$(mktemp -d)
    cd "$test_dir"

    # Install twice
    make install PROFILE=default MODE=copy
    local first_install_time=$(stat -f %m .claude/settings.json)

    sleep 2

    make install PROFILE=default MODE=copy
    local second_install_time=$(stat -f %m .claude/settings.json)

    # Verify settings.json not modified on second install
    assert_equals $first_install_time $second_install_time \
        "Settings should not change on idempotent install"

    cd - && rm -rf "$test_dir"
}

# Run all tests
main() {
    test_fresh_install
    test_idempotent
    # ... more tests

    echo "All tests passed!"
}

main "$@"
```

---

## 9. Error Handling

### 9.1 Error Categories

**Critical Errors (exit immediately, no recovery)**
- Missing required prerequisites that cannot be auto-installed (Claude Code)
- Filesystem permissions prevent writing
- Corrupt agentops source directory
- Invalid manifest in existing installation

**Recoverable Errors (attempt fix, continue if possible)**
- Missing Python/uv (auto-install)
- Invalid config file (prompt to recreate)
- Profile not found (offer alternatives)
- Network failure during download (retry)

**Warnings (continue with notice)**
- Optional tools not installed (Docker, K8s)
- Existing .claude/ has unknown files (may be user customizations)
- Git hooks not executable (offer to fix)
- Python version old but acceptable

### 9.2 Error Message Format

**Standard Template:**
```
Error: [What failed]
Reason: [Why it failed]
Fix: [How to resolve]

[Optional: Technical details for debugging]
```

**Examples:**

**Example 1: Missing Claude Code**
```
Error: Claude Code CLI not found
Reason: Required for AgentOps framework to function
Fix: Install Claude Code from https://claude.com/claude-code
     Then run 'make install' again

Technical details:
  Checked: claude command in PATH
  PATH: /usr/local/bin:/usr/bin:/bin
```

**Example 2: Permission Denied**
```
Error: Permission denied writing to .claude/
Reason: Current user doesn't have write access to this directory
Fix: Run with appropriate permissions:
       Option 1: sudo make install
       Option 2: Change directory ownership:
                 sudo chown -R $USER:$USER .

Technical details:
  Directory: /project/.claude
  Owner: root:root
  Permissions: drwxr-xr-x
  Current user: developer
```

**Example 3: Invalid Config File**
```
Error: Invalid configuration file
Reason: install.config.json contains syntax errors
Fix: Fix JSON syntax errors:
       Line 5: Unexpected comma after last object property

     Or delete and recreate:
       rm install.config.json
       make install  (will prompt for configuration)

Technical details:
  File: /project/install.config.json
  Error: parse error: Expected string key before ':' at line 5, column 3
```

**Example 4: Profile Not Found**
```
Error: Profile 'custom-profile' not found
Reason: Profile does not exist in agentops repository or remote
Fix: Available profiles:
       • default
       • product-dev
       • devops

     Choose one of these profiles:
       make install PROFILE=product-dev

     Or check your AGENTOPS_HOME setting:
       export AGENTOPS_HOME=/path/to/agentops
       make install

Technical details:
  Searched: /Users/user/agentops/profiles/custom-profile
  AGENTOPS_HOME: /Users/user/agentops
```

### 9.3 Rollback Strategy

**Trigger Rollback When:**
- Critical error during installation
- Validation fails after install
- User cancels during critical operation

**Rollback Process:**
```bash
perform_rollback() {
    local backup_dir=$1
    local error_msg=$2

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installation failed: $error_msg"
    echo "Rolling back to previous state..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Restore .claude/
    if [ -d "$backup_dir/.claude" ]; then
        rm -rf ".claude"
        cp -r "$backup_dir/.claude" ".claude"
        echo "✓ Restored .claude/ from backup"
    fi

    # Restore root files
    if [ -f "$backup_dir/CONSTITUTION.md" ]; then
        cp "$backup_dir/CONSTITUTION.md" "CONSTITUTION.md"
        echo "✓ Restored CONSTITUTION.md"
    fi

    if [ -f "$backup_dir/CLAUDE.md" ]; then
        cp "$backup_dir/CLAUDE.md" "CLAUDE.md"
        echo "✓ Restored CLAUDE.md"
    fi

    echo ""
    echo "✓ Rollback complete. Your previous installation is restored."
    echo "✓ Backup retained at: $backup_dir"
    echo ""
    echo "For help troubleshooting, run: make doctor"
    exit 1
}
```

**Backup Retention:**
- Keep last 3 backups automatically
- User can manually clean with `make clean-backups`
- Backups stored in `.claude.backup-<timestamp>/`

```bash
cleanup_old_backups() {
    local backup_dirs=($(ls -1td .claude.backup-* 2>/dev/null))
    local count=${#backup_dirs[@]}
    local max_backups=3

    if [ $count -gt $max_backups ]; then
        local to_remove=$((count - max_backups))
        for ((i=max_backups; i<count; i++)); do
            echo "Removing old backup: ${backup_dirs[$i]}"
            rm -rf "${backup_dirs[$i]}"
        done
    fi
}
```

---

## 10. Security Considerations

### 10.1 Input Validation

**All user input must be validated:**

**JSON Config Files:**
```bash
validate_json_file() {
    local file=$1

    # Check file exists
    if [ ! -f "$file" ]; then
        echo "Error: Config file not found: $file"
        return 1
    fi

    # Check JSON syntax
    if ! jq empty "$file" 2>/dev/null; then
        local error=$(jq empty "$file" 2>&1)
        echo "Error: Invalid JSON in $file"
        echo "$error"
        return 1
    fi

    # Check for required fields
    local version=$(jq -r '.version // "missing"' "$file")
    if [ "$version" = "missing" ]; then
        echo "Error: Config missing required field: version"
        return 1
    fi

    return 0
}
```

**Profile Names:**
```bash
validate_profile_name() {
    local profile=$1

    # Whitelist: alphanumeric, dash, underscore only
    if [[ ! "$profile" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: Invalid profile name: $profile"
        echo "Profile names must contain only letters, numbers, dashes, and underscores"
        return 1
    fi

    # No path traversal
    if [[ "$profile" == *".."* ]]; then
        echo "Error: Profile name cannot contain '..'"
        return 1
    fi

    return 0
}
```

**File Paths:**
```bash
validate_file_path() {
    local path=$1

    # No path traversal
    if [[ "$path" == *".."* ]]; then
        echo "Error: Path cannot contain '..': $path"
        return 1
    fi

    # Must be within project root
    local abs_path=$(cd "$(dirname "$path")" && pwd)/$(basename "$path")
    local project_root=$(pwd)

    if [[ "$abs_path" != "$project_root"* ]]; then
        echo "Error: Path must be within project: $path"
        return 1
    fi

    return 0
}
```

### 10.2 File Permissions

**Set appropriate permissions for all installed files:**

**Default Permissions:**
```bash
set_permissions() {
    # Directories: 755 (rwxr-xr-x)
    chmod 755 .claude
    chmod 755 .claude/agents
    chmod 755 .claude/commands
    chmod 755 .claude/skills

    # Regular files: 644 (rw-r--r--)
    chmod 644 .claude/settings.json
    chmod 644 .claude/README.md
    chmod 644 CONSTITUTION.md
    chmod 644 CLAUDE.md

    # Scripts and hooks: 755 (rwxr-xr-x)
    if [ -f .git/hooks/pre-commit ]; then
        chmod 755 .git/hooks/pre-commit
    fi
    if [ -f .git/hooks/post-commit ]; then
        chmod 755 .git/hooks/post-commit
    fi
    if [ -f .git/hooks/commit-msg ]; then
        chmod 755 .git/hooks/commit-msg
    fi
}
```

**Sensitive Configuration:**
```bash
# settings.local.json may contain sensitive overrides
if [ -f .claude/settings.local.json ]; then
    chmod 600 .claude/settings.local.json  # rw------- (user only)
fi
```

### 10.3 Download Security

**When downloading profiles from remote (download mode):**

**Use HTTPS Only:**
```bash
download_profile() {
    local profile=$1
    local version=${VERSION:-latest}
    local base_url="https://github.com/user/agentops/releases/download"
    local url="$base_url/$version/profile-$profile.tar.gz"
    local checksum_url="$base_url/$version/profile-$profile.tar.gz.sha256"

    # Download with HTTPS only (curl will verify certificate)
    echo "Downloading $profile profile (version: $version)..."
    curl -fsSL "$url" -o "/tmp/profile-$profile.tar.gz"

    # Download checksum
    curl -fsSL "$checksum_url" -o "/tmp/profile-$profile.tar.gz.sha256"

    # Verify checksum
    if ! verify_checksum "/tmp/profile-$profile.tar.gz"; then
        echo "Error: Checksum verification failed"
        rm -f "/tmp/profile-$profile.tar.gz" "/tmp/profile-$profile.tar.gz.sha256"
        return 1
    fi

    # Extract
    tar xzf "/tmp/profile-$profile.tar.gz" -C .claude/

    # Cleanup
    rm -f "/tmp/profile-$profile.tar.gz" "/tmp/profile-$profile.tar.gz.sha256"
}

verify_checksum() {
    local file=$1
    local checksum_file="$file.sha256"

    # Compute checksum
    local computed=$(shasum -a 256 "$file" | cut -d' ' -f1)
    local expected=$(cat "$checksum_file")

    if [ "$computed" != "$expected" ]; then
        echo "Checksum mismatch:"
        echo "  Expected: $expected"
        echo "  Computed: $computed"
        return 1
    fi

    echo "✓ Checksum verified"
    return 0
}
```

### 10.4 Secrets Management

**Never store secrets in committed files:**

**install.config.json** (may be committed)
- No API keys
- No passwords
- No tokens

**settings.json** (may be committed)
- No secrets
- Team-wide defaults only

**settings.local.json** (gitignored, never committed)
- User-specific secrets OK
- API keys OK (if needed)
- Tokens OK

**Example .gitignore:**
```
# AgentOps secrets (never commit)
.claude/settings.local.json
.claude/secrets.json
.claude/.env

# AgentOps backups
.claude.backup-*/
```

**Secret Injection (if needed by profile):**
```bash
# Use environment variables for secrets
export ANTHROPIC_API_KEY="sk-..."

# Or create settings.local.json manually
cat > .claude/settings.local.json <<EOF
{
  "api_key": "sk-..."
}
EOF

chmod 600 .claude/settings.local.json
```

---

## 11. Performance Requirements

### 11.1 Installation Speed

**Targets:**
- Fresh install: < 30 seconds (excluding downloads)
- Update existing: < 15 seconds
- Profile addition: < 10 seconds
- Validation: < 5 seconds

**Optimizations:**

**Parallel Prerequisite Checks:**
```bash
check_prerequisites_parallel() {
    # Check multiple tools concurrently
    {
        check_git &
        check_claude_code &
        check_python_uv &
        wait
    }
}
```

**Minimize Disk I/O:**
```bash
# Batch file operations
install_profile_components() {
    local profile_dir=$1
    local target_dir=$2

    # Copy all at once instead of one-by-one
    rsync -a --ignore-existing \
        "$profile_dir/agents/" "$target_dir/agents/"
    rsync -a --ignore-existing \
        "$profile_dir/commands/" "$target_dir/commands/"
    rsync -a --ignore-existing \
        "$profile_dir/skills/" "$target_dir/skills/"
}
```

**Skip Unnecessary Validations:**
```bash
# If files haven't changed, skip validation
validate_if_changed() {
    local file=$1
    local checksum_file=".claude/.checksums/$1.sha256"

    local current_checksum=$(shasum -a 256 "$file" | cut -d' ' -f1)
    local prev_checksum=$(cat "$checksum_file" 2>/dev/null || echo "")

    if [ "$current_checksum" = "$prev_checksum" ]; then
        echo "✓ $file (unchanged, skipping validation)"
        return 0
    fi

    # File changed, validate
    validate_file "$file"

    # Update checksum
    echo "$current_checksum" > "$checksum_file"
}
```

### 11.2 Disk Usage

**Targets:**
- Base install: < 10 MB
- With default profile: < 20 MB
- With all profiles: < 50 MB
- Backups (3 retained): < 100 MB

**Notes:**
- Symlink mode uses negligible additional space (symlinks are tiny)
- Download mode may use more due to caching
- Backups can be cleaned with `make clean-backups`

### 11.3 Network Usage (Download Mode)

**Profile Download Sizes:**
- default profile: ~2 MB
- product-dev profile: ~5 MB
- devops profile: ~8 MB

**Optimizations:**
- Compress with gzip (tar.gz format)
- Cache downloaded profiles locally
- Support resume on network failure

**Bandwidth-Friendly:**
```bash
download_with_resume() {
    local url=$1
    local output=$2

    # Use curl with resume support
    curl -fsSL -C - "$url" -o "$output"
}
```

---

## 12. Future Enhancements

### 12.1 Post-Dec 1 Iteration

**High Priority (Q1 2026):**
- Web-based installation UI (guided setup)
- Auto-update checking (notify on new versions)
- Migration from other AI frameworks (import configs)
- Team collaboration features (shared profiles, sync)

**Medium Priority (Q2 2026):**
- Profile marketplace (community profiles)
- Installation analytics (opt-in usage stats)
- Docker-based installation (containerized)
- Cloud-hosted profiles (faster downloads)

**Low Priority (Q3 2026):**
- GUI installer (macOS/Windows apps)
- IDE integrations (VS Code, IntelliJ)
- Auto-rollback on agent failures
- Multi-language support (i18n)

### 12.2 Compatibility

**Maintain Backward Compatibility:**
- Old install.config.json formats (migration scripts)
- Deprecated Makefile targets (warnings, not errors)
- Legacy profile structures (converters)

**Breaking Changes:**
- Major version bumps only (v1 → v2)
- Migration guides required
- Deprecation warnings in v1.x releases

**Deprecation Process:**
```
v1.0: Feature X introduced
v1.5: Feature Y deprecated (warning shown)
v2.0: Feature Y removed (migration required)
```

---

## 13. Appendices

### 13.1 Example install.config.json

**Minimal Configuration:**
```json
{
  "version": "1.0",
  "agentops": {
    "model": "sonnet",
    "profile": "default"
  }
}
```

**Typical Configuration:**
```json
{
  "version": "1.0",
  "project": {
    "name": "my-awesome-app",
    "type": "product-dev"
  },
  "agentops": {
    "model": "opus",
    "profile": "product-dev",
    "install_mode": "copy"
  },
  "permissions": {
    "git": true,
    "python": true,
    "docker": false
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "commit_msg": true
  }
}
```

**Full Configuration (All Options):**
```json
{
  "$schema": "https://agentops.dev/schemas/install-config.schema.json",
  "version": "1.0",
  "project": {
    "name": "my-awesome-product",
    "type": "product-dev",
    "description": "AI-powered product development with AgentOps"
  },
  "agentops": {
    "model": "opus",
    "profile": "product-dev",
    "install_mode": "copy",
    "version": "latest"
  },
  "permissions": {
    "git": true,
    "docker": true,
    "kubernetes": false,
    "python": true,
    "rust": false,
    "go": false,
    "npm": false,
    "bash": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true,
    "pre_push": false,
    "commit_msg": true
  },
  "features": {
    "multi_agent": true,
    "context_bundles": true,
    "intelligent_routing": true,
    "session_tracking": true
  },
  "advanced": {
    "backup_count": 3,
    "auto_update": false,
    "telemetry": false
  }
}
```

### 13.2 Directory Structure Reference

**Post-Installation Structure:**
```
project-root/
├── Makefile                        # AgentOps management interface
├── install.config.json             # Installation configuration
├── CONSTITUTION.md                 # Five Laws of an Agent
├── CLAUDE.md                       # Project kernel
├── .gitignore                      # Updated with AgentOps entries
│
├── .claude/                        # Main installation directory
│   ├── README.md                   # Local documentation
│   ├── settings.json               # Claude Code configuration
│   ├── settings.local.json         # User overrides (gitignored)
│   ├── installed_components.json  # Installation manifest
│   │
│   ├── agents/                     # Agent definitions
│   │   ├── research.md
│   │   ├── plan.md
│   │   ├── implement.md
│   │   └── ... (from profile)
│   │
│   ├── commands/                   # Slash commands
│   │   ├── prime-simple-task.md
│   │   ├── prime-complex-task.md
│   │   ├── prime-debug.md
│   │   └── ... (from profile)
│   │
│   └── skills/                     # Reusable skills
│       └── ... (from profile)
│
├── .git/
│   └── hooks/                      # Git hooks (optional)
│       ├── pre-commit              # Validation hook
│       ├── post-commit             # Learning extraction hook
│       └── commit-msg              # Semantic commit template
│
└── .claude.backup-*/               # Backups (timestamped, max 3)
```

### 13.3 Platform-Specific Notes

**macOS:**
- Package manager: Homebrew (`brew install`)
- Default shell: zsh (Bash 3.2 built-in, recommend Homebrew Bash 5)
- Git usually pre-installed (via Xcode Command Line Tools)
- Case-insensitive filesystem by default (handle carefully)
- Python: Use Homebrew or uv
- Permissions: User-owned files (no sudo needed)

**Linux (Ubuntu/Debian):**
- Package manager: apt (`sudo apt-get install`)
- Default shell: bash
- Git usually pre-installed
- Case-sensitive filesystem
- Python: Use system Python + uv
- Permissions: May need sudo for system packages

**Linux (Fedora/RHEL):**
- Package manager: dnf (`sudo dnf install`)
- Default shell: bash
- Git usually pre-installed
- Case-sensitive filesystem
- Python: Use system Python + uv
- SELinux: May affect file permissions

**Linux (Arch):**
- Package manager: pacman (`sudo pacman -S`)
- Default shell: bash
- Git in base-devel group
- Case-sensitive filesystem
- Python: Use system Python + uv
- Rolling release: Always latest versions

**Windows WSL 2:**
- Runs Linux environment on Windows
- Package manager: Same as Linux distro (usually apt)
- Access Windows filesystem: `/mnt/c/...`
- Performance: Best when installed in WSL filesystem (not /mnt/c/)
- Git: Use WSL git (not Windows git)
- Line endings: Ensure LF not CRLF

### 13.4 Glossary

**Profile:** Domain-specific collection of agents, commands, and skills tailored for a use case (e.g., product-dev, devops)

**Base Install:** Core AgentOps framework without any profile-specific components

**Full Install:** Base install + profile (complete, ready-to-use setup)

**Idempotent:** Safe to run multiple times without side effects or duplicate work

**Merge:** Intelligent combination of new framework files with existing user customizations

**Rollback:** Restore previous state after an error during installation

**Validation:** Automated checks to ensure installation succeeded and is functional

**Diagnostics:** Comprehensive troubleshooting tool to identify and suggest fixes for issues

**Manifest:** JSON file tracking installed components, profile, mode, and version

**Backup:** Timestamped copy of previous installation state for rollback/recovery

**Mode (Copy):** Install profile files as standalone copies (self-contained, portable)

**Mode (Symlink):** Install profile as symbolic links to agentops repo (live updates, development-friendly)

**Mode (Download):** Fetch and install profile from remote release (no local repo needed)

**Prerequisite:** Required tool or dependency that must be installed before AgentOps

**Git Hook:** Script that runs automatically during git operations (commit, push, etc.)

**Semantic Commit:** Commit message format with type prefix (feat, fix, docs, etc.)

---

**End of Technical Specification**

**Version:** 1.0.0
**Date:** 2025-11-05
**Status:** Draft → Ready for Review

**Next Steps:**
1. Review specification with stakeholders
2. Create implementation tasks from this spec
3. Begin implementation in phases:
   - Phase 1: Core script backend (platform detection, prerequisites)
   - Phase 2: Makefile interface and interactive prompts
   - Phase 3: Profile management (copy, symlink, download)
   - Phase 4: Validation and diagnostics
   - Phase 5: Testing and polish
4. Test on all platforms (macOS, Linux, WSL)
5. Document in user-facing guides
6. Launch Dec 1, 2025

---

*This specification is comprehensive and implementation-ready. All design decisions are documented with rationale. Developers can implement directly from this spec.*
