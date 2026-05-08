#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${CLAUDE_CONTEXT_LOG_DIR:-/tmp/claude-context/logs}"
OLLAMA_LOG_FILE="$LOG_DIR/ollama.log"
OLLAMA_HOST_VALUE="${OLLAMA_HOST:-http://127.0.0.1:11434}"
CLAUDE_CONTEXT_TMP_ROOT="${CLAUDE_CONTEXT_TMP_ROOT:-/tmp/claude-context}"
OLLAMA_MODELS="${OLLAMA_MODELS:-$HOME/.ollama/models}"

export CLAUDE_CONTEXT_TMP_ROOT
export OLLAMA_MODELS

mkdir -p "$LOG_DIR"

if [ -d "$CLAUDE_CONTEXT_TMP_ROOT" ] && [ ! -w "$CLAUDE_CONTEXT_TMP_ROOT" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$CLAUDE_CONTEXT_TMP_ROOT"
fi

mkdir -p "$CLAUDE_CONTEXT_TMP_ROOT" "$OLLAMA_MODELS"

if command -v ollama >/dev/null 2>&1; then
  if ! curl -fsS "$OLLAMA_HOST_VALUE/api/tags" >/dev/null 2>&1; then
    env OLLAMA_HOST="$OLLAMA_HOST_VALUE" OLLAMA_MODELS="$OLLAMA_MODELS" setsid -f ollama serve > "$OLLAMA_LOG_FILE" 2>&1
    echo "Started Ollama server"
    echo "Log: $OLLAMA_LOG_FILE"
  fi
else
  echo "Ollama is not installed; run scripts/ai/setup.sh"
fi

if command -v docker >/dev/null 2>&1; then
  mkdir -p "$CLAUDE_CONTEXT_TMP_ROOT/etcd" "$CLAUDE_CONTEXT_TMP_ROOT/minio" "$CLAUDE_CONTEXT_TMP_ROOT/milvus"
  docker compose -f docker-compose.claude-context.yml up -d
else
  echo "Docker is not installed; Milvus was not started"
fi
