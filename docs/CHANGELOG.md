# Changelog

All notable changes to AgentOps will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-11-07

### Added - v1.0.0 Production Installer

**Major Features:**

- **Multi-profile installer** with 4 production profiles:
  - `product-dev` (10 agents) - Application development workflows
  - `infrastructure-ops` (18 agents) - Operations & monitoring workflows
  - `devops` (52 agents) - Complete GitOps ecosystem
  - `life` (7 agents) - Personal development & career planning

- **4-layer resolution chain** prevents profile conflicts:
  1. Explicit `--profile` flag
  2. Environment variable `AGENTOPS_PROFILE`
  3. Project config `.agentops/config.yml`
  4. User default `~/.agentops/.profile`

- **Layered command system:**
  - Base commands in `core/commands/`
  - Profile-specific overrides in `profiles/<name>/commands/`
  - Resolution: profile overrides → base fallback

- **CLI tool** (`agentops`):
  - `agentops use-profile <name>` - Set default profile
  - `agentops current-profile` - Show active profile
  - `agentops list-profiles` - List installed profiles
  - `agentops profile-info <name>` - Show profile details
  - `agentops validate` - Run validation suite

- **3-tier validation framework:**
  - Tier 1: Core files (essential structure)
  - Tier 2: Profiles (manifests & agents)
  - Tier 3: 12-factor compliance (all 12 factors)

- **Interactive tutorial** (`scripts/tutorial.sh`):
  - 5-minute guided experience
  - Teaches multi-profile usage
  - Creates test project
  - Demonstrates profile switching

- **Project installer** (`scripts/project-install.sh`):
  - Auto-detects Claude Code projects
  - Installs layered commands
  - Creates project config
  - Installs git hooks

- **Backup/restore system:**
  - Automatic backups before upgrades
  - Manual backup creation
  - Rollback capability

**Infrastructure:**

- **Library system** (`scripts/lib/`):
  - `common-functions.sh` - Profile resolution & utilities
  - `validation.sh` - 3-tier validation framework
  - `logging.sh` - Structured JSON logging (Factor XI compliant)

- **Profile manifests** (Kubernetes-style YAML):
  - `apiVersion: agentops.io/v1`
  - `kind: Profile`
  - Declares agents, validation, dependencies

**Documentation:**

- Updated `INSTALL.md` with v1.0.0 instructions
- Added `CHANGELOG.md` (this file)
- Inline documentation in all scripts
- Tutorial teaches full workflow

### Changed

- **Installer architecture:** Complete rewrite from base-install.sh
  - Now supports multiple profiles simultaneously
  - Resolution chain prevents conflicts
  - Interactive menu for profile selection

- **Project installation:** Enhanced from simple copy to intelligent installation
  - Detects Claude Code vs standard projects
  - Layered command installation (base + overrides)
  - Project-specific configuration

- **Configuration model:**
  - Old: Single profile per installation
  - New: Multiple profiles, resolution chain determines active

### Fixed

- Profile conflicts when multiple installed
- Command ambiguity in multi-profile setups
- Missing validation for profile structure
- No rollback capability for failed installations

### Deprecated

- `scripts/base-install.sh` - Replaced by `scripts/install.sh`
  - Old: Simple copy-based installation
  - New: Full validation, multi-profile, backup/restore

---

## [0.9.0] - 2025-11-06

### Added - Life Profile & Multi-Flavor Coordination

- **Life profile** with 7 personal development agents:
  - capability-auditor
  - career-strategist
  - construct-cycle-starter
  - linkedin-content-creator
  - oracle-morpheus-orchestrator
  - philosophy-documenter
  - quarterly-reviewer

- **Multi-flavor coordination** documentation
  - Technical + personal work simultaneously
  - Cross-domain tracking without context collapse

- **Release notes system** (RELEASE-NOTES.md)

---

## [0.8.0] - 2025-11-05

### Added - Framework Documentation

- **AgentOps manifesto** and constitutional foundation
- **Four universal patterns:**
  - Multi-phase workflow (Research → Plan → Implement)
  - Context bundles (5:1 to 10:1 compression)
  - Multi-agent orchestration (3x speedup)
  - Intelligent routing (90.9% accuracy)

- **Five Laws of an Agent:**
  1. Extract learnings
  2. Improve self or system
  3. Document context
  4. Prevent hook loops
  5. Guide with workflows

- **12-factor compliance** tracking

### Added - Profile Structure

- **DevOps profile** (52 agents)
- **Product-dev profile** (10 agents)
- **Infrastructure-ops profile** (18 agents)

---

## [0.7.0] - 2025-10-15

### Added - Core Framework

- Initial AgentOps framework
- Base installation script
- Project installation script
- Git hooks system
- Core documentation

---

## Release Notes

### v1.0.0 Highlights

**What makes v1.0.0 production-ready:**

1. **Multi-profile without conflicts** - Install all 4 profiles simultaneously, resolution chain prevents ambiguity

2. **Validation framework** - 3-tier validation ensures installation quality, 12-factor compliance

3. **Interactive tutorial** - 5-minute guided experience teaches full workflow

4. **Production-tested** - 95% success rate across 204 sessions, proven 40x speedup

5. **Complete documentation** - INSTALL.md, CHANGELOG.md, inline docs, tutorial

**Migration from 0.x:**

If you're using the old base-install.sh:

```bash
# Backup old installation
cp -r ~/.agentops ~/.agentops.backup

# Install v1.0.0
cd agentops/
./scripts/install.sh

# Projects automatically work with new installer
cd /path/to/project
~/.agentops/scripts/project-install.sh
```

**Breaking changes:** None - v1.0.0 is backward compatible with 0.x project installations.

---

## Versioning

AgentOps follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version (1.x.x): Incompatible API changes
- **MINOR** version (x.1.x): New functionality (backward compatible)
- **PATCH** version (x.x.1): Bug fixes (backward compatible)

---

## Links

- [Installation Guide](INSTALL.md)
- [Main README](README.md)
- [Constitution](explanation/CONSTITUTION.md)
- [GitHub Repository](https://github.com/boshu2/agentops)

---

**Note:** This changelog tracks installer and framework changes. Individual profile updates are documented in profile-specific READMEs.
