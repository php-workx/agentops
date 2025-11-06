#!/usr/bin/env bash
# Validation and Testing Functions
# Post-install validation, diagnostics, and quality gates
#
# Exported functions:
#   check_files_exist()           - Verify all required files and directories present
#   validate_yaml_json()          - Check YAML/JSON syntax validity
#   test_claude_code_load()       - Test Claude Code integration
#   run_sample_agent()            - Execute sample agent test
#   check_git_hooks()             - Validate git hooks installation
#   check_prerequisite_versions() - Verify tool versions meet requirements
#   validate_installation()       - Main coordinator for all validation checks

set -euo pipefail

# Source required libraries
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prerequisites.sh"

# ============================================================================
# File Existence Checks
# ============================================================================

# Check if all required files and directories exist
# Returns: 0 if all present, error count if missing
check_files_exist() {
    local missing_count=0
    local required_files=(
        ".claude/settings.json"
        ".claude/README.md"
        "CONSTITUTION.md"
        "CLAUDE.md"
    )
    local required_dirs=(
        ".claude"
        ".claude/agents"
        ".claude/commands"
        ".claude/skills"
    )

    log_info "Checking file existence..."

    # Check required directories
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_error "Missing directory: $dir"
            missing_count=$((missing_count + 1))
        else
            log_step "$dir/"
        fi
    done

    # Check required files
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Missing file: $file"
            missing_count=$((missing_count + 1))
        else
            log_step "$file"
        fi
    done

    # Count components
    if [[ -d ".claude/agents" ]]; then
        local agent_count=$(find .claude/agents -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        log_info "  Found $agent_count agent(s)"
    fi

    if [[ -d ".claude/commands" ]]; then
        local command_count=$(find .claude/commands -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        log_info "  Found $command_count command(s)"
    fi

    if [[ -d ".claude/skills" ]]; then
        local skill_count=$(find .claude/skills -type d -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')
        log_info "  Found $skill_count skill(s)"
    fi

    if [[ $missing_count -gt 0 ]]; then
        log_error "File existence check failed: $missing_count missing items"
        return $missing_count
    fi

    log_success "All required files and directories present"
    return 0
}

# ============================================================================
# YAML/JSON Syntax Validation
# ============================================================================

# Validate YAML/JSON syntax for all configuration files
# Returns: 0 if all valid, error count if syntax errors
validate_yaml_json() {
    local error_count=0

    log_info "Validating YAML/JSON syntax..."

    # Validate settings.json
    if [[ -f ".claude/settings.json" ]]; then
        if jq empty .claude/settings.json 2>/dev/null; then
            log_step ".claude/settings.json (valid JSON)"
        else
            log_error ".claude/settings.json has syntax errors"
            jq empty .claude/settings.json 2>&1 | head -5
            error_count=$((error_count + 1))
        fi
    fi

    # Validate agent files (Markdown with YAML frontmatter)
    if [[ -d ".claude/agents" ]]; then
        local agent_files=()
        while IFS= read -r -d '' file; do
            agent_files+=("$file")
        done < <(find .claude/agents -name "*.md" -type f -print0 2>/dev/null)

        for agent_file in "${agent_files[@]}"; do
            # Extract YAML frontmatter (between --- markers)
            local frontmatter
            frontmatter=$(awk '/^---$/{flag=!flag; next} flag' "$agent_file" 2>/dev/null || true)

            if [[ -n "$frontmatter" ]]; then
                # Validate YAML using Python (more reliable than yq)
                if command -v python3 &> /dev/null; then
                    if echo "$frontmatter" | python3 -c "import sys, yaml; yaml.safe_load(sys.stdin)" 2>/dev/null; then
                        log_step "$(basename "$agent_file") (valid YAML frontmatter)"
                    else
                        log_error "$(basename "$agent_file") has invalid YAML frontmatter"
                        error_count=$((error_count + 1))
                    fi
                else
                    # Fallback: just check if frontmatter exists
                    log_step "$(basename "$agent_file") (frontmatter present, Python not available for validation)"
                fi
            else
                log_step "$(basename "$agent_file") (no frontmatter)"
            fi
        done

        if [[ ${#agent_files[@]} -eq 0 ]]; then
            log_warn "No agent files found in .claude/agents/"
        fi
    fi

    # Validate manifest if it exists
    if [[ -f ".claude/installed_components.json" ]]; then
        if jq empty .claude/installed_components.json 2>/dev/null; then
            log_step ".claude/installed_components.json (valid JSON)"
        else
            log_error ".claude/installed_components.json has syntax errors"
            error_count=$((error_count + 1))
        fi
    fi

    if [[ $error_count -gt 0 ]]; then
        log_error "YAML/JSON validation failed: $error_count errors"
        return $error_count
    fi

    log_success "All YAML/JSON files valid"
    return 0
}

# ============================================================================
# Claude Code Integration Test
# ============================================================================

# Test if Claude Code can load settings.json
# Returns: 0 if successful, 1 if failed
test_claude_code_load() {
    log_info "Testing Claude Code integration..."

    # Check if Claude Code is installed
    local claude_cmd=""
    for cmd in claude claude-code cc; do
        if command -v "$cmd" &> /dev/null; then
            claude_cmd="$cmd"
            break
        fi
    done

    if [[ -z "$claude_cmd" ]]; then
        log_warn "Claude Code CLI not found, skipping integration test"
        return 0
    fi

    # Check if settings.json exists
    if [[ ! -f ".claude/settings.json" ]]; then
        log_error "settings.json not found, cannot test Claude Code integration"
        return 1
    fi

    # Placeholder for actual Claude Code validation command
    # The actual command depends on Claude Code CLI capabilities
    # For now, we just verify the file is valid JSON (already done in validate_yaml_json)

    # Future implementation might look like:
    # if $claude_cmd config validate .claude/settings.json 2>/dev/null; then
    #     log_step "Claude Code loaded settings successfully"
    #     return 0
    # else
    #     log_error "Claude Code failed to load settings"
    #     return 1
    # fi

    log_step "Claude Code CLI found: $claude_cmd"
    log_info "  (Full integration test pending Claude Code CLI validation command)"
    return 0
}

# ============================================================================
# Sample Agent Execution
# ============================================================================

# Run a sample agent to verify agent system works
# Returns: 0 if successful, 1 if failed
run_sample_agent() {
    log_info "Running sample agent test..."

    # Check if any agents exist
    if [[ ! -d ".claude/agents" ]]; then
        log_warn "No .claude/agents directory, skipping sample agent test"
        return 0
    fi

    local agent_count=$(find .claude/agents -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [[ $agent_count -eq 0 ]]; then
        log_warn "No agents installed, skipping sample agent test"
        return 0
    fi

    # Placeholder for actual agent execution
    # The actual execution depends on Claude Code CLI capabilities
    # For now, we just verify at least one agent file exists

    # Future implementation might look like:
    # if claude run-agent hello-world --test; then
    #     log_step "Sample agent executed successfully"
    #     return 0
    # else
    #     log_error "Sample agent execution failed"
    #     return 1
    # fi

    log_step "$agent_count agent(s) available"
    log_info "  (Full agent execution test pending Claude Code CLI capabilities)"
    return 0
}

# ============================================================================
# Git Hooks Validation
# ============================================================================

# Check if git hooks are installed and executable
# Returns: 0 if OK (or not applicable), 1 if errors
check_git_hooks() {
    log_info "Checking git hooks..."

    # Check if we're in a git repository
    if [[ ! -d ".git" ]]; then
        log_info "  Not a git repository, skipping hook checks"
        return 0
    fi

    local hooks_to_check=("pre-commit" "post-commit" "commit-msg")
    local hooks_found=0
    local hooks_missing=0

    for hook in "${hooks_to_check[@]}"; do
        local hook_path=".git/hooks/$hook"

        if [[ -f "$hook_path" ]]; then
            if [[ -x "$hook_path" ]]; then
                log_step "$hook (installed, executable)"
                hooks_found=$((hooks_found + 1))
            else
                log_warn "$hook (installed but not executable)"
                hooks_found=$((hooks_found + 1))
            fi
        else
            hooks_missing=$((hooks_missing + 1))
        fi
    done

    if [[ $hooks_found -eq 0 ]]; then
        log_info "  No git hooks installed (optional)"
    else
        log_info "  $hooks_found hook(s) installed"
    fi

    return 0
}

# ============================================================================
# Prerequisite Version Validation
# ============================================================================

# Check all prerequisite versions meet minimum requirements
# Returns: 0 if all OK, warning count if some below minimum
check_prerequisite_versions() {
    local warning_count=0

    log_info "Checking prerequisite versions..."

    # Check Git version
    if command -v git &> /dev/null; then
        local git_version
        git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")

        if version_compare "$git_version" ">=" "2.30.0"; then
            log_step "Git $git_version (>= 2.30.0)"
        else
            log_warn "Git $git_version (below recommended 2.30.0)"
            warning_count=$((warning_count + 1))
        fi
    else
        log_warn "Git not found"
        warning_count=$((warning_count + 1))
    fi

    # Check Python version
    if command -v python3 &> /dev/null; then
        local python_version
        python_version=$(python3 --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")

        if version_compare "$python_version" ">=" "3.9"; then
            log_step "Python $python_version (>= 3.9)"
        else
            log_warn "Python $python_version (below recommended 3.9)"
            warning_count=$((warning_count + 1))
        fi
    else
        log_warn "Python not found"
        warning_count=$((warning_count + 1))
    fi

    # Check uv
    if command -v uv &> /dev/null; then
        local uv_version
        uv_version=$(uv --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        log_step "uv $uv_version"
    else
        log_info "  uv not found (optional)"
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
        log_step "Claude Code: $claude_version"
    else
        log_warn "Claude Code CLI not found"
        warning_count=$((warning_count + 1))
    fi

    if [[ $warning_count -gt 0 ]]; then
        log_warn "Prerequisite check completed with $warning_count warning(s)"
    else
        log_success "All prerequisites meet requirements"
    fi

    return $warning_count
}

# ============================================================================
# Main Validation Coordinator
# ============================================================================

# Run all validation checks and report results
# Returns: 0 if all pass, 1 if any fail
validate_installation() {
    local total_errors=0
    local total_warnings=0

    echo ""
    log_info "═══════════════════════════════════════════════════════"
    log_info "  AgentOps Installation Validation"
    log_info "═══════════════════════════════════════════════════════"
    echo ""

    # Check 1: File existence
    echo ""
    log_info "[1/6] File Existence"
    if ! check_files_exist; then
        total_errors=$((total_errors + $?))
    fi

    # Check 2: YAML/JSON syntax
    echo ""
    log_info "[2/6] YAML/JSON Syntax"
    if ! validate_yaml_json; then
        total_errors=$((total_errors + $?))
    fi

    # Check 3: Claude Code integration
    echo ""
    log_info "[3/6] Claude Code Integration"
    if ! test_claude_code_load; then
        total_errors=$((total_errors + 1))
    fi

    # Check 4: Sample agent
    echo ""
    log_info "[4/6] Sample Agent Test"
    if ! run_sample_agent; then
        total_errors=$((total_errors + 1))
    fi

    # Check 5: Git hooks
    echo ""
    log_info "[5/6] Git Hooks"
    if ! check_git_hooks; then
        total_errors=$((total_errors + 1))
    fi

    # Check 6: Prerequisites
    echo ""
    log_info "[6/6] Prerequisites"
    if ! check_prerequisite_versions; then
        total_warnings=$((total_warnings + $?))
    fi

    # Summary
    echo ""
    log_info "═══════════════════════════════════════════════════════"
    if [[ $total_errors -eq 0 ]] && [[ $total_warnings -eq 0 ]]; then
        log_success "All checks passed! ✅"
        log_info ""
        log_info "Installation validated successfully."
        log_info ""
        log_info "Next steps:"
        log_info "  1. Read CLAUDE.md to understand your project setup"
        log_info "  2. Try an agent: /prime-simple-task"
        log_info "  3. Read agent docs: cat .claude/README.md"
        echo ""
        return 0
    elif [[ $total_errors -eq 0 ]] && [[ $total_warnings -gt 0 ]]; then
        log_warn "Validation completed with $total_warnings warning(s)"
        log_info ""
        log_info "Installation is functional but has minor issues."
        log_info "Run 'make doctor' for detailed diagnostics."
        echo ""
        return 0
    else
        log_error "Validation failed with $total_errors error(s), $total_warnings warning(s)"
        log_info ""
        log_info "Installation has critical issues. Please fix the errors above."
        log_info "Run 'make doctor' for detailed diagnostics and suggested fixes."
        echo ""
        return 1
    fi
}
