# Cesar's zshrc

export DOTFILES_DIR="$HOME/dotfiles"
export ZSH="${DOTFILES_DIR}/oh-my-zsh"
export ZSH_THEME="crg"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)

source ${ZSH}/oh-my-zsh.sh
source "${DOTFILES_DIR}"/environment.zsh

ZSH_HIGHLIGHT_STYLES[globbing]=fg=green,bold


if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# GitHub
source ${DOTFILES_DIR}/functions_github.zsh

# Golang
source ${DOTFILES_DIR}/functions_golang.zsh

# tmux 
source ${DOTFILES_DIR}/functions_tmux.zsh

# Darwin only
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ${DOTFILES_DIR}/functions_darwin.zsh
fi

cat "${DOTFILES_DIR}"/crg.eti.br
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
set rtp+=~/.fzf

export PATH=~/bin:/usr/local/go/bin:~/Library/Python/3.8/bin:~/go/bin:$PATH

alias python=/usr/bin/python3

source "${DOTFILES_DIR}"/aliases.zsh 
source "${DOTFILES_DIR}"/aliases_dos.zsh 
source "${DOTFILES_DIR}"/aliases_mosh.zsh 
source "${DOTFILES_DIR}"/aliases_tmux.zsh


