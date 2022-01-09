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


DIR="${0%/*}"


# GitHub
source ${DIR}/functions_github.zsh

# tmux 
source ${DIR}/functions_tmux.zsh

# Darwin only
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ${DIR}/functions_darwin.zsh
fi
