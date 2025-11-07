# AgentOps Plugins

**Catalog of plugins in the agentops repository**

---

## Available Plugins

### agentops-meta-orchestrator

**Location:** `plugins/agentops-meta-orchestrator/`

**Type:** Agent Skill

**Version:** 0.1.0

**Status:** Alpha

**Description:** Analyzes 400+ Claude Code plugins across three marketplaces to learn orchestration patterns and generate optimal workflows. Automatically discovers which plugins work well together and recommends proven patterns for complex tasks.

**Installation:**
```bash
cd /path/to/agentops
/plugin install plugins/agentops-meta-orchestrator
```

**Key Features:**
- Multi-agent parallel research (3x speedup)
- 400+ plugin capability analysis
- Pattern-based workflow generation
- Continuous learning from executions
- 90%+ success rate for recommended workflows

**Commands:**
- `/orchestrate "[task]"` - Automatic plugin orchestration
- `/discover-patterns "[domain]"` - Pattern research

**Documentation:** See `plugins/agentops-meta-orchestrator/README.md`

---

## Plugin Development

To create a new plugin for this repository:

1. Create directory: `plugins/[your-plugin-name]/`
2. Follow Anthropic plugin spec
3. Add entry to this catalog
4. Test locally before committing

**Structure:**
```
plugins/[plugin-name]/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── commands/
├── skills/
└── scripts/
```

---

**Total Plugins:** 1

**Last Updated:** November 7, 2025
