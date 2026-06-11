#!/usr/bin/env bash
set -euo pipefail

OLLAMA_HOST_VALUE="${OLLAMA_HOST:-http://127.0.0.1:11434}"
OLLAMA_MODELS="${OLLAMA_MODELS:-$HOME/.ollama/models}"
OLLAMA_LOG_FILE="${OLLAMA_LOG_FILE:-$HOME/.local/share/ollama/ollama.log}"

if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed" >&2
  exit 1
fi

if curl -fsS "$OLLAMA_HOST_VALUE/api/tags" >/dev/null 2>&1; then
  exit 0
fi

mkdir -p "$(dirname "$OLLAMA_LOG_FILE")"
env OLLAMA_HOST="$OLLAMA_HOST_VALUE" OLLAMA_MODELS="$OLLAMA_MODELS" \
  setsid -f ollama serve > "$OLLAMA_LOG_FILE" 2>&1
echo "Started Ollama (log: $OLLAMA_LOG_FILE)"
