# AgentOps Base Installation System

**Universal installation system for AgentOps framework in any project**

This directory contains the implementation of the Base Installation System - a cross-platform, idempotent installation mechanism that brings AgentOps framework capabilities to any project.

---

## Overview

The Base Installation System provides:

- **Universal Installation** - Works on macOS, Linux, and Windows WSL
- **Makefile Interface** - Simple, discoverable `make install` pattern
- **Bash Scripts** - Portable backend with platform detection
- **Profile Support** - Customizable profiles (default, product-dev, devops)
- **Intelligent Merging** - Preserves user customizations when updating
- **Comprehensive Validation** - Ensures successful installation
- **Diagnostics** - `make doctor` troubleshooting tool

---

## Project Structure

```
agent-os/
├── Makefile                 ← Main user interface
├── README.md                ← This file
├── .gitignore               ← Generated artifacts to ignore
│
├── scripts/
│   ├── base-install.sh      ← Main installation script
│   ├── lib/                 ← Reusable libraries
│   │   ├── platform.sh      ← Platform detection
│   │   ├── prerequisites.sh ← Prerequisite checking
│   │   ├── profiles.sh      ← Profile management
│   │   ├── validation.sh    ← Installation validation
│   │   └── common.sh        ← Shared utilities
│   │
│   └── templates/           ← Installation templates
│       ├── CONSTITUTION.md  ← Framework laws template
│       ├── CLAUDE.md        ← Project kernel template
│       └── .claude/
│           ├── settings.json
│           └── README.md
│
└── specs/                   ← Implementation specifications
    └── 2025-11-05-base-installation/
        ├── spec.md          ← Technical specification
        ├── tasks.md         ← Task breakdown
        └── ...
```

---

## Quick Start

### For Users (Installing in Your Project)

```bash
# 1. Go to your project
cd my-project

# 2. Copy the Makefile and scripts
cp /path/to/agentops/agent-os/Makefile .
cp -r /path/to/agentops/agent-os/scripts .

# 3. Run installation
make install

# 4. Follow prompts, done!
```

### For Developers (Working on This System)

```bash
# Review the specification
cat specs/2025-11-05-base-installation/spec.md

# Understand what needs implementing
cat specs/2025-11-05-base-installation/tasks.md

# Follow the phase prompts
cat implementation/prompts/1-foundation-and-project-setup.md
```

---

## Installation Phases

The Base Installation System is built in 5 phases:

### Phase 1: Foundation & Project Setup ✅ (COMPLETE)
- Directory structure
- Makefile skeleton with all targets
- Template files (CONSTITUTION.md, CLAUDE.md)
- .claude/ structure template
- base-install.sh skeleton
- .gitignore and documentation

**Status:** All 6 tasks complete!

### Phase 2: Core Script Backend (Pending)
- Platform detection (lib/platform.sh)
- Prerequisite checking (lib/prerequisites.sh)
- Shared utilities (lib/common.sh)
- Auto-install for Python/uv

### Phase 3: Installation Logic (Pending)
- Profile management (lib/profiles.sh)
- Merge strategy for existing installations
- Root file installation (CONSTITUTION.md, CLAUDE.md)
- Git hooks installation

### Phase 4: Validation & Testing (Pending)
- Post-install validation (make verify)
- Diagnostics tool (make doctor)
- Automated test suite
- Platform-specific tests

### Phase 5: Documentation & Polish (Pending)
- User guides and examples
- Troubleshooting documentation
- Error message refinement
- Final testing and optimization

---

## Makefile Targets

```bash
make install              # Install AgentOps framework interactively
make install-profile      # Add additional profile (devops, product-dev)
make verify              # Validate successful installation
make update              # Update framework to latest version
make doctor              # Diagnose installation issues
make uninstall           # Remove AgentOps framework
make help                # Display help message
```

---

## Design Principles

### Idempotent
Safe to run multiple times without side effects. Can update existing installations without losing customizations.

### Descriptive Output
Informs users clearly about what's happening. Not verbose, not silent - provides actionable feedback.

### Fail Fast
Clear error messages with fix suggestions. Never leaves system in partial state. Easy rollback and recovery.

### Universal
Works on macOS, Linux, and Windows WSL. Minimal dependencies. Accessible to all developers.

### Portable
POSIX-compatible Bash scripts. No external tools beyond git, Python/uv, and Claude Code CLI.

---

## Key Features

### Multi-Profile Support
Install different profiles for different use cases:
- **default** - Minimal, universal patterns
- **product-dev** - Product development workflows
- **devops** - Infrastructure/operations workflows

### Three Installation Modes
- **copy** - Copy files from agentops/profiles/ (default)
- **symlink** - Symlink to agentops repo (development)
- **download** - Fetch from remote URL (public release)

### Intelligent Merge Strategy
When updating existing installations:
- Preserves user customizations
- Backs up existing state
- Validates before committing
- Easy rollback on error

### Configuration System
- **Interactive prompts** - Guided setup for new users
- **Config file** - Non-interactive setup via install.config.json
- **Environment variables** - Override via AGENTOPS_MODEL, etc.

### Validation & Diagnostics
- **make verify** - Post-install validation (6 checks)
- **make doctor** - Comprehensive diagnostics and troubleshooting
- **Automated tests** - Unit, integration, and platform tests

---

## Development Status

**Framework Status:** Phase 1 Complete ✅
**Target Launch:** December 1, 2025
**Timeline:** 60-80 hours total across 5 phases

### Completed
- ✅ Project directory structure
- ✅ Makefile with all targets (stubs)
- ✅ Template files (CONSTITUTION.md, CLAUDE.md)
- ✅ .claude/ structure template
- ✅ base-install.sh skeleton
- ✅ .gitignore and README

### In Progress
- Phase 2: Core script backend (platform detection, prerequisites)

### Upcoming
- Phase 3: Installation logic (profiles, merge strategy)
- Phase 4: Validation & testing (verify, doctor, tests)
- Phase 5: Documentation & polish (guides, error messages)

---

## Testing

### Phase 1 Testing (Current)

```bash
# Test Makefile
cd /Users/fullerbt/workspace/agentops/agent-os
make help          # Should display all commands
make install       # Should show stub output
make verify        # Should show stub validation
make doctor        # Should show stub diagnostics

# Test base-install.sh
./scripts/base-install.sh --help     # Should show usage
./scripts/base-install.sh            # Should run without error
```

### Full Test Suite (Later Phases)

Phase 4 will implement:
- Unit tests for all library functions
- Integration tests for full workflows
- Platform-specific tests (macOS, Linux, WSL)
- User acceptance testing

---

## Specification Reference

Complete technical details available in:

- **Specification:** `specs/2025-11-05-base-installation/spec.md` (3,671 lines)
- **Requirements:** `specs/2025-11-05-base-installation/planning/requirements.md`
- **Tasks:** `specs/2025-11-05-base-installation/tasks.md`

---

## Contributing

When working on this system:

1. **Read CONSTITUTION.md** - Understand the Five Laws
2. **Follow semantic commits** - `feat()`, `fix()`, `docs()`
3. **Extract learnings** - Document patterns discovered
4. **Improve the system** - Identify and implement improvements
5. **Run tests** - Ensure changes work across platforms

---

## Timeline

### Phase 1: Foundation ✅
**Completed:** Nov 5, 2025
- 6 tasks, all complete
- Makefile skeleton ready
- Templates prepared for phases 2-5

### Phase 2: Backend (Nov 5-8, ~24 hours)
**Estimated:** 9 tasks
- Platform detection
- Prerequisite checking
- Utility libraries

### Phase 3: Logic (Nov 9-14, ~24 hours)
**Estimated:** 14 tasks
- Profile management
- Installation workflow
- Merge strategy

### Phase 4: Testing (Nov 15-20, ~20 hours)
**Estimated:** 12 tasks
- Validation framework
- Diagnostics tool
- Comprehensive test suite

### Phase 5: Polish (Nov 21-28, ~12 hours)
**Estimated:** 11 tasks
- Documentation
- Error messages
- Final testing

**Target Launch:** December 1, 2025

---

## Success Criteria

✅ **Phase 1 (Complete):**
- [x] Directory structure created
- [x] Makefile with all 7 targets
- [x] CONSTITUTION.md template
- [x] CLAUDE.md template
- [x] .claude/settings.json template
- [x] .claude/README.md template
- [x] base-install.sh skeleton with argument parsing
- [x] .gitignore and documentation

🎯 **Overall Success (Dec 1):**
- [ ] All 5 phases complete
- [ ] 70 tasks finished
- [ ] Works on macOS, Linux, WSL
- [ ] < 30 second fresh install
- [ ] 95%+ users have zero config errors
- [ ] Comprehensive documentation
- [ ] Ready for public launch

---

## More Information

- **Framework:** [AgentOps Documentation](https://agentops.dev/docs)
- **Questions:** Open an issue in the repository
- **Contribution:** See CONTRIBUTING.md (future)

---

**Phase 1 Status:** ✅ COMPLETE
**Next Phase:** Backend Libraries
**Timeline:** On track for Dec 1, 2025 launch

🚀 Foundation is solid. Ready to build the rest!
