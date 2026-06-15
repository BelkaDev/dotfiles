#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ install/codespace.sh failed at line $LINENO" >&2' ERR

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# ── Symlinks first for postStartCommand ─────
ln -sfn "$DOTFILES" "$HOME/dotfiles"
ln -sfn "$DOTFILES/ai" "$HOME/ai"
ln -sfn "$DOTFILES/start" "$HOME/start"

# ── Minimal packages (most tools already in the universal devcontainer image) ──
sudo apt-get update -qq
sudo apt-get install -y stow direnv

sudo chsh -s "$(which zsh)" "$(whoami)"
source "$DOTFILES/install/common.sh"

export MILVUS_DATA_DIR="/tmp/claude-context"
if [ -d "$MILVUS_DATA_DIR" ] && [ ! -w "$MILVUS_DATA_DIR" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$MILVUS_DATA_DIR"
fi

if [ -f yarn.lock ]; then
  COREPACK_ENABLE_DOWNLOAD_PROMPT=0 yarn install
fi
