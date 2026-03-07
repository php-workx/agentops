# Handoffs

Session handoff artifacts for continuity across sessions.

## Naming Convention
- `handoff-*.json` — machine-readable handoff state
- `*.md` — human-readable handoff notes
- `*.consumed.json` — already consumed by a session

## Search
- `Grep` in `.agents/handoff/` for goals or topics
- Most recent: `ls -t .agents/handoff/*.md | head -1`
