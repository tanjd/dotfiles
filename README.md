# dotfiles

Personal dotfiles for WSL (Ubuntu) and macOS.

## Quick start

Pick the scenario that matches what you're setting up. If you've forgotten everything, start here.

### New WSL2 machine (personal)

1. Clone this repo (anywhere — `~/projects/dotfiles` is the convention used elsewhere in these notes):
   ```sh
   git clone <this-repo-url> ~/projects/dotfiles
   cd ~/projects/dotfiles
   ```
2. Run the WSL installer:
   ```sh
   ./install.wsl.sh
   ```
   This installs oh-my-zsh itself if it's not already present (unattended, no prompts), then symlinks everything — `.zshrc`, git config, SSH config, Claude Code config, and (if the Windows-side path is present) Windows Terminal settings. Safe to re-run any time; pre-existing files get backed up to `<path>.bak` on first run, not silently overwritten.
3. Restart your shell (or open a new Windows Terminal tab).
4. Optional — install the dev tooling (`gcc`, `gh`, `node`, `rtk`, Claude Code) via Homebrew/Linuxbrew:
   ```sh
   brew bundle --file=Brewfile
   ```

### Devcontainer

Nothing to do manually — `install.sh` runs automatically as part of devcontainer setup (git config is expected to already be forwarded by the devcontainer tooling; `install.sh` installs oh-my-zsh itself if the base image doesn't already have it).

### New Mac (personal or work)

**Not fully automated yet** — there's no `install.macos.sh` or `gitconfig.macos` in this repo yet. Until that exists:

1. Install the same oh-my-zsh plugins as WSL2: `git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting` (`install.sh` handles installing oh-my-zsh itself and cloning `zsh-autosuggestions`/`zsh-syntax-highlighting`; the rest of the plugin list is bundled with oh-my-zsh already).
2. Clone this repo and run the shared installer:
   ```sh
   ./install.sh
   ```
3. Manually configure git — see "macOS" under Platform-specific notes below.
4. Optional — `brew bundle --file=Brewfile` (this also installs the macOS-only extras: JetBrains Mono font, Colima, Docker CLI, docker-compose).
5. **If this is the work laptop**: git identity switching (work vs. personal repos, both live under `~/projects/`) isn't set up yet either — see `CLAUDE.md`'s "Planned, not yet implemented" section for the exact plan before improvising something here.

### JetBrains Mono in Windows Terminal

If you `brew install --cask font-jetbrains-mono` from *inside WSL2*, it only becomes visible to Linux/WSLg apps — Windows Terminal is a native Windows app and can't see fonts installed into the WSL2 filesystem. To actually use it in Windows Terminal: install the font on the **Windows** side (`winget install --id JetBrains.JetBrainsMono`, or grab the `.ttf` files from `\\wsl$\<distro>\home\<user>\.local\share\fonts\` and install them via Explorer), then set it in Windows Terminal's profile settings. `windows-terminal-settings.json` in this repo already has the font configured — this only matters if you're setting up a new Windows machine from scratch.

## Structure

| File | Symlinked to | Platform |
|------|-------------|----------|
| `.zshrc` | `~/.zshrc` | Both |
| `.gitignore_global` | `~/.gitignore_global` | Both |
| `gitconfig.wsl` | `~/.gitconfig` | WSL only (auto-forwarded by devcontainer) |
| `ssh_config.wsl` | `~/.ssh/config` | WSL only (1Password agent socket path differs on macOS) |
| `.claude/settings.json` | `~/.claude/settings.json` | Both |
| `.claude/skills/` | `~/.claude/skills/` | Both |
| `.config/git/allowed_signers` | `~/.config/git/allowed_signers` | WSL only |
| `windows-terminal-settings.json` | `/mnt/c/Users/tanjd/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json` | WSL only |
| `Brewfile` | not symlinked — run in place | Both |

## Install scripts reference

- **`install.sh`** — shared/cross-platform baseline. Installs oh-my-zsh itself (unattended) if `~/.oh-my-zsh` doesn't already exist, then symlinks `.zshrc`, `.gitignore_global`, `.claude/settings.json`, `.claude/skills/commit`, and clones the oh-my-zsh custom plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`) if missing. Run automatically by devcontainers.
- **`install.wsl.sh`** — calls `install.sh`, then additionally symlinks `gitconfig.wsl` → `~/.gitconfig`, `.config/git/allowed_signers`, `ssh_config.wsl` → `~/.ssh/config`, and (only when actually running under WSL with the Windows path present) `windows-terminal-settings.json` onto the Windows side. Manual, first-time-per-machine.
- Both scripts back up any pre-existing non-symlink file to `<path>.bak` before symlinking (via `install-lib.sh`'s `link_file` helper) — safe to run on a machine with existing config. Re-running is idempotent.

## Homebrew packages (optional, manual)

`Brewfile` lists the Homebrew/Linuxbrew formulae and casks for this dev environment (`gcc`, `gh`, `node`, `rtk`, `jq`, `tree`, the `claude-code` cask), plus a macOS-only section (`font-jetbrains-mono`, `colima`, `docker`, `docker-compose`) gated behind `if OS.mac?`. Not run automatically by either install script — install deliberately with:

```sh
brew bundle --file=Brewfile
```

## CI

`.github/workflows/test-install.yml` runs `install.sh` on a fresh Ubuntu and macOS runner, and `install.wsl.sh` on Ubuntu, on every push/PR — catches a broken install script before it hits a real machine.

## Platform-specific notes

### WSL
- `.zshrc` uses a conditional block (`grep -qi microsoft /proc/version`) for WSL-only settings:
  - Linuxbrew `PATH`
  - `ssh` / `ssh-add` aliased to their `.exe` Windows binaries for SSH agent interop
- `gitconfig.wsl` contains WSL-specific git settings:
  - `core.sshCommand = ssh.exe` — uses the Windows SSH binary
  - `credential.helper = store` — plaintext credential store (macOS uses `osxkeychain` by default)
  - `gpg.ssh.program` — 1Password WSL SSH signing binary

### macOS
- Install oh-my-zsh and the same plugins: `git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting`
- Git commit signing: configure `[gpg "ssh"]` separately with the macOS 1Password SSH agent socket
- See `CLAUDE.md`'s "Planned, not yet implemented" section for what's still missing (`gitconfig.macos`, `install.macos.sh`, work-vs-personal git identity switching)
