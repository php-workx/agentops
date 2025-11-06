#!/usr/bin/env bash
# Common Utility Functions
# Shared logging, error handling, file operations, and utility functions
#
# Exported functions:
#   log()              - Standard info logging
#   log_step()         - Log an installation step (with ✓ prefix)
#   log_error()        - Log an error message (to stderr with ✗ prefix)
#   log_warn()         - Log a warning message
#   log_info()         - Log informational message (to stderr with ℹ  prefix)
#   error_exit()       - Log error and exit with code
#   backup_file()      - Backup a file with timestamp
#   timestamp()        - Generate a timestamp for filenames
#   file_size()        - Get human-readable file size
#   confirm()          - Ask user for yes/no confirmation
#   get_relative_path() - Convert absolute path to relative

set -euo pipefail

# ============================================================================
# Color Codes (for future enhancement)
# ============================================================================

# Color support detection
if [[ -t 1 ]] && command -v tput &> /dev/null; then
    USE_COLORS=true
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    RESET=$(tput sgr0)
else
    USE_COLORS=false
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    RESET=""
fi

# ============================================================================
# Logging Functions
# ============================================================================

# Log a standard informational message
# Arguments: $* = message text
log() {
    echo "ℹ  $*" >&2
}

# Log an installation step (checkmark prefix)
# Arguments: $* = step description
log_step() {
    echo "✓ $*"
}

# Log an error message
# Arguments: $* = error description
log_error() {
    echo "${RED}✗ $*${RESET}" >&2
}

# Log a warning message
# Arguments: $* = warning description
log_warn() {
    echo "${YELLOW}⚠ $*${RESET}" >&2
}

# Log informational message (verbose)
# Arguments: $* = information text
log_info() {
    echo "ℹ  $*" >&2
}

# Log success message
# Arguments: $* = success description
log_success() {
    echo "${GREEN}✅ $*${RESET}"
}

# Log an error message and exit
# Arguments: $1 = exit code, $2... = error message
error_exit() {
    local exit_code="${1:-1}"
    shift
    log_error "$@"
    exit "$exit_code"
}

# ============================================================================
# File Operations
# ============================================================================

# Generate a timestamp for backups
# Returns: timestamp string (YYYYMMDD-HHMMSS)
timestamp() {
    date +%Y%m%d-%H%M%S
}

# Backup a file with timestamp suffix
# Arguments: $1 = file path
# Returns: backup file path, or empty if file doesn't exist
backup_file() {
    local file_path="$1"
    local backup_path

    if [[ ! -e "$file_path" ]]; then
        return 0
    fi

    # Create backup with timestamp
    backup_path="${file_path}.backup.$(timestamp)"
    cp -a "$file_path" "$backup_path"
    log_step "Backed up: $file_path → $backup_path"
    echo "$backup_path"
}

# Get human-readable file size
# Arguments: $1 = file path
# Returns: human-readable size (e.g., "1.2 MB")
file_size() {
    local file_path="$1"

    if [[ ! -e "$file_path" ]]; then
        echo "0 B"
        return
    fi

    if [[ "$(uname -s)" == "Darwin" ]]; then
        # macOS stat
        stat -f%z "$file_path" | numfmt --to=iec-i --suffix=B 2>/dev/null || \
            stat -f%z "$file_path"
    else
        # Linux stat
        stat -c%s "$file_path" | numfmt --to=iec-i --suffix=B 2>/dev/null || \
            stat -c%s "$file_path"
    fi
}

# ============================================================================
# File Existence Checks
# ============================================================================

# Check if a file exists and is readable
# Arguments: $1 = file path
# Returns: 0 if exists and readable, 1 otherwise
file_exists() {
    [[ -f "$1" ]] && [[ -r "$1" ]]
}

# Check if a directory exists and is readable
# Arguments: $1 = directory path
# Returns: 0 if exists and readable, 1 otherwise
dir_exists() {
    [[ -d "$1" ]] && [[ -r "$1" ]]
}

# ============================================================================
# User Interaction
# ============================================================================

# Ask user for yes/no confirmation
# Arguments: $1 = prompt text, [$2 = default (Y/n)]
# Returns: 0 for yes, 1 for no
confirm() {
    local prompt="$1"
    local default="${2:-Y}"
    local response

    while true; do
        if [[ "$default" == "Y" ]] || [[ "$default" == "y" ]]; then
            echo -n "$prompt [Y/n]: " >&2
        else
            echo -n "$prompt [y/N]: " >&2
        fi

        read -r response
        response="${response:-$default}"

        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                log_warn "Please answer yes or no"
                ;;
        esac
    done
}

# Prompt for user input with validation
# Arguments: $1 = prompt text, [$2 = default value], [$3 = validation function]
# Returns: user input or default if empty
prompt_input() {
    local prompt="$1"
    local default="${2:-}"
    local validator="${3:-}"
    local response

    while true; do
        if [[ -n "$default" ]]; then
            echo -n "$prompt [$default]: " >&2
        else
            echo -n "$prompt: " >&2
        fi

        read -r response
        response="${response:-$default}"

        # Validate if validator function provided
        if [[ -n "$validator" ]] && ! $validator "$response"; then
            log_warn "Invalid input: $response"
            continue
        fi

        echo "$response"
        return 0
    done
}

# ============================================================================
# Path Operations
# ============================================================================

# Convert absolute path to relative path
# Arguments: $1 = absolute path, [$2 = base path (default: current directory)]
# Returns: relative path
get_relative_path() {
    local target="$1"
    local base="${2:-.}"
    local base_abs
    base_abs="$(cd "$base" && pwd)"

    # Remove trailing slashes
    target="${target%/}"
    base_abs="${base_abs%/}"

    # If target is under base, make it relative
    if [[ "$target" == "$base_abs"* ]]; then
        target="${target#$base_abs/}"
    fi

    echo "$target"
}

# Get absolute path of a file or directory
# Arguments: $1 = path (absolute or relative)
# Returns: absolute path
get_absolute_path() {
    local path="$1"

    if [[ "$path" == /* ]]; then
        echo "$path"
    else
        echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
    fi
}

# ============================================================================
# String Operations
# ============================================================================

# Check if string is empty or whitespace
# Arguments: $1 = string to check
# Returns: 0 if empty/whitespace, 1 if has content
is_empty() {
    [[ -z "${1// /}" ]]
}

# Trim leading/trailing whitespace from string
# Arguments: $1 = string to trim
# Returns: trimmed string
trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"  # Remove leading whitespace
    str="${str%"${str##*[![:space:]]}"}"  # Remove trailing whitespace
    echo "$str"
}

# Check if string matches pattern
# Arguments: $1 = string, $2 = pattern (glob)
# Returns: 0 if matches, 1 if not
matches_pattern() {
    local string="$1"
    local pattern="$2"

    [[ "$string" == $pattern ]]
}

# ============================================================================
# Array Operations
# ============================================================================

# Check if array contains element
# Arguments: $1 = element, $2... = array elements
# Returns: 0 if found, 1 if not found
array_contains() {
    local search="$1"
    shift

    for element in "$@"; do
        [[ "$element" == "$search" ]] && return 0
    done

    return 1
}

# Get array length
# Arguments: $1@  = array elements
# Returns: number of elements
array_length() {
    echo "$#"
}

# ============================================================================
# Version Operations
# ============================================================================

# Compare semantic versions (major.minor.patch format)
# Arguments: $1 = version1, $2 = operator (==, !=, <, <=, >, >=), $3 = version2
# Returns: 0 if comparison true, 1 if false
version_compare() {
    local version1="$1"
    local operator="$2"
    local version2="$3"

    # Remove 'v' prefix if present
    version1="${version1#v}"
    version2="${version2#v}"

    # Convert versions to comparable format (pad with zeros)
    local v1_major v1_minor v1_patch
    local v2_major v2_minor v2_patch

    IFS='.' read -r v1_major v1_minor v1_patch <<< "$version1"
    IFS='.' read -r v2_major v2_minor v2_patch <<< "$version2"

    # Pad with zeros for comparison
    v1_major=${v1_major:-0} v1_minor=${v1_minor:-0} v1_patch=${v1_patch:-0}
    v2_major=${v2_major:-0} v2_minor=${v2_minor:-0} v2_patch=${v2_patch:-0}

    case "$operator" in
        "==")
            [[ "$v1_major" == "$v2_major" ]] && [[ "$v1_minor" == "$v2_minor" ]] && [[ "$v1_patch" == "$v2_patch" ]]
            ;;
        "!=")
            ! ([[ "$v1_major" == "$v2_major" ]] && [[ "$v1_minor" == "$v2_minor" ]] && [[ "$v1_patch" == "$v2_patch" ]])
            ;;
        "<")
            [[ "$v1_major$v1_minor$v1_patch" -lt "$v2_major$v2_minor$v2_patch" ]]
            ;;
        "<=")
            [[ "$v1_major$v1_minor$v1_patch" -le "$v2_major$v2_minor$v2_patch" ]]
            ;;
        ">")
            [[ "$v1_major$v1_minor$v1_patch" -gt "$v2_major$v2_minor$v2_patch" ]]
            ;;
        ">=")
            [[ "$v1_major$v1_minor$v1_patch" -ge "$v2_major$v2_minor$v2_patch" ]]
            ;;
        *)
            return 1
            ;;
    esac
}

# Extract version number from command output
# Arguments: $1 = command to run (e.g., "git --version")
# Returns: version string (e.g., "2.30.0")
extract_version() {
    local cmd="$1"
    local output

    output=$($cmd 2>&1 || true)

    # Try common version formats
    if [[ "$output" =~ ([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    elif [[ "$output" =~ ([0-9]+\.[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        # Fallback: return raw output
        echo "$output"
    fi
}

# ============================================================================
# Directory Management
# ============================================================================

# Create directory with parent directories if needed
# Arguments: $1 = directory path
# Returns: 0 if successful, 1 if failed
mkdir_safe() {
    local dir="$1"

    if mkdir -p "$dir" 2>/dev/null; then
        return 0
    else
        log_error "Failed to create directory: $dir"
        return 1
    fi
}

# Remove directory recursively with confirmation
# Arguments: $1 = directory path, [$2 = force (true/false)]
# Returns: 0 if successful, 1 if cancelled or failed
rmdir_safe() {
    local dir="$1"
    local force="${2:-false}"

    if [[ ! -d "$dir" ]]; then
        return 0
    fi

    if [[ "$force" != "true" ]]; then
        log_warn "About to remove: $dir"
        confirm "Are you sure?" "N" || return 1
    fi

    rm -rf "$dir" || return 1
    log_step "Removed directory: $dir"
    return 0
}
