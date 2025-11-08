---
name: plugin-meta-orchestration
description: |
  Analyzes 400+ Claude Code plugins to discover optimal workflows for complex tasks.
  Triggers when: (1) User requests complex multi-step tasks requiring multiple plugins,
  (2) User asks for plugin recommendations or combinations, (3) User wants workflow
  optimization for existing processes, (4) User requests pattern discovery for specific domains.
  Uses parallel research to analyze plugin capabilities, generates evidence-based workflows,
  validates execution, and learns patterns for continuous improvement.
version: 0.2.0
author: AgentOps Team
license: Apache-2.0
---

# Plugin Meta-Orchestration

Intelligent orchestration layer that learns optimal plugin combinations by analyzing capabilities, discovering patterns, and executing validated workflows.

## Core Workflow

### 1. Research Phase (Parallel Analysis)

Spawn 3 sub-agents simultaneously to analyze available plugins:

**Sub-Agent 1: Capability Extraction**
- Scan plugin metadata (name, description, keywords)
- Extract: inputs, outputs, domain, capabilities
- Categorize by domain (web-dev, devops, data-eng, security, etc.)

**Sub-Agent 2: Integration Patterns**
- Map input/output compatibility between plugins
- Identify common sequences and dependencies
- Document data flow patterns

**Sub-Agent 3: Success Analysis**
- Analyze historical usage patterns
- Measure success rates per context
- Document known failure modes and fixes

**Output:** Comprehensive capability map with integration patterns and reliability scores

**Reference:** See [references/research-process.md](references/research-process.md) for detailed sub-agent workflows

### 2. Plan Phase (Workflow Generation)

Generate optimal workflow from research findings:

1. **Decompose task** into atomic subtasks with clear dependencies
2. **Match plugins** to subtasks based on capability, compatibility, success rate
3. **Sequence workflow** according to dependencies and data flow
4. **Define validation** checkpoints for each step
5. **Plan error handling** with retry strategies and fallbacks

**Output:** Detailed workflow specification with plugin sequence, inputs/outputs, validation criteria

**Reference:** See [references/planning-guide.md](references/planning-guide.md) for workflow generation patterns

### 3. Implement Phase (Validated Execution)

Execute workflow with continuous validation:

```
For each step:
  1. Invoke plugin with required inputs
  2. Capture outputs
  3. Validate against acceptance criteria
  4. If success: Pass outputs to next step, log success
  5. If failure: Retry → Fallback → Manual intervention
```

**Error Recovery Levels:**
1. Retry with exponential backoff (transient errors)
2. Fallback to alternative plugin (incompatibility)
3. Manual intervention (unrecoverable errors)

**Output:** Task completed with validation results

**Reference:** See [references/execution-guide.md](references/execution-guide.md) for detailed execution patterns

### 4. Learn Phase (Continuous Improvement)

Extract and persist patterns after every workflow:

**Pattern Extraction:**
- Record plugin sequence, parameters, success metrics
- Identify reusable pattern characteristics
- Calculate success rate and average completion time

**Pattern Storage (CRITICAL):**
```bash
# Always save patterns to filesystem
~/.claude/skills/meta-orchestrator/patterns/discovered/  # 1-4 executions
~/.claude/skills/meta-orchestrator/patterns/validated/   # 5-19 executions, 80%+ success
~/.claude/skills/meta-orchestrator/patterns/learned/     # 20+ executions, 90%+ success
```

**Pattern Matching:**
- Extract keywords from user request
- Match against pattern library (keyword overlap + success rate + usage count + recency)
- Rank and recommend top 3 patterns

**Script:** Use `scripts/pattern_storage.py` to automate pattern saving and lifecycle management

**Reference:** See [references/learning-system.md](references/learning-system.md) for pattern extraction and matching algorithms

### 5. Multimodal Workflows (Visual Feedback Loops)

**NEW:** Agents can now SEE what they build through screenshots and iterate based on visual feedback.

**Use cases:**
- Web development (UI components, forms, layouts)
- Monitoring dashboards (Grafana, charts, metrics)
- Data visualizations (graphs, plots, diagrams)
- QA testing (visual regression, responsive design)

**Core loop:**
```
1. Generate/Modify Code
2. Capture Screenshot (scripts/screenshot_wrapper.py)
3. Read Screenshot (Claude Code Read tool - multimodal)
4. Analyze Visually (layout, colors, spacing, typography)
5. Identify Issues
6. Iterate (max 5 iterations) OR Request Human Review
```

**Screenshot tools:**
```bash
# Web development (desktop)
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/ui.png

# Mobile viewport
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/mobile.png --viewport 375x667

# Grafana dashboards
bash scripts/grafana_screenshot.sh http://localhost:3000/d/dashboard /tmp/dashboard.png
```

**Visual analysis checklist:**
- Layout & structure (centered, aligned, responsive)
- Typography (sizes, weights, contrast, readability)
- Colors & contrast (WCAG AA minimum)
- Spacing & whitespace (padding, margins, consistency)
- UI elements (borders, shadows, hover states)

**Performance:**
- Screenshot latency: 1.2-1.8s average
- Iterations: 2-4 for simple components
- Speedup: 3-5x faster than text-only feedback
- Success rate: 90%+ (visual criteria met within 5 iterations)

**Reference:** See [references/multimodal-web-dev.md](references/multimodal-web-dev.md) for complete visual iteration workflows

**Patterns:** See `patterns/discovered/2025-11-08-nextjs-login-form-multimodal.md` for example

## When to Trigger

**Activate for:**

✓ Complex multi-step tasks: "Build web app with Next.js, PostgreSQL, deploy to Vercel"
✓ Plugin recommendations: "What plugins should I use for REST API?"
✓ Workflow optimization: "Is there a faster way to deploy containers?"
✓ Pattern discovery: "Show me patterns for data engineering"

**Don't activate for:**

✗ Single plugin usage: "Run the tests"
✗ Simple tasks: No orchestration needed
✗ Non-plugin requests: "What does this code do?"
✗ Other skill already active: Avoid conflicts

## Progressive Disclosure

SKILL.md contains core workflow only. Load these references as needed:

- **[research-process.md](references/research-process.md)** - Detailed sub-agent research workflows
- **[planning-guide.md](references/planning-guide.md)** - Workflow generation patterns and decomposition strategies
- **[execution-guide.md](references/execution-guide.md)** - Implementation patterns, error handling, validation
- **[learning-system.md](references/learning-system.md)** - Pattern extraction algorithms and storage
- **[examples.md](references/examples.md)** - Comprehensive usage examples across domains
- **[plugin-catalog.md](references/plugin-catalog.md)** - Plugin marketplace sources and categories

## Quick Start

For typical usage:

1. **User requests complex task** → Skill activates
2. **Read [research-process.md](references/research-process.md)** → Understand parallel research
3. **Execute research phase** → Analyze 400+ plugins
4. **Read [planning-guide.md](references/planning-guide.md)** → Generate workflow
5. **Execute workflow** → With validation and error handling
6. **Run pattern storage script** → `scripts/pattern_storage.py`

## Scripts

- **`scripts/pattern_storage.py`** - Automates pattern saving, lifecycle management, metrics tracking
- **`scripts/plugin_analyzer.py`** - Analyzes individual plugins for capabilities and compatibility
- **`scripts/pattern_matcher.py`** - Matches user requests to existing patterns
- **`scripts/install_marketplaces.sh`** - Installs all 3 plugin marketplaces

## Success Metrics

Expected outcomes after using this skill:

- **3-5x speedup** in complex multi-plugin tasks vs manual selection
- **90%+ success rate** for generated workflows (validated patterns)
- **Growing pattern library** improves recommendations over time
- **Reduced cognitive load** through automated plugin research

## Pattern Library Location

All patterns stored at: `~/.claude/skills/meta-orchestrator/patterns/`

Use `scripts/pattern_matcher.py` to search patterns, or manually browse:

```bash
# List all learned patterns (production-ready)
ls ~/.claude/skills/meta-orchestrator/patterns/learned/

# Search patterns by keyword
grep -r "api.*auth" ~/.claude/skills/meta-orchestrator/patterns/
```

## Key Principles

1. **Research before executing** - Analyze all options before choosing
2. **Evidence-based decisions** - Use success rates and usage data, not assumptions
3. **Validate continuously** - Check each step succeeds before proceeding
4. **Learn from every execution** - Record patterns for future reuse
5. **Parallel execution** - Research 400+ plugins simultaneously for 3x speedup

## Version History

### 0.2.0 (Current)
- Restructured following skill-creator best practices
- Moved detailed processes to references/
- Added automation scripts
- Improved progressive disclosure

### 0.1.0 (Initial)
- Multi-agent parallel research
- Pattern-based workflow generation
- Continuous validation
- Learning system
