#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pkg update -y
pkg install -y stow zsh git curl wget

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

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

if [[ ! -f "$HOME/.termux/font.ttf" ]]; then
  mkdir -p "$HOME/.termux"
  curl -fLo "$HOME/.termux/font.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
  termux-reload-settings 2>/dev/null || true
fi

pkg install -y fzf tmux zoxide eza bat lazygit neovim

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! command -v atuin >/dev/null 2>&1; then
  pkg install -y atuin 2>/dev/null || curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

rm -f "$HOME/.zshrc" "$HOME/.tmux.conf"

cd "$DOTFILES"
for pkg in zsh tmux nvim; do
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

chsh -s zsh 2>/dev/null || true

echo "Done. Run: exec zsh"
