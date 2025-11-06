# Phase 1: Foundation & Project Setup

We're implementing the Base Installation System for AgentOps by starting with Phase 1: establishing the project structure, Makefile interface, and base templates.

## Implement these tasks:

- [ ] **TASK-001:** Create project directory structure
  - **Description:** Create scripts/, scripts/lib/, scripts/templates/ directories in agentops/agent-os/
  - **Deliverables:** Directory structure matching spec section 2.3
  - **Acceptance:** Directories exist: scripts/, scripts/lib/, scripts/templates/, scripts/templates/.claude/
  - **Estimate:** 30 minutes
  - **Reference:** Spec section 2.3

- [ ] **TASK-002:** Create Makefile skeleton with all targets
  - **Description:** Build Makefile with install, install-profile, verify, update, doctor, uninstall, help targets (stubs)
  - **Deliverables:** Makefile with all targets as stubs that print messages
  - **Acceptance:** `make help` displays all commands, each target runs without error and prints placeholder message
  - **Estimate:** 2 hours
  - **Reference:** Spec section 3.1, requirements FR5

- [ ] **TASK-003:** Create base template files
  - **Description:** Create CONSTITUTION.md, CLAUDE.md templates with placeholders
  - **Deliverables:** scripts/templates/CONSTITUTION.md, scripts/templates/CLAUDE.md with variable placeholders
  - **Acceptance:** Templates contain Five Laws, project name placeholder, date placeholder
  - **Estimate:** 1.5 hours
  - **Reference:** Requirements FR1, spec section 4.2

- [ ] **TASK-004:** Create .claude/ structure template
  - **Description:** Create template .claude/ directory with settings.json template, README.md
  - **Deliverables:** scripts/templates/.claude/settings.json, README.md with default content
  - **Acceptance:** Template files parse as valid JSON/Markdown, contain placeholders for customization
  - **Estimate:** 2 hours
  - **Reference:** Requirements FR1, spec section 2.3

- [ ] **TASK-005:** Create base-install.sh skeleton
  - **Description:** Create main script with argument parsing, main() flow stub, library imports
  - **Deliverables:** scripts/base-install.sh with basic structure, set -euo pipefail, argument parsing
  - **Acceptance:** Script runs without error, --help flag shows usage, imports library files without failing
  - **Estimate:** 1.5 hours
  - **Reference:** Spec section 3.2

- [ ] **TASK-006:** Setup .gitignore and documentation stubs
  - **Description:** Create README.md stub, .gitignore for generated files
  - **Deliverables:** agent-os/README.md, .gitignore
  - **Acceptance:** README explains purpose, .gitignore covers backups and temp files
  - **Estimate:** 30 minutes

## Understand the context

Read `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/spec.md` to understand the architecture and design principles.

Also review:
- `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/planning/requirements.md` - Detailed functional requirements
- Spec section 2.3 for directory structure
- Spec section 3.1 for Makefile interface design

## Design Principles to Follow

From the spec and requirements:

1. **Idempotent Design** - Safe to run multiple times
2. **Descriptive Output** - Not verbose, not silent (inform user)
3. **Fail Fast** - Clear error messages
4. **Preserve User Customizations** - Merge strategy
5. **Universal** - Work on macOS, Linux, Windows WSL

## Implementation Guidance

### Directory Structure (TASK-001)
Create in `/Users/fullerbt/workspace/agentops/agent-os/`:
```
scripts/
├── lib/
│   ├── platform.sh
│   ├── prerequisites.sh
│   ├── profiles.sh
│   ├── validation.sh
│   └── common.sh
├── templates/
│   ├── .claude/
│   │   ├── settings.json
│   │   └── README.md
│   ├── CONSTITUTION.md
│   └── CLAUDE.md
└── base-install.sh
```

### Makefile (TASK-002)
Create in `/Users/fullerbt/workspace/agentops/`:
- Target: `make install` - Install AgentOps framework
- Target: `make install-profile PROFILE=<name>` - Install additional profile
- Target: `make verify` - Validate installation
- Target: `make update` - Update to latest version
- Target: `make doctor` - Diagnose issues
- Target: `make uninstall` - Remove AgentOps
- Target: `make help` - Display help

All targets should be idempotent and provide descriptive output.

### Templates (TASK-003, TASK-004)
Use placeholder syntax like `{{PROJECT_NAME}}`, `{{DATE}}` for customization during installation.

### base-install.sh (TASK-005)
Structure:
```bash
#!/usr/bin/env bash
set -euo pipefail

# Source library files
source "$(dirname "$0")/lib/platform.sh"
source "$(dirname "$0")/lib/prerequisites.sh"
source "$(dirname "$0")/lib/profiles.sh"
source "$(dirname "$0")/lib/validation.sh"
source "$(dirname "$0")/lib/common.sh"

# Parse arguments
# Main flow
# Error handling
```

## Success Criteria

- ✅ All 6 tasks completed
- ✅ Directory structure matches spec section 2.3
- ✅ Makefile skeleton has all 7 targets (install, install-profile, verify, update, doctor, uninstall, help)
- ✅ Templates contain proper placeholders
- ✅ scripts/base-install.sh has proper structure and can source libraries
- ✅ All files use semantic commit messages
- ✅ No breaking changes to existing agentops repository

## After Completion

When all tasks in Phase 1 are complete:
1. Mark all TASK-001 through TASK-006 as `[x]` in `tasks.md`
2. Commit changes with: `feat(base-install): Phase 1 - Foundation & project setup`
3. Report back for Phase 2

Good luck! This foundation enables all subsequent phases.
