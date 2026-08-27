#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

# Run shared install
"$DOTFILES_DIR/install.sh"

# git
link_file "$DOTFILES_DIR/gitconfig.wsl" "$HOME/.gitconfig"
echo "gitconfig linked."

# git allowed signers (SSH commit verification)
link_file "$DOTFILES_DIR/.config/git/allowed_signers" "$HOME/.config/git/allowed_signers"
echo "allowed_signers linked."

# ssh (1Password agent socket path is WSL-specific)
link_file "$DOTFILES_DIR/ssh_config.wsl" "$HOME/.ssh/config"
echo "ssh config linked."

# Windows Terminal settings — only when actually running under WSL with the
# Windows filesystem mounted. No-op elsewhere (e.g. CI, or a machine where
# Windows Terminal's package hash differs), so this script stays safe to run.
if grep -qi microsoft /proc/version 2>/dev/null; then
    WT_SETTINGS="/mnt/c/Users/tanjd/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    if [ -d "$(dirname "$WT_SETTINGS")" ]; then
        link_file "$DOTFILES_DIR/windows-terminal-settings.json" "$WT_SETTINGS"
        echo "Windows Terminal settings linked."
    else
        echo "Windows Terminal settings.json path not found, skipping."
    fi
fi
