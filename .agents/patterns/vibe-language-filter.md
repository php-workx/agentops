---
type: pattern
source: na-xjw post-mortem
date: 2026-03-05
confidence: high
maturity: provisional
tags: [vibe, complexity, performance]
---

# Vibe Language Filter Pattern

Skip language-specific complexity analysis when the changed files don't include that language.

## Problem

In na-xjw (a docs/shell/BATS epic), vibe ran `gocyclo` on the entire `cli/` tree. gocyclo hung, wasting time on irrelevant analysis.

## Solution

Before running complexity tools, check the diff for relevant file types:

```bash
# Only run gocyclo if Go files were changed
if git diff --name-only HEAD~3 | grep -q '\.go$'; then
    gocyclo -over 10 <path> 2>/dev/null | head -30
else
    echo "COMPLEXITY SKIPPED: No Go files in recent changes"
fi
```

Apply the same pattern for radon (Python), eslint (TypeScript), etc.

## When to Apply

- Always during /vibe when target is "recent"
- Skip when target is an explicit directory (user wants full analysis)
