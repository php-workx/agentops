#!/usr/bin/env bash
# Prerequisites Checking and Auto-Installation
# Checks for required tools (Git, Claude Code, Python/uv) and handles auto-installation
#
# Exported functions:
#   check_git()           - Verify Git 2.30+ is installed
#   check_claude_code()   - Verify Claude Code CLI is installed
#   check_python_uv()     - Verify Python 3.9+ and uv are installed
#   install_uv()          - Auto-install uv and Python
#   prompt_install()      - Ask user before auto-installing tools
#   check_prerequisites() - Main coordinator function

set -euo pipefail

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/platform.sh"

# ============================================================================
# Git Prerequisite Checking
# ============================================================================

# Check if Git is installed and meets minimum version requirement
# Minimum version: 2.30.0
# Returns: 0 if OK, 1 if missing or too old
check_git() {
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed"
        log_info "Install Git:"
        log_info "  macOS:  brew install git"
        log_info "  Ubuntu: sudo apt-get install git"
        log_info "  Fedora: sudo dnf install git"
        log_info "  Arch:   sudo pacman -S git"
        return 1
    fi

    local git_version
    git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "0.0.0")

    if ! version_compare "$git_version" ">=" "2.30.0"; then
        log_error "Git version too old: $git_version (requires >= 2.30.0)"
        log_info "Update Git:"
        log_info "  macOS:  brew upgrade git"
        log_info "  Ubuntu: sudo apt-get upgrade git"
        return 1
    fi

    log_step "Git found: v$git_version"
    return 0
}

# ============================================================================
# Claude Code CLI Prerequisite Checking
# ============================================================================

# Check if Claude Code CLI is installed
# Returns: 0 if installed, 1 if not
check_claude_code() {
    local claude_cmd

    # Try different possible command names
    for cmd in claude claude-code cc; do
        if command -v "$cmd" &> /dev/null; then
            claude_cmd="$cmd"
            break
        fi
    done

    if [[ -z "${claude_cmd:-}" ]]; then
        log_error "Claude Code CLI is not installed"
        log_info "Install Claude Code: https://docs.claude.com/en/docs/claude-code/install"
        log_info ""
        log_info "Claude Code is required for AgentOps to function. It must be installed"
        log_info "before running the AgentOps installation system."
        return 1
    fi

    local version
    version=$("$claude_cmd" --version 2>/dev/null || echo "unknown")
    log_step "Claude Code found: $version"
    return 0
}

# ============================================================================
# Python and uv Prerequisite Checking
# ============================================================================

# Check if Python 3.9+ and uv are installed
# Returns: 0 if both present, 1 if missing
check_python_uv() {
    local python_version=""
    local uv_installed=false

    # Check Python version
    if command -v python3 &> /dev/null; then
        python_version=$(python3 --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' || echo "")
    elif command -v python &> /dev/null; then
        python_version=$(python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' || echo "")
    fi

    if [[ -z "$python_version" ]] || ! version_compare "$python_version" ">=" "3.9"; then
        log_warn "Python 3.9+ not found or too old (found: ${python_version:-not installed})"
    else
        log_step "Python found: v$python_version"
    fi

    # Check uv
    if command -v uv &> /dev/null; then
        local uv_version
        uv_version=$(uv --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        log_step "uv found: v$uv_version"
        uv_installed=true
    else
        log_warn "uv is not installed"
    fi

    # Both Python 3.9+ and uv are required
    if [[ "$uv_installed" == "true" ]] && [[ -n "$python_version" ]]; then
        return 0
    fi

    return 1
}

# ============================================================================
# Auto-Installation Functions
# ============================================================================

# Install uv (cross-platform Rust-based tool installer)
# Installs Python 3.11 via uv as well
# Returns: 0 if successful, 1 if failed
install_uv() {
    log_info "Installing uv (Python tool) and Python 3.11..."

    local uv_install_url="https://astral.sh/uv/install.sh"
    local temp_script="/tmp/install-uv-$$.sh"

    # Download install script
    if ! curl -fsSL "$uv_install_url" -o "$temp_script"; then
        log_error "Failed to download uv installer from $uv_install_url"
        rm -f "$temp_script"
        return 1
    fi

    # Run installer
    if ! bash "$temp_script"; then
        log_error "Failed to run uv installer"
        rm -f "$temp_script"
        return 1
    fi

    rm -f "$temp_script"

    # Update PATH for current session
    if [[ -f "$HOME/.local/bin/uv" ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    # Verify installation
    if ! command -v uv &> /dev/null; then
        log_error "uv installation failed - command not found in PATH"
        return 1
    fi

    log_step "uv installed successfully"

    # Install Python 3.11 via uv
    log_info "Installing Python 3.11 via uv..."
    if ! uv python install 3.11; then
        log_warn "Python installation via uv had issues, but continuing..."
    else
        log_step "Python 3.11 installed successfully"
    fi

    return 0
}

# ============================================================================
# User Prompting
# ============================================================================

# Prompt user for permission to auto-install missing tools
# Arguments: $1 = tool name
# Returns: 0 if user approves, 1 if user declines
prompt_install() {
    local tool="$1"

    echo ""
    log_warn "$tool needs to be installed"
    echo ""
    log_info "We can automatically install $tool for you, or you can install it manually."
    echo ""

    confirm "Install $tool now?" "Y" && return 0 || return 1
}

# ============================================================================
# Main Coordinator
# ============================================================================

# Main prerequisite checking function
# Checks all prerequisites, prompts for auto-installation when needed
# Returns: 0 if all prerequisites met, 1 if critical failure, 2 if some failures
check_prerequisites() {
    local failed_count=0
    local warnings_count=0

    log_info ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  Checking Prerequisites"
    log_info "═══════════════════════════════════════════════════════"
    log_info ""

    # Check Git (required)
    if ! check_git; then
        failed_count=$((failed_count + 1))
        log_error "Git is required - cannot continue"
    fi

    echo ""

    # Check Claude Code (required)
    if ! check_claude_code; then
        failed_count=$((failed_count + 1))
        log_error "Claude Code CLI is required - cannot continue"
    fi

    echo ""

    # Check Python/uv (required, can auto-install)
    if ! check_python_uv; then
        warnings_count=$((warnings_count + 1))

        if prompt_install "uv and Python 3.11"; then
            if ! install_uv; then
                failed_count=$((failed_count + 1))
                log_error "Failed to install uv - cannot continue"
            else
                # Verify installation
                if check_python_uv; then
                    log_step "Python/uv check passed after installation"
                else
                    failed_count=$((failed_count + 1))
                    log_error "Python/uv verification failed after installation"
                fi
            fi
        else
            failed_count=$((failed_count + 1))
            log_error "uv and Python 3.11 are required - cannot continue"
        fi
    fi

    echo ""
    log_info "═══════════════════════════════════════════════════════"

    if [[ $failed_count -gt 0 ]]; then
        log_error "Prerequisites check failed: $failed_count critical issue(s)"
        echo ""
        return 1
    fi

    if [[ $warnings_count -gt 0 ]]; then
        log_warn "Prerequisites check completed with $warnings_count warning(s)"
        echo ""
        return 0
    fi

    log_success "All prerequisites met!"
    echo ""
    return 0
}

# ============================================================================
# Utility Functions
# ============================================================================

# Verify a specific version requirement
# Arguments: $1 = tool name, $2 = actual version, $3 = minimum version
# Returns: 0 if version OK, 1 if too old
verify_version() {
    local tool_name="$1"
    local actual_version="$2"
    local minimum_version="$3"

    if version_compare "$actual_version" ">=" "$minimum_version"; then
        return 0
    else
        log_error "$tool_name version $actual_version is below minimum required ($minimum_version)"
        return 1
    fi
}
