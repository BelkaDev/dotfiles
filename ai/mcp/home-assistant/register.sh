#!/usr/bin/env bash
set -euo pipefail

HOMEASSISTANT_URL="${HOMEASSISTANT_URL:-http://192.168.8.215:8123}"
HOMEASSISTANT_TOKEN="${HOMEASSISTANT_TOKEN:?HOMEASSISTANT_TOKEN must be set}"

claude mcp remove home-assistant -s user >/dev/null 2>&1 || true
claude mcp add home-assistant \
  -s user \
  -e HOMEASSISTANT_URL="$HOMEASSISTANT_URL" \
  -e HOMEASSISTANT_TOKEN="$HOMEASSISTANT_TOKEN" \
  -- uvx ha-mcp@latest

echo "Registered home-assistant MCP"
echo "  url: $HOMEASSISTANT_URL"
