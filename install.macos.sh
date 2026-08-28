#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

# Run shared install
"$DOTFILES_DIR/install.sh"

# git — personal and work laptops need different identities (see gitconfig.macos-work's
# includeIf blocks), so pick with:
#   ./install.macos.sh work
# Defaults to "personal" if no argument is given.
GITCONFIG_PROFILE="${1:-personal}"
case "$GITCONFIG_PROFILE" in
    personal|work) ;;
    *)
        echo "Unknown gitconfig profile '$GITCONFIG_PROFILE' (expected 'personal' or 'work')." >&2
        exit 1
        ;;
esac
link_file "$DOTFILES_DIR/gitconfig.macos-$GITCONFIG_PROFILE" "$HOME/.gitconfig"
echo "gitconfig.macos-$GITCONFIG_PROFILE linked."

# git allowed signers (SSH commit verification) — same identity as WSL
link_file "$DOTFILES_DIR/.config/git/allowed_signers" "$HOME/.config/git/allowed_signers"
echo "allowed_signers linked."

# ssh (1Password agent socket path is macOS-specific)
link_file "$DOTFILES_DIR/ssh_config.macos" "$HOME/.ssh/config"
echo "ssh config linked."
