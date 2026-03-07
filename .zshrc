export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export POETRY_PATH="/home/tanjd/.local/bin"
export PATH="$PATH:$POETRY_PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="gnzh"
zstyle ':omz:update' mode auto

COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-autosuggestions z sudo copypath alias-finder zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Example aliases
alias zshconfig="cursor ~/.zshrc"
alias awsconfig="cursor ~/.aws/config"
alias gitconfig="cursor ~/.gitconfig"
alias sshconfig="cursor ~/.ssh/config"
alias gpgconfig="cursor ~/.gnupg/gpg-agent.conf"
alias projects="cd ~/projects"
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'
alias amend="git commit --amend --no-edit"