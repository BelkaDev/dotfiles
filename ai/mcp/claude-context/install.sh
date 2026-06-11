#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

MODEL="${CLAUDE_CONTEXT_EMBEDDING_MODEL:-nomic-embed-text}"
MCP_PACKAGE_VERSION="${CLAUDE_CONTEXT_MCP_VERSION:-0.1.11}"

"$DOTFILES_DIR/ai/ollama/install.sh"

INSTALLED_VERSION="$(npm list -g --depth=0 --json 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); \
    print(d.get('dependencies',{}).get('@zilliz/claude-context-mcp',{}).get('version',''))" \
  2>/dev/null || true)"

if [[ "$INSTALLED_VERSION" != "$MCP_PACKAGE_VERSION" ]]; then
  npm install -g "@zilliz/claude-context-mcp@$MCP_PACKAGE_VERSION"
fi

ollama pull "$MODEL"
