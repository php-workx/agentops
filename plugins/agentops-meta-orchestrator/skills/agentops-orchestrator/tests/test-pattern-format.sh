#!/usr/bin/env bash
# Test pattern file format validation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_DIR="${SCRIPT_DIR}/../patterns"

echo "=== Pattern Format Validation ==="
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

passed=0
failed=0
warnings=0

# Test 1: Check YAML syntax
echo "Test 1: Validating YAML syntax..."
for category in discovered validated learned; do
    if [ ! -d "${PATTERNS_DIR}/${category}" ]; then
        echo -e "${YELLOW}⚠ Directory not found: ${PATTERNS_DIR}/${category}${NC}"
        warnings=$((warnings + 1))
        continue
    fi

    for file in "${PATTERNS_DIR}/${category}"/*.yaml; do
        if [ ! -f "$file" ]; then
            continue
        fi

        if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Valid YAML: $(basename "$file")"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Invalid YAML: $(basename "$file")"
            failed=$((failed + 1))
        fi
    done
done

echo

# Test 2: Check required fields
echo "Test 2: Validating required fields..."
required_fields=(
    "pattern_id"
    "name"
    "description"
    "category"
    "workflow_steps"
    "created_at"
)

for category in discovered validated learned; do
    if [ ! -d "${PATTERNS_DIR}/${category}" ]; then
        continue
    fi

    for file in "${PATTERNS_DIR}/${category}"/*.yaml; do
        if [ ! -f "$file" ]; then
            continue
        fi

        missing_fields=()
        for field in "${required_fields[@]}"; do
            if ! grep -q "^${field}:" "$file"; then
                missing_fields+=("$field")
            fi
        done

        if [ ${#missing_fields[@]} -eq 0 ]; then
            echo -e "${GREEN}✓${NC} All required fields present: $(basename "$file")"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Missing fields in $(basename "$file"): ${missing_fields[*]}"
            failed=$((failed + 1))
        fi
    done
done

echo

# Test 3: Validate pattern ID format
echo "Test 3: Validating pattern ID format..."
for category in discovered validated learned; do
    if [ ! -d "${PATTERNS_DIR}/${category}" ]; then
        continue
    fi

    for file in "${PATTERNS_DIR}/${category}"/*.yaml; do
        if [ ! -f "$file" ]; then
            continue
        fi

        pattern_id=$(grep "^pattern_id:" "$file" | sed 's/pattern_id: *//' | tr -d '"' | tr -d "'")
        basename_without_ext=$(basename "$file" .yaml)

        if [ "$pattern_id" = "$basename_without_ext" ]; then
            echo -e "${GREEN}✓${NC} Pattern ID matches filename: $(basename "$file")"
            passed=$((passed + 1))
        else
            echo -e "${YELLOW}⚠${NC} Pattern ID mismatch: $(basename "$file") (ID: $pattern_id)"
            warnings=$((warnings + 1))
        fi
    done
done

echo

# Test 4: Validate workflow steps format
echo "Test 4: Validating workflow_steps format..."
for category in discovered validated learned; do
    if [ ! -d "${PATTERNS_DIR}/${category}" ]; then
        continue
    fi

    for file in "${PATTERNS_DIR}/${category}"/*.yaml; do
        if [ ! -f "$file" ]; then
            continue
        fi

        if grep -q "workflow_steps:" "$file"; then
            # Check if it's a valid array
            if python3 -c "
import yaml
data = yaml.safe_load(open('$file'))
steps = data.get('workflow_steps', [])
if isinstance(steps, list) and len(steps) > 0:
    exit(0)
else:
    exit(1)
" 2>/dev/null; then
                echo -e "${GREEN}✓${NC} Valid workflow_steps: $(basename "$file")"
                passed=$((passed + 1))
            else
                echo -e "${RED}✗${NC} Invalid workflow_steps (must be non-empty array): $(basename "$file")"
                failed=$((failed + 1))
            fi
        else
            echo -e "${RED}✗${NC} Missing workflow_steps: $(basename "$file")"
            failed=$((failed + 1))
        fi
    done
done

echo

# Test 5: Validate category values
echo "Test 5: Validating category values..."
valid_categories=(
    "api-development"
    "web-development"
    "devops"
    "security"
    "data-engineering"
    "infrastructure"
)

for category in discovered validated learned; do
    if [ ! -d "${PATTERNS_DIR}/${category}" ]; then
        continue
    fi

    for file in "${PATTERNS_DIR}/${category}"/*.yaml; do
        if [ ! -f "$file" ]; then
            continue
        fi

        cat_value=$(grep "^category:" "$file" | sed 's/category: *//' | tr -d '"' | tr -d "'")

        valid=0
        for valid_cat in "${valid_categories[@]}"; do
            if [ "$cat_value" = "$valid_cat" ]; then
                valid=1
                break
            fi
        done

        if [ $valid -eq 1 ]; then
            echo -e "${GREEN}✓${NC} Valid category: $(basename "$file") ($cat_value)"
            passed=$((passed + 1))
        else
            echo -e "${YELLOW}⚠${NC} Unknown category: $(basename "$file") ($cat_value)"
            warnings=$((warnings + 1))
        fi
    done
done

echo
echo "=== Summary ==="
echo -e "${GREEN}Passed:${NC} $passed"
echo -e "${RED}Failed:${NC} $failed"
echo -e "${YELLOW}Warnings:${NC} $warnings"
echo

if [ $failed -gt 0 ]; then
    echo -e "${RED}Pattern validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Pattern validation PASSED${NC}"
    exit 0
fi
