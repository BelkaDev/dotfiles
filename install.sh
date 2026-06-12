#!/usr/bin/env bash
set -euo pipefail

export DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ARCH="$(uname -m)"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

if [[ -n "${CODESPACE_NAME:-}" ]]; then
  "$DOTFILES/install/codespace.sh"
elif [[ -n "${TERMUX_VERSION:-}" ]]; then
  "$DOTFILES/install/termux.sh"
elif command -v pacman >/dev/null 2>&1; then
  "$DOTFILES/install/pacman.sh"
elif command -v apt-get >/dev/null 2>&1; then
  "$DOTFILES/install/apt.sh"
else
  echo "Unsupported environment" >&2
  exit 1
fi
