# dotfiles

Personal dotfiles for WSL (Ubuntu) and macOS.

## Structure

| File | Symlinked to | Platform |
|------|-------------|----------|
| `.zshrc` | `~/.zshrc` | Both |
| `gitconfig.wsl` | `~/.gitconfig` | WSL only (auto-forwarded by devcontainer) |
| `.claude/settings.json` | `~/.claude/settings.json` | Both |
| `.claude/skills/` | `~/.claude/skills/` | Both |
| `.config/git/allowed_signers` | `~/.config/git/allowed_signers` | WSL only |

## Install

### Devcontainer (shared)

`install.sh` is run automatically by the devcontainer to set up shared dotfiles:

```sh
./install.sh
```

Links: `.zshrc`, `.claude/settings.json`, `.claude/skills/`

### WSL2 (manual, first-time setup)

Run once when setting up a new WSL2 environment:

```sh
./install.wsl.sh
```

Links everything from `install.sh`, plus WSL-specific files:
- `gitconfig.wsl` → `~/.gitconfig`
- `.config/git/allowed_signers` → `~/.config/git/allowed_signers`

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
