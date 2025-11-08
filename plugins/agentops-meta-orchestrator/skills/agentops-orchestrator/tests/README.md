# Meta-Orchestrator Tests

**Purpose:** Validate pattern library and metrics infrastructure

---

## Test Scripts

### test-pattern-format.sh

**Purpose:** Validate pattern file format and structure

**Usage:**
```bash
bash tests/test-pattern-format.sh
```

**What it checks:**

1. **YAML Syntax** - All pattern files are valid YAML
2. **Required Fields** - Each pattern has: pattern_id, name, description, category, workflow_steps, created_at
3. **Pattern ID Format** - pattern_id matches filename
4. **Workflow Steps** - workflow_steps is a non-empty array
5. **Category Values** - category is one of: api-development, web-development, devops, security, data-engineering, infrastructure

**Exit codes:**
- `0` - All tests passed
- `1` - One or more tests failed

**Example output:**
```
=== Pattern Format Validation ===

Test 1: Validating YAML syntax...
✓ Valid YAML: simple-rest-api-health-check.yaml
✓ Valid YAML: product-launch-meta-orchestrator.yaml

Test 2: Validating required fields...
✓ All required fields present: simple-rest-api-health-check.yaml
✓ All required fields present: product-launch-meta-orchestrator.yaml

Test 3: Validating pattern ID format...
✓ Pattern ID matches filename: simple-rest-api-health-check.yaml
✓ Pattern ID matches filename: product-launch-meta-orchestrator.yaml

=== Summary ===
Passed: 8
Failed: 0
Warnings: 0

Pattern validation PASSED
```

---

### test-metrics-logs.sh

**Purpose:** Validate metrics log file format and data

**Usage:**
```bash
bash tests/test-metrics-logs.sh
```

**What it checks:**

1. **Required Files** - durations.log, success_rates.log, plugin_usage.log exist
2. **durations.log Format** - Header and CSV structure (7 columns)
3. **success_rates.log Format** - Header and CSV structure (8+ columns)
4. **plugin_usage.log Format** - Header and CSV structure (8 columns)
5. **Timestamp Format** - All timestamps are ISO 8601 (YYYY-MM-DDTHH:MM:SSZ)
6. **Boolean Values** - success columns contain only true/false

**Exit codes:**
- `0` - All tests passed
- `1` - One or more tests failed

**Example output:**
```
=== Metrics Logs Validation ===

Test 1: Checking required log files...
✓ Found: durations.log
✓ Found: success_rates.log
✓ Found: plugin_usage.log

Test 2: Validating durations.log format...
✓ Valid header in durations.log
✓ Valid CSV row 2 (7 columns)
✓ Valid CSV row 3 (7 columns)

Test 3: Validating success_rates.log format...
✓ Valid header in success_rates.log
✓ Valid CSV row 2 (≥8 columns)

=== Summary ===
Passed: 12
Failed: 0
Warnings: 0

Metrics validation PASSED
```

---

## Running All Tests

**Run both test suites:**
```bash
bash tests/test-pattern-format.sh && bash tests/test-metrics-logs.sh
```

**Or create a convenience script:**
```bash
#!/usr/bin/env bash
# run-all-tests.sh

set -e

echo "Running all meta-orchestrator tests..."
echo

bash tests/test-pattern-format.sh
echo
bash tests/test-metrics-logs.sh
echo

echo "✅ All tests passed!"
```

---

## CI Integration

**Add to CI pipeline:**

```yaml
# .gitlab-ci.yml
test:meta-orchestrator:
  stage: test
  script:
    - cd skills/agentops-orchestrator
    - bash tests/test-pattern-format.sh
    - bash tests/test-metrics-logs.sh
  rules:
    - changes:
        - skills/agentops-orchestrator/patterns/**/*
        - skills/agentops-orchestrator/metrics/**/*
```

---

## Test Data

**Sample pattern for testing:**

```yaml
# patterns/discovered/test-pattern.yaml
pattern_id: test-pattern
name: Test Pattern
description: A test pattern for validation
category: api-development
workflow_steps:
  - plugin-1
  - plugin-2
  - plugin-3
created_at: 2025-11-08T00:00:00Z
last_used: 2025-11-08T00:00:00Z
executions: 1
success_rate: 1.0
status: discovered
```

**Sample metrics for testing:**

```csv
# metrics/durations.log
timestamp,workflow_id,phase,step,plugin,duration_seconds,success
2025-11-08T00:00:00Z,wf_test,research,1,plugin-discovery,120,true

# metrics/success_rates.log
timestamp,pattern_id,pattern_name,success,duration_seconds,plugins_used,files_created,notes
2025-11-08T00:00:00Z,test-pattern,Test Pattern,true,300,3,5,"Test execution"

# metrics/plugin_usage.log
timestamp,plugin_name,execution_count,total_duration_seconds,success_count,failure_count,avg_duration_seconds,last_used
2025-11-08T00:00:00Z,plugin-1,10,3000,9,1,300.0,2025-11-08T00:00:00Z
```

---

## Future Tests

**Planned test additions:**

1. **Neo4j Integration Tests**
   - Validate Neo4j schema matches specification
   - Test Cypher queries
   - Verify dual-write consistency (files + Neo4j)

2. **Success Probability Tests**
   - Test probability calculation algorithm
   - Validate factor weights
   - Test pattern selection logic

3. **Command Tests**
   - Test `/orchestrate` command execution
   - Test `/browse-patterns` search
   - Test `/inspect-pattern` queries
   - Test `/replay-pattern` execution

4. **End-to-End Tests**
   - Full workflow execution (Research → Plan → Implement → Learn)
   - Pattern promotion (discovered → validated → learned)
   - Metrics aggregation and reporting

---

## Troubleshooting

### Test Failures

**YAML syntax error:**
```
✗ Invalid YAML: my-pattern.yaml
```
**Fix:** Check YAML syntax using `yamllint` or online validator

**Missing required field:**
```
✗ Missing fields in my-pattern.yaml: workflow_steps created_at
```
**Fix:** Add missing fields to pattern file

**Invalid CSV format:**
```
✗ Invalid CSV row 5 (6 columns, expected 7)
```
**Fix:** Check CSV line 5, ensure correct number of columns

**Invalid timestamp:**
```
⚠ Invalid timestamp: 2025-11-08 00:00:00 (expected ISO 8601)
```
**Fix:** Use ISO 8601 format: `2025-11-08T00:00:00Z`

**Invalid boolean:**
```
✗ Invalid boolean: yes (expected true/false)
```
**Fix:** Use lowercase `true` or `false`

---

## Version & Status

**Version:** 0.1.0
**Last Updated:** November 8, 2025
**Status:** Active, basic validation suite
