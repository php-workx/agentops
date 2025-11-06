#!/usr/bin/env bash
# Profile Management and Installation
# Handles profile detection, validation, installation modes, and settings merge
#
# Exported functions:
#   find_agentops_repo()        - Locate agentops repository
#   list_profiles()             - List available profiles (local or remote)
#   validate_profile()          - Check profile structure validity
#   copy_profile()              - Install profile via copy mode
#   symlink_profile()           - Install profile via symlink mode
#   download_profile()          - Install profile via download mode
#   prompt_profile_selection()  - Interactive profile selection
#   prompt_profile_mode()       - Interactive installation mode selection
#   merge_settings()            - Deep merge JSON settings
#   update_manifest()           - Track installed components
#   detect_existing_installation() - Check for existing .claude/ setup

set -euo pipefail

# Source required libraries
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# ============================================================================
# Global Variables
# ============================================================================

AGENTOPS_REPO_ROOT=""           # Root of agentops repository
INSTALLED_PROFILE=""            # Profile currently being installed
INSTALLED_MODE=""               # Mode used for installation
EXISTING_INSTALL_DETECTED=false # Whether existing .claude/ found
EXISTING_MANIFEST=""            # Path to existing manifest if found

# ============================================================================
# Repository Detection
# ============================================================================

# Find the agentops repository
# Searches common locations: $AGENTOPS_HOME env var, parent directories, common paths
# Returns: 0 if found, 1 if not found
# Sets: AGENTOPS_REPO_ROOT global variable
find_agentops_repo() {
    # Check environment variable first
    if [[ -n "${AGENTOPS_HOME:-}" ]] && [[ -d "$AGENTOPS_HOME/profiles" ]]; then
        AGENTOPS_REPO_ROOT="$AGENTOPS_HOME"
        log_step "Found agentops repo via AGENTOPS_HOME: $AGENTOPS_REPO_ROOT"
        return 0
    fi

    # Check if we're already inside agentops repo
    local current_dir="$(pwd)"
    while [[ "$current_dir" != "/" ]]; do
        if [[ -d "$current_dir/profiles" ]] && [[ -d "$current_dir/scripts" ]]; then
            AGENTOPS_REPO_ROOT="$current_dir"
            log_step "Found agentops repo in parent directory: $AGENTOPS_REPO_ROOT"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done

    # Check common installation locations
    local common_paths=(
        "$HOME/workspace/agentops"
        "$HOME/dev/agentops"
        "$HOME/projects/agentops"
        "/opt/agentops"
        "/usr/local/agentops"
    )

    for path in "${common_paths[@]}"; do
        if [[ -d "$path/profiles" ]] && [[ -d "$path/scripts" ]]; then
            AGENTOPS_REPO_ROOT="$path"
            log_step "Found agentops repo at common location: $AGENTOPS_REPO_ROOT"
            return 0
        fi
    done

    log_error "Could not find agentops repository"
    log_info "Specify location with: --agentops /path/to/agentops"
    return 1
}

# ============================================================================
# Profile Listing
# ============================================================================

# List available profiles from local agentops repository
# Returns: space-separated list of profile names
list_profiles() {
    if [[ -z "$AGENTOPS_REPO_ROOT" ]]; then
        if ! find_agentops_repo; then
            return 1
        fi
    fi

    local profiles_dir="$AGENTOPS_REPO_ROOT/profiles"

    if [[ ! -d "$profiles_dir" ]]; then
        log_error "Profiles directory not found: $profiles_dir"
        return 1
    fi

    # List top-level directories in profiles/
    local profiles=()
    for dir in "$profiles_dir"/*/; do
        if [[ -d "$dir" ]]; then
            profiles+=("$(basename "$dir")")
        fi
    done

    if [[ ${#profiles[@]} -eq 0 ]]; then
        log_error "No profiles found in $profiles_dir"
        return 1
    fi

    echo "${profiles[@]}"
}

# ============================================================================
# Profile Validation
# ============================================================================

# Validate profile structure
# Arguments: $1 = profile name
# Returns: 0 if valid, 1 if invalid
validate_profile() {
    local profile_name="$1"

    if [[ -z "$AGENTOPS_REPO_ROOT" ]]; then
        if ! find_agentops_repo; then
            return 1
        fi
    fi

    local profile_path="$AGENTOPS_REPO_ROOT/profiles/$profile_name"

    # Check profile directory exists
    if [[ ! -d "$profile_path" ]]; then
        log_error "Profile not found: $profile_name"
        return 1
    fi

    # Check for required subdirectories
    local required_dirs=("agents" "commands" "skills")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$profile_path/$dir" ]]; then
            log_error "Profile $profile_name missing required directory: $dir"
            return 1
        fi
    done

    # Check for settings.json
    if [[ ! -f "$profile_path/settings.json" ]]; then
        log_error "Profile $profile_name missing settings.json"
        return 1
    fi

    # Validate settings.json is valid JSON
    if ! jq empty "$profile_path/settings.json" 2>/dev/null; then
        log_error "Profile $profile_name has invalid settings.json"
        return 1
    fi

    log_step "Profile validated: $profile_name"
    return 0
}

# ============================================================================
# Profile Installation Modes
# ============================================================================

# Install profile via copy mode (copy files to target)
# Arguments: $1 = profile name, $2 = target directory (default: .claude)
# Returns: 0 if successful, 1 if failed
copy_profile() {
    local profile_name="$1"
    local target_dir="${2:-.claude}"

    if [[ -z "$AGENTOPS_REPO_ROOT" ]]; then
        if ! find_agentops_repo; then
            return 1
        fi
    fi

    if ! validate_profile "$profile_name"; then
        return 1
    fi

    local profile_path="$AGENTOPS_REPO_ROOT/profiles/$profile_name"
    local items=("agents" "commands" "skills")

    log_info "Installing profile (copy mode): $profile_name"

    # Create target directory if needed
    mkdir_safe "$target_dir" || return 1

    # Copy profile items (don't overwrite existing user files)
    for item in "${items[@]}"; do
        local src="$profile_path/$item"
        local dst="$target_dir/$item"

        if [[ ! -d "$src" ]]; then
            continue
        fi

        if [[ -d "$dst" ]]; then
            log_warn "Target $dst already exists, merging with profile..."
        else
            mkdir_safe "$dst" || return 1
        fi

        # Copy files, skip if destination exists (user customization preserved)
        find "$src" -type f | while read -r src_file; do
            local rel_path="${src_file#$src/}"
            local dst_file="$dst/$rel_path"

            if [[ ! -f "$dst_file" ]]; then
                mkdir -p "$(dirname "$dst_file")"
                cp "$src_file" "$dst_file"
            fi
        done
    done

    log_step "Profile installed via copy: $profile_name"
    INSTALLED_PROFILE="$profile_name"
    INSTALLED_MODE="copy"
    return 0
}

# Install profile via symlink mode (link to profile in agentops repo)
# Arguments: $1 = profile name, $2 = target directory (default: .claude)
# Returns: 0 if successful, 1 if failed
symlink_profile() {
    local profile_name="$1"
    local target_dir="${2:-.claude}"

    if [[ -z "$AGENTOPS_REPO_ROOT" ]]; then
        if ! find_agentops_repo; then
            return 1
        fi
    fi

    if ! validate_profile "$profile_name"; then
        return 1
    fi

    local profile_path="$AGENTOPS_REPO_ROOT/profiles/$profile_name"
    local items=("agents" "commands" "skills")

    log_info "Installing profile (symlink mode): $profile_name"

    # Create target directory if needed
    mkdir_safe "$target_dir" || return 1

    # Create symlinks for each item
    for item in "${items[@]}"; do
        local src="$profile_path/$item"
        local dst="$target_dir/$item"

        if [[ ! -d "$src" ]]; then
            continue
        fi

        # Remove existing symlink or directory
        if [[ -L "$dst" ]]; then
            rm "$dst"
        elif [[ -d "$dst" ]]; then
            log_warn "Directory $dst already exists, not symlinking"
            continue
        fi

        # Create symlink (use absolute paths)
        ln -s "$(get_absolute_path "$src")" "$dst"
    done

    log_step "Profile installed via symlink: $profile_name"
    INSTALLED_PROFILE="$profile_name"
    INSTALLED_MODE="symlink"
    return 0
}

# Install profile via download mode (download from GitHub release)
# Arguments: $1 = profile name, [$2 = version (default: latest)], [$3 = target dir]
# Returns: 0 if successful, 1 if failed
download_profile() {
    local profile_name="$1"
    local version="${2:-latest}"
    local target_dir="${3:-.claude}"

    log_info "Installing profile (download mode): $profile_name (version: $version)"

    # For now, download mode is a stub - it requires GitHub API integration
    # which is deferred to Phase 3+ implementation
    log_warn "Download mode is not fully implemented in Phase 3"
    log_info "Use copy or symlink mode instead"

    return 1
}

# ============================================================================
# Interactive Selection
# ============================================================================

# Prompt user to select a profile
# Returns: selected profile name, or exits if cancelled
prompt_profile_selection() {
    local profiles
    profiles=$(list_profiles) || {
        log_error "No profiles available"
        return 1
    }

    echo ""
    log_info "Available profiles:"
    local profile_array=($profiles)
    for i in "${!profile_array[@]}"; do
        echo "  $((i + 1))) ${profile_array[$i]}"
    done

    echo ""
    echo -n "Select profile (1-${#profile_array[@]}): " >&2
    read -r selection

    # Validate selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || \
       [[ $selection -lt 1 ]] || \
       [[ $selection -gt ${#profile_array[@]} ]]; then
        log_error "Invalid selection"
        return 1
    fi

    # Return selected profile (array is 0-indexed)
    echo "${profile_array[$((selection - 1))]}"
}

# Prompt user to select installation mode
# Returns: selected mode (copy, symlink, or download)
prompt_profile_mode() {
    echo ""
    log_info "Installation modes:"
    echo "  1) copy     - Copy profile files to .claude/ (safest, independent)"
    echo "  2) symlink  - Symlink to agentops repo (fast, live updates, requires repo)"
    echo "  3) download - Download from GitHub (independent, requires network)"

    echo ""
    echo -n "Select installation mode (1-3) [1]: " >&2
    read -r selection
    selection="${selection:-1}"

    case "$selection" in
        1)
            echo "copy"
            ;;
        2)
            echo "symlink"
            ;;
        3)
            echo "download"
            ;;
        *)
            log_error "Invalid selection"
            return 1
            ;;
    esac
}

# ============================================================================
# Settings Management
# ============================================================================

# Deep merge two JSON objects
# Arguments: $1 = base JSON file, $2 = override JSON file, [$3 = output file]
# Returns: 0 if successful, 1 if failed
merge_settings() {
    local base_file="$1"
    local override_file="$2"
    local output_file="${3:-}"

    if [[ ! -f "$base_file" ]]; then
        log_error "Base settings file not found: $base_file"
        return 1
    fi

    if [[ ! -f "$override_file" ]]; then
        log_error "Override settings file not found: $override_file"
        return 1
    fi

    # Validate both are valid JSON
    if ! jq empty "$base_file" 2>/dev/null; then
        log_error "Invalid JSON in base settings: $base_file"
        return 1
    fi

    if ! jq empty "$override_file" 2>/dev/null; then
        log_error "Invalid JSON in override settings: $override_file"
        return 1
    fi

    # Deep merge using jq (override takes precedence)
    local merged
    merged=$(jq -s '.[0] * .[1]' "$base_file" "$override_file" 2>/dev/null) || return 1

    if [[ -n "$output_file" ]]; then
        # Write to file
        echo "$merged" | jq '.' > "$output_file"
        log_step "Settings merged to: $output_file"
    else
        # Output to stdout
        echo "$merged"
    fi

    return 0
}

# ============================================================================
# Installation Manifest
# ============================================================================

# Update installation manifest tracking what was installed
# Arguments: $1 = manifest path, [$2 = profile name], [$3 = mode]
# Returns: 0 if successful, 1 if failed
update_manifest() {
    local manifest_path="$1"
    local profile="${2:-${INSTALLED_PROFILE:-unknown}}"
    local mode="${3:-${INSTALLED_MODE:-unknown}}"
    local timestamp
    timestamp=$(timestamp)

    # Create or update manifest
    local manifest_content
    manifest_content=$(cat <<EOF
{
  "installed_at": "$timestamp",
  "profile": "$profile",
  "mode": "$mode",
  "version": "1.0.0",
  "agentops_version": "1.0.0"
}
EOF
)

    echo "$manifest_content" | jq '.' > "$manifest_path" || return 1
    log_step "Installation manifest updated: $manifest_path"
    return 0
}

# ============================================================================
# Existing Installation Detection
# ============================================================================

# Detect if AgentOps is already installed
# Returns: 0 if existing install found, 1 if new install
detect_existing_installation() {
    local claude_dir=".claude"

    if [[ ! -d "$claude_dir" ]]; then
        EXISTING_INSTALL_DETECTED=false
        return 1
    fi

    EXISTING_INSTALL_DETECTED=true

    # Check for manifest
    if [[ -f "$claude_dir/installed_components.json" ]]; then
        EXISTING_MANIFEST="$claude_dir/installed_components.json"
        log_warn "Existing installation detected at: $claude_dir"
        log_info "Manifest: $EXISTING_MANIFEST"
        return 0
    fi

    log_warn "Existing .claude/ directory found (no manifest)"
    return 0
}

# ============================================================================
# Base Structure Installation
# ============================================================================

# Install base .claude/ directory structure
# Arguments: [$1 = target directory (default: .claude)]
# Returns: 0 if successful, 1 if failed
install_base_structure() {
    local target_dir="${1:-.claude}"

    log_info "Installing base .claude/ structure"

    # Create directory structure
    mkdir_safe "$target_dir" || return 1

    local subdirs=("agents" "commands" "skills")
    for subdir in "${subdirs[@]}"; do
        mkdir_safe "$target_dir/$subdir" || return 1
    done

    # Create/update README.md
    local readme_path="$target_dir/README.md"
    if [[ ! -f "$readme_path" ]]; then
        cp "scripts/templates/.claude/README.md" "$readme_path" || return 1
    fi

    # Create/merge settings.json
    local settings_path="$target_dir/settings.json"
    if [[ ! -f "$settings_path" ]]; then
        cp "scripts/templates/.claude/settings.json" "$settings_path" || return 1
    else
        log_warn ".claude/settings.json already exists, backing up"
        backup_file "$settings_path" > /dev/null || true
    fi

    log_step "Base structure installed: $target_dir"
    return 0
}

# ============================================================================
# Root Files Installation
# ============================================================================

# Install root files (CONSTITUTION.md, CLAUDE.md)
# Arguments: [$1 = template base path], [$2 = overwrite mode (true/false)]
# Returns: 0 if successful, 1 if failed
install_root_files() {
    local template_base="${1:-scripts/templates}"
    local overwrite="${2:-false}"
    local project_name="$(basename "$(pwd)")"

    log_info "Installing root files (CONSTITUTION.md, CLAUDE.md)"

    # Install CONSTITUTION.md
    if [[ -f "CONSTITUTION.md" ]] && [[ "$overwrite" != "true" ]]; then
        log_warn "CONSTITUTION.md already exists, skipping (use --force to overwrite)"
    else
        cp "$template_base/CONSTITUTION.md" "CONSTITUTION.md" || return 1
        log_step "Installed: CONSTITUTION.md"
    fi

    # Install CLAUDE.md
    if [[ -f "CLAUDE.md" ]] && [[ "$overwrite" != "true" ]]; then
        log_warn "CLAUDE.md already exists, skipping (use --force to overwrite)"
    else
        # Substitute project name in template
        sed "s/\${PROJECT_NAME}/$project_name/g" \
            "$template_base/CLAUDE.md" > "CLAUDE.md" || return 1
        log_step "Installed: CLAUDE.md"
    fi

    return 0
}

# ============================================================================
# Git Hooks Installation
# ============================================================================

# Install git hooks if in a git repository
# Arguments: [$1 = hooks base path], [$2 = install hooks (true/false)]
# Returns: 0 if successful (or not applicable), 1 if failed
install_git_hooks() {
    local hooks_base="${1:-scripts/templates}"
    local install_hooks="${2:-true}"

    # Check if we're in a git repo
    if [[ ! -d ".git" ]]; then
        log_warn "Not in a git repository, skipping git hooks"
        return 0
    fi

    if [[ "$install_hooks" != "true" ]]; then
        log_info "Git hooks installation disabled via --no-hooks"
        return 0
    fi

    log_info "Installing git hooks"

    # For Phase 3, we stub git hooks installation
    # Full implementation in Phase 5 with actual hook templates
    log_warn "Git hooks installation deferred to Phase 5 (stub mode)"

    return 0
}
