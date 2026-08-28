#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/install-lib.sh"

brew bundle --file="$DOTFILES_DIR/Brewfile.macos-dev"
echo "macOS dev tooling installed."

# Colima config template — must be in place before the VM's first
# 'colima start', since the template only applies when a profile is
# first created (config precedence: defaults -> template -> profile -> CLI flags).
# Personal and work machines run different VM sizes, so pick with:
#   ./install.macos-dev.sh work
# Defaults to "personal" if no argument is given.
COLIMA_PROFILE="${1:-personal}"
case "$COLIMA_PROFILE" in
    personal|work) ;;
    *)
        echo "Unknown colima profile '$COLIMA_PROFILE' (expected 'personal' or 'work')." >&2
        exit 1
        ;;
esac
link_file "$DOTFILES_DIR/colima.yaml.macos-$COLIMA_PROFILE" "$HOME/.colima/_templates/default.yaml"
echo "colima.yaml.macos-$COLIMA_PROFILE linked. Run 'colima start' to launch the VM."
