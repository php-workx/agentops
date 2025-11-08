# Implementation Plan: Trinity "One Skill to Rule Them All" Documentation Update

**Created:** 2025-11-08
**Status:** Ready for Implementation
**Token Budget:** Plan phase complete (~15k tokens used)

## Summary

Update all Trinity documentation (README.md, TRINITY.md, CLAUDE.md) across all three repos to emphasize:
1. **Single-command orchestration** - `/orchestrate` executes all 4 phases automatically
2. **"One Skill to Rule Them All"** - The meta-skill concept
3. **Browsable pattern library** - Users can explore discovered patterns via `/browse-patterns`, `/inspect-pattern`, `/replay-pattern`
4. **Neo4j integration** - Knowledge graph backend storing 400+ plugins and discovered patterns
5. **Prompt generator** - `/craft-prompt` command that generates optimized prompts from Neo4j

## Total Changes: 11 Edits Across 3 Repositories

### agentops (6 changes)
1. README.md:20-24 - Update tagline to "One Skill to Rule Them All"
2. README.md:97+ - Add comprehensive "One Skill" section with examples
3. README.md:149-176 - Update "See It In Action" to show single-command orchestration
4. README.md:180 - Add "One Skill" concept to table
5. Create commands/craft-prompt.md - Full `/craft-prompt` specification
6. CLAUDE.md:11-22 - Update "What is AgentOps?" section

### 12-factor-agentops (3 changes)
7. README.md:29-30 - Update Trinity note
8. README.md:230-231 - Emphasize "One Skill" concept
9. TRINITY.md:33+ - Add key innovation note

### agentops-showcase (2 changes)
10. README.md:146-154 - Update orchestration layer description
11. TRINITY.md:73-81 - Update meta orchestrator implementation details

## Implementation Order

1. Create `/craft-prompt` command specification (new file)
2. Update all README.md files (biggest changes)
3. Update TRINITY.md files (consistency)
4. Update CLAUDE.md files (kernel alignment)
5. Commit each repo separately with semantic commits

## Validation Commands

```bash
# Check markdown rendering
# (Visual review in IDE or GitHub)

# Verify no broken links
cd agentops && ./scripts/validate-doc-links.sh
cd ../12-factor-agentops && ./scripts/validate-doc-links.sh
cd ../agentops-showcase && # (no validation script yet)
```

## Key Messages to Communicate

1. **ONE command does everything:** `/orchestrate` is autonomous - all 4 phases automatic
2. **Browse discoveries:** `/browse-patterns` shows what the system learned
3. **Reuse patterns:** `/replay-pattern` executes proven workflows
4. **Get help prompting:** `/craft-prompt` generates perfect prompts
5. **Knowledge compounds:** Neo4j stores all discoveries, improves over time

## Success Criteria

- [ ] "One Skill to Rule Them All" prominently featured
- [ ] Single-command orchestration clear (not 4 separate commands)
- [ ] Pattern browsing capabilities documented
- [ ] Neo4j role explained
- [ ] `/craft-prompt` command specified
- [ ] Trinity consistency maintained
- [ ] All markdown valid

## Next Steps

Load this bundle and execute:
```bash
/bundle-load plan-trinity-one-skill-docs
/implement
```
