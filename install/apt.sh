#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
ARCH="${ARCH:-$(uname -m)}"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

sudo apt-get update -qq
sudo apt-get install -y stow tmux direnv ripgrep

if [[ ! -d "$HOME/.fzf" ]]; then
  git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all --no-update-rc
fi

if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

if ! command -v eza >/dev/null 2>&1; then
  sudo apt-get install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update && sudo apt-get install -y eza
fi

if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1; then
  sudo apt-get install -y bat 2>/dev/null || true
fi

if ! command -v lazygit >/dev/null 2>&1; then
  LG_VERSION=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazygit/releases/latest | grep -o '[^/]*$' | sed 's/^v//')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VERSION}_Linux_${ARCH}.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit
  rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

if ! command -v atuin >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh || true
fi

if ! command -v nvim >/dev/null 2>&1; then
  curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
  sudo tar -xf /tmp/nvim.tar.gz -C /usr/local --strip-components=1
  rm /tmp/nvim.tar.gz
fi

source "$DOTFILES/install/common.sh"

"$DOTFILES/ai/mcp/home-assistant/install.sh"
"$DOTFILES/ai/mcp/home-assistant/register.sh"
