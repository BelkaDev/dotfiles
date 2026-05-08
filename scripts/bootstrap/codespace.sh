#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

npm install -g @anthropic-ai/claude-code @openai/codex @ccpocket/bridge@latest

"$REPO_ROOT/scripts/ai/setup.sh"

if [[ -f "$REPO_ROOT/config/tmux.conf" ]]; then
  cp "$REPO_ROOT/config/tmux.conf" "$HOME/.tmux.conf"
fi
