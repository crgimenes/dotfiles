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

###############################################################################
# GitHub
###############################################################################

# Opens the GitHub page of the current repository.
function og() {
    open $(git config remote.origin.url |
        sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
}


# Darwin only

if [[ "$OSTYPE" == "darwin"* ]]; then

###############################################################################
# Apple Music
###############################################################################

# Get the current track and artist from Apple Music
function plaing() {
    osascript -e 'tell application "Music" to return (name of current track) & " - " & (artist of current track)'
}

fi
