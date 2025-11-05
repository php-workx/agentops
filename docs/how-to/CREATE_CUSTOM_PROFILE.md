# Creating a Custom AgentOps Profile

**Guide for creating a new profile for your domain**

---

## Overview

AgentOps framework = universal architecture + customizable profiles

This guide shows how to create a profile for your specific domain.

---

## What's a Profile?

A profile specializes agentops for your domain:

```
Core Kernel (Non-negotiable)
  ↓
Universal Architecture (Multi-phase, bundles, orchestration, routing)
  ↓
YOUR PROFILE (Domain specialization)
  ├── Agents (8-50 specialized for your domain)
  ├── Commands (Phase-based workflows)
  ├── Workflows (Domain patterns)
  └── Standards (Domain best practices)
```

---

## Step 1: Understand Your Domain

### Ask These Questions:

1. **What problems does your domain solve?**
   - Product-dev: "How do we build features faster?"
   - Infrastructure: "How do we deploy safely?"
   - SRE: "How do we respond to incidents?"
   - Your domain: "___?"

2. **What types of agents would help?**
   - Product: product-planner, spec-writer, implementer
   - Infrastructure: app-creator, site-configurator, debugger
   - SRE: incident-responder, postmortem-analyzer
   - Your domain: ___?, ___?, ___?

3. **What's the typical workflow?**
   - Product: mission → specs → tasks → code
   - Infrastructure: research → plan → manifests
   - SRE: detect → investigate → document
   - Your domain: ___ → ___ → ___?

4. **What terminology matters?**
   - Product: features, specs, roadmap, user stories
   - Infrastructure: manifests, configs, deployments, sites
   - SRE: incidents, metrics, SLOs, runbooks
   - Your domain: ___?, ___?, ___?

### Document Your Answers

```markdown
# [Domain Name] Profile Planning

## Domain Problems
[What does your domain try to solve?]

## Agent Types Needed
[What specialized agents would help?]

## Typical Workflow
[How do tasks flow in your domain?]

## Key Terminology
[What language does your domain use?]
```

---

## Step 2: Design Your Agents

### Agent Template

Create agents for your domain:

```markdown
---
name: [agent-name]
description: [What this agent does]
tools: [Tools available]
---

You are a [specialist] for [domain] work.

## Responsibilities

1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

## Workflow

### Step 1: [Phase]
{{workflows/[path]/[workflow]}}

### Step 2: [Phase]
{{workflows/[path]/[workflow]}}

## Next Steps

[Guidance on what to do with output]
```

### Identify Agent Types

Map to universal phases:

| Universal | Your Domain |
|-----------|------------|
| Research agent | Domain explorer agent |
| Plan agent | Domain specification agent |
| Implement agent | Domain execution agent |
| Router agent | Domain classifier agent |

**Example (SRE profile):**
- Incident detector (phase 1: detect problems)
- Root cause analyzer (phase 2: investigate)
- Postmortem writer (phase 3: document)
- Alert router (phase 0: classify alerts)

---

## Step 3: Create Profile Structure

```
agentops/profiles/[your-domain]/
├── README.md (Profile overview)
├── agents/
│   ├── [agent-1].md
│   ├── [agent-2].md
│   └── ...
├── commands/
│   ├── [workflow-1].md
│   ├── [workflow-2].md
│   └── ...
├── workflows/
│   ├── [phase-1]/
│   │   └── [workflow].md
│   ├── [phase-2]/
│   │   └── [workflow].md
│   └── [phase-3]/
│       └── [workflow].md
└── standards/
    ├── [standard-1].md
    └── [standard-2].md
```

---

## Step 4: Follow Universal Patterns

Your profile must include:

### Pattern 1: Multi-Phase Workflow

Implement 3 phases for complex work:

```bash
/research [domain question]
  ↓ (Phase 1: Explore and understand)
/plan research-[name].md
  ↓ (Phase 2: Specify and plan)
/implement plan-[name].md
  ↓ (Phase 3: Execute and validate)
```

### Pattern 2: Context Bundles

Support bundle save/load:

```bash
/research [question]
/bundle-save [research-name]
# ...later...
/bundle-load [research-name]
/plan research-[name].md
```

### Pattern 3: Multi-Agent Orchestration

Support parallel agents (optional but recommended):

```bash
/[research-type]-multi [question]
  # Multiple agents research simultaneously
```

### Pattern 4: Intelligent Routing

Support auto-routing to agents:

```bash
/prime-with-routing "Your [domain] task"
  # Auto-recommends agent
```

---

## Step 5: Document Your Profile

### Profile README

```markdown
# [Domain Name] Profile

**Specialization:** [What this profile does]
**Use when:** [When to use this profile]
**Key domains:** [Specific areas covered]

## Overview
[Brief description]

## Agents
[List of agents with descriptions]

## Patterns
[Domain-specific patterns]

## Workflows
[Typical workflows]

## Real Example
[Show a real task walkthrough]

## Metrics
[How you measure success]
```

### Agent Documentation

Each agent needs:
- Clear description
- Responsibilities
- Workflow steps
- Next steps
- Examples

---

## Step 6: Validate Your Profile

### Test with Real Work

Use your profile for actual tasks:

1. **Try phase-based workflow:**
   - /research [real question]
   - /plan research.md
   - /implement plan.md

2. **Try bundles:**
   - /bundle-save [findings]
   - /bundle-load [findings]

3. **Try intelligent routing:**
   - /prime-with-routing [real task]

4. **Measure improvements:**
   - Time saved vs manual work
   - Bundles reused (duplicate research prevented)
   - Agent routing accuracy

### Document Results

```markdown
# [Domain] Profile Validation

## Test Results

### Phase-Based Workflow
- Task: [real task]
- Time: [research time] + [plan time] + [implement time]
- Result: ✅ Works well

### Context Bundles
- Bundles created: [number]
- Bundles reused: [number]
- Time saved: [calculation]

### Intelligent Routing
- Tasks: [number]
- Routing accuracy: [percentage]
- Override rate: [percentage]

## Metrics
[Quantified improvements]
```

---

## Step 7: Share Your Profile

When validated:

1. **Create case study** (`docs/case-studies/[domain]-profile.md`)
2. **Document learnings** (what worked, what didn't)
3. **Contribute to project** (share with community)
4. **Build agent library** (expand over time)

---

## Profile Checklist

- [ ] Identified domain problems
- [ ] Designed 5+ specialized agents
- [ ] Created agent files with documentation
- [ ] Implemented multi-phase workflow
- [ ] Added bundle support (save/load/list)
- [ ] Added intelligent routing
- [ ] Created profile README
- [ ] Tested with real work
- [ ] Documented metrics
- [ ] Created case study
- [ ] Ready to share

---

## Common Profiles to Create

### SRE Profile
- Agents: incident-responder, analyzer, postmortem-writer
- Workflow: detect → investigate → document
- Metrics: MTTR, incident count, prevention

### Data Engineering Profile
- Agents: schema-designer, pipeline-builder, validator
- Workflow: design → implement → validate
- Metrics: pipeline uptime, data quality, latency

### Marketing Profile
- Agents: campaign-planner, content-writer, analyzer
- Workflow: research → plan → execute
- Metrics: engagement, conversion, ROI

### Your Domain Profile
- Agents: ___?, ___?, ___?
- Workflow: ___ → ___ → ___?
- Metrics: ___?, ___?, ___?

---

## Resources

- `agentops/architecture/` - Universal patterns
- `agentops/profiles/product-dev/` - Product profile (reference)
- `agentops/profiles/devops/` - Infrastructure profile (reference)
- `pattern-extraction-methodology.md` - How to identify patterns

---

## Example: Creating SRE Profile

### Step 1: Domain Analysis
```
Problems: Incidents take too long to resolve
Agents: Detect, Analyze, PostmortemWrite
Workflow: Detect incident → Investigate → Document learnings
Terminology: MTTR, SLO, postmortem, runbook
```

### Step 2: Create Agents

```markdown
# incident-responder.md
## Responsibilities
1. Analyze incident alert
2. Gather system information
3. Identify root cause
4. Recommend remediation
```

### Step 3: Create Workflows

```markdown
# detect-incident.md
## Step 1: Receive Alert
[Detailed guidance]

# investigate-incident.md
## Step 1: Gather Data
[Detailed guidance]

# write-postmortem.md
## Step 1: Summarize Timeline
[Detailed guidance]
```

### Step 4: Document Profile

```markdown
# SRE Profile

**Specialization:** Incident Response

## Typical Workflow
1. /research "What caused this incident?"
2. /plan investigation-findings.md
3. /implement postmortem-plan.md

## Metrics
- MTTR: [target]
- Postmortem completion: [target]
- Prevention rate: [target]
```

### Step 5: Validate and Share

Test with real incidents, document metrics, share with team.

---

## Success Looks Like

✅ Agents are used for real work
✅ Workflows feel natural for domain
✅ Bundles prevent duplicate research
✅ Intelligent routing works (>80% accuracy)
✅ Team adopts profile
✅ Metrics show improvement

---

## Next Steps

1. **Answer Step 1 questions** (understand your domain)
2. **Design agents** (Step 2)
3. **Create structure** (Step 3)
4. **Implement patterns** (Step 4)
5. **Validate** (Step 6)
6. **Share case study** (Step 7)

Start with one profile. Build your library over time.
