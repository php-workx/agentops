# Phase 5: Documentation & Polish

We're wrapping up the Base Installation System with comprehensive documentation, polished error messages, and final refinements for public launch.

## Key Tasks (11 total)

- [ ] **TASK-060:** Implement configuration loading (interactive + file)
- [ ] **TASK-061:** Implement main installation flow (base-install.sh)
- [ ] **TASK-062:** Implement update flow (make update)
- [ ] **TASK-063:** Implement uninstall flow (make uninstall)
- [ ] **TASK-064:** Polish all error messages
- [ ] **TASK-065:** Create user installation guide
- [ ] **TASK-066:** Create configuration reference
- [ ] **TASK-067:** Create troubleshooting guide
- [ ] **TASK-068:** Create profile documentation
- [ ] **TASK-069:** Create developer setup guide
- [ ] **TASK-070:** Final testing and polish

## Configuration System

### Interactive Prompts

Friendly, informative prompts guide users:

```
Project name (current directory: my-project): [my-project]
>

Default AI model:
  1. opus (better quality, slower, higher cost)
  2. sonnet (faster, lower cost) [default]
> 2

Select profile:
  1. default (minimal, universal patterns)
  2. product-dev (product development workflows) [recommended]
  3. devops (infrastructure/operations workflows)
> 2

Install git hooks? [Y/n]
> y
```

### Configuration File

Support `install.config.json` for non-interactive install:

```json
{
  "project": {
    "name": "my-project",
    "type": "product-dev"
  },
  "agentops": {
    "model": "opus",
    "profile": "product-dev"
  },
  "permissions": {
    "git": true,
    "python": true
  },
  "hooks": {
    "pre_commit": true,
    "post_commit": true
  }
}
```

## Installation Flows

### Main Installation Flow

```
1. Detect agentops repo location
2. Check prerequisites (auto-install Python/uv if needed)
3. Load or prompt for configuration
4. Detect existing installation (if any)
5. Create backup (if updating)
6. Install base structure (.claude/)
7. Install selected profile
8. Install root files (CONSTITUTION.md, CLAUDE.md)
9. Install git hooks (optional)
10. Validate installation
11. Show success summary + next steps
```

### Update Flow (make update)

```
1. Detect existing installation
2. Verify not corrupted
3. Backup current state
4. Check for new versions
5. Pull updates from agentops repo
6. Merge new features with user customizations
7. Update settings.json
8. Run validation
9. Report what changed
```

### Uninstall Flow (make uninstall)

```
1. Confirm user wants to uninstall
2. Backup .claude/ directory
3. Remove .claude/
4. Remove CONSTITUTION.md, CLAUDE.md
5. Remove git hooks
6. Update .gitignore
7. Report what was removed, where backup is
```

## Documentation Requirements

### Installation Guide (INSTALL.md)

**Sections:**
1. Quick start (3 steps)
2. Prerequisites (what's needed)
3. Step-by-step instructions
4. Post-install verification
5. Troubleshooting common issues
6. FAQ

**Example:**
```markdown
# AgentOps Framework Installation

## Quick Start

1. Enter your project directory: `cd my-project`
2. Run the installer: `make install`
3. Choose your preferences (model, profile)
4. Done! Try an agent: `/prime-simple-task`

## Prerequisites

- Git 2.30+ (check with: `git --version`)
- Claude Code CLI installed
- Python 3.9+ (auto-installed if missing)

## Detailed Installation

[Full step-by-step]

## Post-Install Check

```bash
make verify
```

## Troubleshooting

If something goes wrong: `make doctor`
```

### Configuration Reference (CONFIG.md)

**Sections:**
1. install.config.json schema
2. settings.json explanation
3. Environment variables
4. Customization examples
5. Profile selection guide

### Troubleshooting Guide (TROUBLESHOOTING.md)

**Error scenarios with solutions:**
1. Git not found → Install Git
2. Claude Code not found → Install Claude Code
3. Permission denied → Fix permissions
4. Installation fails with "profile not found" → Check agentops location
5. Merge conflicts → How to resolve
6. Rollback previous install → Using backups

## Error Message Polish

### Design Principles

1. **Clear** - User understands what went wrong
2. **Helpful** - Suggests how to fix it
3. **Actionable** - User knows next step
4. **Friendly** - Not condescending

### Format

```bash
print_error "Installation failed: File permission denied"
echo ""
echo "Cannot write to .claude/ directory. Options:"
echo "  1. Fix permissions: chmod 755 .claude/"
echo "  2. Run with sudo: sudo make install"
echo "  3. Change directory owner: sudo chown -R \$USER ."
echo ""
echo "After fixing, run 'make install' again."
```

### Error Categories

**Critical (exit immediately):**
- Git not found
- Claude Code not installed
- Write permission denied
- Corrupted agentops source

**Recoverable (auto-fix or prompt):**
- Python/uv missing → auto-install
- Profile not found → offer alternatives
- Backup restore failed → keep old backup

**Warnings (continue with notice):**
- Optional tools missing
- Unusual file ownership
- Git hooks not executable

## Polish Tasks

### TASK-060: Configuration Loading
Implement config loading logic:
- Detect install.config.json if exists
- Parse and validate JSON
- Load environment variables (AGENTOPS_MODEL, etc.)
- Prompt for missing values
- Save config for future runs

### TASK-061: Main Installation Flow
Integrate all components into complete flow:
- Call detect_platform()
- Call check_prerequisites()
- Call load_configuration()
- Call install_base_structure()
- Call install_profile()
- Call install_root_files()
- Call install_hooks()
- Call validate_installation()
- Print success summary

### TASK-062: Update Flow
Implement make update:
- Check for newer version
- Pull from agentops
- Merge intelligently
- Update settings
- Validate
- Show changelog

### TASK-063: Uninstall Flow
Implement make uninstall:
- Confirm with user
- Backup first
- Remove cleanly
- Update .gitignore
- Report results

### TASK-064: Polish Error Messages
Review and perfect all error messages:
- Consistent format
- Always suggest fix
- Link to help docs
- Test with various scenarios

### TASK-065-069: Documentation
Write comprehensive guides for users:
- Installation guide (quick start + detailed)
- Configuration reference
- Troubleshooting guide
- Profile documentation
- Developer setup guide

### TASK-070: Final Polish
Final review and optimization:
- Performance tuning
- Edge case handling
- Final testing
- Code cleanup
- Prepare for launch

## Documentation Checklist

### User-Facing Docs

- [ ] Installation guide (INSTALL.md)
- [ ] Configuration reference (CONFIG.md)
- [ ] Troubleshooting (TROUBLESHOOTING.md)
- [ ] Profile guide (PROFILES.md)
- [ ] FAQ (FAQ.md)
- [ ] Examples (examples/)

### Developer Docs

- [ ] Developer setup (docs/DEVELOPER.md)
- [ ] Architecture (docs/ARCHITECTURE.md)
- [ ] Extending profiles (docs/EXTENDING.md)
- [ ] Testing guide (docs/TESTING.md)

## Success Criteria

- ✅ All 11 tasks completed
- ✅ Complete user documentation
- ✅ All error messages helpful and actionable
- ✅ Configuration system working (interactive + file)
- ✅ Update/uninstall flows working
- ✅ Final test on all platforms passing
- ✅ Ready for Dec 1 public launch
- ✅ Zero critical bugs

## After Completion

1. Mark TASK-060 through TASK-070 as `[x]` in `tasks.md`
2. Commit: `feat(base-install): Phase 5 - Documentation and final polish`
3. Run final validation: `make verify`
4. Run full test suite: `make test-install`
5. **All tasks complete!** Ready for launch.

## Launch Checklist

Before Dec 1 release:

- [ ] All phases 1-5 complete
- [ ] All tests passing on macOS, Linux, WSL
- [ ] Documentation reviewed and complete
- [ ] Error messages polished and helpful
- [ ] Performance targets met (< 30s fresh install)
- [ ] Rollback/recovery tested
- [ ] README.md updated with getting-started
- [ ] Git history clean and semantic
- [ ] Ready to publish!

This completes the Base Installation System for Dec 1 launch! 🚀
