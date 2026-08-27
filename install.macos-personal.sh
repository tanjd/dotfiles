#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew bundle --file="$DOTFILES_DIR/Brewfile.macos-personal"
echo "macOS personal apps installed."
