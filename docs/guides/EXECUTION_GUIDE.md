# Execution Guide: PRIORITY 1-3 Roadmap (Nov 11 - Dec 1, 2025)

**Purpose:** Map where work lives, how it flows, and what matters most
**Timeline:** 20 days to dual launch
**Status:** Ready to execute

---

## The Three Priorities & Where Work Lives

### PRIORITY 1: Content Rewrites (Nov 11-17, 7 hours)
**What:** Rewrite all promotional content for problem-first positioning

| Item | Count | Location | Status |
|------|-------|----------|--------|
| LinkedIn posts | 10 | `life/agentops-promotion/` (git-tracked) | ❌ 0% |
| Case studies | 4 | `life/agentops-promotion/` | ❌ 0% |
| Tech articles | 5 | `life/agentops-promotion/` | ❌ 0% |
| Engagement templates | 53 | `life/agentops-promotion/` | ❌ 0% |
| Audit gitops/ | - | Reference only (read, don't edit) | ⏳ |
| Audit life/ | - | Reference only (read, don't edit) | ⏳ |

**Source of Truth:** `life/agentops-promotion/`
- All finished content lives here
- Git-tracked for versioning
- This is what gets published Dec 1

**Reference Only:** `agentops/`
- You can store drafts/notes in `launch/examples/` if needed
- But final work must be in `life/agentops-promotion/`

**Language to Use:**
- "I'm testing this framework" (NOT "proven")
- "Alpha" + "validating" (NOT "production-ready")
- Show what didn't work (failure modes matter)
- Problem-first (problem → hypothesis → explorer → invitation)

---

### PRIORITY 2: Website Project (Nov 11-28, 40 hours with agents)
**What:** Build personal portfolio + agentops hub using agentops methodology as live case study

#### Phase 1: Research & Planning (Done ✅)
**Location:** `life/agentops-promotion/`
- `WEBSITE_RESEARCH.md` - Market validation, tech stack, success criteria
- `WEBSITE_PLAN.md` - Phase 3 timeline, component architecture, deployment
- `WEBSITE_IMPLEMENTATION_AGENTOPS.md` - Agent workflow for spec-driven build

#### Phase 2: Agent-Driven Specification (Nov 11-12, 5-8 hours)
**Run these agents in sequence:**
1. `/plan-product` → generates product specs
2. `/shape-spec` → creates detailed specification
3. `/write-spec` → writes implementable spec
4. `/create-tasks` → breaks into implementation tasks

**Where Output Goes:**
- Store in `agentops/launch/examples/` (working space) OR new `website/` repo
- These are specifications, not final code

#### Phase 3: Implementation (Nov 15-28, 20-25 hours)
**Run this agent:**
- `/implement-tasks` → builds all features

**Where Final Code Goes:**
- **NEW REPOSITORY:** `website/` (create when ready)
- NOT in agentops/ (that's the framework, not the product)
- Git history documents entire build process
- Commits = case study material

**Case Study Documentation (Automatic):**
- Daily commits document decisions
- Screenshots show evolution
- Blog posts written from notes taken during build
- Result: Full case study by Dec 1 for publishing

---

### PRIORITY 3: Pre-Launch Verification (Nov 25-28, 5 hours)
**What:** Final go/no-go checklist before Dec 1

**Location:** `agentops/launch/README.md` (Cleanup Checklist section)

| Category | Pass % | Target | Status |
|----------|--------|--------|--------|
| Content Integrity | 0% | 100% | ⏳ IN PROGRESS |
| Repository Readiness | 90% | 100% | 🟢 NEAR COMPLETE |
| Community Readiness | 0% | 80%+ | ⏳ RECRUITMENT PHASE |
| Personal Readiness | 95% | 100% | 🟢 READY |

**Decision Gate:** Nov 28 EOD (all four must pass)

---

## The Repository Ecosystem

### `life/agentops-promotion/` (SOURCE OF TRUTH)
**Your content hub - everything public-facing**

```
life/agentops-promotion/
├── STRATEGY.md                          (why we exist)
├── CONTENT_CALENDAR.md                  (editorial calendar)
├── EARLY_TESTER_OUTREACH.md            (recruitment strategy)
├── EARLY_TESTER_GUIDE.md               (what beta means)
├── LAUNCH_CHECKLIST.md                 (go/no-go gates)
│
├── WEBSITE_RESEARCH.md                 (market validation)
├── WEBSITE_PLAN.md                     (implementation plan)
├── WEBSITE_IMPLEMENTATION_AGENTOPS.md  (agent workflow)
│
└── [PRIORITY 1 CONTENT]
    ├── 10-linkedin-posts.md            (final versions)
    ├── 4-case-studies.md               (finalized)
    ├── 5-tech-articles.md              (polished)
    └── 53-engagement-templates.md      (done)
```

**Git-tracked:** Yes (all changes versioned)
**For:** Final, finished content only
**Publish From:** This directory (everything here goes public Dec 1)

### `agentops/` (WORKING SPACE & FRAMEWORK)
**Framework development + optional drafting**

```
agentops/
├── Core Framework                      (public-ready structure)
├── claude.md                           (kernel for contributors)
├── STRATEGY.md                         (mission context)
│
└── /launch/                            (experimental working space)
    ├── case-studies/                   (optional drafts)
    ├── examples/                       (optional working notes)
    ├── profiles/                       (optional templates)
    └── guides/                         (optional drafts)
```

**Git-tracked:** Yes (but /launch/ removed before Dec 1)
**For:** Reference, optional working space, framework improvements
**Publish From:** NO - everything in /launch/ is removed before public release

### `website/` (NEW REPO - CREATE WHEN READY)
**Personal website repository**

```
website/
├── src/
│   ├── components/
│   ├── pages/
│   └── styles/
├── content/
│   ├── blog/
│   └── projects/
├── .github/
│   └── workflows/                      (CI/CD for deployment)
└── package.json
```

**Git-tracked:** Yes (full implementation history)
**For:** Working code, deployment, CI/CD
**Publish From:** Yes - deploy from main branch to Vercel (Dec 1)
**Case Study:** Full git history becomes blog material

---

## Critical Path (If Time Gets Tight)

**If you can only do one thing per priority, do this:**

### PRIORITY 1: CRITICAL
✅ **10 LinkedIn posts** (problem-first positioning)
- These drive all traffic to framework
- Must be rewritten before Dec 1
- Everything else can be rough, posts must be polished

❌ Case studies, articles, templates (nice to have, can iterate post-launch)

### PRIORITY 2: CRITICAL
✅ **Website MVP** (minimum viable product)
- Home page (hero + intro + CTAs)
- About page (who you are, philosophy)
- Portfolio (3-5 key projects + agentops)
- Blog infrastructure (MDX parsing, CSS)
- Deploy to Vercel with GitHub Actions

❌ Newsletter signup, analytics, fancy features (post-launch iterations)

### PRIORITY 3: CRITICAL
✅ **Final go/no-go decision** (Nov 28 EOD)
- Content: 100% (posts + core docs)
- Repos: Ready to push (agentops + website)
- Community: 3-5 beta collaborators confirmed
- Personal: Committed to 1-2 posts/week

---

## File Flow Map

```
┌─────────────────────────────────────────────────────────────┐
│ PRIORITY 1: Content Rewrites (Nov 11-17)                    │
│                                                              │
│ Work in: life/agentops-promotion/                           │
│          10 posts, 4 studies, 5 articles, 53 templates      │
│          Store here = Git-tracked source of truth           │
│                                                              │
│ Output: Finished content ready for Dec 1 publication        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ PRIORITY 2: Website Build (Nov 11-28)                       │
│                                                              │
│ Research: life/agentops-promotion/ (WEBSITE_*.md files)    │
│ Plans: Generated by /plan-product, /shape-spec agents       │
│ Build: NEW website/ repo (create Dec 1 ready)               │
│        Github Actions auto-deploys to Vercel                │
│                                                              │
│ Output: Live website + full case study documentation        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ PRIORITY 3: Launch Verification (Nov 25-28)                 │
│                                                              │
│ Checklist: agentops/launch/README.md                        │
│ Decision: All 4 categories pass = GO on Nov 28 EOD          │
│           Any fail = HOLD to Dec 8                          │
│                                                              │
│ Output: Decision to proceed or delay                        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ DEC 1, 9 AM: DUAL LAUNCH 🚀                                 │
│                                                              │
│ 1. Push agentops/ (Alpha reference impl) to public          │
│ 2. Move 12-factor-agentops/ to Beta                         │
│ 3. Deploy website/ to Vercel (live site)                    │
│ 4. Publish POST 1 (dual launch announcement)                │
│ 5. Begin beta collaborator support                          │
└─────────────────────────────────────────────────────────────┘
```

---

## Day-by-Day Example (PRIORITY 1 Week)

**Nov 11 (TODAY):** Content kickoff
- [ ] Rewrite post 1-3 (LinkedIn problem-first)
- [ ] Update case study 1 (experimental language)
- [ ] Store in `life/agentops-promotion/`
- [ ] Commit: `feat(content): Rewrite posts 1-3, update case study 1`

**Nov 12:** Keep momentum
- [ ] Rewrite post 4-6
- [ ] Update case study 2-3
- [ ] Rewrite article 1-2
- [ ] Commit: `feat(content): Rewrite posts 4-6, add articles 1-2`

**Nov 13-14:** Finish content
- [ ] Rewrite post 7-10
- [ ] Update case study 4 + articles 3-5
- [ ] Update 53 engagement templates
- [ ] Commit: `feat(content): Complete all content rewrites (posts + studies + articles + templates)`

**Nov 15:** Final review
- [ ] Read all content (posture check)
- [ ] Fix language inconsistencies
- [ ] Ensure problem-first throughout
- [ ] Commit: `refactor(content): Polish language and consistency`

**Nov 16-17:** Audit
- [ ] Audit gitops/ for reference (no changes)
- [ ] Audit life/ for timeline alignment
- [ ] Note improvements for later
- [ ] Final PRIORITY 1 status: 100% ✅

---

## What "Done" Means

### PRIORITY 1 Done
- All 10 posts rewritten and stored in `life/agentops-promotion/`
- All 4 case studies updated with experimental framing
- All 5 articles rewritten with agentops focus
- All 53 templates updated with "I'm testing" language
- Everything git-committed and ready to publish

### PRIORITY 2 Done
- Website live at custom domain (Vercel deployed)
- Homepage, About, Portfolio, Blog all functional
- Mobile responsive + Lighthouse >90 score
- CI/CD auto-deploys on push
- Case study documented (daily notes + git history)

### PRIORITY 3 Done
- Go/no-go checklist filled (all 4 categories pass)
- Decision made (GO or HOLD)
- If GO: Team ready to launch at 9 AM Dec 1

---

## Tools You'll Use

| Priority | Tool | What For |
|----------|------|----------|
| 1 | Text editor | Rewrite posts, articles, case studies |
| 1 | Git | Commit content changes |
| 2 | `/plan-product` agent | Generate product specs |
| 2 | `/shape-spec` agent | Create detailed specification |
| 2 | `/write-spec` agent | Write implementable spec |
| 2 | `/create-tasks` agent | Break into tasks |
| 2 | `/implement-tasks` agent | Build website |
| 2 | Next.js/TypeScript | Development framework |
| 2 | Vercel | Deploy & host |
| 3 | Checklist (launch/README.md) | Verify readiness |

---

## Questions Answered by This Guide

**"I'm doing PRIORITY 1 - where do I actually write the 10 posts?"**
→ `life/agentops-promotion/` (source of truth, git-tracked)

**"I'm doing PRIORITY 2 - where are the research/plans and where does the final website code go?"**
→ Research/plans: `life/agentops-promotion/WEBSITE_*.md`
→ Website code: NEW `website/` repo (you create it)

**"I'm running low on time - what's the critical path?"**
→ See "Critical Path" section above (posts are #1, website MVP is #2, checklist is #3)

**"Where does agentops/ fit in all this?"**
→ It's the framework + working space. Not the public launch content or website code.
→ It gets sanitized and launched separately on Dec 1 as Alpha reference implementation.

**"What if I need to store drafts?"**
→ PRIORITY 1: Everything goes to `life/agentops-promotion/` (source of truth)
→ PRIORITY 2: Specifications in `agentops/launch/examples/` (optional), final code in `website/`

**"How do I know when I'm done?"**
→ See "What 'Done' Means" section above for each priority.

---

## Quick Checklist

**Before Starting:**
- [ ] Read this guide (5 min)
- [ ] Confirm locations (life/agentops-promotion/ = content hub)
- [ ] Confirm priorities (posts > website > verification)
- [ ] Confirm date (Nov 28 decision gate, Dec 1 launch)

**Starting PRIORITY 1:**
- [ ] Open `life/agentops-promotion/`
- [ ] Create/open files for 10 posts
- [ ] Rewrite post 1 (problem-first, "I'm testing")
- [ ] Commit to git
- [ ] Continue posts 2-10

**Success Looks Like (Dec 1, 9 AM):**
- ✅ 10 LinkedIn posts live (driving traffic)
- ✅ Website live (portfolio + case study)
- ✅ agentops/ (Alpha) + 12-factor (Beta) both public
- ✅ 3-5 beta collaborators confirmed
- ✅ Community engaged

---

**Status:** Ready to execute
**Next Step:** Start PRIORITY 1 (content rewrites)
**Time Budget:** 20 days, 52 hours total (7+40+5)
**Success Rate:** Achievable with focus and execution

Go build it. 🚀

---

*Last Updated: Nov 5, 2025*
*Version: Execution Guide v1.0*
