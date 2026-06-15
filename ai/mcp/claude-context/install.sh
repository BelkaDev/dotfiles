#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

MODEL="${CLAUDE_CONTEXT_EMBEDDING_MODEL:-nomic-embed-text}"
FORK_REPO="${CLAUDE_CONTEXT_FORK_REPO:-https://github.com/BelkaDev/claude-context.git}"
FORK_BRANCH="${CLAUDE_CONTEXT_FORK_BRANCH:-fix/sync-cloud-overwrites-indexing-status}"
BUILD_DIR="/tmp/claude-context-build"

"$DOTFILES_DIR/ai/ollama/install.sh"

rm -rf "$BUILD_DIR"
git clone --depth 1 --branch "$FORK_BRANCH" "$FORK_REPO" "$BUILD_DIR"
cd "$BUILD_DIR"
pnpm install
pnpm build:mcp
npm install -g "$BUILD_DIR/packages/mcp"
rm -rf "$BUILD_DIR"

ollama serve &>/dev/null &
OLLAMA_PID=$!
until curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do sleep 1; done
ollama pull "$MODEL"
kill $OLLAMA_PID 2>/dev/null || true
