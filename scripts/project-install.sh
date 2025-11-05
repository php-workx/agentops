#!/bin/bash

# agentops project installation script
# Installs agentops into your project

set -e

AGENTOPS_HOME="${HOME}/.agentops"
PROJECT_ROOT="$(pwd)"
PROFILE="${1:-default}"

# Check base installation exists
if [ ! -d "$AGENTOPS_HOME" ]; then
    echo "❌ Base installation not found at $AGENTOPS_HOME"
    echo "Run: curl -sSL https://raw.githubusercontent.com/boshu2/agentops/main/scripts/base-install.sh | bash"
    exit 1
fi

# Check profile exists
if [ ! -d "$AGENTOPS_HOME/profiles/$PROFILE" ]; then
    echo "❌ Profile '$PROFILE' not found"
    echo ""
    echo "Available profiles:"
    ls -1 "$AGENTOPS_HOME/profiles/" | grep -v examples | sed 's/^/  - /'
    echo ""
    echo "Usage: $0 [profile]"
    exit 1
fi

echo "📦 agentops Project Installation"
echo ""
echo "Project: $PROJECT_ROOT"
echo "Profile: $PROFILE"
echo ""

# Create project directories
mkdir -p agentops
cp -r "$AGENTOPS_HOME/core" agentops/
cp -r "$AGENTOPS_HOME/profiles/$PROFILE" agentops/profile

# Create .claude directories for Claude Code
if [ ! -d ".claude" ]; then
    mkdir -p .claude
fi

# Copy commands if profile has them
if [ -d "agentops/profile/commands" ]; then
    mkdir -p .claude/commands
    cp -r agentops/profile/commands .claude/commands/agentops || true
fi

# Install git hooks
if [ -d ".git" ]; then
    mkdir -p .git/hooks
    cp agentops/core/hooks/* .git/hooks/ 2>/dev/null || true
    chmod +x .git/hooks/*
    echo "✅ Git hooks installed"
fi

echo ""
echo "✅ Project installation complete!"
echo ""
echo "Files created:"
echo "  agentops/           - Profile with commands, workflows, standards"
echo "  .claude/commands/   - Claude Code integration (if applicable)"
echo "  .git/hooks/         - Git enforcement"
echo ""
echo "Next steps:"
echo "1. Read: agentops/core/README.md"
echo "2. Configure: agentops/profile/config.yml (if needed)"
echo "3. Start work: /prime (if using Claude Code)"
echo ""
