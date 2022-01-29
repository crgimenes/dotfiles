# Cesar's zshrc

export DOTFILES_DIR="${HOME}/dotfiles"
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="crg"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf)

source "${ZSH}/oh-my-zsh.sh"
source "${DOTFILES_DIR}/environment.zsh"

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"

    autoload -Uz compinit
    compinit
fi

# GitHub
source "${DOTFILES_DIR}/functions_github.zsh"

# Golang
source "${DOTFILES_DIR}/functions_golang.zsh"

# tmux 
source "${DOTFILES_DIR}/functions_tmux.zsh"

# Darwin only
if [[ "${OSTYPE}" == "darwin"* ]]; then
    source "${DOTFILES_DIR}/functions_darwin.zsh"
fi

cat "${DOTFILES_DIR}/crg.eti.br"

export PATH=~/bin:/usr/local/go/bin:~/go/bin:$PATH

alias python=/usr/bin/python3

source "${DOTFILES_DIR}/aliases.zsh"
source "${DOTFILES_DIR}/aliases_dos.zsh"
source "${DOTFILES_DIR}/aliases_mosh.zsh" 
source "${DOTFILES_DIR}/aliases_tmux.zsh"

if test -f "${HOME}/.localrc"; then
    source "${HOME}/.localrc"
fi

