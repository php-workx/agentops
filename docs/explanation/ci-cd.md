# CI/CD Pipeline

**Status:** Active
**Platform:** GitHub Actions
**Configuration:** `.github/workflows/`

## Overview

The agentops repository uses GitHub Actions for continuous integration and validation. All workflows run automatically on push and pull requests.

## Workflows

### 1. Validate (`validate.yml`)

**Purpose:** Ensure documentation quality and repository structure

**Jobs:**
- **markdown-lint** - Validates all `.md` files using `.markdownlint.json`
- **link-check** - Validates all markdown links using `.markdown-link-check.json`
- **structure-validation** - Ensures required files and directories exist

**Runs on:** Every push and PR
**Duration:** ~2-3 minutes

**What it checks:**

1. **Markdown Linting** (`markdown-lint` job)
   - All `.md` files comply with markdown standards
   - Configuration: `.markdownlint.json`
   - Rules enforced:
     - MD013 disabled (line length not enforced)
     - MD033 disabled (inline HTML allowed for badges/diagrams)
     - MD041 disabled (first line doesn't need to be H1)

2. **Link Checking** (`link-check` job)
   - All markdown links resolve correctly
   - Configuration: `.markdown-link-check.json`
   - Settings:
     - Ignores `localhost` links (for local testing examples)
     - 20-second timeout per link
     - Retries on 429 (rate limiting)
     - 3 retry attempts

3. **Structure Validation** (`structure-validation` job)
   - Required files exist:
     - `README.md`
     - `CONSTITUTION.md`
     - `LICENSE`
   - Required directories exist:
     - `profiles/default/agents/`
     - `profiles/default/commands/`
     - `docs/tutorials/`
     - `docs/how-to/`
     - `docs/reference/`
     - `docs/explanation/`

### 2. Learning Validation (`learning-validation.yml`)

**Purpose:** (Future) Validate Law 1-3 compliance in commits

**Status:** Stub - non-blocking placeholder
**Implementation:** Post-launch enhancement
**Script:** `scripts/validate-learnings.sh`

**What it will check (future):**
- Law 1: Learning extraction present and well-formatted
- Law 2: Improvement identification with impact quantification
- Law 3: Context/Solution/Learning/Impact sections complete

**Current behavior:** Always passes (stub mode)

## Configuration Files

### `.markdownlint.json`

Markdown linting rules:

```json
{
  "default": true,
  "MD013": false,  // Line length not enforced
  "MD033": false,  // Inline HTML allowed
  "MD041": false   // First line doesn't need to be H1
}
```

### `.markdown-link-check.json`

Link checking configuration:

```json
{
  "ignorePatterns": [
    {
      "pattern": "^http://localhost"
    }
  ],
  "timeout": "20s",
  "retryOn429": true,
  "retryCount": 3
}
```

## Badges

Repository README displays CI status:

[![Validate](https://github.com/boshu2/agentops/actions/workflows/validate.yml/badge.svg)](https://github.com/boshu2/agentops/actions/workflows/validate.yml)

This badge:
- Shows current status (passing/failing)
- Links to latest workflow run
- Updates automatically on each push

## Local Validation

Run CI checks locally before pushing:

### Markdown Linting

Requires: `markdownlint-cli` ([installation](https://github.com/igorshubovych/markdownlint-cli))

```bash
# Install (npm)
npm install -g markdownlint-cli

# Run validation
markdownlint -c .markdownlint.json '**/*.md'
```

### Link Checking

Requires: `markdown-link-check` ([installation](https://github.com/tcort/markdown-link-check))

```bash
# Install (npm)
npm install -g markdown-link-check

# Run validation (single file)
markdown-link-check -c .markdown-link-check.json README.md

# Run validation (all files)
find . -name "*.md" -exec markdown-link-check -c .markdown-link-check.json {} \;
```

### Structure Validation

Requires: `bash`

```bash
# Run structure checks
bash -c "test -f README.md && test -d profiles/default/agents && echo '✅ Structure OK'"
```

## Troubleshooting

### Markdown Linting Failures

**Symptom:** `markdown-lint` job fails

**Common causes:**
- Trailing whitespace in markdown files
- Inconsistent heading increments (H1 → H3 without H2)
- Multiple H1 headings in a single file
- Missing blank lines around lists or code blocks

**Resolution:**
1. Review the CI output for specific line numbers
2. Fix the reported issues
3. Run `markdownlint -c .markdownlint.json <file>` locally to verify
4. Commit and push the fixes

### Link Checking Failures

**Symptom:** `link-check` job fails

**Common causes:**
- Broken external links (404, 500 errors)
- Typos in internal file paths
- Files moved without updating references
- Rate limiting on external sites (429 errors)

**Resolution:**
1. Review the CI output for failed links
2. For external links: verify URL is correct and accessible
3. For internal links: verify file exists at the specified path
4. For rate limiting: workflow will auto-retry 3 times
5. Commit and push the fixes

### Structure Validation Failures

**Symptom:** `structure-validation` job fails

**Common causes:**
- Required file deleted
- Required directory missing
- Case-sensitivity issue (e.g., `README.md` vs `readme.md`)

**Resolution:**
1. Review the CI output for missing files/directories
2. Restore or create the missing items
3. Ensure exact names match (case-sensitive)
4. Commit and push the fixes

## CI Workflow Design Philosophy

### Why These Checks?

1. **Markdown Linting** - Ensures consistent documentation style
   - Prevents formatting issues that affect readability
   - Catches common markdown syntax errors early
   - Maintains professional documentation quality

2. **Link Checking** - Prevents broken documentation
   - Catches broken links before users encounter them
   - Validates internal cross-references
   - Ensures documentation remains navigable

3. **Structure Validation** - Enforces framework architecture
   - Prevents accidental deletion of core files
   - Ensures profile structure remains intact
   - Validates Diátaxis documentation organization

### Why Stubs?

**Learning validation is a stub because:**
- Complex to implement correctly (natural language processing)
- Requires human judgment (what counts as a "learning"?)
- Not critical for launch (documentation quality > enforcement)
- Can be enhanced post-launch based on community feedback

**Philosophy:** Start with simple, reliable checks. Add complexity when proven necessary.

## Future Enhancements

### Phase 2 (Post-Launch)

1. **Learning Validation** - Implement `scripts/validate-learnings.sh`
   - Parse commit messages for learning sections
   - Validate learning format (pattern/evidence/application)
   - Generate compliance reports

2. **Coverage Reports** - Track documentation coverage
   - Identify undocumented agents/commands
   - Generate coverage badges
   - Set coverage thresholds

3. **Performance Testing** - Validate agent performance benchmarks
   - Run sample workflows
   - Measure execution time
   - Compare against baseline

4. **Security Scanning** - Dependency and code security checks
   - Scan for vulnerable dependencies
   - Check for exposed secrets
   - Validate file permissions

### Phase 3 (Community Growth)

1. **Contribution Validation** - Validate community contributions
   - Check for required sections in profile PRs
   - Validate case study format
   - Ensure license compliance

2. **Multi-Domain Testing** - Test profiles across domains
   - Run profile-specific validation
   - Verify cross-profile compatibility
   - Test profile installation scripts

## Related Documentation

- [CONSTITUTION.md](../../CONSTITUTION.md) - Laws enforced by CI
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - How to pass CI checks
- [scripts/validate-learnings.sh](../../scripts/validate-learnings.sh) - Learning validation script (stub)
- [.markdownlint.json](../../.markdownlint.json) - Markdown linting rules
- [.markdown-link-check.json](../../.markdown-link-check.json) - Link checking config

## CI Metrics

**Current Status (as of Task Group 4 completion):**

- **Workflows:** 2 active (validate, learning-validation)
- **Jobs per workflow:** 3 (validate), 1 (learning-validation)
- **Average duration:** ~2-3 minutes (validate), ~10 seconds (learning-validation stub)
- **Success rate:** Target 100% (all checks must pass)
- **Coverage:** 100% of `.md` files, all internal links, core structure

**Design Goals:**

- **Fast feedback:** < 3 minutes for full validation
- **Clear errors:** Specific line numbers and file paths in failures
- **Local reproducibility:** All checks can be run locally
- **Non-blocking stubs:** Future enhancements don't block current work

---

**CI Pipeline Status:** [![Validate](https://github.com/boshu2/agentops/actions/workflows/validate.yml/badge.svg)](https://github.com/boshu2/agentops/actions/workflows/validate.yml)
