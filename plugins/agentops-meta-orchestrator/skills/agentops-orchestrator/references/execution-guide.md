# Execution Phase Guide

Execute workflows with continuous validation and error recovery.

## Core Execution Loop

```python
def execute_workflow(workflow_spec):
    """Execute workflow with validation and error handling"""
    
    context = {}  # Store outputs for inter-step data flow
    
    for step in workflow_spec.steps:
        print(f"⚙️ Step {step.number}: {step.purpose}")
        
        # Prepare inputs (resolve references to previous outputs)
        inputs = resolve_inputs(step.inputs, context)
        
        # Invoke plugin
        result = invoke_plugin(
            plugin_name=step.plugin,
            inputs=inputs
        )
        
        # Validate outputs
        if validate_outputs(result, step.validation):
            print(f"✓ Step {step.number} complete")
            context[step.plugin] = result.outputs
        else:
            print(f"✗ Step {step.number} failed")
            if not handle_failure(step, result, context):
                raise WorkflowExecutionError(f"Step {step.number} failed")
    
    # Final validation
    if run_final_validation(workflow_spec.final_validation, context):
        print("✅ Workflow complete!")
        return WorkflowResult(success=True, outputs=context)
    else:
        print("❌ Final validation failed")
        return WorkflowResult(success=False)
```

## Plugin Invocation

**Standard invocation pattern:**

```
1. Prepare inputs
   inputs = {
     "app_name": "my-api",
     "template": "minimal"
   }

2. Call plugin
   result = run_plugin("fastapi-scaffolder", inputs)

3. Capture outputs
   outputs = {
     "project_path": "./my-api",
     "files_created": ["main.py", "config.py"],
     "success": true
   }

4. Store in context
   context["scaffolder"] = outputs
```

**Input resolution:**
```python
def resolve_inputs(step_inputs, context):
    """Resolve references to previous step outputs"""
    resolved = {}
    for key, value in step_inputs.items():
        if isinstance(value, str) and value.startswith("$"):
            # Reference to previous output
            plugin, field = value[1:].split(".")
            resolved[key] = context[plugin][field]
        else:
            # Literal value
            resolved[key] = value
    return resolved

# Example:
step_inputs = {
    "project_path": "$scaffolder.project_path",  # Reference
    "user_model": "User"                          # Literal
}
resolved = resolve_inputs(step_inputs, context)
# → { "project_path": "./my-api", "user_model": "User" }
```

## Validation Execution

**Validation pattern:**

```
Step validation:

Check 1: Files exist
  Command: ls ./my-api/main.py ./my-api/config.py
  Result: ✓ Both files exist

Check 2: Syntax valid
  Command: python -m py_compile ./my-api/main.py
  Result: ✓ No syntax errors

Check 3: Module importable
  Command: python -c "import sys; sys.path.insert(0, './my-api'); import main"
  Result: ✓ Import successful

Overall: ✓ All checks passed
```

**Validation types:**

**File existence:**
```bash
test -f ./path/to/file && echo "✓ Exists" || echo "✗ Missing"
```

**Syntax validation:**
```bash
python -m py_compile script.py
node --check script.js
```

**Import/require validation:**
```bash
python -c "import module_name"
node -e "require('./module')"
```

**Service health:**
```bash
curl -f http://localhost:8000/health || echo "✗ Service down"
```

**Test execution:**
```bash
pytest tests/ --quiet
npm test -- --silent
```

## Error Recovery

### Level 1: Retry with Exponential Backoff

**Pattern:**
```python
def retry_with_backoff(plugin, inputs, max_attempts=3):
    """Retry plugin with exponential backoff"""
    for attempt in range(1, max_attempts + 1):
        try:
            result = invoke_plugin(plugin, inputs)
            if result.success:
                return result
        except Exception as e:
            if attempt < max_attempts:
                wait_time = 2 ** attempt  # 2, 4, 8 seconds
                print(f"⚠️ Attempt {attempt} failed, retrying in {wait_time}s...")
                time.sleep(wait_time)
            else:
                print(f"✗ All {max_attempts} attempts failed")
                raise e
```

**When to use:** Transient errors (network timeouts, temporary locks, rate limits)

### Level 2: Fallback to Alternative Plugin

**Pattern:**
```python
def execute_with_fallback(primary, fallback, inputs):
    """Try primary plugin, fall back to alternative if fails"""
    try:
        result = retry_with_backoff(primary, inputs)
        return result
    except Exception as e:
        print(f"⚠️ Primary plugin {primary} failed: {e}")
        print(f"→ Trying fallback: {fallback}")
        
        # Convert inputs if needed
        fallback_inputs = convert_inputs(inputs, primary, fallback)
        
        try:
            result = retry_with_backoff(fallback, fallback_inputs)
            print(f"✓ Fallback succeeded")
            # Alert user about substitution
            alert_user(f"Used {fallback} instead of {primary}")
            return result
        except Exception as e2:
            print(f"✗ Fallback also failed: {e2}")
            raise e2
```

**When to use:** Plugin incompatibilities, version conflicts, environment-specific issues

### Level 3: Manual Intervention

**Pattern:**
```python
def require_manual_intervention(step, error):
    """Request user action for unrecoverable errors"""
    print(f"⚠️ Manual intervention required for Step {step.number}")
    print(f"Error: {error}")
    
    # Provide guidance
    if "redis" in str(error).lower():
        print("Action: Start Redis server")
        print("Command: redis-server")
    elif "permission denied" in str(error).lower():
        print("Action: Fix file permissions")
        print("Command: chmod +x script.sh")
    else:
        print("Action: Review error and fix manually")
    
    # Wait for confirmation
    user_input = input("Press Enter when fixed, or 'skip' to continue: ")
    
    if user_input.lower() == "skip":
        print("⚠️ Skipping step, workflow may be incomplete")
        return False
    else:
        print("→ Retrying step...")
        return True
```

**When to use:** Missing external services, permission errors, configuration issues requiring user input

## Progress Tracking

**Real-time feedback:**

```
🔧 Executing workflow: REST API with JWT auth and Redis caching
   Estimated time: 12 minutes
   Steps: 8

⚙️ Step 1/8: Create API structure (fastapi-scaffolder)
   Status: Running...
   [████████████████░░░░] 80%
   Status: ✓ Complete (2 min)

⚙️ Step 2/8: Add JWT authentication (jwt-auth-plugin)
   Status: Running...
   [████████████████████] 100%
   Status: ✓ Complete (3 min)

⚙️ Step 3/8: Setup Redis caching (redis-cache-plugin)
   Status: Running...
   [████████░░░░░░░░░░░░] 40%
   Status: ⚠️ Waiting for Redis connection...
   Status: ✓ Complete (4 min, with retry)

🔍 Final Validation
   Running tests...
   [████████████████████] 100%
   Status: ✓ All tests passed

✅ Workflow complete!
   Total time: 11 minutes
   Success rate: 100% (8/8 steps)
```

## Output Collection

**Structure workflow results:**

```json
{
  "workflow_id": "rest-api-jwt-redis-workflow",
  "status": "success",
  "execution_time": "11_minutes",
  "steps_completed": 8,
  "steps_failed": 0,
  "outputs": {
    "project_path": "./my-api",
    "api_endpoints": [
      "POST /register",
      "POST /login",
      "GET /me",
      "GET /health"
    ],
    "features": [
      "JWT authentication",
      "Redis caching",
      "Rate limiting",
      "API documentation"
    ],
    "test_results": {
      "total": 24,
      "passed": 24,
      "failed": 0
    }
  },
  "learnings": {
    "pattern_used": "fastapi-jwt-redis",
    "modifications": [],
    "success": true
  }
}
```

## Common Error Scenarios

### Missing Dependency

**Error:** `ModuleNotFoundError: No module named 'python-jose'`

**Recovery:**
```bash
pip install python-jose --break-system-packages
# Retry plugin
```

### Service Unavailable

**Error:** `redis.exceptions.ConnectionError: Connection refused`

**Recovery:**
```bash
# Check if Redis running
redis-cli ping

# If not, start it
redis-server --daemonize yes

# Retry plugin
```

### Permission Denied

**Error:** `PermissionError: [Errno 13] Permission denied: '/usr/local/bin/script.sh'`

**Recovery:**
```bash
chmod +x /usr/local/bin/script.sh
# Retry plugin
```

### Version Incompatibility

**Error:** `ImportError: FastAPI requires version >= 0.95.0, found 0.88.0`

**Recovery:**
```bash
pip install --upgrade fastapi --break-system-packages
# Retry plugin
```

## Execution Checklist

- [ ] Load workflow specification
- [ ] Initialize context for inter-step data
- [ ] For each step:
  - [ ] Resolve inputs from context
  - [ ] Invoke plugin
  - [ ] Validate outputs
  - [ ] Store outputs in context
  - [ ] Handle failures (retry → fallback → manual)
- [ ] Run final validation
- [ ] Collect and structure outputs
- [ ] Return results for learning phase

## Performance Tips

**Parallel execution (when possible):**
```python
# If steps 2 and 3 are independent
results = await asyncio.gather(
    invoke_plugin_async("step2-plugin", inputs2),
    invoke_plugin_async("step3-plugin", inputs3)
)
```

**Caching (for idempotent operations):**
```python
@cache
def analyze_plugin(plugin_name):
    """Cache expensive analysis operations"""
    # Analysis logic
    return results
```

**Checkpointing (for long workflows):**
```python
# Save progress after each step
save_checkpoint(workflow_id, step_number, context)

# Resume from checkpoint if interrupted
if checkpoint_exists(workflow_id):
    context, last_step = load_checkpoint(workflow_id)
    resume_from(last_step + 1)
```
