#!/usr/bin/env bash
# Unit Tests for Prerequisites Checking (lib/prerequisites.sh)
# Tests version parsing, auto-install logic, prerequisite checks

set -euo pipefail

# Test framework setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_PASSED=0
TESTS_FAILED=0

# ============================================================================
# Test Framework
# ============================================================================

assert_true() {
    local result=$1
    local description="$2"

    if [[ $result -eq 0 ]]; then
        echo "✓ PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_false() {
    local result=$1
    local description="$2"

    if [[ $result -ne 0 ]]; then
        echo "✓ PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_equals() {
    local actual="$1"
    local expected="$2"
    local description="$3"

    if [[ "$actual" == "$expected" ]]; then
        echo "✓ PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: $description (expected: '$expected', got: '$actual')"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# ============================================================================
# Test Setup
# ============================================================================

# Source common utilities first (prerequisites depends on it)
source "$SCRIPT_DIR/../scripts/lib/common.sh"
source "$SCRIPT_DIR/../scripts/lib/platform.sh"

# Don't source prerequisites.sh yet - it will auto-run checks

# ============================================================================
# Version Comparison Tests
# ============================================================================

test_version_compare() {
    echo ""
    echo "Testing version comparison..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test equality
    version_compare "1.0.0" "==" "1.0.0"
    assert_true $? "Version 1.0.0 == 1.0.0"

    version_compare "1.0.0" "==" "1.0.1"
    assert_false $? "Version 1.0.0 != 1.0.1"

    # Test greater than
    version_compare "2.0.0" ">" "1.0.0"
    assert_true $? "Version 2.0.0 > 1.0.0"

    version_compare "1.0.1" ">" "1.0.0"
    assert_true $? "Version 1.0.1 > 1.0.0"

    # Test greater than or equal
    version_compare "2.30.0" ">=" "2.30.0"
    assert_true $? "Version 2.30.0 >= 2.30.0"

    version_compare "2.31.0" ">=" "2.30.0"
    assert_true $? "Version 2.31.0 >= 2.30.0"

    # Test less than
    version_compare "1.0.0" "<" "2.0.0"
    assert_true $? "Version 1.0.0 < 2.0.0"

    # Test with v prefix
    version_compare "v2.30.0" ">=" "2.30.0"
    assert_true $? "Version v2.30.0 >= 2.30.0 (v prefix handled)"
}

# ============================================================================
# Version Extraction Tests
# ============================================================================

test_extract_version() {
    echo ""
    echo "Testing version extraction..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Mock git --version output
    local version
    version=$(echo "git version 2.39.3" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    assert_equals "$version" "2.39.3" \
        "Extract version from 'git version 2.39.3'"

    # Mock Python version output
    version=$(echo "Python 3.11.5" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    assert_equals "$version" "3.11.5" \
        "Extract version from 'Python 3.11.5'"

    # Mock version with extra text
    version=$(echo "uv 0.1.45 (release)" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    assert_equals "$version" "0.1.45" \
        "Extract version from 'uv 0.1.45 (release)'"
}

# ============================================================================
# Git Check Tests (Mock)
# ============================================================================

test_git_version_check() {
    echo ""
    echo "Testing Git version check logic..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test that version 2.30.0 meets requirement
    version_compare "2.30.0" ">=" "2.30.0"
    assert_true $? "Git 2.30.0 meets minimum requirement"

    # Test that version 2.40.0 meets requirement
    version_compare "2.40.0" ">=" "2.30.0"
    assert_true $? "Git 2.40.0 meets minimum requirement"

    # Test that version 2.20.0 fails requirement
    version_compare "2.20.0" ">=" "2.30.0"
    assert_false $? "Git 2.20.0 below minimum requirement"
}

# ============================================================================
# Python Version Check Tests (Mock)
# ============================================================================

test_python_version_check() {
    echo ""
    echo "Testing Python version check logic..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test that version 3.9 meets requirement
    version_compare "3.9" ">=" "3.9"
    assert_true $? "Python 3.9 meets minimum requirement"

    # Test that version 3.11 meets requirement
    version_compare "3.11" ">=" "3.9"
    assert_true $? "Python 3.11 meets minimum requirement"

    # Test that version 3.8 fails requirement
    version_compare "3.8" ">=" "3.9"
    assert_false $? "Python 3.8 below minimum requirement"

    # Test that version 2.7 fails requirement
    version_compare "2.7" ">=" "3.9"
    assert_false $? "Python 2.7 below minimum requirement"
}

# ============================================================================
# Command Availability Tests
# ============================================================================

test_command_availability() {
    echo ""
    echo "Testing command availability checks..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test that common commands are available
    if command -v git &> /dev/null; then
        echo "✓ PASS: git command is available"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "⚠ SKIP: git command not available (expected on most systems)"
    fi

    if command -v bash &> /dev/null; then
        echo "✓ PASS: bash command is available"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: bash command should be available"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi

    # Test that non-existent commands are detected
    if ! command -v nonexistent_command_xyz &> /dev/null; then
        echo "✓ PASS: Correctly detects missing command"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: Should not find nonexistent command"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# ============================================================================
# Real Prerequisites Check (Informational)
# ============================================================================

test_real_prerequisites() {
    echo ""
    echo "Checking real prerequisites (informational)..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo "ℹ  Current system prerequisites:"
    echo ""

    # Check Git
    if command -v git &> /dev/null; then
        local git_version
        git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        echo "   Git: $git_version"

        if version_compare "$git_version" ">=" "2.30.0"; then
            echo "        (meets requirement >= 2.30.0)"
        else
            echo "        (below requirement >= 2.30.0)"
        fi
    else
        echo "   Git: not found"
    fi

    # Check Python
    if command -v python3 &> /dev/null; then
        local python_version
        python_version=$(python3 --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
        echo "   Python: $python_version"

        if version_compare "$python_version" ">=" "3.9"; then
            echo "           (meets requirement >= 3.9)"
        else
            echo "           (below requirement >= 3.9)"
        fi
    else
        echo "   Python: not found"
    fi

    # Check uv
    if command -v uv &> /dev/null; then
        local uv_version
        uv_version=$(uv --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        echo "   uv: $uv_version"
    else
        echo "   uv: not found (optional)"
    fi

    # Check Claude Code
    local claude_cmd=""
    for cmd in claude claude-code cc; do
        if command -v "$cmd" &> /dev/null; then
            claude_cmd="$cmd"
            break
        fi
    done

    if [[ -n "$claude_cmd" ]]; then
        local claude_version
        claude_version=$($claude_cmd --version 2>&1 | head -1 || echo "unknown")
        echo "   Claude Code: $claude_version"
    else
        echo "   Claude Code: not found"
    fi

    echo ""
    echo "ℹ  (These are informational checks, not test assertions)"
}

# ============================================================================
# Test Runner
# ============================================================================

main() {
    echo "═══════════════════════════════════════════════════════"
    echo "  Prerequisites Checking Unit Tests"
    echo "═══════════════════════════════════════════════════════"

    # Run all tests
    test_version_compare
    test_extract_version
    test_git_version_check
    test_python_version_check
    test_command_availability
    test_real_prerequisites

    # Summary
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  Test Results"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo "  Total:  $((TESTS_PASSED + TESTS_FAILED))"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo "✅ All tests passed!"
        echo ""
        return 0
    else
        echo "❌ Some tests failed"
        echo ""
        return 1
    fi
}

# Run tests
main "$@"
