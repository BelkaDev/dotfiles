#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

MODEL="${CLAUDE_CONTEXT_EMBEDDING_MODEL:-nomic-embed-text}"
FORK_REPO="${CLAUDE_CONTEXT_FORK_REPO:-https://github.com/BelkaDev/claude-context.git}"
FORK_BRANCH="${CLAUDE_CONTEXT_FORK_BRANCH:-master}"
BUILD_DIR="/tmp/claude-context-build"

"$DOTFILES_DIR/ai/ollama/install.sh"

rm -rf "$BUILD_DIR"
git clone --depth 1 --branch "$FORK_BRANCH" "$FORK_REPO" "$BUILD_DIR"
cd "$BUILD_DIR"
pnpm install
pnpm build:mcp
npm install -g --prefix "$HOME/.npm-global" "$BUILD_DIR/packages/mcp"
echo "==> npm prefix: $HOME/.npm-global"
echo "==> installed packages:"
ls "$HOME/.npm-global/lib/node_modules/" 2>/dev/null || echo "  (empty)"
echo "==> dist/index.js exists: $(test -f "$HOME/.npm-global/lib/node_modules/@zilliz/claude-context-mcp/dist/index.js" && echo yes || echo NO)"
rm -rf "$BUILD_DIR"

ollama serve &>/dev/null &
OLLAMA_PID=$!
until curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do sleep 1; done
ollama pull "$MODEL"
kill $OLLAMA_PID 2>/dev/null || true
