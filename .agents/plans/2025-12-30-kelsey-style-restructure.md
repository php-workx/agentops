---
date: 2025-12-30
type: Plan
goal: "Transform agentops into Kelsey Hightower-style educational marketplace"
tags: [plan, education, restructure, kelsey-hightower]
epic: "agentops-3eo"
status: ACTIVE
---

# Plan: Kelsey-Style Educational Restructure

## Overview

Transform agentops from conceptual framework documentation (516-line commands with 80% PDC/FAAFO content) to hands-on progressive learning experience (50-line commands that run, with framework content as reference). Follow Kelsey Hightower's "The Hard Way" approach: step-by-step, visible output, progressive complexity.

## Research Reference

`.agents/research/2025-12-30-kelsey-style-restructure.md`

## Features (Dependency Order)

| ID | Feature | Priority | Depends On | Status |
|----|---------|----------|------------|--------|
| agentops-3eo | Epic: Kelsey-style educational restructure | P1 | - | open |
| agentops-1ca | Create levels/ directory structure and README | P1 | agentops-3eo | open |
| agentops-05o | Create L1-basics/research.md (~50 lines) | P1 | agentops-1ca | open |
| agentops-co9 | Create L1-basics/implement.md (~50 lines) | P1 | agentops-1ca | open |
| agentops-eaw | Create reference/pdc-framework.md | P2 | agentops-3eo | open |
| agentops-bo0 | Create reference/faafo-alignment.md | P2 | agentops-3eo | open |
| agentops-j9e | Create reference/failure-patterns.md | P2 | agentops-3eo | open |
| agentops-9aj | Create L1-basics/demo/ with real transcripts | P2 | agentops-05o, agentops-co9 | open |
| agentops-3i7 | Create L2-persistence level | P2 | agentops-9aj | open |
| agentops-of5 | Create L3-state-management level | P3 | agentops-3i7 | open |
| agentops-5vl | Create L4-parallelization level | P3 | agentops-of5 | open |
| agentops-rix | Create L5-orchestration level | P4 | agentops-5vl | open |

## Dependency Graph

```
agentops-3eo (Epic)
├── agentops-1ca (Structure)
│   ├── agentops-05o (L1 research.md)
│   │   └── agentops-9aj (L1 demos) ─┐
│   └── agentops-co9 (L1 implement.md) ─┘
│           └── agentops-3i7 (L2)
│               └── agentops-of5 (L3)
│                   └── agentops-5vl (L4)
│                       └── agentops-rix (L5)
├── agentops-eaw (PDC reference)
├── agentops-bo0 (FAAFO reference)
└── agentops-j9e (Failure patterns reference)
```

## Wave Execution Order

| Wave | Features | Can Parallel | Notes |
|------|----------|--------------|-------|
| 1 | agentops-3eo (Epic) | No | Must close to unblock all |
| 2 | agentops-1ca, agentops-eaw, agentops-bo0, agentops-j9e | Yes | Different directories |
| 3 | agentops-05o, agentops-co9 | Yes | Different files in L1-basics |
| 4 | agentops-9aj | No | Depends on both L1 commands |
| 5 | agentops-3i7 | No | L2 depends on L1 demo |
| 6 | agentops-of5 | No | L3 depends on L2 |
| 7 | agentops-5vl | No | L4 depends on L3 |
| 8 | agentops-rix | No | L5 depends on L4 |

## Implementation Notes

### L1-basics Pattern (50 lines max)

```markdown
---
description: [One line]
---

# /command-name

[2-3 sentences: what it does, when to use it]

---

## Usage

/command-name "your input"

---

## Steps

1. [Step with command]
2. [Step with command]
3. [Step with command]

---

## Output

[Where output goes, what it looks like]

---

## Example

[Real example with real output]

---

## Next

[What command to run next]
```

### Reference docs pattern

Extract from existing commands:
- `commands/implement.md` → `reference/pdc-framework.md` (PDC sections)
- `commands/research.md` → `reference/faafo-alignment.md` (FAAFO sections)
- `commands/retro.md` → `reference/failure-patterns.md` (12 patterns)

### Demo transcripts pattern

```markdown
# Demo: /research on a real codebase

## Before
- Fresh session
- No .agents/ directory

## Session

$ /research "how authentication works"

[Full transcript of what Claude outputs]

## After
- .agents/research/YYYY-MM-DD-auth.md created
- [Show file contents]

## What You Learned
- [Key takeaway 1]
- [Key takeaway 2]
```

## Risks

| Risk | Mitigation |
|------|------------|
| L1 too simple | Gateway to L2-L5; simple is the point |
| Breaks existing users | Additive - keep commands/, add levels/ |
| Demo transcripts stale | Date them, update quarterly |

## Next Steps

1. Close epic agentops-3eo to unblock Wave 2
2. Run `bd ready` to see unblocked issues
3. Implement in wave order, parallelizing where possible
4. Use `/implement` for each issue
