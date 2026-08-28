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

1. Install the same oh-my-zsh plugins as WSL2: `git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting` (`install.sh` handles installing oh-my-zsh itself and cloning `zsh-autosuggestions`/`zsh-syntax-highlighting`; the rest of the plugin list is bundled with oh-my-zsh already).
2. Clone this repo and run the macOS installer — pass `work` if this is the work laptop (personal + work repos both live under `~/projects/`, so git identity switches per-remote; see "macOS" under Platform-specific notes below), otherwise omit it:
   ```sh
   ./install.macos.sh [personal|work]
   ```
   This runs `install.sh` first, then symlinks `gitconfig.macos-<personal|work>` → `~/.gitconfig`, the shared `allowed_signers`, and `ssh_config.macos` → `~/.ssh/config` (1Password agent socket path differs from WSL — see "macOS" under Platform-specific notes below). Safe to re-run; pre-existing files get backed up to `<path>.bak`.
3. **If this is the work laptop**: also hand-create `~/.gitconfig-work` with your work identity — it's intentionally untracked (see "macOS" under Platform-specific notes below).
4. Optional — install dev tooling (`font-jetbrains-mono`, VS Code, Colima, Docker CLI, docker-compose, zsh-autocomplete) and symlink a Colima config template sized for this machine in one step — pass `work` for the work laptop's bigger VM spec, otherwise omit it:
   ```sh
   ./install.macos-dev.sh [personal|work]
   colima start
   ```
   See "macOS" under Platform-specific notes below for what the Colima settings do.
5. Optional — install personal apps (Obsidian, Tailscale):
   ```sh
   ./install.macos-personal.sh
   ```

### JetBrains Mono in Windows Terminal

If you `brew install --cask font-jetbrains-mono` from *inside WSL2*, it only becomes visible to Linux/WSLg apps — Windows Terminal is a native Windows app and can't see fonts installed into the WSL2 filesystem. To actually use it in Windows Terminal: install the font on the **Windows** side (`winget install --id JetBrains.JetBrainsMono`, or grab the `.ttf` files from `\\wsl$\<distro>\home\<user>\.local\share\fonts\` and install them via Explorer), then set it in Windows Terminal's profile settings. `windows-terminal-settings.json` in this repo already has the font configured — this only matters if you're setting up a new Windows machine from scratch.

## Structure

| File | Symlinked to | Platform |
|------|-------------|----------|
| `.zshrc` | `~/.zshrc` | Both |
| `.gitignore_global` | `~/.gitignore_global` | Both |
| `gitconfig.wsl` | `~/.gitconfig` | WSL only (auto-forwarded by devcontainer) |
| `gitconfig.macos-personal` | `~/.gitconfig` | macOS only, personal Mac |
| `gitconfig.macos-work` | `~/.gitconfig` | macOS only, work laptop |
| `ssh_config.wsl` | `~/.ssh/config` | WSL only (1Password agent socket path differs on macOS) |
| `ssh_config.macos` | `~/.ssh/config` | macOS only |
| `.claude/settings.json` | `~/.claude/settings.json` | Both |
| `.claude/skills/` | `~/.claude/skills/` | Both |
| `.config/git/allowed_signers` | `~/.config/git/allowed_signers` | Both |
| `windows-terminal-settings.json` | `/mnt/c/Users/tanjd/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json` | WSL only |
| `Brewfile` | not symlinked — run in place | Both |
| `Brewfile.macos-dev` | not symlinked — run in place | macOS only |
| `Brewfile.macos-personal` | not symlinked — run in place | macOS only |
| `colima.yaml.macos-personal` | `~/.colima/_templates/default.yaml` | macOS only, personal Mac |
| `colima.yaml.macos-work` | `~/.colima/_templates/default.yaml` | macOS only, work laptop |

## Install scripts reference

- **`install.sh`** — shared/cross-platform baseline. Installs oh-my-zsh itself (unattended) if `~/.oh-my-zsh` doesn't already exist, then symlinks `.zshrc`, `.gitignore_global`, `.claude/settings.json`, `.claude/skills/commit`, and clones the oh-my-zsh custom plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`) if missing. Run automatically by devcontainers.
- **`install.wsl.sh`** — calls `install.sh`, then additionally symlinks `gitconfig.wsl` → `~/.gitconfig`, `.config/git/allowed_signers`, `ssh_config.wsl` → `~/.ssh/config`, and (only when actually running under WSL with the Windows path present) `windows-terminal-settings.json` onto the Windows side. Manual, first-time-per-machine.
- **`install.macos.sh [personal|work]`** — macOS only. Calls `install.sh`, then symlinks `gitconfig.macos-<personal|work>` (default `personal`) → `~/.gitconfig`, `.config/git/allowed_signers`, and `ssh_config.macos` → `~/.ssh/config`. Mirrors `install.wsl.sh`'s structure. Manual, first-time-per-machine.
- **`install.macos-dev.sh [personal|work]`** — macOS only. Runs `brew bundle --file=Brewfile.macos-dev` (font-jetbrains-mono, VS Code, Colima, Docker CLI, docker-compose, zsh-autocomplete), then symlinks `colima.yaml.macos-<personal|work>` (default `personal`) → `~/.colima/_templates/default.yaml`. Doesn't call `install.sh` — run that separately first. Manual, first-time-per-machine (safe to re-run).
- **`install.macos-personal.sh`** — macOS only. Runs `brew bundle --file=Brewfile.macos-personal` (Obsidian, Tailscale). No symlinking. Manual, first-time-per-machine.
- All scripts back up any pre-existing non-symlink file to `<path>.bak` before symlinking (via `install-lib.sh`'s `link_file` helper) — safe to run on a machine with existing config. Re-running is idempotent.

## Homebrew packages (optional, manual)

- `Brewfile` — cross-platform formulae/casks (`gcc`, `gh`, `node`, `rtk`, `jq`, `tree`, the `claude-code` cask). Not run automatically by any install script:
  ```sh
  brew bundle --file=Brewfile
  ```
- `Brewfile.macos-dev` / `Brewfile.macos-personal` — macOS-only, split by purpose so a machine can install one without the other. Run via `./install.macos-dev.sh` / `./install.macos-personal.sh` (see above) or directly with `brew bundle --file=...`.

## CI

`.github/workflows/test-install.yml` runs `install.sh` on a fresh Ubuntu and macOS runner, `install.wsl.sh` on Ubuntu, and `install.macos.sh`/`install.macos-dev.sh`/`install.macos-personal.sh` on macOS, on every push/PR — catches a broken install script before it hits a real machine.

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
- `gitconfig.macos-personal`/`gitconfig.macos-work` contain macOS-specific git settings (mirror `gitconfig.wsl` otherwise):
  - `credential.helper = osxkeychain` — native Keychain instead of WSL's plaintext store
  - No `core.sshCommand` override — the native `ssh` binary is used directly
  - `gpg.ssh.program` — 1Password's native macOS SSH-signing binary at `/Applications/1Password.app/Contents/MacOS/op-ssh-sign`
  - `gitconfig.macos-work` additionally has two `includeIf "hasconfig:remote.*.url:..."` blocks (git ≥2.36) that switch to an untracked `~/.gitconfig-work` for any repo with a `git.autodesk.com` remote (matches both the `https://` and SSH-rewritten forms) — needed because personal and work repos both live under `~/projects/` with no folder-level separation, so the switch has to key off the remote instead of the path. Hand-create `~/.gitconfig-work` once on the work laptop with the work identity (and any work-only URL rewrites); it's untracked since employer email/signing key shouldn't be committed to a personal dotfiles repo. `gitconfig.macos-personal` skips all of this — a personal Mac never has an Autodesk remote to match.
- `ssh_config.macos` points `IdentityAgent` at 1Password's macOS SSH agent socket (`~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`) instead of the WSL bridge socket (`~/.1password/agent.sock`), and declares `Include ~/.colima/ssh_config` itself so Colima doesn't write that line through the symlink into this tracked file.
- `colima.yaml.macos-personal`/`colima.yaml.macos-work` configure Colima's VM for Apple Silicon: `vmType: vz` (Apple's Virtualization.framework, faster than the QEMU default) paired with `mountType: virtiofs` (faster than the default `sshfs`), a native `arch: aarch64` VM, and `rosetta: true` for occasional amd64-only images without giving up the native VM. They're split by machine rather than a single file because the work laptop needs meaningfully bigger resources (`cpu: 6` / `memory: 16` / `disk: 150` and `forwardAgent: true` to forward the 1Password SSH agent into the VM) than a personal Mac (`cpu: 4` / `memory: 4` / `disk: 100`, colima's own defaults otherwise) — pick with `install.macos-dev.sh [personal|work]`. Both are full commented templates (from `colima template`), so the diff between the two files documents exactly what's customized. It's a config *template*, only applied when a Colima profile is first created — symlinking it into place only takes effect before `colima start` runs for the first time (or after `colima delete`).
