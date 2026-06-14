#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> installing claude"
"$DOTFILES_DIR/claude/install.sh"
echo "==> installing codex"
"$DOTFILES_DIR/codex/install.sh"
echo "==> installing ccpocket"
"$DOTFILES_DIR/ccpocket/install.sh"

echo "==> installing claude-context MCP"
"$DOTFILES_DIR/mcp/claude-context/install.sh"
echo "==> registering claude-context MCP"
"$DOTFILES_DIR/mcp/claude-context/register.sh"

