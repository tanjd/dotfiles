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

# Clones $repo into $dir, or shallow-updates an existing clone to upstream HEAD.
# oh-my-zsh's own auto-update doesn't touch $ZSH_CUSTOM, so without this a plugin
# stays pinned to whatever HEAD was current the day it was first installed.
# fetch+reset rather than `git pull`: these are --depth=1 clones, and merging into
# a grafted history fails with "unrelated histories".
clone_or_update() {
    local repo="$1" dir="$2"
    if [ -d "$dir/.git" ]; then
        # Best-effort. An existing clone used to mean zero network calls on re-run;
        # now that we always fetch, an unreachable remote (offline devcontainer
        # rebuild, flaky proxy) would abort the whole script via `set -e` before the
        # steps that follow. A stale-but-working plugin beats a half-finished install.
        if git -C "$dir" fetch --depth=1 --quiet origin HEAD 2>/dev/null; then
            git -C "$dir" reset --hard --quiet FETCH_HEAD
        else
            echo "Warning: could not reach $repo; keeping existing $dir as-is." >&2
        fi
    else
        git clone --depth=1 "$repo" "$dir"
    fi
}
