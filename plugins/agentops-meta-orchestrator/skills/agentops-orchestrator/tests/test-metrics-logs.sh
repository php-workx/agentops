#!/usr/bin/env bash
# Test metrics log format validation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
METRICS_DIR="${SCRIPT_DIR}/../metrics"

echo "=== Metrics Logs Validation ==="
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

passed=0
failed=0
warnings=0

# Test 1: Check required log files exist
echo "Test 1: Checking required log files..."
required_logs=(
    "durations.log"
    "success_rates.log"
    "plugin_usage.log"
)

for log in "${required_logs[@]}"; do
    if [ -f "${METRICS_DIR}/${log}" ]; then
        echo -e "${GREEN}✓${NC} Found: ${log}"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} Missing: ${log}"
        failed=$((failed + 1))
    fi
done

echo

# Test 2: Validate durations.log format
echo "Test 2: Validating durations.log format..."
if [ -f "${METRICS_DIR}/durations.log" ]; then
    # Check header
    expected_header="timestamp,workflow_id,phase,step,plugin,duration_seconds,success"
    actual_header=$(head -n 1 "${METRICS_DIR}/durations.log")

    if [ "$actual_header" = "$expected_header" ]; then
        echo -e "${GREEN}✓${NC} Valid header in durations.log"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} Invalid header in durations.log"
        echo "  Expected: $expected_header"
        echo "  Actual:   $actual_header"
        failed=$((failed + 1))
    fi

    # Check CSV format (7 columns per row)
    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [ $line_num -eq 1 ]; then
            continue  # Skip header
        fi

        if [ -z "$line" ]; then
            continue  # Skip empty lines
        fi

        col_count=$(echo "$line" | awk -F',' '{print NF}')
        if [ "$col_count" -eq 7 ]; then
            echo -e "${GREEN}✓${NC} Valid CSV row $line_num (7 columns)"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Invalid CSV row $line_num ($col_count columns, expected 7)"
            failed=$((failed + 1))
        fi
    done < "${METRICS_DIR}/durations.log"
else
    echo -e "${RED}✗${NC} durations.log not found"
    failed=$((failed + 1))
fi

echo

# Test 3: Validate success_rates.log format
echo "Test 3: Validating success_rates.log format..."
if [ -f "${METRICS_DIR}/success_rates.log" ]; then
    # Check header
    expected_header="timestamp,pattern_id,pattern_name,success,duration_seconds,plugins_used,files_created,notes"
    actual_header=$(head -n 1 "${METRICS_DIR}/success_rates.log")

    if [ "$actual_header" = "$expected_header" ]; then
        echo -e "${GREEN}✓${NC} Valid header in success_rates.log"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} Invalid header in success_rates.log"
        echo "  Expected: $expected_header"
        echo "  Actual:   $actual_header"
        failed=$((failed + 1))
    fi

    # Check CSV format (8 columns per row)
    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [ $line_num -eq 1 ]; then
            continue  # Skip header
        fi

        if [ -z "$line" ]; then
            continue  # Skip empty lines
        fi

        col_count=$(echo "$line" | awk -F',' '{print NF}')
        if [ "$col_count" -ge 8 ]; then  # >= because notes may contain commas
            echo -e "${GREEN}✓${NC} Valid CSV row $line_num (≥8 columns)"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Invalid CSV row $line_num ($col_count columns, expected ≥8)"
            failed=$((failed + 1))
        fi
    done < "${METRICS_DIR}/success_rates.log"
else
    echo -e "${RED}✗${NC} success_rates.log not found"
    failed=$((failed + 1))
fi

echo

# Test 4: Validate plugin_usage.log format
echo "Test 4: Validating plugin_usage.log format..."
if [ -f "${METRICS_DIR}/plugin_usage.log" ]; then
    # Check header
    expected_header="timestamp,plugin_name,execution_count,total_duration_seconds,success_count,failure_count,avg_duration_seconds,last_used"
    actual_header=$(head -n 1 "${METRICS_DIR}/plugin_usage.log")

    if [ "$actual_header" = "$expected_header" ]; then
        echo -e "${GREEN}✓${NC} Valid header in plugin_usage.log"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} Invalid header in plugin_usage.log"
        echo "  Expected: $expected_header"
        echo "  Actual:   $actual_header"
        failed=$((failed + 1))
    fi

    # Check CSV format (8 columns per row)
    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [ $line_num -eq 1 ]; then
            continue  # Skip header
        fi

        if [ -z "$line" ]; then
            continue  # Skip empty lines
        fi

        col_count=$(echo "$line" | awk -F',' '{print NF}')
        if [ "$col_count" -eq 8 ]; then
            echo -e "${GREEN}✓${NC} Valid CSV row $line_num (8 columns)"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Invalid CSV row $line_num ($col_count columns, expected 8)"
            failed=$((failed + 1))
        fi
    done < "${METRICS_DIR}/plugin_usage.log"
else
    echo -e "${RED}✗${NC} plugin_usage.log not found"
    failed=$((failed + 1))
fi

echo

# Test 5: Check timestamp format
echo "Test 5: Validating timestamp format (ISO 8601)..."
timestamp_regex="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z"

for log in "${required_logs[@]}"; do
    if [ ! -f "${METRICS_DIR}/${log}" ]; then
        continue
    fi

    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [ $line_num -eq 1 ]; then
            continue  # Skip header
        fi

        if [ -z "$line" ]; then
            continue  # Skip empty lines
        fi

        timestamp=$(echo "$line" | cut -d',' -f1)
        if echo "$timestamp" | grep -qE "$timestamp_regex"; then
            echo -e "${GREEN}✓${NC} Valid timestamp in ${log}:${line_num}: $timestamp"
            passed=$((passed + 1))
        else
            echo -e "${YELLOW}⚠${NC} Invalid timestamp in ${log}:${line_num}: $timestamp (expected ISO 8601)"
            warnings=$((warnings + 1))
        fi
    done < "${METRICS_DIR}/${log}"
done

echo

# Test 6: Validate boolean values
echo "Test 6: Validating boolean values..."
for log in durations.log success_rates.log; do
    if [ ! -f "${METRICS_DIR}/${log}" ]; then
        continue
    fi

    # durations.log has success column (index 7)
    # success_rates.log has success column (index 4)
    if [ "$log" = "durations.log" ]; then
        col_index=7
    else
        col_index=4
    fi

    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [ $line_num -eq 1 ]; then
            continue  # Skip header
        fi

        if [ -z "$line" ]; then
            continue  # Skip empty lines
        fi

        success_value=$(echo "$line" | cut -d',' -f${col_index})
        if [ "$success_value" = "true" ] || [ "$success_value" = "false" ]; then
            echo -e "${GREEN}✓${NC} Valid boolean in ${log}:${line_num}: $success_value"
            passed=$((passed + 1))
        else
            echo -e "${RED}✗${NC} Invalid boolean in ${log}:${line_num}: $success_value (expected true/false)"
            failed=$((failed + 1))
        fi
    done < "${METRICS_DIR}/${log}"
done

echo
echo "=== Summary ==="
echo -e "${GREEN}Passed:${NC} $passed"
echo -e "${RED}Failed:${NC} $failed"
echo -e "${YELLOW}Warnings:${NC} $warnings"
echo

if [ $failed -gt 0 ]; then
    echo -e "${RED}Metrics validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Metrics validation PASSED${NC}"
    exit 0
fi
