# .agents Directory Guide

Use this directory as a navigation surface, not a place to guess. Prefer the CLI first:

- `ao lookup --query "topic"` for learnings retrieval.
- `ao search` for session and transcript search.
- `rg "topic" .agents/` as a fallback when you need raw grep across stored artifacts.

## Knowledge

- `learnings/` holds extracted lessons. Use `YYYY-MM-DD-*.md` filenames.
- `findings/` holds the canonical finding surfaces: `registry.jsonl` is the intake ledger, and promoted `.md` artifacts are the durable cross-repo/search surface.
- `patterns/` holds reusable patterns. Use `kebab-case.md` filenames.
- `research/` holds deeper investigations and writeups. Use `YYYY-MM-DD-*.md` filenames.
- `retros/` holds retrospectives and summary reflections. Prefer date-prefixed Markdown names such as `YYYY-MM-DD-*.md`.
- `knowledge/` holds pending knowledge-processing inputs. Keep filenames descriptive and preserve incoming names until processed.

## Workflow

- `brainstorm/` holds structured brainstorm outputs from `/brainstorm`. Use `YYYY-MM-DD-*.md` filenames.
- `plans/` holds implementation plans. Use `YYYY-MM-DD-*.md` filenames.
- `planning-rules/` holds compiled advisory rules that `/plan` should consume before decomposition.
- `handoff/` holds session handoffs. Use `handoff-*.json` for machine-readable handoff state and `*.md` for human-readable notes.
- `pre-mortem-checks/` holds compiled advisory checks that `/pre-mortem` should load before judgment.
- `rpi/` holds pipeline state and scheduler outputs. Expect operational state files such as `next-work.jsonl` plus timestamped artifacts.
- `ao/` holds internal AgentOps session state. Do not read or edit this directly unless you are working on runtime internals.

## Validation

- `council/` holds council validation reports. Use `YYYY-MM-DD-*.md` filenames.
- `constraints/` holds compiled mechanical rules. `constraints/index.json` is the canonical executable surface, and `constraints/*.sh` are human-reviewable companions only.

## Usage Notes

- Reach for `ao lookup` before browsing Markdown by hand when you want prior lessons.
- Reach for `ao search` before opening handoffs or transcripts one by one.
- Use grep in `.agents/` when the CLI does not surface what you need or when you are validating exact strings.
- Keep new files aligned with the naming convention of their target directory.
- Avoid adding directory summaries that depend on hardcoded counts or inventory snapshots.
