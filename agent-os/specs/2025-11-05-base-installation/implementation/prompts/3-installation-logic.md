# Phase 3: Installation Logic

We're implementing the core installation logic: profile management, merge strategy, and component installation.

## Key Tasks (14 total)

- [ ] **TASK-020:** Implement agentops repo detection (lib/profiles.sh)
- [ ] **TASK-021:** Implement profile listing (lib/profiles.sh)
- [ ] **TASK-022:** Implement profile validation (lib/profiles.sh)
- [ ] **TASK-023:** Implement copy_profile() mode (lib/profiles.sh)
- [ ] **TASK-024:** Implement symlink_profile() mode (lib/profiles.sh)
- [ ] **TASK-025:** Implement download_profile() mode (lib/profiles.sh)
- [ ] **TASK-026:** Implement interactive profile selection (lib/profiles.sh)
- [ ] **TASK-027:** Implement settings merge logic (lib/profiles.sh)
- [ ] **TASK-028:** Implement installation manifest (lib/profiles.sh)
- [ ] **TASK-029:** Implement existing installation detection (base-install.sh)
- [ ] **TASK-030:** Implement backup logic (base-install.sh)
- [ ] **TASK-031:** Implement install_base_structure() (base-install.sh)
- [ ] **TASK-032:** Implement install_root_files() (base-install.sh)
- [ ] **TASK-033:** Implement git hooks installation (base-install.sh)

## Core Concepts

### Profile System

**Three installation modes:**
1. **copy** - Copy files from agentops/profiles/ to user project (default)
2. **symlink** - Symlink to agentops repo (development)
3. **download** - Fetch from remote URL (public release)

**Profile structure:**
```
agentops/profiles/default/
├── agents/
├── commands/
├── skills/
└── README.md
```

### Merge Strategy

**Intelligent merging** when .claude/ already exists:
- Framework files (settings.json) → update
- User files → ask before overwrite
- Directories → recursive merge
- Backups on every update

### Installation Flow

```
1. Detect agentops repo location
2. List available profiles
3. Validate profile structure
4. Select profile (interactive or config)
5. Backup existing .claude/
6. Install profile (copy/symlink/download)
7. Merge settings
8. Install root files (CONSTITUTION.md, CLAUDE.md)
9. Install git hooks
10. Validate installation
```

## Detailed Tasks

### TASK-020: Detect AgentOps Repo
- Find agentops repo: env var, parent dir, current dir, fallback to online
- Validate agentops structure
- Set AGENTOPS_HOME variable

### TASK-021: List Profiles
- Scan agentops/profiles/
- Return list of valid profiles
- Include profile descriptions

### TASK-022: Validate Profile
- Check profile has agents/, commands/, skills/ (or at least one)
- Verify README.md exists
- Report any issues

### TASK-023: Copy Profile
- Copy from agentops/profiles/[name]/ to user .claude/
- Preserve directory structure
- Merge with existing if present

### TASK-024: Symlink Profile
- Create symlinks in .claude/ pointing to agentops/profiles/[name]/
- Useful for development
- Verify symlinks work

### TASK-025: Download Profile
- Fetch from remote URL (GitHub raw)
- Verify checksum
- Cache locally
- Extract to .claude/

### TASK-026: Interactive Selection
- Show available profiles
- Let user choose
- Explain each option
- Default to "default" profile

### TASK-027: Merge Settings
- Load existing settings.json (if exists)
- Load profile settings
- Merge intelligently:
  - Keep user customizations
  - Add new framework fields
  - Update version/framework info

### TASK-028: Installation Manifest
- Track what was installed
- Version info
- Profile used
- Installation date
- For future updates/rollback

### TASK-029: Detect Existing Install
- Check .claude/ directory exists
- Check CONSTITUTION.md, CLAUDE.md
- Version detection
- State reporting (installed, partial, broken)

### TASK-030: Backup Logic
- Create timestamped backups
- Keep last 3 backups
- Quick rollback capability
- Error recovery

### TASK-031: Install Base Structure
- Create .claude/ if not exists
- Create agents/, commands/, skills/ dirs
- Copy settings.json template
- Create README.md

### TASK-032: Install Root Files
- Copy CONSTITUTION.md template
- Copy CLAUDE.md template
- Substitute placeholders
- Update .gitignore

### TASK-033: Git Hooks
- Create pre-commit hook (validation)
- Create post-commit hook (learning extraction)
- Make executable
- Allow user to disable

## Understand the Context

Read `/Users/fullerbt/workspace/agentops/agent-os/specs/2025-11-05-base-installation/spec.md`:
- Section 3.5 - Profile management
- Section 4.2 - Merge strategy
- Section 4.3 - Configuration schema
- Section 7 - Installation flow

Also:
- Section 4.1 - Installation algorithm (complete reference)
- Requirements FR6, FR7, FR8

## Success Criteria

- ✅ All 14 tasks completed
- ✅ Profiles can be installed in all 3 modes (copy, symlink, download)
- ✅ Merge strategy preserves user customizations
- ✅ Existing installations detected correctly
- ✅ Backup/rollback works reliably
- ✅ Root files installed with proper substitution
- ✅ Git hooks created and executable
- ✅ Installation manifest tracks installation

## After Completion

1. Mark TASK-020 through TASK-033 as `[x]` in `tasks.md`
2. Commit: `feat(base-install): Phase 3 - Installation logic and profile management`
3. Test manually: `make install` should work
4. Report ready for Phase 4

This phase makes the system actually work!
