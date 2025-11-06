# agentops Constitution

**The foundational laws that govern all AI agent operations.**

These rules are **always enforced** through git hooks and automation. This is not optional context—this is the operational foundation.

---

## Table of Contents

1. [The Five Laws (MANDATORY)](#the-five-laws-mandatory)
   - [Law 1: ALWAYS Extract Learnings](#law-1-always-extract-learnings)
   - [Law 2: ALWAYS Improve Self or System](#law-2-always-improve-self-or-system)
   - [Law 3: ALWAYS Document Context for Future Agents](#law-3-always-document-context-for-future-agents)
   - [Law 4: ALWAYS Prevent Hook Loops](#law-4-always-prevent-hook-loops)
   - [Law 5: ALWAYS Guide with Workflow Suggestions](#law-5-always-guide-with-workflow-suggestions)
2. [The Three Rules (NEVER FORGET)](#the-three-rules-never-forget)
3. [The 40% Rule (Context Engineering)](#the-40-rule-context-engineering)
4. [The Four Pillars (FOUNDATIONAL)](#the-four-pillars-foundational)
5. [Specs-Driven Development](#specs-driven-development)
6. [Validation Gates](#validation-gates)
7. [Commit Message Format](#commit-message-format)
8. [Enforcement](#enforcement)

---

## The Five Laws (MANDATORY)

### Law 1: ALWAYS Extract Learnings

#### Operational Mandate

Every agent session MUST produce extractable learnings before completion. Sessions without documented learnings are considered incomplete.

**Required Actions:**
- Document patterns discovered during work
- Capture decision rationale (why, not just what)
- Analyze failures to prevent recurrence
- Extract reusable insights for future sessions

#### Enforcement Mechanisms

1. **Pre-commit hook:** Validates learning documentation exists in commit messages
2. **Session template:** Includes learning capture section automatically
3. **CI validation:** Checks learning format compliance
4. **Completion criteria:** Learning extraction required before marking work complete

#### Compliance Checklist

Before completing any agent session, confirm:
- [ ] Patterns identified and documented
- [ ] Decision rationale captured (why choices were made)
- [ ] Failure analysis completed (if applicable)
- [ ] Reusable insights extracted and formatted
- [ ] Learning section present in commit message

#### Practical Examples

**Good Learning:**
```markdown
## Learning: Context Collapse Prevention

**Pattern:** Staying under 40% context capacity prevents collapse
**Evidence:** 0 collapses in 100 sessions under 40%, 8/10 over 60%
**Application:** Load context JIT, not all upfront
**Reusability:** Applies to all multi-phase workflows
```

**Insufficient Learning:**
```markdown
## Learning

We learned some stuff.
```

**Why Insufficient:** No specific pattern, no evidence, no application guidance, not reusable.

#### Failure Remediation

**If learning extraction incomplete:**
1. Review session transcript or work log
2. Identify key decisions made during session
3. Extract patterns used or discovered
4. Document rationale for approach taken
5. Resubmit commit with complete learning section

#### Philosophical Foundation

→ **Theory & Evidence:** [12-factor-agentops/foundations/five-laws.md#law-1](https://github.com/boshu2/12-factor-agentops/blob/main/foundations/five-laws.md#law-1)

---

### Law 2: ALWAYS Improve Self or System

#### Operational Mandate

Every agent session MUST identify at least one improvement opportunity. Stagnation is regression—continuous improvement is mandatory.

**Required Actions:**
- Identify at least one improvement opportunity per session
- Specify impact (time saved, quality improved, risk reduced)
- Propose implementation approach (effort, priority, dependencies)
- Document improvement for future consideration

#### Enforcement Mechanisms

1. **Pre-commit hook:** Validates improvement section exists
2. **Session retrospective:** Improvement identification required
3. **CI validation:** Checks improvement format includes impact
4. **Tracking:** Improvements logged for future prioritization

#### Compliance Checklist

Before completing any agent session, confirm:
- [ ] At least one improvement identified
- [ ] Impact quantified (time, quality, reliability, etc.)
- [ ] Implementation effort estimated (hours, complexity)
- [ ] Priority suggested (critical, high, medium, low)
- [ ] Dependencies or prerequisites noted

#### Practical Examples

**Good Improvement:**
```markdown
## Improvement: Parallel Validation Execution

**Current State:** Validation runs sequentially (30s total)
**Proposed:** Run YAML, security, workflow validation in parallel
**Impact:** 3x faster validation (30s → 10s), faster feedback
**Effort:** 2 hours (modify CI workflow)
**Priority:** High (affects every PR)
**Dependencies:** None
```

**Insufficient Improvement:**
```markdown
## Improvement

Make things faster.
```

**Why Insufficient:** No specificity, no quantified impact, no implementation plan.

#### Failure Remediation

**If improvement identification incomplete:**
1. Review session for pain points or friction
2. Identify what slowed you down or could be better
3. Quantify current state vs. proposed state
4. Estimate implementation effort
5. Resubmit with complete improvement section

#### Philosophical Foundation

→ **Theory & Evidence:** [12-factor-agentops/foundations/five-laws.md#law-2](https://github.com/boshu2/12-factor-agentops/blob/main/foundations/five-laws.md#law-2)

---

### Law 3: ALWAYS Document Context for Future Agents

#### Operational Mandate

Every commit MUST include structured context documentation. Future agents (and future you) need to understand why work was done, not just what changed.

**Required Sections:**
- **Context:** Why this work was needed (problem, requirement, trigger)
- **Solution:** What was created/changed (approach, files, design)
- **Learning:** Reusable patterns discovered (generalizable insights)
- **Impact:** Value delivered, who benefits (metrics, users, systems)

#### Enforcement Mechanisms

1. **Commit template:** Pre-populated with Context/Solution/Learning/Impact sections
2. **Pre-commit hook:** Validates all four sections present
3. **CI validation:** Checks section completeness and format
4. **PR reviews:** Reviewers verify context clarity

#### Compliance Checklist

Before committing, verify your commit message includes:
- [ ] Context section explaining why work was needed
- [ ] Solution section describing what was done
- [ ] Learning section with reusable insights
- [ ] Impact section quantifying value delivered
- [ ] All sections non-empty and substantive

#### Practical Examples

**Good Context Documentation:**
```markdown
feat(validation): add parallel validation execution

Context: Sequential validation takes 30s, slowing PR feedback loop.
Developers wait unnecessarily for simple checks.

Solution: Modified CI workflow to run YAML, security, and workflow
validations in parallel using GitHub Actions matrix strategy.

Learning: Parallel execution pattern reduces feedback time 3x.
Matrix strategy applies to any independent validation tasks.

Impact: PR validation now completes in 10s (3x faster).
Affects all 50+ monthly PRs. Developers get faster feedback.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Insufficient Context Documentation:**
```markdown
feat(validation): make it faster

Made validation faster.
```

**Why Insufficient:** No context for why, no implementation details, no learning, no impact quantification.

#### Failure Remediation

**If context documentation incomplete:**
1. Answer: Why was this work needed? (Context)
2. Answer: What approach did you take? (Solution)
3. Answer: What pattern can others reuse? (Learning)
4. Answer: Who benefits and how much? (Impact)
5. Amend commit with complete documentation

#### Philosophical Foundation

→ **Theory & Evidence:** [12-factor-agentops/foundations/five-laws.md#law-3](https://github.com/boshu2/12-factor-agentops/blob/main/foundations/five-laws.md#law-3)

---

### Law 4: ALWAYS Prevent Hook Loops

#### Operational Mandate

Never commit files that were modified by git hooks. Git hooks maintain institutional memory automatically—interfering creates infinite loops and corrupts history.

**Required Actions:**
- Run post-push check after every push
- Review hook-modified files but don't commit them
- Understand hook modifications are system memory, not your work
- Report hook issues if they're incorrect, don't work around them

**Mandatory Post-Push Check:**
```bash
git push && bash tools/scripts/post-push-law4-check.sh
```

#### Enforcement Mechanisms

1. **Post-push hook:** Detects if hooks modified files after push
2. **Validation script:** `tools/scripts/post-push-law4-check.sh` checks status
3. **Documentation:** Clear guidance on what hooks do and why
4. **Alerts:** Warnings if hook-modified files detected

#### Compliance Checklist

After every `git push`:
- [ ] Run `post-push-law4-check.sh` script
- [ ] Check for hook-modified files (script will report)
- [ ] If files modified, STOP—do not commit them
- [ ] Review modifications to understand what hooks did
- [ ] Report issues if hook behavior seems wrong

#### Practical Examples

**Good Practice:**
```bash
# You push your commit
git push

# Post-push hook modifies metrics.json with session stats
# You run validation
bash tools/scripts/post-push-law4-check.sh

# Output: "Hook modified: metrics.json (institutional memory update)"
# You STOP. Don't commit metrics.json. It's automatic tracking.
```

**Hook Loop (AVOID THIS):**
```bash
# You push commit A
git push

# Hook modifies metrics.json
# You commit metrics.json (DON'T DO THIS!)
git add metrics.json
git commit -m "update metrics"
git push

# Hook modifies metrics.json AGAIN
# Infinite loop starts...
```

#### Failure Remediation

**If you accidentally committed hook-modified files:**
1. STOP immediately—don't push again
2. Reset to before the hook-modified commit: `git reset HEAD~1`
3. Review what the hook changed (it's institutional memory)
4. If hook behavior wrong, file an issue
5. If hook behavior correct, leave files uncommitted

**If hook behavior seems incorrect:**
1. Check hook documentation: `docs/reference/git-hooks.md`
2. Understand hook purpose (metrics, tracking, automation)
3. If truly incorrect, file issue with evidence
4. Never bypass hooks by committing over them

#### Philosophical Foundation

→ **Theory & Evidence:** [12-factor-agentops/foundations/five-laws.md#law-4](https://github.com/boshu2/12-factor-agentops/blob/main/foundations/five-laws.md#law-4)

---

### Law 5: ALWAYS Guide with Workflow Suggestions

#### Operational Mandate

After loading context, agents MUST suggest relevant workflows rather than prescribing a single path. Users choose their workflow—agents guide discovery.

**Required Actions:**
- Suggest 5-6 relevant workflows based on user's stated goal
- Provide brief description of each workflow's purpose
- Let user select their preferred approach
- Never prescribe "you must use workflow X"
- Enable exploration and learning

#### Enforcement Mechanisms

1. **Agent templates:** Include workflow suggestion section
2. **Context-loading agents:** Programmed to suggest, not prescribe
3. **User feedback:** Track if users feel guided vs. forced
4. **Documentation:** Examples of good vs. bad guidance

#### Compliance Checklist

When user requests help, verify you:
- [ ] Loaded relevant context for their goal
- [ ] Identified 5-6 potentially helpful workflows
- [ ] Described each workflow briefly (purpose, when to use)
- [ ] Asked user to choose rather than choosing for them
- [ ] Provided links to workflow documentation

#### Practical Examples

**Good Guidance:**
```markdown
Based on your goal to "plan a new product feature," here are relevant workflows:

1. **/plan-product** (multi-agent) - Deep research, parallel planning, comprehensive specs
   - Best for: Complex features requiring thorough research
   - Time: 30-60 minutes
   - Output: Full product spec with research context

2. **/shape-spec** (single-agent) - Quick spec shaping from rough ideas
   - Best for: Simple features, fast iteration
   - Time: 10-15 minutes
   - Output: Lightweight spec for immediate implementation

3. **/research-first** - Research-only phase, plan separately
   - Best for: Uncertain problem space, need understanding first
   - Time: 15-30 minutes
   - Output: Research bundle for later planning

4. **/write-spec** - Write spec directly (if you know exactly what you want)
   - Best for: Well-understood features, clear requirements
   - Time: 5-10 minutes
   - Output: Implementation-ready spec

Which approach fits your needs? Or would you like to explore these further?
```

**Prescriptive (AVOID THIS):**
```markdown
You should use /plan-product for this. It's the best workflow.
```

**Why Wrong:** Doesn't explain alternatives, doesn't let user choose, assumes one-size-fits-all.

#### Failure Remediation

**If you prescribed instead of guided:**
1. Acknowledge the prescription
2. Offer alternative workflows
3. Explain trade-offs of each approach
4. Ask user to choose based on their context
5. Document user's choice and rationale (learning!)

#### Philosophical Foundation

→ **Theory & Evidence:** [12-factor-agentops/foundations/five-laws.md#law-5](https://github.com/boshu2/12-factor-agentops/blob/main/foundations/five-laws.md#law-5)

---

## The Three Rules (NEVER FORGET)

1. ❌ **NEVER modify read-only upstream** - Preserve immutable references
2. ✅ **ALWAYS edit source of truth, not generated** - Config patterns matter
3. ✅ **ALWAYS use semantic commits** - `<type>(<scope>): <subject>`

---

## The 40% Rule (Context Engineering)

Stay under 40% of token budget per phase to prevent context collapse.

- 🟢 <35%: GREEN - continue
- ⚡ 35-40%: YELLOW - prepare to transition
- ⚠️ 40-60%: RED - transition NOW
- 🔴 >60%: CRITICAL - reset immediately

**Pattern:** Gather → Glean → Summarize (JIT loading, not upfront)

---

## The Four Pillars (FOUNDATIONAL)

1. **DevOps Principles** - Apply infrastructure practices to agents
2. **Learning Science** - Research→Plan→Implement based on cognitive science
3. **Context Engineering** - Stay under 40% token budget, prevent collapse
4. **Institutional Memory** - Git captures decision context and learnings

---

## Specs-Driven Development

The heart of agentops is specification-driven workflow:

```
RESEARCH (understand the problem)
  ↓
PLAN (write detailed specifications)
  ↓
IMPLEMENT (follow spec precisely)
```

**Why:** Specs force thinking before execution. Prevents ambiguity, token waste, and iteration.

This pattern works across ALL domains:
- **DevOps:** Infrastructure specs, deployment specs
- **Product:** Feature specs, API specs, UI specs
- **SRE:** Runbook specs, verification specs
- **Security:** Compliance specs, audit specs

---

## Validation Gates

### Gate 1: Pre-Commit
Validate syntax and quality before commit.

### Gate 2: Human Review
Review PLAN before executing, not code after.

### Gate 3: CI/CD
Automated validation in your pipeline.

### Gate 4: Deployment
Deploy to environment with safety checks.

---

## Commit Message Format

```
<type>(<scope>): <subject>

Context: [Why was this needed?]
Solution: [What was done?]
Learning: [What pattern was applied?]
Impact: [What value is delivered?]

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:** feat, fix, docs, refactor, test, chore
**Scopes:** apps, config, docs, agents, monitoring

---

## Enforcement

### This Constitution is Always Enforced

You don't "load" it. You operate under it.

Every agent, every workflow, every system enforces these laws automatically through:

#### Automated Enforcement

1. **Git Hooks**
   - Pre-commit: Validates learning/improvement/context documentation
   - Post-push: Checks for hook-modified files (Law 4)
   - Commit template: Pre-populates required sections

2. **CI/CD Pipeline**
   - Learning format validation
   - Improvement section validation
   - Context documentation completeness checks
   - Link validation (cross-references work)

3. **Agent Templates**
   - Include compliance checklists
   - Enforce workflow suggestion patterns
   - Require structured outputs

#### Manual Enforcement

1. **PR Reviews**
   - Reviewers verify context clarity
   - Check learning extraction quality
   - Validate improvement proposals
   - Ensure compliance with all Five Laws

2. **Session Retrospectives**
   - Review learning extraction
   - Identify improvement opportunities
   - Document context for future
   - Verify workflow guidance quality

#### Compliance Tracking

Track compliance through:
- Commit message analysis (automated)
- Session completion audits (periodic)
- User feedback (ongoing)
- Improvement implementation rate (monthly)

#### Non-Compliance Remediation

**If a session/commit doesn't comply:**
1. Automated checks flag the issue
2. Remediation steps provided (see each law's section)
3. Resubmission required with fixes
4. Patterns documented to prevent recurrence

**Philosophy:** Enforcement isn't punishment—it's institutional memory formation.
