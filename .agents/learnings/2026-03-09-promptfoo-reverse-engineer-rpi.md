---
id: 2026-03-09-promptfoo-reverse-engineer-rpi
date: 2026-03-09
tags: [reverse-engineer-rpi, promptfoo, evidence, discovery]
---

When reverse-engineering a product or workflow, keep documentation-derived
inventory separate from code, binary, or runtime evidence. Docs can suggest
what probably exists, but they do not prove that a hosted service, control
plane feature, or integration is actually implemented in the target system.
Mark those areas as unknown until source, tests, traces, or shipped artifacts
confirm them, so plans and findings stay honest about what has really been
verified.
