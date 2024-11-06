# get the operating system
function get_os() {
  case "$OSTYPE" in
    darwin*)
      echo "osx"
      ;;
    linux*)
      echo "linux"
      ;;
    *)
      echo "unknown"
      ;;
    esac
}

function urlencode() {
    echo $@|jq -sRr @uri
}

function pause {
  >/dev/tty printf '%s' "${*:-Press any key to continue... }"
  read -krs
  printf '\n'
}

function pause_and_capture {
  local message="${1:-Pressione uma tecla para continuar...}"
  >/dev/tty printf '%s' "$message"
  local key
  read -krs key
  >/dev/tty printf '\n'
  echo "$key"
}

function ww() {
    vi -c ':VimwikiIndex'
}


function wdd() {
    vi -c 'norm \w\w'
}

function rw() {
    local current_dir=$(pwd)
    builtin cd ~/Documents/wiki && rv $@
    builtin cd $current_dir
}

function fbr() {
    git for-each-ref --format='%(refname:short)' refs/heads| fzf | xargs git checkout
}


function delete-branches() {
  local branches_to_delete
  branches_to_delete=$(git branch | fzf --multi)

  [ -n "$branches_to_delete" ] && \
    git branch --delete --force $branches_to_delete
}

function checkout-branch() {
  local branches
  branches=$(git branch | fzf)

  [ -n "$branches" ] && \
    git checkout $branches
}

function colors256() {
        local c i j

        printf "Colors 0 to 15 for the standard 16 colors\n"
        for ((c = 0; c < 16; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n\n"

        printf "Colors 16 to 231 for 256 colors\n"
        for ((i = j = 0; c < 232; c++, i++)); do
                printf "|"
                ((i > 5 && (i = 0, ++j))) && printf " |"
                ((j > 5 && (j = 0, 1)))   && printf "\b \n|"
                printf "%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n\n"

        printf "Greyscale 232 to 255 for 256 colors\n"
        for ((; c < 256; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n"
}

function copyFromStdin() {
    if [[ -n $SSH_CLIENT ]]; then
        printf "\033]52;c;"
        base64
        printf "\a" #OSC52
    elif [[ "$(uname)" == "Darwin" ]]; then
        pbcopy
    elif [[ "$(uname)" == "Linux" ]]; then
        xclip -selection clipboard
    fi
}

function ei {
    local ext=$1
    if [ -z "$ext" ]; then
        ext="md"
    fi
    t="$(mktemp).$ext"
    touch $t
    # se a variavel EDITOR contem nvim
    if [[ $EDITOR == *"nvim"* ]]; then
        $EDITOR -c "startinsert" $t
    else
        $EDITOR $t
    fi
    copyFromStdin < $t
    rm -f $t
}

## Function to switch to the last window or session in tmux, if available
function exit_handler() {
  [ -z "$TMUX" ] && return

  local windows=($(tmux list-windows -F '#I'))
  if [ ${#windows[@]} -gt 1 ]; then
      tmux select-window -t ${windows[-2]}
      return
  fi

  local sessions=($(tmux list-sessions -F '#S'))
  if [ ${#sessions[@]} -gt 1 ]; then
      sessions=("${(@)sessions:#$(tmux display-message -p '#S')}")
      tmux switch-client -t ${sessions[-1]}
  fi
}

function history_list() {
  local selected
  selected=$(fc -rl 1 | \
      fzf \
        --height 60% \
        --prompt ": " \
        --ansi \
        --preview "sed 's/^ *[0-9]* *//' <<< {}" \
        --preview-window=down:3:wrap)

  [[ -n "$selected" ]] && \
      print -z $(echo "$selected" | sed 's/^ *[0-9]* *//')
}

function nuke() {
  local pid
  pid=$(ps -al | grep -v ^root | sed 1d | fzf -m | awk '{print $2}')

  [ -n "$pid" ] && \
      echo $pid | \
      xargs kill -9
}

