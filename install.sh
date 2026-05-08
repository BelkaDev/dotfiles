#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  sudo apt-get install -y stow 2>/dev/null || brew install stow 2>/dev/null || { echo "install stow manually"; exit 1; }
fi

cd "$DOTFILES"

for pkg in zsh tmux; do
  stow --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(which zsh)" 2>/dev/null || true
fi

echo "Done."
