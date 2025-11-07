#!/usr/bin/env bash
#
# Comprehensive Installer Test Suite
# Tests all aspects of the AgentOps installer
#

set -euo pipefail

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

#######################################
# Print test result
#######################################
print_result() {
    local result="$1"
    local message="$2"

    ((TESTS_RUN++))

    if [[ "$result" == "pass" ]]; then
        echo -e "${GREEN}✓${RESET} $message"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${RESET} $message"
        ((TESTS_FAILED++))
    fi
}

#######################################
# Test: Shell script syntax
#######################################
test_syntax() {
    echo ""
    echo -e "${BLUE}Testing: Shell Script Syntax${RESET}"
    echo "=============================="

    local scripts=(
        "scripts/install.sh"
        "scripts/project-install.sh"
        "scripts/tutorial.sh"
        "scripts/validate-installation.sh"
        "scripts/lib/common-functions.sh"
        "scripts/lib/validation.sh"
        "scripts/lib/logging.sh"
    )

    for script in "${scripts[@]}"; do
        if bash -n "$script" 2>/dev/null; then
            print_result "pass" "Syntax valid: $script"
        else
            print_result "fail" "Syntax invalid: $script"
        fi
    done
}

#######################################
# Test: Profile manifests
#######################################
test_profiles() {
    echo ""
    echo -e "${BLUE}Testing: Profile Manifests${RESET}"
    echo "=============================="

    local profiles=("product-dev" "infrastructure-ops" "devops" "life")

    for profile in "${profiles[@]}"; do
        local manifest="profiles/${profile}/profile.yaml"

        if [[ -f "$manifest" ]]; then
            print_result "pass" "Profile manifest exists: $profile"

            # Check for required fields
            if grep -q "apiVersion:" "$manifest"; then
                print_result "pass" "  - Has apiVersion: $profile"
            else
                print_result "fail" "  - Missing apiVersion: $profile"
            fi

            if grep -q "kind: Profile" "$manifest"; then
                print_result "pass" "  - Has kind: $profile"
            else
                print_result "fail" "  - Missing kind: $profile"
            fi

            if grep -q "agent_count:" "$manifest"; then
                print_result "pass" "  - Has agent_count: $profile"
            else
                print_result "fail" "  - Missing agent_count: $profile"
            fi
        else
            print_result "fail" "Profile manifest missing: $profile"
        fi
    done
}

#######################################
# Test: Library functions
#######################################
test_libraries() {
    echo ""
    echo -e "${BLUE}Testing: Library Functions${RESET}"
    echo "=============================="

    # Source libraries
    source scripts/lib/common-functions.sh 2>/dev/null || {
        print_result "fail" "Cannot source common-functions.sh"
        return
    }

    source scripts/lib/validation.sh 2>/dev/null || {
        print_result "fail" "Cannot source validation.sh"
        return
    }

    source scripts/lib/logging.sh 2>/dev/null || {
        print_result "fail" "Cannot source logging.sh"
        return
    }

    # Test common functions
    local common_funcs=(
        "print_color"
        "die"
        "success"
        "warn"
        "info"
        "get_active_profile"
        "set_default_profile"
        "list_installed_profiles"
        "is_profile_installed"
        "resolve_command"
        "resolve_agent"
    )

    for func in "${common_funcs[@]}"; do
        if declare -f "$func" > /dev/null; then
            print_result "pass" "Function exists: $func"
        else
            print_result "fail" "Function missing: $func"
        fi
    done

    # Test validation functions
    local validation_funcs=(
        "validate_core_installation"
        "validate_profile"
        "validate_12factor_compliance"
        "validate_all"
    )

    for func in "${validation_funcs[@]}"; do
        if declare -f "$func" > /dev/null; then
            print_result "pass" "Function exists: $func"
        else
            print_result "fail" "Function missing: $func"
        fi
    done

    # Test logging functions
    local logging_funcs=(
        "log_json"
        "log_info"
        "log_error"
        "log_event"
    )

    for func in "${logging_funcs[@]}"; do
        if declare -f "$func" > /dev/null; then
            print_result "pass" "Function exists: $func"
        else
            print_result "fail" "Function missing: $func"
        fi
    done
}

#######################################
# Test: Commands
#######################################
test_commands() {
    echo ""
    echo -e "${BLUE}Testing: Commands${RESET}"
    echo "=============================="

    # Test base commands
    local base_commands=("research" "plan")

    for cmd in "${base_commands[@]}"; do
        local cmd_file="core/commands/${cmd}.md"
        if [[ -f "$cmd_file" ]]; then
            print_result "pass" "Base command exists: $cmd"

            # Check not empty
            if [[ -s "$cmd_file" ]]; then
                print_result "pass" "  - Command not empty: $cmd"
            else
                print_result "fail" "  - Command empty: $cmd"
            fi
        else
            print_result "fail" "Base command missing: $cmd"
        fi
    done

    # Test profile overrides
    if [[ -f "profiles/devops/commands/research.md" ]]; then
        print_result "pass" "Profile override exists: devops/research"
    else
        print_result "fail" "Profile override missing: devops/research"
    fi
}

#######################################
# Test: Documentation
#######################################
test_documentation() {
    echo ""
    echo -e "${BLUE}Testing: Documentation${RESET}"
    echo "=============================="

    local required_docs=(
        "INSTALL.md"
        "CHANGELOG.md"
        "README.md"
        "CLAUDE.md"
        "CONSTITUTION.md"
    )

    for doc in "${required_docs[@]}"; do
        if [[ -f "$doc" ]]; then
            print_result "pass" "Documentation exists: $doc"

            # Check not empty
            if [[ -s "$doc" ]]; then
                print_result "pass" "  - Not empty: $doc"
            else
                print_result "fail" "  - Empty: $doc"
            fi
        else
            print_result "fail" "Documentation missing: $doc"
        fi
    done

    # Check CHANGELOG has v1.0.0
    if grep -q "\[1.0.0\]" CHANGELOG.md; then
        print_result "pass" "CHANGELOG has v1.0.0 entry"
    else
        print_result "fail" "CHANGELOG missing v1.0.0 entry"
    fi
}

#######################################
# Test: Installer functionality
#######################################
test_installer_help() {
    echo ""
    echo -e "${BLUE}Testing: Installer Help${RESET}"
    echo "=============================="

    if scripts/install.sh --help > /dev/null 2>&1; then
        print_result "pass" "install.sh --help works"
    else
        print_result "fail" "install.sh --help failed"
    fi

    if scripts/project-install.sh --help > /dev/null 2>&1; then
        print_result "pass" "project-install.sh --help works"
    else
        print_result "fail" "project-install.sh --help failed"
    fi

    if scripts/validate-installation.sh --help > /dev/null 2>&1; then
        print_result "pass" "validate-installation.sh --help works"
    else
        print_result "fail" "validate-installation.sh --help failed"
    fi
}

#######################################
# Print summary
#######################################
print_summary() {
    echo ""
    echo "=============================="
    echo -e "${BLUE}Test Summary${RESET}"
    echo "=============================="
    echo ""
    echo "Tests run:    $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${RESET}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${RESET}"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✅ All tests passed!${RESET}"
        return 0
    else
        echo -e "${RED}❌ Some tests failed${RESET}"
        return 1
    fi
}

#######################################
# Main
#######################################
main() {
    echo ""
    echo "=============================="
    echo -e "${BLUE}AgentOps Installer Test Suite${RESET}"
    echo "=============================="

    # Run all tests
    test_syntax
    test_profiles
    test_libraries
    test_commands
    test_documentation
    test_installer_help

    # Print summary
    print_summary
}

# Run main
main "$@"
