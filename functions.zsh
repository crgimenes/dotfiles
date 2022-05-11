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
