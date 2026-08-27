export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="gnzh"
zstyle ':omz:update' mode auto

COMPLETION_WAITING_DOTS="true"

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE

plugins=(git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

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
fi