#!/bin/bash
# Validate AgentOps profile structure and manifest
# Usage: ./scripts/validate-profile.sh <profile-name>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get profile name
PROFILE_NAME=$1

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: $0 <profile-name>"
  echo ""
  echo "Example: $0 example"
  echo "         $0 devops"
  exit 1
fi

PROFILE_DIR="profiles/$PROFILE_NAME"

echo "Validating profile: $PROFILE_NAME"
echo ""

# Check structure
echo "✓ Checking structure..."
if [ ! -d "$PROFILE_DIR" ]; then
  echo -e "${RED}❌ Profile directory not found: $PROFILE_DIR${NC}"
  exit 1
fi

if [ ! -f "$PROFILE_DIR/profile.yaml" ]; then
  echo -e "${RED}❌ Missing profile.yaml${NC}"
  exit 1
fi

if [ ! -f "$PROFILE_DIR/README.md" ]; then
  echo -e "${YELLOW}⚠️  Missing README.md (recommended)${NC}"
fi

if [ ! -d "$PROFILE_DIR/agents" ]; then
  echo -e "${YELLOW}⚠️  Missing agents/ directory (recommended)${NC}"
fi

echo -e "${GREEN}✓ Structure valid${NC}"
echo ""

# Validate YAML syntax
echo "✓ Validating YAML..."
if command -v yamllint &> /dev/null; then
  if yamllint "$PROFILE_DIR/profile.yaml" 2>&1 | grep -q "error"; then
    echo -e "${RED}❌ YAML syntax errors found${NC}"
    yamllint "$PROFILE_DIR/profile.yaml"
    exit 1
  fi
  echo -e "${GREEN}✓ YAML syntax valid${NC}"
else
  echo -e "${YELLOW}⚠️  yamllint not found, skipping YAML validation${NC}"
  echo "   Install: pip install yamllint"
fi
echo ""

# Check profile.yaml structure
echo "✓ Checking profile.yaml structure..."

if ! grep -q "apiVersion:" "$PROFILE_DIR/profile.yaml"; then
  echo -e "${RED}❌ Missing apiVersion in profile.yaml${NC}"
  exit 1
fi

if ! grep -q "kind: Profile" "$PROFILE_DIR/profile.yaml"; then
  echo -e "${RED}❌ Missing 'kind: Profile' in profile.yaml${NC}"
  exit 1
fi

if ! grep -q "extends: core" "$PROFILE_DIR/profile.yaml"; then
  echo -e "${RED}❌ Missing 'extends: core' in profile.yaml${NC}"
  echo "   All profiles must extend core"
  exit 1
fi

if ! grep -q "name:" "$PROFILE_DIR/profile.yaml" | head -1; then
  echo -e "${RED}❌ Missing metadata.name in profile.yaml${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Profile manifest structure valid${NC}"
echo ""

# Validate agent files exist
echo "✓ Validating agents..."
if [ -d "$PROFILE_DIR/agents" ]; then
  AGENT_COUNT=$(find "$PROFILE_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$AGENT_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No agent files found in agents/${NC}"
  else
    echo "   Found $AGENT_COUNT agent(s)"

    # Check each agent file has required frontmatter
    for agent_file in "$PROFILE_DIR/agents"/*.md; do
      if [ -f "$agent_file" ]; then
        agent_name=$(basename "$agent_file")
        if ! grep -q "^---$" "$agent_file"; then
          echo -e "${YELLOW}⚠️  Agent $agent_name missing frontmatter${NC}"
        fi
      fi
    done
  fi
  echo -e "${GREEN}✓ Agents validated${NC}"
else
  echo -e "${YELLOW}⚠️  No agents/ directory${NC}"
fi
echo ""

# Check README quality
echo "✓ Checking README..."
if [ -f "$PROFILE_DIR/README.md" ]; then
  README_LINES=$(wc -l < "$PROFILE_DIR/README.md" | tr -d ' ')
  if [ "$README_LINES" -lt 20 ]; then
    echo -e "${YELLOW}⚠️  README seems short (<20 lines)${NC}"
  else
    echo "   README: $README_LINES lines"
  fi
  echo -e "${GREEN}✓ README present${NC}"
else
  echo -e "${YELLOW}⚠️  README.md not found (recommended)${NC}"
fi
echo ""

# Check for common issues
echo "✓ Checking for common issues..."

# Check for placeholder text
if grep -q "your-domain" "$PROFILE_DIR/profile.yaml" 2>/dev/null; then
  echo -e "${YELLOW}⚠️  Found 'your-domain' placeholder in profile.yaml${NC}"
  echo "   Update with actual domain name"
fi

if grep -q "TODO" "$PROFILE_DIR"/*.md 2>/dev/null; then
  echo -e "${YELLOW}⚠️  Found TODO markers in documentation${NC}"
fi

# Check for example artifacts
if [ "$PROFILE_NAME" != "example" ]; then
  if grep -q "example" "$PROFILE_DIR/profile.yaml" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Found 'example' references in profile.yaml${NC}"
    echo "   Update to match your domain"
  fi
fi

echo -e "${GREEN}✓ Common issues check complete${NC}"
echo ""

# Final summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Profile validation complete: $PROFILE_NAME${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Review any warnings above"
echo "  2. Install: ./scripts/install.sh --profile $PROFILE_NAME"
echo "  3. Use: /prime"
echo ""

exit 0
