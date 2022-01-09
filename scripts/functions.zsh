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


