# Pre-Mortem: Register All 20 Agents

**Date:** 2026-01-26
**Spec:** .agents/plans/2026-01-26-register-agents-improve-coverage.md

## Summary

Plan to fix agent registration gap (6/20 agents available) and add smoke tests. Key risk: root cause unknown, so fix may require Claude Code internals knowledge we don't have.

**Note:** Pre-mortem failure expert agents (integration-failure-expert, ops-failure-expert, data-failure-expert, edge-case-hunter) are NOT registered, confirming the very problem we're trying to fix. Analysis performed manually.

## Simulation Findings

### CRITICAL (Must Fix)

1. **Root cause unknown - fix may be impossible**
   - **Why it will fail:** Issue 1 assumes we can diagnose why agents aren't registered. If registration happens in Claude Code's internal plugin loader (not in plugin.json), we may not be able to fix it.
   - **Recommended fix:** Check Claude Code documentation/source for agent registration requirements. Consider opening a GitHub issue if it's a bug.

2. **Chicken-and-egg with smoke test**
   - **Why it will fail:** Issue 3 (smoke test script) can't test agents via bash script - agents are only available inside Claude Code sessions via Task tool.
   - **Recommended fix:** Create a Claude Code prompt file that acts as the smoke test, not a bash script. Or use a meta-skill that dispatches all 20 agents.

### HIGH (Should Fix)

1. **Plugin refresh may require session restart**
   - **Risk:** After fixing plugin.json, Claude Code may cache the old configuration. User would need to restart session to see changes.
   - **Mitigation:** Document the refresh requirement. Test in fresh session after changes.

2. **Agent naming collision possible**
   - **Risk:** If another plugin registers `agentops:code-reviewer`, there could be conflicts.
   - **Mitigation:** Check for namespace conflicts in available agents list.

3. **No rollback plan**
   - **Risk:** If fix breaks the 6 working agents, we lose validation capability.
   - **Mitigation:** Commit current working state before making changes. Test incrementally.

### MEDIUM (Consider)

- Smoke test may have false negatives (agent available but returns error for other reason)
- Documentation may become stale if Claude Code changes agent registration
- 20 agents dispatching in parallel may hit rate limits

## Ambiguities Found

- How does Claude Code discover agents from `"agents": "./agents/"` path?
- What determines which agents appear in the "Available agents" list?
- Are the 6 registered agents special (hardcoded somewhere)?
- Does marketplace.json affect agent registration?

## Spec Enhancement Recommendations

1. **Add:** Fallback plan if root cause is Claude Code bug (file issue, workaround)
2. **Clarify:** What "smoke test" means - bash script won't work, needs Claude session
3. **Add:** Testing in fresh session after each change

## Verdict
[x] NEEDS WORK - Address critical issues first

The plan has a fundamental gap: we don't know WHY agents aren't registering. Before implementing, we should:
1. Research Claude Code agent registration mechanism
2. Revise Issue 3 to use in-session testing, not bash script
