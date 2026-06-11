#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

"$DOTFILES_DIR/ai/mcp/claude-context/start.sh"
