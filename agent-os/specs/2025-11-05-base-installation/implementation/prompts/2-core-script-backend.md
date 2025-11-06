# Phase 2: Core Script Backend

We're implementing the Base Installation System by building the core script libraries for platform detection, prerequisite checking, and shared utilities.

## Implement these tasks:

- [ ] **TASK-010:** Implement platform detection (lib/platform.sh)
  - **Description:** Detect OS (macOS, Linux, WSL), package manager, set platform variables
  - **Deliverables:** scripts/lib/platform.sh with detect_platform(), is_macos(), is_linux(), is_wsl()
  - **Acceptance:** Correctly detects macOS, Linux (Ubuntu, Fedora, Arch), WSL; returns correct package manager
  - **Estimate:** 3 hours
  - **Reference:** Spec section 3.3, requirements TR1, platform support section

- [ ] **TASK-011:** Implement package manager operations (lib/platform.sh)
  - **Description:** Add install_package(), check_package() functions with platform-specific logic
  - **Deliverables:** Functions that work with brew, apt, dnf, pacman, zypper
  - **Acceptance:** Can install and check packages on all supported platforms
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.3, platform support section

- [ ] **TASK-012:** Implement Git prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_git() function: verify git installed, version >= 2.30
  - **Deliverables:** check_git() with version validation, clear error messages
  - **Acceptance:** Returns 0 if Git >= 2.30 present, returns 1 with error message if missing/old
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.4, requirements FR4

- [ ] **TASK-013:** Implement Claude Code prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_claude_code() function: verify Claude Code CLI installed
  - **Deliverables:** check_claude_code() with version detection
  - **Acceptance:** Returns 0 if Claude Code present, returns 1 with installation link if missing
  - **Estimate:** 1 hour
  - **Reference:** Spec section 3.4, requirements FR4

- [ ] **TASK-014:** Implement Python/uv prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_python_uv() function: verify Python 3.9+, uv tool
  - **Deliverables:** check_python_uv() with version validation
  - **Acceptance:** Returns 0 if uv + Python 3.9+ present, returns 1 if missing
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.4, requirements FR4, TR2

- [ ] **TASK-015:** Implement auto-install for uv (lib/prerequisites.sh)
  - **Description:** install_uv() function: download and install uv, install Python 3.11 via uv
  - **Deliverables:** install_uv() with progress messages, error handling
  - **Acceptance:** Successfully installs uv and Python 3.11, updates PATH for current session
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.4, requirements TR2

- [ ] **TASK-016:** Implement prerequisite prompt logic (lib/prerequisites.sh)
  - **Description:** prompt_missing_prerequisite() function: friendly prompts for missing tools
  - **Deliverables:** Function for each prerequisite asking "do you want to auto-install?"
  - **Acceptance:** User can choose to auto-install or exit, clear explanations
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 5.2

- [ ] **TASK-017:** Implement main check_prerequisites() coordinator (lib/prerequisites.sh)
  - **Description:** check_prerequisites() orchestrator: runs all checks, handles auto-install, reports
  - **Deliverables:** Main coordinator function that calls individual checks, handles rollback
  - **Acceptance:** Checks all prerequisites, auto-installs missing (if allowed), reports clearly
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.4

- [ ] **TASK-018:** Implement utility functions (lib/common.sh)
  - **Description:** Shared utilities: logging, error handling, formatting, file operations
  - **Deliverables:** Functions: log_info(), log_error(), log_step(), print_error(), print_success(), command_exists()
  - **Acceptance:** All utilities work correctly, output is descriptive and formatted nicely
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.2, implementation details

## Understand the context

Read `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/spec.md`:
- Section 2.2 - Component relationships
- Section 3.2 - Script backend structure
- Section 3.3 - Platform detection API
- Section 3.4 - Prerequisites management API
- Section 13.3 - Platform-specific notes

Also review requirements:
- `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/planning/requirements.md`
- Technical Requirements TR1, TR2, TR3

## Implementation Guidance

### Key Design Principles

1. **POSIX-compatible Bash** - Avoid bash-isms where possible for maximum portability
2. **Fail fast with clear errors** - Informative error messages with fix suggestions
3. **Platform detection first** - Set variables early, use throughout
4. **Idempotent checks** - Safe to run multiple times
5. **Auto-install when possible** - Especially for Python/uv

### lib/platform.sh

Must provide:
```bash
detect_platform()          # Sets PLATFORM, PKG_MANAGER, and platform-specific vars
is_macos()                 # Boolean
is_linux()                 # Boolean
is_wsl()                   # Boolean
get_pkg_manager()          # Returns package manager (brew, apt, dnf, pacman, zypper)
install_package(name)      # Universal package install
check_package(name)        # Check if package installed
```

Platform detection algorithm:
1. Check uname output (Darwin = macOS, Linux = Linux)
2. If Linux, check for WSL (grep -i microsoft /proc/version)
3. Detect package manager based on OS

### lib/prerequisites.sh

Must provide:
```bash
check_git()                # Verify git >= 2.30
check_claude_code()        # Verify claude-code CLI installed
check_python_uv()          # Verify Python 3.9+ and uv installed
install_uv()               # Auto-install uv and Python 3.11
prompt_missing_prerequisite() # Ask user if they want auto-install
check_prerequisites()      # Orchestrator - checks all, handles auto-install
```

Version checking pattern:
```bash
get_version() {
    local tool=$1
    $tool --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "0.0"
}

version_gte() {
    local required=$1 actual=$2
    [[ "$actual" == "$(echo -e "$required\n$actual" | sort -V | head -n1)" ]]
}
```

### lib/common.sh

Must provide:
```bash
log_info(msg)              # Info message to stderr
log_error(msg)             # Error message to stderr
log_step(msg)              # Step message (checkmarks, nice formatting)
print_error(title, msg)    # Formatted error output
print_success(msg)         # Success message
command_exists(cmd)        # Check if command exists in PATH
safe_run(cmd)              # Run command, handle errors gracefully
backup_file(path)          # Backup file with timestamp
rollback_file(path)        # Restore from backup
```

Output formatting:
```bash
log_step "Installing Python via uv"  # → ✓ Installing Python via uv
print_success "Installation complete" # → ✅ Installation complete!
print_error "Git not found" "Install Git from https://git-scm.com"
```

## Success Criteria

- ✅ All 9 tasks completed
- ✅ Platform detection works on macOS, Linux (Ubuntu/Fedora/Arch), WSL 2
- ✅ All prerequisite checks work correctly with version validation
- ✅ Auto-install for uv handles failures gracefully
- ✅ Utility functions provide clear, formatted output
- ✅ All libraries source properly without errors
- ✅ Code is POSIX-compatible and portable

## Dependencies

Phase 1 must be complete:
- Directory structure exists
- Makefile skeleton in place
- base-install.sh skeleton ready to call these libraries

## After Completion

When all Phase 2 tasks complete:
1. Mark TASK-010 through TASK-018 as `[x]` in `tasks.md`
2. Commit: `feat(base-install): Phase 2 - Core script backend libraries`
3. Report ready for Phase 3

This phase is critical - these libraries are used throughout the installation system!
