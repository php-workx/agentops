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

    # Check if yq is available
    local has_yq=false
    if command -v yq &> /dev/null; then
        has_yq=true
        print_result "pass" "yq available for YAML validation"
    else
        print_result "warn" "yq not available, using grep fallback"
    fi

    for profile in "${profiles[@]}"; do
        local manifest="profiles/${profile}/profile.yaml"

        if [[ -f "$manifest" ]]; then
            print_result "pass" "Profile manifest exists: $profile"

            # Validate YAML syntax with yq if available
            if [[ "$has_yq" == "true" ]]; then
                if yq eval '.' "$manifest" > /dev/null 2>&1; then
                    print_result "pass" "  - Valid YAML syntax: $profile"
                else
                    print_result "fail" "  - Invalid YAML syntax: $profile"
                    continue
                fi

                # Validate required fields with yq
                local api_version
                api_version=$(yq eval '.apiVersion' "$manifest" 2>/dev/null)
                if [[ "$api_version" == "agentops.io/v1" ]]; then
                    print_result "pass" "  - apiVersion valid: $profile"
                else
                    print_result "fail" "  - apiVersion invalid or missing: $profile (got: $api_version)"
                fi

                local kind
                kind=$(yq eval '.kind' "$manifest" 2>/dev/null)
                if [[ "$kind" == "Profile" ]]; then
                    print_result "pass" "  - kind valid: $profile"
                else
                    print_result "fail" "  - kind invalid or missing: $profile (got: $kind)"
                fi

                local profile_name
                profile_name=$(yq eval '.metadata.name' "$manifest" 2>/dev/null)
                if [[ "$profile_name" == "$profile" ]]; then
                    print_result "pass" "  - metadata.name matches: $profile"
                else
                    print_result "fail" "  - metadata.name mismatch: $profile (got: $profile_name)"
                fi

                local agent_count
                agent_count=$(yq eval '.spec.agent_count' "$manifest" 2>/dev/null)
                if [[ "$agent_count" =~ ^[0-9]+$ ]]; then
                    print_result "pass" "  - agent_count valid: $profile ($agent_count agents)"
                else
                    print_result "fail" "  - agent_count invalid: $profile (got: $agent_count)"
                fi
            else
                # Fallback to grep if yq not available
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
        "docs/FAQ.md"
        "docs/TROUBLESHOOTING.md"
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
# Test: GitHub Actions workflows
#######################################
test_github_actions() {
    echo ""
    echo -e "${BLUE}Testing: GitHub Actions Workflows${RESET}"
    echo "=============================="

    # Check if yq is available
    if ! command -v yq &> /dev/null; then
        print_result "warn" "yq not available, skipping workflow YAML validation"
        return
    fi

    local workflow=".github/workflows/installer-validation.yml"

    if [[ -f "$workflow" ]]; then
        print_result "pass" "Workflow file exists: installer-validation.yml"

        # Validate YAML syntax
        if yq eval '.' "$workflow" > /dev/null 2>&1; then
            print_result "pass" "  - Valid YAML syntax"
        else
            print_result "fail" "  - Invalid YAML syntax"
            return
        fi

        # Check required fields
        local workflow_name
        workflow_name=$(yq eval '.name' "$workflow" 2>/dev/null)
        if [[ -n "$workflow_name" ]]; then
            print_result "pass" "  - Has name: $workflow_name"
        else
            print_result "fail" "  - Missing workflow name"
        fi

        # Check for on triggers
        if yq eval '.on' "$workflow" > /dev/null 2>&1; then
            print_result "pass" "  - Has triggers defined"

            # Check for pull_request trigger
            if yq eval '.on.pull_request' "$workflow" | grep -q "main"; then
                print_result "pass" "    - Triggers on PR to main"
            else
                print_result "fail" "    - Missing PR to main trigger"
            fi
        else
            print_result "fail" "  - Missing triggers"
        fi

        # Check for jobs
        local job_count
        job_count=$(yq eval '.jobs | length' "$workflow" 2>/dev/null)
        if [[ "$job_count" -gt 0 ]]; then
            print_result "pass" "  - Has jobs defined: $job_count jobs"
        else
            print_result "fail" "  - No jobs defined"
        fi
    else
        print_result "fail" "Workflow file missing: installer-validation.yml"
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
    test_github_actions
    test_installer_help

    # Print summary
    print_summary
}

# Run main
main "$@"
