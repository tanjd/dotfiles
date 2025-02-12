
export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export POETRY_PATH="/home/tanjd/.local/bin"
export PATH="$PATH:$POETRY_PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="gnzh"
zstyle ':omz:update' mode auto

COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-autosuggestions z sudo zsh-syntax-highlighting copypath alias-finder)

source $ZSH/oh-my-zsh.sh

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Example aliases
alias zshconfig="code ~/.zshrc"
alias awsconfig="code ~/.aws/config"
alias gitconfig="code ~/.gitconfig"
alias sshconfig="code ~/.ssh/config"
alias gpgconfig="code ~/.gnupg/gpg-agent.conf"
alias projects="cd ~/projects"