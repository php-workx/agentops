#!/bin/bash
#
# Grafana Screenshot Helper for AgentOps Multimodal Workflows
#
# Purpose: Capture Grafana dashboard screenshots with authentication and kiosk mode
# Usage: bash grafana_screenshot.sh <grafana-url> <output-path> [auth-token]
#
# Examples:
#   bash grafana_screenshot.sh http://localhost:3000/d/dashboard-id /tmp/dashboard.png
#   bash grafana_screenshot.sh http://localhost:3000/d/dashboard-id /tmp/dashboard.png my-api-key
#
# Environment Variables:
#   GRAFANA_AUTH_TOKEN  - Optional: Grafana API token for authentication
#   GRAFANA_USERNAME    - Optional: Grafana username (basic auth)
#   GRAFANA_PASSWORD    - Optional: Grafana password (basic auth)
#

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
if [ $# -lt 2 ]; then
    echo "Usage: bash grafana_screenshot.sh <grafana-url> <output-path> [auth-token]" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "  bash grafana_screenshot.sh http://localhost:3000/d/dashboard /tmp/dash.png" >&2
    echo "  bash grafana_screenshot.sh http://localhost:3000/d/dashboard /tmp/dash.png my-token" >&2
    exit 1
fi

GRAFANA_URL="$1"
OUTPUT_PATH="$2"
AUTH_TOKEN="${3:-${GRAFANA_AUTH_TOKEN:-}}"

# Add kiosk mode to URL if not already present
if [[ ! "$GRAFANA_URL" =~ "kiosk" ]]; then
    if [[ "$GRAFANA_URL" =~ \? ]]; then
        GRAFANA_URL="${GRAFANA_URL}&kiosk"
    else
        GRAFANA_URL="${GRAFANA_URL}?kiosk"
    fi
fi

echo "[grafana-screenshot] Capturing Grafana dashboard..."
echo "[grafana-screenshot] URL: ${GRAFANA_URL}"
echo "[grafana-screenshot] Output: ${OUTPUT_PATH}"

# Use screenshot.js with appropriate wait time for Grafana rendering
# Grafana dashboards need ~2 seconds to fully render queries
node "${SCRIPT_DIR}/screenshot.js" \
    "${GRAFANA_URL}" \
    "${OUTPUT_PATH}" \
    --wait 2000 \
    --viewport 1920x1080

echo "[grafana-screenshot] ✓ Grafana dashboard screenshot complete"
