#!/usr/bin/env bash
# Platform Detection and Package Manager Operations
# Detects OS, architecture, package manager, and provides cross-platform package operations
#
# Exported functions:
#   detect_platform()      - Detect OS and set platform variables
#   is_macos()             - Check if running on macOS
#   is_linux()             - Check if running on Linux
#   is_wsl()               - Check if running on Windows Subsystem for Linux
#   get_package_manager()  - Get the package manager for current platform
#   install_package()      - Install a package using platform-appropriate package manager
#   check_package()        - Check if a package is installed
#   get_package_name()     - Get platform-specific package name

set -euo pipefail

# ============================================================================
# Global Variables (set by detect_platform)
# ============================================================================

DETECTED_OS=""           # macOS, Linux
DETECTED_DISTRO=""       # Ubuntu, Fedora, Arch, Alpine, etc.
DETECTED_PKG_MANAGER=""  # brew, apt, apt-get, dnf, pacman, zypper, apk
DETECTED_ARCH=""         # x86_64, arm64, aarch64, etc.
IS_WSL=false             # true if running on Windows Subsystem for Linux

# ============================================================================
# Platform Detection
# ============================================================================

# Detect the operating system and distribution
# Sets: DETECTED_OS, DETECTED_DISTRO, DETECTED_ARCH, IS_WSL
detect_platform() {
    local uname_output
    uname_output="$(uname -s)"

    case "$uname_output" in
        Darwin)
            DETECTED_OS="macOS"
            DETECTED_ARCH="$(uname -m)"
            detect_package_manager_macos
            ;;
        Linux)
            DETECTED_OS="Linux"
            DETECTED_ARCH="$(uname -m)"

            # Check if running on WSL
            if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
                IS_WSL=true
            fi

            detect_package_manager_linux
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

# Detect package manager on macOS
detect_package_manager_macos() {
    if command -v brew &> /dev/null; then
        DETECTED_PKG_MANAGER="brew"
        DETECTED_DISTRO="Homebrew"
    else
        DETECTED_DISTRO="Unknown"
    fi
}

# Detect package manager and distribution on Linux
detect_package_manager_linux() {
    # Check for common distributions and their package managers
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DETECTED_DISTRO="${ID:-unknown}"

        case "$DETECTED_DISTRO" in
            ubuntu|debian)
                DETECTED_PKG_MANAGER="apt"
                ;;
            fedora|rhel|centos)
                DETECTED_PKG_MANAGER="dnf"
                ;;
            arch)
                DETECTED_PKG_MANAGER="pacman"
                ;;
            alpine)
                DETECTED_PKG_MANAGER="apk"
                ;;
            opensuse*)
                DETECTED_PKG_MANAGER="zypper"
                ;;
            *)
                DETECTED_PKG_MANAGER="unknown"
                ;;
        esac
    elif [[ -f /etc/lsb-release ]]; then
        # Fallback for systems with lsb-release
        DETECTED_DISTRO="Linux"
        # Try to detect apt (Debian-based)
        if command -v apt &> /dev/null; then
            DETECTED_PKG_MANAGER="apt"
        fi
    else
        DETECTED_DISTRO="Unknown"
    fi
}

# ============================================================================
# Platform Detection Helpers
# ============================================================================

# Check if running on macOS
# Returns 0 if on macOS, 1 otherwise
is_macos() {
    [[ "$DETECTED_OS" == "macOS" ]]
}

# Check if running on Linux
# Returns 0 if on Linux, 1 otherwise
is_linux() {
    [[ "$DETECTED_OS" == "Linux" ]]
}

# Check if running on Windows Subsystem for Linux
# Returns 0 if on WSL, 1 otherwise
is_wsl() {
    [[ "$IS_WSL" == "true" ]]
}

# Get the detected package manager
# Returns the package manager name (brew, apt, dnf, pacman, etc.)
get_package_manager() {
    echo "$DETECTED_PKG_MANAGER"
}

# ============================================================================
# Package Manager Operations
# ============================================================================

# Install a package using the platform-appropriate package manager
# Arguments: $1 = package name
# Returns 0 on success, 1 on failure
install_package() {
    local package_name="$1"

    # Normalize package name for current package manager
    package_name="$(get_package_name "$package_name" "$DETECTED_PKG_MANAGER")"

    case "$DETECTED_PKG_MANAGER" in
        brew)
            brew install "$package_name" 2>/dev/null || return 1
            ;;
        apt)
            sudo apt-get update > /dev/null 2>&1 || true
            sudo apt-get install -y "$package_name" > /dev/null 2>&1 || return 1
            ;;
        dnf)
            sudo dnf install -y "$package_name" > /dev/null 2>&1 || return 1
            ;;
        pacman)
            sudo pacman -S --noconfirm "$package_name" > /dev/null 2>&1 || return 1
            ;;
        zypper)
            sudo zypper install -y "$package_name" > /dev/null 2>&1 || return 1
            ;;
        apk)
            sudo apk add "$package_name" > /dev/null 2>&1 || return 1
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

# Check if a package is installed
# Arguments: $1 = package name, [$2 = check command override]
# Returns 0 if installed, 1 if not installed
check_package() {
    local package_name="$1"
    local check_cmd="${2:-$package_name}"

    case "$DETECTED_PKG_MANAGER" in
        brew)
            brew list "$package_name" > /dev/null 2>&1
            ;;
        apt)
            dpkg -l | grep -q "^ii  $package_name" 2>/dev/null || \
                apt list --installed 2>/dev/null | grep -q "^$package_name/"
            ;;
        dnf)
            dnf list installed 2>/dev/null | grep -q "^$package_name\."
            ;;
        pacman)
            pacman -Q "$package_name" > /dev/null 2>&1
            ;;
        zypper)
            zypper search -i "$package_name" > /dev/null 2>&1
            ;;
        apk)
            apk list --installed 2>/dev/null | grep -q "^$package_name"
            ;;
        *)
            # Fallback: check if command exists
            command -v "$check_cmd" &> /dev/null
            ;;
    esac
}

# Get platform-specific package name
# Maps common package names to platform-specific variants
# Arguments: $1 = package name, $2 = package manager
# Returns the platform-specific package name
get_package_name() {
    local package_name="$1"
    local pkg_manager="$2"

    # Handle common package name variations
    case "$package_name" in
        python)
            case "$pkg_manager" in
                brew)
                    echo "python3"
                    ;;
                apk)
                    echo "python3"
                    ;;
                *)
                    echo "python3"
                    ;;
            esac
            ;;
        *)
            echo "$package_name"
            ;;
    esac
}

# ============================================================================
# Platform Information Output
# ============================================================================

# Print detected platform information
print_platform_info() {
    cat << EOF
Platform Detection:
  OS:              $DETECTED_OS
  Distribution:    $DETECTED_DISTRO
  Architecture:    $DETECTED_ARCH
  Package Manager: $DETECTED_PKG_MANAGER
  WSL:             $IS_WSL
EOF
}

# ============================================================================
# Initialization
# ============================================================================

# Detect platform on script load
detect_platform
