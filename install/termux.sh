#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

pkg update -y
pkg install -y stow zsh git curl wget fzf tmux zoxide eza bat lazygit neovim

if ! command -v atuin >/dev/null 2>&1; then
  pkg install -y atuin 2>/dev/null || curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && \
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && \
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && \
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

if [[ ! -f "$HOME/.termux/font.ttf" ]]; then
  mkdir -p "$HOME/.termux"
  curl -fLo "$HOME/.termux/font.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
  termux-reload-settings 2>/dev/null || true
fi

rm -f "$HOME/.zshrc" "$HOME/.tmux.conf"
cd "$DOTFILES"

for pkg in zsh tmux nvim; do
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

chsh -s zsh 2>/dev/null || true

echo "Done. Run: exec zsh"
