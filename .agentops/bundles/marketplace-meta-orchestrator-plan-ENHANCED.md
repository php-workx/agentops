---
bundle_id: bundle-marketplace-meta-orchestrator-enhanced-2025-11-07
created: 2025-11-07T22:15:00Z
type: plan
phase: plan
priority: critical
complexity: high
estimated_effort: 5-7 days
tags: [marketplace, meta-orchestrator, plugins, self-learning, automation]
dependencies: [git, jq, bash, python3]
risk_level: medium
backward_compatible: true
rollback_time: <5min
---

# ENHANCED Implementation Plan: Claude Marketplace + Self-Learning Meta-Orchestrator

## Executive Summary

Transform AgentOps into a **Claude Code plugin marketplace** with a revolutionary **self-learning Meta-Orchestrator** plugin that:
- Coordinates 1000+ plugins across multiple marketplaces
- **Learns from every execution** via git-based pattern extraction
- Provides intelligent plugin discovery and workflow orchestration
- Maintains 100% backward compatibility
- Ships with automated testing, CI/CD, and monitoring

**Key Innovation:** Meta-Orchestrator is itself a plugin that **learns and improves** through git commits of discovered patterns, becoming smarter with every use.

---

## Part 1: Marketplace Structure (Foundation)

### 1.1 Core Marketplace Manifest

**File:** `.claude-plugin/marketplace.json`

```json
{
  "$schema": "https://schemas.claude.com/marketplace/v1/schema.json",
  "name": "agentops-marketplace",
  "version": "1.0.0",
  "description": "Universal AI agent orchestration platform with self-learning meta-orchestrator",
  "homepage": "https://github.com/boshu2/agentops",
  "documentation": "https://github.com/boshu2/agentops/docs",
  "license": "Apache-2.0",
  "owner": {
    "name": "AgentOps Framework",
    "email": "team@agentops.ai",
    "url": "https://github.com/boshu2/agentops"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/boshu2/agentops.git"
  },
  "keywords": [
    "ai-agents",
    "orchestration",
    "workflows",
    "automation",
    "meta-orchestrator",
    "self-learning",
    "plugin-coordination"
  ],
  "plugins": [
    {
      "name": "agentops-core",
      "source": "./plugins/agentops-core",
      "description": "Core orchestration platform with 13 universal commands and 9 base agents",
      "category": "framework",
      "version": "1.0.0",
      "tags": ["orchestration", "workflows", "agents"],
      "required": true,
      "author": {
        "name": "AgentOps Team"
      },
      "stability": "stable"
    },
    {
      "name": "agentops-devops",
      "source": "./plugins/agentops-devops",
      "description": "DevOps profile: Kubernetes, Docker, CI/CD, GitOps specialized agents",
      "category": "devops",
      "version": "1.0.0",
      "tags": ["kubernetes", "docker", "ci-cd", "gitops", "infrastructure"],
      "dependencies": ["agentops-core"],
      "author": {
        "name": "AgentOps Team"
      },
      "stability": "stable"
    },
    {
      "name": "agentops-product-dev",
      "source": "./plugins/agentops-product-dev",
      "description": "Product development profile: APIs, UIs, databases, full-stack workflows",
      "category": "development",
      "version": "1.0.0",
      "tags": ["api", "frontend", "backend", "database", "full-stack"],
      "dependencies": ["agentops-core"],
      "author": {
        "name": "AgentOps Team"
      },
      "stability": "stable"
    },
    {
      "name": "agentops-meta-orchestrator",
      "source": "./plugins/agentops-meta-orchestrator",
      "description": "🧠 Self-learning meta-orchestrator: Coordinates 1000+ plugins, learns from execution, discovers optimal workflows",
      "category": "meta",
      "version": "0.9.0-alpha",
      "tags": ["meta-orchestration", "self-learning", "plugin-coordination", "workflow-discovery", "ai"],
      "dependencies": ["agentops-core"],
      "author": {
        "name": "AgentOps Team"
      },
      "stability": "alpha",
      "experimental": true,
      "icon": "🧠"
    }
  ],
  "changelog": "./CHANGELOG.md",
  "security": "./SECURITY.md",
  "contributing": "./docs/community/CONTRIBUTING.md"
}
```

### 1.2 Plugin Directory Structure

```
agentops/
├── .claude-plugin/
│   └── marketplace.json              # Marketplace manifest
├── plugins/
│   ├── agentops-core/               # Core platform (required)
│   │   ├── .claude-plugin/
│   │   │   ├── plugin.json
│   │   │   ├── manifest.yaml
│   │   │   └── icon.svg
│   │   ├── README.md
│   │   ├── CHANGELOG.md
│   │   ├── commands/                # 13 universal commands
│   │   ├── agents/                  # 9 base agent personas
│   │   ├── workflows/               # Core workflows
│   │   ├── skills/                  # Skill framework
│   │   ├── hooks/                   # Extension points
│   │   ├── tests/                   # Automated tests
│   │   └── docs/                    # Plugin documentation
│   │
│   ├── agentops-devops/            # DevOps profile
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── README.md
│   │   ├── agents/                  # DevOps-specific agents
│   │   ├── commands/                # DevOps commands
│   │   ├── workflows/               # DevOps workflows
│   │   ├── validation/              # DevOps validation
│   │   └── tests/
│   │
│   ├── agentops-product-dev/       # Product dev profile
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── README.md
│   │   ├── agents/
│   │   ├── commands/
│   │   ├── workflows/
│   │   ├── validation/
│   │   └── tests/
│   │
│   └── agentops-meta-orchestrator/  # 🧠 THE GAME CHANGER
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── README.md
│       ├── LEARNING_LOG.md          # Documents what it learns
│       ├── skills/
│       │   └── orchestrator/
│       │       └── SKILL.md         # Auto-invoked orchestration
│       ├── commands/
│       │   ├── orchestrate.md       # Main orchestration command
│       │   ├── analyze-plugins.md   # Plugin analysis
│       │   ├── show-patterns.md     # Show learned patterns
│       │   ├── learn-from.md        # Explicit learning
│       │   └── meta-stats.md        # Show meta statistics
│       ├── patterns/                # 🧠 LEARNED PATTERNS
│       │   ├── discovered/          # Raw patterns (not validated)
│       │   ├── validated/           # Validated patterns
│       │   ├── learned/             # Committed learnings
│       │   └── meta/                # Meta-patterns (patterns about patterns)
│       ├── metrics/
│       │   ├── success_rates.log    # Track success by pattern
│       │   ├── durations.log        # Execution times
│       │   ├── plugin_usage.log     # Plugin usage statistics
│       │   └── learning_metrics.json
│       ├── workflows/
│       │   ├── auto-learn.md        # Automatic learning workflow
│       │   └── pattern-validation.md
│       ├── scripts/
│       │   ├── auto-learn-commit.sh # Git-based learning
│       │   ├── extract-patterns.py  # Pattern extraction
│       │   ├── validate-pattern.py  # Pattern validation
│       │   └── merge-learnings.sh   # Merge learned patterns
│       ├── tests/
│       │   ├── test-orchestration.sh
│       │   ├── test-learning.sh
│       │   └── test-pattern-extraction.sh
│       └── docs/
│           ├── ARCHITECTURE.md
│           ├── LEARNING_SYSTEM.md
│           └── PATTERN_FORMAT.md
│
├── core/                            # Symlinks for backward compatibility
│   ├── commands -> ../plugins/agentops-core/commands
│   ├── agents -> ../plugins/agentops-core/agents
│   ├── workflows -> ../plugins/agentops-core/workflows
│   └── skills -> ../plugins/agentops-core/skills
│
├── .github/
│   ├── workflows/
│   │   ├── validate-plugins.yml     # CI for plugin validation
│   │   ├── test-marketplace.yml     # Test marketplace structure
│   │   ├── test-meta-orchestrator.yml # Test learning system
│   │   └── auto-publish.yml         # Auto-publish on tag
│   └── ISSUE_TEMPLATE/
│       ├── plugin-request.md
│       └── pattern-submission.md
│
├── scripts/
│   ├── ensure-compatibility.sh      # Backward compatibility
│   ├── validate-all-plugins.sh      # Validate all plugins
│   ├── test-installation.sh         # Test installation flow
│   └── generate-plugin.sh           # Generate new plugin scaffold
│
├── docs/
│   ├── plugins/
│   │   ├── README.md                # Plugin overview
│   │   ├── CREATING_PLUGINS.md      # How to create plugins
│   │   ├── PLUGIN_STANDARDS.md      # Quality standards
│   │   └── TESTING_PLUGINS.md       # Testing guidelines
│   ├── meta-orchestrator/
│   │   ├── README.md
│   │   ├── LEARNING_SYSTEM.md       # How learning works
│   │   ├── PATTERN_LANGUAGE.md      # Pattern format spec
│   │   └── CONTRIBUTING_PATTERNS.md # Submit learned patterns
│   └── marketplace/
│       ├── INSTALLATION.md
│       ├── MIGRATION.md
│       └── PUBLISHING.md
│
├── MIGRATION.md                     # Migration guide
└── MARKETPLACE_README.md            # Marketplace overview
```

---

## Part 2: Meta-Orchestrator Plugin (The Innovation)

### 2.1 Core Concept: Self-Learning Through Git

**Philosophy:** The Meta-Orchestrator learns by committing discovered patterns to git, creating an ever-growing knowledge base.

**Learning Flow:**
```
User Task → Orchestrate Execution → Extract Patterns → Validate → Git Commit → Learn
```

### 2.2 Meta-Orchestrator plugin.json

**File:** `plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json`

```json
{
  "name": "agentops-meta-orchestrator",
  "version": "0.9.0-alpha",
  "description": "Self-learning meta-orchestrator that coordinates plugins and improves through experience",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/boshu2/agentops",
  "license": "Apache-2.0",
  "homepage": "https://github.com/boshu2/agentops/tree/main/plugins/agentops-meta-orchestrator",
  "keywords": [
    "meta-orchestration",
    "self-learning",
    "plugin-coordination",
    "workflow-discovery",
    "pattern-extraction",
    "ai-learning"
  ],
  "stability": "alpha",
  "experimental": true,
  "claude-code": {
    "minVersion": "2.0.13",
    "maxVersion": "*"
  },
  "components": {
    "commands": "./commands",
    "skills": "./skills",
    "workflows": "./workflows",
    "hooks": "./hooks"
  },
  "dependencies": {
    "required": ["agentops-core"],
    "optional": [],
    "peerDependencies": []
  },
  "capabilities": {
    "learns": true,
    "adapts": true,
    "discovers": true,
    "coordinates": true,
    "optimizes": true
  },
  "learning": {
    "method": "git-based",
    "pattern_storage": "./patterns",
    "metrics_tracking": "./metrics",
    "auto_learn": true,
    "validation_required": true
  },
  "metrics": {
    "success_rate": null,
    "patterns_learned": 0,
    "executions": 0,
    "avg_duration": null
  }
}
```

### 2.3 Meta-Orchestrator Skill Definition

**File:** `plugins/agentops-meta-orchestrator/skills/orchestrator/SKILL.md`

```markdown
# Meta-Orchestrator Skill

**Skill ID:** `meta-orchestrator`
**Version:** 0.9.0-alpha
**Type:** Auto-invoked coordination skill
**Learning:** Enabled (git-based)

## Activation Criteria

This skill activates when:
- User requests multi-step workflow coordination
- Task requires multiple plugins/agents
- Workflow pattern not clearly defined
- Optimization opportunity detected
- Learning opportunity present

## Capabilities

### 1. Intelligent Task Analysis
- Parse user intent with NLP
- Identify required capabilities
- Estimate complexity and duration
- Calculate success probability

### 2. Plugin Discovery & Selection
- Search across all installed plugins
- Rank by relevance, performance, and reliability
- Consider complementary plugins
- Evaluate dependencies

### 3. Workflow Generation
- Create optimal execution plan
- Identify parallelization opportunities
- Define dependency graph
- Set checkpoint gates

### 4. Execution Orchestration
- Coordinate multi-agent workflows
- Manage state between steps
- Handle errors and rollbacks
- Track metrics in real-time

### 5. Pattern Extraction & Learning
- **Extract patterns from successful executions**
- **Validate patterns against historical data**
- **Commit learned patterns to git**
- **Update success probabilities**

## Commands Provided

### `/orchestrate <task>`
Main orchestration command

**Usage:**
```bash
/orchestrate "Add OAuth2 to API with tests and docs"
```

**Flow:**
1. Analyze task intent
2. Discover relevant plugins
3. Generate workflow plan
4. Execute with coordination
5. Extract and learn patterns

**Options:**
- `--plan-only` - Show plan without execution
- `--learn` - Force learning from execution
- `--dry-run` - Simulate without changes
- `--parallel` - Max parallelization
- `--conservative` - Serial execution only

### `/analyze-plugins [query]`
Analyze and discover plugins

**Usage:**
```bash
/analyze-plugins "kubernetes deployment"
/analyze-plugins --limit 10 --category devops
```

**Output:**
- Relevant plugins ranked by fit
- Complementary plugin suggestions
- Usage statistics and reliability
- Workflow recommendations

### `/show-patterns [category]`
Display learned patterns

**Usage:**
```bash
/show-patterns
/show-patterns --category api-development
/show-patterns --success-rate ">0.9"
```

### `/learn-from <execution-id>`
Explicit learning from execution

**Usage:**
```bash
/learn-from exec_2025-11-07_1234
/learn-from --interactive  # Interactive pattern extraction
```

### `/meta-stats`
Show meta-orchestrator statistics

**Output:**
- Total patterns learned
- Success rates by category
- Plugin usage statistics
- Learning velocity
- Optimization impact

## Learning System

### Git-Based Pattern Storage

**Pattern File Format:** `patterns/learned/YYYY-MM-DD-<category>-<id>.md`

**Example Pattern:**
```markdown
---
pattern_id: pat_2025-11-07_oauth_api
created: 2025-11-07T22:30:00Z
category: api-development
success_rate: 0.95
executions: 20
validated: true
---

# Pattern: Add OAuth2 to REST API

## Context
Adding OAuth2 authentication to an existing REST API

## Workflow
1. Research OAuth2 libraries (Code Explorer)
2. Plan authentication flow (Spec Architect)
3. Implement auth middleware (Change Executor)
4. Add tests (Test Generator)
5. Update API docs (Doc Generator)

## Success Factors
- Use battle-tested libraries
- Follow OAuth2 RFC 6749
- Test with multiple grant types
- Document all endpoints

## Metrics
- Avg duration: 45min
- Success rate: 95%
- Rollback rate: 5%

## Learned Optimizations
- Parallel: Research + Plan (saves 10min)
- Checkpoint: After middleware (enable rollback)
- Validation: Test grant types before docs
```

### Auto-Learning Workflow

**File:** `plugins/agentops-meta-orchestrator/scripts/auto-learn-commit.sh`

```bash
#!/bin/bash
# Auto-learn from execution and commit to git

EXECUTION_ID="$1"
PATTERN_FILE="$2"

# Extract pattern
./scripts/extract-patterns.py "$EXECUTION_ID" > "$PATTERN_FILE"

# Validate pattern
if ./scripts/validate-pattern.py "$PATTERN_FILE"; then
  # Commit to git (institutional learning)
  git add "$PATTERN_FILE"
  git commit -m "Learn pattern: $(basename $PATTERN_FILE .md)
  
  Execution: $EXECUTION_ID
  Success rate: $(jq -r .success_rate $PATTERN_FILE)
  Category: $(jq -r .category $PATTERN_FILE)
  
  Automated learning from meta-orchestrator"
  
  echo "✅ Pattern learned and committed"
else
  echo "❌ Pattern validation failed"
  exit 1
fi
```

### Pattern Validation

**File:** `plugins/agentops-meta-orchestrator/scripts/validate-pattern.py`

```python
#!/usr/bin/env python3
"""Validate extracted patterns before committing."""

import sys
import yaml
import json

def validate_pattern(pattern_file):
    """Validate pattern structure and content."""
    
    with open(pattern_file) as f:
        # Parse frontmatter and content
        content = f.read()
        if not content.startswith('---'):
            return False, "Missing frontmatter"
        
        parts = content.split('---', 2)
        if len(parts) < 3:
            return False, "Invalid frontmatter format"
        
        frontmatter = yaml.safe_load(parts[1])
        body = parts[2]
        
        # Required fields
        required = ['pattern_id', 'category', 'success_rate', 'executions']
        for field in required:
            if field not in frontmatter:
                return False, f"Missing required field: {field}"
        
        # Validate success rate
        sr = float(frontmatter['success_rate'])
        if not (0.0 <= sr <= 1.0):
            return False, f"Invalid success_rate: {sr}"
        
        # Require minimum executions
        if int(frontmatter['executions']) < 3:
            return False, "Need at least 3 executions to learn pattern"
        
        # Validate content structure
        required_sections = ['## Context', '## Workflow', '## Metrics']
        for section in required_sections:
            if section not in body:
                return False, f"Missing section: {section}"
        
        return True, "Valid pattern"

if __name__ == '__main__':
    pattern_file = sys.argv[1]
    valid, message = validate_pattern(pattern_file)
    
    if valid:
        print(f"✅ {message}")
        sys.exit(0)
    else:
        print(f"❌ {message}", file=sys.stderr)
        sys.exit(1)
```

---

## Part 3: Plugin Definitions (All 4 Plugins)

### 3.1 agentops-core Plugin

**File:** `plugins/agentops-core/.claude-plugin/plugin.json`

```json
{
  "name": "agentops-core",
  "version": "1.0.0",
  "description": "Core AgentOps orchestration platform with universal patterns",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/boshu2/agentops",
  "license": "Apache-2.0",
  "homepage": "https://github.com/boshu2/agentops",
  "keywords": [
    "ai-agents",
    "orchestration",
    "workflows",
    "automation",
    "framework"
  ],
  "stability": "stable",
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "commands": "./commands",
    "agents": "./agents",
    "workflows": "./workflows",
    "skills": "./skills",
    "hooks": "./hooks"
  },
  "commands": [
    "prime",
    "prime-simple",
    "prime-complex",
    "research",
    "research-multi",
    "plan",
    "implement",
    "validate",
    "validate-multi",
    "bundle-save",
    "bundle-load",
    "learn"
  ],
  "agents": [
    "code-explorer",
    "doc-explorer",
    "history-explorer",
    "spec-architect",
    "risk-assessor",
    "change-executor",
    "validation-planner",
    "test-generator",
    "continuous-validator"
  ],
  "dependencies": {},
  "constitution": "./CONSTITUTION.md",
  "hooks": {
    "pre-commit": "./hooks/pre-commit.sh",
    "post-commit": "./hooks/post-commit.sh"
  }
}
```

### 3.2 agentops-devops Plugin

**File:** `plugins/agentops-devops/.claude-plugin/plugin.json`

```json
{
  "name": "agentops-devops",
  "version": "1.0.0",
  "description": "DevOps specialized agents for infrastructure, containers, and CI/CD",
  "author": {
    "name": "AgentOps Team"
  },
  "repository": "https://github.com/boshu2/agentops",
  "license": "Apache-2.0",
  "keywords": [
    "kubernetes",
    "docker",
    "ci-cd",
    "devops",
    "gitops",
    "infrastructure"
  ],
  "stability": "stable",
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "agents": "./agents",
    "commands": "./commands",
    "workflows": "./workflows",
    "validation": "./validation"
  },
  "dependencies": {
    "required": ["agentops-core"],
    "optional": []
  },
  "profile": {
    "type": "devops",
    "specializations": [
      "kubernetes",
      "docker",
      "ci-cd",
      "infrastructure",
      "monitoring"
    ]
  }
}
```

### 3.3 agentops-product-dev Plugin

**File:** `plugins/agentops-product-dev/.claude-plugin/plugin.json`

```json
{
  "name": "agentops-product-dev",
  "version": "1.0.0",
  "description": "Product development agents for APIs, UIs, and full-stack workflows",
  "author": {
    "name": "AgentOps Team"
  },
  "repository": "https://github.com/boshu2/agentops",
  "license": "Apache-2.0",
  "keywords": [
    "api",
    "frontend",
    "backend",
    "database",
    "full-stack",
    "product-development"
  ],
  "stability": "stable",
  "claude-code": {
    "minVersion": "2.0.13"
  },
  "components": {
    "agents": "./agents",
    "commands": "./commands",
    "workflows": "./workflows",
    "validation": "./validation"
  },
  "dependencies": {
    "required": ["agentops-core"],
    "optional": []
  },
  "profile": {
    "type": "product-dev",
    "specializations": [
      "api-development",
      "frontend",
      "backend",
      "database",
      "testing"
    ]
  }
}
```

---

## Part 4: Automated Testing & CI/CD

### 4.1 Plugin Validation CI

**File:** `.github/workflows/validate-plugins.yml`

```yaml
name: Validate Plugins

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  validate-structure:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install jq
        run: sudo apt-get install -y jq
      
      - name: Validate marketplace.json
        run: |
          jq '.' .claude-plugin/marketplace.json
          echo "✅ Marketplace manifest valid"
      
      - name: Validate plugin manifests
        run: |
          for plugin in plugins/*/; do
            if [ -f "$plugin/.claude-plugin/plugin.json" ]; then
              echo "Validating $plugin"
              jq '.' "$plugin/.claude-plugin/plugin.json"
            fi
          done
      
      - name: Check required fields
        run: ./scripts/validate-all-plugins.sh
      
      - name: Verify symlinks
        run: |
          ls -la core/commands
          ls -la core/agents
          ls -la core/workflows
          echo "✅ Backward compatibility maintained"

  test-installation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Test local installation
        run: |
          ./scripts/test-installation.sh
      
      - name: Verify commands available
        run: |
          # Test that command files exist
          test -f plugins/agentops-core/commands/prime.md
          test -f plugins/agentops-core/commands/research.md
          echo "✅ Core commands present"

  test-meta-orchestrator:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install pyyaml pytest
      
      - name: Test pattern validation
        run: |
          cd plugins/agentops-meta-orchestrator
          python -m pytest tests/
      
      - name: Test pattern extraction
        run: |
          cd plugins/agentops-meta-orchestrator
          ./tests/test-pattern-extraction.sh
      
      - name: Test auto-learning
        run: |
          cd plugins/agentops-meta-orchestrator
          ./tests/test-learning.sh

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run security scan
        run: |
          # Check for secrets in patterns
          ! grep -r "password\|secret\|key" plugins/agentops-meta-orchestrator/patterns/learned/ || exit 1
          echo "✅ No secrets in learned patterns"
```

### 4.2 Validation Scripts

**File:** `scripts/validate-all-plugins.sh`

```bash
#!/bin/bash
# Validate all plugins meet standards

set -e

echo "🔍 Validating all plugins..."

FAILED=0

for plugin_dir in plugins/*/; do
  plugin_name=$(basename "$plugin_dir")
  echo ""
  echo "📦 Validating $plugin_name..."
  
  # Check plugin.json exists
  if [ ! -f "$plugin_dir/.claude-plugin/plugin.json" ]; then
    echo "❌ Missing plugin.json"
    FAILED=$((FAILED + 1))
    continue
  fi
  
  # Validate JSON
  if ! jq empty "$plugin_dir/.claude-plugin/plugin.json" 2>/dev/null; then
    echo "❌ Invalid JSON in plugin.json"
    FAILED=$((FAILED + 1))
    continue
  fi
  
  # Check required fields
  required_fields=("name" "version" "description" "author")
  for field in "${required_fields[@]}"; do
    if ! jq -e ".$field" "$plugin_dir/.claude-plugin/plugin.json" >/dev/null; then
      echo "❌ Missing required field: $field"
      FAILED=$((FAILED + 1))
    fi
  done
  
  # Check README exists
  if [ ! -f "$plugin_dir/README.md" ]; then
    echo "⚠️  Missing README.md (recommended)"
  fi
  
  # Check tests exist
  if [ ! -d "$plugin_dir/tests" ]; then
    echo "⚠️  No tests directory (recommended)"
  fi
  
  echo "✅ $plugin_name validated"
done

echo ""
if [ $FAILED -eq 0 ]; then
  echo "✅ All plugins valid!"
  exit 0
else
  echo "❌ $FAILED plugin(s) failed validation"
  exit 1
fi
```

**File:** `scripts/test-installation.sh`

```bash
#!/bin/bash
# Test plugin installation flow

set -e

echo "🧪 Testing installation flow..."

# Create temp directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

echo "📂 Test directory: $TEST_DIR"

# Simulate plugin installation
echo "1️⃣ Simulating plugin discovery..."
MARKETPLACE_FILE="$OLDPWD/.claude-plugin/marketplace.json"
if [ ! -f "$MARKETPLACE_FILE" ]; then
  echo "❌ marketplace.json not found"
  exit 1
fi

PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_FILE")
echo "Found $PLUGIN_COUNT plugins"

echo "2️⃣ Testing agentops-core installation..."
CORE_DIR="$OLDPWD/plugins/agentops-core"
if [ ! -d "$CORE_DIR" ]; then
  echo "❌ agentops-core not found"
  exit 1
fi

echo "3️⃣ Verifying commands..."
for cmd in prime research plan implement; do
  if [ ! -f "$CORE_DIR/commands/$cmd.md" ]; then
    echo "❌ Missing command: $cmd"
    exit 1
  fi
done

echo "4️⃣ Testing meta-orchestrator installation..."
META_DIR="$OLDPWD/plugins/agentops-meta-orchestrator"
if [ ! -d "$META_DIR" ]; then
  echo "❌ agentops-meta-orchestrator not found"
  exit 1
fi

echo "5️⃣ Verifying meta-orchestrator structure..."
if [ ! -d "$META_DIR/patterns" ]; then
  echo "❌ Missing patterns directory"
  exit 1
fi

if [ ! -f "$META_DIR/scripts/auto-learn-commit.sh" ]; then
  echo "❌ Missing auto-learn script"
  exit 1
fi

echo "✅ Installation test passed!"
cd "$OLDPWD"
rm -rf "$TEST_DIR"
```

---

## Part 5: Meta-Orchestrator Testing

### 5.1 Pattern Extraction Test

**File:** `plugins/agentops-meta-orchestrator/tests/test-pattern-extraction.sh`

```bash
#!/bin/bash
# Test pattern extraction from execution

set -e

echo "🧪 Testing pattern extraction..."

# Create mock execution data
EXEC_DIR="$(mktemp -d)/test-execution"
mkdir -p "$EXEC_DIR"

cat > "$EXEC_DIR/execution.json" <<EOF
{
  "execution_id": "exec_test_001",
  "task": "Add OAuth2 to API",
  "timestamp": "2025-11-07T22:00:00Z",
  "workflow": [
    {"step": 1, "agent": "code-explorer", "duration": 300, "success": true},
    {"step": 2, "agent": "spec-architect", "duration": 600, "success": true},
    {"step": 3, "agent": "change-executor", "duration": 900, "success": true},
    {"step": 4, "agent": "test-generator", "duration": 400, "success": true}
  ],
  "result": "success",
  "total_duration": 2200
}
EOF

# Run pattern extraction
python3 scripts/extract-patterns.py "$EXEC_DIR/execution.json" > /tmp/test-pattern.md

# Validate pattern
if python3 scripts/validate-pattern.py /tmp/test-pattern.md; then
  echo "✅ Pattern extraction successful"
else
  echo "❌ Pattern extraction failed"
  exit 1
fi

# Check pattern content
if grep -q "## Workflow" /tmp/test-pattern.md; then
  echo "✅ Pattern contains workflow"
else
  echo "❌ Missing workflow section"
  exit 1
fi

echo "✅ Pattern extraction test passed"
rm -rf "$EXEC_DIR" /tmp/test-pattern.md
```

### 5.2 Learning System Test

**File:** `plugins/agentops-meta-orchestrator/tests/test-learning.sh`

```bash
#!/bin/bash
# Test git-based learning system

set -e

echo "🧪 Testing learning system..."

# Create test git repo
TEST_REPO=$(mktemp -d)/test-learning
mkdir -p "$TEST_REPO"
cd "$TEST_REPO"
git init
git config user.email "test@agentops.ai"
git config user.name "Test Bot"

# Copy learning scripts
cp "$OLDPWD/scripts/auto-learn-commit.sh" .
cp "$OLDPWD/scripts/validate-pattern.py" .

# Create test pattern
mkdir -p patterns/learned
cat > patterns/learned/test-pattern.md <<EOF
---
pattern_id: pat_test_001
created: 2025-11-07T22:00:00Z
category: testing
success_rate: 0.95
executions: 5
validated: true
---

# Test Pattern

## Context
Testing pattern learning

## Workflow
1. Test step 1
2. Test step 2

## Metrics
- Success rate: 95%
- Executions: 5
EOF

# Test learning commit
./auto-learn-commit.sh "exec_test_001" "patterns/learned/test-pattern.md"

# Verify commit
if git log --oneline | grep -q "Learn pattern"; then
  echo "✅ Learning commit successful"
else
  echo "❌ Learning commit failed"
  exit 1
fi

# Verify pattern in history
if git show HEAD:patterns/learned/test-pattern.md | grep -q "Test Pattern"; then
  echo "✅ Pattern stored in git"
else
  echo "❌ Pattern not in git"
  exit 1
fi

echo "✅ Learning system test passed"
cd "$OLDPWD"
rm -rf "$TEST_REPO"
```

---

## Part 6: Documentation & Migration

### 6.1 Enhanced README Section

Add to main `README.md` after line 258:

```markdown
## Installation

### 🚀 Quick Start (Recommended)

Install via Claude Code plugin marketplace:

\`\`\`bash
# 1. Install core framework
/plugin install agentops-core

# 2. Add domain profile (optional)
/plugin install agentops-devops        # For infrastructure/DevOps
/plugin install agentops-product-dev   # For product development

# 3. 🧠 Install Meta-Orchestrator (optional, alpha)
/plugin install agentops-meta-orchestrator
\`\`\`

### 🧠 What is Meta-Orchestrator?

The **Meta-Orchestrator** is a self-learning plugin that:
- Coordinates workflows across 1000+ plugins
- **Learns from every execution** via git-committed patterns
- Discovers optimal workflows automatically
- Improves success rates over time
- Provides intelligent plugin discovery

**Status:** Alpha (experimental, but functional)

**Example usage:**
\`\`\`bash
# Let meta-orchestrator figure out the workflow
/orchestrate "Add OAuth2 to my API with full test coverage"

# Analyze what plugins are best for a task
/analyze-plugins "kubernetes deployment with monitoring"

# See what the system has learned
/show-patterns --success-rate ">0.9"

# View meta-orchestrator statistics
/meta-stats
\`\`\`

### 📦 Installation Options

#### Option 1: Plugin Marketplace (Recommended)
\`\`\`bash
# Install from Claude Code marketplace
/plugin install agentops-core
\`\`\`

#### Option 2: Direct GitHub Marketplace
\`\`\`bash
# Add AgentOps marketplace
/plugin marketplace add github:boshu2/agentops

# Browse and install
/plugin list
/plugin install agentops-core
\`\`\`

#### Option 3: Manual Installation (Legacy)
\`\`\`bash
# Clone and use directly (backward compatible)
git clone https://github.com/boshu2/agentops.git
cd agentops
./scripts/install.sh
\`\`\`

### 🔄 Migrating from Legacy Installation

Existing users: No action required! Symlinks maintain full backward compatibility.

Optionally migrate to plugins:
\`\`\`bash
# Install plugin versions
/plugin install agentops-core
/plugin install agentops-devops  # If using DevOps profile

# Everything still works the same
/prime
/research "your task"
\`\`\`

See [MIGRATION.md](./MIGRATION.md) for details.
```

### 6.2 Meta-Orchestrator README

**File:** `plugins/agentops-meta-orchestrator/README.md`

```markdown
# 🧠 AgentOps Meta-Orchestrator

**Status:** Alpha (v0.9.0) - Experimental but functional

## What is This?

The Meta-Orchestrator is a **self-learning plugin** that coordinates AI agent workflows and **improves through experience**.

### Key Features

1. **🧠 Self-Learning**
   - Learns from every execution
   - Commits patterns to git
   - Improves success rates over time
   - No manual training required

2. **🔍 Intelligent Discovery**
   - Analyzes your task
   - Discovers relevant plugins
   - Recommends optimal workflows
   - Considers 1000+ plugins

3. **🚀 Workflow Orchestration**
   - Coordinates multi-agent workflows
   - Parallelizes when possible
   - Handles dependencies automatically
   - Tracks metrics in real-time

4. **📊 Pattern Library**
   - Git-based pattern storage
   - Validated, high-success patterns
   - Community-contributed learnings
   - Meta-patterns (patterns about patterns)

## Installation

\`\`\`bash
# Requires agentops-core
/plugin install agentops-core

# Install meta-orchestrator
/plugin install agentops-meta-orchestrator
\`\`\`

## Quick Start

\`\`\`bash
# Let meta-orchestrator handle it
/orchestrate "Add OAuth2 authentication to my REST API"

# See the execution plan first
/orchestrate "Deploy to production" --plan-only

# Analyze plugins for a task
/analyze-plugins "kubernetes monitoring setup"

# View learned patterns
/show-patterns

# See statistics
/meta-stats
\`\`\`

## How Learning Works

### 1. Execution
Every orchestrated workflow is tracked:
- Task description
- Workflow steps
- Success/failure
- Duration
- Plugins used

### 2. Pattern Extraction
After successful executions (≥3 times), patterns are extracted:
\`\`\`bash
# Automatic extraction
/orchestrate "task"  # Success → Pattern extracted

# Manual extraction
/learn-from exec_2025-11-07_1234
\`\`\`

### 3. Validation
Patterns are validated before learning:
- Minimum 3 successful executions
- Success rate ≥ 70%
- Complete workflow definition
- Proper metrics

### 4. Git Commit
Valid patterns are committed to git:
\`\`\`bash
git commit -m "Learn pattern: oauth-api-auth
Success rate: 95% (20 executions)"
\`\`\`

### 5. Continuous Improvement
As patterns accumulate:
- Success rates improve
- Recommendations get better
- Execution times decrease
- Edge cases covered

## Pattern Format

Learned patterns are stored in `patterns/learned/`:

\`\`\`markdown
---
pattern_id: pat_2025-11-07_oauth_api
category: api-development
success_rate: 0.95
executions: 20
validated: true
---

# Pattern: Add OAuth2 to REST API

## Context
When adding OAuth2 authentication to existing API

## Workflow
1. Research: Evaluate OAuth2 libraries
2. Plan: Design auth flow
3. Implement: Add middleware
4. Test: All grant types
5. Document: API changes

## Success Factors
- Use RFC 6749 compliant libraries
- Test all grant types
- Update API documentation

## Metrics
- Duration: ~45min
- Success: 95%
- Rollbacks: 5%
\`\`\`

## Commands Reference

### `/orchestrate <task>`
Main orchestration command

**Options:**
- `--plan-only` - Show plan without execution
- `--dry-run` - Simulate without changes
- `--learn` - Force learning from execution
- `--parallel` - Maximize parallelization
- `--conservative` - Serial execution

**Example:**
\`\`\`bash
/orchestrate "Add OAuth2 with tests" --plan-only
\`\`\`

### `/analyze-plugins [query]`
Discover and analyze plugins

**Options:**
- `--limit N` - Show top N results
- `--category CAT` - Filter by category
- `--installed` - Show only installed

**Example:**
\`\`\`bash
/analyze-plugins "k8s deployment" --limit 5 --category devops
\`\`\`

### `/show-patterns [filters]`
Display learned patterns

**Options:**
- `--category CAT` - Filter by category
- `--success-rate COMP` - e.g., ">0.9"
- `--recent N` - Show N most recent

**Example:**
\`\`\`bash
/show-patterns --success-rate ">0.9" --category api
\`\`\`

### `/learn-from <exec-id>`
Learn from specific execution

**Options:**
- `--interactive` - Interactive extraction
- `--force` - Skip validation

**Example:**
\`\`\`bash
/learn-from exec_2025-11-07_1234 --interactive
\`\`\`

### `/meta-stats`
Show meta-orchestrator statistics

**Output:**
- Total patterns learned
- Success rates by category
- Plugin usage rankings
- Learning velocity
- Optimization impact

## Architecture

\`\`\`
User Task
    ↓
┌─────────────────────────────┐
│   Intent Analysis           │ ← NLP parsing
└─────────────────────────────┘
    ↓
┌─────────────────────────────┐
│   Plugin Discovery          │ ← Search 1000+ plugins
└─────────────────────────────┘
    ↓
┌─────────────────────────────┐
│   Workflow Generation       │ ← Use learned patterns
└─────────────────────────────┘
    ↓
┌─────────────────────────────┐
│   Execution Orchestration   │ ← Multi-agent coordination
└─────────────────────────────┘
    ↓
┌─────────────────────────────┐
│   Pattern Extraction        │ ← Learn from execution
└─────────────────────────────┘
    ↓
┌─────────────────────────────┐
│   Git Commit (Learning)     │ ← Institutional memory
└─────────────────────────────┘
\`\`\`

## Metrics & Monitoring

Track learning progress:

\`\`\`bash
# View metrics
cat metrics/success_rates.log
cat metrics/durations.log
cat metrics/plugin_usage.log

# Learning metrics
cat metrics/learning_metrics.json
\`\`\`

**Example learning_metrics.json:**
\`\`\`json
{
  "total_patterns": 47,
  "validated_patterns": 45,
  "avg_success_rate": 0.89,
  "total_executions": 342,
  "categories": {
    "api-development": 12,
    "devops": 18,
    "data-engineering": 8
  },
  "learning_velocity": 2.3
}
\`\`\`

## Contributing Patterns

Submit your learned patterns:

1. Run tasks with meta-orchestrator
2. Successful patterns auto-extracted
3. Review in `patterns/discovered/`
4. Submit PR with validated patterns

See [CONTRIBUTING_PATTERNS.md](../../docs/meta-orchestrator/CONTRIBUTING_PATTERNS.md)

## Troubleshooting

### Pattern validation fails
\`\`\`bash
# Check pattern format
python scripts/validate-pattern.py patterns/discovered/my-pattern.md

# View validation rules
cat docs/PATTERN_FORMAT.md
\`\`\`

### Learning not working
\`\`\`bash
# Check git config
git config user.name
git config user.email

# Verify permissions
ls -la patterns/learned/
\`\`\`

### Low success rates
\`\`\`bash
# Analyze failed executions
cat metrics/failures.log

# Show problematic patterns
/show-patterns --success-rate "<0.7"
\`\`\`

## Roadmap

- [x] Git-based learning system
- [x] Pattern extraction and validation
- [x] Basic orchestration
- [ ] Multi-marketplace discovery (v1.0)
- [ ] Advanced parallelization (v1.1)
- [ ] Meta-patterns (patterns about patterns) (v1.2)
- [ ] Community pattern library (v1.3)
- [ ] ML-based optimization (v2.0)

## License

Apache 2.0 - Same as AgentOps core

## Support

- **Issues:** https://github.com/boshu2/agentops/issues
- **Discussions:** https://github.com/boshu2/agentops/discussions
- **Docs:** https://github.com/boshu2/agentops/tree/main/docs/meta-orchestrator
\`\`\`

### 6.3 Migration Guide

**File:** `MIGRATION.md`

```markdown
# Migration Guide: AgentOps to Plugin Marketplace

## Summary

AgentOps now distributes as Claude Code plugins for easier installation and modular adoption. **No breaking changes** - existing installations continue to work.

## For Existing Users

### What's Changed

1. **Structure:**
   - `core/*` → Moved to `plugins/agentops-core/`
   - `profiles/*` → Moved to `plugins/agentops-*/`
   - Symlinks maintain backward compatibility

2. **Installation:**
   - New: `/plugin install agentops-core`
   - Old: `./scripts/install.sh` (still works)

3. **New Feature:**
   - 🧠 Meta-Orchestrator plugin available
   - Self-learning workflow coordination
   - Git-based pattern learning

### Do I Need to Migrate?

**No.** Existing installations continue to work unchanged.

**Optional:** Migrate to plugins for:
- Automatic updates via marketplace
- Modular installation (pick what you need)
- Access to meta-orchestrator

### Migration Steps (Optional)

\`\`\`bash
# 1. Keep your existing setup (still works)
# No action required

# 2. Optionally install plugin versions
/plugin install agentops-core
/plugin install agentops-devops        # If using DevOps profile
/plugin install agentops-product-dev   # If using Product Dev profile

# 3. Optionally add meta-orchestrator
/plugin install agentops-meta-orchestrator

# 4. Test that everything works
/prime
/research "test topic"
\`\`\`

### Backward Compatibility

**Guaranteed:**
- All commands work identically
- All agents available
- All workflows function
- File paths resolve correctly
- No performance impact

**How:**
- Symlinks: `core/` → `plugins/agentops-core/`
- Script compatibility layer
- Same command syntax

### Benefits of Migration

1. **Easier Updates:**
   \`\`\`bash
   /plugin update agentops-core
   \`\`\`

2. **Modular Installation:**
   - Install only what you need
   - Switch profiles easily
   - Add/remove plugins

3. **New Features:**
   - Meta-orchestrator access
   - Community plugins
   - Marketplace ecosystem

4. **Better Discovery:**
   - Browse available profiles
   - See usage statistics
   - Community ratings

### Breaking Changes

**None.** This is a non-breaking change.

All existing functionality preserved:
- ✅ Commands work
- ✅ Agents available
- ✅ Workflows function
- ✅ Scripts run
- ✅ Git hooks active
- ✅ CONSTITUTION enforced

### Verification

Test that migration successful:

\`\`\`bash
# 1. Verify core commands
/prime
/research "test"

# 2. Check symlinks
ls -la core/commands
ls -la core/agents

# 3. Test profile commands
# (If using DevOps profile)
ls plugins/agentops-devops/

# 4. Verify git hooks
ls -la .git/hooks/
\`\`\`

### Troubleshooting

#### Commands not found
\`\`\`bash
# Check symlinks
./scripts/ensure-compatibility.sh
\`\`\`

#### Plugin install fails
\`\`\`bash
# Try local installation
git pull origin main
/plugin install ./plugins/agentops-core
\`\`\`

#### Meta-orchestrator issues
\`\`\`bash
# Check requirements
python3 --version  # Need 3.11+
git --version      # Need 2.0+

# Verify installation
ls plugins/agentops-meta-orchestrator/
\`\`\`

## For New Users

Just install via plugins:

\`\`\`bash
/plugin install agentops-core
/plugin install agentops-devops  # Optional
/plugin install agentops-meta-orchestrator  # Optional
\`\`\`

See [GET_STARTED.md](docs/GET_STARTED.md)

## FAQ

### Q: Do I have to migrate?
**A:** No. Existing installations work unchanged.

### Q: Will my custom profiles break?
**A:** No. Custom profiles in `profiles/` continue to work.

### Q: Can I use both old and new structure?
**A:** Yes. Symlinks allow both to coexist.

### Q: What about git history?
**A:** Preserved completely. Files moved with git mv.

### Q: Is meta-orchestrator required?
**A:** No. It's optional and experimental (alpha).

### Q: Can I rollback?
**A:** Yes. See "Rollback Procedure" below.

### Q: Will plugins get updates?
**A:** Yes. Via Claude Code marketplace or git pull.

### Q: Are there new dependencies?
**A:** No. Same dependencies as before.

## Rollback Procedure

If you want to revert to pre-plugin structure:

\`\`\`bash
# 1. Quick rollback (< 5 minutes)
rm -rf plugins/ .claude-plugin/
rm core/commands core/agents core/workflows
git checkout -- core/
./scripts/install.sh

# 2. Verify
ls -la core/
/prime  # Test

# 3. Git-based rollback
git log --oneline -10
git checkout [last-good-sha] -- .
\`\`\`

## Support

**Need Help?**
- 📖 [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- 💬 [GitHub Discussions](https://github.com/boshu2/agentops/discussions)
- 🐛 [Report Issue](https://github.com/boshu2/agentops/issues)

## Timeline

- **Nov 7, 2025:** Plugin structure created
- **Nov 8-10:** Testing and validation
- **Nov 11-12:** Community testing
- **Dec 1, 2025:** Official launch

---

*Migration guide updated: November 7, 2025*
\`\`\`

---

## Part 7: Implementation Timeline & Worktree Strategy

### 7.1 Three-Worktree Parallel Strategy

**Worktree 1: Marketplace Structure**
- Focus: Core marketplace setup
- Duration: 1-2 days
- Tasks:
  - Create `.claude-plugin/marketplace.json`
  - Set up plugin directories
  - Move core components
  - Create symlinks
  - Write plugin manifests
  - Test structure

**Worktree 2: Meta-Orchestrator Plugin**
- Focus: Self-learning system
- Duration: 2-3 days
- Tasks:
  - Create plugin structure
  - Implement learning scripts
  - Build pattern extraction
  - Set up git-based storage
  - Write tests
  - Create documentation

**Worktree 3: Testing & Documentation**
- Focus: Quality assurance
- Duration: 2 days
- Tasks:
  - Write automated tests
  - Set up CI/CD workflows
  - Create migration guide
  - Write plugin READMEs
  - Update main README
  - Create examples

### 7.2 Detailed Implementation Plan

#### Day 1: Foundation (Worktree 1 + 3)

**Morning (Worktree 1):**
1. Create marketplace structure
   ```bash
   mkdir -p .claude-plugin
   touch .claude-plugin/marketplace.json
   mkdir -p plugins/{agentops-core,agentops-devops,agentops-product-dev,agentops-meta-orchestrator}
   ```

2. Write marketplace.json
3. Create plugin directories

**Afternoon (Worktree 1):**
1. Move core components:
   ```bash
   mv core/commands plugins/agentops-core/
   mv core/agents plugins/agentops-core/
   mv core/workflows plugins/agentops-core/
   mv core/skills plugins/agentops-core/
   ```

2. Create symlinks:
   ```bash
   ln -s ../plugins/agentops-core/commands core/commands
   ln -s ../plugins/agentops-core/agents core/agents
   ln -s ../plugins/agentops-core/workflows core/workflows
   ```

3. Test backward compatibility

**Evening (Worktree 3):**
1. Write compatibility test scripts
2. Initial validation

#### Day 2: Plugin Manifests (Worktree 1 + 2)

**Morning (Worktree 1):**
1. Create agentops-core plugin.json
2. Create agentops-devops plugin.json
3. Create agentops-product-dev plugin.json
4. Validate all JSON

**Afternoon (Worktree 2):**
1. Create meta-orchestrator structure
2. Set up patterns directories
3. Create metrics directories
4. Write plugin.json for meta-orchestrator

**Evening (Worktree 2):**
1. Design pattern format
2. Write pattern validation schema

#### Day 3: Meta-Orchestrator Core (Worktree 2)

**Morning:**
1. Implement `auto-learn-commit.sh`
2. Implement `extract-patterns.py`
3. Implement `validate-pattern.py`

**Afternoon:**
1. Create skill definition (SKILL.md)
2. Write command definitions:
   - orchestrate.md
   - analyze-plugins.md
   - show-patterns.md
   - learn-from.md
   - meta-stats.md

**Evening:**
1. Create test patterns
2. Test learning flow manually

#### Day 4: Testing Infrastructure (Worktree 2 + 3)

**Morning (Worktree 2):**
1. Write pattern extraction tests
2. Write learning system tests
3. Create test fixtures

**Afternoon (Worktree 3):**
1. Create CI/CD workflows
2. Write validation scripts
3. Set up automated testing

**Evening (Worktree 3):**
1. Test entire pipeline
2. Fix any issues

#### Day 5: Documentation (Worktree 3)

**Morning:**
1. Write MIGRATION.md
2. Update main README.md
3. Create plugins/README.md

**Afternoon:**
1. Write meta-orchestrator/README.md
2. Create LEARNING_SYSTEM.md
3. Write PATTERN_FORMAT.md

**Evening:**
1. Create examples
2. Write troubleshooting guides

#### Day 6: Integration & Testing (All Worktrees)

**Morning:**
1. Merge worktree 1 (marketplace structure)
2. Test installation flow
3. Verify backward compatibility

**Afternoon:**
1. Merge worktree 2 (meta-orchestrator)
2. Test learning system end-to-end
3. Verify git commits work

**Evening:**
1. Merge worktree 3 (testing & docs)
2. Run full test suite
3. Fix any integration issues

#### Day 7: Polish & Validation (All Worktrees)

**Morning:**
1. Community testing
2. Bug fixes
3. Performance optimization

**Afternoon:**
1. Final documentation review
2. Create demo workflows
3. Prepare launch materials

**Evening:**
1. Tag release
2. Update CHANGELOG
3. Ready for launch

### 7.3 Worktree Setup Commands

```bash
# Create main worktree
cd /Users/fullerbt/.cursor/worktrees/agentops
git worktree list

# Create worktree 1: Marketplace Structure
git worktree add ../agentops-marketplace marketplace-structure
cd ../agentops-marketplace
git checkout -b feature/marketplace-structure

# Create worktree 2: Meta-Orchestrator
git worktree add ../agentops-meta-orchestrator meta-orchestrator
cd ../agentops-meta-orchestrator
git checkout -b feature/meta-orchestrator

# Create worktree 3: Testing & Docs
git worktree add ../agentops-testing testing-docs
cd ../agentops-testing
git checkout -b feature/testing-docs
```

---

## Part 8: Success Criteria & Validation

### 8.1 Marketplace Structure Validation

- [ ] marketplace.json valid JSON
- [ ] All 4 plugins have plugin.json
- [ ] Symlinks work for backward compatibility
- [ ] Core commands accessible via symlinks
- [ ] Profile commands accessible
- [ ] No broken links

**Test Command:**
```bash
./scripts/validate-all-plugins.sh
./scripts/test-installation.sh
```

### 8.2 Meta-Orchestrator Validation

- [ ] Pattern extraction works
- [ ] Pattern validation enforces rules
- [ ] Git commits successful
- [ ] Patterns stored correctly
- [ ] Metrics tracked
- [ ] Commands execute
- [ ] Learning system functional

**Test Command:**
```bash
cd plugins/agentops-meta-orchestrator
./tests/test-pattern-extraction.sh
./tests/test-learning.sh
./tests/test-orchestration.sh
```

### 8.3 Integration Validation

- [ ] Install agentops-core via plugin
- [ ] Install meta-orchestrator via plugin
- [ ] Run /orchestrate successfully
- [ ] Pattern learned and committed
- [ ] Backward compatibility maintained
- [ ] All tests pass
- [ ] CI/CD green

**Test Command:**
```bash
# Full integration test
./scripts/test-full-integration.sh
```

### 8.4 Documentation Validation

- [ ] MIGRATION.md complete
- [ ] README.md updated
- [ ] All plugins have README
- [ ] Meta-orchestrator docs complete
- [ ] Examples provided
- [ ] Troubleshooting guide written

**Test Command:**
```bash
# Check all docs exist
./scripts/validate-documentation.sh
```

### 8.5 Performance Benchmarks

- [ ] Plugin installation < 30 seconds
- [ ] Pattern extraction < 5 seconds
- [ ] Pattern validation < 2 seconds
- [ ] Git commit < 3 seconds
- [ ] Backward compatibility 0% overhead
- [ ] Meta-orchestrator overhead < 10%

### 8.6 Community Readiness

- [ ] Clear installation instructions
- [ ] Migration guide complete
- [ ] Contributing guide updated
- [ ] Issue templates created
- [ ] Discussion forums ready
- [ ] Demo videos recorded (optional)

---

## Part 9: Rollback & Recovery

### 9.1 Immediate Rollback (< 5 minutes)

```bash
#!/bin/bash
# Emergency rollback script

echo "🚨 Emergency rollback initiated..."

# 1. Remove plugin directories
rm -rf plugins/
rm -rf .claude-plugin/

# 2. Restore core from symlinks
rm core/commands core/agents core/workflows core/skills 2>/dev/null || true
git checkout -- core/

# 3. Restore profiles
git checkout -- profiles/

# 4. Verify restoration
ls -la core/
ls -la profiles/

# 5. Test basic functionality
if [ -f "core/commands/prime.md" ]; then
  echo "✅ Core commands restored"
else
  echo "❌ Restoration failed"
  exit 1
fi

echo "✅ Rollback complete"
```

### 9.2 Git-Based Rollback

```bash
# Find last good commit
git log --oneline -20

# Checkout specific commit
git checkout [last-good-sha] -- .

# Or revert specific commits
git revert [bad-commit-sha]

# Verify
make test
./scripts/test-installation.sh
```

### 9.3 Worktree Cleanup

```bash
# Remove worktrees
git worktree remove ../agentops-marketplace
git worktree remove ../agentops-meta-orchestrator
git worktree remove ../agentops-testing

# Delete branches if needed
git branch -D feature/marketplace-structure
git branch -D feature/meta-orchestrator
git branch -D feature/testing-docs
```

### 9.4 Recovery Validation

- [ ] Core commands work
- [ ] Profiles accessible
- [ ] No broken symlinks
- [ ] Git status clean
- [ ] Tests pass
- [ ] Documentation intact

---

## Part 10: Launch Strategy

### 10.1 Pre-Launch Checklist (Nov 11-30)

**Week 1 (Nov 11-17):**
- [ ] All code merged to main
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Community testing initiated
- [ ] Bug fixes completed

**Week 2 (Nov 18-24):**
- [ ] Performance benchmarks met
- [ ] Security review complete
- [ ] Demo workflows created
- [ ] Launch materials prepared
- [ ] Blog post written

**Week 3 (Nov 25-30):**
- [ ] Final testing
- [ ] Release notes written
- [ ] Changelog updated
- [ ] Tag release candidate
- [ ] Dry run launch

### 10.2 Launch Day (Dec 1)

**Morning:**
1. Tag v1.0.0 release
2. Push to GitHub
3. Publish blog post
4. Announce on social media
5. Post in communities

**Afternoon:**
1. Monitor for issues
2. Respond to feedback
3. Fix critical bugs
4. Update documentation

**Evening:**
1. Collect metrics
2. Plan hotfixes if needed
3. Celebrate 🎉

### 10.3 Post-Launch (Dec 2-7)

**Day 1-2:**
- Monitor adoption metrics
- Fix reported bugs
- Answer questions
- Update docs based on feedback

**Day 3-5:**
- Collect learned patterns
- Analyze meta-orchestrator usage
- Optimize based on metrics
- Plan v1.1 features

**Day 6-7:**
- Write case studies
- Create more examples
- Improve documentation
- Plan community contributions

### 10.4 Success Metrics

**Week 1:**
- [ ] 50+ plugin installations
- [ ] 10+ meta-orchestrator installations
- [ ] 5+ learned patterns submitted
- [ ] 0 critical bugs
- [ ] 90%+ backward compatibility reports

**Month 1:**
- [ ] 500+ installations
- [ ] 50+ meta-orchestrator users
- [ ] 50+ learned patterns
- [ ] Community contributions
- [ ] Enterprise inquiries

---

## Part 11: Risk Mitigation

### 11.1 Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Plugin structure breaks existing setups | Low | High | Symlinks + extensive testing |
| Meta-orchestrator learning fails | Medium | Medium | Fallback to manual patterns |
| Git commits fail | Low | Medium | Error handling + user notification |
| Performance degradation | Low | Medium | Benchmarking + optimization |
| CI/CD failures | Medium | Low | Comprehensive test coverage |

### 11.2 User Experience Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Confusion during migration | Medium | Medium | Clear documentation + migration guide |
| Installation difficulties | Low | High | Multiple installation methods |
| Meta-orchestrator complexity | Medium | Low | Good defaults + optional usage |
| Learning curve | Medium | Low | Examples + tutorials |

### 11.3 Community Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Low adoption | Low | High | Strong launch + clear value prop |
| Negative feedback | Low | Medium | Responsive support + quick fixes |
| Pattern quality issues | Medium | Medium | Validation + review process |
| Fork/competing projects | Low | Low | Open collaboration + Apache 2.0 |

---

## Part 12: Approval & Next Steps

### 12.1 Approval Checklist

- [ ] Marketplace structure validated
- [ ] Meta-orchestrator design approved
- [ ] Testing strategy comprehensive
- [ ] Documentation plan complete
- [ ] CI/CD workflows defined
- [ ] Rollback procedure verified
- [ ] Timeline realistic
- [ ] Risks identified and mitigated

**Approved by:** _______________
**Date:** November 7, 2025
**Next action:** Create worktrees and begin implementation

### 12.2 Immediate Next Steps

1. **Create Worktrees:**
   ```bash
   cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
   git worktree add ../marketplace marketplace-structure
   git worktree add ../meta-orchestrator meta-orchestrator
   git worktree add ../testing testing-docs
   ```

2. **Begin Implementation:**
   - Worktree 1: Start marketplace structure
   - Worktree 2: Start meta-orchestrator scaffold
   - Worktree 3: Start test framework

3. **Daily Sync:**
   - Morning: Review progress
   - Afternoon: Test integration
   - Evening: Document learnings

### 12.3 Communication Plan

**Internal:**
- Daily progress updates
- Blocker resolution
- Cross-worktree coordination

**External:**
- Community testing announcement (Nov 11)
- Beta testing program (Nov 15)
- Launch announcement (Dec 1)

---

## Appendix A: File Checklist

### Files to Create

**Marketplace:**
- [ ] `.claude-plugin/marketplace.json`
- [ ] `plugins/agentops-core/.claude-plugin/plugin.json`
- [ ] `plugins/agentops-devops/.claude-plugin/plugin.json`
- [ ] `plugins/agentops-product-dev/.claude-plugin/plugin.json`
- [ ] `plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json`

**Meta-Orchestrator:**
- [ ] `plugins/agentops-meta-orchestrator/README.md`
- [ ] `plugins/agentops-meta-orchestrator/LEARNING_LOG.md`
- [ ] `plugins/agentops-meta-orchestrator/skills/orchestrator/SKILL.md`
- [ ] `plugins/agentops-meta-orchestrator/commands/orchestrate.md`
- [ ] `plugins/agentops-meta-orchestrator/commands/analyze-plugins.md`
- [ ] `plugins/agentops-meta-orchestrator/commands/show-patterns.md`
- [ ] `plugins/agentops-meta-orchestrator/commands/learn-from.md`
- [ ] `plugins/agentops-meta-orchestrator/commands/meta-stats.md`
- [ ] `plugins/agentops-meta-orchestrator/scripts/auto-learn-commit.sh`
- [ ] `plugins/agentops-meta-orchestrator/scripts/extract-patterns.py`
- [ ] `plugins/agentops-meta-orchestrator/scripts/validate-pattern.py`
- [ ] `plugins/agentops-meta-orchestrator/tests/test-pattern-extraction.sh`
- [ ] `plugins/agentops-meta-orchestrator/tests/test-learning.sh`
- [ ] `plugins/agentops-meta-orchestrator/docs/ARCHITECTURE.md`
- [ ] `plugins/agentops-meta-orchestrator/docs/LEARNING_SYSTEM.md`

**CI/CD:**
- [ ] `.github/workflows/validate-plugins.yml`
- [ ] `.github/workflows/test-marketplace.yml`
- [ ] `.github/workflows/test-meta-orchestrator.yml`

**Scripts:**
- [ ] `scripts/ensure-compatibility.sh`
- [ ] `scripts/validate-all-plugins.sh`
- [ ] `scripts/test-installation.sh`
- [ ] `scripts/test-full-integration.sh`

**Documentation:**
- [ ] `MIGRATION.md`
- [ ] `MARKETPLACE_README.md`
- [ ] `plugins/README.md`
- [ ] `docs/plugins/CREATING_PLUGINS.md`
- [ ] `docs/meta-orchestrator/LEARNING_SYSTEM.md`

### Files to Modify

- [ ] `README.md` (add installation section)
- [ ] `CHANGELOG.md` (document changes)
- [ ] `.gitignore` (add patterns/discovered/)

---

## Appendix B: Command Reference

### Marketplace Commands

```bash
# Validate structure
./scripts/validate-all-plugins.sh

# Test installation
./scripts/test-installation.sh

# Run all tests
make test-marketplace

# Generate plugin scaffold
./scripts/generate-plugin.sh <plugin-name>
```

### Meta-Orchestrator Commands

```bash
# Test pattern extraction
cd plugins/agentops-meta-orchestrator
./tests/test-pattern-extraction.sh

# Test learning
./tests/test-learning.sh

# Validate pattern
python scripts/validate-pattern.py <pattern-file>

# Extract pattern manually
python scripts/extract-patterns.py <execution-id>
```

### Integration Commands

```bash
# Full integration test
./scripts/test-full-integration.sh

# CI/CD locally
act -j validate-plugins

# Performance benchmark
./scripts/benchmark-performance.sh
```

---

## Summary

This enhanced plan transforms AgentOps into:

1. **Claude Code Plugin Marketplace**
   - 4 plugins: core, devops, product-dev, meta-orchestrator
   - Modular installation
   - Backward compatible

2. **Self-Learning Meta-Orchestrator**
   - 🧠 Learns from every execution
   - Git-based pattern storage
   - Improves over time
   - Coordinates 1000+ plugins

3. **Production-Ready Infrastructure**
   - Automated testing
   - CI/CD workflows
   - Performance monitoring
   - Security validation

4. **Comprehensive Documentation**
   - Migration guide
   - Plugin creation guide
   - Learning system docs
   - Troubleshooting

**Estimated Effort:** 5-7 days with 3 parallel worktrees
**Risk Level:** Medium (mitigated through testing)
**Backward Compatibility:** 100% maintained
**Innovation Level:** 🚀 Revolutionary

---

**Next Action:** Create worktrees and begin implementation

**Command to start:**
```bash
cd /Users/fullerbt/.cursor/worktrees/agentops/BG0D2
git worktree add ../marketplace marketplace-structure
git worktree add ../meta-orchestrator meta-orchestrator  
git worktree add ../testing testing-docs
```

🚀 **Let's build the future of AI agent orchestration!**

