#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DOTFILES_DIR/claude/install.sh"
"$DOTFILES_DIR/codex/install.sh" || echo "  ⚠ codex install failed" >&2
"$DOTFILES_DIR/ccpocket/install.sh" || echo "  ⚠ ccpocket install failed" >&2
"$DOTFILES_DIR/ollama/install.sh"

"$DOTFILES_DIR/mcp/claude-context/install.sh"
"$DOTFILES_DIR/mcp/claude-context/register.sh"

