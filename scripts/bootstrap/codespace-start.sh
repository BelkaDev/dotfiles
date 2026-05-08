#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

PORT="${BRIDGE_PORT:-8765}"

if [[ -n "${CODESPACE_NAME:-}" ]]; then
  DOMAIN="${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
  export BRIDGE_PUBLIC_WS_URL="wss://${CODESPACE_NAME}-${PORT}.${DOMAIN}"

  if command -v gh >/dev/null 2>&1; then
    gh codespace ports visibility "${PORT}:public" -c "$CODESPACE_NAME" >/dev/null 2>&1 || \
      echo "Could not set port $PORT to public"
  fi
fi

"$REPO_ROOT/scripts/ai/start.sh"
"$REPO_ROOT/scripts/ai/ccpocket.sh"
