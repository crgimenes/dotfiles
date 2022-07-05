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

#function delete-branches() {
#  git branch |
#    grep --invert-match '\*' |
#    cut -c 3- |
#    fzf --multi --preview="git log {} --" |
#    xargs --no-run-if-empty git branch --delete --force
#}


