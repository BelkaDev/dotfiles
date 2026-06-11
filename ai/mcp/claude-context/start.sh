#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"$DOTFILES_DIR/ai/ollama/start.sh"
"$DOTFILES_DIR/docker/milvus-start.sh"
