# Plugin Analyzer Template

**Purpose:** Template for sub-agents analyzing individual Claude Code plugins

**Used by:** Sub-Agent 1 (Capability Extractor) during Research Phase

**Output:** Structured plugin capability analysis

---

## Analysis Checklist

For each plugin, complete the following analysis:

### 1. Basic Metadata

**Plugin Name:**
```
Name: [plugin-name]
Version: [x.y.z]
Author: [author-name]
License: [license-type]
Repository: [github-url]
```

**Description:**
```
One-sentence summary: [what does this plugin do?]

Full description: [detailed explanation]

Keywords: [keyword1, keyword2, keyword3, ...]
```

### 2. Capability Extraction

**Primary Capability:**
```
What is the main thing this plugin does?
Example: "Scaffolds FastAPI project structure"
```

**Secondary Capabilities:**
```
What additional things can this plugin do?
Example:
- Generate CRUD endpoints
- Setup OpenAPI documentation
- Configure database connections
```

**Domain Classification:**
```
Which domain does this belong to?
Options:
- web-development
- devops
- data-engineering
- security
- testing
- database
- ai-ml
- infrastructure
- documentation
- other

Selected: [domain-name]
Subdomain: [optional-subdomain]
```

### 3. Input/Output Identification

**Inputs Required:**
```yaml
inputs:
  - name: [input-name]
    type: [string | number | boolean | object | array]
    required: [true | false]
    description: [what is this input for?]
    example: [example-value]

  # Example:
  - name: app_name
    type: string
    required: true
    description: Name of the application to create
    example: "my-api"

  - name: features
    type: array
    required: false
    description: List of features to include
    example: ["auth", "cache", "docs"]
```

**Outputs Produced:**
```yaml
outputs:
  - name: [output-name]
    type: [string | number | boolean | object | array]
    description: [what does this output contain?]
    example: [example-value]

  # Example:
  - name: project_path
    type: string
    description: Path to created project directory
    example: "./my-api"

  - name: files_created
    type: array
    description: List of files created by scaffolder
    example: ["main.py", "config.py", "requirements.txt"]
```

**Data Format:**
```
What data formats does this plugin work with?
Examples:
- JSON (input and output)
- YAML (configuration)
- Markdown (documentation)
- CSV (data)
- Binary (images, executables)

This plugin uses: [format-list]
```

### 4. Dependency Detection

**Runtime Dependencies:**
```yaml
dependencies:
  required:
    - name: [dependency-name]
      version: [version-spec]
      type: [npm | pip | system | claude-plugin]

  # Example:
  required:
    - name: fastapi
      version: ">=0.95.0"
      type: pip

    - name: uvicorn
      version: ">=0.20.0"
      type: pip

  optional:
    - name: redis
      version: ">=4.0.0"
      type: pip
      purpose: "For caching support"
```

**Plugin Dependencies:**
```
Does this plugin require other plugins to work?

Required plugins:
- [plugin-name] (for [reason])

Compatible plugins:
- [plugin-name] (enhances with [feature])

Incompatible plugins:
- [plugin-name] (conflicts because [reason])
```

**Environment Requirements:**
```
Environment variables needed:
- [ENV_VAR_NAME]: [purpose]

System requirements:
- OS: [linux | macos | windows | any]
- RAM: [minimum memory]
- Disk: [disk space needed]

External services:
- [service-name]: [why needed]
```

### 5. Integration Pattern Recognition

**Common Usage Patterns:**
```
How is this plugin typically used?

Pattern 1: [pattern-name]
  Sequence: [plugin-a] → this-plugin → [plugin-c]
  Purpose: [what does this pattern achieve?]
  Frequency: [how often seen?]

Pattern 2: [pattern-name]
  Sequence: [plugin-x] → this-plugin → [plugin-y]
  Purpose: [what does this pattern achieve?]
  Frequency: [how often seen?]
```

**Integration Points:**
```
How does this plugin connect to others?

Input compatibility:
- Accepts outputs from: [plugin-list]
- Input format matches: [plugin-list]

Output compatibility:
- Produces inputs for: [plugin-list]
- Output format matches: [plugin-list]

Data transformation:
- Transforms [input-format] to [output-format]
```

**Orchestration Role:**
```
What role does this plugin play in workflows?

Role: [initiator | transformer | validator | finalizer]

Initiator: Starts a workflow (creates initial structure)
Transformer: Modifies data/code in the middle
Validator: Checks quality/correctness
Finalizer: Completes a workflow (deployment, publishing)

This plugin is a: [role]
```

### 6. Success Rate & Reliability

**Usage Statistics:**
```
If telemetry available:

Total invocations: [number]
Successful runs: [number]
Failed runs: [number]
Success rate: [percentage]

If no telemetry:
Estimated reliability: [high | medium | low]
Based on: [what signals? stars, issues, maintenance?]
```

**Known Issues:**
```
Common failure modes:

Issue 1: [issue-description]
  Frequency: [how often?]
  Root cause: [why does this happen?]
  Fix: [how to resolve?]

Issue 2: [issue-description]
  Frequency: [how often?]
  Root cause: [why does this happen?]
  Fix: [how to resolve?]
```

**Maintenance Status:**
```
Last updated: [date]
Update frequency: [active | maintained | stale | abandoned]
Open issues: [count]
Closed issues: [count]
Community engagement: [active | moderate | low]

Assessment: [is this plugin reliable for production?]
```

### 7. Documentation Quality

**Documentation Coverage:**
```
README quality: [excellent | good | basic | poor]
- Installation instructions: [yes | no]
- Usage examples: [yes | no]
- API reference: [yes | no]
- Troubleshooting guide: [yes | no]

Code examples provided: [count]
Quality of examples: [clear | unclear | missing]

Overall documentation: [excellent | good | basic | poor]
```

### 8. Performance Characteristics

**Execution Time:**
```
Estimated execution time: [duration]

Fast (<1 min): [yes | no]
Medium (1-5 min): [yes | no]
Slow (>5 min): [yes | no]

Time varies by: [what factors affect speed?]
```

**Resource Usage:**
```
CPU: [low | medium | high]
Memory: [low | medium | high]
Disk: [low | medium | high]
Network: [none | low | medium | high]

Bottlenecks: [what limits performance?]
```

### 9. Security Considerations

**Security Profile:**
```
Requires credentials: [yes | no]
  If yes: [what credentials?]

Accesses network: [yes | no]
  If yes: [what endpoints?]

Reads filesystem: [yes | no]
  If yes: [what paths?]

Writes filesystem: [yes | no]
  If yes: [what paths?]

Executes code: [yes | no]
  If yes: [what code? user-provided or plugin-defined?]

Security risk: [low | medium | high]
Reason: [why this risk level?]
```

### 10. Recommendation Score

**Overall Score:**
```
Based on analysis above:

Capability clarity: [1-10]
Documentation quality: [1-10]
Reliability: [1-10]
Integration ease: [1-10]
Community support: [1-10]

Overall recommendation: [1-10]

Should this plugin be suggested? [yes | with-caution | no]
Reason: [why or why not?]
```

---

## Analysis Template (YAML)

Use this YAML structure to record findings:

```yaml
plugin:
  name: fastapi-scaffolder
  version: 1.2.3
  author: example-author
  license: MIT
  repository: https://github.com/example/fastapi-scaffolder

  description:
    short: "Scaffolds FastAPI project structure"
    full: "Automatically generates FastAPI project with best practices..."
    keywords: [fastapi, scaffold, api, crud, openapi]

  domain: web-development
  subdomain: api-development

  capabilities:
    primary: "Create FastAPI project structure"
    secondary:
      - "Generate CRUD endpoints"
      - "Setup OpenAPI documentation"
      - "Configure database connections"

  inputs:
    - name: app_name
      type: string
      required: true
      description: "Name of application to create"
      example: "my-api"

  outputs:
    - name: project_path
      type: string
      description: "Path to created project"
      example: "./my-api"

  dependencies:
    required:
      - name: fastapi
        version: ">=0.95.0"
        type: pip

  integration:
    role: initiator
    common_patterns:
      - sequence: "fastapi-scaffolder → jwt-auth → test-generator"
        purpose: "Create authenticated API"
        frequency: high

  reliability:
    success_rate: 0.95
    known_issues:
      - issue: "Fails if directory exists"
        fix: "Delete existing directory first"

  documentation:
    readme_quality: excellent
    examples_count: 5
    overall: excellent

  performance:
    execution_time: "~2 minutes"
    cpu: low
    memory: low

  security:
    risk_level: low
    requires_credentials: false
    network_access: false

  recommendation:
    score: 9
    suggest: yes
    reason: "Well-documented, reliable, commonly used"
```

---

## Analysis Workflow

**Step-by-step process for analyzing a plugin:**

1. **Read plugin metadata**
   - Clone/download plugin repository
   - Read package.json, plugin.json, or equivalent
   - Extract name, version, author, license

2. **Analyze documentation**
   - Read README.md thoroughly
   - Look for CHANGELOG.md (update frequency)
   - Check for CONTRIBUTING.md (community activity)
   - Review examples/ directory if exists

3. **Examine plugin code**
   - Identify entry points (main function, command handlers)
   - Map inputs to code (what parameters are read?)
   - Map outputs to code (what is returned/produced?)
   - Check for error handling (try/catch, validation)

4. **Test plugin locally** (if possible)
   - Install plugin in test environment
   - Run with sample inputs
   - Observe outputs and behavior
   - Note any issues encountered

5. **Search for usage patterns**
   - Look for this plugin in other plugin configurations
   - Check documentation for "works well with" mentions
   - Identify common plugin sequences

6. **Record findings**
   - Fill out YAML template
   - Store in plugin capability database
   - Flag for review if anything unclear

---

## Output Format

After analyzing each plugin, produce:

1. **Structured YAML file** (using template above)
2. **One-paragraph summary** (for quick reference)
3. **Recommendation** (yes/with-caution/no)

**Example summary:**
```
fastapi-scaffolder: Highly reliable FastAPI project scaffolder (95% success rate,
1200+ uses). Creates project structure with best practices. Works well with
jwt-auth-plugin and redis-cache-plugin. Excellent documentation, active maintenance.
Recommended for API development workflows. Execution time: ~2 minutes. No security concerns.
```

---

**Version:** 0.1.0
**Last Updated:** 2025-11-07
**Status:** Template for sub-agent use
