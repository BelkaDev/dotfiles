# dotfiles

Personal dotfiles for Linux (apt/pacman) and GitHub Codespaces, managed with [stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone https://github.com/BelkaDev/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

## GitHub Codespaces

Enable this repo as your dotfiles in [Codespaces settings](https://github.com/settings/codespaces). GitHub will run `install.sh` automatically when a codespace is created.

## Termux

```bash
./install-termux.sh
```


## Secrets

Sensitive env vars go in `~/.zshrc.secrets` (not tracked).

