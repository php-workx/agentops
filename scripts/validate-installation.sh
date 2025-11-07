#!/usr/bin/env bash
#
# AgentOps Installation Validation Script
# Wrapper around validation.sh library for standalone execution
#

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if running from installed location or source
if [[ -f "${SCRIPT_DIR}/lib/validation.sh" ]]; then
    # Running from installation
    LIB_DIR="${SCRIPT_DIR}/lib"
elif [[ -f "${HOME}/.agentops/scripts/lib/validation.sh" ]]; then
    # Running from installed location
    LIB_DIR="${HOME}/.agentops/scripts/lib"
else
    echo "ERROR: Cannot find validation library" >&2
    exit 1
fi

# Source libraries
# shellcheck source=./lib/common-functions.sh
source "${LIB_DIR}/common-functions.sh"
# shellcheck source=./lib/logging.sh
source "${LIB_DIR}/logging.sh"
# shellcheck source=./lib/validation.sh
source "${LIB_DIR}/validation.sh"

#######################################
# Print usage
#######################################
usage() {
    cat <<EOF
AgentOps Installation Validation

Usage:
  $0 [OPTIONS] [PROFILE]

Options:
  --tier1           Run Tier 1 validation only (core files)
  --tier2           Run Tier 2 validation only (profiles)
  --tier3           Run Tier 3 validation only (12-factor compliance)
  --all             Run all validation tiers (default)
  --profile NAME    Validate specific profile only
  --help            Show this help message

Validation Tiers:
  Tier 1: Core Files - Essential directory structure and scripts
  Tier 2: Profiles - Profile manifests and structure
  Tier 3: 12-Factor Compliance - Adherence to 12-factor principles

Examples:
  $0                           # Run all tiers
  $0 --tier1                   # Core files only
  $0 --tier2 --profile devops  # Validate devops profile only
  $0 --profile product-dev     # All tiers for product-dev profile

Exit Codes:
  0 - All validations passed
  1 - One or more validations failed
  2 - Usage error

EOF
}

#######################################
# Main validation entry point
#######################################
main() {
    local tier="all"
    local profile=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --tier1)
                tier="tier1"
                shift
                ;;
            --tier2)
                tier="tier2"
                shift
                ;;
            --tier3)
                tier="tier3"
                shift
                ;;
            --all)
                tier="all"
                shift
                ;;
            --profile)
                profile="$2"
                shift 2
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                if [[ -z "$profile" ]] && [[ "$1" != --* ]]; then
                    profile="$1"
                    shift
                else
                    echo "ERROR: Unknown option: $1" >&2
                    usage
                    exit 2
                fi
                ;;
        esac
    done

    # Log validation start
    log_validation "$tier" "start" "Beginning validation" "profile=${profile:-all}"

    # Run requested validation tier(s)
    local result=0

    case "$tier" in
        tier1)
            validate_core_installation || result=$?
            ;;
        tier2)
            validate_profile "$profile" || result=$?
            ;;
        tier3)
            validate_12factor_compliance || result=$?
            ;;
        all)
            validate_all "$profile" || result=$?
            ;;
        *)
            echo "ERROR: Invalid tier: $tier" >&2
            exit 2
            ;;
    esac

    # Log validation result
    if [[ $result -eq 0 ]]; then
        log_validation "$tier" "pass" "Validation completed successfully" "profile=${profile:-all}"
    else
        log_validation "$tier" "fail" "Validation completed with errors" "profile=${profile:-all}"
    fi

    exit $result
}

# Run main function
main "$@"
