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
#
# Can't use link_file here: a plain `ln -s` stores a Linux path (e.g.
# /home/.../windows-terminal-settings.json) as the target. Windows Terminal is
# a native Windows process and can't resolve that — it fails with "the file
# cannot be accessed by the system". It needs a Windows-native symlink
# pointing at the \\wsl.localhost UNC form of the same file instead, which
# requires going through powershell.exe and (on most machines) Developer Mode
# enabled, or an elevated shell.
if grep -qi microsoft /proc/version 2>/dev/null; then
    WT_SETTINGS="/mnt/c/Users/tanjd/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    if [ -d "$(dirname "$WT_SETTINGS")" ]; then
        if [ -e "$WT_SETTINGS" ] && [ ! -L "$WT_SETTINGS" ]; then
            mv "$WT_SETTINGS" "$WT_SETTINGS.bak"
            echo "Backed up existing $WT_SETTINGS -> $WT_SETTINGS.bak"
        fi
        rm -f "$WT_SETTINGS"
        if SRC_WIN="$(wslpath -w "$DOTFILES_DIR/windows-terminal-settings.json")" \
           DEST_WIN="$(wslpath -w "$WT_SETTINGS")" \
           powershell.exe -NoProfile -Command 'New-Item -ItemType SymbolicLink -Path $env:DEST_WIN -Target $env:SRC_WIN | Out-Null'; then
            echo "Windows Terminal settings linked."
        else
            echo "Windows Terminal settings symlink failed (enable Developer Mode, or create it manually from an elevated PowerShell) — skipping."
        fi
    else
        echo "Windows Terminal settings.json path not found, skipping."
    fi
fi
