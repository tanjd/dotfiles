export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# WSL-specific settings
if grep -qi microsoft /proc/version 2>/dev/null; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    # Use Windows SSH binaries for WSL interop (enables Windows ssh-agent and key access)
    alias ssh='ssh.exe'
    alias ssh-add='ssh-add.exe'
fi

# macOS-specific settings
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # 1Password SSH agent socket, for SSH auth + git commit signing (see gitconfig.macos)
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

    # Only set up zsh-autocomplete if `brew bundle --file=Brewfile.macos-dev` has been
    # run — it's optional tooling installed separately from the baseline install.sh,
    # so a fresh Mac that hasn't run it yet shouldn't hit a "no such file" on every shell.
    if [[ -f "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
        ZSH_AUTOCOMPLETE_LOADED=1

        # The plugin resolves its own path with `:P`, so it puts the *version-pinned* Cellar dir in
        # $fpath. `brew upgrade` deletes that dir, breaking lazy autoloads of Completions/* in
        # already-running shells (e.g. `_autocomplete__history_lines` on up-arrow). Prepending the
        # stable symlink path gives autoload a fallback that survives upgrades.
        fpath=( "$HOMEBREW_PREFIX/share/zsh-autocomplete/Completions" $fpath )

        # Must load before any `compdef` call (oh-my-zsh's git plugin makes several):
        # Autocomplete queues them and replays them after it runs compinit.
        source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

        # Autocomplete runs the one real compinit itself, at the first precmd, and
        # unfunctions this stub beforehand. Stubbing makes oh-my-zsh's internal
        # compinit call a no-op so the dump is built once and stays cached.
        compinit() { : }
        _comp_dumpfile=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump
    fi
fi

ZSH_THEME="gnzh"
zstyle ':omz:update' mode auto

COMPLETION_WAITING_DOTS="true"

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE

plugins=(git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting)

if [[ -n "$ZSH_AUTOCOMPLETE_LOADED" ]]; then
    # With compinit stubbed above, oh-my-zsh never writes a real dump here — only its
    # own bookkeeping metadata — so keep that stub out of $HOME.
    ZSH_COMPDUMP=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/omz-compdump
    # oh-my-zsh's lib/completion.zsh overwrites Autocomplete's single-pass
    # matcher-list with a multi-pass one; save and restore it.
    zstyle -g _ac_matcher_list ':completion:*' matcher-list
fi

source $ZSH/oh-my-zsh.sh

if [[ -n "$ZSH_AUTOCOMPLETE_LOADED" ]]; then
    zstyle ':completion:*' matcher-list "${_ac_matcher_list[@]}"
    unset _ac_matcher_list

    # Autocomplete appends oh-my-zsh's metadata to $ZSH_COMPDUMP each time it runs
    # compinit, which grows the file without bound now that oh-my-zsh's own compinit
    # is a no-op. oh-my-zsh has no further use for the variable after this point.
    unset ZSH_COMPDUMP

    # oh-my-zsh's lib/key-bindings.zsh rebinds these after Autocomplete loads.
    bindkey '^[[A' up-line-or-search   '^[OA' up-line-or-search
    bindkey '^[[B' down-line-or-select '^[OB' down-line-or-select
    [[ -v terminfo[kcuu1] ]] && bindkey -M emacs "$terminfo[kcuu1]" up-line-or-search
    [[ -v terminfo[kcud1] ]] && bindkey -M emacs "$terminfo[kcud1]" down-line-or-select
    [[ -v terminfo[kcbt]  ]] && bindkey -M emacs "$terminfo[kcbt]"  expand-word

    unset ZSH_AUTOCOMPLETE_LOADED
fi

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Example aliases
alias zshconfig="code ~/.zshrc"
alias awsconfig="code ~/.aws/config"
alias gitconfig="code ~/.gitconfig"
alias sshconfig="code ~/.ssh/config"
alias projects="cd ~/projects"
alias amend="git commit --amend --no-edit"
alias glog="git log --graph --decorate -5"
