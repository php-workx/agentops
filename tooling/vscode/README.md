# VS Code Workspace Blueprint

Reusable, open-source templates for the AgentOps working environment.

## Quick Start

1) Copy `workspace.template.code-workspace` to your repo root as `workspace.code-workspace`.
2) Optionally copy `keybindings.template.json` to `.vscode/keybindings.json` in your repo.
3) Open the workspace via `File > Open Workspace from File...`.
4) Arrange editors once via `View > Editor Layout > Three Columns` — layout persists per workspace.

## What’s Included

- Layout defaults: 3-column editors, panel/terminal docked on the right, restores on reopen
- Multi-root folders: curated, emoji-friendly structure for code + docs + ops
- File hygiene: excludes, search/watcher tuning, rulers, side-by-side diffs
- YAML/Ansible authoring: Kubernetes schemas, formatting, validation
- Git UX: safe defaults and clear notifications
- Extensions: curated recommendations for this workflow
- Example task: aggregated git status across multiple repos

## Notes

- OS window tiling/positions across multiple VS Code windows are managed by your OS window manager.
- Paths are generic; customize folders to match your repo layout.
- Workspace keybindings are optional; place `keybindings.template.json` into `.vscode/` to enable.

