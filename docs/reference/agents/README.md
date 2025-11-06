# Agent Reference

**Complete catalog of AgentOps workflow agents.**

This directory contains reference documentation for all AgentOps agents. Each agent implements specific patterns from the AgentOps framework and follows established operational principles.

## Agent Categories

### Product Planning
- [product-planner](product-planner.md) - Create comprehensive product documentation including mission and roadmap

### Specification Phase
- [spec-initializer](spec-initializer.md) - Initialize spec folder structure and save raw ideas
- [spec-shaper](spec-shaper.md) - Gather detailed requirements through targeted questions and visual analysis
- [spec-writer](spec-writer.md) - Create detailed specification documents for development
- [spec-verifier](spec-verifier.md) - Verify specifications and tasks lists

### Implementation Phase
- [tasks-list-creator](tasks-list-creator.md) - Create detailed and strategic tasks lists for development
- [implementer](implementer.md) - Implement features by following tasks.md specifications
- [implementation-verifier](implementation-verifier.md) - Verify end-to-end implementation of specifications

## Quick Reference

| Agent | Purpose | Model | Pattern |
|-------|---------|-------|---------|
| product-planner | Product documentation & roadmap | inherit | Phase-Based Workflow |
| spec-initializer | Initialize spec structure | sonnet | Initialization Pattern |
| spec-shaper | Requirements gathering | inherit | Research Pattern |
| spec-writer | Specification writing | inherit | Documentation Pattern |
| spec-verifier | Specification verification | sonnet | Verification Pattern |
| tasks-list-creator | Tasks list creation | inherit | Planning Pattern |
| implementer | Feature implementation | inherit | Implementation Pattern |
| implementation-verifier | Implementation verification | inherit | Verification Pattern |

## Agent Lifecycle

```
Product Planning
       ↓
Specification Phase
  1. Initialize (spec-initializer)
  2. Shape (spec-shaper)
  3. Write (spec-writer)
  4. Verify (spec-verifier)
       ↓
Implementation Phase
  1. Create Tasks (tasks-list-creator)
  2. Implement (implementer)
  3. Verify (implementation-verifier)
```

## Pattern References

All agents implement patterns from the AgentOps framework:

- **Phase-Based Workflow**: Research → Plan → Implement separation
- **Verification Gates**: Validation before proceeding to next phase
- **Documentation-First**: Specifications before implementation
- **Standards Compliance**: User preferences and tech stack alignment

See [12-factor-agentops patterns](https://github.com/boshu2/12-factor-agentops/tree/main/patterns) for framework documentation (Task Group 10).

## Usage

Agents are invoked through Claude Code's agent system. Each agent:

1. **Receives context** from prior phases
2. **Executes workflows** defined in `profiles/default/workflows/`
3. **Produces artifacts** (specifications, tasks lists, code, verification reports)
4. **Hands off** to next agent in the lifecycle

## Related Documentation

- [Workflows Reference](../workflows/README.md) - Detailed workflow documentation (Task Group 9)
- [How-To Guides](../../how-to/README.md) - Step-by-step usage guides (Task Group 8)
- [AgentOps Framework](https://github.com/boshu2/12-factor-agentops) - Theoretical foundation

---

**Status:** Production
**Last Updated:** 2025-11-06
**Agent Count:** 8
