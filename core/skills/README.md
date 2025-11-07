# Core Reusable Skills

**Purpose:** Reusable capabilities that agents can invoke

**Two types of skills:**
1. **Script-based** - Fast, deterministic (bash/python scripts)
2. **AI-powered** - Slower, reasoning-based (agent workflows)

---

## Skill Categories

### 1. Pattern Recognition (AI-powered)
**Skill:** pattern-recognition
**Purpose:** Identify code patterns, anti-patterns, opportunities
**Use:** During research phase, code review, refactoring
**Token budget:** 10-15k tokens

**Placeholder:** To be implemented in domain profiles

### 2. Dependency Mapping (Script-based)
**Skill:** dependency-mapping
**Purpose:** Map imports, function calls, component relationships
**Use:** Architecture review, impact analysis, refactoring
**Implementation:** Bash script + grep/awk

**Placeholder:** To be implemented in domain profiles

### 3. Syntax Validator (Script-based)
**Skill:** syntax-validator
**Purpose:** Fast syntax checks (YAML, Go, Python, Shell, JSON)
**Use:** Pre-commit, continuous validation, quick checks
**Implementation:** yamllint, go fmt, flake8, shellcheck, jq

**Placeholder:** To be implemented in domain profiles

### 4. Security Scanner (Script-based)
**Skill:** security-scanner
**Purpose:** Detect vulnerabilities, secrets, security issues
**Use:** Pre-deployment, periodic scans, security audits
**Implementation:** nancy, gitleaks, trivy, safety

**Placeholder:** To be implemented in domain profiles

### 5. Performance Analyzer (Script-based)
**Skill:** performance-analyzer
**Purpose:** Benchmark, profile, identify performance issues
**Use:** Before/after comparisons, regression detection
**Implementation:** go test -bench, ab, pytest-benchmark

**Placeholder:** To be implemented in domain profiles

### 6. Complexity Reducer (AI-powered)
**Skill:** complexity-reducer
**Purpose:** Simplify complex code, suggest refactorings
**Use:** Technical debt reduction, maintainability improvement
**Token budget:** 15-20k tokens

**Placeholder:** To be implemented in domain profiles

### 7. Bundle Compressor (Script-based)
**Skill:** bundle-compressor
**Purpose:** Compress research/plan/implementation to bundles
**Use:** Mid-implementation checkpointing, knowledge sharing
**Implementation:** Python script (5:1 to 38:1 compression)

**Placeholder:** Implemented in /bundle-save command

### 8. Learning Extractor (AI-powered)
**Skill:** learning-extractor
**Purpose:** Extract reusable patterns from work
**Use:** After implementation, retrospectives, pattern mining
**Token budget:** 10-20k tokens

**Placeholder:** Implemented in /learn command

---

## Skill Implementation Guidelines

### Script-Based Skills

**Requirements:**
- Fast execution (<5 seconds)
- Deterministic results
- Exit codes (0=success, non-zero=failure)
- JSON output format (machine-readable)

**Template:**
```bash
#!/bin/bash
# Skill: [name]
# Purpose: [description]

set -e  # Exit on error

# Run validation/analysis
[tool-command] [args]

# Output results as JSON
cat <<EOF
{
  "skill": "[name]",
  "status": "success|failure",
  "results": {
    [skill-specific data]
  }
}
EOF
```

### AI-Powered Skills

**Requirements:**
- Clear reasoning steps
- Token budget specified
- Structured output
- Reusable across domains

**Template:**
```markdown
---
name: [skill-name]
description: [purpose]
model: sonnet|opus
tools: [tool-list]
token_budget: [amount]
---

# [Skill Name]

## Purpose
[What this skill does]

## When to Use
[Scenarios where this skill applies]

## Approach
[How the skill works]

## Output Format
[What the skill returns]
```

---

## Domain Specialization

Profiles extend these core skills with domain-specific implementations:

**DevOps profile adds:**
- kubernetes-validator (script)
- helm-linter (script)
- container-scanner (script)

**Product Dev profile adds:**
- api-contract-validator (script)
- ui-component-analyzer (AI)
- data-model-validator (script)

**Data Eng profile adds:**
- data-quality-checker (script)
- schema-validator (script)
- pipeline-analyzer (AI)

---

## Usage in Agents

**Agents invoke skills:**

```markdown
# In agent definition

## Approach

**Step 1: Validate syntax**
```bash
# Invoke syntax-validator skill
skill: syntax-validator --path ./config/
```

**Step 2: Analyze patterns**
```bash
# Invoke pattern-recognition skill (AI-powered)
skill: pattern-recognition --component ./auth/
```
```

---

## Implementation Priority

**Phase 1 (Current):** Framework scaffolded ✅
**Phase 2 (Next):** Implement script-based skills in domain profiles
**Phase 3 (Future):** Implement AI-powered skills in domain profiles

---

## Notes

- Skills are reusable across all profiles
- Skills should be small, focused, single-purpose
- Skills compose into larger workflows
- Skills can invoke other skills (composability)

---

**Status:** Framework complete, implementations pending domain profiles
