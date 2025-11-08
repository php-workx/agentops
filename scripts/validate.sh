#!/bin/bash
# Local validation script - Run before committing/pushing
# Mirrors CI/CD pipeline checks for agentops (orchestration layer)

set -e  # Exit on any error

echo "🔍 Running local validation..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall success
FAILED=0

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
        FAILED=1
    fi
}

# Check bash version
echo "📦 Checking bash version..."
BASH_VERSION_NUM=$(echo $BASH_VERSION | cut -d'.' -f1)
if [ "$BASH_VERSION_NUM" -ge 4 ]; then
    print_status 0 "Bash version: $BASH_VERSION"
else
    print_status 1 "Bash version too old (need 4+): $BASH_VERSION"
fi
echo ""

# Validate repository structure
echo "📁 Validating repository structure..."
./scripts/validate-structure.sh > /dev/null 2>&1
print_status $? "Repository structure valid"
echo ""

# Validate documentation links
echo "🔗 Validating documentation links..."
./scripts/validate-doc-links.sh > /dev/null 2>&1
print_status $? "Documentation links valid"
echo ""

# Validate Trinity alignment
echo "🔱 Validating Trinity alignment..."
./scripts/validate-trinity.sh > /dev/null 2>&1
print_status $? "Trinity alignment valid"
echo ""

# Check for common issues
echo "🔍 Checking for common issues..."

# Check for broken symlinks
BROKEN_LINKS=$(find . -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l)
if [ "$BROKEN_LINKS" -gt 0 ]; then
    echo -e "${YELLOW}⚠${NC} Warning: Found $BROKEN_LINKS broken symlinks"
else
    print_status 0 "No broken symlinks"
fi

# Check for large files (>1MB)
LARGE_FILES=$(find . -type f -size +1M ! -path "./.git/*" ! -path "./node_modules/*" 2>/dev/null | wc -l)
if [ "$LARGE_FILES" -gt 0 ]; then
    echo -e "${YELLOW}⚠${NC} Warning: Found $LARGE_FILES files larger than 1MB"
else
    print_status 0 "No unexpectedly large files"
fi

# Check for TODO comments in staged files
if git diff --cached --name-only > /dev/null 2>&1; then
    TODO_COUNT=$(git diff --cached | grep -c "TODO:" 2>/dev/null || true)
    if [ "$TODO_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}⚠${NC} Warning: Found $TODO_COUNT TODO comments in staged files"
    else
        print_status 0 "No TODO comments in staged files"
    fi
fi

echo ""

# Final result
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ All validation checks passed!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Ready to commit and push!"
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ Validation failed!${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Please fix the errors above before committing."
    exit 1
fi
