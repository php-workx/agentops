# Marketplace Sources

**Purpose:** Comprehensive list of plugin marketplaces analyzed by the meta-orchestrator

**Last Updated:** November 7, 2025

**Total Sources:** 3 marketplaces

**Total Plugins:** 400+ analyzed

---

## Overview

The AgentOps Meta-Orchestrator analyzes plugins from three major Claude Code plugin marketplaces to discover workflow patterns and generate optimal orchestrations.

**Coverage Statistics:**
- **Total marketplaces:** 3
- **Total plugins:** 407+ (estimate)
- **Domain categories:** 23+
- **Active maintenance:** All 3 marketplaces actively maintained

---

## Source 1: claude-code-templates (davila7)

### Marketplace Information

**Repository:** https://github.com/davila7/claude-code-templates

**Author:** davila7

**Description:** Comprehensive collection of Claude Code components including agents, commands, MCPs, settings, hooks, and skills.

**Installation:**
```bash
# Via NPM (recommended)
npx claude-code-templates@latest

# Or install globally
npm install -g claude-code-templates
```

**Plugin Count:** 100+ components

**Categories:**
- **Agents** - Specialized AI agent configurations
- **Commands** - Slash commands for workflows
- **MCPs** - Model Context Protocol integrations
- **Settings** - Configuration templates
- **Hooks** - Event-driven automation
- **Skills** - Reusable skill definitions

**Maintenance Status:**
- Last updated: November 2025
- Update frequency: Active (weekly updates)
- Community: Growing (500+ stars)
- Issues: Actively resolved

**Strengths:**
- Well-organized by component type
- Excellent documentation
- NPM distribution (easy installation)
- Frequent updates with new templates

**Analysis Priority:** High (comprehensive, well-maintained)

---

## Source 2: wshobson/agents

### Marketplace Information

**Repository:** https://github.com/wshobson/agents

**Author:** wshobson

**Description:** Curated collection of Claude Code plugins, agents, and skills organized by domain.

**Installation:**
```bash
# Via Claude Code marketplace
/plugin marketplace add wshobson/agents

# Or clone repository
git clone https://github.com/wshobson/agents.git
```

**Plugin Count:**
- **63 plugins**
- **85 agents**
- **47 skills**

**Domain Categories (23 total):**
1. **android** - Android app development tools
2. **backend** - Backend development (APIs, databases, services)
3. **claude** - Claude-specific workflows and integrations
4. **code** - General programming tools
5. **data** - Data engineering and analysis
6. **devops** - Infrastructure and operations
7. **docs** - Documentation generation
8. **docker** - Container workflows
9. **frontend** - UI/UX development
10. **git** - Version control automation
11. **google-cloud** - GCP integrations
12. **javascript** - JS/TS development
13. **laravel** - PHP framework tools
14. **llms** - LLM integrations and workflows
15. **mobile** - Mobile development (iOS/Android)
16. **nextjs** - Next.js specific tools
17. **nodejs** - Node.js development
18. **php** - PHP development
19. **python** - Python development
20. **react** - React development
21. **ruby** - Ruby development
22. **search** - Search and discovery tools
23. **web** - General web development

**Maintenance Status:**
- Last updated: November 2025
- Update frequency: Active (bi-weekly updates)
- Community: Active (300+ stars)
- Issues: Responsive

**Strengths:**
- Domain-organized structure
- Mix of plugins, agents, and skills
- Real-world production use
- Strong domain coverage (23 categories)

**Analysis Priority:** High (diverse domains, production-tested)

---

## Source 3: jeremylongshore/claude-code-plugins-plus

### Marketplace Information

**Repository:** https://github.com/jeremylongshore/claude-code-plugins-plus

**Author:** jeremylongshore

**Description:** Extensive marketplace of Claude Code plugins covering development, devops, AI/ML, security, and more.

**Installation:**
```bash
# Via Claude Code marketplace
/plugin marketplace add jeremylongshore/claude-code-plugins-plus

# Or clone repository
git clone https://github.com/jeremylongshore/claude-code-plugins-plus.git
```

**Plugin Count:** 244 plugins

**Domain Categories:**
- **devops** - CI/CD, infrastructure, deployment
- **ai-ml** - Machine learning, model training, inference
- **database** - Database management and migrations
- **security** - Vulnerability scanning, auditing
- **api** - API development and testing
- **crypto** - Cryptography and blockchain
- **cloud** - Cloud platform integrations (AWS, Azure, GCP)
- **monitoring** - Observability and logging
- **testing** - Test generation and execution
- **documentation** - Doc generation and maintenance

**Maintenance Status:**
- Last updated: November 2025
- Update frequency: Active (monthly updates)
- Community: Growing (150+ stars)
- Issues: Responsive

**Strengths:**
- Largest plugin count (244)
- Strong devops/infrastructure coverage
- Security-focused plugins
- Cloud platform integrations

**Analysis Priority:** High (largest collection, unique security/cloud tools)

---

## Coverage Analysis

### Domain Coverage by Marketplace

| Domain | claude-code-templates | wshobson/agents | claude-code-plugins-plus | Total |
|--------|----------------------|-----------------|------------------------|-------|
| Web Development | ✓ | ✓ | ✓ | 3/3 |
| DevOps | ✓ | ✓ | ✓ | 3/3 |
| Backend | ✓ | ✓ | ✓ | 3/3 |
| Frontend | ✓ | ✓ | ✓ | 3/3 |
| Data Engineering | ✓ | ✓ | ✓ | 3/3 |
| Security | ✓ | Partial | ✓ | 2.5/3 |
| AI/ML | ✓ | ✓ | ✓ | 3/3 |
| Database | ✓ | Partial | ✓ | 2.5/3 |
| Testing | ✓ | Partial | ✓ | 2.5/3 |
| Documentation | ✓ | ✓ | ✓ | 3/3 |

**Coverage Score:** 95% (excellent overlap and complementary coverage)

### Overlap Analysis

**Redundant plugins** (same capability across marketplaces):
- ~15% overlap (similar tools for common tasks like API scaffolding)

**Unique plugins** (only in one marketplace):
- claude-code-templates: 25% unique (NPM-specific tools, hooks)
- wshobson/agents: 40% unique (domain-specific agents)
- claude-code-plugins-plus: 50% unique (security, cloud, crypto)

**Recommendation:** Analyze all 3 marketplaces for comprehensive coverage

---

## Installation Recommendations

### For Meta-Orchestrator Users

**Install all 3 marketplaces:**

Reason: Maximum plugin coverage, best orchestration recommendations

Steps:
```bash
# 1. Install claude-code-templates (NPM)
npm install -g claude-code-templates

# 2. Add wshobson/agents marketplace
/plugin marketplace add wshobson/agents

# 3. Add claude-code-plugins-plus marketplace
/plugin marketplace add jeremylongshore/claude-code-plugins-plus
```

**Or use automation script:**
```bash
cd /path/to/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts
./install-marketplaces.sh
```

### For Specific Domain Work

**Web Development:**
```bash
# Priority 1: wshobson/agents (23 web categories)
# Priority 2: claude-code-templates (component library)
```

**DevOps/Infrastructure:**
```bash
# Priority 1: claude-code-plugins-plus (244 plugins, strong devops)
# Priority 2: wshobson/agents (devops category)
```

**Security:**
```bash
# Priority 1: claude-code-plugins-plus (security focus)
# Priority 2: claude-code-templates (security hooks)
```

**AI/ML:**
```bash
# Priority 1: claude-code-plugins-plus (ai-ml category)
# Priority 2: wshobson/agents (llms category)
```

---

## Update Schedule

### Monitoring for New Marketplaces

**How to find new sources:**
1. GitHub search: `claude-code plugins`
2. Claude Code community forums
3. NPM search: `claude-code`
4. User recommendations

**Evaluation criteria for new marketplaces:**
- **Size:** At least 10+ plugins
- **Maintenance:** Updated within last 3 months
- **Documentation:** README with installation instructions
- **Quality:** At least 3+ working examples
- **Uniqueness:** Offers plugins not in existing 3 marketplaces

**Add to this list when:**
- New marketplace meets all 5 criteria
- Provides significant new capabilities
- Has active community engagement

### Refresh Frequency

**How often to update marketplace data:**

**Plugin counts:** Monthly
- Check total plugin count for each marketplace
- Update coverage analysis

**New plugins:** Weekly
- Scan for newly added plugins
- Analyze new capabilities
- Update pattern library if new patterns discovered

**Deprecated plugins:** Quarterly
- Check for removed/archived plugins
- Remove from analysis if no longer maintained
- Update patterns that relied on deprecated plugins

---

## Future Marketplace Candidates

### Under Evaluation

**1. anthropic/claude-code-examples**
- Official Anthropic examples
- Status: Monitoring for marketplace structure
- Estimated: 20+ examples

**2. Community collections**
- Various user-submitted plugins
- Status: Evaluating for quality/maintenance
- Estimated: 50+ scattered across repos

**3. Enterprise-specific marketplaces**
- Internal company plugin libraries
- Status: Requires access/permissions
- Estimated: Unknown

### Wishlist

**Domains needing more coverage:**
- **Legal tech** - Contract analysis, compliance
- **Healthcare** - Medical data processing, HIPAA compliance
- **Finance** - Financial modeling, risk analysis
- **Education** - Course generation, grading automation
- **Scientific research** - Data analysis, paper writing

**If you know of marketplaces covering these domains, please contribute!**

---

## Marketplace Statistics Summary

| Marketplace | Plugins | Categories | Last Updated | Stars | Priority |
|-------------|---------|------------|--------------|-------|----------|
| claude-code-templates | 100+ | 6 | Nov 2025 | 500+ | High |
| wshobson/agents | 63+85+47 | 23 | Nov 2025 | 300+ | High |
| claude-code-plugins-plus | 244 | 10 | Nov 2025 | 150+ | High |
| **Total** | **~407** | **39** | - | **950+** | - |

---

## Integration with Meta-Orchestrator

### How Marketplaces Are Analyzed

**Research Phase:**
1. Sub-agents clone/download each marketplace
2. Extract plugin metadata (names, descriptions, capabilities)
3. Categorize by domain
4. Identify integration patterns (which plugins work together)
5. Build capability graph (plugin relationships)

**Planning Phase:**
1. Match user task to plugin capabilities
2. Find patterns across all 3 marketplaces
3. Recommend optimal plugin sequence
4. Prefer plugins with higher usage/success rates

**Implementation Phase:**
1. Invoke plugins from any marketplace
2. Handle marketplace-specific installation if needed
3. Validate outputs regardless of source

**Learning Phase:**
1. Record which marketplace plugins came from
2. Track success rates per marketplace
3. Update recommendations based on reliability

### Marketplace-Specific Considerations

**claude-code-templates (NPM-based):**
- Installed globally via npm
- Components available immediately
- No marketplace add needed

**wshobson/agents (GitHub-based):**
- Requires marketplace add command
- Organized by domain folders
- Git-based updates

**claude-code-plugins-plus (GitHub-based):**
- Requires marketplace add command
- Organized by functionality
- Git-based updates

---

## Contributing

### Adding a New Marketplace

To propose a new marketplace for inclusion:

1. **Open an issue** at https://github.com/agentops/agentops/issues
2. **Provide:**
   - Marketplace URL
   - Plugin count
   - Domain coverage
   - Maintenance status
   - Why it's valuable

3. **Evaluation criteria:**
   - At least 10+ plugins
   - Updated within last 3 months
   - Good documentation
   - Working examples
   - Unique capabilities

### Updating This List

If you notice:
- Outdated plugin counts
- New marketplaces
- Deprecated marketplaces
- Changed URLs

Please submit a pull request with updates!

---

**Version:** 0.1.0
**Last Updated:** November 7, 2025
**Status:** Active (3 marketplaces being analyzed)
**Next Review:** December 7, 2025
