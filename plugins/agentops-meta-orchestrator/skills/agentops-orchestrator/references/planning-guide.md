# Planning Phase Guide

Transform research findings into executable workflow specifications.

## Step 1: Task Decomposition

Break high-level request into atomic subtasks.

**Decomposition Principles:**
- Each subtask = one clear responsibility
- Order by dependencies (structure before features)
- Each maps to ≥1 plugin capability

**Example:**
```
Request: "Build REST API with JWT auth and Redis caching"

Subtasks:
1. Create API project structure
2. Define data models and routes
3. Integrate JWT authentication
4. Add Redis caching layer
5. Configure rate limiting
6. Generate API documentation
7. Create tests
8. Validate complete system
```

## Step 2: Plugin-to-Subtask Mapping

Match best plugin to each subtask.

**Selection Criteria:**
1. Capability match (plugin solves requirement)
2. Success rate (proven reliability)
3. Usage count (production-tested)
4. Compatibility (integrates with other selections)

**Example:**
```
Subtask 1: Create API structure
  Candidates:
    - fastapi-scaffolder (95% success, 234 uses)
    - flask-starter (87% success, 123 uses)
  Selected: fastapi-scaffolder
  Reason: Higher success rate, more usage

Subtask 3: JWT authentication
  Candidates:
    - jwt-auth-plugin (89% success, 1247 uses)
    - oauth2-integration (85% success, 892 uses)
  Selected: jwt-auth-plugin
  Reason: Matches explicit requirement "JWT"
```

## Step 3: Workflow Sequencing

Order plugins by dependencies and data flow.

**Dependency Graph:**
```
fastapi-scaffolder
       ↓
pydantic-models + sqlalchemy-setup
       ↓
jwt-auth-plugin
       ↓
redis-cache-plugin
       ↓
rate-limiter-plugin
       ↓
api-docs-generator
       ↓
test-generator
       ↓
api-tester (validation)
```

**Rationale:**
1. Structure must exist before adding features
2. Models defined before auth uses them
3. Auth works before caching responses
4. All features complete before docs
5. Tests validate integrated system

## Step 4: Data Flow Definition

Define what data flows between plugins.

**Template:**
```
Step N: <plugin-name>
  Input: {
    param1: <value-or-reference-to-previous-output>,
    param2: <value>
  }
  Output: {
    result1: <description>,
    result2: <description>
  }
```

**Example:**
```
Step 1: fastapi-scaffolder
  Input: { app_name: "my-api", template: "minimal" }
  Output: {
    project_path: "./my-api",
    files_created: ["main.py", "config.py"],
    entry_point: "main.py"
  }

Step 2: jwt-auth-plugin
  Input: {
    project_path: "./my-api",  # From Step 1
    user_model: "User"
  }
  Output: {
    auth_routes: ["POST /login", "POST /register"],
    middleware_added: "JWTMiddleware"
  }
```

**Validation:**
- Every input satisfied by previous outputs
- Configuration requirements documented
- Missing dependencies flagged

## Step 5: Validation Checkpoints

Define success criteria for each step.

**Template:**
```
Step N validation:
  Check 1: <what-to-verify>
    Command: <how-to-verify>
    Expected: <success-criteria>
  Check 2: <what-to-verify>
    Command: <how-to-verify>
    Expected: <success-criteria>
  Overall: <acceptance-criteria>
```

**Example:**
```
Step 1: fastapi-scaffolder
  Validation:
    Check 1: Files exist
      Command: ls main.py config.py
      Expected: Both files present
    Check 2: Syntax valid
      Command: python -m py_compile main.py
      Expected: No errors
    Check 3: Module imports
      Command: python -c "import main"
      Expected: Import succeeds
  Overall: ✓ All files created and valid
```

## Step 6: Error Handling Strategy

Plan recovery for each failure type.

**Error Handling Levels:**

**Level 1: Retry with backoff (transient errors)**
```
Attempt 1: Invoke plugin → Error
Wait: 2 seconds
Attempt 2: Retry → Error
Wait: 4 seconds
Attempt 3: Retry → Success or escalate
```

**Level 2: Fallback to alternative (incompatibility)**
```
Primary: jwt-auth-plugin → Incompatible with FastAPI 0.110
Fallback: oauth2-integration → Success
Alert: User wanted JWT, using OAuth2 instead
```

**Level 3: Manual intervention (unrecoverable)**
```
Plugin: redis-cache-plugin → Connection refused
Retries: All failed
Fallback: No alternative
Action: Alert user "Start Redis server: redis-server"
```

## Workflow Specification Format

Output from planning phase:

```yaml
workflow_id: <unique-identifier>
created: <timestamp>
task_description: <original-user-request>
estimated_time: <minutes>
estimated_success_rate: <percentage>

steps:
  - step: <number>
    plugin: <plugin-name>
    purpose: <what-this-step-does>
    inputs:
      param1: <value>
      param2: <value-or-reference>
    outputs:
      result1: <description>
      result2: <description>
    validation:
      - check: <what-to-verify>
        command: <how-to-verify>
    retry_strategy: <strategy>
    fallback: <alternative-plugin-or-null>

  # ... more steps

environment_requirements:
  - ENV_VAR: <description>
  - SECRET: <description>

dependencies:
  - package>=version
  - package>=version

final_validation:
  - test: <final-check>
    command: <how-to-test>

rollback_procedure:
  - <step-to-undo>
  - <step-to-undo>
```

## Common Workflow Patterns

### Sequential Pattern
```
A → B → C → D
```
Simple dependency chain, each step builds on previous.

### Parallel Pattern
```
    A
   / \
  B   C
   \ /
    D
```
B and C execute simultaneously after A, D waits for both.

### Conditional Pattern
```
A → Decision
    ├─ Yes → B → D
    └─ No  → C → D
```
Path depends on condition evaluation.

### Feedback Pattern
```
A → B → Validate
         ├─ Pass → C
         └─ Fail → A (retry with fixes)
```
Loop until validation passes or max retries.

## Planning Checklist

- [ ] Decompose task into atomic subtasks
- [ ] Match plugins to subtasks (capability + success rate)
- [ ] Order plugins by dependencies and data flow
- [ ] Define inputs/outputs for each step
- [ ] Validate all inputs can be satisfied
- [ ] Define validation checkpoints
- [ ] Plan error handling (retry, fallback, manual)
- [ ] Document environment requirements
- [ ] Define final validation criteria
- [ ] Estimate completion time and success rate

## Quick Decision Matrix

**Choose high-freedom (text instructions) when:**
- Multiple valid approaches exist
- Context determines best path
- Creativity valued over consistency

**Choose medium-freedom (scripts with params) when:**
- Preferred pattern exists
- Some variation acceptable
- Configuration affects behavior

**Choose low-freedom (specific scripts) when:**
- Operations fragile and error-prone
- Consistency critical
- Specific sequence required

For meta-orchestration: **Medium-freedom** (workflow specs with parameters)
