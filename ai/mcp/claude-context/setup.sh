#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"$DOTFILES_DIR/ai/mcp/claude-context/install.sh"
"$DOTFILES_DIR/ai/mcp/claude-context/start.sh"
"$DOTFILES_DIR/ai/mcp/claude-context/register.sh"

SERVICE_NAME="milvus-claude-context"
SERVICE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
SERVICE_FILE="$SERVICE_DIR/$SERVICE_NAME.service"

if ! systemctl --user is-enabled "$SERVICE_NAME" >/dev/null 2>&1; then
  mkdir -p "$SERVICE_DIR"
  cp "$DOTFILES_DIR/systemd/$SERVICE_NAME.service" "$SERVICE_FILE"
  systemctl --user daemon-reload
  systemctl --user enable --now "$SERVICE_NAME"
  loginctl enable-linger "$USER"
  echo "Enabled systemd user service: $SERVICE_NAME"
fi
