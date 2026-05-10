#!/usr/bin/env bash
set -euo pipefail

MODEL="${CLAUDE_CONTEXT_EMBEDDING_MODEL:-nomic-embed-text}"
DIMENSION="${CLAUDE_CONTEXT_EMBEDDING_DIMENSION:-768}"
BATCH_SIZE="${CLAUDE_CONTEXT_EMBEDDING_BATCH_SIZE:-24}"
MCP_PACKAGE_VERSION="${CLAUDE_CONTEXT_MCP_VERSION:-0.1.11}"
OLLAMA_HOST_VALUE="${OLLAMA_HOST:-http://127.0.0.1:11434}"
MILVUS_ADDRESS="${MILVUS_ADDRESS:-127.0.0.1:19530}"
CLAUDE_LOG_DIR="${HOME}/.claude"
CLAUDE_CONTEXT_LOG_FILE="${CLAUDE_LOG_DIR}/claude-context.stderr.log"
CLAUDE_CONTEXT_TMP_ROOT="${CLAUDE_CONTEXT_TMP_ROOT:-/tmp/claude-context}"
OLLAMA_MODELS="${OLLAMA_MODELS:-$CLAUDE_CONTEXT_TMP_ROOT/ollama-models}"

export CLAUDE_CONTEXT_TMP_ROOT
export OLLAMA_MODELS

mkdir -p "$CLAUDE_CONTEXT_TMP_ROOT" "$OLLAMA_MODELS"

if ! command -v ollama >/dev/null 2>&1; then
  curl -fsSL https://ollama.com/install.sh | sh
fi

npm install -g "@zilliz/claude-context-mcp@$MCP_PACKAGE_VERSION"

"$(dirname "$0")/start.sh" || true

ollama pull "$MODEL" || true

NODE_BIN="$(command -v node)"
MCP_ENTRY="$(npm root -g)/@zilliz/claude-context-mcp/dist/index.js"

if [[ ! -f "$MCP_ENTRY" ]]; then
  echo "Could not find claude-context MCP entrypoint: $MCP_ENTRY" >&2
  exit 1
fi

mkdir -p "$CLAUDE_LOG_DIR"

claude mcp remove claude-context -s local >/dev/null 2>&1 || true
claude mcp add claude-context \
  -s local \
  -e EMBEDDING_PROVIDER=Ollama \
  -e EMBEDDING_MODEL="$MODEL" \
  -e EMBEDDING_DIMENSION="$DIMENSION" \
  -e OLLAMA_HOST="$OLLAMA_HOST_VALUE" \
  -e OLLAMA_MODELS="$OLLAMA_MODELS" \
  -e MILVUS_ADDRESS="$MILVUS_ADDRESS" \
  -e EMBEDDING_BATCH_SIZE="$BATCH_SIZE" \
  -- /bin/sh -lc "exec '$NODE_BIN' '$MCP_ENTRY' 2>>'$CLAUDE_CONTEXT_LOG_FILE'"

CODEX_CONFIG="${HOME}/.codex/config.toml"
mkdir -p "${HOME}/.codex"
python3 - "$CODEX_CONFIG" "$NODE_BIN" "$MCP_ENTRY" \
  "$MODEL" "$DIMENSION" "$BATCH_SIZE" \
  "$OLLAMA_HOST_VALUE" "$OLLAMA_MODELS" "$MILVUS_ADDRESS" << 'PYEOF'
import sys, re, os

config_path, node_bin, mcp_entry, model, dim, batch, ollama_host, ollama_models, milvus = sys.argv[1:]

new_block = f"""[mcp_servers.claude-context]
command = "{node_bin}"
args = ["{mcp_entry}"]

[mcp_servers.claude-context.env]
CLAUDE_CONTEXT_TRIGGER_WATCHER = "false"
EMBEDDING_BATCH_SIZE = "{batch}"
EMBEDDING_DIMENSION = "{dim}"
EMBEDDING_MODEL = "{model}"
EMBEDDING_PROVIDER = "Ollama"
MILVUS_ADDRESS = "{milvus}"
OLLAMA_HOST = "{ollama_host}"
OLLAMA_MODELS = "{ollama_models}"
"""

if os.path.exists(config_path):
    with open(config_path) as f:
        content = f.read()
    if '[mcp_servers.claude-context]' in content:
        content = re.sub(
            r'\[mcp_servers\.claude-context\].*?(?=\n\[|\Z)',
            new_block,
            content,
            flags=re.DOTALL,
        )
    else:
        content = content.rstrip('\n') + '\n\n' + new_block
else:
    content = new_block

with open(config_path, 'w') as f:
    f.write(content)
print("Configured Codex claude-context MCP in", config_path)
PYEOF

echo "claude-context MCP configured"
echo "  model: $MODEL"
echo "  ollama: $OLLAMA_HOST_VALUE"
echo "  milvus: $MILVUS_ADDRESS"
