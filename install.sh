#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

# zsh itself, required by oh-my-zsh below. Not preinstalled on bare Ubuntu
# (including GitHub Actions' ubuntu-latest runner); macOS ships it already
# but brew is the natural fallback if it's ever missing there too.
if ! command -v zsh >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v brew >/dev/null 2>&1; then
        brew install zsh
    else
        echo "zsh is not installed and no supported package manager (apt-get/brew) was found to install it. Install zsh manually and re-run." >&2
        exit 1
    fi
    echo "zsh installed."
fi

# oh-my-zsh itself (required by .zshrc). Must run before the .zshrc symlink
# below: the installer overwrites ~/.zshrc with its own template unless told
# otherwise, so it needs to go first and get overwritten by our symlink, not
# the other way around. --unattended skips the interactive prompt, the
# post-install shell launch, and changing the default shell.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "oh-my-zsh installed."
fi

# zsh
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
echo "zshrc linked."

# git (cross-platform ignore patterns)
link_file "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
echo "gitignore_global linked."

# zsh custom plugins (not bundled with oh-my-zsh)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
echo "zsh plugins installed."

# Claude Code
mkdir -p "$HOME/.claude"
# Migrate from the old whole-directory skills symlink, if present.
[ -L "$HOME/.claude/skills" ] && rm "$HOME/.claude/skills"
mkdir -p "$HOME/.claude/skills"
# Only install skills meant for global use. create-pr is intentionally excluded:
# it's kept in this repo for reference, but repos that need it (e.g. core-repository)
# define their own local override with repo-specific conventions.
INSTALLED_SKILLS=(commit)
for skill in "${INSTALLED_SKILLS[@]}"; do
    link_file "$DOTFILES_DIR/.claude/skills/$skill" "$HOME/.claude/skills/$skill"
done
link_file "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
echo "Claude skills and settings linked."
