#!/usr/bin/env bash
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "ha-mcp uses uvx (no install needed, runs via uvx ha-mcp@latest)"
