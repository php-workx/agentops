# Life Profile Generalization - Requirements

## Objective

Transform `agentops/profiles/life/` into a universal `personal-development/` workflow package that anyone can customize while preserving all proven patterns.

## Success Criteria

### Must Have

1. **Universal Applicability**
   - Remove ALL personal-specific references (Oracle/Morpheus, NVIDIA, ADHD personal story, Session 46, life/ repo paths)
   - Replace with customizable placeholders `[YOUR_*]`
   - Work for ANY personal development framework, not just one implementation

2. **Pattern Preservation**
   - ALL 7 agents functional with placeholders
   - ALL workflow structures intact
   - Constitutional laws (40% rule, Five Laws) preserved
   - Validation and quality gates maintained

3. **Attribution & Examples**
   - Original implementation documented in `examples/` directory
   - 40% rule discovery story preserved
   - Oracle/Morpheus 6-week cycle as reference implementation
   - Production validation metrics included

4. **Customization Support**
   - Comprehensive `CUSTOMIZATION_GUIDE.md` (150-200 lines)
   - Clear placeholder system with examples
   - Step-by-step setup instructions
   - Validation checklist for users

5. **Integration Integrity**
   - Root-level agentops/ references updated
   - Multi-flavor coordination examples genericized
   - Cross-package references maintained
   - Git hooks and validation preserved

### Should Have

1. **Examples Directory** (4-6 example files)
   - `oracle-morpheus-6week-cycle.md` - Original 4-phase framework
   - `40-percent-rule-discovery.md` - Discovery story
   - `codex-v2-philosophy.md` - Philosophy structure example
   - `career-path-example.md` - Career planning template
   - `production-validation.md` - Metrics proof

2. **Template Quality**
   - Consistent `[YOUR_*]` placeholder naming
   - YAML frontmatter with customization metadata
   - Clear separation of universal patterns vs. personal examples
   - Inline customization notes where helpful

3. **Documentation Updates**
   - README.md transformation with customization section
   - CLAUDE.md bootstrap with generic loading instructions
   - CONSTITUTION.md with universal laws + example stories moved

### Could Have

1. **Migration Guide** (for existing users of life profile)
2. **Video walkthrough** of customization process
3. **Additional example implementations** (GTD, OKRs, weekly sprints)

### Won't Have (Out of Scope)

1. Modification of other profiles (infrastructure-ops, product-dev, devops)
2. Changes to agentops core orchestration logic
3. New features or capabilities (only generalization)

## Constraints

### Technical Constraints

1. **Preserve Git History**
   - Use `git mv` for directory rename
   - Maintain file history through transformation
   - Clear commit messages following semantic conventions

2. **Maintain Cross-References**
   - All internal links must resolve after transformation
   - Examples directory must be self-contained
   - Root-level references updated consistently

3. **Validation Gates**
   - YAML syntax validation must pass
   - No broken cross-references
   - All placeholders intentional (not missed replacements)

### Operational Constraints

1. **40% Rule Enforcement**
   - Implementation must respect 40% context rule
   - Execute in phases with validation between
   - No single phase exceeds 40% token budget

2. **Reversibility**
   - Must be able to rollback via git revert
   - Original life profile recoverable
   - Time to rollback < 10 minutes

### Business Constraints

1. **Attribution Preservation**
   - Credit original 2-year development journey
   - Acknowledge neurodivergent optimization origin
   - Maintain connection to proven production use

2. **Privacy Protection**
   - Remove specific personal references (company names, personal repo paths)
   - Generalize while preserving pattern credibility
   - Keep proof points (metrics) but anonymize context

## Non-Functional Requirements

### Usability

1. Users can customize in < 30 minutes with guide
2. Placeholder system is self-explanatory
3. Examples provide sufficient guidance
4. Error messages guide to CUSTOMIZATION_GUIDE.md

### Maintainability

1. Clear separation between template and examples
2. Consistent placeholder naming scheme
3. Well-documented transformation decisions
4. Future updates don't require re-generalization

### Performance

1. No performance impact on agentops orchestration
2. Template loading time equivalent to original
3. Validation speed unchanged

## Acceptance Criteria

### Pre-Implementation

- [ ] Spec reviewed and approved
- [ ] Tasks.md breakdown complete
- [ ] Implementation order validated
- [ ] Rollback procedure tested

### During Implementation

- [ ] Phase 1 (examples/) complete before main transformation
- [ ] Directory rename executed cleanly
- [ ] All 7 agent files transformed with placeholders
- [ ] All workflow directories renamed and updated
- [ ] Template files include customization headers
- [ ] Root-level references updated

### Post-Implementation

- [ ] Zero `[YOUR_*]` placeholders in examples/ directory
- [ ] ~150 intentional placeholders in main package
- [ ] All cross-references resolve correctly
- [ ] `grep -r "\[YOUR_" examples/` returns 0 matches
- [ ] Examples self-contained and usable
- [ ] CUSTOMIZATION_GUIDE.md complete
- [ ] All validation commands pass

### Validation Commands

```bash
# Placeholder verification
cd profiles/personal-development
grep -r "\[YOUR_" examples/ | wc -l  # Expected: 0
grep -r "\[YOUR_" . --exclude-dir=examples | wc -l  # Expected: ~150

# Cross-reference check
grep -r "Oracle.*Morpheus" . --exclude-dir=examples | wc -l  # Expected: 0
grep -r "Oracle.*Morpheus" examples/ | wc -l  # Expected: ~30

# File structure
ls -R | grep -c "\.md$"  # Expected: 39 total files

# Integration
cd ../..
grep -r "profiles/life" . | wc -l  # Expected: 0
grep -r "personal-development" . | wc -l  # Expected: ~15
```

## Dependencies

### Internal

- agentops core orchestrator (no changes required)
- Multi-flavor coordination system (update examples)
- Root CLAUDE.md and README.md (update references)

### External

- None (self-contained transformation)

## Risks & Mitigations

### High Risk

**Risk:** Breaking cross-references during file transformation
**Mitigation:** Follow exact implementation order, validate after each phase
**Detection:** Validation grep commands will catch
**Recovery:** Git revert to before transformation

### Medium Risk

**Risk:** Incomplete placeholder replacement
**Mitigation:** Systematic find/replace, post-implementation verification
**Detection:** `grep -r "\[YOUR_"` with expected count comparison
**Recovery:** Manual fix of missed placeholders

### Low Risk

**Risk:** Examples directory lacks sufficient context
**Mitigation:** Write complete, self-contained examples
**Detection:** User feedback during validation
**Recovery:** Add missing context to examples

## Timeline

### Phase 1: Foundation (Day 1, 4-6 hours)
- Create examples/ directory (4-6 files)
- Rename directory life → personal-development
- Create CUSTOMIZATION_GUIDE.md

### Phase 2: Core Files (Day 1-2, 4-6 hours)
- Transform README.md, CLAUDE.md, CONSTITUTION.md
- Add customization sections
- Update examples references

### Phase 3: Agents & Workflows (Day 2, 6-8 hours)
- Transform all 7 agent files
- Rename and update 4 workflow directories
- Update 5 template files
- Update 4 command files

### Phase 4: Integration & Validation (Day 2-3, 2-4 hours)
- Update root agentops/ references
- Run validation suite
- Fix any broken references
- Create migration guide (optional)

**Total Estimated Effort:** 2-3 days systematic execution

## Out of Scope

1. Creating new agents or workflows
2. Modifying agentops core functionality
3. Changing other profile packages
4. Adding new features to personal-development
5. Documentation improvements beyond generalization
6. Performance optimizations
7. Refactoring code structure

## Questions & Assumptions

### Assumptions

1. Current life profile is production-ready and validated
2. Users will customize before using (not use templates directly)
3. Examples directory provides sufficient guidance
4. Placeholder system `[YOUR_*]` is intuitive
5. Git history preservation is important

### Open Questions

1. Should we create migration guide for existing life profile users?
   - **Decision:** Add as "could have" if time permits

2. Should examples include multiple framework implementations (GTD, OKRs)?
   - **Decision:** Start with Oracle/Morpheus, add others as community contributions

3. Should CUSTOMIZATION_GUIDE.md include video walkthrough?
   - **Decision:** Text guide sufficient for MVP, video as enhancement

## Success Metrics

### Quantitative

- 0 personal references in main package (excluding examples)
- ~150 intentional placeholders
- 100% cross-references valid
- <30 min customization time
- 0% context collapse during implementation

### Qualitative

- Users can understand and customize without assistance
- Examples provide clear implementation guidance
- Pattern quality and credibility preserved
- Attribution maintains connection to proven use
