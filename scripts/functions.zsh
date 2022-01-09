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


# GitHub
source ./functions_github.zsh

# tmux 
source ./functions_tmux.zsh

# Darwin only
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ./functions_darwin.zsh
fi
