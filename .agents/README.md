# AI Memory System

This directory contains persistent context for AI-assisted development.

## Directory Structure

| Directory | Purpose | Lifecycle |
|-----------|---------|-----------|
| `research/` | Deep exploration before planning | Created by /research |
| `plans/` | Implementation roadmaps | Created by /plan |
| `patterns/` | Reusable solutions | Extracted from production |
| `learnings/` | Session insights | Created by /retro |
| `retros/` | Session retrospectives | Created by /retro |
| `blackboard/` | Multi-session state | Updated during work |
| `reports/` | Validation outputs | Created by validation |
| `schemas/` | JSON Schema for frontmatter | Reference only |
| `archive/` | Superseded documents | Moved when outdated |
| `bundles/` | Context bundles for /bundle-load | Loaded on demand |

## Document Naming

- Research: `YYYY-MM-DD-<topic>.md`
- Plans: `YYYY-MM-DD-<topic>-plan.md`
- Patterns: `<pattern-name>.md`
- Learnings: `YYYY-MM-DD-<topic>.md`

## Frontmatter Schema

All documents use YAML frontmatter:

```yaml
---
date: YYYY-MM-DD
type: Research | Plan | Pattern | Learning | Retro
topic: "Human-readable title"
tags: [type-tag, domain-tag, tech-tag]
status: DRAFT | IN_PROGRESS | COMPLETE | ACTIVE | DEPRECATED
---
```
