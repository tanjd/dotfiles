# Homebrew/Linuxbrew formulae and casks for this dev environment.
# Install with: brew bundle --file=Brewfile

brew "gcc"   # GNU compiler collection
brew "gh"    # GitHub command-line tool
brew "node"  # JavaScript runtime
brew "rtk"   # Token-optimized CLI proxy (see RTK.md)
brew "jq"    # JSON processor
brew "tree"  # Recursive directory lister

cask "claude-code"  # Claude Code CLI

if OS.mac?
  cask "font-jetbrains-mono"  # terminal/editor font

  brew "colima"          # container runtime (Docker Desktop alternative)
  brew "docker"          # Docker CLI, talks to colima
  brew "docker-compose"  # docker compose CLI plugin
end
