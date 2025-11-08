# Implementation Plan: Transform AgentOps to Claude Code Plugin Marketplace

## Summary
Transform the existing AgentOps framework repository into a Claude Code plugin marketplace, enabling distribution through official Claude Code `/plugin` commands. This maintains backward compatibility while enabling modular installation of framework components.

## Timeline
- **Target:** Complete by Nov 10, 2025 (3 days before launch prep)
- **Duration:** 2-3 days implementation
- **Testing:** 1 day validation

## Changes Specified

### Phase 1: Marketplace Structure Creation

#### 1. Create `.claude-plugin/marketplace.json`
**File:** `/Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json`
**Purpose:** Root marketplace manifest defining all available plugins
**Content:**
```json
{
  "$schema": "https://schemas.claude.com/marketplace/v1/schema.json",
  "name": "agentops",
  "version": "1.0.0",
  "description": "Universal operating system patterns for reliable AI agent operations",
  "owner": {
    "name": "AgentOps Framework",
    "email": "team@agentops.ai"
  },
  "plugins": [
    {
      "name": "agentops-core",
      "source": "./plugins/agentops-core",
      "description": "Core AgentOps platform with universal commands, agents, and workflows",
      "category": "framework",
      "version": "1.0.0",
      "tags": ["ai-agents", "workflows", "automation"],
      "author": {
        "name": "AgentOps Team"
      }
    },
    {
      "name": "agentops-devops",
      "source": "./plugins/agentops-devops",
      "description": "DevOps profile with Kubernetes, Docker, and CI/CD specialized agents",
      "category": "devops",
      "version": "1.0.0",
      "tags": ["kubernetes", "docker", "ci-cd", "gitops"]
    },
    {
      "name": "agentops-product-dev",
      "source": "./plugins/agentops-product-dev",
      "description": "Product development profile with API, UI, and database agents",
      "category": "development",
      "version": "1.0.0",
      "tags": ["apis", "frontend", "backend", "databases"]
    }
  ]
}
```
**Validation:** `jq '.' .claude-plugin/marketplace.json`

### Phase 2: Plugin Directory Structure

#### 2. Create plugins directory structure
**Command:** `mkdir -p plugins/{agentops-core,agentops-devops,agentops-product-dev}/.claude-plugin`
**Purpose:** Organize plugins in standard marketplace structure

#### 3. Move core components to agentops-core plugin
**Source:** `core/*`
**Destination:** `plugins/agentops-core/`
**Commands:**
```bash
# Move core components
mv core/commands plugins/agentops-core/
mv core/agents plugins/agentops-core/
mv core/workflows plugins/agentops-core/
mv core/skills plugins/agentops-core/
cp core/CONSTITUTION.md plugins/agentops-core/

# Create symlinks for backward compatibility
ln -s plugins/agentops-core/commands core/commands
ln -s plugins/agentops-core/agents core/agents
ln -s plugins/agentops-core/workflows core/workflows
```
**Validation:** `ls -la plugins/agentops-core/`

#### 4. Create agentops-core plugin.json
**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-core/.claude-plugin/plugin.json`
**Content:**
```json
{
  "name": "agentops-core",
  "version": "1.0.0",
  "description": "Core AgentOps framework with universal patterns for AI agent operations",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/agentops/agentops",
  "license": "Apache-2.0",
  "keywords": ["ai-agents", "workflows", "automation", "framework"],
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "commands": "./commands",
    "agents": "./agents",
    "workflows": "./workflows",
    "hooks": "./skills"
  },
  "dependencies": []
}
```
**Validation:** `jq '.' plugins/agentops-core/.claude-plugin/plugin.json`

#### 5. Move devops profile to plugin
**Source:** `profiles/devops/*`
**Destination:** `plugins/agentops-devops/`
**Commands:**
```bash
# Move profile components
cp -r profiles/devops/* plugins/agentops-devops/
# Create symlink for compatibility
ln -s ../../plugins/agentops-devops profiles/devops-plugin
```
**Validation:** `ls -la plugins/agentops-devops/`

#### 6. Create agentops-devops plugin.json
**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-devops/.claude-plugin/plugin.json`
**Content:**
```json
{
  "name": "agentops-devops",
  "version": "1.0.0",
  "description": "DevOps specialized agents for Kubernetes, Docker, CI/CD workflows",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/agentops/agentops",
  "license": "Apache-2.0",
  "keywords": ["kubernetes", "docker", "ci-cd", "devops", "gitops"],
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "agents": "./agents",
    "commands": "./commands",
    "workflows": "./workflows"
  },
  "dependencies": ["agentops-core"]
}
```
**Validation:** `jq '.' plugins/agentops-devops/.claude-plugin/plugin.json`

#### 7. Move product-dev profile to plugin
**Source:** `profiles/product-dev/*`
**Destination:** `plugins/agentops-product-dev/`
**Commands:**
```bash
# Move profile components
cp -r profiles/product-dev/* plugins/agentops-product-dev/
# Create symlink for compatibility
ln -s ../../plugins/agentops-product-dev profiles/product-dev-plugin
```
**Validation:** `ls -la plugins/agentops-product-dev/`

#### 8. Create agentops-product-dev plugin.json
**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-product-dev/.claude-plugin/plugin.json`
**Content:**
```json
{
  "name": "agentops-product-dev",
  "version": "1.0.0",
  "description": "Product development agents for APIs, UIs, and databases",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/agentops/agentops",
  "license": "Apache-2.0",
  "keywords": ["api", "frontend", "backend", "database", "product-development"],
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "agents": "./agents",
    "commands": "./commands",
    "workflows": "./workflows",
    "validation": "./validation"
  },
  "dependencies": ["agentops-core"]
}
```
**Validation:** `jq '.' plugins/agentops-product-dev/.claude-plugin/plugin.json`

### Phase 3: Documentation Updates

#### 9. Update main README.md
**File:** `/Users/fullerbt/workspaces/personal/agentops/README.md`
**Change:** Add new "Installation" section at line 50
**Content:**
```markdown
## Installation

### Via Claude Code Plugin Marketplace (Recommended)

```bash
# Install core framework
/plugin install agentops-core

# Add domain-specific profiles
/plugin install agentops-devops      # For Kubernetes/Docker work
/plugin install agentops-product-dev  # For API/UI development
```

### Via GitHub Marketplace

```bash
# Add the AgentOps marketplace
/plugin marketplace add agentops/agentops

# Browse available plugins
/plugin list

# Install what you need
/plugin install agentops-core
```

### Manual Installation (Legacy)

For backward compatibility, you can still clone and use directly:
```bash
git clone https://github.com/agentops/agentops.git
cd agentops
# Follow legacy setup instructions below
```
```
**Validation:** `grep -n "Installation" README.md`

#### 10. Create MIGRATION.md
**File:** `/Users/fullerbt/workspaces/personal/agentops/MIGRATION.md`
**Purpose:** Guide for existing users to migrate to plugin model
**Content:**
```markdown
# Migration Guide: AgentOps to Plugin Marketplace

## For Existing Users

### What's Changed
AgentOps now distributes as Claude Code plugins for easier installation and modular adoption.

### Migration Steps

1. **Keep your existing setup** (still works)
   - Symlinks maintain backward compatibility
   - No breaking changes to core functionality

2. **Optional: Switch to plugin model**
   ```bash
   # Install via Claude Code
   /plugin install agentops-core
   /plugin install agentops-devops  # If using DevOps profile
   ```

3. **Update your .claude/settings.json** (if customized)
   - Remove manual path references
   - Plugins auto-configure paths

### Benefits of Migration
- Automatic updates through marketplace
- Cleaner installation
- Pick only profiles you need
- Community plugins available

### Breaking Changes
None. All existing workflows continue to work.

### Need Help?
Open an issue: https://github.com/agentops/agentops/issues
```
**Validation:** `wc -l MIGRATION.md`

#### 11. Create plugins/README.md
**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/README.md`
**Purpose:** Explain plugin structure for contributors
**Content:**
```markdown
# AgentOps Plugin Collection

## Available Plugins

### agentops-core (Required)
Base framework with:
- 12 universal commands
- 9 agent personas
- Core workflows
- CONSTITUTION enforcement

### agentops-devops
Specialized for:
- Kubernetes operations
- Docker workflows
- CI/CD pipelines
- GitOps patterns

### agentops-product-dev
Optimized for:
- API development
- UI/UX workflows
- Database design
- Full-stack patterns

## Creating New Plugins

See [CONTRIBUTING.md](../CONTRIBUTING.md) for plugin development guide.

## Installation

```bash
/plugin install agentops-core
/plugin install [profile-name]
```
```
**Validation:** `ls plugins/README.md`

### Phase 4: Compatibility Layer

#### 12. Create compatibility script
**File:** `/Users/fullerbt/workspaces/personal/agentops/scripts/ensure-compatibility.sh`
**Purpose:** Ensure backward compatibility with symlinks
**Content:**
```bash
#!/bin/bash
# Ensure backward compatibility for existing users

echo "Setting up compatibility layer..."

# Create symlinks if not exists
if [ ! -L "core/commands" ]; then
  ln -sf ../plugins/agentops-core/commands core/commands
fi

if [ ! -L "core/agents" ]; then
  ln -sf ../plugins/agentops-core/agents core/agents
fi

if [ ! -L "core/workflows" ]; then
  ln -sf ../plugins/agentops-core/workflows core/workflows
fi

echo "Compatibility layer ready."
```
**Validation:** `bash -n scripts/ensure-compatibility.sh`

## Test Strategy

### Marketplace Validation
```bash
# 1. Validate JSON structure
jq '.' .claude-plugin/marketplace.json
jq '.' plugins/*/claude-plugin/plugin.json

# 2. Test local installation
cd /tmp/test-install
/plugin marketplace add file:///Users/fullerbt/workspaces/personal/agentops
/plugin list
/plugin install agentops-core

# 3. Verify commands available
/help | grep -E "prime|research|plan|implement"
```

### Backward Compatibility Tests
```bash
# 1. Verify symlinks work
ls -la core/commands/
cat core/commands/prime.md | head -5

# 2. Test existing workflows
/prime
/research test-topic

# 3. Verify profiles still accessible
ls profiles/devops-plugin/
```

### Integration Tests
```bash
# 1. Test core plugin alone
/plugin install agentops-core
/prime  # Should work

# 2. Test with domain plugin
/plugin install agentops-devops
/help | grep kubernetes  # Should show DevOps commands

# 3. Test multiple plugins
/plugin install agentops-product-dev
/help | grep api  # Should show product commands
```

## Rollback Procedure

If implementation fails:

### Immediate Rollback (< 5 minutes)
```bash
# 1. Remove plugin directories
rm -rf plugins/
rm -rf .claude-plugin/

# 2. Restore core from symlinks
rm core/commands core/agents core/workflows
git checkout -- core/

# 3. Verify restoration
ls -la core/
/prime  # Test basic command
```

### Git-based Rollback
```bash
# 1. Find last good commit
git log --oneline -10

# 2. Revert to previous state
git checkout [last-good-sha] -- .

# 3. Verify
make test
```

### Recovery Validation
- [ ] Core commands work: `/prime`, `/research`
- [ ] Profiles accessible: `ls profiles/`
- [ ] No broken symlinks: `find . -type l -exec test ! -e {} \; -print`
- [ ] Documentation intact: `ls *.md`

## Risk Assessment

### Low Risk
- No breaking changes to existing functionality
- Symlinks maintain compatibility
- Can rollback in < 5 minutes

### Medium Risk
- Users might be confused by dual structure initially
- Need clear migration documentation

### Mitigations
- Extensive compatibility testing before release
- Clear MIGRATION.md guide
- Support both models during transition

## Approval Checklist

- [ ] Marketplace structure matches Claude Code standards
- [ ] All plugins have valid plugin.json
- [ ] Backward compatibility maintained
- [ ] Documentation updated
- [ ] Test strategy comprehensive
- [ ] Rollback procedure verified
- [ ] Ready for implementation

## Implementation Order

1. **Day 1 (Nov 8):** Create marketplace structure (Phase 1-2)
2. **Day 2 (Nov 9):** Move components and test (Phase 3-4)
3. **Day 3 (Nov 10):** Documentation and validation
4. **Nov 11-12:** Community testing
5. **Dec 1:** Public launch

## Success Metrics

- [ ] `/plugin install agentops-core` works
- [ ] Existing users experience no breaking changes
- [ ] New users can install in < 1 minute
- [ ] All tests pass
- [ ] Documentation clear and complete

---

**Plan created:** November 7, 2025
**Estimated effort:** 2-3 days
**Risk level:** Low
**Backward compatibility:** Fully maintained

## Next Steps

1. Get approval for this plan
2. Save plan bundle: `/bundle-save marketplace-plan`
3. Start fresh session for implementation
4. Load plan: `/bundle-load marketplace-plan`
5. Execute: `/implement`