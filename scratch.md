  1. What components get installed?
    - .claude/ directory structure (settings.json, agents/,
  commands/, skills/)?
    - CONSTITUTION.md at project root?
    - CLAUDE.md kernel file?
    - Any scripts or utilities?
    - Git hooks or templates?
  2. Should installation be additive or complete replacement?
    - If .claude/ already exists, merge
    - How to handle existing settings.json? add
    - Preserve user customizations? yes

  Target Projects & Use Cases

  3. What types of projects should this support?
    - Existing git repos only?
    - New projects (not yet git initialized)?
    - Any programming language?
    - single repos with flavor per repo task (ie devops/spec driven dev)
  4. Primary user personas?
    - Individual developers installing for personal use?
    - Team leads installing for team adoption?
    - Both? Diff per flow

  Prerequisites & Dependencies

  5. Required prerequisites?
    - Git (what minimum version)?
    - Claude Code CLI (must be installed first)?
    - Python/Shell (which version)? use uv for this. pick a stable
    - Any other tools?
  6. How to handle missing prerequisites?

    - Check and auto-install?


  Makefile Interface

  1. Desired Makefile targets?
    - make install (base installation)?
    - make install-profile PROFILE=devops (with profile)?
    - make uninstall (clean removal)?
    - make verify (test installation)?
    - make update (upgrade existing installation)?
    - make doctor
  2. Make target behavior?
    - Should targets be idempotent (safe to run multiple times)? yes
    - Verbose output or quiet by default? descriptive
    - Dry-run option (make install DRY_RUN=1)? no

  Script Backend

  9. Script language preference?
    - Bash (more universal, simpler)?

  10. Platform compatibility strategy?
    - Single script with platform detection?
    - What macOS/Linux/windows

  Configuration & Customization

  1.  How should users customize installation?
    - Interactive prompts during install (ask questions)?
    - Config file (install.config.json)?
    - Combination of above?
  2.  What should be customizable?
    - Default model (opus/sonnet)?
    - Profile selection?
    - Project name/metadata?
    - Permissions?
    - Git hooks?

  Profile System

  13. Profile installation options?

    - Let user choose during install (interactive)?

  14. Where do profiles live?
    - Copy from agentops/profiles/ to user project?
    - Symlink to agentops repo?
    - Download from remote?
    - All of above as options?

  Validation & Testing

  15. How to verify successful installation? you decide
    - Check files exist?
    - Validate YAML/JSON syntax?
    - Test Claude Code can load settings?
    - Run sample agent?
    - What makes a "successful" install?
  16. What about post-install testing?
    - make verify target to run tests?
    - make test-agent AGENT=hello-world smoke test?


  Edge Cases & Constraints

  1.  How to handle installation in agentops repo itself?
    - Should it detect "you're already in agentops" and skip?
    - Different behavior for dogfooding? should just work and be idempotent. like my harmonize script in release-engineering
  2.  Dec 1 launch constraints? full scope dec 1 and iterate and improve after
    - Must this be feature-complete by Dec 1?
    - MVP scope vs full-featured scope?
    - Can we ship iteratively post-launch?
