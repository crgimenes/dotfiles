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

function ww() {
    vi -c ':VimwikiIndex'
}


function wdd() {
    vim -c 'norm \w\w'
}

function wv() {
    cd ~/Documents/wiki
    rv $@
}

function fbr() {
    git for-each-ref --format='%(refname:short)' refs/heads| fzf | xargs git checkout
}


function delete-branches() {
  local branches_to_delete
  branches_to_delete=$(git branch | fzf --multi)

  if [ -n "$branches_to_delete" ]; then 
    git branch --delete --force $branches_to_delete
  fi
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

