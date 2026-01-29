# Forge-Temper-Store Knowledge Flywheel

**Date:** 2026-01-26
**Status:** TEMPERED
**Task:** #16 - Design TEMPER & STORE flywheel with ao-cli integration

## Overview

The Knowledge Flywheel ensures learnings from each development cycle compound for future work. Following the forge metaphor: raw ore (transcripts, artifacts) → metal (extracted insights) → hardened steel (validated, indexed knowledge).

---

## The Three Phases

```
┌─────────────────────────────────────────────────────────────────────┐
│                     KNOWLEDGE FLYWHEEL                               │
│                                                                      │
│   ┌──────────┐         ┌──────────┐         ┌──────────┐           │
│   │  FORGE   │────────►│  TEMPER  │────────►│  STORE   │           │
│   │          │         │          │         │          │           │
│   │ Extract  │         │ Validate │         │  Index   │           │
│   │ raw ore  │         │ & harden │         │ & serve  │           │
│   └──────────┘         └──────────┘         └──────────┘           │
│        │                    │                    │                  │
│        │                    │                    │                  │
│        ▼                    ▼                    ▼                  │
│   ao forge             Gate 4              ao pool add              │
│   transcript           TEMPER?             ao ratchet lock          │
│                        decision                                     │
│                                                                      │
│                              │                                       │
│                              ▼                                       │
│                    ┌──────────────────┐                             │
│                    │ Future /research │                             │
│                    │ finds this gold  │                             │
│                    └──────────────────┘                             │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: FORGE

**Command:** `ao forge transcript`

**What happens:**
1. Parse Claude session transcript
2. Extract decisions, learnings, patterns, anti-patterns
3. Write raw artifacts to `.agents/pool/pending/`
4. Tag with source session ID for provenance

**Output artifacts:**
```
.agents/pool/pending/
├── decisions/
│   └── YYYY-MM-DD-<topic>.md
├── learnings/
│   └── YYYY-MM-DD-<topic>.md
├── patterns/
│   └── YYYY-MM-DD-<topic>.md
└── anti-patterns/
    └── YYYY-MM-DD-<topic>.md
```

**Trigger:** End of /implement or /crank

---

## Phase 2: TEMPER

**Command:** Gate 4 decision in /post-mortem

**What happens:**
1. Human reviews post-mortem report
2. Decides: "Is this output good enough?"
3. If YES → TEMPER (validate, harden, promote)
4. If NO → ITERATE (back to forge for refinement)

**TEMPER process:**
```bash
# Validate artifact structure
ao validate .agents/pool/pending/*.md

# Run quality checks
ao vibe .agents/pool/pending/*.md --quick

# Promote to validated pool
mv .agents/pool/pending/*.md .agents/pool/validated/

# Lock with ratchet (prevents regression)
ao ratchet lock .agents/pool/validated/YYYY-MM-DD-*.md
```

**Locked artifacts cannot be modified** - only supplemented with new learnings.

---

## Phase 3: STORE

**Command:** `ao pool add` + `ao ratchet lock`

**What happens:**
1. Index validated artifacts for semantic search
2. Add to CASS memory (if configured)
3. Make discoverable by future /research

**Storage locations:**
```
.agents/
├── learnings/      # TEMPERED learnings (locked)
├── patterns/       # TEMPERED patterns (locked)
├── decisions/      # TEMPERED decisions (locked)
├── pool/
│   ├── pending/    # FORGED but not yet TEMPERED
│   └── validated/  # TEMPERED and locked
└── index/          # Semantic search index (auto-generated)
```

**Discovery:**
```bash
# Future /research calls this automatically
ao inject <topic>

# Returns relevant TEMPERED artifacts
```

---

## ao-cli Commands

| Command | Phase | Description |
|---------|-------|-------------|
| `ao forge transcript` | FORGE | Extract knowledge from session |
| `ao pool add <files>` | STORE | Add files to knowledge pool |
| `ao pool search <query>` | DISCOVER | Semantic search for knowledge |
| `ao ratchet lock <files>` | TEMPER | Lock files as validated |
| `ao ratchet status` | CHECK | Show locked vs pending |
| `ao inject <topic>` | DISCOVER | Inject relevant knowledge into context |
| `ao validate <files>` | TEMPER | Check artifact structure |

---

## Integration Points

### /research (Discovery)
```markdown
### Step 2: Check Prior Art

**First, inject existing knowledge (if ao available):**
```bash
ao inject <topic> 2>/dev/null
```
```

### /post-mortem (Gate 4)
```markdown
### Step 5: Request Human Approval (Gate 4)

**If TEMPER & STORE:**
```bash
ao forge transcript
ao pool add .agents/*.md
ao ratchet lock .agents/retros/YYYY-MM-DD-*.md
```

**If ITERATE:** Back to forge for another round.
```

### /retro (Extraction)
```markdown
### Step 4: Extract Learnings

```bash
ao forge extract --type learnings
```
```

---

## CASS Integration (Optional)

If CASS memory is configured:

```bash
# Store learning in persistent memory
ao cass store --type fact --content "<learning>" --confidence 0.8

# Recall relevant memories
ao cass recall --query "<topic>" --limit 10
```

This enables cross-session memory persistence.

---

## Flywheel Compounding

```
Loop 1: Research → Plan → Crank → Post-mortem → TEMPER
                                                   │
                                                   ▼
                                         .agents/learnings/
                                         (indexed, locked)
                                                   │
Loop 2: Research ◄─────────────────────────────────┘
        (ao inject finds Loop 1's gold)
        → Plan (better informed)
        → Crank → Post-mortem → TEMPER
                                  │
Loop 3: Research ◄────────────────┘
        (finds Loop 1 + Loop 2's gold)
        → Even better...
```

**Each successful loop makes future loops faster and higher quality.**

---

## Metrics

Track flywheel health:

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Learnings per week | 5+ | 2-4 | <2 |
| TEMPER rate | >80% | 50-80% | <50% |
| Injection hit rate | >70% | 40-70% | <40% |
| Pool staleness | <30 days | 30-60 days | >60 days |

```bash
ao flywheel status  # Show all metrics
```

---

## Related

- Pattern: `.agents/patterns/rpi-4-gates-flywheel.md`
- Conflict Resolution: `.agents/specs/conflict-resolution-algorithm.md`
- Brownian Ratchet: `BROWNIAN-RATCHET.md` (chaos → filter → lock)
