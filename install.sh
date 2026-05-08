#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$1"
  if [[ -f "$src" ]]; then
    ln -sf "$src" "$dst"
    echo "  linked $1"
  fi
}

echo "Installing dotfiles from $DOTFILES"
link .zshrc
link .tmux.conf
echo "Done."
