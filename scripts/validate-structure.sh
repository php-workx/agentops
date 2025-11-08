#!/bin/bash
# Repository Structure Validation Script
# Ensures repository follows open source standards for agentops (orchestration layer)

set -e

ERRORS=0
WARNINGS=0

echo "🔍 Validating repository structure..."
echo ""

# Check required root files
echo "📋 Checking required root files..."
required_root=(
  "README.md"
  "LICENSE"
  "CONTRIBUTING.md"
  "CODE_OF_CONDUCT.md"
  "SECURITY.md"
  "CHANGELOG.md"
  "VERSION"
  "Makefile"
)

for file in "${required_root[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ Missing required file: $file"
    ((ERRORS++))
  else
    echo "✅ $file"
  fi
done

echo ""

# Check no stray markdown in root (except allowed)
echo "📄 Checking for stray markdown files in root..."
allowed_root_md=(
  "README.md"
  "CONTRIBUTING.md"
  "CODE_OF_CONDUCT.md"
  "SECURITY.md"
  "CHANGELOG.md"
  "CLAUDE.md"
  "CONSTITUTION.md"
)

stray_found=0
shopt -s nullglob
for md in *.md; do
  # Skip if no .md files found
  if [[ ! " ${allowed_root_md[@]} " =~ " ${md} " ]]; then
    echo "❌ Markdown file should be in docs/: $md"
    ((ERRORS++))
    stray_found=1
  fi
done
shopt -u nullglob

if [ $stray_found -eq 0 ]; then
  echo "✅ No stray markdown files in root"
fi

echo ""

# Check required directories
echo "📁 Checking required directories..."
required_dirs=(
  "docs"
  "scripts"
  "core"
  "profiles"
)

for dir in "${required_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "❌ Missing required directory: $dir"
    ((ERRORS++))
  else
    echo "✅ $dir/"
  fi
done

echo ""

# Check docs structure
echo "📚 Checking docs/ structure..."
required_docs_dirs=(
  "docs/architecture"
  "docs/guides"
  "docs/reference"
  "docs/project"
)

for dir in "${required_docs_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "❌ Missing docs directory: $dir"
    ((ERRORS++))
  else
    echo "✅ $dir/"
  fi
done

# Check docs README exists
if [ ! -f "docs/README.md" ]; then
  echo "❌ Missing docs/README.md index"
  ((ERRORS++))
else
  echo "✅ docs/README.md"
fi

echo ""

# Check core structure (AgentOps specific)
echo "⚙️  Checking core/ structure..."
required_core_dirs=(
  "core/agents"
  "core/commands"
  "core/workflows"
)

for dir in "${required_core_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "❌ Missing core directory: $dir"
    ((ERRORS++))
  else
    echo "✅ $dir/"
  fi
done

echo ""

# Check profiles structure
echo "👥 Checking profiles/ structure..."
if [ ! -f "profiles/README.md" ]; then
  echo "⚠️  Missing profiles/README.md (optional but recommended)"
  ((WARNINGS++))
else
  echo "✅ profiles/README.md"
fi

# Check for at least one profile
profile_count=$(find profiles -maxdepth 1 -type d ! -name profiles | wc -l)
if [ "$profile_count" -lt 1 ]; then
  echo "⚠️  No profile directories found (optional)"
  ((WARNINGS++))
else
  echo "✅ Found $profile_count profile(s)"
fi

echo ""

# Check scripts exist
echo "🔧 Checking validation scripts..."
required_scripts=(
  "scripts/validate.sh"
  "scripts/validate-structure.sh"
  "scripts/validate-doc-links.sh"
  "scripts/validate-trinity.sh"
)

for script in "${required_scripts[@]}"; do
  if [ ! -f "$script" ]; then
    echo "❌ Missing script: $script"
    ((ERRORS++))
  else
    # Check if executable
    if [ ! -x "$script" ]; then
      echo "⚠️  Script not executable: $script"
      ((WARNINGS++))
    else
      echo "✅ $script"
    fi
  fi
done

echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -gt 0 ]; then
  echo "❌ Structure validation FAILED"
  echo "   Errors: $ERRORS"
  echo "   Warnings: $WARNINGS"
  echo ""
  echo "Fix errors above and re-run validation."
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo "⚠️  Structure validation PASSED with warnings"
  echo "   Warnings: $WARNINGS"
  echo ""
  echo "Consider addressing warnings for best practices."
  exit 0
else
  echo "✅ Repository structure is VALID"
  echo "   All checks passed!"
  exit 0
fi
