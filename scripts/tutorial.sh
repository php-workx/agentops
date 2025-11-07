#!/usr/bin/env bash
#
# AgentOps Interactive Tutorial
# 5-minute guided experience teaching multi-profile usage
#

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
if [[ -f "${SCRIPT_DIR}/lib/common-functions.sh" ]]; then
    # shellcheck source=./lib/common-functions.sh
    source "${SCRIPT_DIR}/lib/common-functions.sh"
elif [[ -f "${HOME}/.agentops/scripts/lib/common-functions.sh" ]]; then
    # shellcheck source=./lib/common-functions.sh
    source "${HOME}/.agentops/scripts/lib/common-functions.sh"
else
    echo "ERROR: Cannot find common-functions.sh library" >&2
    exit 1
fi

# Tutorial workspace
TUTORIAL_DIR="${HOME}/.agentops/tutorial"

#######################################
# Wait for user to press Enter
#######################################
wait_for_user() {
    local prompt="${1:-Press Enter to continue...}"
    echo ""
    read -r -p "$prompt "
    echo ""
}

#######################################
# Print tutorial section header
#######################################
section_header() {
    local title="$1"
    echo ""
    echo "=========================================="
    print_color blue "$title"
    echo "=========================================="
    echo ""
}

#######################################
# Run command and show output
#######################################
demo_command() {
    local description="$1"
    local command="$2"

    echo ""
    print_color yellow "→ $description"
    print_color blue "$ $command"
    echo ""

    # Run command
    eval "$command"

    wait_for_user
}

#######################################
# Tutorial Introduction
#######################################
tutorial_intro() {
    clear
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   AgentOps Interactive Tutorial       ║"
    echo "║   Duration: ~5 minutes                 ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    info "Welcome to AgentOps!"
    echo ""
    echo "This tutorial will teach you:"
    echo "  1. How to use multiple profiles"
    echo "  2. How profile resolution works"
    echo "  3. How to switch between profiles"
    echo "  4. How to install profiles in projects"
    echo ""

    wait_for_user "Press Enter to begin..."
}

#######################################
# Section 1: Profile Basics
#######################################
tutorial_profiles() {
    section_header "Section 1: Understanding Profiles"

    echo "AgentOps uses PROFILES to organize workflows by domain."
    echo ""
    echo "Think of profiles like Kubernetes contexts:"
    echo "  - product-dev: Application development"
    echo "  - infrastructure-ops: Operations & monitoring"
    echo "  - devops: Complete GitOps ecosystem"
    echo "  - life: Personal development"
    echo ""

    wait_for_user

    demo_command \
        "List all installed profiles:" \
        "agentops list-profiles"

    demo_command \
        "View details about a profile:" \
        "agentops profile-info product-dev"
}

#######################################
# Section 2: Profile Resolution
#######################################
tutorial_resolution() {
    section_header "Section 2: Profile Resolution Chain"

    echo "AgentOps resolves the active profile using a 4-layer chain:"
    echo ""
    echo "  1. Explicit flag: --profile devops"
    echo "  2. Environment: AGENTOPS_PROFILE=infrastructure-ops"
    echo "  3. Project config: .agentops/config.yml"
    echo "  4. User default: ~/.agentops/.profile"
    echo ""
    echo "This prevents conflicts when multiple profiles are installed."
    echo ""

    wait_for_user

    demo_command \
        "Check your current default profile:" \
        "agentops current-profile"

    echo "Let's change your default profile:"
    echo ""

    demo_command \
        "Set default to product-dev:" \
        "agentops use-profile product-dev"

    demo_command \
        "Verify the change:" \
        "agentops current-profile"

    echo ""
    info "The default profile is stored in: ~/.agentops/.profile"
    echo ""

    wait_for_user
}

#######################################
# Section 3: Environment Override
#######################################
tutorial_environment() {
    section_header "Section 3: Using Environment Variables"

    echo "You can override the default profile using AGENTOPS_PROFILE:"
    echo ""

    demo_command \
        "Current profile (default):" \
        "agentops current-profile"

    demo_command \
        "Override with environment variable:" \
        "AGENTOPS_PROFILE=devops agentops current-profile"

    echo ""
    info "Notice how the profile changed without modifying the default!"
    echo ""
    echo "This is useful for:"
    echo "  - Switching contexts temporarily"
    echo "  - Running scripts with specific profiles"
    echo "  - Testing different profile configurations"
    echo ""

    wait_for_user
}

#######################################
# Section 4: Project Installation
#######################################
tutorial_project() {
    section_header "Section 4: Installing in Projects"

    echo "Let's create a test project and install AgentOps into it."
    echo ""

    # Create tutorial workspace
    mkdir -p "$TUTORIAL_DIR"
    cd "$TUTORIAL_DIR"

    demo_command \
        "Create test project directory:" \
        "mkdir -p test-project && cd test-project && pwd"

    cd test-project

    demo_command \
        "Initialize git repository:" \
        "git init"

    demo_command \
        "Create CLAUDE.md (makes it a Claude Code project):" \
        "echo '# Test Project' > CLAUDE.md"

    echo ""
    info "Now let's install AgentOps with the devops profile:"
    echo ""

    # Install non-interactively
    demo_command \
        "Install AgentOps with devops profile:" \
        "${SCRIPT_DIR}/project-install.sh devops <<< 'yes' 2>/dev/null || true"

    wait_for_user "Check what was created..."

    demo_command \
        "View project structure:" \
        "ls -la"

    demo_command \
        "View AgentOps config:" \
        "cat .agentops/config.yml"

    demo_command \
        "View Claude Code commands:" \
        "ls .claude/commands/ | head -10"
}

#######################################
# Section 5: Multi-Profile Usage
#######################################
tutorial_multi_profile() {
    section_header "Section 5: Using Multiple Profiles"

    echo "The key feature: You can install ALL profiles without conflicts!"
    echo ""
    echo "Resolution chain prevents ambiguity:"
    echo "  - Project config specifies profile"
    echo "  - Or use environment variable"
    echo "  - Or use explicit flag"
    echo ""

    wait_for_user

    echo "In our test project:"
    echo ""

    demo_command \
        "Check active profile (from project config):" \
        "cd ${TUTORIAL_DIR}/test-project && cat .agentops/config.yml | grep profile:"

    echo ""
    info "Project is configured for 'devops' profile"
    echo ""
    echo "But you can override it:"
    echo ""

    demo_command \
        "Use environment to switch to product-dev:" \
        "AGENTOPS_PROFILE=product-dev agentops current-profile"

    echo ""
    info "The project config wasn't changed, just overridden temporarily!"
    echo ""

    wait_for_user
}

#######################################
# Section 6: Validation
#######################################
tutorial_validation() {
    section_header "Section 6: Validating Installation"

    echo "AgentOps includes a validation framework:"
    echo ""
    echo "  Tier 1: Core Files - Essential structure"
    echo "  Tier 2: Profiles - Profile validation"
    echo "  Tier 3: 12-Factor - Compliance checking"
    echo ""

    wait_for_user

    demo_command \
        "Run full validation:" \
        "agentops validate"

    echo ""
    success "All validation tiers passed!"
    echo ""

    wait_for_user
}

#######################################
# Tutorial Summary
#######################################
tutorial_summary() {
    section_header "Tutorial Complete!"

    echo ""
    success "Congratulations! You've learned:"
    echo ""
    echo "  ✓ How profiles organize workflows by domain"
    echo "  ✓ The 4-layer resolution chain (explicit > env > project > user)"
    echo "  ✓ How to switch profiles (agentops use-profile)"
    echo "  ✓ How to install profiles in projects"
    echo "  ✓ How multiple profiles work without conflicts"
    echo "  ✓ How to validate installations"
    echo ""

    echo ""
    info "Next Steps:"
    echo ""
    echo "  1. Explore your installed profiles:"
    echo "     $ ls ~/.agentops/profiles/"
    echo ""
    echo "  2. Install AgentOps in your own project:"
    echo "     $ cd /path/to/your/project"
    echo "     $ ~/.agentops/scripts/project-install.sh"
    echo ""
    echo "  3. Read profile documentation:"
    echo "     $ cat ~/.agentops/profiles/devops/README.md"
    echo ""
    echo "  4. Try the CLI:"
    echo "     $ agentops help"
    echo ""

    echo ""
    info "Tutorial workspace: ${TUTORIAL_DIR}/test-project"
    echo ""
    echo "You can explore the test project or delete it:"
    echo "  $ cd ${TUTORIAL_DIR}/test-project"
    echo "  $ rm -rf ${TUTORIAL_DIR}  # To clean up"
    echo ""

    wait_for_user "Press Enter to finish..."

    clear
    echo ""
    success "🎉 Tutorial Complete!"
    echo ""
    echo "AgentOps is ready to use!"
    echo ""
    echo "Documentation: ~/.agentops/README.md"
    echo "Profiles: ~/.agentops/profiles/"
    echo "CLI Help: agentops help"
    echo ""
}

#######################################
# Main tutorial flow
#######################################
main() {
    # Check AgentOps is installed
    if [[ ! -d "$AGENTOPS_HOME" ]]; then
        die "AgentOps not installed. Run: scripts/install.sh"
    fi

    # Run tutorial sections
    tutorial_intro
    tutorial_profiles
    tutorial_resolution
    tutorial_environment
    tutorial_project
    tutorial_multi_profile
    tutorial_validation
    tutorial_summary
}

# Run main
main "$@"
