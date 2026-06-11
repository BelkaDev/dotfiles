#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"$DOTFILES_DIR/ai/mcp/home-assistant/install.sh"
"$DOTFILES_DIR/ai/mcp/home-assistant/register.sh"
