#!/usr/bin/env bash
# AgentOps Framework - Base Installation Script
# Universal installation system for any project
#
# Usage:
#   ./scripts/base-install.sh [--help] [--profile <name>] [--mode copy|symlink|download]
#

set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTOPS_HOME="$(cd "$(dirname "$SCRIPT_DIR")" && pwd)"

# ============================================================================
# Source Library Files
# ============================================================================

# Source in proper order (dependencies first)
source "$SCRIPT_DIR/lib/common.sh"           # Core utilities (logging, file ops)
source "$SCRIPT_DIR/lib/platform.sh"        # Platform detection and package manager
source "$SCRIPT_DIR/lib/prerequisites.sh"   # Prerequisite checking and auto-install
source "$SCRIPT_DIR/lib/profiles.sh"        # Profile management and installation

# Phase 4+ libraries
source "$SCRIPT_DIR/lib/validation.sh"

# ============================================================================
# Argument Parsing
# ============================================================================

PROFILE="${PROFILE:-default}"
INSTALL_MODE="${INSTALL_MODE:-copy}"
AGENTOPS_HOME_OVERRIDE=""
VERIFY_MODE=false
DOCTOR_MODE=false
UPDATE_MODE=false
UNINSTALL_MODE=false
CONFIG_FILE=""
FORCE_UNINSTALL=false

show_help() {
    cat << EOF
AgentOps Framework - Base Installation System

Usage:
  $(basename "$0") [OPTIONS]

Options:
  --help, -h              Show this help message
  --profile, -p <name>    Profile to install (default, product-dev, devops)
  --mode, -m <mode>       Installation mode (copy, symlink, download)
  --config, -c <file>     Configuration file (install.config.json)
  --agentops <path>       Path to agentops repository
  --verify                Validate existing installation
  --doctor                Diagnose installation issues
  --update                Update existing installation
  --uninstall             Remove AgentOps installation
  --force                 Force uninstall without confirmation

Environment Variables:
  AGENTOPS_HOME           Path to agentops repository
  PROFILE                 Profile to install (default: default)
  INSTALL_MODE            Installation mode (default: copy)

Examples:
  $(basename "$0")                        # Interactive install
  $(basename "$0") --profile product-dev  # Install with profile
  $(basename "$0") --mode symlink         # Install with symlink mode
  $(basename "$0") --verify               # Validate installation
  $(basename "$0") --doctor               # Diagnose issues

For more information: https://agentops.dev/docs
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --profile|-p)
                PROFILE="$2"
                shift 2
                ;;
            --mode|-m)
                INSTALL_MODE="$2"
                shift 2
                ;;
            --agentops)
                AGENTOPS_HOME_OVERRIDE="$2"
                shift 2
                ;;
            --verify)
                VERIFY_MODE=true
                shift
                ;;
            --doctor)
                DOCTOR_MODE=true
                shift
                ;;
            --config|-c)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --update)
                UPDATE_MODE=true
                shift
                ;;
            --uninstall)
                UNINSTALL_MODE=true
                shift
                ;;
            --force)
                FORCE_UNINSTALL=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# Configuration Management
# ============================================================================

# Load configuration from install.config.json file
# Arguments: $1 = config file path
# Returns: 0 if loaded successfully, 1 if failed
load_configuration() {
    local config_file="$1"

    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi

    log_info "Loading configuration from $config_file..."

    # Validate JSON syntax
    if ! jq empty "$config_file" 2>/dev/null; then
        log_error "Invalid JSON in configuration file"
        return 1
    fi

    # Load profile (if present)
    local profile_from_config
    profile_from_config=$(jq -r '.profile // empty' "$config_file")
    if [[ -n "$profile_from_config" ]]; then
        PROFILE="$profile_from_config"
        log_step "Profile: $PROFILE (from config)"
    fi

    # Load mode (if present)
    local mode_from_config
    mode_from_config=$(jq -r '.profile_mode // empty' "$config_file")
    if [[ -n "$mode_from_config" ]]; then
        INSTALL_MODE="$mode_from_config"
        log_step "Mode: $INSTALL_MODE (from config)"
    fi

    log_step "Configuration loaded successfully"
    return 0
}

# Interactive configuration prompts (if config not provided or incomplete)
# Returns: 0 if configuration complete, 1 if user cancelled
prompt_configuration() {
    log_info "Interactive configuration..."
    echo ""

    # Prompt for profile if not set
    if [[ -z "$PROFILE" ]] || [[ "$PROFILE" == "default" ]]; then
        log_info "Available profiles:"
        echo "  1) default      - Minimal, universal patterns"
        echo "  2) product-dev  - Product development workflows"
        echo "  3) devops       - Infrastructure/operations workflows"
        echo ""
        echo -n "Select profile (1-3) [1]: " >&2
        read -r profile_choice
        profile_choice="${profile_choice:-1}"

        case "$profile_choice" in
            1) PROFILE="default" ;;
            2) PROFILE="product-dev" ;;
            3) PROFILE="devops" ;;
            *)
                log_warn "Invalid selection, using 'default'"
                PROFILE="default"
                ;;
        esac
        log_step "Profile: $PROFILE"
    fi

    # Prompt for mode if not set
    if [[ -z "$INSTALL_MODE" ]] || [[ "$INSTALL_MODE" == "copy" ]]; then
        echo ""
        log_info "Installation modes:"
        echo "  1) copy     - Copy files (independent, recommended)"
        echo "  2) symlink  - Symlink to agentops repo (live updates)"
        echo ""
        echo -n "Select mode (1-2) [1]: " >&2
        read -r mode_choice
        mode_choice="${mode_choice:-1}"

        case "$mode_choice" in
            1) INSTALL_MODE="copy" ;;
            2) INSTALL_MODE="symlink" ;;
            *)
                log_warn "Invalid selection, using 'copy'"
                INSTALL_MODE="copy"
                ;;
        esac
        log_step "Mode: $INSTALL_MODE"
    fi

    echo ""
    log_success "Configuration complete"
    return 0
}

# ============================================================================
# Update Flow
# ============================================================================

# Update existing installation with latest components
# Returns: 0 if successful, 1 if failed
perform_update() {
    log_info ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Update Workflow"
    log_info "═══════════════════════════════════════════════════════"
    log_info ""

    # Check if installation exists
    if [[ ! -d ".claude" ]]; then
        log_error "No existing installation found"
        log_info "Run 'make install' to install AgentOps first"
        return 1
    fi

    # Backup existing installation
    if ! backup_existing_installation; then
        log_error "Failed to create backup before update"
        return 1
    fi

    # Find agentops repository
    if ! find_agentops_repo; then
        log_error "Cannot update without agentops repository"
        return 1
    fi

    # Re-install profile (preserves customizations via merge strategy)
    log_info "Updating profile components..."
    case "$INSTALL_MODE" in
        copy)
            if ! copy_profile "$PROFILE"; then
                log_error "Failed to update profile"
                return 1
            fi
            ;;
        symlink)
            if ! symlink_profile "$PROFILE"; then
                log_error "Failed to update profile"
                return 1
            fi
            ;;
        *)
            log_error "Unknown installation mode: $INSTALL_MODE"
            return 1
            ;;
    esac

    # Update manifest
    if ! update_manifest ".claude/installed_components.json" "$PROFILE" "$INSTALL_MODE"; then
        log_warn "Failed to update manifest"
    fi

    log_success "Update complete!"
    log_info "Run 'make verify' to validate the update"
    return 0
}

# ============================================================================
# Uninstall Flow
# ============================================================================

# Uninstall AgentOps installation
# Returns: 0 if successful, 1 if failed or cancelled
perform_uninstall() {
    log_info ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Uninstall Workflow"
    log_info "═══════════════════════════════════════════════════════"
    log_info ""

    # Check if installation exists
    if [[ ! -d ".claude" ]] && [[ ! -f "CONSTITUTION.md" ]] && [[ ! -f "CLAUDE.md" ]]; then
        log_warn "No AgentOps installation found"
        return 0
    fi

    # Show what will be removed
    log_warn "This will remove:"
    if [[ -d ".claude" ]]; then
        echo "  - .claude/ directory"
    fi
    if [[ -f "CONSTITUTION.md" ]]; then
        echo "  - CONSTITUTION.md"
    fi
    if [[ -f "CLAUDE.md" ]]; then
        echo "  - CLAUDE.md"
    fi
    if [[ -d ".git/hooks" ]]; then
        echo "  - Git hooks (if installed by AgentOps)"
    fi
    echo ""
    log_info "A backup will be created before removal."
    echo ""

    # Confirm unless --force
    if [[ "$FORCE_UNINSTALL" != "true" ]]; then
        if ! confirm "Are you sure you want to uninstall AgentOps?" "N"; then
            log_info "Uninstall cancelled"
            return 1
        fi
    fi

    # Create backup
    local backup_dir=".claude.backup-uninstall-$(timestamp)"
    log_info "Creating backup at $backup_dir..."

    mkdir -p "$backup_dir"

    if [[ -d ".claude" ]]; then
        cp -r .claude "$backup_dir/" || true
    fi
    if [[ -f "CONSTITUTION.md" ]]; then
        cp CONSTITUTION.md "$backup_dir/" || true
    fi
    if [[ -f "CLAUDE.md" ]]; then
        cp CLAUDE.md "$backup_dir/" || true
    fi

    log_step "Backup created: $backup_dir"

    # Remove components
    log_info "Removing AgentOps components..."

    if [[ -d ".claude" ]]; then
        rm -rf .claude
        log_step "Removed .claude/"
    fi

    if [[ -f "CONSTITUTION.md" ]]; then
        rm -f CONSTITUTION.md
        log_step "Removed CONSTITUTION.md"
    fi

    if [[ -f "CLAUDE.md" ]]; then
        rm -f CLAUDE.md
        log_step "Removed CLAUDE.md"
    fi

    log_info ""
    log_success "Uninstall complete!"
    log_info ""
    log_info "Backup location: $backup_dir/"
    log_info "To restore: cp -r $backup_dir/.claude .claude"
    log_info ""

    return 0
}

# ============================================================================
# Installation Orchestration Functions
# ============================================================================

# Create backup of existing .claude/ directory before installation
# Returns: 0 if successful, 1 if failed
backup_existing_installation() {
    if [[ ! -d ".claude" ]]; then
        return 0  # No backup needed
    fi

    local backup_dir=".claude.backup-$(timestamp)"

    log_warn "Existing .claude/ detected, creating backup..."
    if ! cp -a ".claude" "$backup_dir"; then
        log_error "Failed to backup existing .claude/ directory"
        return 1
    fi

    log_step "Backup created: $backup_dir"
    return 0
}

# Perform full installation workflow
# Orchestrates all installation steps in correct order
# Returns: 0 if successful, 1 if failed
perform_installation() {
    log_info ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Installation Workflow"
    log_info "═══════════════════════════════════════════════════════"
    log_info ""

    # Set AGENTOPS_HOME if not set
    if [[ -z "${AGENTOPS_HOME:-}" ]]; then
        AGENTOPS_HOME="$AGENTOPS_HOME_OVERRIDE"
    fi

    # Find agentops repository
    if ! find_agentops_repo; then
        log_error "Cannot proceed without agentops repository"
        return 1
    fi

    # Detect existing installation
    if detect_existing_installation; then
        if ! backup_existing_installation; then
            log_error "Failed to backup existing installation"
            return 1
        fi
    fi

    # Install base structure
    if ! install_base_structure; then
        log_error "Failed to install base structure"
        return 1
    fi

    # Install selected profile
    case "$INSTALL_MODE" in
        copy)
            if ! copy_profile "$PROFILE"; then
                log_error "Failed to install profile (copy mode)"
                return 1
            fi
            ;;
        symlink)
            if ! symlink_profile "$PROFILE"; then
                log_error "Failed to install profile (symlink mode)"
                return 1
            fi
            ;;
        download)
            if ! download_profile "$PROFILE"; then
                log_error "Failed to install profile (download mode)"
                return 1
            fi
            ;;
        *)
            log_error "Unknown installation mode: $INSTALL_MODE"
            return 1
            ;;
    esac

    # Install root files
    if ! install_root_files "$(realpath "$SCRIPT_DIR/templates")"; then
        log_error "Failed to install root files"
        return 1
    fi

    # Install git hooks (if applicable)
    if ! install_git_hooks "$(realpath "$SCRIPT_DIR/templates")"; then
        log_warn "Git hooks installation encountered issues"
    fi

    # Update manifest
    if ! update_manifest ".claude/installed_components.json" "$PROFILE" "$INSTALL_MODE"; then
        log_warn "Failed to update manifest"
    fi

    log_info ""
    return 0
}

# ============================================================================
# Diagnostics Mode
# ============================================================================

# Run comprehensive diagnostics to help troubleshoot issues
# Returns: 0 if no issues, 1 if issues found
run_diagnostics() {
    log_info ""
    log_info "╔════════════════════════════════════════════════════════╗"
    log_info "║   AgentOps Installation Diagnostics (make doctor)     ║"
    log_info "╚════════════════════════════════════════════════════════╝"
    log_info ""

    local issues_found=0

    # Run all validation checks
    if ! validate_installation; then
        issues_found=$((issues_found + 1))
    fi

    # Additional diagnostic information
    echo ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Environment Information"
    log_info "═══════════════════════════════════════════════════════"
    echo ""

    # Platform info
    log_info "Platform:"
    log_info "  OS:              $DETECTED_OS"
    log_info "  Distribution:    $DETECTED_DISTRO"
    log_info "  Architecture:    $DETECTED_ARCH"
    log_info "  Package Manager: $DETECTED_PKG_MANAGER"
    log_info "  WSL:             $IS_WSL"
    echo ""

    # Shell info
    log_info "Shell:"
    log_info "  Current shell:   $SHELL"
    log_info "  Bash version:    $BASH_VERSION"
    echo ""

    # Environment variables
    log_info "Environment Variables:"
    log_info "  AGENTOPS_HOME:   ${AGENTOPS_HOME:-not set}"
    log_info "  HOME:            ${HOME:-not set}"
    log_info "  PATH:            ${PATH:-not set}"
    echo ""

    # File permissions
    if [[ -d ".claude" ]]; then
        log_info "File Permissions:"
        log_info "  .claude/:        $(ls -ld .claude | awk '{print $1}')"
        if [[ -f ".claude/settings.json" ]]; then
            log_info "  settings.json:   $(ls -l .claude/settings.json | awk '{print $1}')"
        fi
    fi
    echo ""

    log_info "═══════════════════════════════════════════════════════"
    if [[ $issues_found -eq 0 ]]; then
        log_success "Status: All systems healthy ✅"
    else
        log_warn "Status: $issues_found issue(s) detected"
        log_info ""
        log_info "Suggested actions:"
        log_info "  1. Review errors above"
        log_info "  2. Check file permissions"
        log_info "  3. Verify prerequisites are installed"
        log_info "  4. Re-run installation: make install"
    fi
    log_info "═══════════════════════════════════════════════════════"
    echo ""

    return $issues_found
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    local exit_code=0

    # Parse command-line arguments
    parse_arguments "$@"

    # Override AGENTOPS_HOME if specified
    if [[ -n "$AGENTOPS_HOME_OVERRIDE" ]]; then
        AGENTOPS_HOME="$AGENTOPS_HOME_OVERRIDE"
    fi

    # Handle --verify mode
    if [[ "$VERIFY_MODE" == "true" ]]; then
        validate_installation
        return $?
    fi

    # Handle --doctor mode
    if [[ "$DOCTOR_MODE" == "true" ]]; then
        run_diagnostics
        return $?
    fi

    # Handle --update mode
    if [[ "$UPDATE_MODE" == "true" ]]; then
        perform_update
        return $?
    fi

    # Handle --uninstall mode
    if [[ "$UNINSTALL_MODE" == "true" ]]; then
        perform_uninstall
        return $?
    fi

    # Normal installation flow
    log_info ""
    log_info "╔════════════════════════════════════════════════════════╗"
    log_info "║   AgentOps Framework Installation (Phase 1-5 Ready)   ║"
    log_info "╚════════════════════════════════════════════════════════╝"
    log_info ""

    # Load configuration file if specified
    if [[ -n "$CONFIG_FILE" ]]; then
        if ! load_configuration "$CONFIG_FILE"; then
            log_error "Failed to load configuration file"
            return 1
        fi
    else
        # Interactive configuration prompts
        if ! prompt_configuration; then
            log_error "Configuration cancelled"
            return 1
        fi
    fi

    log_info ""
    log_info "Configuration:"
    log_info "  AGENTOPS_HOME: $AGENTOPS_HOME"
    log_info "  Profile:       $PROFILE"
    log_info "  Mode:          $INSTALL_MODE"
    log_info ""

    # Check prerequisites (Phase 2 - implemented)
    if ! check_prerequisites; then
        log_error "Installation aborted: prerequisite checks failed"
        return 1
    fi

    # Perform installation (Phase 3 - implemented)
    if ! perform_installation; then
        log_error "Installation failed"
        return 1
    fi

    # Phase 4: Validation
    log_info ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Running post-install validation..."
    log_info "═══════════════════════════════════════════════════════"

    if ! validate_installation; then
        log_warn "Validation found issues, but installation completed"
        log_info "Run 'make doctor' for detailed diagnostics"
    fi

    return $exit_code
}

# ============================================================================
# Error Handling
# ============================================================================

error_handler() {
    local line_number=$1
    log_error "Installation failed at line $line_number"
    log_error "Run 'make doctor' to diagnose issues"
    exit 1
}

trap 'error_handler $LINENO' ERR

# ============================================================================
# Run Main
# ============================================================================

main "$@"
