#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

brew bundle --file="$DOTFILES_DIR/Brewfile.macos-dev"
echo "macOS dev tooling installed."

# Colima config template — must be in place before the VM's first
# 'colima start', since the template only applies when a profile is
# first created (config precedence: defaults -> template -> profile -> CLI flags).
link_file "$DOTFILES_DIR/colima.yaml" "$HOME/.colima/_templates/default.yaml"
echo "colima.yaml linked. Run 'colima start' to launch the VM."
