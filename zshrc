# Cesar's zshrc

setopt hist_ignore_all_dups


export DOTFILES_DIR="${HOME}/dotfiles"
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="crg"

test -f "${HOME}/.prelocalrc" && source "${HOME}/.prelocalrc"

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
[[ "${OSTYPE}" == "darwin"* ]] && source "${DOTFILES_DIR}/functions_darwin.zsh"

##################################################
# Print banner
##################################################
#[[ $(tput cols) -gt 68 ]]; then
#    cat "${DOTFILES_DIR}/ansi/crg.eti.br"
#else
#    cat "${DOTFILES_DIR}/ansi/crg.eti.br.small"
#fi


[[ $(tput cols) -gt 68 ]] && \
    cat "${DOTFILES_DIR}/ansi/crg.eti.br" || \
    cat "${DOTFILES_DIR}/ansi/crg.eti.br.small"


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

test -f "${HOME}/.localrc" && source "${HOME}/.localrc"

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

test -e "${HOME}/.iterm2_shell_integration.zsh" && \
    source "${HOME}/.iterm2_shell_integration.zsh"

# https://www.npmjs.com/package/@githubnext/github-copilot-cli
# eval "$(github-copilot-cli alias -- "$0")"

test -f "$HOME/Projects/scripts/config.sh" && \
    source "$HOME/Projects/scripts/config.sh"

echo tty: $(tty)


