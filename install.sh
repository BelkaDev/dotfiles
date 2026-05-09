#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  sudo apt-get install -y stow 2>/dev/null || brew install stow 2>/dev/null || { echo "install stow manually"; exit 1; }
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "$HOME/.fzf" ]]; then
  git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all --no-update-rc
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
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
