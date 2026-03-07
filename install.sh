#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Claude skills
mkdir -p "$HOME/.claude"
ln -sfn "$DOTFILES_DIR/.claude/skills" "$HOME/.claude/skills"
echo "Claude skills linked."
