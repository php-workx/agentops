# Pre-Mortem: Fix the 6 Unclassified Skills in SKILL-TIERS.md

**Date:** 2026-01-26
**Spec:** .agents/plans/2026-01-26-fix-skill-tiers.md
**Status:** ALREADY IMPLEMENTED (plan was executed earlier)

## Summary

This plan to add background tier and classify 6 skills has already been implemented. The pre-mortem analysis reveals deeper systemic issues with tier management that the simple fix doesn't address.

## Simulation Findings

### CRITICAL (Must Fix)

1. **Tier Field Not Extracted by Skill Discovery**
   - **Location:** `lib/skills-core.js:36-43`
   - **Why it will fail:** The `extractFrontmatter()` function only extracts `name` and `description` - tier field is ignored even if present in skill frontmatter.
   - **Impact:** SKILL-TIERS.md is documentation-only with no runtime validation.
   - **Recommended fix:** Add tier extraction to skills-core.js switch statement.

2. **No Validation Between SKILL-TIERS.md and Actual Skills**
   - **Why it will fail:** New skills can be added without updating SKILL-TIERS.md, creating data drift.
   - **Impact:** Documentation says 22 skills but only 21 exist (or vice versa).
   - **Recommended fix:** Create CI validation script comparing skill files vs tier table.

### HIGH (Should Fix)

1. **Bidirectional Sync Not Enforced**
   - **Risk:** Skills renamed/reclassified in code without SKILL-TIERS.md update.
   - **Mitigation:** Add pre-commit hook or CI check.

2. **Hook System Doesn't Use Tier**
   - **Risk:** "solo" skill could be added to hooks without catching tier mismatch.
   - **Mitigation:** Validate tier before hook dispatch.

3. **Tier Values Not Schema-Validated**
   - **Risk:** Typos in tier values (`"backgrond"`) not caught.
   - **Mitigation:** Add JSON schema with tier enum validation.

4. **Marketplace Publishing Gap**
   - **Risk:** SKILL-TIERS.md not included in plugin distribution.
   - **Mitigation:** Include in package manifest.

5. **Same-Name Skill Conflicts**
   - **Risk:** User skill `research` (library) shadows `agentops:research` (solo).
   - **Mitigation:** Tier-aware resolution with disambiguation.

### MEDIUM (Consider)

1. **Version mismatch** - plugin.json version may lag SKILL-TIERS.md updates
2. **Case sensitivity** - `skill.md` vs `SKILL.md` may fail on Linux
3. **Platform divergence** - OpenCode.ai and ao CLI discover skills differently
4. **Circular dependencies** - No tier-based call graph validation
5. **Missing tier fallback** - Default tier for unclassified skills undefined
6. **Team tier not enforced** - `crank` calls `implement` (team) autonomously

## Ambiguities Found

- What is the default tier if a skill isn't in SKILL-TIERS.md?
- Should `tier` be in skill frontmatter or only in SKILL-TIERS.md?
- Can orchestration skills call other orchestration skills?
- Is team tier (human-required) enforced at runtime?

## Spec Enhancement Recommendations

1. **Add:** Validation script to CI comparing skill directory vs SKILL-TIERS.md
2. **Add:** Tier field extraction to lib/skills-core.js
3. **Add:** Schema validation for tier values
4. **Clarify:** Define default tier behavior for new/unclassified skills
5. **Document:** Tier enforcement rules (what prevents solo→hook?)

## Verdict

[x] NEEDS WORK - The simple plan (add rows to markdown table) is implemented, but systemic issues remain:
- Tier is documentation-only (no code integration)
- No validation/sync mechanism
- No schema enforcement

## Follow-up Issues to Create

1. `Add tier extraction to lib/skills-core.js`
2. `Create CI validation for SKILL-TIERS.md sync`
3. `Add tier schema validation`
4. `Document tier enforcement rules`
