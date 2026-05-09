#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  sudo apt-get install -y stow 2>/dev/null || brew install stow 2>/dev/null || { echo "install stow manually"; exit 1; }
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

rm -f "$HOME/.zshrc" "$HOME/.tmux.conf"

cd "$DOTFILES"

for pkg in zsh tmux scripts; do
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(which zsh)" 2>/dev/null || true
fi

echo "Done."
