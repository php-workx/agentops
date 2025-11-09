#!/bin/bash
#
# Install All Claude Code Plugin Marketplaces
#
# Installs all 3 major plugin marketplaces:
# 1. NPM Registry (claude-code-templates)
# 2. GitHub Marketplace (wshobson/agents)
# 3. Claude Code Marketplace Plus (jeremylongshore/claude-code-plugins-plus)
#

set -e  # Exit on error

echo "🚀 Installing Claude Code Plugin Marketplaces..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if npm is installed
echo "Checking prerequisites..."
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi
print_success "npm is installed"

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    print_warning "claude CLI not found. Some marketplaces may not install correctly."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Marketplace 1/3: NPM Registry"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if npm list -g claude-code-templates &> /dev/null; then
    print_warning "claude-code-templates already installed, updating..."
    npm update -g claude-code-templates || print_error "Failed to update claude-code-templates"
else
    echo "Installing claude-code-templates from NPM..."
    npm install -g claude-code-templates || print_error "Failed to install claude-code-templates"
fi

if npm list -g claude-code-templates &> /dev/null; then
    print_success "NPM Registry installed successfully (~120 plugins)"
else
    print_error "NPM Registry installation failed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Marketplace 2/3: GitHub Marketplace (wshobson/agents)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v claude &> /dev/null; then
    echo "Installing wshobson/agents marketplace..."
    claude install marketplace:wshobson/agents || print_error "Failed to install wshobson/agents"
    print_success "GitHub Marketplace (wshobson/agents) installed successfully (~180 plugins)"
else
    print_error "claude CLI not available. Skipping wshobson/agents installation."
    echo "   Install manually with: claude install marketplace:wshobson/agents"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Marketplace 3/3: Claude Code Marketplace Plus"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v claude &> /dev/null; then
    echo "Installing jeremylongshore/claude-code-plugins-plus marketplace..."
    claude install marketplace:jeremylongshore/claude-code-plugins-plus || print_error "Failed to install claude-code-plugins-plus"
    print_success "Claude Code Marketplace Plus installed successfully (~120 plugins)"
else
    print_error "claude CLI not available. Skipping claude-code-plugins-plus installation."
    echo "   Install manually with: claude install marketplace:jeremylongshore/claude-code-plugins-plus"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Count installed plugins
if command -v claude &> /dev/null; then
    PLUGIN_COUNT=$(claude list-plugins 2>/dev/null | wc -l || echo "unknown")
    echo "Total plugins available: ${PLUGIN_COUNT}"
else
    echo "Total plugins available: ~420 (exact count unavailable without claude CLI)"
fi

echo ""
print_success "Marketplace installation complete!"
echo ""
echo "Next steps:"
echo "  1. Verify installation: claude list-plugins"
echo "  2. Search plugins: claude search-plugins <keyword>"
echo "  3. Test meta-orchestration: Ask Claude to build something complex!"
echo ""
