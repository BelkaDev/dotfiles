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

# eza
#   if ! command -v eza >/dev/null 2>&1; then
#     curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
#     tar xf /tmp/eza.tar.gz -C /tmp eza
#     sudo install /tmp/eza /usr/local/bin/eza
#   fi

  # bat
  if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1; then
  fi
  
  # lazygit
  if ! command -v lazygit >/dev/null 2>&1; then
    LG_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz
  "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/lazygit
  fi
  
  # atuin
  if ! command -v atuin >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
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
