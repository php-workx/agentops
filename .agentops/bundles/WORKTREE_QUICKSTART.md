# Worktree Quick-Start Guide

**Date:** November 7, 2025
**Purpose:** Get the 3 parallel worktrees set up and begin implementation
**Estimated Setup Time:** 15 minutes
**Implementation Time:** 5-7 days (parallelized)

---

## Overview

We'll create 3 git worktrees to work on the marketplace transformation in parallel:

1. **marketplace** - Marketplace structure and core plugins
2. **meta-orchestrator** - Self-learning meta-orchestrator plugin
3. **testing** - Testing infrastructure and documentation

Each worktree works independently, then we merge them together on Day 6.

---

## Part 1: Prerequisites

### Check Current State

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Verify you're in the right directory
pwd

# Check current git status
git status

# Verify no uncommitted changes
git diff --quiet || echo "⚠️ You have uncommitted changes"

# Check current branch
git branch --show-current
```

### Ensure Clean State

```bash
# Commit any pending work
git add .
git commit -m "Checkpoint before worktree creation" || echo "Nothing to commit"

# Verify clean state
git status
```

---

## Part 2: Create Worktrees

### Create Directory Structure

```bash
# We'll create worktrees in parent directory
cd /Users/fullerbt/.cursor/worktrees/agentops

# Verify structure
ls -la
# Should see: BG0D2 (current worktree)
```

### Create Worktree 1: Marketplace Structure

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Create worktree with new branch
git worktree add ../marketplace feature/marketplace-structure

# Verify creation
git worktree list

# Expected output:
# /Users/fullerbt/.cursor/worktrees/agentops/BG0D2        <current-branch>
# /Users/fullerbt/.cursor/worktrees/agentops/marketplace  feature/marketplace-structure
```

### Create Worktree 2: Meta-Orchestrator

```bash
# Create meta-orchestrator worktree
git worktree add ../meta-orchestrator feature/meta-orchestrator

# Verify
git worktree list

# Expected output:
# /Users/fullerbt/.cursor/worktrees/agentops/BG0D2             <current-branch>
# /Users/fullerbt/.cursor/worktrees/agentops/marketplace       feature/marketplace-structure
# /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator feature/meta-orchestrator
```

### Create Worktree 3: Testing & Documentation

```bash
# Create testing worktree
git worktree add ../testing feature/testing-docs

# Verify all worktrees
git worktree list

# Expected output:
# /Users/fullerbt/.cursor/worktrees/agentops/BG0D2             <current-branch>
# /Users/fullerbt/.cursor/worktrees/agentops/marketplace       feature/marketplace-structure
# /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator feature/meta-orchestrator
# /Users/fullerbt/.cursor/worktrees/agentops/testing           feature/testing-docs
```

---

## Part 3: Verify Worktrees

### Check Each Worktree

```bash
# Marketplace worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace
git branch --show-current  # Should show: feature/marketplace-structure
ls -la                     # Should show all project files

# Meta-orchestrator worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator
git branch --show-current  # Should show: feature/meta-orchestrator
ls -la

# Testing worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/testing
git branch --show-current  # Should show: feature/testing-docs
ls -la

# Return to main worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
```

---

## Part 4: Initial Setup Per Worktree

### Worktree 1: Marketplace Structure

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace

# Create initial directory structure
mkdir -p .claude-plugin
mkdir -p plugins/agentops-core/.claude-plugin
mkdir -p plugins/agentops-devops/.claude-plugin
mkdir -p plugins/agentops-product-dev/.claude-plugin

# Verify structure
tree -L 3 plugins/

# Commit initial structure
git add .
git commit -m "feat(marketplace): Initial plugin directory structure

- Create .claude-plugin directory for marketplace manifest
- Set up plugin directories for core, devops, product-dev
- Prepare for component migration"

git log --oneline -1  # Verify commit
```

### Worktree 2: Meta-Orchestrator

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator

# Create meta-orchestrator directory structure
mkdir -p plugins/agentops-meta-orchestrator/.claude-plugin
mkdir -p plugins/agentops-meta-orchestrator/{commands,skills/orchestrator,patterns/{discovered,validated,learned,meta},metrics,scripts,tests,workflows,docs}

# Create placeholder files
touch plugins/agentops-meta-orchestrator/README.md
touch plugins/agentops-meta-orchestrator/LEARNING_LOG.md

# Verify structure
tree -L 4 plugins/agentops-meta-orchestrator/

# Commit initial structure
git add .
git commit -m "feat(meta-orchestrator): Initial meta-orchestrator structure

- Create plugin directory with all subdirectories
- Set up patterns storage (discovered, validated, learned, meta)
- Prepare metrics, scripts, tests directories
- Add placeholder documentation"

git log --oneline -1  # Verify commit
```

### Worktree 3: Testing & Documentation

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/testing

# Create testing directory structure
mkdir -p .github/workflows
mkdir -p scripts
mkdir -p docs/{plugins,meta-orchestrator,marketplace}

# Create placeholder files
touch .github/workflows/validate-plugins.yml
touch scripts/validate-all-plugins.sh
touch scripts/test-installation.sh

# Verify structure
tree -L 2 .github/
tree -L 2 scripts/
tree -L 2 docs/

# Commit initial structure
git add .
git commit -m "feat(testing): Initial testing and documentation structure

- Create GitHub Actions workflow directory
- Set up validation scripts
- Prepare documentation directories
- Ready for test implementation"

git log --oneline -1  # Verify commit
```

---

## Part 5: Worktree Coordination Setup

### Create Coordination Script

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Create coordination script
cat > scripts/sync-worktrees.sh << 'EOF'
#!/bin/bash
# Sync status across all worktrees

echo "🔄 Worktree Status Report"
echo "========================"
echo ""

WORKTREES=(
  "/Users/fullerbt/.cursor/worktrees/agentops/marketplace:Marketplace"
  "/Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator:Meta-Orchestrator"
  "/Users/fullerbt/.cursor/worktrees/agentops/testing:Testing & Docs"
)

for wt in "${WORKTREES[@]}"; do
  IFS=':' read -r path name <<< "$wt"
  
  echo "📦 $name"
  echo "   Path: $path"
  
  if [ -d "$path" ]; then
    cd "$path"
    
    # Branch
    branch=$(git branch --show-current)
    echo "   Branch: $branch"
    
    # Commits
    commits=$(git rev-list --count HEAD ^main)
    echo "   Commits ahead of main: $commits"
    
    # Status
    if git diff --quiet && git diff --cached --quiet; then
      echo "   Status: ✅ Clean"
    else
      echo "   Status: ⚠️  Uncommitted changes"
    fi
    
    # Last commit
    last_commit=$(git log -1 --pretty=format:"%s" 2>/dev/null)
    echo "   Last commit: $last_commit"
    
  else
    echo "   Status: ❌ Not found"
  fi
  
  echo ""
done

echo "========================"
echo "Use this script daily to track progress"
EOF

chmod +x scripts/sync-worktrees.sh

# Test it
./scripts/sync-worktrees.sh
```

---

## Part 6: Daily Workflow

### Morning Routine

```bash
# 1. Check status of all worktrees
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
./scripts/sync-worktrees.sh

# 2. Pull any updates from main
for wt in marketplace meta-orchestrator testing; do
  cd /Users/fullerbt/.cursor/worktrees/agentops/$wt
  git fetch origin main
  echo "✅ $wt updated"
done

# 3. Start work in your assigned worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace  # or meta-orchestrator or testing
```

### During Work

```bash
# Commit frequently
git add <files>
git commit -m "feat(scope): description"

# Push to remote periodically
git push -u origin $(git branch --show-current)
```

### Evening Routine

```bash
# 1. Commit all work
git add .
git commit -m "feat(scope): end of day checkpoint"

# 2. Push to remote
git push

# 3. Check status
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
./scripts/sync-worktrees.sh

# 4. Update coordination log
echo "$(date +%Y-%m-%d): Summary of today's work" >> .agentops/worktree-log.md
```

---

## Part 7: Work Assignment

### Worktree 1: Marketplace Structure (Days 1-2)

**Owner:** Primary developer
**Location:** `/Users/fullerbt/.cursor/worktrees/agentops/marketplace`
**Branch:** `feature/marketplace-structure`

**Tasks:**
1. Create marketplace.json
2. Write all plugin.json files
3. Move core components to plugins/agentops-core/
4. Move profiles to plugin directories
5. Create backward compatibility symlinks
6. Test installation flow
7. Validate JSON schemas

**Deliverables:**
- [ ] .claude-plugin/marketplace.json
- [ ] plugins/agentops-core/.claude-plugin/plugin.json
- [ ] plugins/agentops-devops/.claude-plugin/plugin.json
- [ ] plugins/agentops-product-dev/.claude-plugin/plugin.json
- [ ] Symlinks: core/{commands,agents,workflows}
- [ ] Validation script passes

**Progress Tracking:**
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace
cat > PROGRESS.md << 'EOF'
# Marketplace Structure Progress

## Day 1
- [ ] Create directory structure
- [ ] Write marketplace.json
- [ ] Write agentops-core plugin.json
- [ ] Move core components

## Day 2
- [ ] Write devops plugin.json
- [ ] Write product-dev plugin.json
- [ ] Create symlinks
- [ ] Test and validate
EOF
```

### Worktree 2: Meta-Orchestrator (Days 1-3)

**Owner:** Secondary developer (or same dev, different time)
**Location:** `/Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator`
**Branch:** `feature/meta-orchestrator`

**Tasks:**
1. Create plugin.json for meta-orchestrator
2. Implement auto-learn-commit.sh
3. Implement extract-patterns.py
4. Implement validate-pattern.py
5. Write SKILL.md
6. Write all 5 command definitions
7. Create test patterns
8. Write tests

**Deliverables:**
- [ ] plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json
- [ ] scripts/auto-learn-commit.sh
- [ ] scripts/extract-patterns.py
- [ ] scripts/validate-pattern.py
- [ ] skills/orchestrator/SKILL.md
- [ ] commands/{orchestrate,analyze-plugins,show-patterns,learn-from,meta-stats}.md
- [ ] tests/test-pattern-extraction.sh
- [ ] tests/test-learning.sh

**Progress Tracking:**
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator
cat > PROGRESS.md << 'EOF'
# Meta-Orchestrator Progress

## Day 1
- [ ] Create directory structure
- [ ] Write plugin.json
- [ ] Design pattern format

## Day 2
- [ ] Implement learning scripts
- [ ] Write SKILL.md
- [ ] Write command definitions

## Day 3
- [ ] Create tests
- [ ] Test learning flow
- [ ] Validate end-to-end
EOF
```

### Worktree 3: Testing & Documentation (Days 1-2)

**Owner:** Third developer (or same dev, final phase)
**Location:** `/Users/fullerbt/.cursor/worktrees/agentops/testing`
**Branch:** `feature/testing-docs`

**Tasks:**
1. Write CI/CD workflows
2. Create validation scripts
3. Write test-installation.sh
4. Write MIGRATION.md
5. Update README.md
6. Write meta-orchestrator/README.md
7. Create examples

**Deliverables:**
- [ ] .github/workflows/validate-plugins.yml
- [ ] .github/workflows/test-meta-orchestrator.yml
- [ ] scripts/validate-all-plugins.sh
- [ ] scripts/test-installation.sh
- [ ] MIGRATION.md
- [ ] README.md updates
- [ ] plugins/agentops-meta-orchestrator/README.md
- [ ] docs/meta-orchestrator/LEARNING_SYSTEM.md

**Progress Tracking:**
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/testing
cat > PROGRESS.md << 'EOF'
# Testing & Documentation Progress

## Day 1
- [ ] Create CI/CD workflows
- [ ] Write validation scripts
- [ ] Test installation flow

## Day 2
- [ ] Write MIGRATION.md
- [ ] Update README.md
- [ ] Write meta-orchestrator README
- [ ] Create examples
EOF
```

---

## Part 8: Integration Plan (Day 6)

### Merge Order

```bash
# Day 6 Morning: Merge marketplace structure

cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git checkout main

# Merge marketplace
git merge --no-ff feature/marketplace-structure -m "feat: Add Claude Code plugin marketplace structure

Merges marketplace structure with all plugin manifests and backward compatibility"

# Test
./scripts/validate-all-plugins.sh || echo "Fix issues before proceeding"

# Day 6 Afternoon: Merge meta-orchestrator

git merge --no-ff feature/meta-orchestrator -m "feat: Add self-learning meta-orchestrator plugin

Merges meta-orchestrator with learning system, pattern extraction, and validation"

# Test
cd plugins/agentops-meta-orchestrator
./tests/test-learning.sh || echo "Fix issues before proceeding"

# Day 6 Evening: Merge testing & docs

cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git merge --no-ff feature/testing-docs -m "feat: Add testing infrastructure and documentation

Merges CI/CD, validation scripts, and comprehensive documentation"

# Test everything
.github/workflows/validate-plugins.yml  # Run locally with act
./scripts/test-installation.sh
./scripts/validate-all-plugins.sh
```

### Conflict Resolution

If merge conflicts occur:

```bash
# Check conflicts
git status

# For each conflicted file
git mergetool <file>

# Or manually edit
vim <file>
# Remove conflict markers
# Keep appropriate version

# Mark resolved
git add <file>

# Continue merge
git merge --continue
```

---

## Part 9: Verification Checklist

### After Setup (Now)

```bash
# Verify all worktrees created
git worktree list | grep -c "feature/" | grep 3 || echo "Missing worktrees"

# Verify branches exist
git branch -a | grep feature/marketplace-structure
git branch -a | grep feature/meta-orchestrator
git branch -a | grep feature/testing-docs

# Verify clean state
for wt in marketplace meta-orchestrator testing; do
  cd /Users/fullerbt/.cursor/worktrees/agentops/$wt
  git status | grep "working tree clean" || echo "$wt has changes"
done
```

### After Integration (Day 6)

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# All features merged
git log --oneline -10 | grep "feat:"

# All tests pass
./scripts/validate-all-plugins.sh
./scripts/test-installation.sh
cd plugins/agentops-meta-orchestrator && ./tests/test-learning.sh

# Documentation complete
ls -la MIGRATION.md
ls -la plugins/agentops-meta-orchestrator/README.md
ls -la docs/meta-orchestrator/LEARNING_SYSTEM.md

# CI/CD ready
ls -la .github/workflows/validate-plugins.yml
ls -la .github/workflows/test-meta-orchestrator.yml
```

---

## Part 10: Troubleshooting

### Worktree Creation Fails

```bash
# Error: branch already exists
git branch -D feature/marketplace-structure
git worktree add ../marketplace feature/marketplace-structure

# Error: directory already exists
rm -rf ../marketplace
git worktree add ../marketplace feature/marketplace-structure

# Error: uncommitted changes
git stash
git worktree add ../marketplace feature/marketplace-structure
git stash pop
```

### Cannot Switch Between Worktrees

```bash
# Wrong: trying to checkout in same worktree
git checkout feature/marketplace-structure  # Won't work if branch is checked out in another worktree

# Right: cd to different worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace
```

### Merge Conflicts

```bash
# See what's conflicted
git status

# Abort merge and try again
git merge --abort

# Or resolve conflicts
git mergetool
git add <resolved-files>
git merge --continue
```

### Lost Work

```bash
# Find recent commits
git reflog

# Recover lost commit
git checkout <commit-hash>
git branch recovery-<name>
```

---

## Part 11: Quick Reference

### Essential Commands

```bash
# Check all worktrees
git worktree list

# Sync status
./scripts/sync-worktrees.sh

# Switch worktrees
cd /Users/fullerbt/.cursor/worktrees/agentops/<worktree-name>

# Commit and push
git add .
git commit -m "feat(scope): description"
git push

# Merge to main (Day 6)
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git merge --no-ff feature/<branch-name>
```

### Worktree Paths

```bash
# Main worktree
/Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Marketplace
/Users/fullerbt/.cursor/worktrees/agentops/marketplace

# Meta-orchestrator
/Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator

# Testing
/Users/fullerbt/.cursor/worktrees/agentops/testing
```

---

## Part 12: Next Steps

### Immediate (Next 5 minutes)

1. ✅ Read this guide
2. ✅ Create 3 worktrees
3. ✅ Verify setup
4. ✅ Create initial commits
5. ✅ Set up sync script

### Today (Day 1)

1. 📦 Marketplace: Create marketplace.json
2. 🧠 Meta-orchestrator: Design pattern format
3. 🧪 Testing: Plan CI/CD workflows

### This Week (Days 1-7)

1. Days 1-2: Core implementation in each worktree
2. Days 3-4: Advanced features and testing
3. Day 5: Documentation
4. Day 6: Integration and testing
5. Day 7: Polish and validation

---

## Success Criteria

After running this quick-start:

- [ ] 3 worktrees created
- [ ] All on correct branches
- [ ] Initial directory structures in place
- [ ] First commits made
- [ ] Sync script working
- [ ] Clear understanding of work assignment
- [ ] Ready to begin implementation

---

**Quick-Start Guide Complete!**

**Time to execute:** ~15 minutes
**Next step:** Begin implementation in your assigned worktree

🚀 **Let's build the future of AI agent orchestration!**

---

## Appendix: Worktree Cheat Sheet

```bash
# List all worktrees
git worktree list

# Add new worktree
git worktree add <path> <branch-name>

# Remove worktree
git worktree remove <path>

# Prune deleted worktrees
git worktree prune

# Move worktree
git worktree move <old-path> <new-path>

# Lock worktree (prevent deletion)
git worktree lock <path>

# Unlock worktree
git worktree unlock <path>
```

**Pro Tip:** Keep this guide open in a browser tab for easy reference during implementation!

