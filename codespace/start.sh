#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

export MILVUS_DATA_DIR="/tmp/claude-context"

if [ -d "$MILVUS_DATA_DIR" ] && [ ! -w "$MILVUS_DATA_DIR" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$MILVUS_DATA_DIR"
fi

PORT="${BRIDGE_PORT:-8765}"
DOMAIN="${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
export BRIDGE_PUBLIC_WS_URL="wss://${CODESPACE_NAME}-${PORT}.${DOMAIN}"

if command -v gh >/dev/null 2>&1; then
  gh codespace ports visibility "${PORT}:public" -c "$CODESPACE_NAME" >/dev/null 2>&1 || \
    echo "Could not set port $PORT to public"
fi

if [ ! -f "$HOME/.ai_setup_done" ]; then
  "$DOTFILES_DIR/codespace/install.sh" && touch "$HOME/.ai_setup_done"
fi

"$DOTFILES_DIR/ai/mcp/start.sh"
"$DOTFILES_DIR/ai/ccpocket/start.sh"
