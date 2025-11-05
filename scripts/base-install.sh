#!/bin/bash

# agentops base installation script
# Installs agentops to ~/.agentops

set -e

AGENTOPS_HOME="${HOME}/.agentops"
REPO_URL="https://github.com/boshu2/agentops.git"

echo "📦 agentops - Specification-driven AI agent operations"
echo ""

# Check if already installed
if [ -d "$AGENTOPS_HOME" ]; then
    echo "✅ agentops already installed at $AGENTOPS_HOME"
    echo ""
    read -p "Update existing installation? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating agentops..."
        cd "$AGENTOPS_HOME"
        git pull origin main
        echo "✅ Updated!"
    fi
    exit 0
fi

echo "Installing agentops to $AGENTOPS_HOME..."
echo ""

# Clone repository
git clone "$REPO_URL" "$AGENTOPS_HOME"
cd "$AGENTOPS_HOME"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Navigate to your project: cd /path/to/your/project"
echo "2. Run project installation: ~/.agentops/scripts/project-install.sh"
echo "3. Choose your profile (default/devops/product-dev/sre)"
echo ""
echo "For more information, see INSTALL.md"
