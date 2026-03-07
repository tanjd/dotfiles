#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run shared install
"$DOTFILES_DIR/install.sh"

# git
ln -sfn "$DOTFILES_DIR/gitconfig.wsl" "$HOME/.gitconfig"
echo "gitconfig linked."

# git allowed signers (SSH commit verification)
mkdir -p "$HOME/.config/git"
ln -sfn "$DOTFILES_DIR/.config/git/allowed_signers" "$HOME/.config/git/allowed_signers"
echo "allowed_signers linked."
