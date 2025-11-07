# Trinity Integration

**The Trinity:** Three repositories, one unified PaaS ecosystem

```
🧠 12-factor-agentops (Philosophy - The Mind)
   ├── WHY patterns work
   └── Four Pillars, Five Laws
        ↓ defines
⚙️ agentops (Orchestration - The Engine)
   ├── HOW to implement
   └── Universal orchestrator
        ↓ implements
🌐 agentops-showcase (Presentation - The Voice)
   └── WHAT users experience
```

## This Repository's Role

**agentops** is the **Orchestration Layer** - The Engine

- **Purpose:** Implement HOW to execute AgentOps patterns
- **Contents:** Universal orchestrator, profiles system, CLI tools, validation scripts
- **Audience:** Practitioners, operators, integrators
- **Output:** Working implementation that runs AgentOps workflows

## The Other Two

**12-factor-agentops** - The Philosophy Layer (The Mind)
- **Purpose:** Define WHY AgentOps patterns work
- **Location:** `../12-factor-agentops/`
- **Contents:** Four Pillars, Five Laws, research, theoretical foundations
- **See:** [12-factor-agentops/TRINITY.md](../12-factor-agentops/TRINITY.md)

**agentops-showcase** - The Presentation Layer (The Voice)
- **Purpose:** Show WHAT users experience with AgentOps
- **Location:** `../agentops-showcase/`
- **Contents:** Examples, demos, case studies, learning paths
- **See:** [agentops-showcase/TRINITY.md](../agentops-showcase/TRINITY.md)

## How They Connect

### Implementation Flow
```
12-factor-agentops defines patterns
         ↓
agentops implements patterns ← YOU ARE HERE
         ↓
agentops-showcase demonstrates patterns
```

### Example: The Four Pillars
- **12-factor-agentops:** Defines Four Pillars theory (Context, Validation, Institutional Memory, Laws)
- **agentops:** Implements via profiles, validation scripts, git hooks, law enforcement ← **This repo**
- **agentops-showcase:** Shows real examples of pillars in action

### Example: Context Engineering
- **12-factor-agentops:** Explains WHY 40% rule works (research, neuroscience, AI limits)
- **agentops:** Enforces 40% rule via token budgets in profiles ← **This repo**
- **agentops-showcase:** Demonstrates efficiency gains (8x speedup examples)

## Version Alignment

**Current version:** v0.9.0

All three repositories share the same version number to indicate alignment:
- **12-factor-agentops:** v0.9.0 (philosophy)
- **agentops:** v0.9.0 (implementation)
- **agentops-showcase:** v0.9.0 (presentation)

Version synchronization ensures that patterns, implementation, and examples are consistent.

## Navigation

### From This Repository

**To understand theory:**
```bash
cd ../12-factor-agentops/
cat README.md
```

**To see examples:**
```bash
cd ../agentops-showcase/
cat README.md
```

### Cross-References

- **Implementation Map:** See `docs/trinity/implementation-map.md` for pattern→code mapping
- **Pattern Definitions:** See `../12-factor-agentops/docs/trinity/README.md`
- **Examples:** See `../agentops-showcase/content/trinity/navigation.json`

## Validation

To validate Trinity alignment:

```bash
make trinity-validate
```

This checks:
- ✅ Version alignment across all three repos
- ✅ Cross-references are valid
- ✅ Implementation matches patterns
- ✅ Mission statements aligned

## Mission Alignment

See [MISSION.md](./MISSION.md) for the unified mission statement shared by all three repositories.

## Contributing

When contributing to this repository:

1. **Understand your layer:** You're working in the Orchestration layer
2. **Implement patterns:** Focus on HOW, referencing WHY from 12-factor-agentops
3. **Enable showcasing:** Make features demonstrable for agentops-showcase
4. **Cross-reference:** Link to pattern definitions and examples
5. **Validate alignment:** Run `make trinity-validate` before committing

## Implementation Mapping

Every feature in agentops should map to:
- **Pattern definition** in 12-factor-agentops (WHY)
- **Working example** in agentops-showcase (WHAT)

See `docs/trinity/implementation-map.md` for complete mapping.

## Architecture Decision

**Why three repositories?**

- **Separation of concerns:** Philosophy, implementation, presentation are distinct
- **Independent evolution:** Each can evolve at its own pace
- **Clear boundaries:** Easy to understand what belongs where
- **Reusability:** This orchestrator can serve multiple use cases

**Why unified as Trinity?**

- **Consistency:** Every implementation traces to pattern definition
- **Navigation:** Users can move seamlessly between repos
- **Versioning:** Synchronized releases ensure alignment
- **Mental model:** Three aspects of one system, not three separate projects

## Core Components

### Profiles System
- **What:** Profile-based agent execution engine
- **Pattern:** Defined in 12-factor-agentops/foundations/profiles/
- **Example:** Showcased in agentops-showcase/content/profiles/

### Validation Framework
- **What:** Multi-stage validation (YAML, security, workflows)
- **Pattern:** Defined in 12-factor-agentops/foundations/validation/
- **Example:** Showcased in agentops-showcase/content/validation/

### CLI Tools
- **What:** Command-line interface for AgentOps workflows
- **Pattern:** Defined in 12-factor-agentops/patterns/cli-patterns/
- **Example:** Showcased in agentops-showcase/content/quickstart/

### Git Integration
- **What:** Institutional memory via git hooks and commit metadata
- **Pattern:** Defined in 12-factor-agentops/foundations/institutional-memory/
- **Example:** Showcased in agentops-showcase/content/git-workflow/

## Status

**Trinity integration status:** ✅ Active (v0.9.0)

This repository is part of the Trinity architecture. Every feature should have:
- ✅ Pattern reference in 12-factor-agentops
- ✅ Example demonstration in agentops-showcase
- ✅ Implementation map entry in `docs/trinity/implementation-map.md`

---

**Part of the Trinity:** Three repositories, one unified AgentOps ecosystem.
