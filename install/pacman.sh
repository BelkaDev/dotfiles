#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

sudo pacman -Sy --noconfirm --needed \
  stow tmux direnv ripgrep fzf zoxide eza bat lazygit atuin neovim

source "$DOTFILES/install/common.sh"

"$DOTFILES/ai/mcp/home-assistant/install.sh"
"$DOTFILES/ai/mcp/home-assistant/register.sh"
