#!/bin/bash
#
# install-marketplaces.sh
#
# Purpose: Install all 3 plugin marketplaces for AgentOps Meta-Orchestrator
# Usage: ./install-marketplaces.sh
# Exit codes: 0 (success), 1 (partial failure), 2 (complete failure)

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_SOURCES=3
INSTALLED=0
FAILED=0

echo ""
echo "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo "${BLUE}  AgentOps Meta-Orchestrator: Marketplace Installation${NC}"
echo "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "This script will install 3 Claude Code plugin marketplaces:"
echo "  1. claude-code-templates (via NPM)"
echo "  2. wshobson/agents (via Claude Code marketplace)"
echo "  3. jeremylongshore/claude-code-plugins-plus (via Claude Code marketplace)"
echo ""
echo "Total plugins: ~407 across all marketplaces"
echo ""

# Check prerequisites
echo "${YELLOW}Checking prerequisites...${NC}"

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "${RED}✗ npm not found${NC}"
    echo "  Please install Node.js and npm: https://nodejs.org/"
    exit 2
fi
echo "${GREEN}✓ npm found${NC}"

# Check for git
if ! command -v git &> /dev/null; then
    echo "${RED}✗ git not found${NC}"
    echo "  Please install git: https://git-scm.com/"
    exit 2
fi
echo "${GREEN}✓ git found${NC}"

echo ""

# ───────────────────────────────────────────────────────────
# Source 1: claude-code-templates (NPM)
# ───────────────────────────────────────────────────────────

echo "${BLUE}[1/3] Installing claude-code-templates...${NC}"
echo "  Repository: https://github.com/davila7/claude-code-templates"
echo "  Method: NPM global install"
echo "  Count: 100+ components"
echo ""

if npm list -g claude-code-templates &> /dev/null; then
    echo "${YELLOW}  ⚠ claude-code-templates already installed${NC}"
    echo "  Checking for updates..."
    if npm update -g claude-code-templates; then
        echo "${GREEN}  ✓ Updated to latest version${NC}"
        INSTALLED=$((INSTALLED + 1))
    else
        echo "${RED}  ✗ Update failed${NC}"
        FAILED=$((FAILED + 1))
    fi
else
    echo "  Installing globally..."
    if npm install -g claude-code-templates; then
        echo "${GREEN}  ✓ claude-code-templates installed successfully${NC}"
        INSTALLED=$((INSTALLED + 1))
    else
        echo "${RED}  ✗ Installation failed${NC}"
        echo "  Try manual install: npm install -g claude-code-templates"
        FAILED=$((FAILED + 1))
    fi
fi

echo ""

# ───────────────────────────────────────────────────────────
# Source 2: wshobson/agents (Claude Code Marketplace)
# ───────────────────────────────────────────────────────────

echo "${BLUE}[2/3] Adding wshobson/agents marketplace...${NC}"
echo "  Repository: https://github.com/wshobson/agents"
echo "  Method: Claude Code marketplace command"
echo "  Count: 63 plugins + 85 agents + 47 skills"
echo ""

# Note: Claude Code marketplace commands aren't available in bash
# We'll document what the user needs to do manually

echo "${YELLOW}  ⚠ Manual step required${NC}"
echo ""
echo "  To add this marketplace, run the following in Claude Code:"
echo ""
echo "    ${GREEN}/plugin marketplace add wshobson/agents${NC}"
echo ""
echo "  Or clone the repository manually:"
echo ""
echo "    ${GREEN}git clone https://github.com/wshobson/agents.git ~/.claude/marketplaces/wshobson-agents${NC}"
echo ""

read -p "  Have you added wshobson/agents marketplace? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "${GREEN}  ✓ wshobson/agents marketplace added${NC}"
    INSTALLED=$((INSTALLED + 1))
else
    echo "${YELLOW}  ⚠ wshobson/agents marketplace not added yet${NC}"
    echo "  You can add it later using the command above"
    # Don't count as failed, user can add later
fi

echo ""

# ───────────────────────────────────────────────────────────
# Source 3: claude-code-plugins-plus (Claude Code Marketplace)
# ───────────────────────────────────────────────────────────

echo "${BLUE}[3/3] Adding claude-code-plugins-plus marketplace...${NC}"
echo "  Repository: https://github.com/jeremylongshore/claude-code-plugins-plus"
echo "  Method: Claude Code marketplace command"
echo "  Count: 244 plugins"
echo ""

echo "${YELLOW}  ⚠ Manual step required${NC}"
echo ""
echo "  To add this marketplace, run the following in Claude Code:"
echo ""
echo "    ${GREEN}/plugin marketplace add jeremylongshore/claude-code-plugins-plus${NC}"
echo ""
echo "  Or clone the repository manually:"
echo ""
echo "    ${GREEN}git clone https://github.com/jeremylongshore/claude-code-plugins-plus.git ~/.claude/marketplaces/claude-code-plugins-plus${NC}"
echo ""

read -p "  Have you added claude-code-plugins-plus marketplace? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "${GREEN}  ✓ claude-code-plugins-plus marketplace added${NC}"
    INSTALLED=$((INSTALLED + 1))
else
    echo "${YELLOW}  ⚠ claude-code-plugins-plus marketplace not added yet${NC}"
    echo "  You can add it later using the command above"
    # Don't count as failed, user can add later
fi

echo ""

# ───────────────────────────────────────────────────────────
# Installation Summary
# ───────────────────────────────────────────────────────────

echo "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo "${BLUE}  Installation Summary${NC}"
echo "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

echo "Sources processed: ${TOTAL_SOURCES}"
echo "Successfully installed: ${INSTALLED}/${TOTAL_SOURCES}"
echo "Failed/Skipped: $((TOTAL_SOURCES - INSTALLED))/${TOTAL_SOURCES}"
echo ""

if [ $INSTALLED -eq $TOTAL_SOURCES ]; then
    echo "${GREEN}✓ All marketplaces installed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Claude Code (if needed)"
    echo "  2. Verify plugins available: /plugin list"
    echo "  3. Test meta-orchestrator: /orchestrate \"test installation\""
    echo ""
    exit 0
elif [ $INSTALLED -gt 0 ]; then
    echo "${YELLOW}⚠ Partial installation${NC}"
    echo ""
    echo "Some marketplaces were installed, but not all."
    echo "Review the output above for manual installation steps."
    echo ""
    echo "To complete installation:"
    echo "  - Add wshobson/agents: /plugin marketplace add wshobson/agents"
    echo "  - Add claude-code-plugins-plus: /plugin marketplace add jeremylongshore/claude-code-plugins-plus"
    echo ""
    exit 1
else
    echo "${RED}✗ Installation failed${NC}"
    echo ""
    echo "No marketplaces were successfully installed."
    echo "Please check error messages above and retry."
    echo ""
    echo "For help, see:"
    echo "  - README.md in this plugin"
    echo "  - Marketplace sources: references/marketplace-sources.md"
    echo "  - GitHub issues: https://github.com/agentops/agentops/issues"
    echo ""
    exit 2
fi
