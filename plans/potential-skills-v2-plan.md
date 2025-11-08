# Implementation Plan: AgentOps Meta-Orchestrator Agent Skill

## Summary

Build an Anthropic Agent Skill that analyzes 400+ **locally cloned** Claude Code plugins, learns meta-patterns about what works together, and generates optimal workflows for any task. This implements the AgentOps methodology (Research/Plan/Implement/Learn) applied to plugin orchestration.

**Key Innovation:** Scans your local plugin repositories (no API calls, no rate limits, instant analysis)

**Timeline:** 4-5 days implementation
**Complexity:** Medium (primarily documentation and structure)
**Value:** Self-learning orchestrator that improves with every use

---

## Changes Specified

### Phase 1: Plugin Structure Creation (Day 1 - 4 hours)

#### 1. Create plugin directory structure

**Command:**
```bash
mkdir -p /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/{.claude-plugin,commands,skills/agentops-orchestrator/{references,scripts,config,patterns/{discovered,validated,learned},metrics,assets}}
```

**Purpose:** Establish the plugin file structure with pattern library

**Validation:**
```bash
ls -la /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/
tree -L 3 /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/
```

#### 2. Create .claude-plugin/plugin.json

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json`

**Purpose:** Plugin metadata following Anthropic spec

**Content:**
```json
{
  "name": "agentops-meta-orchestrator",
  "version": "0.1.0",
  "description": "Self-learning Agent Skill that analyzes 400+ locally cloned Claude Code plugins, discovers workflow patterns, and orchestrates optimal multi-plugin workflows",
  "author": {
    "name": "AgentOps Team",
    "email": "team@agentops.ai"
  },
  "repository": "https://github.com/boshu2/agentops",
  "license": "Apache-2.0",
  "keywords": [
    "meta-orchestration",
    "agent-skills",
    "workflow-learning",
    "plugin-analysis",
    "pattern-discovery",
    "self-learning",
    "local-discovery"
  ],
  "capabilities": {
    "learns": true,
    "discovers": true,
    "orchestrates": true,
    "local_analysis": true
  }
}
```

**Validation:**
```bash
jq '.' /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json
```

#### 3. Create plugin README.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/README.md`

**Purpose:** Plugin documentation and usage guide

**Content:** ~300 lines covering:
- What the skill does (local plugin analysis + orchestration)
- How it works (4 phases: Discover → Analyze → Orchestrate → Learn)
- Configuration (local repo paths)
- Installation instructions
- Usage examples
- Expected outcomes

**Validation:**
```bash
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/README.md
```

---

### Phase 2: Core Skill Definition (Day 1-2 - 8 hours)

#### 4. Create SKILL.md (Primary Implementation)

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md`

**Purpose:** The Agent Skill definition following Anthropic spec v1.0

**Structure:**
```markdown
---
name: plugin-meta-orchestration
description: |
  Analyzes 400+ locally cloned Claude Code plugins to learn orchestration patterns
  and generate optimal workflows. Activates when users request complex multi-step
  tasks or ask about plugin recommendations. Uses local filesystem scanning for
  instant, offline-capable discovery.
---

## Overview
[200 lines: Purpose, approach, local discovery advantage]

## How It Works
[300 lines: 4-phase process with local scanning]

## Local Plugin Discovery
[200 lines: Filesystem scanning, configuration, caching]

## When to Use This Skill
[100 lines: Activation triggers]

## Research Phase: Local Analysis
[400 lines: Filesystem scanning, parallel analysis, pattern extraction]

## Planning Phase: Pattern Synthesis
[300 lines: Workflow generation from learned patterns]

## Implementation Phase: Orchestration
[200 lines: Multi-plugin execution coordination]

## Learning Phase: Continuous Improvement
[150 lines: Pattern library updates, git-based memory]

## Examples
[300 lines: Real-world orchestration scenarios]

## Integration
[100 lines: Using with other AgentOps tools]
```

**Total:** ~2,250 lines

**Validation:**
```bash
# Check frontmatter
head -n 10 /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md | grep "name:"

# Check line count
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md

# Validate markdown structure
grep -c "^## " /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md
```

---

### Phase 3: Configuration & Reference Materials (Day 2 - 4 hours)

#### 5. Create local-sources.yaml (NEW - Key for local discovery)

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/config/local-sources.yaml`

**Purpose:** Configure paths to locally cloned plugin repositories

**Content:**
```yaml
# Local Plugin Repository Configuration
# Update these paths to match your local setup

local_repositories:
  - name: claude-code-plugins-plus
    path: /Users/fullerbt/repos/claude-code-plugins-plus
    marketplace: jeremylongshore/claude-code-plugins-plus
    expected_count: 244
    priority: high
    categories:
      - devops
      - ai-ml
      - database
      - security
      - api
      - crypto

  - name: wshobson-agents
    path: /Users/fullerbt/repos/wshobson-agents
    marketplace: wshobson/agents
    expected_count: 85
    priority: high
    categories:
      - agents
      - skills
      - workflows

  - name: claude-code-templates
    path: /Users/fullerbt/repos/claude-code-templates
    marketplace: davila7/claude-code-templates
    expected_count: 100
    priority: medium
    categories:
      - templates
      - commands
      - mcps

# Optional: Additional custom plugin directories
additional_paths:
  - /Users/fullerbt/repos/my-custom-plugins
  - /Users/fullerbt/workspaces/personal/agentops/plugins

# Cache settings
cache:
  enabled: true
  refresh_interval_days: 7
  index_path: patterns/discovered/plugin-index.json
  incremental_updates: true

# Analysis settings
analysis:
  parallel_workers: 10
  timeout_per_plugin_seconds: 30
  extract_readme: true
  extract_examples: true
  analyze_git_history: false  # Optional: slower but richer analysis
```

**Validation:**
```bash
python3 -c "import yaml; yaml.safe_load(open('/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/config/local-sources.yaml'))"
```

#### 6. Create plugin-analyzer-template.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/plugin-analyzer-template.md`

**Purpose:** Template for analyzing individual plugins from local filesystem

**Content:** ~250 lines including:
- Analysis checklist (metadata extraction)
- Capability extraction from description + README
- Input/output identification from SKILL.md
- Dependency detection from plugin.json
- Command discovery (scan commands/)
- Agent discovery (scan agents/)
- Integration pattern recognition

**Validation:**
```bash
grep -c "##" /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/plugin-analyzer-template.md
```

#### 7. Create pattern-library-template.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/pattern-library-template.md`

**Purpose:** Template for recording discovered workflow patterns

**Content:** ~150 lines including:
- Pattern structure (name, sequence, state-flow, success-rate)
- Common pattern archetypes (sequential, parallel, conditional, feedback)
- Success criteria
- Failure modes
- Example pattern file

**Validation:**
```bash
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/pattern-library-template.md
```

#### 8. Create marketplace-sources.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/marketplace-sources.md`

**Purpose:** Document all plugin sources with local paths

**Content:**
```markdown
## Plugin Sources (Local Filesystem - Updated: 2025-11-07)

### Source 1: claude-code-plugins-plus (jeremylongshore)
- **GitHub:** https://github.com/jeremylongshore/claude-code-plugins-plus
- **Local Path:** `/Users/fullerbt/repos/claude-code-plugins-plus`
- **Count:** 244 plugins
- **Categories:** devops, ai-ml, database, security, api, crypto, blockchain, monitoring
- **Discovery Method:** Scan `.claude-plugin/plugin.json` files recursively
- **Update Command:** `cd /Users/fullerbt/repos/claude-code-plugins-plus && git pull`

### Source 2: wshobson/agents
- **GitHub:** https://github.com/wshobson/agents
- **Local Path:** `/Users/fullerbt/repos/wshobson-agents`
- **Count:** 63 plugins, 85 agents, 47 skills
- **Categories:** 23 domain categories (design, development, marketing, etc.)
- **Discovery Method:** Scan marketplace manifest + plugin directories
- **Update Command:** `cd /Users/fullerbt/repos/wshobson-agents && git pull`

### Source 3: claude-code-templates (davila7)
- **GitHub:** https://github.com/davila7/claude-code-templates
- **Local Path:** `/Users/fullerbt/repos/claude-code-templates`
- **Count:** 100+ components
- **Categories:** agents, commands, MCPs, settings, hooks, skills
- **Discovery Method:** Parse directory structure + README
- **Update Command:** `cd /Users/fullerbt/repos/claude-code-templates && git pull`

## Total Available
- **Repositories:** 3
- **Plugins/Components:** 400+
- **Categories:** 30+
- **Discovery Time:** ~30 seconds (local filesystem scan)

## Configuration

Edit `config/local-sources.yaml` to update paths:
```yaml
local_repositories:
  - path: /Users/fullerbt/repos/claude-code-plugins-plus
  - path: /Users/fullerbt/repos/wshobson-agents
  - path: /Users/fullerbt/repos/claude-code-templates
```

## Advantages of Local Discovery
✅ **Fast:** 30 seconds vs 10+ minutes via API
✅ **Offline:** No internet required after initial clone
✅ **No Rate Limits:** Scan as often as needed
✅ **Full Content:** Access to README, examples, tests
✅ **Git History:** Can analyze evolution (optional)
```

**Validation:**
```bash
grep -c "^### Source" /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/marketplace-sources.md
```

---

### Phase 4: Discovery & Analysis Scripts (Day 2-3 - 6 hours)

#### 9. Create discover-local-plugins.py (NEW - Core Innovation)

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/discover-local-plugins.py`

**Purpose:** Fast local filesystem scanning for plugin discovery

**Content:**
```python
#!/usr/bin/env python3
"""
Discover and analyze locally cloned Claude Code plugin repositories.
Fast, offline-capable plugin discovery via filesystem scanning.
"""

import os
import json
import yaml
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import sys

def load_config():
    """Load local repository configuration"""
    config_path = Path(__file__).parent.parent / "config" / "local-sources.yaml"
    with open(config_path) as f:
        return yaml.safe_load(f)

def discover_plugins_in_path(repo_path):
    """Recursively find all plugin.json files in a repository"""
    repo_path = Path(repo_path)
    if not repo_path.exists():
        print(f"⚠️  Path not found: {repo_path}")
        return []

    plugin_files = list(repo_path.rglob("*/. claude-plugin/plugin.json"))
    return plugin_files

def analyze_plugin(plugin_json_path):
    """Analyze a single plugin from its plugin.json"""
    try:
        plugin_dir = plugin_json_path.parent.parent

        # Read plugin.json
        with open(plugin_json_path) as f:
            metadata = json.load(f)

        analysis = {
            'name': metadata.get('name', 'unknown'),
            'version': metadata.get('version', '0.0.0'),
            'description': metadata.get('description', ''),
            'path': str(plugin_dir),
            'capabilities': [],
            'commands': [],
            'skills': [],
            'agents': [],
            'keywords': metadata.get('keywords', [])
        }

        # Scan for commands
        commands_dir = plugin_dir / "commands"
        if commands_dir.exists():
            analysis['commands'] = [f.stem for f in commands_dir.glob("*.md")]

        # Scan for skills
        skills_dir = plugin_dir / "skills"
        if skills_dir.exists():
            for skill_dir in skills_dir.iterdir():
                if skill_dir.is_dir():
                    skill_md = skill_dir / "SKILL.md"
                    if skill_md.exists():
                        analysis['skills'].append(skill_dir.name)

        # Scan for agents
        agents_dir = plugin_dir / "agents"
        if agents_dir.exists():
            analysis['agents'] = [f.stem for f in agents_dir.glob("*.md")]

        # Extract capabilities from description and keywords
        analysis['capabilities'] = extract_capabilities(
            metadata.get('description', '') + ' ' + ' '.join(metadata.get('keywords', []))
        )

        return analysis

    except Exception as e:
        print(f"❌ Error analyzing {plugin_json_path}: {e}")
        return None

def extract_capabilities(text):
    """Extract capability keywords from text"""
    capability_keywords = [
        'kubernetes', 'k8s', 'docker', 'container', 'api', 'rest', 'graphql',
        'database', 'sql', 'nosql', 'frontend', 'react', 'vue', 'angular',
        'backend', 'nodejs', 'python', 'go', 'rust', 'testing', 'test',
        'deployment', 'deploy', 'ci/cd', 'cicd', 'monitoring', 'observability',
        'security', 'auth', 'oauth', 'jwt', 'devops', 'infrastructure',
        'terraform', 'ansible', 'aws', 'azure', 'gcp', 'cloud',
        'ml', 'ai', 'machine-learning', 'data', 'analytics',
        'ui', 'ux', 'design', 'documentation', 'docs'
    ]

    text_lower = text.lower()
    return [kw for kw in capability_keywords if kw in text_lower]

def discover_all_plugins(config):
    """Discover all plugins from configured local repositories"""
    all_plugins = []

    print("🔍 Discovering plugins from local repositories...\n")

    for repo in config['local_repositories']:
        repo_name = repo['name']
        repo_path = repo['path']
        expected = repo.get('expected_count', '?')

        print(f"📂 Scanning {repo_name}...")
        print(f"   Path: {repo_path}")

        plugin_files = discover_plugins_in_path(repo_path)

        if not plugin_files:
            print(f"   ⚠️  No plugins found (expected ~{expected})")
            continue

        print(f"   Found {len(plugin_files)} plugin manifests")

        # Analyze in parallel
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = {executor.submit(analyze_plugin, pf): pf for pf in plugin_files}

            repo_plugins = []
            for future in as_completed(futures):
                result = future.result()
                if result:
                    result['marketplace'] = repo_name
                    repo_plugins.append(result)

            all_plugins.extend(repo_plugins)

        print(f"   ✅ Analyzed {len(repo_plugins)} plugins\n")

    return all_plugins

def save_plugin_index(plugins, output_path):
    """Save discovered plugins to index file"""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    index = {
        'generated': datetime.now().isoformat(),
        'total_plugins': len(plugins),
        'plugins': plugins,
        'by_marketplace': {},
        'by_capability': {}
    }

    # Group by marketplace
    for plugin in plugins:
        marketplace = plugin.get('marketplace', 'unknown')
        if marketplace not in index['by_marketplace']:
            index['by_marketplace'][marketplace] = []
        index['by_marketplace'][marketplace].append(plugin['name'])

    # Group by capability
    for plugin in plugins:
        for cap in plugin.get('capabilities', []):
            if cap not in index['by_capability']:
                index['by_capability'][cap] = []
            index['by_capability'][cap].append(plugin['name'])

    with open(output_path, 'w') as f:
        json.dump(index, f, indent=2)

    print(f"💾 Saved plugin index to {output_path}")

def main():
    """Main discovery process"""
    try:
        # Load configuration
        config = load_config()

        # Discover all plugins
        plugins = discover_all_plugins(config)

        if not plugins:
            print("❌ No plugins discovered. Check your config/local-sources.yaml paths.")
            sys.exit(1)

        # Save to index
        output_path = config['cache']['index_path']
        save_plugin_index(plugins, output_path)

        # Print summary
        print("\n" + "="*60)
        print("📊 Discovery Summary")
        print("="*60)
        print(f"Total plugins discovered: {len(plugins)}")

        by_marketplace = {}
        for p in plugins:
            mp = p.get('marketplace', 'unknown')
            by_marketplace[mp] = by_marketplace.get(mp, 0) + 1

        for marketplace, count in by_marketplace.items():
            print(f"  - {marketplace}: {count} plugins")

        print(f"\n✅ Discovery complete! Index saved to {output_path}")
        print(f"   Use /analyze-plugins to analyze capabilities")

    except Exception as e:
        print(f"❌ Discovery failed: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
```

**Validation:**
```bash
python3 -m py_compile /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/discover-local-plugins.py
chmod +x /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/discover-local-plugins.py
```

#### 10. Create update-repos.sh (NEW - Keep local repos fresh)

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/update-repos.sh`

**Purpose:** Git pull all local plugin repositories

**Content:**
```bash
#!/bin/bash
# Update all locally cloned plugin repositories

set -e

echo "🔄 Updating local plugin repositories..."
echo ""

# Read paths from config
REPOS=(
  "/Users/fullerbt/repos/claude-code-plugins-plus"
  "/Users/fullerbt/repos/wshobson-agents"
  "/Users/fullerbt/repos/claude-code-templates"
)

for repo in "${REPOS[@]}"; do
  if [ ! -d "$repo" ]; then
    echo "⚠️  Repository not found: $repo"
    continue
  fi

  echo "📂 Updating $(basename $repo)..."
  cd "$repo"

  if git pull; then
    echo "   ✅ Updated"
  else
    echo "   ❌ Update failed"
  fi

  echo ""
done

echo "✅ All repositories updated"
echo "   Run /analyze-plugins to re-scan for changes"
```

**Validation:**
```bash
bash -n /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/update-repos.sh
chmod +x /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/update-repos.sh
```

---

### Phase 5: Commands (Day 3 - 3 hours)

#### 11. Create /orchestrate command

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/orchestrate.md`

**Purpose:** Main command for users to request workflow orchestration

**Content:** ~250 lines with:
- Command syntax and options
- How it uses local plugin index
- Workflow generation logic
- Pattern matching from learned library
- Execution coordination
- Learning capture

**Validation:**
```bash
grep -c "^#" /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/orchestrate.md
```

#### 12. Create /analyze-plugins command (UPDATED - local discovery)

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/analyze-plugins.md`

**Purpose:** Trigger local plugin discovery and analysis

**Content:**
```markdown
---
description: Discover and analyze plugins from local repositories
---

# /analyze-plugins - Local Plugin Discovery

## Purpose
Scan locally cloned plugin repositories, extract capabilities, and build searchable index.

## Usage

```bash
# Full discovery (scans all configured repos)
/analyze-plugins

# Re-scan with fresh git pull
/analyze-plugins --refresh

# Scan specific repository
/analyze-plugins --repo claude-code-plugins-plus

# Quick scan (first 50 plugins for testing)
/analyze-plugins --limit 50

# Show configuration
/analyze-plugins --show-config
```

## What It Does

1. **Reads config:** Loads `config/local-sources.yaml`
2. **Scans filesystem:** Finds all `plugin.json` files
3. **Analyzes plugins:** Extracts metadata, commands, skills, agents
4. **Builds index:** Creates searchable `plugin-index.json`
5. **Caches results:** Stores for fast lookups

## Expected Output

```
🔍 Discovering plugins from local repositories...

📂 Scanning claude-code-plugins-plus...
   Path: /Users/fullerbt/repos/claude-code-plugins-plus
   Found 244 plugin manifests
   ✅ Analyzed 244 plugins

📂 Scanning wshobson-agents...
   Path: /Users/fullerbt/repos/wshobson-agents
   Found 85 plugin manifests
   ✅ Analyzed 85 plugins

📂 Scanning claude-code-templates...
   Path: /Users/fullerbt/repos/claude-code-templates
   Found 100 plugin manifests
   ✅ Analyzed 100 plugins

💾 Saved plugin index to patterns/discovered/plugin-index.json

============================================================
📊 Discovery Summary
============================================================
Total plugins discovered: 429

  - claude-code-plugins-plus: 244 plugins
  - wshobson-agents: 85 plugins
  - claude-code-templates: 100 plugins

✅ Discovery complete! Index saved.
```

## Performance

- **Duration:** ~30 seconds for 400+ plugins
- **Parallelization:** 10 workers (configurable)
- **Cached:** Yes (7-day default refresh)

## Configuration

Edit `config/local-sources.yaml` to customize paths:

```yaml
local_repositories:
  - name: claude-code-plugins-plus
    path: /Users/fullerbt/repos/claude-code-plugins-plus
    expected_count: 244
```

## Troubleshooting

**"Path not found" errors:**
```bash
# Check your paths in config
cat config/local-sources.yaml

# Clone missing repos
cd /Users/fullerbt/repos
git clone https://github.com/jeremylongshore/claude-code-plugins-plus
```

**No plugins discovered:**
```bash
# Verify directory structure
ls /Users/fullerbt/repos/claude-code-plugins-plus/plugins/

# Check for plugin.json files
find /Users/fullerbt/repos/claude-code-plugins-plus -name "plugin.json"
```

## Related Commands

- `/orchestrate <task>` - Use discovered plugins to orchestrate workflows
- `/discover-patterns` - Extract patterns from plugin interactions
```

**Validation:**
```bash
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/analyze-plugins.md
```

#### 13. Create /discover-patterns command

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/discover-patterns.md`

**Purpose:** Extract workflow patterns from successful orchestrations

**Content:** ~150 lines

**Validation:**
```bash
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/commands/discover-patterns.md
```

---

### Phase 6: Learning Infrastructure (Day 3-4 - 4 hours)

#### 14. Create pattern library README

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/patterns/README.md`

**Purpose:** Document pattern library organization and lifecycle

**Content:**
```markdown
# Pattern Library

Discovered workflow patterns organized by maturity level.

## Directory Structure

```
patterns/
├── discovered/      # New patterns (0-5 uses)
├── validated/       # Proven patterns (5-20 uses, >80% success)
└── learned/         # Mastered patterns (20+ uses, >90% success)
```

## Pattern Lifecycle

```
Execution → discovered/ → validated/ → learned/
           (found)       (proven)      (mastered)
```

### discovered/
- Newly identified patterns
- 0-5 successful executions
- Success rate not yet established
- Require validation

### validated/
- Patterns with track record
- 5-20 successful executions
- Success rate: 80-95%
- Recommended for use

### learned/
- Production-ready patterns
- 20+ successful executions
- Success rate: >90%
- Highest confidence

## Pattern Format

Each pattern file (`YYYY-MM-DD-category-name.md`):

```markdown
---
pattern_id: pat_2025-11-07_fullstack_api
created: 2025-11-07T15:30:00Z
category: full-stack-development
success_rate: 0.92
executions: 15
last_used: 2025-11-07T20:15:00Z
validated: true
---

# Pattern: Full-Stack API with Auth

## Context
Building a complete API with authentication and database

## Workflow
1. Database schema design (plugin: db-designer)
2. API endpoint generation (plugin: api-generator)
3. Authentication middleware (plugin: auth-builder)
4. Test suite generation (plugin: test-generator)

## Success Factors
- Use TypeScript for type safety
- PostgreSQL for relational data
- JWT for auth tokens

## Metrics
- Avg duration: 35min
- Success rate: 92%
- Parallelizable: Steps 1&3
```

## Pattern Promotion

Patterns automatically promote based on metrics:

```python
if executions >= 20 and success_rate > 0.90:
    move_to("learned/")
elif executions >= 5 and success_rate > 0.80:
    move_to("validated/")
```

## Searching Patterns

```bash
# Find patterns by category
ls patterns/validated/*api*

# Search pattern content
grep -r "authentication" patterns/learned/

# Use /discover-patterns command
/discover-patterns --category full-stack --success ">0.9"
```
```

**Validation:**
```bash
test -f /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/patterns/README.md
```

#### 15. Create metrics tracking files

**Files:**
- `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/success_rates.log`
- `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/durations.log`

**Purpose:** Track pattern success over time

**Content:**
```csv
# success_rates.log
timestamp,pattern_id,success,plugins_used,notes

# durations.log
timestamp,workflow_id,phase,duration_seconds,pattern_used
```

**Commands:**
```bash
touch /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/success_rates.log
touch /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/durations.log

echo "timestamp,pattern_id,success,plugins_used,notes" > /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/success_rates.log
echo "timestamp,workflow_id,phase,duration_seconds,pattern_used" > /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/durations.log
```

**Validation:**
```bash
test -f /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/success_rates.log
test -f /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/metrics/durations.log
```

#### 16. Create assets README

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/assets/README.md`

**Content:**
```markdown
# AgentOps Meta-Orchestrator Assets

Future home of:
- Workflow diagrams
- Pattern visualizations
- Success rate charts
- Example outputs

Currently empty - assets generated as patterns are discovered.
```

**Validation:**
```bash
test -f /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/assets/README.md
```

---

### Phase 7: Integration with AgentOps (Day 4 - 2 hours)

#### 17. Update main README.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/README.md`

**Change:** Add Meta-Orchestrator section after installation section (around line 260)

**Content to add:**
```markdown
### 🧠 Meta-Orchestrator Plugin (Experimental)

**NEW:** Self-learning plugin that orchestrates 400+ Claude Code plugins.

```bash
# Install the meta-orchestrator
/plugin install agentops-meta-orchestrator

# Configure your local plugin repositories
/analyze-plugins --configure

# Discover plugins (one-time setup, ~30 seconds)
/analyze-plugins

# Orchestrate complex workflows
/orchestrate "Build a SaaS app with auth, payments, and admin dashboard"

# See learned patterns
/discover-patterns --success ">0.9"
```

**Key Features:**
- 🔍 **Local Discovery:** Scans your locally cloned plugin repos (fast, offline)
- 🧠 **Self-Learning:** Learns from every execution, improves over time
- 📊 **Pattern Library:** Discovers, validates, and masters workflow patterns
- 🚀 **Auto-Orchestration:** Generates optimal multi-plugin workflows

**Status:** Alpha (v0.1.0) - Functional but experimental

See [plugins/agentops-meta-orchestrator/README.md](plugins/agentops-meta-orchestrator/README.md) for details.
```

**Validation:**
```bash
grep "meta-orchestrator" /Users/fullerbt/workspaces/personal/agentops/README.md
```

#### 18. Create plugins/README.md

**File:** `/Users/fullerbt/workspaces/personal/agentops/plugins/README.md`

**Purpose:** Document all plugins in the repository

**Content:**
```markdown
# AgentOps Plugins

## Available Plugins

### 🧠 agentops-meta-orchestrator (Alpha)

**Self-learning orchestrator for 400+ Claude Code plugins**

- **Path:** `plugins/agentops-meta-orchestrator/`
- **Version:** 0.1.0 (Alpha)
- **Purpose:** Discover, analyze, and orchestrate workflows across hundreds of plugins
- **Key Innovation:** Local filesystem scanning for instant, offline discovery

**Install:**
```bash
/plugin install agentops-meta-orchestrator
```

**Quick Start:**
```bash
# Configure local plugin repos (one-time)
/analyze-plugins --configure

# Discover all plugins (~30 seconds)
/analyze-plugins

# Orchestrate a workflow
/orchestrate "Deploy microservice with monitoring and logging"
```

**Documentation:** [README.md](agentops-meta-orchestrator/README.md)

---

## Future Plugins

Additional AgentOps plugins will be added here as they're developed.

## Creating Your Own Plugin

See [docs/CREATE_PROFILE.md](../docs/CREATE_PROFILE.md) for guidance on creating custom plugins.
```

**Validation:**
```bash
test -f /Users/fullerbt/workspaces/personal/agentops/plugins/README.md
wc -l /Users/fullerbt/workspaces/personal/agentops/plugins/README.md
```

---

### Phase 8: Marketplace Integration (Day 4-5 - 3 hours)

#### 19. Create marketplace.json

**File:** `/Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json`

**Purpose:** Make plugin discoverable via Claude Code marketplace

**Content:**
```json
{
  "$schema": "https://schemas.claude.com/marketplace/v1/schema.json",
  "name": "agentops",
  "version": "1.0.0",
  "description": "AI agent orchestration platform with self-learning meta-orchestrator",
  "homepage": "https://github.com/boshu2/agentops",
  "repository": {
    "type": "git",
    "url": "https://github.com/boshu2/agentops.git"
  },
  "license": "Apache-2.0",
  "keywords": [
    "ai-agents",
    "orchestration",
    "workflows",
    "meta-orchestrator",
    "self-learning"
  ],
  "plugins": [
    {
      "name": "agentops-meta-orchestrator",
      "source": "./plugins/agentops-meta-orchestrator",
      "description": "Self-learning orchestrator that analyzes 400+ plugins and discovers optimal workflows",
      "category": "meta",
      "version": "0.1.0",
      "stability": "alpha",
      "experimental": true,
      "tags": [
        "orchestration",
        "self-learning",
        "plugin-coordination",
        "workflow-discovery"
      ],
      "author": {
        "name": "AgentOps Team"
      }
    }
  ]
}
```

**Validation:**
```bash
jq '.' /Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json
jq '.plugins[0].name' /Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json
```

---

## Test Strategy

### Structural Validation

```bash
# Verify directory structure
tree -L 4 /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/

# Validate JSON files
jq '.' /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/.claude-plugin/plugin.json
jq '.' /Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json

# Validate YAML config
python3 -c "import yaml; yaml.safe_load(open('/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/config/local-sources.yaml'))"

# Check SKILL.md frontmatter
head -n 10 /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md | grep "name:"

# Verify script syntax
bash -n /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/*.sh
python3 -m py_compile /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/*.py

# Check file permissions
ls -la /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/
```

### Functional Testing

```bash
# Test local discovery script
cd /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator
python3 scripts/discover-local-plugins.py

# Expected output:
# 🔍 Discovering plugins from local repositories...
# 📂 Scanning claude-code-plugins-plus...
#    Found 244 plugin manifests
#    ✅ Analyzed 244 plugins
# ...
# ✅ Discovery complete!

# Verify index created
test -f patterns/discovered/plugin-index.json
jq '.total_plugins' patterns/discovered/plugin-index.json

# Test repo update script
scripts/update-repos.sh
```

### Installation Test

```bash
# Local marketplace test
cd /Users/fullerbt/workspaces/personal/agentops
/plugin marketplace add file:///Users/fullerbt/workspaces/personal/agentops

# List available plugins
/plugin list | grep agentops-meta-orchestrator

# Install the plugin
/plugin install agentops-meta-orchestrator

# Verify commands available
/help | grep orchestrate
/help | grep analyze-plugins
```

### Success Criteria Checklist

- [ ] All 19 files created with correct paths
- [ ] JSON files validate successfully
- [ ] YAML config loads without errors
- [ ] Markdown files have proper structure
- [ ] SKILL.md follows Anthropic spec v1.0
- [ ] Scripts have correct permissions (chmod +x)
- [ ] Python scripts compile without syntax errors
- [ ] Local discovery script finds 400+ plugins
- [ ] Plugin index generated successfully
- [ ] Plugin installs via marketplace
- [ ] Commands recognized by Claude Code
- [ ] Skill activates on relevant prompts

---

## Rollback Procedure

If implementation fails:

```bash
# Remove plugin directory
rm -rf /Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator

# Remove marketplace file
rm -f /Users/fullerbt/workspaces/personal/agentops/.claude-plugin/marketplace.json

# Remove plugin catalog
rm -f /Users/fullerbt/workspaces/personal/agentops/plugins/README.md

# Revert README changes
git checkout /Users/fullerbt/workspaces/personal/agentops/README.md

# Verify clean state
git status
```

---

## Implementation Order

### Day 1: Foundation + Local Discovery (6-8 hours)
1. Create directory structure (Task 1)
2. Create plugin.json (Task 2)
3. Create plugin README.md (Task 3)
4. Create local-sources.yaml config (Task 5) **← KEY**
5. Create discover-local-plugins.py (Task 9) **← KEY**
6. Begin SKILL.md (overview sections) (Task 4)
7. **Test:** Run discovery script, verify it finds plugins
8. Commit: `feat(meta-orchestrator): local plugin discovery`

### Day 2: Core Skill + References (6-8 hours)
1. Complete SKILL.md (all sections) (Task 4)
2. Create plugin-analyzer-template.md (Task 6)
3. Create pattern-library-template.md (Task 7)
4. Create marketplace-sources.md (Task 8)
5. Create update-repos.sh (Task 10)
6. **Test:** Validate SKILL.md structure, run scripts
7. Commit: `feat(meta-orchestrator): complete skill definition`

### Day 3: Commands + Learning (6-8 hours)
1. Create /orchestrate command (Task 11)
2. Create /analyze-plugins command (Task 12)
3. Create /discover-patterns command (Task 13)
4. Create pattern library README (Task 14)
5. Create metrics tracking (Task 15)
6. Create assets README (Task 16)
7. **Test:** Validate command markdown, check directory structure
8. Commit: `feat(meta-orchestrator): commands and learning infrastructure`

### Day 4: Integration (4-6 hours)
1. Update main README.md (Task 17)
2. Create plugins/README.md (Task 18)
3. Create marketplace.json (Task 19)
4. **Test:** Full structural validation
5. **Test:** Local installation via /plugin install
6. Commit: `feat(meta-orchestrator): integrate with agentops repo`

### Day 5: Testing & Refinement (4-6 hours)
1. Run all validation tests
2. Test discovery script with real repos
3. Fix any issues found
4. Test plugin installation end-to-end
5. Document learnings
6. Create example patterns (optional)
7. Commit: `feat(meta-orchestrator): testing and refinements`

---

## Key Enhancements from Base Plan

### 🚀 Local Filesystem Discovery
- **Fast:** 30 seconds vs 10+ minutes API calls
- **Offline:** No internet after initial clone
- **No Rate Limits:** Scan as often as needed
- **Full Content:** Access to README, examples, tests

### 🧠 Self-Learning Infrastructure
- **Pattern library:** discovered/ → validated/ → learned/ lifecycle
- **Metrics tracking:** success_rates.log, durations.log
- **Auto-promotion:** Patterns mature based on success rates
- **Institutional memory:** Git-based learning

### 📊 What This Enables
- Analyze 400+ plugins in ~30 seconds (vs hours via API)
- Learn from every orchestration execution
- Build pattern library that improves over time
- Offline-capable after initial setup

---

## Approval Checklist

- [ ] Research phase completed (local discovery validated)
- [ ] Approach validated (Agent Skill + local scanning optimal)
- [ ] File structure defined (19 files specified)
- [ ] Content outlined (line counts and structure)
- [ ] Local discovery script implemented (Python)
- [ ] Self-learning infrastructure added (patterns, metrics)
- [ ] Configuration flexible (YAML-based paths)
- [ ] Validation strategy defined (structural + functional tests)
- [ ] Rollback procedure documented (safe to revert)
- [ ] Timeline realistic (4-5 days for quality implementation)
- [ ] Risks identified and mitigated

---

## Next Steps

1. **Approve this plan**
2. **Verify local repo paths exist:**
   ```bash
   ls /Users/fullerbt/repos/claude-code-plugins-plus
   ls /Users/fullerbt/repos/wshobson-agents
   ls /Users/fullerbt/repos/claude-code-templates
   ```
3. **Start implementation:** Begin with Day 1 tasks
4. **Save plan bundle:** `/bundle-save meta-orchestrator-final-plan`

---

**Plan created:** November 7, 2025
**Updated:** November 7, 2025 (added local discovery)
**Estimated effort:** 4-5 days (26-38 hours)
**Risk level:** Low
**Value:** Self-learning orchestrator with instant local discovery
**Ready for:** Implementation 🚀
