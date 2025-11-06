# Base Installation System - Tasks Breakdown

**Spec:** 2025-11-05-base-installation
**Date:** 2025-11-05
**Target:** Dec 1, 2025 Launch
**Status:** Ready for Implementation

---

## Overview

The Base Installation System provides a universal, cross-platform mechanism to install AgentOps into any project via a Makefile interface backed by intelligent Bash scripting. The system supports multiple platforms (macOS, Linux, WSL), multiple profiles (default, product-dev, devops), and multiple installation modes (copy, symlink, download). It preserves user customizations during updates and provides comprehensive validation.

**Implementation Strategy:**
- Build foundation first (directory structure, Makefile skeleton)
- Implement core backend libraries (platform detection, prerequisites)
- Build installation logic (profiles, merge strategy, root files)
- Add validation and testing infrastructure
- Polish documentation and error messages

**Key Design Principles:**
- Idempotent (safe to run multiple times)
- Descriptive output (not verbose, not silent)
- Fail fast with clear errors
- Preserve user customizations
- Work seamlessly in agentops repo (dogfooding)

---

## Task Grouping Strategy

Tasks are organized into 5 sequential phases:

**Phase 1: Foundation & Project Setup**
- Directory structure, Makefile skeleton, basic templates
- Dependencies: None
- Outcome: Project structure ready for implementation

**Phase 2: Core Script Backend**
- Platform detection, prerequisite checking, shared utilities
- Dependencies: Phase 1 complete
- Outcome: Backend libraries functional, ready for integration

**Phase 3: Installation Logic**
- Profile management, merge strategy, component installation
- Dependencies: Phase 2 complete
- Outcome: Full installation flow working

**Phase 4: Validation & Testing**
- Post-install validation, diagnostics, automated tests
- Dependencies: Phase 3 complete
- Outcome: Quality gates in place, comprehensive testing

**Phase 5: Documentation & Polish**
- User guides, error messages, troubleshooting, final polish
- Dependencies: Phase 4 complete
- Outcome: Production-ready for Dec 1 launch

---

## Phase 1: Foundation & Project Setup

**Goal:** Establish project structure, Makefile interface, and base templates

**Timeline:** 6-8 hours

**Dependencies:** None

### Tasks

- [x] **TASK-001:** Create project directory structure
  - **Description:** Create scripts/, scripts/lib/, scripts/templates/ directories in agentops/agent-os/
  - **Deliverables:** Directory structure matching spec section 2.3
  - **Acceptance:** Directories exist: scripts/, scripts/lib/, scripts/templates/, scripts/templates/.claude/
  - **Estimate:** 30 minutes
  - **Reference:** Spec section 2.3
  - **Status:** ✅ Complete - All directories created successfully

- [x] **TASK-002:** Create Makefile skeleton with all targets
  - **Description:** Build Makefile with install, install-profile, verify, update, doctor, uninstall, help targets (stubs)
  - **Deliverables:** Makefile with all targets as stubs that print messages
  - **Acceptance:** `make help` displays all commands, each target runs without error and prints placeholder message
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.1, requirements FR5
  - **Status:** ✅ Complete - All 7 targets implemented and tested

- [x] **TASK-003:** Create base template files
  - **Description:** Create CONSTITUTION.md, CLAUDE.md templates with placeholders
  - **Deliverables:** scripts/templates/CONSTITUTION.md, scripts/templates/CLAUDE.md with variable placeholders
  - **Acceptance:** Templates contain Five Laws, project name placeholder, date placeholder
  - **Estimate:** 1.5 hours
  - **Reference:** Requirements FR1, spec section 4.2
  - **Status:** ✅ Complete - Both templates created with placeholders

- [x] **TASK-004:** Create .claude/ structure template
  - **Description:** Create template .claude/ directory with settings.json template, README.md
  - **Deliverables:** scripts/templates/.claude/settings.json, README.md with default content
  - **Acceptance:** Template files parse as valid JSON/Markdown, contain placeholders for customization
  - **Estimate:** 2 hours
  - **Reference:** Requirements FR1, spec section 2.3
  - **Status:** ✅ Complete - settings.json and README.md templates created

- [x] **TASK-005:** Create base-install.sh skeleton
  - **Description:** Create main script with argument parsing, main() flow stub, library imports
  - **Deliverables:** scripts/base-install.sh with basic structure, set -euo pipefail, argument parsing
  - **Acceptance:** Script runs without error, --help flag shows usage, imports library files without failing
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.2
  - **Status:** ✅ Complete - Script with full argument parsing and error handling

- [x] **TASK-006:** Setup .gitignore and documentation stubs
  - **Description:** Create README.md stub, .gitignore for generated files
  - **Deliverables:** agent-os/README.md, .gitignore
  - **Acceptance:** README explains purpose, .gitignore covers backups and temp files
  - **Estimate:** 30 minutes
  - **Status:** ✅ Complete - .gitignore and comprehensive README.md created

---

## Phase 2: Core Script Backend

**Goal:** Implement platform detection, prerequisite checking, and shared utilities

**Timeline:** 12-16 hours

**Dependencies:** Phase 1 complete

### Tasks

- [x] **TASK-010:** Implement platform detection (lib/platform.sh)
  - **Description:** Detect OS (macOS, Linux, WSL), package manager, set platform variables
  - **Deliverables:** scripts/lib/platform.sh with detect_platform(), is_macos(), is_linux(), is_wsl()
  - **Acceptance:** Correctly detects macOS, Linux (Ubuntu, Fedora, Arch), WSL; returns correct package manager
  - **Estimate:** 3 hours
  - **Reference:** Spec section 3.3, requirements TR1, platform support section
  - **Status:** ✅ Complete - All platform detection functions implemented with cross-platform package manager support

- [x] **TASK-011:** Implement package manager operations (lib/platform.sh)
  - **Description:** Add install_package(), check_package() functions with platform-specific logic
  - **Deliverables:** Functions that work with brew, apt, dnf, pacman, zypper
  - **Acceptance:** Can install and check packages on all supported platforms
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.3, platform support section
  - **Status:** ✅ Complete - Implemented in lib/platform.sh with support for brew, apt, dnf, pacman, zypper, apk

- [x] **TASK-012:** Implement Git prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_git() function: verify git installed, version >= 2.30
  - **Deliverables:** check_git() with version validation, clear error messages
  - **Acceptance:** Returns 0 if Git >= 2.30 present, returns 1 with error message if missing/old
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.4, requirements FR4
  - **Status:** ✅ Complete - Implemented with version comparison and platform-specific installation instructions

- [x] **TASK-013:** Implement Claude Code prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_claude_code() function: verify Claude Code CLI installed
  - **Deliverables:** check_claude_code() with version detection
  - **Acceptance:** Returns 0 if Claude Code present, returns 1 with installation link if missing
  - **Estimate:** 1 hour
  - **Reference:** Spec section 3.4, requirements FR4
  - **Status:** ✅ Complete - Implemented with multiple command name checks and helpful error messages

- [x] **TASK-014:** Implement Python/uv prerequisite checking (lib/prerequisites.sh)
  - **Description:** check_python_uv() function: verify Python 3.9+, uv tool
  - **Deliverables:** check_python_uv() with version validation
  - **Acceptance:** Returns 0 if uv + Python 3.9+ present, returns 1 if missing
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.4, requirements FR4, TR2
  - **Status:** ✅ Complete - Checks both Python 3.9+ and uv with version comparison

- [x] **TASK-015:** Implement auto-install for uv (lib/prerequisites.sh)
  - **Description:** install_uv() function: download and install uv, install Python 3.11 via uv
  - **Deliverables:** install_uv() with progress messages, error handling
  - **Acceptance:** Successfully installs uv and Python 3.11, updates PATH for current session
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.4, requirements TR2
  - **Status:** ✅ Complete - Implemented with curl download, PATH updates, and Python 3.11 installation

- [x] **TASK-016:** Implement prerequisite prompt logic (lib/prerequisites.sh)
  - **Description:** prompt_install() function: ask user before auto-installing tools
  - **Deliverables:** prompt_install() with clear prompts, Y/n default
  - **Acceptance:** Prompts user clearly, respects user choice, handles yes/no correctly
  - **Estimate:** 1 hour
  - **Reference:** Spec section 3.4
  - **Status:** ✅ Complete - Implemented in both prerequisites.sh and common.sh with confirm() function

- [x] **TASK-017:** Implement main check_prerequisites() coordinator (lib/prerequisites.sh)
  - **Description:** check_prerequisites() orchestrates all checks, handles auto-install flow
  - **Deliverables:** check_prerequisites() calls individual checks, prompts for auto-install, exits on critical failure
  - **Acceptance:** All prerequisites checked, missing tools auto-installed (with consent), exits with code 2 if critical missing
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.4, requirements FR4
  - **Status:** ✅ Complete - Implemented as main coordinator that orchestrates all checks with proper error handling

- [x] **TASK-018:** Implement utility functions (lib/common.sh)
  - **Description:** Create common utility functions: log(), error(), backup_file(), timestamp()
  - **Deliverables:** scripts/lib/common.sh with logging, error handling, backup utilities
  - **Acceptance:** Functions work correctly, consistent output formatting
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section TR1 (idempotent design patterns)
  - **Status:** ✅ Complete - Comprehensive utility library with logging, file ops, user interaction, versioning, and more

---

## Phase 3: Installation Logic

**Goal:** Implement profile management, installation algorithm, merge strategy

**Timeline:** 16-20 hours

**Dependencies:** Phase 2 complete

### Tasks

- [ ] **TASK-020:** Implement agentops repo detection (lib/profiles.sh)
  - **Description:** find_agentops_repo() searches common locations, detects if inside agentops repo
  - **Deliverables:** find_agentops_repo() function, sets AGENTOPS_ROOT variable
  - **Acceptance:** Detects agentops repo in common locations, detects if running inside agentops, handles not found
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.5, requirements TR5 (dogfooding)

- [ ] **TASK-021:** Implement profile listing (lib/profiles.sh)
  - **Description:** list_profiles() returns available profiles from local or remote
  - **Deliverables:** list_profiles() with local and remote fallback
  - **Acceptance:** Lists profiles from local repo if available, fetches from GitHub API if not
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.5

- [ ] **TASK-022:** Implement profile validation (lib/profiles.sh)
  - **Description:** validate_profile() checks profile structure (agents/, settings.json present, valid JSON)
  - **Deliverables:** validate_profile() with structure checks
  - **Acceptance:** Returns 0 if profile valid, returns 1 with clear error if invalid
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.5

- [ ] **TASK-023:** Implement copy_profile() mode (lib/profiles.sh)
  - **Description:** Copy profile files from agentops/profiles/<name>/ to .claude/
  - **Deliverables:** copy_profile() function, preserves existing files
  - **Acceptance:** Copies agents, commands, skills; doesn't overwrite existing files; copies settings.json to .profile variant
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.5, requirements FR7

- [ ] **TASK-024:** Implement symlink_profile() mode (lib/profiles.sh)
  - **Description:** Symlink profile directories from agentops repo to .claude/
  - **Deliverables:** symlink_profile() function, creates symlinks for agents, commands, skills
  - **Acceptance:** Creates symlinks correctly, handles existing symlinks, copies settings separately
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.5, requirements FR7

- [ ] **TASK-025:** Implement download_profile() mode (lib/profiles.sh)
  - **Description:** Download profile from GitHub release, extract to .claude/
  - **Deliverables:** download_profile() with curl + tar extraction, version handling
  - **Acceptance:** Downloads profile tarball, extracts correctly, handles network errors gracefully
  - **Estimate:** 2.5 hours
  - **Reference:** Spec section 3.5, requirements FR7

- [ ] **TASK-026:** Implement interactive profile selection (lib/profiles.sh)
  - **Description:** prompt_profile_selection() and prompt_profile_mode() for interactive config
  - **Deliverables:** Interactive prompts for profile and mode selection
  - **Acceptance:** Clear prompts, validates input, sets PROFILE and MODE variables
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.5, requirements FR6

- [ ] **TASK-027:** Implement settings merge logic (lib/profiles.sh)
  - **Description:** merge_settings() combines profile settings with existing user settings
  - **Deliverables:** merge_settings() using jq for deep merge, preserves user keys
  - **Acceptance:** User settings take precedence, new profile keys added, no data loss
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.5, requirements FR2

- [ ] **TASK-028:** Implement installation manifest (lib/profiles.sh)
  - **Description:** update_manifest() creates/updates .claude/installed_components.json
  - **Deliverables:** update_manifest() with JSON generation, component counts
  - **Acceptance:** Manifest tracks profile, mode, timestamp, version, component counts
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.5, requirements TR4

- [ ] **TASK-029:** Implement existing installation detection (base-install.sh)
  - **Description:** detect_existing_installation() checks for .claude/, reads manifest
  - **Deliverables:** Detection logic in main script, sets EXISTING_INSTALL flags
  - **Acceptance:** Correctly detects existing install, reads manifest, handles missing manifest
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 4.1, requirements FR2

- [ ] **TASK-030:** Implement backup logic (base-install.sh)
  - **Description:** backup_if_existing() creates timestamped backups before updates
  - **Deliverables:** Backup function, creates .claude.backup-<timestamp>/ directory
  - **Acceptance:** Backups created with timestamp, preserves all files, handles errors
  - **Estimate:** 2 hours
  - **Reference:** Spec section TR5 (idempotent design)

- [ ] **TASK-031:** Implement install_base_structure() (base-install.sh)
  - **Description:** Create/update .claude/ directory, install base templates
  - **Deliverables:** Function installs .claude/, settings.json, README.md
  - **Acceptance:** Creates directory structure, installs base files, merges with existing
  - **Estimate:** 2 hours
  - **Reference:** Spec section 4.1, requirements FR1

- [ ] **TASK-032:** Implement install_root_files() (base-install.sh)
  - **Description:** Install CONSTITUTION.md, CLAUDE.md at project root
  - **Deliverables:** Function installs root files with variable substitution
  - **Acceptance:** Templates rendered with project name, date; existing files backed up
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 4.1, requirements FR1

- [ ] **TASK-033:** Implement git hooks installation (base-install.sh)
  - **Description:** install_hooks_if_enabled() installs pre-commit, post-commit, commit-msg hooks
  - **Deliverables:** Function copies hooks to .git/hooks/, makes executable
  - **Acceptance:** Hooks installed only if git repo exists, made executable, skipped if INSTALL_HOOKS=false
  - **Estimate:** 2 hours
  - **Reference:** Requirements FR1

---

## Phase 4: Validation & Testing

**Goal:** Implement post-install validation, diagnostics, automated tests

**Timeline:** 16-20 hours

**Dependencies:** Phase 3 complete

### Tasks

- [ ] **TASK-040:** Implement file existence checks (lib/validation.sh)
  - **Description:** check_files_exist() verifies all required files and directories present
  - **Deliverables:** Function checks .claude/, CONSTITUTION.md, CLAUDE.md, counts components
  - **Acceptance:** Returns 0 if all files present, returns error count and lists missing files
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-041:** Implement YAML/JSON syntax validation (lib/validation.sh)
  - **Description:** validate_yaml_json() checks settings.json and agent files parse correctly
  - **Deliverables:** Function uses jq for JSON validation, handles YAML frontmatter in agents
  - **Acceptance:** Validates JSON syntax, reports line numbers for errors, handles agent Markdown files
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-042:** Implement Claude Code integration test (lib/validation.sh)
  - **Description:** test_claude_code_load() verifies Claude Code can load settings.json
  - **Deliverables:** Function calls Claude Code CLI to validate settings (placeholder for actual command)
  - **Acceptance:** Returns 0 if settings load successfully, returns 1 with error message if fail
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-043:** Implement sample agent execution (lib/validation.sh)
  - **Description:** run_sample_agent() executes hello-world or similar test agent
  - **Deliverables:** Function runs agent, checks output (placeholder for actual agent execution)
  - **Acceptance:** Agent executes without error, output matches expected
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-044:** Implement git hooks validation (lib/validation.sh)
  - **Description:** check_git_hooks() verifies hooks installed and executable
  - **Deliverables:** Function checks .git/hooks/ for pre-commit, post-commit, commit-msg
  - **Acceptance:** Reports which hooks installed, checks executable bit, skips if not git repo
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-045:** Implement prerequisite version validation (lib/validation.sh)
  - **Description:** check_prerequisite_versions() verifies all tools meet minimum versions
  - **Deliverables:** Function checks Git, Claude Code, Python versions
  - **Acceptance:** Reports versions, warns if below minimum, doesn't fail for optional tools
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-046:** Implement main validate_installation() coordinator (lib/validation.sh)
  - **Description:** Orchestrates all validation checks, formats output, returns exit code
  - **Deliverables:** Function runs all checks, prints progress, summarizes results
  - **Acceptance:** Runs all 6 checks, clear progress output, exit code 0 if pass / 1 if fail
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.6, requirements FR8

- [ ] **TASK-047:** Implement make verify target (Makefile)
  - **Description:** Connect Makefile verify target to validation script
  - **Deliverables:** Makefile target calls base-install.sh --verify
  - **Acceptance:** `make verify` runs validation, returns correct exit code, displays formatted output
  - **Estimate:** 1 hour
  - **Reference:** Spec section 3.1, requirements FR5

- [ ] **TASK-048:** Implement make doctor target (Makefile + base-install.sh)
  - **Description:** Diagnostics mode: check prerequisites, file structure, configuration, suggest fixes
  - **Deliverables:** --doctor flag in script, checks all aspects, provides actionable suggestions
  - **Acceptance:** `make doctor` diagnoses issues, suggests fixes, returns 0 if no issues / 1 if issues found
  - **Estimate:** 3 hours
  - **Reference:** Spec section 3.1, requirements FR5

- [ ] **TASK-049:** Create unit tests for platform detection
  - **Description:** Test scripts for platform.sh: test all OS detection, package manager detection
  - **Deliverables:** tests/test-platform.sh with assertions for macOS, Linux, WSL
  - **Acceptance:** Tests pass on all platforms, mock uname for cross-platform testing
  - **Estimate:** 2 hours

- [ ] **TASK-050:** Create unit tests for prerequisites checking
  - **Description:** Test scripts for prerequisites.sh: test version parsing, auto-install logic
  - **Deliverables:** tests/test-prerequisites.sh with mock commands
  - **Acceptance:** Tests verify version checking logic, simulate missing tools
  - **Estimate:** 2 hours

- [ ] **TASK-051:** Create integration tests for installation flow
  - **Description:** End-to-end test: fresh install in empty directory, install over existing, update
  - **Deliverables:** tests/test-install-flow.sh with setup/teardown, multiple scenarios
  - **Acceptance:** Tests cover: fresh install, existing .claude/, profile addition, update
  - **Estimate:** 4 hours

---

## Phase 5: Documentation & Polish

**Goal:** User documentation, error messages, troubleshooting, final polish

**Timeline:** 10-16 hours

**Dependencies:** Phase 4 complete

### Tasks

- [ ] **TASK-060:** Implement configuration file loading (base-install.sh)
  - **Description:** load_configuration() reads install.config.json, validates schema
  - **Deliverables:** Function parses JSON config, validates fields, sets variables
  - **Acceptance:** Loads complete and partial configs, prompts for missing values, validates schema
  - **Estimate:** 2.5 hours
  - **Reference:** Spec section 6, requirements FR6

- [ ] **TASK-061:** Implement interactive configuration prompts (base-install.sh)
  - **Description:** prompt_configuration() asks user for model, profile, permissions, hooks
  - **Deliverables:** Interactive prompts with defaults, validation
  - **Acceptance:** Clear prompts, sensible defaults, input validation, sets all required variables
  - **Estimate:** 3 hours
  - **Reference:** Spec section 6, requirements FR6

- [ ] **TASK-062:** Implement update flow (base-install.sh)
  - **Description:** --update flag: detect current install, fetch latest, merge, validate
  - **Deliverables:** Update logic with backup, fetch, merge, migration support
  - **Acceptance:** `make update` preserves customizations, adds new components, handles version-specific migrations
  - **Estimate:** 3 hours
  - **Reference:** Spec section 2.4, requirements FR5

- [ ] **TASK-063:** Implement uninstall flow (base-install.sh)
  - **Description:** --uninstall flag: warn, confirm, remove components, keep backups
  - **Deliverables:** Uninstall logic with confirmation, complete removal, backup to .claude.backup-uninstall-*/
  - **Acceptance:** `make uninstall` removes .claude/, root files, hooks; creates backup; prompts for confirmation
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.1, requirements FR5

- [ ] **TASK-064:** Implement success message and next steps (base-install.sh)
  - **Description:** print_success_message() displays summary, next steps, documentation links
  - **Deliverables:** Function prints formatted success message with actionable next steps
  - **Acceptance:** Message is clear, actionable, includes: what was installed, how to verify, next steps
  - **Estimate:** 1 hour
  - **Reference:** Spec section 2.4

- [ ] **TASK-065:** Improve error messages throughout
  - **Description:** Audit all error messages, ensure they're actionable and helpful
  - **Deliverables:** Clear error messages with: what went wrong, why, how to fix
  - **Acceptance:** All errors explain problem and provide solution, no cryptic messages
  - **Estimate:** 2 hours
  - **Reference:** Spec section 9 (error handling)

- [ ] **TASK-066:** Write user installation guide (docs/)
  - **Description:** Create comprehensive installation guide: quick start, options, troubleshooting
  - **Deliverables:** agent-os/docs/INSTALL.md with examples for all scenarios
  - **Acceptance:** Guide covers: quick start, all parameters, config file, profiles, troubleshooting
  - **Estimate:** 3 hours

- [ ] **TASK-067:** Write configuration reference (docs/)
  - **Description:** Document install.config.json schema, all options, examples
  - **Deliverables:** agent-os/docs/CONFIGURATION.md with complete schema reference
  - **Acceptance:** Documents all fields, types, defaults, examples for common scenarios
  - **Estimate:** 2 hours
  - **Reference:** Spec section 6, requirements configuration schema

- [ ] **TASK-068:** Write troubleshooting guide (docs/)
  - **Description:** Document common issues and solutions, platform-specific problems
  - **Deliverables:** agent-os/docs/TROUBLESHOOTING.md with FAQs, platform issues, debugging
  - **Acceptance:** Covers: prerequisite issues, installation failures, platform-specific problems, `make doctor` usage
  - **Estimate:** 2 hours

- [ ] **TASK-069:** Create example config files
  - **Description:** Create example install.config.json for common scenarios
  - **Deliverables:** examples/config-minimal.json, config-devops.json, config-product-dev.json
  - **Acceptance:** Examples are valid JSON, cover common use cases, well-commented
  - **Estimate:** 1 hour

- [ ] **TASK-070:** Final polish: output formatting and user experience
  - **Description:** Audit all output, ensure consistent formatting, progress indicators, colors (optional)
  - **Deliverables:** Consistent output style across all commands
  - **Acceptance:** All output is clear, consistent formatting, progress visible, success/error distinguishable
  - **Estimate:** 2 hours

---

## Testing Checklist

### Unit Tests

- [ ] Platform detection tests (macOS, Linux, WSL detection)
- [ ] Package manager detection (brew, apt, dnf, pacman, zypper)
- [ ] Git version checking (various versions, >= 2.30)
- [ ] Python/uv version checking (various versions, >= 3.9)
- [ ] Profile validation (valid/invalid structures)
- [ ] Settings merge logic (various merge scenarios)
- [ ] Manifest generation (correct JSON, component counts)
- [ ] File existence checks (present/missing files)
- [ ] JSON syntax validation (valid/invalid JSON)

### Integration Tests

- [ ] Fresh install in empty directory
- [ ] Install over existing .claude/ (merge scenario)
- [ ] Install with interactive prompts
- [ ] Install with config file (full config)
- [ ] Install with config file (partial config, prompts for missing)
- [ ] Profile addition (install-profile target)
- [ ] Update existing installation
- [ ] Uninstall and verify cleanup

### Platform Tests

- [ ] macOS 12+ (Homebrew package manager)
- [ ] macOS 14+ (latest)
- [ ] Ubuntu 20.04 (apt)
- [ ] Ubuntu 22.04 (apt)
- [ ] Fedora 38+ (dnf)
- [ ] Arch Linux (pacman)
- [ ] Windows WSL 2 (Ubuntu)

### User Acceptance Tests

- [ ] Individual developer: quick install (interactive)
- [ ] Individual developer: install with config file
- [ ] Team lead: install specific profile for team
- [ ] Team lead: update existing team installation
- [ ] Developer: verify installation after install
- [ ] Developer: diagnose issues with `make doctor`
- [ ] Developer: uninstall AgentOps
- [ ] Error recovery: missing prerequisites
- [ ] Error recovery: invalid config file
- [ ] Error recovery: network failure during download

### Dogfooding Tests

- [ ] Install in agentops repo itself (symlink mode)
- [ ] Update in agentops repo
- [ ] Verify works alongside existing .claude/
- [ ] Developer workflow: edit profiles, see changes immediately

---

## Dependencies & Blockers

### External Dependencies

**Required (user must have):**
- Git 2.30+ - Cannot install if missing and auto-install fails
- Claude Code CLI - Must be pre-installed (cannot auto-install)
- Internet connection - Required for download mode, GitHub API profile listing

**Auto-Installable:**
- Python 3.9+ via uv - Can auto-install with user consent
- uv (Python tool) - Can auto-install via curl
- Git (if missing) - Can auto-install via package manager

**Optional (profile-dependent):**
- Docker - Required for devops profile features
- Kubernetes tools (kubectl, helm) - Required for devops profile K8s features
- Language-specific tools - Required for language-specific workflows

### Internal Dependencies

**Existing in agentops repo:**
- profiles/ directory with default, product-dev, devops profiles
- Profile structure: agents/, commands/, skills/, settings.json
- CONSTITUTION.md template content
- CLAUDE.md template content

**Created by this system:**
- scripts/base-install.sh (main installer)
- scripts/lib/*.sh (backend libraries)
- scripts/templates/ (template files)
- Makefile targets (in project root)

### Potential Blockers

**High Risk:**
- Claude Code CLI interface changes - Validation tests depend on CLI interface (placeholder in spec)
- Platform-specific package manager issues - Auto-install may fail on uncommon distros
- Merge strategy edge cases - Complex existing .claude/ structures may break merge logic
- Network reliability - Download mode depends on GitHub availability

**Mitigation Strategies:**
- Claude Code: Use generic validation for now, update when CLI interface finalized
- Platform: Test on wide range of distros, provide manual instructions as fallback
- Merge: Extensive testing with various existing structures, backups prevent data loss
- Network: Retry logic, fallback to local profiles, clear error messages

**Medium Risk:**
- Git hooks compatibility - Different git versions may handle hooks differently
- Symlink behavior - Windows/WSL symlinks may behave unexpectedly
- Permissions issues - sudo required for some package installs, may fail in CI

**Mitigation Strategies:**
- Hooks: Test with multiple git versions, provide opt-out
- Symlinks: Test WSL specifically, fallback to copy mode if issues
- Permissions: Clear error messages, guide user through manual install

**Low Risk:**
- Performance on slow systems - Large profiles may take time to copy
- Disk space - Backups accumulate over time
- User confusion with prompts - Interactive mode may overwhelm

**Mitigation Strategies:**
- Performance: Progress indicators, optimize file operations
- Disk space: Document cleanup of old backups, provide cleanup command
- Prompts: Clear help text, sensible defaults, config file option

---

## Success Criteria

### Functional Requirements

- ✅ All Makefile targets work as specified (install, verify, update, doctor, uninstall, help)
- ✅ Installs on macOS, Linux, WSL without errors
- ✅ All three profile modes work (copy, symlink, download)
- ✅ Interactive prompts and config file both work
- ✅ Prerequisite auto-install works (Git, Python/uv)
- ✅ Merge strategy preserves user customizations
- ✅ Validation catches common issues (missing files, syntax errors, version mismatches)
- ✅ Rollback works on installation error
- ✅ Idempotent (safe to run multiple times)

### Performance Requirements

- ✅ Fresh install completes in < 30 seconds (copy mode, local profile)
- ✅ Fresh install with download completes in < 2 minutes (network dependent)
- ✅ Update completes in < 15 seconds (preserving customizations)
- ✅ Validation completes in < 5 seconds (all checks)
- ✅ Doctor diagnostics complete in < 10 seconds

### Quality Requirements

- ✅ 95%+ users have zero configuration errors (validated through beta testing)
- ✅ All automated tests pass (unit, integration, platform tests)
- ✅ Error messages are clear and actionable (no "Unknown error")
- ✅ Documentation is complete (installation guide, config reference, troubleshooting)
- ✅ Works in agentops repo itself (dogfooding tested)

### User Experience Requirements

- ✅ User can install with one command: `make install`
- ✅ User can verify installation: `make verify`
- ✅ User can diagnose issues: `make doctor`
- ✅ User can customize via config file or interactive prompts
- ✅ User gets clear next steps after installation
- ✅ User can immediately start using agents (no additional setup)

---

## Timeline Estimate

**Total:** 60-80 hours (2-3 weeks for 1 developer working full-time)

### Phase Breakdown

- **Phase 1: Foundation & Project Setup** — 6-8 hours
  - Directory structure, Makefile, templates, skeleton script
  - Ready for backend implementation

- **Phase 2: Core Script Backend** — 12-16 hours
  - Platform detection, prerequisite checking, utilities
  - Backend libraries functional

- **Phase 3: Installation Logic** — 16-20 hours
  - Profile management, merge strategy, installation flow
  - Full install workflow working

- **Phase 4: Validation & Testing** — 16-20 hours
  - Post-install validation, diagnostics, automated tests
  - Quality gates in place

- **Phase 5: Documentation & Polish** — 10-16 hours
  - User guides, error messages, troubleshooting, final polish
  - Production-ready

### Milestones

**Week 1 (Nov 11-15):**
- Phase 1 complete (foundation)
- Phase 2 complete (backend libraries)
- Milestone: Platform detection and prerequisite checking working

**Week 2 (Nov 18-22):**
- Phase 3 complete (installation logic)
- Milestone: Full installation flow working, all modes functional

**Week 3 (Nov 25-29):**
- Phase 4 complete (validation & testing)
- Phase 5 complete (documentation & polish)
- Milestone: Production-ready, all tests passing, docs complete

**Target Completion:** Nov 28, 2025 (3 days before Dec 1 launch)

**Buffer:** Nov 29-30 for unexpected issues, final testing, last-minute fixes

---

## Risk Management

### Technical Risks

**Risk:** Platform-specific edge cases break installation
- **Probability:** Medium
- **Impact:** High (blocks users on that platform)
- **Mitigation:** Test on wide variety of platforms, provide manual fallback, clear error messages
- **Contingency:** Document manual installation for problem platforms

**Risk:** Claude Code CLI interface changes before launch
- **Probability:** Low
- **Impact:** Medium (validation tests may break)
- **Mitigation:** Use minimal Claude Code integration, prepare to update quickly
- **Contingency:** Disable Claude Code integration tests if interface unavailable

**Risk:** Complex merge scenarios corrupt existing configurations
- **Probability:** Medium
- **Impact:** High (data loss for users)
- **Mitigation:** Always backup before merge, extensive testing with various configs, rollback on error
- **Contingency:** User can restore from timestamped backup

**Risk:** Network failures during download mode
- **Probability:** Medium
- **Impact:** Low (fallback modes available)
- **Mitigation:** Retry logic, clear error messages, recommend copy mode
- **Contingency:** Users can use copy or symlink mode instead

### Schedule Risks

**Risk:** Implementation takes longer than estimated
- **Probability:** Medium
- **Impact:** High (misses Dec 1 launch)
- **Mitigation:** Start immediately, track progress daily, identify delays early
- **Contingency:** Reduce scope (e.g., defer download mode, simplify validation)

**Risk:** Testing uncovers major issues late
- **Probability:** Medium
- **Impact:** High (delays launch)
- **Mitigation:** Test continuously during implementation, not just at end
- **Contingency:** Fix critical issues, document known issues for post-launch

**Risk:** Documentation incomplete at launch
- **Probability:** Low
- **Impact:** Medium (poor user experience)
- **Mitigation:** Write docs alongside code, dedicate final days to polish
- **Contingency:** Launch with minimal docs, improve post-launch

### User Experience Risks

**Risk:** Users confused by interactive prompts
- **Probability:** Medium
- **Impact:** Low (can use config file)
- **Mitigation:** Clear prompts with examples, sensible defaults, config file alternative
- **Contingency:** Improve prompts based on beta feedback

**Risk:** Error messages unclear
- **Probability:** Low
- **Impact:** Medium (users can't fix issues)
- **Mitigation:** Audit all error messages, test with beta users, provide suggestions
- **Contingency:** Update error messages post-launch based on support requests

---

## Next Steps

1. **✅ Review tasks** — Stakeholders approve breakdown and estimates
2. **Assign tasks** — Developer(s) claim Phase 1 tasks
3. **Setup repository** — Create agent-os/ structure, initialize git
4. **Start Phase 1** — Begin with TASK-001 (directory structure)
5. **Daily standups** — Track progress, identify blockers, adjust timeline
6. **Beta testing** — Week of Nov 25: beta testers install on their systems
7. **Launch prep** — Nov 29-30: final testing, documentation review, last fixes
8. **Launch** — Dec 1, 2025: AgentOps Base Installation System public release

---

## Task Status Legend

- [ ] Not started
- [~] In progress
- [✓] Complete
- [✗] Blocked

---

## Notes

### Implementation Philosophy

**Idempotent by Design:**
- Every operation checks before creating
- Merge instead of overwrite
- Track state in manifest
- Safe to run multiple times

**User-Centric:**
- Clear prompts and defaults
- Preserve customizations always
- Actionable error messages
- Multiple workflows (interactive, config, CLI)

**Developer-Friendly:**
- Works in agentops repo (dogfooding)
- Symlink mode for live development
- Clear debugging with `make doctor`
- Comprehensive validation

**Production-Ready:**
- Automated testing on all platforms
- Error handling and rollback
- Performance optimized
- Complete documentation

### Testing Strategy

**Continuous Testing:**
- Write tests alongside code (not after)
- Run tests on every change
- Test on multiple platforms early
- Beta test with real users

**Test Pyramid:**
- Many unit tests (fast, isolated)
- Some integration tests (end-to-end flows)
- Few platform tests (expensive, comprehensive)
- UAT with beta users (real-world scenarios)

**Dogfooding:**
- Install in agentops repo immediately
- Use daily during development
- Find issues before users do

### Success Metrics (Post-Launch)

**Week 1 (Dec 1-7):**
- 50+ installations across platforms
- < 5% installation failure rate
- Zero critical bugs reported
- User feedback mostly positive

**Month 1 (Dec 1-31):**
- 200+ installations
- < 2% installation failure rate
- Common issues documented in troubleshooting
- At least 5 GitHub issues filed and resolved

**Quarter 1 (Dec-Feb):**
- 1000+ installations
- < 1% installation failure rate
- Community contributions (bug fixes, profiles)
- Iteration 1.1 released with improvements

---

**Created:** 2025-11-05
**Last Updated:** 2025-11-05
**Version:** 1.0
**Status:** Ready for Implementation
**Target:** Dec 1, 2025 Launch
**Estimated Effort:** 60-80 hours (2-3 weeks)
