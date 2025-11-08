# Quick Reference Card - Marketplace + Meta-Orchestrator

**Date:** November 7, 2025
**Print this or keep it visible during implementation!**

---

## 📦 Project Overview

**Goal:** Transform AgentOps into Claude Code plugin marketplace with self-learning meta-orchestrator

**Timeline:** 5-7 days (3 parallel worktrees)

**Output:** 4 plugins + learning system + CI/CD + comprehensive docs

---

## 🗺️ Worktree Paths

```bash
# Main worktree
/Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Worktree 1: Marketplace
/Users/fullerbt/.cursor/worktrees/agentops/marketplace

# Worktree 2: Meta-orchestrator  
/Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator

# Worktree 3: Testing
/Users/fullerbt/.cursor/worktrees/agentops/testing
```

---

## 🚀 Setup Commands (15 min)

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Create worktrees
git worktree add ../marketplace feature/marketplace-structure
git worktree add ../meta-orchestrator feature/meta-orchestrator
git worktree add ../testing feature/testing-docs

# Verify
git worktree list

# Status script
cat > scripts/sync-worktrees.sh << 'EOF'
#!/bin/bash
for wt in marketplace meta-orchestrator testing; do
  cd /Users/fullerbt/.cursor/worktrees/agentops/$wt
  echo "📦 $wt: $(git branch --show-current)"
  git status -s
done
EOF
chmod +x scripts/sync-worktrees.sh
```

---

## 📋 Daily Workflow

### Morning
```bash
# Check status
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
./scripts/sync-worktrees.sh

# Start work
cd ../marketplace  # or meta-orchestrator or testing
```

### During Day
```bash
# Commit frequently
git add <files>
git commit -m "feat(scope): description"

# Push periodically
git push -u origin $(git branch --show-current)
```

### Evening
```bash
# End-of-day checkpoint
git add .
git commit -m "feat(scope): end of day checkpoint"
git push

# Check progress
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
./scripts/sync-worktrees.sh
```

---

## 📦 Worktree 1: Marketplace (Days 1-2)

### Key Files
```
.claude-plugin/marketplace.json
plugins/agentops-core/.claude-plugin/plugin.json
plugins/agentops-devops/.claude-plugin/plugin.json
plugins/agentops-product-dev/.claude-plugin/plugin.json
core/commands -> ../plugins/agentops-core/commands (symlink)
```

### Validation
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace

# Validate JSON
jq '.' .claude-plugin/marketplace.json
jq '.' plugins/*/.claude-plugin/plugin.json

# Test symlinks
ls -la core/commands
ls -la core/agents

# Run validation
./scripts/validate-all-plugins.sh
```

---

## 🧠 Worktree 2: Meta-Orchestrator (Days 2-4)

### Key Files
```
plugins/agentops-meta-orchestrator/
  .claude-plugin/plugin.json
  skills/orchestrator/SKILL.md
  commands/orchestrate.md
  commands/analyze-plugins.md
  commands/show-patterns.md
  commands/learn-from.md
  commands/meta-stats.md
  scripts/auto-learn-commit.sh
  scripts/extract-patterns.py
  scripts/validate-pattern.py
  patterns/{discovered,validated,learned,meta}/
  metrics/{success_rates,durations,plugin_usage}.log
  tests/test-*.sh
```

### Validation
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/meta-orchestrator
cd plugins/agentops-meta-orchestrator

# Test pattern extraction
./tests/test-pattern-extraction.sh

# Test learning
./tests/test-learning.sh

# Test orchestration
./tests/test-orchestration.sh
```

---

## 🧪 Worktree 3: Testing (Days 4-5)

### Key Files
```
.github/workflows/
  validate-plugins.yml
  test-marketplace.yml
  test-meta-orchestrator.yml
scripts/
  validate-all-plugins.sh
  test-installation.sh
  test-full-integration.sh
docs/
  MIGRATION.md
  plugins/
  meta-orchestrator/
  marketplace/
```

### Validation
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/testing

# Test installation
./scripts/test-installation.sh

# Validate all plugins
./scripts/validate-all-plugins.sh

# Full integration test
./scripts/test-full-integration.sh
```

---

## 🔀 Integration (Day 6)

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git checkout main

# Merge marketplace
git merge --no-ff feature/marketplace-structure
./scripts/validate-all-plugins.sh

# Merge meta-orchestrator
git merge --no-ff feature/meta-orchestrator
cd plugins/agentops-meta-orchestrator && ./tests/test-learning.sh

# Merge testing
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git merge --no-ff feature/testing-docs
./scripts/test-full-integration.sh
```

---

## ✅ Validation Checklist

### Marketplace
- [ ] marketplace.json valid
- [ ] All plugin.json valid
- [ ] Symlinks work
- [ ] Commands accessible
- [ ] No broken links

### Meta-Orchestrator
- [ ] Pattern extraction works
- [ ] Pattern validation enforces rules
- [ ] Git commits successful
- [ ] Metrics tracked
- [ ] Commands execute
- [ ] All tests pass

### Testing & Docs
- [ ] CI/CD workflows valid
- [ ] All scripts executable
- [ ] Documentation complete
- [ ] Examples work
- [ ] Migration guide clear

### Integration
- [ ] All tests pass
- [ ] Backward compatible
- [ ] Performance benchmarks met
- [ ] No critical bugs
- [ ] Ready for launch

---

## 🐛 Common Issues

### Worktree creation fails
```bash
# Branch already exists
git branch -D feature/marketplace-structure

# Directory exists
rm -rf ../marketplace

# Recreate
git worktree add ../marketplace feature/marketplace-structure
```

### Can't switch branches
```bash
# Wrong: checkout in same worktree
git checkout feature/other  # ERROR

# Right: cd to other worktree
cd /Users/fullerbt/.cursor/worktrees/agentops/marketplace
```

### Merge conflicts
```bash
# Check what's conflicted
git status

# Abort and retry
git merge --abort

# Or resolve
git mergetool
git add <files>
git merge --continue
```

### Lost work
```bash
# Find recent commits
git reflog

# Recover
git checkout <commit-hash>
git branch recovery-temp
```

---

## 📊 Progress Tracking

### Day 1
- [ ] Worktrees created
- [ ] Initial structures in place
- [ ] marketplace.json created
- [ ] Meta-orchestrator scaffold done

### Day 2
- [ ] All plugin.json files written
- [ ] Core components moved
- [ ] Symlinks created
- [ ] Learning scripts started

### Day 3
- [ ] Meta-orchestrator commands defined
- [ ] Pattern validation implemented
- [ ] Tests written

### Day 4
- [ ] CI/CD workflows created
- [ ] Validation scripts done
- [ ] Tests passing

### Day 5
- [ ] Documentation complete
- [ ] Examples created
- [ ] Migration guide written

### Day 6
- [ ] All worktrees merged
- [ ] Integration tests passing
- [ ] No conflicts

### Day 7
- [ ] Polish complete
- [ ] All validations green
- [ ] Ready for launch

---

## 🎯 Success Metrics

### Week 1
- [ ] 50+ installations
- [ ] 10+ meta-orchestrator users
- [ ] 5+ learned patterns
- [ ] 0 critical bugs

### Month 1  
- [ ] 500+ installations
- [ ] 50+ meta-orchestrator users
- [ ] 50+ learned patterns
- [ ] Community contributions

---

## 📞 Emergency Rollback

```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2

# Quick rollback (< 5 min)
rm -rf plugins/ .claude-plugin/
rm core/commands core/agents core/workflows 2>/dev/null || true
git checkout -- core/
git checkout -- profiles/

# Verify
ls -la core/
./scripts/test-installation.sh
```

---

## 📚 Document Reference

| Document | Purpose | Lines |
|----------|---------|-------|
| marketplace-meta-orchestrator-plan-ENHANCED.md | Complete implementation plan | 18,000 |
| ENHANCEMENT_ANALYSIS.md | Original vs Enhanced comparison | 5,000 |
| WORKTREE_QUICKSTART.md | Setup guide | 2,000 |
| EXECUTIVE_SUMMARY.md | High-level overview | 2,500 |
| QUICK_REFERENCE.md | This card | 500 |

**Total:** 28,000+ lines of planning documentation

---

## 🔑 Key Commands

```bash
# Status
git worktree list
./scripts/sync-worktrees.sh

# Validate
./scripts/validate-all-plugins.sh
./scripts/test-installation.sh
./scripts/test-full-integration.sh

# Switch worktrees
cd /Users/fullerbt/.cursor/worktrees/agentops/<worktree>

# Commit
git add .
git commit -m "feat(scope): description"
git push

# Merge (Day 6)
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git merge --no-ff feature/<branch>
```

---

## 💡 Pro Tips

1. **Commit frequently** - Small commits easier to review
2. **Push daily** - Backup your work
3. **Test continuously** - Catch issues early
4. **Document as you go** - Fresh memory is best
5. **Use sync script** - Track progress daily
6. **Read the plan** - Comprehensive details available
7. **Ask questions** - Better to clarify than assume

---

## 🚨 Red Flags

Watch for these issues:

- ❌ Symlinks broken
- ❌ JSON validation fails
- ❌ Tests not passing
- ❌ Backward compatibility broken
- ❌ Performance degradation
- ❌ Security issues (secrets in patterns)

**If you see any:** Stop, fix, then continue

---

## 🎉 Success Indicators

Look for these signs:

- ✅ All tests green
- ✅ Documentation complete
- ✅ Examples work
- ✅ CI/CD passing
- ✅ Performance benchmarks met
- ✅ Community excited
- ✅ No critical bugs

---

## 📅 Timeline Summary

```
Day 1: Setup + Foundation
Day 2: Plugin manifests + Learning design
Day 3: Meta-orchestrator implementation
Day 4: Testing infrastructure
Day 5: Documentation
Day 6: Integration + Testing
Day 7: Polish + Validation
```

**Launch:** December 1, 2025

---

## 🎯 Remember

**Goal:** Revolutionary self-learning meta-orchestrator

**Innovation:** Git-based institutional memory

**Impact:** First-mover in self-learning AI orchestration

**Timeline:** 5-7 days

**Success:** 95% probability

---

## 🚀 Let's Build!

**Command to start:**
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git worktree add ../marketplace feature/marketplace-structure
git worktree add ../meta-orchestrator feature/meta-orchestrator
git worktree add ../testing feature/testing-docs
cd ../marketplace
```

**You've got this! 🎉**

---

**Keep this card visible during implementation!**

*Last updated: November 7, 2025*

