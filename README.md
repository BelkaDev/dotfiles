# dotfiles

Personal dotfiles for Linux (apt/pacman), GitHub Codespaces, and Termux, managed with [stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone https://github.com/BelkaDev/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Detects the environment automatically (Codespaces, Termux, apt, pacman).

## GitHub Codespaces

Enable this repo as your dotfiles in [Codespaces settings](https://github.com/settings/codespaces). GitHub will run `install.sh` automatically when a codespace is created.

## Secrets

Sensitive env vars go in `~/.zshrc.secrets` (not tracked).

## TODO

- Migrate to [Nix](https://nixos.org/) or [chezmoi](https://www.chezmoi.io/) for declarative, environment-aware dotfiles management
- Move `docker/milvus-start.sh` into `ai/milvus/`
