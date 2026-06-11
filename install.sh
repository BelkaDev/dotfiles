#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Package manager ────────────────────────────────────────────────────────────
if command -v pacman >/dev/null 2>&1; then
  PM="pacman"
elif command -v apt-get >/dev/null 2>&1; then
  PM="apt"
else
  echo "Unsupported package manager" >&2
  exit 1
fi

pkg() {
  case "$PM" in
    pacman) sudo pacman -S --noconfirm --needed "$@" ;;
    apt)    sudo apt-get install -y "$@" ;;
  esac
}

ARCH="$(uname -m)"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

# ── System packages ────────────────────────────────────────────────────────────
if [[ "$PM" == "pacman" ]]; then
  sudo pacman -Sy --noconfirm --needed \
    stow tmux direnv ripgrep fzf zoxide eza bat lazygit atuin neovim

elif [[ "$PM" == "apt" ]]; then
  sudo apt-get update -qq
  pkg stow tmux direnv ripgrep

  if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
  fi

  if ! command -v zoxide >/dev/null 2>&1; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  if ! command -v eza >/dev/null 2>&1; then
    pkg gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update && pkg eza
  fi

  if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1; then
    pkg bat 2>/dev/null || true
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
fi

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
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

# ── tmux plugin manager ────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ── nvm + node ─────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node >/dev/null 2>&1; then
  nvm install --lts
fi

# ── Stow dotfiles ──────────────────────────────────────────────────────────────
rm -f "$HOME/.zshrc" "$HOME/.tmux.conf"

cd "$DOTFILES"

for pkg in zsh tmux nvim; do
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

ln -sfn "$DOTFILES/ai" "$HOME/ai"
echo "  linked ai"

if [[ -n "${CODESPACE_NAME:-}" ]]; then
  ln -sfn "$DOTFILES/codespace" "$HOME/codespace"
  echo "  linked codespace"
fi

if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(which zsh)" 2>/dev/null || true
fi

# ── AI tools ───────────────────────────────────────────────────────────────────
"$DOTFILES/ai/install.sh"

echo "Done."
