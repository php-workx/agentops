# Phase 4: Validation & Testing

We're implementing post-install validation, diagnostics (`make doctor`), and comprehensive automated tests.

## Key Tasks (12 total)

- [ ] **TASK-040:** Implement file existence checks (lib/validation.sh)
- [ ] **TASK-041:** Implement YAML/JSON syntax validation (lib/validation.sh)
- [ ] **TASK-042:** Implement Claude Code integration test (lib/validation.sh)
- [ ] **TASK-043:** Implement sample agent execution (lib/validation.sh)
- [ ] **TASK-044:** Implement git hooks validation (lib/validation.sh)
- [ ] **TASK-045:** Implement prerequisite version validation (lib/validation.sh)
- [ ] **TASK-046:** Implement main validate_installation() coordinator (lib/validation.sh)
- [ ] **TASK-047:** Implement diagnostics tool (make doctor)
- [ ] **TASK-048:** Implement unit tests for all libraries
- [ ] **TASK-049:** Implement integration tests (full install scenarios)
- [ ] **TASK-050:** Implement platform-specific tests
- [ ] **TASK-051:** Create test suite runner

## Validation System

### Post-Install Validation (make verify)

Six checks that run after successful installation:

1. **File existence checks**
   - .claude/settings.json exists
   - .claude/README.md exists
   - CONSTITUTION.md exists
   - CLAUDE.md exists
   - Profile files present

2. **Syntax validation**
   - settings.json is valid JSON
   - All YAML files valid
   - No shell syntax errors

3. **Claude Code integration**
   - settings.json loads without errors
   - No conflicting configuration
   - Agents directory recognized

4. **Sample agent execution**
   - Run hello-world agent
   - Verify output
   - Check exit code

5. **Git hooks validation**
   - Hooks exist and executable
   - Hook syntax valid
   - Can be run manually

6. **Prerequisite version validation**
   - Git >= 2.30
   - Claude Code CLI available
   - Python 3.9+

### Diagnostics Tool (make doctor)

Troubleshooting for users with installation issues:

**Six categories:**
1. **Prerequisites** - Git, Claude Code, Python/uv versions
2. **File structure** - Permissions, ownership, symlinks
3. **Configuration** - install.config.json, settings.json validity
4. **Environment** - AGENTOPS_HOME, PATH, shell compatibility
5. **Functionality** - Can load settings, can run agents
6. **Recommendations** - Specific fix suggestions

Output format:
```
✓ Git 2.43.0 (>= 2.30.0)
✗ Python 3.8.0 (need 3.9+) ← ISSUE
! Optional: Docker not installed

ISSUES FOUND: 1
FIX: Run 'make install' to auto-install Python
```

## Testing Strategy

### Unit Tests (scripts/test/unit_*)

Test each library function individually:

**Platform tests (lib/platform.sh):**
- detect_platform() on mock macOS, Linux, WSL
- is_macos(), is_linux(), is_wsl()
- get_pkg_manager() returns correct manager
- install_package() (mocked)
- check_package() (mocked)

**Prerequisites tests (lib/prerequisites.sh):**
- check_git() with various versions
- check_claude_code() installed/missing
- check_python_uv() with version variants
- install_uv() (mocked or optional)

**Profile tests (lib/profiles.sh):**
- list_profiles() returns available
- validate_profile() detects valid/invalid
- copy_profile(), symlink_profile() (with temp dirs)
- merge_settings() with various scenarios
- Detect existing installation

**Validation tests (lib/validation.sh):**
- check_files_exist() with various states
- validate_yaml_json() with valid/invalid files
- All validation checks independently

### Integration Tests (scripts/test/integration_*)

Test full scenarios end-to-end:

1. **Fresh install in empty repo**
   - Init git repo
   - Run make install
   - Verify all files installed
   - Run make verify
   - Check no errors

2. **Install over existing .claude/**
   - Create existing .claude/ with user file
   - Run make install
   - Verify backup created
   - Verify user file preserved
   - Check merge successful

3. **Install with different profiles**
   - Install default profile
   - Add product-dev profile (make install-profile PROFILE=product-dev)
   - Verify both profiles merged
   - Check no conflicts

4. **Update existing installation**
   - Initial install
   - Run make update
   - Verify updates applied
   - Check user files preserved

5. **Uninstall and cleanup**
   - Install framework
   - Run make uninstall
   - Verify .claude/ removed
   - Check .git and code intact

6. **Non-interactive install with config file**
   - Create install.config.json
   - Run make install (no prompts)
   - Verify installation matches config

### Platform Tests (scripts/test/platform_*)

Test on each supported platform:

**macOS 12+**
- Homebrew integration
- GNU tools compatibility
- Path variables

**Linux (Ubuntu, Fedora, Arch)**
- Different package managers (apt, dnf, pacman)
- sudo requirements
- GNU tools available

**Windows WSL 2**
- Windows path handling
- Git line endings
- WSL-specific paths

### User Acceptance Tests (UAT)

Manual test scenarios:
1. First-time user install
2. Team adoption (different profiles)
3. Error recovery (repair broken install)
4. Performance (timed install)

## Test Infrastructure

### Test Utilities (scripts/test/lib/)

```bash
# Assertions
assert_file_exists(path)
assert_file_not_exists(path)
assert_file_contains(path, text)
assert_command_success(cmd)
assert_command_fails(cmd)
assert_equals(actual, expected)

# Fixtures
create_temp_repo()
create_mock_agentops()
cleanup_temp_files()

# Mocking
mock_command(name, output)
unmock_command(name)
```

## Detailed Task Breakdown

### TASK-040: File Existence Checks
Check that all required files exist post-install:
- .claude/settings.json
- .claude/README.md
- CONSTITUTION.md, CLAUDE.md
- Profile files (agents/, commands/, skills/)

### TASK-041: YAML/JSON Validation
Use `jq` for JSON, `yamllint` or simple parser for YAML:
- Syntax validation
- Schema validation optional
- Clear error messages

### TASK-042: Claude Code Integration
Test that Claude Code can load settings:
- Load settings.json without errors
- Verify structure
- Check for conflicts

### TASK-043: Sample Agent Execution
Run a simple test agent to prove system works:
- Find test agent
- Execute it
- Verify output
- Return exit code

### TASK-044: Git Hooks Validation
Check hooks are present, executable, syntactically correct:
- File exists
- Executable bit set
- Shell syntax valid
- Can be run manually

### TASK-045: Prerequisite Validation
Verify all prerequisites at correct versions:
- Git >= 2.30
- Claude Code available
- Python 3.9+ present

### TASK-046: Main validate_installation() Coordinator
Orchestrator that runs all 6 checks above:
- Run all checks
- Collect results
- Generate report
- Exit code 0 if all pass, 1 if any fail

### TASK-047: Diagnostics Tool (make doctor)
Comprehensive troubleshooting tool:
- Six category checks
- Specific fix recommendations
- Clear output format
- Links to help docs

### TASK-048-051: Test Suite
- Unit tests for each library
- Integration tests for workflows
- Platform-specific tests
- Test runner that runs all

## Understand the Context

Read `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/spec.md`:
- Section 8 - Validation & Testing
- Section 8.1 - Installation validation
- Section 8.2 - Diagnostic tool
- Section 8.3 - Automated testing
- Section 9 - Error handling
- Section 11 - Performance requirements

## Success Criteria

- ✅ All 12 tasks completed
- ✅ Installation validation checks all 6 areas
- ✅ Diagnostics tool helpful and accurate
- ✅ Unit tests cover all library functions
- ✅ Integration tests cover all major workflows
- ✅ Platform tests pass on macOS, Linux, WSL
- ✅ Performance: validate < 5s, doctor < 10s
- ✅ UAT passes: zero configuration errors

## After Completion

1. Mark TASK-040 through TASK-051 as `[x]` in `tasks.md`
2. Commit: `feat(base-install): Phase 4 - Validation and testing`
3. Run full test suite: `make test-install`
4. Report ready for Phase 5

This phase ensures quality and reliability!
