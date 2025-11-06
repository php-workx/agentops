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

# Phase 3+ libraries (to be sourced when implemented)
# source "$SCRIPT_DIR/lib/profiles.sh"
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
# Main Installation Flow (Stub)
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
    log_info "║   AgentOps Framework Installation (Phase 1-2 Ready)   ║"
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

    log_info ""
    log_step "Loading configuration (Phase 3)"
    log_step "Detecting existing installation (Phase 3)"
    log_step "Installing base structure (Phase 3)"
    log_step "Installing profile (Phase 3)"
    log_step "Installing root files (Phase 3)"
    log_step "Installing git hooks (Phase 3)"
    log_step "Validating installation (Phase 4)"

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
