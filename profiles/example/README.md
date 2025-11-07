# Example AgentOps Profile

**Status:** Template for creating custom profiles
**Version:** 1.0.0
**License:** Apache-2.0

---

## What This Is

This is a **template profile** showing how to extend AgentOps core for your domain.

Think of it like a Kubernetes CRD (Custom Resource Definition) - it defines custom resources and behaviors for a specific domain on top of the core platform.

---

## Structure

```
profiles/example/
├── profile.yaml           # Profile manifest (like K8s CRD)
├── README.md              # This file
├── agents/
│   ├── domain-explorer.md # Domain-specific research agent
│   └── domain-architect.md # Domain-specific planning agent
├── commands/
│   └── research.md        # Domain-specific research command override
├── workflows/
│   └── domain-complete-cycle.md # Domain workflow orchestration
└── skills/
    ├── domain-validator.sh # Script-based automation
    └── domain-analyzer.md  # AI-powered skill
```

---

## How to Use This Template

### 1. Copy This Directory

```bash
cp -r profiles/example profiles/your-domain
cd profiles/your-domain
```

### 2. Edit Profile Manifest

Edit `profile.yaml`:

```yaml
metadata:
  name: your-domain  # Change from 'example'
  description: Brief description of your domain
  author: Your Name

spec:
  agents:
    - name: your-domain-explorer
      # Update agent definitions
```

### 3. Create Your Agents

Edit `agents/domain-explorer.md`:

- Change "domain" to your actual domain (kubernetes, api, data, etc.)
- Add domain-specific tools and patterns
- Include examples from your stack

### 4. Customize Workflows

Edit `workflows/domain-complete-cycle.md`:

- Add domain-specific phases
- Reference your agents
- Include domain examples

### 5. Add Domain Skills

Create `skills/your-validator.sh`:

```bash
#!/bin/bash
# Validate your domain-specific files
your-validation-tool "$@"
```

### 6. Test Installation

```bash
# From repository root
./scripts/validate-profile.sh your-domain
./scripts/install.sh --profile your-domain
```

### 7. Use Your Profile

```bash
/prime  # Your profile loads automatically
```

---

## What's Included

### Agents (2)

**domain-explorer**
- Explores domain-specific code patterns
- Maps domain structure
- Identifies domain conventions

**domain-architect**
- Designs domain-specific solutions
- Creates domain specifications
- Plans domain implementations

### Commands (1 override)

**research** (enhanced)
- Extends core `/research` command
- Adds domain-specific research patterns
- Includes domain examples

### Workflows (1)

**domain-complete-cycle**
- Full Research→Plan→Implement→Validate→Learn cycle
- Customized for domain patterns
- References domain agents

### Skills (2)

**domain-validator** (script)
- Fast, deterministic validation
- Domain-specific syntax checks
- Returns structured results

**domain-analyzer** (AI)
- Pattern recognition
- Complexity assessment
- Reasoning-based analysis

---

## Customization Guide

### Minimal Customization (Quick Start)

Just update profile metadata:

```yaml
# profile.yaml
metadata:
  name: my-domain
  description: My domain description
```

Keep example agents, customize later.

**Time:** 5 minutes
**Result:** Functional profile

### Moderate Customization (Recommended)

Update metadata + add 2-3 domain agents:

```yaml
agents:
  - name: my-domain-specific-agent-1
    file: agents/agent-1.md
  - name: my-domain-specific-agent-2
    file: agents/agent-2.md
```

**Time:** 1-2 hours
**Result:** Domain-optimized profile

### Full Customization (Production-Ready)

- 5-10 specialized agents
- 2-3 command overrides
- 3-5 domain workflows
- Multiple domain skills
- Comprehensive documentation

**Time:** 1-2 days
**Result:** Complete domain profile

---

## Real-World Examples

See community profiles for inspiration:

### DevOps Profile

```yaml
# profiles/devops/profile.yaml
agents:
  - kubernetes-debugger
  - container-builder
  - pipeline-architect
  - helm-chart-creator
  - dockerfile-optimizer

workflows:
  - containerize-application
  - setup-ci-cd
  - deploy-to-kubernetes
```

### Product Dev Profile

```yaml
# profiles/product-dev/profile.yaml
agents:
  - api-designer
  - ui-component-builder
  - database-architect
  - test-generator

workflows:
  - create-rest-api
  - build-ui-feature
  - design-database-schema
```

### Data Eng Profile

```yaml
# profiles/data-eng/profile.yaml
agents:
  - pipeline-builder
  - data-quality-checker
  - transformation-designer
  - schema-validator

workflows:
  - build-data-pipeline
  - validate-data-quality
  - design-transformation
```

---

## Testing Your Profile

### 1. Syntax Validation

```bash
# Validate YAML
yamllint profile.yaml

# Validate Markdown
markdownlint *.md agents/*.md
```

### 2. Structure Validation

```bash
# Run profile validator
./scripts/validate-profile.sh your-domain
```

Expected output:
```
✓ Checking structure...
✓ Validating YAML...
✓ Checking profile.yaml structure...
✓ Validating agents...
✓ Checking README...
✅ Profile validation complete
```

### 3. Installation Test

```bash
# Install profile
./scripts/install.sh --profile your-domain

# Verify installation
ls ~/.agentops/profiles/your-domain/
```

### 4. Functional Test

```bash
# Use profile
/prime
# Should load your profile

# Test agent
# (Use your custom agent)

# Test workflow
# (Execute your workflow)
```

---

## Sharing Your Profile

### 1. Document Well

- Clear README (this file)
- Example usage
- Requirements
- Troubleshooting

### 2. Add Examples

```markdown
## Example Usage

\```bash
# Create new [domain] project
/prime
/research "[domain] project structure"
/plan [domain]-research.md
/implement [domain]-plan.md
\```
```

### 3. Publish to GitHub

```bash
git add profiles/your-domain/
git commit -m "feat(profiles): Add your-domain profile"
git push
```

### 4. Submit to Catalog (Future)

When profile catalog launches:

```bash
agentops profile publish your-domain
```

---

## Profile Versioning

Follow semantic versioning:

### Version Format

```
MAJOR.MINOR.PATCH
1.0.0
```

- **MAJOR:** Breaking changes (2.0.0)
- **MINOR:** New features (1.1.0)
- **PATCH:** Bug fixes (1.0.1)

### Update profile.yaml

```yaml
metadata:
  version: 1.1.0
  changelog: |
    v1.1.0: Added kubernetes-debugger agent
    v1.0.1: Fixed validation script bug
    v1.0.0: Initial release
```

---

## Common Patterns

### Pattern 1: Single Domain Focus

Best for specific tech stacks:

```yaml
# Kubernetes profile
agents: [kubernetes-specific agents only]
workflows: [K8s deployment workflows]
```

### Pattern 2: Multi-Tool Domain

For domains spanning multiple tools:

```yaml
# DevOps profile (many tools)
agents:
  - kubernetes-agents
  - docker-agents
  - ci-cd-agents
  - monitoring-agents
```

### Pattern 3: Organization-Specific

Internal company patterns:

```yaml
# Acme Corp DevOps
agents: [company-standard agents]
workflows: [company processes]
skills: [company validation]
```

---

## Troubleshooting

### Profile not loading

**Check:**
```bash
ls ~/.agentops/profiles/your-domain/
```

**Fix:**
```bash
./scripts/install.sh --profile your-domain
```

### Validation fails

**Check:**
```bash
./scripts/validate-profile.sh your-domain
```

**Common issues:**
- Missing `extends: core` in profile.yaml
- Agent files don't exist
- YAML syntax errors

### Agents not working

**Check:**
- Agent files have correct frontmatter
- Model specified (sonnet/opus)
- Tools list provided

---

## Best Practices

### Do ✅
- Start with this template
- Extend core, don't replace
- Document domain assumptions
- Provide working examples
- Test thoroughly
- Version properly

### Don't ❌
- Break core compatibility
- Hardcode values
- Skip documentation
- Ignore validation
- Forget error handling

---

## Support

- **Documentation:** `docs/CREATE_PROFILE.md`
- **Extension Guide:** `docs/EXTEND_CORE.md`
- **Validation:** `scripts/validate-profile.sh`
- **Community:** [forum-link]
- **Issues:** [github-issues]

---

## License

Apache-2.0 - Same as AgentOps core

---

## Next Steps

1. **Copy this template:** `cp -r profiles/example profiles/your-domain`
2. **Edit profile.yaml:** Change name, description, agents
3. **Create agents:** Add domain-specific personas
4. **Test:** `./scripts/validate-profile.sh your-domain`
5. **Install:** `./scripts/install.sh --profile your-domain`
6. **Use:** `/prime`
7. **Share:** Publish and contribute back

**Happy profile building!**
