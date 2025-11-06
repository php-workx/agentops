# How to Debug Workflow Issues

**Goal:** Systematically troubleshoot and resolve workflow problems

**Time:** 10-30 minutes (varies by issue)

**Prerequisites:**
- Basic understanding of AgentOps workflows
- Access to error messages or symptoms

## Overview

When workflows don't behave as expected, systematic debugging helps identify and fix issues quickly. This guide covers common problems, debugging strategies, and solutions for AgentOps workflows.

**Common issue types:**
- Workflow doesn't start or fails immediately
- Agent produces incorrect output
- Files not found or created in wrong location
- Workflow references or includes not loading
- Tasks not completing as expected
- Verification failures

## Quick Diagnosis Checklist

Before deep debugging, check these common issues:

```
[ ] Is the spec/task file in the right location?
[ ] Does tasks.md or spec.md exist?
[ ] Are file paths absolute or relative correctly?
[ ] Is the agent name spelled correctly?
[ ] Are required dependencies installed?
[ ] Does the codebase match expected structure?
[ ] Are there typos in workflow references?
```

## Debugging Strategies

### 1. Read Error Messages Carefully

**What to look for:**
- File not found → Path issue
- Command not found → Missing dependency
- Syntax error → Typo in workflow file
- Permission denied → File permissions problem
- Validation failed → Output doesn't match spec

**Example:**
```
Error: File 'specs/2025-11-06-feature/spec.md' not found

Diagnosis: Spec file missing or wrong path
Solution: Run /write-spec or check spec folder name
```

### 2. Verify File Locations

**Check spec folder structure:**

```bash
# List spec folder
ls -la specs/2025-11-06-feature-name/

# Should see:
# - spec.md (from /write-spec)
# - tasks.md (from /create-tasks)
# - planning/requirements.md (from /shape-spec)
# - planning/visuals/ (optional)
```

**If files missing:**
- Run prerequisite commands (/shape-spec, /write-spec, /create-tasks)
- Check for typos in folder names
- Verify you're in correct repository directory

### 3. Check Workflow References

**Workflow references look like:**
```markdown
{{workflows/planning/gather-product-info}}
```

**Common issues:**
- Typo in path: `workflows/planing/` instead of `workflows/planning/`
- File doesn't exist at referenced path
- Wrong file extension (should be `.md`)

**How to verify:**

```bash
# Check if workflow file exists
ls -la profiles/default/workflows/planning/gather-product-info.md

# If missing, check actual location
find profiles -name "gather-product-info.md"
```

### 4. Validate Agent Configuration

**Check agent frontmatter:**

```markdown
---
name: agent-name           # Must match filename (agent-name.md)
description: Brief desc    # Required
tools: Read, Write, Bash   # Must be valid tool names
color: cyan                # Optional
model: inherit             # Optional
---
```

**Common frontmatter issues:**
- Missing required fields (name, description, tools)
- Invalid tool names (check capitalization)
- YAML syntax errors (missing colons, quotes)

**How to verify:**

```bash
# Check frontmatter syntax
head -10 profiles/default/agents/your-agent.md
```

### 5. Test Components Independently

**Break down the problem:**

1. **Test agent alone** - Can it execute basic workflow?
2. **Test command alone** - Does command invoke correctly?
3. **Test workflow file** - Does workflow load without errors?
4. **Test with minimal input** - Simplify to isolate issue

**Example:**
```bash
# Instead of full /implement-tasks, test just reading spec
# Create minimal test agent that only reads spec.md
```

### 6. Check Standards/Preferences Loading

**If using user standards:**

```markdown
{{standards/global/*}}
{{standards/api/*}}
```

**Verify standards exist:**

```bash
# Check standards directory
ls -la profiles/default/standards/

# Check specific standard file
cat profiles/default/standards/global/coding-style.md
```

**Common issues:**
- Standards directory doesn't exist
- Wildcard pattern matches no files
- Standards files have syntax errors

## Common Issues and Solutions

### Issue: "Spec file not found"

**Symptoms:**
- Workflow errors immediately
- Message: "Cannot find spec.md"

**Diagnosis:**
```bash
# Check if spec exists
ls specs/*/spec.md

# Check folder name
ls -la specs/
```

**Solutions:**
1. Run `/write-spec` to create spec.md
2. Check spec folder name matches what workflow expects
3. Verify you're in correct repository directory

---

### Issue: "Agent not found" or "Command not found"

**Symptoms:**
- `/command-name` doesn't work
- Error: "Command not recognized"

**Diagnosis:**
```bash
# Check if command file exists
ls profiles/default/commands/command-name/

# Check if agent file exists
ls profiles/default/agents/agent-name.md
```

**Solutions:**
1. Verify file naming (kebab-case, e.g., `product-planner.md`)
2. Check file is in correct profile directory
3. Verify command/agent name matches file name exactly

---

### Issue: Workflow produces wrong output

**Symptoms:**
- Agent completes but output incorrect
- Files created in wrong location
- Content doesn't match specification

**Diagnosis:**
1. Review agent workflow steps - are they correct?
2. Check if agent has right tools (Read, Write, etc.)
3. Verify spec.md has sufficient detail
4. Check if codebase patterns match expectations

**Solutions:**
1. **Add more detail to spec** - Agent needs clear guidance
2. **Update agent workflow** - Fix workflow logic
3. **Provide examples** - Show agent what output should look like
4. **Check user standards** - May be conflicting guidance

---

### Issue: Tasks not marked complete

**Symptoms:**
- `/implement-tasks` completes but tasks.md still shows `[ ]`
- Verification doesn't run (waits for all tasks `[x]`)

**Diagnosis:**
```bash
# Check tasks.md
cat specs/*/tasks.md | grep "\[x\]"
cat specs/*/tasks.md | grep "\[ \]"
```

**Solutions:**
1. **Manually update** - Edit tasks.md to mark `[x]`
2. **Agent issue** - Implementer agent may have failed to update
3. **Re-run** - Try `/implement-tasks` again on same group

---

### Issue: Verification fails

**Symptoms:**
- Tests fail
- Linting errors
- Build errors
- Verification report shows failures

**Diagnosis:**
```bash
# Run tests manually
npm test  # or pytest, cargo test, etc.

# Run linter manually
npm run lint  # or pylint, clippy, etc.

# Try building manually
npm run build  # or cargo build, make, etc.
```

**Solutions:**
1. **Fix test failures** - Address failing tests
2. **Fix lint errors** - Clean up code quality issues
3. **Fix build errors** - Resolve compilation/bundling issues
4. **Update verification** - If checks are too strict, adjust

---

### Issue: Workflow reference not loading

**Symptoms:**
- Agent workflow incomplete
- Steps missing
- `{{workflows/path/file}}` appears literally in output

**Diagnosis:**
```bash
# Check if workflow file exists
ls profiles/default/workflows/planning/gather-product-info.md

# Check for typos in reference
grep -r "{{workflows" profiles/default/agents/
```

**Solutions:**
1. **Create missing workflow** - If file doesn't exist
2. **Fix typo** - Correct workflow reference path
3. **Check syntax** - Ensure proper `{{workflows/path/file}}` format

---

### Issue: Agent has wrong tools/permissions

**Symptoms:**
- "Tool not available" error
- Agent can't read/write files
- Commands fail with permission errors

**Diagnosis:**
Check agent frontmatter tools list:
```markdown
---
tools: Read, Write, Bash
---
```

**Solutions:**
1. **Add missing tools** - Include required tools in frontmatter
2. **Check tool names** - Verify capitalization (e.g., `Read` not `read`)
3. **Minimal tools** - Only grant what's needed

---

### Issue: Multi-agent workflow fails partway

**Symptoms:**
- First agent completes, second fails
- Subagent invocation errors
- Context not passed between agents

**Diagnosis:**
Review agent delegation:
```markdown
Delegates to **spec-writer** subagent with:
- Spec folder path
- Requirements.md
- Visuals/
```

**Solutions:**
1. **Check subagent exists** - Verify agent file present
2. **Verify inputs** - Ensure all required inputs passed
3. **Test subagent alone** - Isolate which agent has issue

---

## Debugging Workflow Template

Use this systematic approach:

```markdown
# Debugging Session: [Issue Description]

## Symptom
[What's going wrong]

## Expected Behavior
[What should happen]

## Steps Taken
1. [First thing tried]
2. [Second thing tried]

## Observations
- [Finding 1]
- [Finding 2]

## Diagnosis
[Root cause identified]

## Solution
[What fixed it]

## Prevention
[How to avoid in future]
```

## Advanced Debugging

### Enable Verbose Output

For bash commands in workflows:

```bash
# Add debugging to bash commands
set -x  # Print commands as executed

# Example
set -x
ls -la specs/
cat specs/*/spec.md
set +x  # Disable debugging
```

### Check File Permissions

```bash
# Check if files are readable/writable
ls -la specs/2025-11-06-feature/

# Fix permissions if needed
chmod 644 specs/*/spec.md
chmod 755 specs/*/
```

### Validate Workflow Files

```bash
# Check for common issues in workflow files
for file in profiles/default/workflows/**/*.md; do
    echo "Checking $file"
    # Check file is not empty
    [ -s "$file" ] || echo "  WARNING: Empty file"
    # Check has markdown content
    grep -q "#" "$file" || echo "  WARNING: No markdown headers"
done
```

### Test with Minimal Example

Create simplified version of failing workflow:

```markdown
---
name: test-minimal
description: Minimal test agent
tools: Read, Write
model: inherit
---

# Minimal Test

## Workflow

### Step 1: Read File

```bash
cat specs/2025-11-06-test/spec.md
```

### Step 2: Write Output

Create test file:

```bash
echo "Test successful" > test-output.txt
```
```

## Prevention Strategies

### Before Running Workflows

1. **Validate file structure**
   ```bash
   # Ensure required files exist
   ls specs/*/spec.md
   ls specs/*/tasks.md
   ```

2. **Check for typos**
   - Agent names
   - Command names
   - Workflow references

3. **Verify dependencies**
   ```bash
   # Example: Check npm packages installed
   npm list --depth=0
   ```

### During Development

1. **Test incrementally** - Don't build entire workflow at once
2. **Use version control** - Commit working states
3. **Document changes** - Note what you modified
4. **Keep workflows simple** - Complexity increases debugging difficulty

### After Issues Resolved

1. **Document solution** - Add to troubleshooting guide
2. **Update workflows** - Fix root cause, not just symptom
3. **Add validation** - Prevent recurrence
4. **Share learnings** - Help others avoid same issue

## Getting Help

If stuck after trying debugging steps:

1. **Check documentation**
   - [Command Reference](../reference/commands/README.md)
   - [Agent Reference](../reference/agents/README.md)
   - [Pattern Documentation](https://github.com/boshu2/12-factor-agentops)

2. **Review examples**
   - Look at working agents in `profiles/default/agents/`
   - Study working commands in `profiles/default/commands/`

3. **Create minimal reproduction**
   - Simplify to smallest failing case
   - Easier to debug and explain

4. **Ask for help**
   - Include error messages
   - Show what you've tried
   - Provide minimal reproduction

## Related

- [Agent Reference](../reference/agents/README.md)
- [Command Reference](../reference/commands/README.md)
- [How to Create Custom Agent](create-custom-agent.md)
- [How to Create Custom Profile](CREATE_CUSTOM_PROFILE.md)

## Quick Reference: Common Commands

```bash
# Check file locations
ls -la specs/*/
ls -la profiles/default/agents/
ls -la profiles/default/commands/

# Find files
find . -name "spec.md"
find . -name "*agent-name*"

# Check file contents
cat specs/*/spec.md
head -20 profiles/default/agents/agent-name.md

# Verify bash commands work
bash -x your-script.sh

# Check workflow references
grep -r "{{workflows" profiles/

# Validate YAML frontmatter
head -10 profiles/default/agents/*.md
```

## Tips for Success

1. **Read error messages** - They usually point to the issue
2. **Check file paths first** - Most common problem
3. **Test components independently** - Isolate the issue
4. **Use version control** - Easy to revert when debugging
5. **Start simple** - Add complexity incrementally
6. **Document as you debug** - Helps future you
7. **Keep calm** - Systematic approach beats random changes
8. **Ask for help** - Don't waste hours on obvious issues
