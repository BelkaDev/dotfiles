#!/usr/bin/env bash
set -euo pipefail

if command -v ollama >/dev/null 2>&1; then
  echo "Ollama already installed ($(ollama --version))"
  exit 0
fi

curl -fsSL https://ollama.com/install.sh | sh
