# Pattern: Context Bundles

**Abstract:** Compress intermediate artifacts (research, plans) for reuse across sessions and teams.

**Compression ratio:** 5:1 to 10:1 (5-10k tokens → 500-1k tokens)

**Domains validated:** Product development, Infrastructure/DevOps

---

## The Pattern

```
Raw output: research.md (5-10k tokens)
  ↓ [Extract key findings, remove exploration notes]
Compressed: research-bundle.md (500-1k tokens)
  ↓ [Store in .agents/bundles/]
Reusable: Load in any future session
  ↓ [Share via UUID with team]
Team reuse: Prevent duplicate research
```

---

## Why It Works

**Problem 1:** Research one day, need it next day, starting fresh context

**Solution:** Save compressed research as bundle, load in new session

**Problem 2:** Multiple team members research the same topic

**Solution:** Bundle discovery prevents "I already researched this"

**Problem 3:** Raw research is verbose, wastes context

**Solution:** Compression extracts only key findings (5:1 ratio)

---

## What Compresses Well

**Good candidates for bundles:**
- Research findings (explorations, approaches evaluated)
- Infrastructure analysis (architecture decisions, constraints)
- Incident postmortems (root cause, learnings)
- Specification drafts (design before implementation)

**Not candidates:**
- Working notes (stream of consciousness, keep in notes)
- Code files (keep in git, not bundles)
- Large datasets (should be in database)

---

## Implementation in Commands

### Save Bundle

```bash
/research "Your question"
# Output: research.md (verbose, exploratory)

/bundle-save research-topic-name
# Compresses research.md → bundle (1-2k tokens)
# Stores: .agents/bundles/research-topic-name.md
# Metadata: created date, tags, UUID
```

### Load Bundle

```bash
/bundle-load research-topic-name
# Loads bundle into context (500-1k tokens)
# Metadata shows: compression ratio, when created, who created
# Can load in fresh session (different day)
```

### List Bundles

```bash
/bundle-list                          # Show all
/bundle-list --tag redis              # Find redis-related
/bundle-list --recent                 # 5 most recent
/bundle-list --tag redis --small      # Filter by tag and size
```

---

## Example Compression

### Before (Research output - verbose)
```markdown
# Redis Research

## Exploration 1: Tried Redis cluster
- Setup is complex
- Requires sentinel
- Pros: high availability
- Cons: operational overhead

## Exploration 2: Tried Memcached
- Simpler setup
- No persistence
- Pros: lightweight
- Cons: data loss on restart

## Exploration 3: Local cache
- Tested in-process caching
- No network overhead
- Pros: fast
- Cons: not distributed

## Findings
Redis recommended: 3x faster than memcached, HA capability

## Architecture Decision
- Use Redis with pub/sub for invalidation
- Circuit breaker for fallback
- TTL <= 3600s for safety

[5-10k tokens raw output]
```

### After (Compressed bundle)
```markdown
# Redis Caching - Key Findings

## Recommendation
Use Redis with pub/sub cache invalidation (3x faster than memcached)

## Approaches Evaluated
1. Redis cluster (recommended)
2. Memcached (too simple)
3. Local cache (not distributed)

## Key Constraints
- Circuit breaker required
- TTL <= 3600s
- 500MB memory limit

## Implementation Readiness
✅ Existing redis config in infrastructure/
✅ API already has cache interface
✅ Ready to plan deployment

[1-2k tokens compressed]
```

**Compression ratio: ~5:1**

---

## Team Coordination Example

**Alice researches Redis:**
```bash
/research "Redis caching implementation"
/bundle-save redis-caching-research
# Creates: .agents/bundles/redis-caching-research.md
# UUID: bundle-abc123def456
git add .agents/bundles/ && git commit
```

**Bob discovers it:**
```bash
/bundle-list --tag redis
# Shows: redis-caching-research (2 days old, accessed 3 times)

/bundle-load redis-caching-research
# Uses Alice's research, no re-research needed
```

**Carol avoids duplicate:**
```bash
/bundle-list --tag caching
# Shows: redis-caching-research (already done)
# Skips redundant research
```

---

## Metrics

| Metric | Measurement |
|--------|------------|
| Compression ratio | 5:1 to 10:1 consistently |
| Token savings per reuse | 4-9k tokens (raw research cost) |
| Team coordination | UUID-based sharing |
| Storage overhead | ~1k per bundle |
| Discoverability | Tag-based search |

---

## Storage & Persistence

### Local Storage (Default)
```
.agents/bundles/
├── redis-caching-research.md
├── postgres-migration-plan.md
├── incident-2025-11-postmortem.md
└── index.json (metadata)
```

Stored in git, version controlled, team-shareable

### Optional: PostgreSQL (Future)
```sql
bundles (
  uuid,
  name,
  content,
  tokens,
  tags,
  created_by,
  created_at,
  accessed_count,
  compression_ratio
)
```

Enables team-wide search without cloning

---

## Bundle Lifecycle

**Create:** `/bundle-save [name]`
**Access:** `/bundle-load [name]` or `/bundle-list --tag [tag]`
**Update:** `/bundle-save [name]` (overwrites)
**Version:** `/bundle-save [name]-v2` (new bundle)
**Archive:** `rm .agents/bundles/[name].md && git commit`

---

## Best Practices

**Do:**
- ✅ Name bundles descriptively (`redis-caching-research`, not `stuff`)
- ✅ Tag bundles for discovery (`--tag redis`, `--tag caching`)
- ✅ Save after research phase completes
- ✅ Load at start of planning phase
- ✅ Share UUIDs with team

**Don't:**
- ❌ Create bundles for everything (just key findings)
- ❌ Save uncompressed raw output (defeats purpose)
- ❌ Use cryptic names (future you won't find it)
- ❌ Commit bundle changes per-line (atomically)

---

## Cross-Domain Usage

| Domain | Bundle Type | Size | Reuse Scenario |
|--------|------------|------|-----------------|
| Product | Spec drafts | 1-2k | Review before implementation |
| DevOps | Research | 1.2k | Multiple teams using same finding |
| SRE | Postmortem | 0.8k | Reference for similar incidents |
| Data | Schema analysis | 1.5k | Reference for new pipelines |

---

## See Also

- `phase-based-workflow.md` - Phases output bundles
- Commands: `/bundle-save`, `/bundle-load`, `/bundle-list`
- Pattern: Used with `/research` → `/bundle-save` → `/bundle-load` → `/plan`
