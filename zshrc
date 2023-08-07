# Cesar's zshrc

setopt hist_ignore_all_dups


export DOTFILES_DIR="${HOME}/dotfiles"
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="crg"

if test -f "${HOME}/.prelocalrc"; then
    source "${HOME}/.prelocalrc"
fi

# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf)

source "${ZSH}/oh-my-zsh.sh"
source "${DOTFILES_DIR}/environment.zsh"

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"

    autoload -Uz compinit
    compinit
fi

source "${DOTFILES_DIR}/functions.zsh"

# GitHub
source "${DOTFILES_DIR}/functions_github.zsh"

# Golang
source "${DOTFILES_DIR}/functions_golang.zsh"

# tmux 
source "${DOTFILES_DIR}/functions_tmux.zsh"

# searX 
source "${DOTFILES_DIR}/functions_searX.zsh"

# Darwin only
if [[ "${OSTYPE}" == "darwin"* ]]; then
    source "${DOTFILES_DIR}/functions_darwin.zsh"
fi

cat "${DOTFILES_DIR}/crg.eti.br"

python_prefix=$(brew --prefix python)
export PATH=$python_prefix/bin:$PATH

#export GOROOT="$(brew --prefix golang)/libexec"
export GOROOT="/usr/local/go"
export PATH=$GOROOT/bin:~/go/bin:$PATH

export PATH=~/bin:$PATH

# alias python=/usr/bin/python3
alias python=$python_prefix/bin/python3

source "${DOTFILES_DIR}/aliases.zsh"
source "${DOTFILES_DIR}/aliases_dos.zsh"
source "${DOTFILES_DIR}/aliases_mosh.zsh" 
source "${DOTFILES_DIR}/aliases_tmux.zsh"

if test -f "${HOME}/.localrc"; then
    source "${HOME}/.localrc"
fi

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# https://www.npmjs.com/package/@githubnext/github-copilot-cli
eval "$(github-copilot-cli alias -- "$0")"

echo tty: $(tty)

