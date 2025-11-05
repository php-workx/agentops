# AgentOps Launch Content (Nov 11 - Dec 1, 2025)

**Purpose:** Working space for Dec 1 dual launch preparation
**Timeline:** Nov 11 (today) → Dec 1 (public launch)
**Status:** Alpha - Experimental, will be sanitized before public

---

## Directory Structure

### `/launch/case-studies/`
Multi-domain validation case studies showing universality of 4 patterns.

**Examples:**
- `product-development-validation.md` - 40x speedup proof
- `infrastructure-devops-validation.md` - 3x speedup proof
- `sre-incident-response.md` - TBD
- `data-engineering.md` - TBD

**Before Dec 1:** Move finalized case studies to `/docs/case-studies/`

### `/launch/profiles/`
Domain-specific profile templates for community extension.

**Examples:**
- `sre-profile-template.md` - SRE operations
- `data-eng-profile-template.md` - Data engineering
- `custom-profile-guide.md` - How others create profiles

**Before Dec 1:** Move finalized profiles to `/profiles/[domain]/`

### `/launch/guides/`
Contributor and user guides specific to launch.

**Examples:**
- `CONTRIBUTING.md` - How to contribute
- `ADOPTER_GUIDE.md` - How to use AgentOps
- `VALIDATION_GUIDE.md` - How to validate in your domain

**Before Dec 1:** Move to appropriate locations (root or `/docs/how-to/`)

### `/launch/examples/`
Working code examples, templates, and proof-of-concept implementations.

**Examples:**
- `spec-driven-workflow.example.md` - Multi-phase workflow example
- `context-bundle-compression.example.md` - How bundles work
- `multi-agent-orchestration.example.sh` - Agent coordination example

**Before Dec 1:** Move to `/docs/explanation/` or `/architecture/`

---

## Workflow During Launch Prep

### Nov 11-15: Content Drafting
- Write case studies (2 complete, 2 pending)
- Draft profile templates
- Create contributor guides
- Build working examples

**Store in:** `/launch/[subdirectory]/`

### Nov 16-22: Refinement & Validation
- Edit for clarity and accuracy
- Validate examples work
- Get feedback from testers
- Prepare for publication

**Store in:** Still `/launch/[subdirectory]/`

### Nov 23-28: Sanitization & Migration
- Final reviews
- Remove internal references
- Move to permanent locations
- Prepare for public release

**Move to:** `/docs/case-studies/`, `/profiles/`, etc.

### Dec 1: Public Launch
- All `/launch/` content moved to public directories
- Repository clean for public sharing
- Case studies and guides published

---

## Important Notes

⚠️ **This is a working space:**
- Content may be incomplete or experimental
- Internal references are OK here (will be cleaned)
- Iteration encouraged
- Before Dec 1, everything gets sanitized

✅ **Before moving to public:**
1. Remove internal implementation details
2. Remove proprietary AgentOps (gitops) references
3. Sanitize any company-specific content
4. Verify examples still work
5. Get final approval

---

## How to Use This Space

**Adding a case study:**
```
1. Create /launch/case-studies/[domain]-validation.md
2. Document: Problem → Approach → Results → Learnings
3. Include metrics and proof
4. Before Dec 1: Review and move to /docs/case-studies/
```

**Creating a profile template:**
```
1. Create /launch/profiles/[domain]-template.md
2. Follow existing profile structure
3. Include agents, workflows, examples
4. Before Dec 1: Move to /profiles/[domain]/
```

**Writing a guide:**
```
1. Create /launch/guides/[TOPIC_GUIDE].md
2. Follow Diataxis format (how-to, explanation, etc.)
3. Test with real use case
4. Before Dec 1: Move to /docs/how-to/ or root
```

---

## Cleanup Checklist (Nov 28)

Before moving to public, verify:

- [ ] No gitops/ internal references
- [ ] No company-specific details
- [ ] No credentials or secrets
- [ ] All examples tested and working
- [ ] Case studies have metrics/proof
- [ ] Profiles follow template structure
- [ ] Guides are clear and actionable
- [ ] Links are correct (no broken refs)

---

## Timeline for This Directory

| Date | Action | Owner |
|------|--------|-------|
| Nov 11-15 | Draft content | You + Claude |
| Nov 16-22 | Refine + validate | You + testers |
| Nov 23-28 | Sanitize + approve | You |
| Nov 29-30 | Final migration | You |
| Dec 1 | LAUNCH (clean repo) | You |

After Dec 1, `/launch/` directory is removed (content moved to permanent locations).

---

**Status:** Nov 5, 2025 - Ready for content
**Next:** Add case studies, profiles, and guides to respective subdirectories
