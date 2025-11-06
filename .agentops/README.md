# AgentOps Operational Documentation

This folder contains the **operational foundation** for the AgentOps repository.

---

## Start Here

### [MISSION.md](MISSION.md)
**Read this first.** Constitutional Principle #0 and how we execute it.

- What we build (reference implementation)
- How we operationalize at every scale
- Educational ecosystem vision
- Why this approach works
- Success metrics

---

## Files in This Folder

| File | Purpose |
|------|---------|
| **MISSION.md** | Constitutional mission and execution strategy |

---

## Related Documentation

### In This Repository
- **README.md** - Overview of AgentOps as an orchestrator
- **CONSTITUTION.md** - The Six Laws, Three Rules, 40% Rule that govern all work
- **docs/** - How-to guides, tutorials, patterns, case studies

### In 12-Factor AgentOps
- **[12-factor-agentops/.agentops/MISSION.md](../../12-factor-agentops/.agentops/MISSION.md)** - Framework/theory layer mission
- **[12-factor-agentops/README.md](../../12-factor-agentops/README.md)** - Foundational philosophy and patterns

---

## Quick Navigation

**If you want to...**

| Goal | Start Here |
|------|-----------|
| Understand our mission | MISSION.md |
| Learn the laws that govern work | CONSTITUTION.md |
| Use AgentOps immediately | README.md → Quick Start |
| Understand patterns deeply | 12-factor-agentops/README.md |
| Create a new workflow | docs/how-to/CREATE_CUSTOM_PROFILE.md |
| See what's proven to work | docs/case-studies/ |
| Understand the theory | 12-factor-agentops/foundations/ |

---

## The Mission (TL;DR)

**Invite people to operationalize AI reliably, at whatever scale they're at, with patterns forged where failure is unacceptable.**

This means:
- ✅ Patterns proven at federal scale (hardest constraints)
- ✅ Accessible at personal → team → org → institutional → human scales
- ✅ Built in public with community (not proprietary)
- ✅ Teach operational thinking (not just tools)
- ✅ Stay honest (what works, what doesn't, what we're testing)

---

## Architecture

```
12-Factor AgentOps
    ↓ (theory → reference implementation)
AgentOps
    ↓ (reference → domain-specific implementations)
Your Implementation
    ↓ (patterns + adaptations)
Community Learning
```

**12-Factor AgentOps** = Why patterns work (learning science, philosophy)
**AgentOps** = How patterns work (reference implementation, examples)
**Your Work** = Where patterns apply (your domain, your context)

---

## Philosophy

### Why This Approach

**Patterns Forged in Federal Operations**
- Tested under hardest constraints (disconnected, security-hardened, mission-critical)
- If patterns work there, they generalize everywhere

**Building in Public**
- You see the thinking, not polished marketing
- Participate at inception, shape the framework
- Help test if patterns work in YOUR domain

**Educational Ecosystem**
- Make operational thinking accessible at every scale
- Not gatekept or proprietary
- Available everywhere AI is being built

**Honest About Status**
- Alpha: Patterns proven, framework generalizing
- Testing hypothesis: Do federal patterns work elsewhere?
- Seeking validation: Help us understand scope and limits

---

## Next Steps

1. **Read MISSION.md** - Understand what we're building
2. **Check out README.md** - See AgentOps architecture
3. **Choose your entry point:**
   - Want to build? → docs/how-to/
   - Want to understand? → 12-factor-agentops/
   - Want examples? → docs/case-studies/
4. **Try a pattern** - Fork an example, adapt it
5. **Report back** - What worked? What didn't? What changed?

---

## Constitutional Foundation

Everything in this repository serves this mission and operates under these laws:

- **Law 1:** ALWAYS Extract Learnings
- **Law 2:** ALWAYS Improve Self or System
- **Law 3:** ALWAYS Document Context for Future Agents
- **Law 4:** ALWAYS Prevent Hook Loops
- **Law 5:** ALWAYS Guide with Workflow Suggestions
- **Law 6:** ALWAYS Create Git-Auditable Artifacts

See CONSTITUTION.md for details.

---

## Contributing

**This is open source built in public. Your feedback shapes the framework.**

Ways to contribute:
- ✅ Try patterns in your domain, report what works
- ✅ Create case studies showing patterns in action
- ✅ Propose adaptations for your constraints
- ✅ Help document patterns and learnings
- ✅ Challenge assumptions, ask hard questions

---

*Built to make AI agents as reliable as the infrastructure they run on.*
