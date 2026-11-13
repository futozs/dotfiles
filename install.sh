#!/usr/bin/env bash
# Set up this Mac from the dotfiles repo.
#   ./install.sh            Homebrew packages, config symlinks, shell history import
#   ./install.sh --all      same, plus clone and install claude-setup and vscode-setup
#   ./install.sh --links    only (re)create symlinks, no network
# Safe to re-run. Anything it replaces goes to ~/dotfiles-backups/<timestamp>/ first.
# macOS preferences are separate on purpose: run ./macos.sh yourself.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
MODE="${1:-}"

say() { printf '\033[1m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!!\033[0m %s\n' "$*"; }

[ "$(uname)" = Darwin ] || { echo "macOS only"; exit 1; }

if ! command -v brew >/dev/null; then
  echo "Install Homebrew first: https://brew.sh"; exit 1
fi

if [ "$MODE" != "--links" ]; then
  say "Homebrew packages (installs what is missing, removes nothing)"
  brew bundle --no-upgrade --file="$REPO/Brewfile"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    say "oh-my-zsh + powerlevel10k"
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
  P10K="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  [ -d "$P10K" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K"
fi

link() { # link <repo-path> <target>
  local src="$REPO/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then rm "$dst"
  elif [ -e "$dst" ]; then mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/"; warn "backed up $dst -> $BACKUP/"
  fi
  ln -s "$src" "$dst"
  echo "   $dst"
}

say "Linking config"
link zsh/zshrc        "$HOME/.zshrc"
link zsh/zprofile     "$HOME/.zprofile"
link zsh/p10k.zsh     "$HOME/.p10k.zsh"
link ghostty/config   "$HOME/.config/ghostty/config"
link git/ignore       "$HOME/.config/git/ignore"
link mise/config.toml "$HOME/.config/mise/config.toml"
link atuin/config.toml "$HOME/.config/atuin/config.toml"

# ~/.gitconfig stays a local file (name, email, per-machine bits) and includes the shared config.
if ! git config --global --get-all include.path | grep -qx "$REPO/git/config"; then
  git config --global --add include.path "$REPO/git/config"
  echo "   ~/.gitconfig includes git/config"
fi

if [ "$MODE" != "--links" ] && command -v atuin >/dev/null && [ ! -f "$HOME/.local/share/atuin/.imported" ]; then
  say "Importing shell history into atuin"
  atuin import auto && mkdir -p "$HOME/.local/share/atuin" && touch "$HOME/.local/share/atuin/.imported"
fi

if [ "$MODE" = "--all" ]; then
  for repo in claude-setup vscode-setup; do
    dir="$HOME/Developer/personal/$repo"
    [ -d "$dir" ] || git clone "https://github.com/futozs/$repo.git" "$dir"
    say "Running $repo/install.sh"
    "$dir/install.sh"
  done
fi

say "Done. Open a new terminal (or run: exec zsh). Then run ./macos.sh for system preferences."
