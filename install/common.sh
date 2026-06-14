#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ install/common.sh failed at line $LINENO" >&2' ERR

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
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

# ── tmux plugin manager ────────────────────────────────────────────────────────
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && \
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# ── nvm + node ─────────────────────────────────────────────────────────────────
if [[ ! -d "${NVM_DIR:-$HOME/.nvm}" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

node_major="$(node -e 'process.stdout.write(String(process.versions.node.split(".")[0]))' 2>/dev/null || echo 0)"
if [[ "$node_major" -lt 18 ]]; then
  nvm install --lts
fi

# ── Stow dotfiles ──────────────────────────────────────────────────────────────
rm -f "$HOME/.zshrc" "$HOME/.tmux.conf"
cd "$DOTFILES"

for pkg in zsh tmux nvim; do
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  echo "  stowed $pkg"
done

command -v zsh >/dev/null 2>&1 && chsh -s "$(which zsh)" 2>/dev/null || true

# ── AI tools ───────────────────────────────────────────────────────────────────
echo "==> running ai/install.sh from $DOTFILES"
"$DOTFILES/ai/install.sh"

echo "Done."
