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

# Phase 4+ libraries (to be sourced when implemented)
# source "$SCRIPT_DIR/lib/validation.sh"

# ============================================================================
# Argument Parsing
# ============================================================================

PROFILE="${PROFILE:-default}"
INSTALL_MODE="${INSTALL_MODE:-copy}"
AGENTOPS_HOME_OVERRIDE=""

show_help() {
    cat << EOF
AgentOps Framework - Base Installation System

Usage:
  $(basename "$0") [OPTIONS]

Options:
  --help, -h              Show this help message
  --profile, -p <name>    Profile to install (default, product-dev, devops)
  --mode, -m <mode>       Installation mode (copy, symlink, download)
  --agentops <path>       Path to agentops repository

Environment Variables:
  AGENTOPS_HOME           Path to agentops repository
  PROFILE                 Profile to install (default: default)
  INSTALL_MODE            Installation mode (default: copy)

Examples:
  $(basename "$0")
  $(basename "$0") --profile product-dev
  $(basename "$0") --mode symlink
  $(basename "$0") --agentops /path/to/agentops

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
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
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

    log_info ""
    log_info "╔════════════════════════════════════════════════════════╗"
    log_info "║   AgentOps Framework Installation (Phase 1-3 Ready)   ║"
    log_info "╚════════════════════════════════════════════════════════╝"
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

    # Phase 4 (Validation) will be called here when implemented
    # if ! validate_installation; then
    #     log_error "Validation failed"
    #     return 1
    # fi

    log_info ""
    log_success "Installation Complete!"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Try an agent:  /prime-simple-task"
    log_info "  2. Read docs:     cat .claude/README.md"
    log_info "  3. Verify setup:  make verify"
    log_info ""

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
