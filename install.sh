#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
ln -sfn "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
echo "zshrc linked."

# Claude Code
mkdir -p "$HOME/.claude"
ln -sfn "$DOTFILES_DIR/.claude/skills" "$HOME/.claude/skills"
ln -sfn "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
echo "Claude skills and settings linked."
