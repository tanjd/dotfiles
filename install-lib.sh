#!/usr/bin/env bash
# Shared helpers for install.sh and install.wsl.sh

# Symlinks $src to $dest, backing up $dest first if something other than
# our own symlink is already there (so a stray pre-existing file is never
# silently clobbered).
link_file() {
    local src="$1" dest="$2"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "$dest.bak"
        echo "Backed up existing $dest -> $dest.bak"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
}
