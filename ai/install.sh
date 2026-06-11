#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
npm install -g @ccpocket/bridge@latest
