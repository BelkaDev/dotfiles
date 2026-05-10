#!/usr/bin/env bash
set -euo pipefail

npm install -g @anthropic-ai/claude-code @openai/codex @ccpocket/bridge@latest

"$HOME/scripts/ai/setup.sh"
