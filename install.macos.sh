#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

# Run shared install
"$DOTFILES_DIR/install.sh"

# git
link_file "$DOTFILES_DIR/gitconfig.macos" "$HOME/.gitconfig"
echo "gitconfig linked."

# git allowed signers (SSH commit verification) — same identity as WSL
link_file "$DOTFILES_DIR/.config/git/allowed_signers" "$HOME/.config/git/allowed_signers"
echo "allowed_signers linked."

# ssh (1Password agent socket path is macOS-specific)
link_file "$DOTFILES_DIR/ssh_config.macos" "$HOME/.ssh/config"
echo "ssh config linked."
