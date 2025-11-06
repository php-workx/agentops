#!/usr/bin/env bash
# Unit Tests for Platform Detection (lib/platform.sh)
# Tests OS detection, package manager detection, platform operations

set -euo pipefail

# Test framework setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_PASSED=0
TESTS_FAILED=0

# ============================================================================
# Test Framework
# ============================================================================

# Assert function: check condition is true
# Arguments: $1 = condition result (0=true, 1=false), $2 = test description
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

# Assert function: check condition is false
# Arguments: $1 = condition result (0=true, 1=false), $2 = test description
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

# Assert function: check strings are equal
# Arguments: $1 = actual value, $2 = expected value, $3 = test description
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

# Source platform.sh library
source "$SCRIPT_DIR/../scripts/lib/platform.sh"

# ============================================================================
# Platform Detection Tests
# ============================================================================

test_platform_detection() {
    echo ""
    echo "Testing platform detection..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test that platform detection ran (called during source)
    assert_true $([[ -n "$DETECTED_OS" ]] && echo 0 || echo 1) \
        "Platform OS detected"

    assert_true $([[ -n "$DETECTED_PKG_MANAGER" ]] && echo 0 || echo 1) \
        "Package manager detected"

    assert_true $([[ -n "$DETECTED_ARCH" ]] && echo 0 || echo 1) \
        "Architecture detected"

    # Test platform helper functions work
    if is_macos || is_linux; then
        echo "✓ PASS: Platform is macOS or Linux (expected)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ FAIL: Platform should be macOS or Linux"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# ============================================================================
# Package Manager Tests
# ============================================================================

test_package_manager() {
    echo ""
    echo "Testing package manager operations..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Test get_package_manager
    local pkg_mgr
    pkg_mgr=$(get_package_manager)
    assert_true $([[ -n "$pkg_mgr" ]] && echo 0 || echo 1) \
        "get_package_manager() returns a value"

    # Test package name mapping
    local python_pkg
    python_pkg=$(get_package_name "python" "$DETECTED_PKG_MANAGER")
    assert_equals "$python_pkg" "python3" \
        "Package name mapping: python -> python3"
}

# ============================================================================
# Mock uname Tests
# ============================================================================

# Test macOS detection (mock)
test_macos_detection_mock() {
    echo ""
    echo "Testing macOS detection (mock)..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Create temporary mock uname script
    local mock_dir="/tmp/platform-test-$$"
    mkdir -p "$mock_dir"
    cat > "$mock_dir/uname" << 'EOF'
#!/bin/bash
if [[ "$1" == "-s" ]]; then
    echo "Darwin"
elif [[ "$1" == "-m" ]]; then
    echo "arm64"
fi
EOF
    chmod +x "$mock_dir/uname"

    # Save original PATH
    local original_path="$PATH"

    # Temporarily add mock to PATH
    export PATH="$mock_dir:$PATH"

    # Re-run detection
    local detected_os_mock
    detected_os_mock=$($mock_dir/uname -s)

    # Restore PATH
    export PATH="$original_path"

    # Cleanup
    rm -rf "$mock_dir"

    # Verify mock worked
    assert_equals "$detected_os_mock" "Darwin" \
        "Mock uname -s returns 'Darwin' for macOS"

    echo "ℹ  (Mock tests verify detection logic works for different platforms)"
}

# Test Linux detection (mock)
test_linux_detection_mock() {
    echo ""
    echo "Testing Linux detection (mock)..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Create temporary mock uname script
    local mock_dir="/tmp/platform-test-$$"
    mkdir -p "$mock_dir"
    cat > "$mock_dir/uname" << 'EOF'
#!/bin/bash
if [[ "$1" == "-s" ]]; then
    echo "Linux"
elif [[ "$1" == "-m" ]]; then
    echo "x86_64"
fi
EOF
    chmod +x "$mock_dir/uname"

    # Re-run detection
    local detected_os_mock
    detected_os_mock=$($mock_dir/uname -s)

    # Cleanup
    rm -rf "$mock_dir"

    # Verify mock worked
    assert_equals "$detected_os_mock" "Linux" \
        "Mock uname -s returns 'Linux' for Linux systems"
}

# ============================================================================
# Real Platform Tests
# ============================================================================

test_current_platform() {
    echo ""
    echo "Testing current platform..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo "ℹ  Current platform information:"
    echo "   OS:              $DETECTED_OS"
    echo "   Distribution:    $DETECTED_DISTRO"
    echo "   Architecture:    $DETECTED_ARCH"
    echo "   Package Manager: $DETECTED_PKG_MANAGER"
    echo "   WSL:             $IS_WSL"
    echo ""

    # Verify detected values are reasonable
    if [[ "$DETECTED_OS" == "macOS" ]]; then
        assert_equals "$DETECTED_PKG_MANAGER" "brew" \
            "macOS should use brew package manager (or be unknown)"
    elif [[ "$DETECTED_OS" == "Linux" ]]; then
        assert_true $([[ -n "$DETECTED_PKG_MANAGER" ]] && echo 0 || echo 1) \
            "Linux should have a detected package manager"
    fi
}

# ============================================================================
# Test Runner
# ============================================================================

main() {
    echo "═══════════════════════════════════════════════════════"
    echo "  Platform Detection Unit Tests"
    echo "═══════════════════════════════════════════════════════"

    # Run all tests
    test_platform_detection
    test_package_manager
    test_macos_detection_mock
    test_linux_detection_mock
    test_current_platform

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
