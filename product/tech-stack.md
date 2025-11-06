# AgentOps Technical Stack

**Version:** 1.0.0 (Alpha)
**Last Updated:** November 5, 2025
**Status:** Pre-Launch (Dec 1, 2025)

---

## Overview

AgentOps is built with simplicity, portability, and developer experience as core principles. The tech stack is intentionally minimal—we use proven tools that work everywhere, avoiding unnecessary dependencies and complexity.

**Design Principles:**

1. **Minimal Dependencies** - Works with tools developers already have (git, markdown, shell)
2. **Language Agnostic** - Framework concepts apply regardless of implementation language
3. **Git-First** - Version control is the foundation for institutional memory
4. **Text-Based** - Markdown configuration for readability, diffability, portability
5. **Shell-Native** - CLI scripts for orchestration, compatible across platforms

---

## Core Technology Stack

### 1. Configuration & Documentation

**Technology:** Markdown + YAML frontmatter
**Rationale:**

- ✅ Human-readable and git-diffable
- ✅ Widely supported (every editor, IDE, platform)
- ✅ Enables rich documentation alongside configuration
- ✅ YAML frontmatter for structured metadata
- ✅ Easy to template and generate programmatically

**Usage:**

- Agent definitions (`profiles/*/agents/*.md`)
- Workflow specifications (`profiles/*/workflows/*.md`)
- Documentation (all `docs/` content)
- Case studies, guides, patterns

**Example Structure:**

```yaml
---
description: Brief description of agent
model: sonnet | opus
name: agent-name
tools: Read, Write, Edit, Bash, Grep, Glob
---

# Agent Name

Agent definition in markdown...
```

### 2. Version Control & Institutional Memory

**Technology:** Git
**Rationale:**

- ✅ Universal version control (every developer has it)
- ✅ Built-in history and audit trail
- ✅ Branching for experimentation (git worktree for multi-agent)
- ✅ Commit messages capture context and rationale
- ✅ Diffs show exactly what changed and why
- ✅ Enables institutional memory (learnings compound over time)

**Usage:**

- Store all agent sessions (commits document decisions)
- Track pattern extraction (learnings in commit messages)
- Context bundles (compressed artifacts stored in git)
- Multi-agent coordination (git worktree for parallel sessions)
- Constitutional enforcement (git hooks validate laws)

**Git Hooks (Enforcement):**

- **Pre-commit:** Validate Five Laws compliance, YAML syntax
- **Commit-msg:** Enforce semantic commit format
- **Post-commit:** Extract learnings, update metrics
- **Pre-push:** Verify no hook loops, final validation

### 3. Orchestration & Automation

**Technology:** Shell scripts (Bash/Zsh) + CLI tools
**Rationale:**

- ✅ Universal (works on macOS, Linux, WSL on Windows)
- ✅ Minimal dependencies (shell, git, basic CLI tools)
- ✅ Easy to understand and modify
- ✅ Chainable and composable (Unix philosophy)
- ✅ Fast execution (no interpreter overhead)

**Optional:** Python for advanced orchestration
- Used when shell becomes unwieldy
- Not required for basic framework functionality
- Provides libraries for NLP routing, context analysis

**Usage:**

- Installation scripts (`scripts/base-install.sh`, `scripts/project-install.sh`)
- Agent routing and execution
- Multi-agent coordination (spawn parallel sessions)
- Validation and testing
- Git worktree management for parallel agents

**Example (Multi-Agent Orchestration):**

```bash
#!/bin/bash
# Launch 3 parallel research agents using git worktree

# Create worktrees for parallel work
git worktree add /tmp/agent-1 -b research-agent-1
git worktree add /tmp/agent-2 -b research-agent-2
git worktree add /tmp/agent-3 -b research-agent-3

# Launch agents in parallel (each in separate Claude Code session)
claude-code-session /tmp/agent-1 --agent=code-explorer &
claude-code-session /tmp/agent-2 --agent=doc-researcher &
claude-code-session /tmp/agent-3 --agent=history-analyst &

# Wait for completion
wait

# Merge results back to main branch
git worktree remove /tmp/agent-1
git worktree remove /tmp/agent-2
git worktree remove /tmp/agent-3
```

### 4. AI Agent Interface

**Technology:** Claude Code (Anthropic) via CLI
**Rationale:**

- ✅ Best-in-class AI reasoning (Claude 3.5 Sonnet, Opus)
- ✅ Large context windows (200K tokens)
- ✅ Tool use capabilities (Read, Write, Edit, Bash, etc.)
- ✅ CLI interface for automation
- ✅ Well-documented API

**Usage:**

- Agent execution (spawn Claude Code sessions)
- Multi-agent orchestration (parallel sessions)
- Context management (enforce 40% rule)
- Tool use for file operations, git, shell commands

**Alternative AI Providers (Future):**

- OpenAI (GPT-4, o1)
- Google (Gemini)
- Open-source models (Llama, Mistral)
- **Design Goal:** Provider-agnostic framework (swap AI backends)

### 5. Storage & State Management

**Technology:** Git repository + filesystem
**Rationale:**

- ✅ No database required (simplifies deployment)
- ✅ All state is files (readable, diffable, portable)
- ✅ Git provides versioning and history
- ✅ Context bundles stored as compressed markdown
- ✅ Institutional memory is commit history

**Storage Locations:**

```
$HOME/.agentops/               ← User-level AgentOps installation
  ├── scripts/                 ← Framework scripts
  ├── profiles/                ← Installed profiles
  └── config.yml               ← Global config

/path/to/project/              ← Project using AgentOps
  ├── .agentops/               ← Project-specific AgentOps config
  │   ├── profile/             ← Active profile (symlink or copy)
  │   ├── agents/              ← Customized agents
  │   ├── workflows/           ← Project workflows
  │   └── config.yml           ← Project config
  ├── .agents/                 ← Agent workspace (gitignored)
  │   ├── bundles/             ← Context bundles
  │   ├── sessions/            ← Session history
  │   └── metrics/             ← Performance data
  └── .git/                    ← Git repo (institutional memory)
```

---

## Development Tools

### Testing & Validation

**Technology:** Bash test framework + YAML validators
**Rationale:**

- ✅ Fast feedback (5-10 seconds for full validation)
- ✅ No test framework dependencies
- ✅ Easy to run in CI/CD
- ✅ Constitutional compliance checks (Five Laws enforcement)

**Tools:**

- `yamllint` - YAML syntax validation
- `shellcheck` - Shell script linting
- `markdownlint` - Markdown consistency
- Custom validators for Five Laws compliance

**Testing Approach:**

```bash
# Quick validation (syntax only, 5 seconds)
make quick

# Full validation (syntax + compliance + integration, 30 seconds)
make validate

# Integration tests (end-to-end agent workflows)
make test
```

### CI/CD Integration

**Technology:** GitHub Actions (primary), GitLab CI (secondary)
**Rationale:**

- ✅ Free for open-source projects
- ✅ Built-in to GitHub/GitLab (no external service)
- ✅ Matrix testing across platforms (macOS, Linux, Windows WSL)
- ✅ Easy integration with git hooks

**CI Workflow:**

1. Validate YAML syntax and markdown
2. Check Five Laws compliance
3. Run shell script tests
4. Test installation on multiple platforms
5. Validate documentation links
6. Run integration tests (agent workflows)

### Documentation

**Technology:** Markdown + Diátaxis methodology
**Rationale:**

- ✅ Diátaxis provides clear structure (tutorials, how-to, explanation, reference)
- ✅ Markdown renders everywhere (GitHub, docs sites, IDEs)
- ✅ Version-controlled alongside code
- ✅ Easy to contribute (no complex tooling)

**Structure:**

```
docs/
├── explanation/           ← Why patterns work (conceptual)
│   ├── agentops-manifesto.md
│   └── PATTERN_EXTRACTION_METHODOLOGY.md
├── how-to/                ← How to use patterns (procedural)
│   ├── CREATE_CUSTOM_PROFILE.md
│   └── [domain-specific guides]
├── reference/             ← Reference material (lookups)
│   └── [API docs, command references]
└── tutorials/             ← Learning-oriented (step-by-step)
    └── [getting started guides]
```

---

## Optional Enhancements (Future)

### Advanced Orchestration (Phase 2+)

**Python + Libraries:**

- **Why:** Shell scripts become unwieldy for complex orchestration
- **When:** Phase 2+ (after MVP launch)
- **Libraries:**
  - `anthropic` - Anthropic API client
  - `openai` - OpenAI API client (multi-provider support)
  - `spacy` or `transformers` - NLP for intelligent routing
  - `networkx` - Agent dependency graphs
  - `pyyaml` - YAML parsing and generation

**Example (Intelligent Routing):**

```python
from agentops.routing import route_task
from agentops.agents import load_agents

agents = load_agents("profiles/default/agents/")
task = "Debug production incident with Redis cache"
recommended = route_task(task, agents)  # Returns: incident-response agent
```

### Web Dashboard (Phase 3+)

**Technology:** Lightweight web UI for observability
**Rationale:**

- ✅ Visualize agent sessions, metrics, patterns
- ✅ Browse context bundles and institutional memory
- ✅ Search learnings and extracted patterns
- ✅ Track performance over time

**Tech Stack (When Needed):**

- **Frontend:** Simple HTML + JavaScript (no framework initially)
- **Backend:** Flask/FastAPI (Python, lightweight)
- **Data:** Read directly from git repo (no separate DB)
- **Deployment:** Single binary or Docker container

**Not MVP - Deferred to Phase 3+**

### SaaS Offering (Phase 4+)

**Technology:** Cloud-native deployment
**Rationale:**

- ✅ Managed hosting for teams
- ✅ Multi-tenancy support
- ✅ Enhanced security and compliance
- ✅ Real-time collaboration

**Tech Stack (When Needed):**

- **Infrastructure:** Kubernetes (agent orchestration at scale)
- **Database:** PostgreSQL (user/team management)
- **Cache:** Redis (session state, rate limiting)
- **Queue:** RabbitMQ or Kafka (async agent coordination)
- **Auth:** OAuth2 / SAML (enterprise SSO)
- **Monitoring:** Prometheus + Grafana (observability)

**Not MVP - Deferred to Phase 4+**

---

## Installation & Deployment

### Installation Approach

**Two-Stage Installation:**

1. **Base Install** - Framework setup (global, user-level)
2. **Project Install** - Per-project configuration (local)

**Base Install (`base-install.sh`):**

```bash
#!/bin/bash
# Install AgentOps framework to ~/.agentops

INSTALL_DIR="$HOME/.agentops"

# Clone framework
git clone https://github.com/boshu2/agentops.git "$INSTALL_DIR"

# Install dependencies (minimal)
# - Git (already required)
# - Bash/Zsh (already required)
# - yamllint (optional, for validation)

# Add to PATH
echo 'export PATH="$HOME/.agentops/scripts:$PATH"' >> ~/.bashrc

echo "✅ AgentOps installed to $INSTALL_DIR"
echo "Run: agentops init in your project to get started"
```

**Project Install (`project-install.sh`):**

```bash
#!/bin/bash
# Initialize AgentOps in a project

PROJECT_DIR="$(pwd)"
PROFILE="${1:-default}"  # Default profile if not specified

# Create .agentops directory
mkdir -p "$PROJECT_DIR/.agentops"

# Link or copy profile
ln -s "$HOME/.agentops/profiles/$PROFILE" "$PROJECT_DIR/.agentops/profile"

# Create agent workspace (gitignored)
mkdir -p "$PROJECT_DIR/.agents/bundles"
mkdir -p "$PROJECT_DIR/.agents/sessions"
mkdir -p "$PROJECT_DIR/.agents/metrics"

# Add to .gitignore
echo ".agents/" >> .gitignore

# Install git hooks (constitutional enforcement)
cp "$HOME/.agentops/hooks/"* "$PROJECT_DIR/.git/hooks/"

echo "✅ AgentOps initialized with '$PROFILE' profile"
echo "Run: agentops --help to see available commands"
```

### Platform Support

**Tier 1 (Fully Supported):**

- macOS (Apple Silicon + Intel)
- Linux (Ubuntu, Debian, Fedora, Arch)
- Windows (WSL2 with Ubuntu)

**Tier 2 (Community Supported):**

- FreeBSD
- Windows (Git Bash, PowerShell)
- Other Unix-like systems

**Minimum Requirements:**

- Git 2.30+
- Bash 4.0+ or Zsh 5.0+
- Claude Code CLI (or compatible AI agent CLI)
- 1GB disk space (for framework + profiles)
- Internet connection (for AI API calls)

---

## Security & Privacy

### Data Handling

**Local-First:**

- All data stored locally (git repo, filesystem)
- No telemetry by default (opt-in only)
- No cloud dependencies (works offline except AI calls)
- User controls all data (can delete, export, archive)

**AI Provider Considerations:**

- API calls to Anthropic (Claude) or other providers
- User responsible for API key management
- Sensitive data should be excluded from context (gitignore)
- Context bundles may contain project information

**Best Practices:**

1. Use `.gitignore` for secrets, credentials, sensitive files
2. Review context before sending to AI (40% rule helps)
3. Store API keys in environment variables (not in repo)
4. Use `.agents/` for temporary workspace (gitignored)
5. Review commits before pushing (hook loop prevention)

### Enterprise Security (Phase 4+)

**Air-Gapped Support:**

- Self-hosted AI models (Llama, Mistral)
- No external API calls required
- All data stays on-premises

**Secret Management:**

- Integration with Vault, AWS Secrets Manager
- Encrypted credential storage
- Audit logging for access

**Compliance:**

- SOC2 certification (SaaS offering)
- GDPR compliance (data residency)
- HIPAA support (healthcare domains)

---

## Technology Decisions & Rationale

### Why Markdown + Git (Not a Database)?

**Rationale:**

- ✅ **Simplicity:** No database to install, configure, maintain
- ✅ **Portability:** Works on any platform with git
- ✅ **Auditability:** Full history via git log
- ✅ **Readability:** Human-readable diffs and history
- ✅ **Tooling:** Every developer already has git
- ✅ **Institutional Memory:** Commits capture context and learnings

**Trade-off:** Less efficient for large-scale queries (but not needed for MVP)

### Why Shell Scripts (Not Python Everywhere)?

**Rationale:**

- ✅ **Universality:** Shell is on every platform
- ✅ **Simplicity:** No interpreter to install
- ✅ **Speed:** Fast startup, no overhead
- ✅ **Composability:** Unix philosophy (pipe, chain)
- ✅ **Learning Curve:** Most developers know shell basics

**Trade-off:** Shell is less powerful for complex logic (use Python when needed)

### Why Claude Code (Not OpenAI or Others)?

**Rationale:**

- ✅ **Best reasoning:** Claude 3.5 Sonnet/Opus are state-of-the-art
- ✅ **Large context:** 200K tokens (needed for 40% rule)
- ✅ **Tool use:** Built-in file operations, shell commands
- ✅ **CLI interface:** Easily scriptable

**Trade-off:** Tied to one provider initially (but framework designed for multi-provider support in future)

### Why Profile-Based (Not Monolithic)?

**Rationale:**

- ✅ **Customization:** Different domains need different agents
- ✅ **Modularity:** Easy to extend, share, version
- ✅ **Community:** Enables contributions (add your domain profile)
- ✅ **Clarity:** Separation of concerns (core framework vs. domain logic)

**Trade-off:** More files to manage (but profiles are self-contained)

---

## Performance Considerations

### Context Management (40% Rule)

**Problem:** AI agents degrade when context windows exceed ~40% capacity

**Solution:**

- Enforce multi-phase workflows (fresh context per phase)
- Compress intermediate artifacts (context bundles, 5:1 to 10:1 ratio)
- JIT loading (load only what's needed for current phase)
- Git worktree for parallel agents (isolated contexts)

**Measurement:**

- Token counting before agent execution
- Alert if approaching 40% threshold
- Automatic phase splitting if needed

### Multi-Agent Orchestration (3x Speedup)

**Problem:** Serial agent work is slow (30 min research → blocking)

**Solution:**

- Parallel agent execution via git worktree
- Same total token budget, faster wall-clock time
- Synergistic results (agents explore different areas)

**Architecture:**

```
Main Branch
  ├── git worktree → /tmp/agent-1 (code-explorer)
  ├── git worktree → /tmp/agent-2 (doc-researcher)
  └── git worktree → /tmp/agent-3 (history-analyst)

Each agent works in isolated context (no conflicts)
Results merged back to main branch after completion
```

### Intelligent Routing (90.9% Accuracy)

**Problem:** Random agent selection wastes specialized capabilities

**Solution:**

- NLP classification of user task
- Agent scoring and ranking (match task to agent persona)
- Auto-recommend best-fit agent (user can override)

**Technology:**

- Initially: Keyword matching + heuristics (good enough for MVP)
- Phase 2+: spaCy or transformers for semantic similarity
- Phase 3+: Fine-tuned model on historical routing decisions

---

## Future Considerations

### Language-Agnostic Framework

**Vision:** AgentOps patterns work in any language

**Implementation:**

- Core concepts documented (universal patterns)
- Reference implementation in shell + Python (MVP)
- Community implementations in Go, Rust, JavaScript, etc.
- Standardized profile format (cross-language compatibility)

### Multi-Provider Support

**Vision:** Works with any AI provider (Claude, GPT, Gemini, open-source)

**Implementation:**

- Abstract AI interface (provider-agnostic API)
- Adapter pattern for each provider
- Fallback and load-balancing (try Claude, fall back to GPT)
- Cost optimization (use cheaper models for simple tasks)

### Real-Time Collaboration

**Vision:** Multiple agents + multiple users working together

**Implementation:**

- Operational transform (CRDT) for concurrent editing
- Agent-to-agent communication (message passing)
- Human approval gates (review workflows)
- Shared context (team institutional memory)

**Technology (When Needed):**

- WebSockets for real-time updates
- Redis pub/sub for agent coordination
- Conflict-free replicated data types (CRDTs)

**Not MVP - Phase 5+ consideration**

---

## Conclusion

AgentOps tech stack is intentionally minimal and pragmatic:

- **Markdown + Git** - Configuration and institutional memory
- **Shell scripts** - Orchestration and automation
- **Claude Code** - AI agent interface (multi-provider support in future)
- **Filesystem** - Storage and state management (no database needed)

**Design Philosophy:** Use proven tools that work everywhere, avoid unnecessary complexity, optimize for developer experience.

**Future Evolution:** Add capabilities as needed (Python for advanced orchestration, web UI for observability, SaaS for managed hosting), but keep core framework simple and portable.

**Success = Easy to install, easy to use, easy to extend, works everywhere.**

---

*"Simplicity is the ultimate sophistication. AgentOps uses the tools you already have."*

**AgentOps Tech Stack v1.0.0 - Ready for Ignition**
