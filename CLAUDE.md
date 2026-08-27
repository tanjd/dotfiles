# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for WSL (Ubuntu) and macOS. Plain shell scripts and config files that get symlinked into `$HOME` (and, for one file, into the Windows side of a WSL2 machine). See README.md for the full file-to-symlink mapping.

## Install commands

- `./install.sh` — shared/cross-platform install, run automatically by devcontainers. Installs oh-my-zsh itself (unattended — no prompt, no shell launch, no `chsh`) if `~/.oh-my-zsh` doesn't exist, **before** the `.zshrc` symlink step — the oh-my-zsh installer overwrites `~/.zshrc` with its own template unless it runs first and gets overwritten by our symlink, not the other way around. Then symlinks `.zshrc`, `.gitignore_global`, `.claude/settings.json`, and each skill listed in `INSTALLED_SKILLS` individually (not the whole `.claude/skills/` directory — see below), and clones the oh-my-zsh custom plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`) into `$ZSH_CUSTOM/plugins` if missing.
- `./install.wsl.sh` — WSL-only, run manually once per new WSL2 environment. Calls `install.sh` first, then additionally symlinks `gitconfig.wsl` → `~/.gitconfig`, `.config/git/allowed_signers` → `~/.config/git/allowed_signers`, and `ssh_config.wsl` → `~/.ssh/config`. Also symlinks `windows-terminal-settings.json` onto the Windows side via `/mnt/c/Users/tanjd/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json`, guarded behind an actual WSL detection check (`grep -qi microsoft /proc/version`) plus a path-exists check — so this step no-ops safely in CI or on a machine where that package hash differs, rather than assuming "this script is named `.wsl.sh` so it's always real WSL."
- Both scripts use the shared `link_file` helper in `install-lib.sh`, which backs up any pre-existing non-symlink file at the target path to `<path>.bak` before symlinking — so a forgotten pre-existing `.zshrc`/`.gitconfig` on a machine is never silently clobbered. Re-running is idempotent: once a path is our symlink, subsequent runs skip the backup step.
- No macOS install script exists yet; macOS setup is manual (see README "Platform-specific notes").
- `Brewfile` (repo root) lists Homebrew/Linuxbrew formulae and casks (`gcc`, `gh`, `node`, `rtk`, `claude-code` cask). Not symlinked or run automatically by either install script — apply manually with `brew bundle --file=Brewfile`. Deliberately excludes winget entries and npm globals that `brew bundle dump` also picks up on this machine — those aren't portable to macOS and aren't Homebrew's concern. A `Brewfile` is itself a small Ruby DSL (evaluated by `brew bundle`), so it uses a real `if OS.mac? ... end` conditional for macOS-only packages (`font-jetbrains-mono`, `colima`, `docker`, `docker-compose`) that don't apply to WSL2/Linuxbrew — no second Brewfile needed.
- `.github/workflows/test-install.yml` runs `install.sh` on Ubuntu + macOS runners and `install.wsl.sh` on Ubuntu, on every push/PR — the only CI in this repo, exists purely to catch a broken install script before it hits a real machine.

There is no build, lint, or test tooling beyond that CI workflow (no Makefile, no package.json).

## Architecture

- **Platform split happens at install time**, via separate scripts/files rather than in-script branching: `install.sh` (shared baseline) vs `install.wsl.sh` (WSL superset) vs `gitconfig.wsl`/`ssh_config.wsl` (WSL-only configs, `.wsl` suffix convention; no macOS equivalents exist yet since their contents are genuinely platform-specific — e.g. `ssh_config.wsl`'s `IdentityAgent` path points at 1Password's WSL bridge socket, which differs from 1Password's macOS agent socket path).
- **Two runtime OS-detection conditionals** exist in `.zshrc`: `grep -qi microsoft /proc/version` for WSL (sets Linuxbrew PATH and `ssh`/`ssh-add` aliases pointed at the Windows `.exe` binaries for SSH agent interop), and `uname == Darwin` for macOS (evals `brew shellenv` from either the Apple Silicon or Intel Homebrew prefix).
- This repo doubles as the source of truth for the user's own Claude Code global config: `.claude/settings.json` here is symlinked to `~/.claude/settings.json`, and skills under `.claude/skills/` are symlinked individually per `INSTALLED_SKILLS` in `install.sh` (currently just `commit`). Editing them changes the user's actual Claude Code setup on any machine where the install scripts have run.
- `.claude/skills/create-pr/` is intentionally **not** installed globally — it's kept here for reference only. Repos that need PR-creation automation (e.g. `core-repository`) define their own local `.claude/skills/create-pr/` override with repo-specific conventions, which always takes precedence over any global skill regardless of whether the global one is installed.
- Git commit signing uses SSH keys (not GPG): `gitconfig.wsl` sets `gpg.format = ssh` and signs via a 1Password WSL SSH-signing binary; `.config/git/allowed_signers` holds the public key used to verify signatures.

## Known inconsistencies in `.claude/skills/`

- `create-pr/SKILL.md` (uninstalled, kept for reference) uses `master` as the PR base branch, but this repo's actual default branch is `main` (per `gitconfig.wsl`'s `defaultBranch = main`). Not currently a live issue since the skill isn't installed, but fix this if it's ever revived/installed elsewhere.

## Planned, not yet implemented

Picking this up on a Mac (personal or work)? Start here:

- **`gitconfig.macos` + `install.macos.sh` don't exist yet.** Mac git setup is currently fully manual (see README "Platform-specific notes"). These should mirror `gitconfig.wsl`/`install.wsl.sh`'s structure: same non-platform-specific settings (pull/push/merge/diff/fetch/rebase/status/branch/tag/log/rerere blocks), but swap `credential.helper = store` → `osxkeychain`, drop `core.sshCommand = ssh.exe` (unneeded natively on macOS), and point `gpg.ssh.program` at 1Password's macOS SSH-signing binary instead of the WSL bridge binary. **Don't guess the exact 1Password macOS paths** (signing binary, agent socket) — verify them on the actual Mac (`ls "/Applications/1Password.app/Contents/MacOS/"`, check 1Password's own SSH agent settings) rather than trusting a remembered default, since a wrong path fails silently/confusingly on commit.
- **Work-laptop git identity switching**: work and personal repos will both live under `~/projects/` with no folder-level separation (confirmed by the user — a `gitdir:`-based `includeIf` won't distinguish them). Use `includeIf "hasconfig:remote.*.url:<pattern>"` instead (git ≥2.36), matching on the work remote's URL/org pattern — needs the user's actual employer GitHub org (or self-hosted git host) to fill in `<pattern>`, not yet known since the work laptop isn't set up.
- **Keep the work identity itself out of this repo.** The matched-in file (e.g. `~/.gitconfig-work`, referenced via `[includeIf ...] path = ~/.gitconfig-work`) should stay untracked and be created by hand once on the work laptop — employer email/signing key shouldn't be committed to a personal dotfiles repo. Only the `includeIf` line pointing at it belongs in `gitconfig.macos`.
- Personal machines (personal Mac, personal WSL2) need none of the above — they only ever use the single default identity already in `gitconfig.wsl`/`gitconfig.macos`, unchanged.
