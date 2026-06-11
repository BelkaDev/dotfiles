#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export MILVUS_DATA_DIR="/tmp/claude-context"

if [ -d "$MILVUS_DATA_DIR" ] && [ ! -w "$MILVUS_DATA_DIR" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$MILVUS_DATA_DIR"
fi

"$DOTFILES_DIR/ai/install.sh"
"$DOTFILES_DIR/ai/mcp/claude-context/setup.sh"

if [ -f yarn.lock ]; then
  COREPACK_ENABLE_DOWNLOAD_PROMPT=0 yarn install
fi
