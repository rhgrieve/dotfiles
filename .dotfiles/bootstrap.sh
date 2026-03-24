#!/bin/bash
# bootstrap.sh — fresh machine setup

set -e

DOTFILES_REPO="git@github.com:rhgrieve/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "🔧 Cloning dotfiles..."
git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

function dot {
  git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"
}

echo "📦 Checking out files..."
dot checkout 2>/dev/null || {
  echo "⚠️  Conflicts detected — backing up pre-existing files..."
  dot checkout 2>&1 | grep "^\s" | awk '{print $1}' | xargs -I{} sh -c 'mkdir -p "$HOME/.dotfiles-backup/$(dirname {})" && mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"'
  dot checkout
}

dot config --local status.showUntrackedFiles no

echo "🍺 Installing Homebrew (if missing)..."
which brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "✅ Done! Next steps:"
echo "  1. source ~/.zshrc"
echo "  2. nvim  (LazyVim will auto-install plugins)"
echo "  3. bash ~/.macos  (if on a fresh Mac)"

