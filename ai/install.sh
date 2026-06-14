#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DOTFILES_DIR/claude/install.sh"
"$DOTFILES_DIR/codex/install.sh"
"$DOTFILES_DIR/ccpocket/install.sh"

"$DOTFILES_DIR/mcp/claude-context/install.sh"
"$DOTFILES_DIR/mcp/claude-context/register.sh"

